#!/bin/bash
# The entry point stays run.sh; the logic is run.py, which needs to be ONE
# process rather than three per spec. See run.py's docstring for why.
#
# THE PIN IS APPLIED HERE, IN BASH, so that nothing downstream has to import
# Python to learn which checkout this port compiles against. `pins.tsv` is the
# one place it is written; SAFARI_COBBLESTONE overrides it, and CODEX_ROOT is
# deliberately NOT consulted -- this box exports one globally, pointing at a
# different tree, and letting it win is the exact bug pins.py was written for.
set -uo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
pin="${SAFARI_COBBLESTONE:-$(sed 's/#.*//' "$root/pins.tsv" | awk '$1=="cobblestone"{print $2}')}"
export CODEX_ROOT="${pin/#\~/$HOME}"
[ -f "$CODEX_ROOT/codex/compiler/opening.codex" ] || {
    echo "pins.tsv gives $CODEX_ROOT, which is not a Cobblestone checkout" >&2; exit 2; }
exec python3 "$root/spec/run.py" "$@"

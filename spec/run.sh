#!/bin/bash
# The entry point stays run.sh; the logic is run.py, which needs to be ONE
# process rather than three per spec. See run.py's docstring for why.
#
# THE PIN IS DERIVED, IN BASH, so nothing downstream has to import Python to
# learn which checkout the arms compile against. It is NOT a safari pin: the
# borrowed transpilers record the checkout they were built from, and
# harness/cobblestone_pin.py reads it and refuses if they disagree.
# SAFARI_COBBLESTONE overrides it explicitly; ambient CODEX_ROOT is deliberately
# NOT consulted -- this box exports one globally, pointing at a different tree.
set -uo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CODEX_ROOT="$(python3 "$root/harness/cobblestone_pin.py")" || exit 2
export CODEX_ROOT
exec python3 -u "$root/spec/run.py" "$@"

#!/bin/bash
# Two bundlers, this project's targets: do they agree byte for byte?
#
#   ./harness/bundle_gate.sh
#
# The ladder's `bundle_gate.sh` asks this of the corpus. This asks it of what
# safari actually builds -- every spec and every judge check -- because those go
# through quires upstream has never heard of (`quires.tsv`) and the corpus gate
# never exercises that path.
#
# A difference is a FINDING until someone shows it is a bug in the Rust arm. It
# is never a reason to go back to one bundler for everything: a bundling bug
# applied identically to all four arms is one no comparison between them finds.
set -uo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$root"
pin="${SAFARI_COBBLESTONE:-$(sed 's/#.*//' pins.tsv | awk '$1=="cobblestone"{print $2}')}"
export CODEX_ROOT="${pin/#\~/$HOME}"
BUNDLE="${CODEXBUNDLE:-${CARGO_TARGET_DIR:-$HOME/build/rust-target}/release/bundle}"
[ -x "$BUNDLE" ] || { echo "no bundle binary at $BUNDLE; set CODEXBUNDLE" >&2; exit 2; }

tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
same=0; differ=0
for s in spec/*Spec.codex judge/*Check.codex; do
    name="$(basename "$s" .codex)"
    "$BUNDLE" one "$s" "$tmp/r.codex" 2>/dev/null || { echo "$name: Rust refused"; differ=$((differ+1)); continue; }
    python3 harness/bundle.py "$s" "$tmp/p.codex" >/dev/null 2>&1 || { echo "$name: Python refused"; differ=$((differ+1)); continue; }
    if cmp -s "$tmp/r.codex" "$tmp/p.codex"; then
        same=$((same+1))
    else
        differ=$((differ+1))
        echo "$name:"; diff "$tmp/r.codex" "$tmp/p.codex" | head -6
    fi
done
echo
echo "$same identical, $differ differ"
[ "$differ" = 0 ] || exit 1

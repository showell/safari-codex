#!/usr/bin/env bash
# Make sure OUR codexzig is built and current, and print its path.
#
#     eval codexzig=$(./harness/build_codexzig.sh)     # or just read the path
#
# THE TRANSPILER IS BUILT BY ITS OWN PROJECT, IN A WORKTREE THIS ONE OWNS.
# codex-zig-transpiler/build.py is nine stages, three of them guests, and it ends
# by checking the fixed point -- the emitter emitting the same bytes for its own
# source under QEMU and as the native binary it produced. Copying the generated
# zig here and running `zig build-exe` on it would get a working binary while
# skipping the check that says it is the right one.
#
# The worktree is the whole point: `codexzig-safari` is not the transpiler's
# active line, so nothing this project runs on can be rebuilt out from under it
# by work happening next door. Same for the Cobblestone it is built from.
# pins.tsv names all three trees and PROVENANCE.md explains them.
#
# This script does NOT run build.py on the happy path. build.py's own guard is
# content-addressed -- generated/local/codexzig.fp holds the sha of the zig the
# binary was built from -- so the check is a hash and a comparison, and the
# seconds a fixed-point re-check would cost do not belong in a sweep that runs
# it once per module.
set -euo pipefail
pin=$(sed 's/#.*//' "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/pins.tsv" | awk '$1=="codexzig"{print $2}')
tree="${CODEXZIG_TREE:-${pin/#\~/$HOME}}"
bin="$tree/generated/local/codexzig"
src="$tree/generated/codexzig.qemu.zig"

# SET BUT EMPTY IS A FAILURE, NOT AN ABSENCE. The documented way to test a
# candidate is `CODEXZIG=$(./harness/build_codexzig_try.sh) ./harness/run.sh`,
# and when that build fails the substitution leaves CODEXZIG empty -- which read
# as "no override" and ran the whole sweep on the BASE transpiler, printing
# GREEN about a candidate that was never built. Refusing here is the only place
# that catches it for every arm at once.
if [ "${CODEXZIG+set}" = set ] && [ -z "$CODEXZIG" ]; then
    echo "CODEXZIG is set but EMPTY -- a candidate build failed; refusing to" >&2
    echo "fall back to the base transpiler and report on the wrong binary." >&2
    exit 1
fi
if [ -n "${CODEXZIG:-}" ]; then          # an explicit override answers for itself
    printf '%s' "$CODEXZIG"; exit 0
fi
[ -d "$tree" ] || { echo "no transpiler worktree at $tree (see PROVENANCE.md)" >&2; exit 1; }
want=$(sha256sum "$src" | awk '{print $1}')
if [ ! -x "$bin" ] || [ "$(cat "$tree/generated/local/codexzig.fp" 2>/dev/null)" != "$want" ]; then
    echo "codexzig is missing or stale in $tree; building it there" >&2
    ( cd "$tree" && COBBLESTONE_ROOT="${COBBLESTONE_ROOT:-$HOME/showell_repos/cobblestone-safari}" \
        python3 -u build.py ) >&2
fi
printf '%s' "$bin"

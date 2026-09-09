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
# THE PIN NAMES THE TRANSPILER'S OWN TREE. It used to name a private worktree of
# it, so that work next door could not rebuild this out from under a run. What
# that bought was a silently stale oracle -- on 2026-09-06 the worktree still
# held a binary built from `cc6eab7e` while the language pin had moved -- and the
# fingerprint check below is the thing that was actually doing the protecting.
# pins.tsv names the two transpiler trees; PROVENANCE.md explains them, and every
# run's own PROVENANCE records the path and size that ran.
#
# THIS SCRIPT NEVER BUILDS -- it checks the fingerprint and REFUSES if stale,
# exactly as build_codexwasm.sh does, and for the same reason: building belongs
# to the project that owns it, and a build starting on its own is a cost the
# caller did not ask for. safari borrows this binary; it does not make it. The
# guard is content-addressed -- generated/local/codexzig.fp holds the sha of the
# zig the binary was built from -- so the check is a hash and a comparison.
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
    echo "codexzig is missing or stale in $tree." >&2
    echo "Build it THERE -- \`cd $tree && python3 build.py\` -- and re-run." >&2
    exit 1
fi
printf '%s' "$bin"

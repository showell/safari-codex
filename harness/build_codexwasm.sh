#!/usr/bin/env bash
# Resolve the pinned codexwasm -- Codex source in, WAT out -- and print its path.
#
#     eval codexwasm=$(./harness/build_codexwasm.sh)     # or just read the path
#
# THIS PROJECT NO LONGER BUILDS A WASM TRANSPILER AND SHOULD NOT. It used to:
# bundle the compiler's front end with plugs/wasm's emitter using the LADDER's
# chapter list, hand that to codexzig, and build the zig it emitted -- ninety
# seconds, three host-side steps, and a copy of `harness/CodexWasmHarness.codex`
# that had to be kept in step with every Update.
#
# ALL THREE REASONS THAT WAS RIGHT HAVE EXPIRED, and they expired within a week:
#
#   * codex-wasm-transpiler exists and IS this program. Its whole job is to be a
#     fixed point -- the emitter emitting the same bytes for its own source on
#     two roads -- which is a stronger claim about the binary than this project
#     was ever making about the one it built.
#   * the LADDER is deprecated. It supplied the chapter list, and when it moved
#     `ast/` to `src/` this script broke with a path error. The next move will
#     not announce itself either.
#   * U55 SPLIT THE DRIVER. `harness/CodexWasmHarness.codex` walked the compiler's
#     phases by hand, so it stopped compiling at U55 with `CDX2001 Type mismatch:
#     Rec:IRChapter vs Fun`. codex-wasm-transpiler's own harness was already
#     fixed to call `compile-frontend-cdx` -- which is the standing rule, and
#     keeping a second harness here means learning that lesson twice.
#
# So the binary is PINNED, exactly as the language and the zig transpiler are:
# a worktree on our own branch that nothing next door can rebuild under us.
# pins.tsv names it. This script checks the fingerprint and REFUSES if it is
# stale rather than building -- building belongs to the project that owns it,
# and a build starting on its own is a cost the caller did not ask for.
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# SET BUT EMPTY IS A FAILURE, NOT AN ABSENCE -- the same guard build_codexzig.sh
# carries, and for the same incident: a failed candidate build leaves the
# substitution empty, which reads as "no override" and reports on the wrong
# binary.
if [ "${CODEXWASM+set}" = set ] && [ -z "$CODEXWASM" ]; then
    echo "CODEXWASM is set but EMPTY -- a candidate build failed; refusing to" >&2
    echo "fall back to the pinned transpiler and report on the wrong binary." >&2
    exit 1
fi
if [ -n "${CODEXWASM:-}" ]; then         # an explicit override answers for itself
    printf '%s' "$CODEXWASM"; exit 0
fi

pin=$(sed 's/#.*//' "$root/pins.tsv" | awk '$1=="codexwasm"{print $2}')
tree="${SAFARI_CODEXWASM:-${pin/#\~/$HOME}}"
[ -d "$tree" ] || { echo "no wasm transpiler worktree at $tree (see PROVENANCE.md)" >&2; exit 1; }

# THE GUARD READS THE TRACKED SUBJECT, which is what makes it work in a fresh
# worktree. build.py's fingerprint is one sha per input, newline-joined, and the
# FIRST of them is `generated/codexwasm-subject.codex` -- the bundle the binary
# was transpiled from, and the only one of its inputs git carries. So this
# compares that line and no other: it catches a binary swapped out from under
# its subject, and a subject re-bundled without a rebuild.
bin="$tree/generated/local/codexwasm"
src="$tree/generated/codexwasm-subject.codex"
[ -f "$src" ] || { echo "no $src -- is $tree a codex-wasm-transpiler checkout?" >&2; exit 1; }
want=$(sha256sum "$src" | awk '{print $1}')
if [ ! -x "$bin" ] || [ "$(head -1 "$tree/generated/local/codexwasm.fp" 2>/dev/null)" != "$want" ]; then
    echo "codexwasm is missing or stale in $tree." >&2
    echo "Build it THERE -- \`cd $tree && python3 build.py\` -- and re-run." >&2
    exit 1
fi
printf '%s' "$bin"

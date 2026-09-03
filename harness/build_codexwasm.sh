#!/usr/bin/env bash
# Build build/codexwasm: Codex source in, WAT out, one native binary, NO GUEST.
#
#     ./harness/build_codexwasm.sh [--force]
#
# THE TRICK IS THAT WE ALREADY HAVE A NATIVE CODEX COMPILER. `codexzig` is
# Codex source in, zig out, and it runs on this host. So the wasm transpiler
# does not need the seed at all: bundle the compiler's front end with
# plugs/wasm's emitter, hand that bundle to codexzig, and build the zig it
# emits. Three host-side steps, about ninety seconds, and no QEMU anywhere.
#
# That is the whole point. `harness/wasm_arm.py` costs two guests a module and
# has to queue behind every other job on this box; `harness/wasm_arm.py --native`
# costs seconds and queues behind nothing.
#
# WHAT IT IS NOT: a second opinion. The guest arm's right-hand road runs the
# emitter on BARE METAL under the seed's own x86; this one runs it as zig
# compiled by codexzig. Same emitter, same IR, different machine underneath --
# so agreement between the two is worth having and is checked by
# `--native --both`, but the native arm cannot replace the guest one as
# evidence about the seed.
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$root"
# SET, not defaulted: CODEX_ROOT is exported in this box's login environment,
# so `${CODEX_ROOT:=...}` reads as a pin and is not one. harness/pins.py has
# the incident. SAFARI_COBBLESTONE is the override nothing else exports.
export CODEX_ROOT="${SAFARI_COBBLESTONE:-$HOME/showell_repos/cobblestone-safari}"
ladder="${SAFARI_LADDER:-$HOME/showell_repos/codex-zig-ladder}"
zig="${ZIG:-$HOME/zig-0.16.0/zig}"
codexzig="$("$root/harness/build_codexzig.sh")"
mkdir -p build

subject=build/codexwasm-subject.codex
# The chapter list is the LADDER'S, called rather than restated. It is the
# compiler front end plus the IR passes -- twenty-odd chapters with three
# section drops among them -- and a second copy here would be a second thing to
# keep in step with an Update. `-Harness` and `-OutName` are joined to the
# ladder's own ast/ directory, so both are given relative to it and nothing is
# written into that tree.
[ -f "$ladder/ast/bundle_codexir.ps1" ] || { echo "no $ladder/ast/bundle_codexir.ps1; set SAFARI_LADDER" >&2; exit 1; }
# THE WAY BACK TO THIS CHECKOUT, COMPUTED AND NOT ASSUMED. It was the literal
# `../../safari-codex` until 2026-09-03, which is the path of ONE checkout: run
# from a git worktree or a second clone, the bundler resolved that against the
# ladder's ast/ and wrote this tree's subject into the OTHER tree, then failed
# here because the file it had just written was not where it was looking. A
# hardcoded sibling path is a cross-tree write waiting for a second checkout,
# and the sandbox rules exist to stop exactly that.
back=$(python3 -c 'import os,sys; print(os.path.relpath(sys.argv[1], sys.argv[2]))' "$root" "$ladder/ast")
# -Command and not -File: `-MoreChapters` is a [string[]], and under -File every
# argument arrives as one string -- a comma-joined pair binds as a single
# element and the bundler then looks for a chapter whose name contains a comma.
~/.local/pwsh/pwsh -NoProfile -Command "
& '$ladder/ast/bundle_codexir.ps1' \
    -Harness '$back/harness/CodexWasmHarness.codex' \
    -OutName '$back/$subject' \
    -PlugName 'codexwasm-subject' \
    -MoreChapters @('codex/plugs/common/IRTextParser.codex','codex/plugs/wasm/WasmEmitter.codex')
" | tail -1 >&2

# The key covers the CODEXZIG as well as the bundle, because the binary is a
# function of both: rebuild the base transpiler underneath this and a key on the
# bundle alone hands back a stale codexwasm saying it already matches -- in the
# one situation where it is most likely to be wrong. Same fix as 02a90f6 in
# build_codexzig_try.sh, found by the review of that commit; $codexzig is
# already resolved above.
want=$( { sha256sum "$subject"; sha256sum "$codexzig"; } | sha256sum | awk '{print $1}')
if [ "${1:-}" != "--force" ] && [ -x build/codexwasm ] \
   && [ "$(cat build/codexwasm.fp 2>/dev/null)" = "$want" ]; then
    echo "build/codexwasm already matches this bundle and this codexzig (${want:0:12}) -- not rebuilding" >&2
    printf '%s' "$root/build/codexwasm"; exit 0
fi

echo "transpiling $(wc -c < "$subject") bytes of compiler+emitter through codexzig..." >&2
# codexzig writes the PROGRAM to stderr and its diagnostics to stdout. A halt
# writes the reason to stderr too, so the output is short and non-empty rather
# than empty -- which is why the marker is checked and not the file size.
"$codexzig" < "$subject" 2> build/codexwasm.zig > build/codexwasm.diag || true
if ! grep -q "^// THE PRELUDE" build/codexwasm.zig; then
    echo "codexzig emitted no program:" >&2; head -3 build/codexwasm.zig >&2; exit 1
fi
echo "building build/codexwasm ($(wc -c < build/codexwasm.zig) bytes of zig)..." >&2
( cd build && "$zig" build-exe codexwasm.zig -femit-bin=codexwasm )
printf '%s' "$want" > build/codexwasm.fp
echo "build/codexwasm: $(wc -c < build/codexwasm) bytes" >&2
printf '%s' "$root/build/codexwasm"

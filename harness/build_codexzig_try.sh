#!/usr/bin/env bash
# Build a CANDIDATE codexzig from the current emitter, with NO GUEST, and print
# its path.
#
#     eval codexzig=$(./harness/build_codexzig_try.sh)
#     CODEXZIG=$(./harness/build_codexzig_try.sh) ./harness/run.sh
#
# THIS IS NOT `build_codexzig.sh` AND MUST NOT BE CONFUSED WITH IT. That one is
# the door to the transpiler's own `build.py`, which is nine stages, three of
# them QEMU guests, and ends by checking the FIXED POINT -- the emitter emitting
# the same bytes for its own source under QEMU and as the binary it produced.
# This one skips all of that. What it produces is a binary that is probably
# right, built in about a minute, for finding out whether an emitter edit is
# worth spending guests on.
#
# It is build.py's stages 3, 7 and 6, which are the three that are host-only:
#
#     3  bundle the transpiler   compiler + emitter + harness   pwsh
#     7  transpile it            with the codexzig we ALREADY have
#     6  build the binary        zig build-exe
#
# The bootstrap is why that works: the existing native codexzig is a Codex->zig
# compiler, so it can compile a transpiler containing a NEWER emitter without
# anyone booting anything. What it cannot do is tell you the result is a fixed
# point, because the binary it produced was never checked against the seed's own
# x86 road. Run `build.py` for that, and read its answer as the real one.
#
# CODEXZIG is an explicit override that harness/build_codexzig.sh returns
# unchanged, so every arm in this project -- run.sh, wasm_arm.py, plug_probe.py,
# mem_probe.py -- takes the candidate by setting one variable.
#
# THE CANDIDATE IS BUILT INTO A TREE-SHAPED DIRECTORY, and that is not tidiness.
# run.sh folds the TRANSPILER'S OWN SOURCE into each module's stamp key, by
# reading `$(dirname $codexzig)/../codexzig.qemu.zig` -- which is what makes a
# sweep notice that the compiler changed and not just the chapter. A candidate
# dropped anywhere else has no such file and run.sh dies rather than silently
# skipping, which is the right way round. So the candidate goes to
# build/codexzig-try/generated/local/codexzig with its zig one level up, and the
# gate keeps working with nothing edited in it.
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$root"
export CODEX_ROOT="${SAFARI_COBBLESTONE:-$HOME/showell_repos/cobblestone-safari}"
export COBBLESTONE_ROOT="$CODEX_ROOT"
tree="${CODEXZIG_TREE:-$HOME/showell_repos/codexzig-safari}"
zig="${ZIG:-$HOME/zig-0.16.0/zig}"
mkdir -p build

# The bundler is the transpiler's own, run from its own source/ directory, so
# the chapter list and the foreword cite resolution are that project's and not a
# copy here that would drift. build.py:175 does the same three things.
subject=build/codexzig-try-subject.codex
~/.local/pwsh/pwsh -NoProfile -File "$tree/source/bundle_codexzig.ps1" \
    -OutFile "$root/$subject" 2>&1 | tail -1 >&2

out=build/codexzig-try/generated
mkdir -p "$out/local"

# The transpiler that compiles the candidate is the CURRENT one, deliberately:
# what is being tested is the emitter's OUTPUT, so the compiler producing the
# candidate should be the known-good binary and not the candidate itself.
#
# It is RESOLVED BEFORE the freshness check and folded into the key, because the
# candidate is a function of both. Keying on the bundle alone -- which this did
# until a review caught it -- hands back a stale binary saying "already matches
# this bundle" after the base codexzig has been rebuilt underneath it, which is
# the one situation where a candidate is most likely to be wrong.
codexzig="$("$root/harness/build_codexzig.sh")"
want=$( { sha256sum "$subject"; sha256sum "$codexzig"; } | sha256sum | awk '{print $1}')
if [ "${1:-}" != "--force" ] && [ -x "$out/local/codexzig" ] \
   && [ "$(cat "$out/local/codexzig.fp" 2>/dev/null)" = "$want" ]; then
    echo "the candidate already matches this bundle and this codexzig (${want:0:12})" >&2
    printf '%s' "$root/$out/local/codexzig"; exit 0
fi
echo "transpiling $(wc -c < "$subject") bytes with $codexzig..." >&2
"$codexzig" < "$subject" 2> "$out/codexzig.qemu.zig" > "$out/local/codexzig.diag" || true
if ! grep -q "^// THE PRELUDE" "$out/codexzig.qemu.zig"; then
    echo "codexzig emitted no program:" >&2; head -3 "$out/codexzig.qemu.zig" >&2; exit 1
fi
echo "building the candidate ($(wc -c < "$out/codexzig.qemu.zig") bytes of zig)..." >&2
( cd "$out/local" && "$zig" build-exe ../codexzig.qemu.zig -femit-bin=codexzig )
printf '%s' "$want" > "$out/local/codexzig.fp"
echo "candidate: $(wc -c < "$out/local/codexzig") bytes" >&2
printf '%s' "$root/$out/local/codexzig"

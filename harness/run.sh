#!/usr/bin/env bash
# Run every check in judge/, end to end: gold, bundle, transpile, build, grade.
#
# The four steps NOTES calls the loop, wired once so that adding a module means
# adding files, never editing this script. A check is judge/<Chapter>Check.codex;
# its oracle is probe/probe_<chapter_in_snake_case>.zig, named after the game file
# it imports; its gold is gold/<Chapter>Gold.codex, regenerated every run.
#
# Nothing here boots a guest. The whole sweep is native and takes seconds, which
# is why the gold is rebuilt from the zig every time rather than cached.
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
root="$(dirname "$here")"
cd "$root"

: "${CODEX_ROOT:=$HOME/showell_repos/NewRepository}"
export CODEX_ROOT
zig="${ZIG:-$HOME/zig-0.16.0/zig}"
codexzig="${CODEXZIG:-$HOME/showell_repos/codex-zig-transpiler/generated/local/codexzig}"

for tool in "$zig" "$codexzig"; do
  [ -x "$tool" ] || { echo "missing tool: $tool" >&2; exit 1; }
done
mkdir -p build gold

# One chapter name (or several) runs just those; no arguments runs the lot. The
# `$# -gt 0` guard is needed under `set -u`.
if [ $# -gt 0 ]; then
  checks=()
  for a in "$@"; do
    c="judge/${a}Check.codex"
    [ -e "$c" ] || { echo "no judge/${a}Check.codex" >&2; exit 1; }
    checks+=("$c")
  done
else
  checks=(judge/*Check.codex)
  [ -e "${checks[0]}" ] || { echo "no checks in judge/" >&2; exit 1; }
fi

fail=0
for check in "${checks[@]}"; do
  base="$(basename "$check" Check.codex)"
  # GuardRail -> guard_rail, matching wasm/guard_rail.zig. Pond stays pond.
  # harness/names.py owns this rule; the sed that used to live here was a fourth
  # copy of it and disagreed with the python on consecutive capitals.
  mod="$(python3 harness/names.py "$base")"

  # SKIP WHAT HAS NOT CHANGED. Every step below is deterministic -- the transpiler
  # is byte-stable and so is each probe's output -- so a content hash is a sound
  # key. Two stamps, because the two halves have different inputs.
  #
  # The gold's inputs are its probe and the game sources it imports. Rather than
  # work out the transitive import set, over-approximate with the whole wasm
  # directory; it is under a megabyte and hashes in milliseconds.
  #
  # THE GOLD'S OWN HASH IS PART OF ITS KEY, and that is the load-bearing detail.
  # It is what keeps README's promise that a stale or hand-edited gold cannot
  # survive one run: edit gold/ by hand and the key no longer matches, so the next
  # sweep regenerates it from the zig. Leave the gold out of the key and this
  # optimisation would quietly turn a generated file into an editable one.
  # `|| true` because a NEW module has no gold yet: cat fails, pipefail propagates
  # it, and set -e killed the whole sweep with no message at all. Adding a module
  # must not be able to do that -- a missing gold simply means the key cannot
  # match, which is exactly the "regenerate it" answer we want.
  gold_key="$( { cat "probe/probe_$mod.zig" probe/wasm/*.zig "gold/${base}Gold.codex" 2>/dev/null || true; } | sha256sum )"
  if [ "$gold_key" != "$(cat "build/$mod.goldstamp" 2>/dev/null)" ]; then
    python3 harness/gen_gold.py "$base" >/dev/null
    cat "probe/probe_$mod.zig" probe/wasm/*.zig "gold/${base}Gold.codex" | sha256sum > "build/$mod.goldstamp"
  fi

  # Bundling is 50 ms and its output IS the transitive closure of every `cites`
  # edge -- the port chapters, Grade, the gold just written, and the foreword
  # chapters that live outside this repo -- so hashing the unit covers all of them
  # and there is no dependency list to keep in step. Always bundle; skip the two
  # slow steps after it. run.sh is in the key so changing a build flag rebuilds,
  # and the transpiler by size+mtime, which is enough for a locally built tool.
  python3 harness/bundle.py "$check" "build/$mod-unit.codex"
  key="$( { cat "build/$mod-unit.codex" harness/run.sh; stat -c '%s %Y' "$codexzig"; } | sha256sum )"
  # The binaries are gitignored, so a fresh clone has a stamp-less build to do.
  if [ "$key" != "$(cat "build/$mod.stamp" 2>/dev/null)" ] || [ ! -x "build/$mod" ]; then
    # A FAILED BUILD MUST NOT LEAVE SOMETHING THAT LOOKS CURRENT. The binary and
    # the stamp go FIRST, so that whatever happens below, the next run rebuilds
    # rather than trusting wreckage. Without this: a build fails, `set -e` exits
    # before the stamp is rewritten, the source is then restored to what the OLD
    # stamp describes -- and the key matches again while build/<mod> is the corrupt
    # output of the failed run. The sweep then executes it. Measured 2026-08-30:
    # `./harness/run.sh` printed `--- Mountains ---` and exited, silently, because
    # build/mountains was 5,547 bytes of nothing and `Exec format error` went to a
    # captured stream nobody printed.
    rm -f "build/$mod" "build/$mod.stamp"
    "$codexzig" < "build/$mod-unit.codex" 2> "build/$mod.zig" > "build/$mod.diag"
    # THE SAME GATE spike.sh AND build_wasm.sh ALREADY HAD, and this was the only
    # build path without it. codexzig writes the program to stderr and diagnostics
    # to stdout, so a refusal leaves a SHORT NON-EMPTY .zig -- the halt message
    # itself -- which a plain -s test calls success and zig then compiles into
    # something that is not a program.
    grep -q "^// THE PRELUDE" "build/$mod.zig" || {
      echo "codexzig emitted no program for $base:" >&2
      head -1 "build/$mod.zig" >&2
      head -3 "build/$mod.diag" >&2
      exit 1
    }
    # DEBUG, like the probe, and the saving is not what it first looked like.
    # ReleaseFast costs ~23 s here against Debug's ~0.85 s, but that is NOT the
    # Codex prelude being optimised: a TWO-LINE program whose whole body is one
    # std.debug.print costs the same 23 s. It is LLVM compiling zig's own
    # formatting machinery, on a two-core box, and it is flat in our code size --
    # 1,200 extra lines of generated Codex cost 0.05 s. Nothing here is a
    # benchmark, and Debug additionally turns ON zig's safety checks, which is
    # what a correctness harness wants. PORTING_NOTES C9.
    ( cd build && "$zig" build-exe "$mod.zig" )
    printf '%s' "$key" > "build/$mod.stamp"
  fi

  echo "--- $base ---"
  # ALWAYS RUN, even when nothing was rebuilt. It costs under two seconds for the
  # whole sweep and it is what keeps the output identical and the silence check
  # below honest.
  # The graded program writes to stderr (std.debug.print), so that is what is read.
  out="$( cd build && "./$mod" 2>&1 )"
  echo "$out"
  if grep -q BAD <<<"$out"; then fail=1; fi
  # A check that printed nothing is a check that did not run; silence must not pass.
  [ -n "$out" ] || { echo "$base printed nothing" >&2; fail=1; }
done

echo
if [ "$fail" -ne 0 ]; then echo "RED"; exit 1; fi
echo "GREEN"

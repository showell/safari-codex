#!/usr/bin/env bash
# Run every check in judge/, end to end: gold, bundle, transpile, build, grade.
#
# The four steps NOTES calls the loop, wired once so that adding a module means
# adding files, never editing this script. A check is judge/<Module>Check.codex;
# its oracle is probe/probe_<module>.zig; its gold is regenerated every run.
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

fail=0
for check in judge/*Check.codex; do
  [ -e "$check" ] || { echo "no checks in judge/" >&2; exit 1; }
  base="$(basename "$check" Check.codex)"
  mod="$(echo "$base" | tr '[:upper:]' '[:lower:]')"

  python3 harness/gen_gold.py "$mod" >/dev/null
  python3 harness/bundle.py "$check" "build/$mod-unit.codex"
  "$codexzig" < "build/$mod-unit.codex" 2> "build/$mod.zig" > "build/$mod.diag"
  ( cd build && "$zig" build-exe "$mod.zig" -O ReleaseFast )

  echo "--- $base ---"
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

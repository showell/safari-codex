#!/usr/bin/env bash
# SPIKE ONLY. THROWAWAY TOOLING, not part of the verification loop -- run.sh does
# not call this and nothing here is graded. It builds poc/SpikeMain and renders
# each of its viewpoints to an SVG you can open in a browser.
#
#     ./harness/spike.sh && open http://localhost:9200/spikes/
set -euo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$(dirname "$here")"
: "${CODEX_ROOT:=$HOME/showell_repos/NewRepository}"
export CODEX_ROOT
zig="${ZIG:-$HOME/zig-0.16.0/zig}"
codexzig="${CODEXZIG:-$HOME/showell_repos/codex-zig-transpiler/generated/local/codexzig}"
# ONE BINARY PER GROUP OF VIEWPOINTS, and the reason is the bump heap rather than
# taste: the prelude never reclaims (PORTING_NOTES C6) and a native binary has no
# arena rewind, so every frame a process prints is still held when it prints the
# next. Six viewpoints came to within 1.8 KB of the 4 GiB reserve. A second process
# starts fresh, which is the whole trick.
for pair in SpikeMain:spike SpikeTruckMain:spike_truck; do
  entry="${pair%%:*}"; out="${pair##*:}"
  python3 harness/bundle.py "poc/$entry.codex" "build/$out-unit.codex"
  "$codexzig" < "build/$out-unit.codex" 2> "build/$out.zig" > "build/$out.diag"
  grep -q "^// THE PRELUDE" "build/$out.zig" || { echo "codexzig emitted no program for $entry:" >&2; head -3 "build/$out.diag" >&2; exit 1; }
  ( cd build && "$zig" build-exe "$out.zig" )
done
python3 harness/spike_svg.py spike spike_truck

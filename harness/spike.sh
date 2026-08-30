#!/usr/bin/env bash
# SPIKE ONLY. THROWAWAY TOOLING, not part of the verification loop -- run.sh does
# not call this and nothing here is graded. It builds the poc spike entries and
# renders each of their viewpoints to an SVG you can open in a browser.
#
#     ./harness/spike.sh && open http://localhost:9200/spikes/
set -euo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$(dirname "$here")"
: "${CODEX_ROOT:=$HOME/showell_repos/NewRepository}"
export CODEX_ROOT
zig="${ZIG:-$HOME/zig-0.16.0/zig}"
codexzig="${CODEXZIG:-$HOME/showell_repos/codex-zig-transpiler/generated/local/codexzig}"
# ONE BINARY PER PAIR OF VIEWPOINTS, and the reason is the bump heap rather than
# taste: the prelude never reclaims (PORTING_NOTES C6) and neither arm rewinds an
# arena, so every frame a run prints is still held when it prints the next. Six
# fit a native process's 4 GiB reserve; only five fit the QEMU guest's 3072 MB,
# and the guest is the arm that compares VALUES (`./harness/metal.py --entry`).
# Two per entry is what BOTH arms hold, so the pairing is the guest's number.
# This list is the one place it is written down -- metal.py takes entries by name.
entries=(SpikeProfileMain SpikeMain SpikePondMain SpikeCatMain SpikeTruckMain)
mods=()
for entry in "${entries[@]}"; do
  # SpikePondMain -> spike_pond_main. harness/names.py owns the rule, so this and
  # metal.py cannot drift into naming different build/ artifacts.
  out="$(python3 harness/names.py "$entry")"
  mods+=("$out")
  python3 harness/bundle.py "poc/$entry.codex" "build/$out-unit.codex"
  "$codexzig" < "build/$out-unit.codex" 2> "build/$out.zig" > "build/$out.diag"
  grep -q "^// THE PRELUDE" "build/$out.zig" || { echo "codexzig emitted no program for $entry:" >&2; head -3 "build/$out.diag" >&2; exit 1; }
  ( cd build && "$zig" build-exe "$out.zig" )
done
python3 harness/spike_svg.py "${mods[@]}"

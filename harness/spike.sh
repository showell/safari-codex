#!/usr/bin/env bash
# SPIKE ONLY. THROWAWAY TOOLING, not part of the verification loop -- run.sh does
# not call this and nothing here is graded. It builds the poc spike entries and
# renders each of their viewpoints to an SVG you can open in a browser.
#
#     ./harness/spike.sh && open http://localhost:9200/spikes/
set -euo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$(dirname "$here")"
# SET, not defaulted: CODEX_ROOT is exported in this box's login environment,
# so `${CODEX_ROOT:=...}` reads as a pin and is not one. harness/pins.py has
# the incident. SAFARI_COBBLESTONE is the override nothing else exports.
export CODEX_ROOT="${SAFARI_COBBLESTONE:-$HOME/showell_repos/cobblestone-safari}"
zig="${ZIG:-$HOME/zig-0.16.0/zig}"
# OURS, built by its own project in a worktree this one owns. It used to
# default into the SHARED transpiler checkout, which meant the compiler under
# every number here was whatever that tree happened to hold this afternoon.
# PROVENANCE.md names the pin; CODEXZIG still overrides.
codexzig="$("$here/build_codexzig.sh")"
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

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
python3 harness/bundle.py poc/SpikeMain.codex build/spike-unit.codex
"$codexzig" < build/spike-unit.codex 2> build/spike.zig > build/spike.diag
grep -q "^// THE PRELUDE" build/spike.zig || { echo "codexzig emitted no program:" >&2; head -3 build/spike.diag >&2; exit 1; }
( cd build && "$zig" build-exe spike.zig )
python3 harness/spike_svg.py

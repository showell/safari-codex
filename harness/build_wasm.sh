#!/usr/bin/env bash
# Build the browser proof of concept: Codex -> zig -> wasm32-freestanding, and
# drop the module where the game's own blitter.js expects to fetch it.
#
# The blitter is symlinked, not copied, and fetches an absolute
# /driving/safari.wasm -- so web/ is served as the document root and the only
# thing that differs from the real game is which module sits at that path.
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
root="$(dirname "$here")"
cd "$root"

# SET, not defaulted: CODEX_ROOT is exported in this box's login environment,
# so `${CODEX_ROOT:=...}` reads as a pin and is not one. harness/pins.py has
# the incident. SAFARI_COBBLESTONE is the override nothing else exports.
export CODEX_ROOT="${SAFARI_COBBLESTONE:-$HOME/showell_repos/cobblestone-safari}"
zig="${ZIG:-$HOME/zig-0.16.0/zig}"
# OURS, built by its own project in a worktree this one owns. It used to
# default into the SHARED transpiler checkout, which meant the compiler under
# every number here was whatever that tree happened to hold this afternoon.
# PROVENANCE.md names the pin; CODEXZIG still overrides.
codexzig="$("$root/harness/build_codexzig.sh")"
mkdir -p build web/driving

# The entry chapter, defaulting to the REAL-ROUTE scene. `Scene` is the original
# throwaway that placed its own scenery by hand; it still builds, and passing it
# is the way to compare the two.
#     ./harness/build_wasm.sh            # DriveMain -- the ported route
#     ./harness/build_wasm.sh SceneMain  # the old hand-placed proof of concept
entry="${1:-DriveMain}"
[ -f "poc/$entry.codex" ] || { echo "no poc/$entry.codex" >&2; exit 1; }
# The shim is per scene: Drive carries state (the world, the rider, a history
# ring) while Scene is a pure function of a scrub.
case "$entry" in
  DriveMain) shim=drive_shim.zig ;;
  *)         shim=shim.zig ;;
esac

python3 harness/bundle.py "poc/$entry.codex" build/scene-unit.codex
"$codexzig" < build/scene-unit.codex 2> build/scene.zig > build/scene.diag
# codexzig writes the zig to STDERR and diagnostics to stdout. On a halt it writes
# the REASON to stderr too, so the output file is short and non-empty rather than
# empty -- a plain -s test calls that success and hands wasmify a one-line file.
if ! grep -q "^// THE PRELUDE" build/scene.zig; then
  echo "codexzig emitted no program:" >&2
  head -3 build/scene.zig >&2
  exit 1
fi

# HEAP. 32 MB was ample while the animals drew nothing; with their stills in the
# frame it dies at frame 202. The arena is rewound every frame, so this is not a
# leak -- it is the high-water mark of ONE frame, and drawing 2,368 commands
# through Codex's persistent lists costs far more transient memory than the 166 KB
# of wire it produces. .bss costs nothing until touched (wasmify), so reserving
# generously is close to free; wasm32 caps the whole address space at 4 GiB.
python3 harness/wasmify.py build/scene.zig build/scene_wasm.zig "${HEAP_MB:-256}" "$shim"
( cd build && "$zig" build-exe scene_wasm.zig \
    -target wasm32-freestanding -fno-entry -rdynamic -O ReleaseSmall \
    -femit-bin=safari_codex.wasm )
cp build/safari_codex.wasm web/driving/safari.wasm
echo "web/driving/safari.wasm  ($(wc -c < web/driving/safari.wasm) bytes)"

# Decode the frame the module produces, so a broken wire fails HERE and not as a
# blank canvas in the browser.
#
# AND THEN RENDER A THOUSAND MORE. This decoded exactly ONE frame for a long time,
# and one frame is not what a browser does: blitter.js calls renderFrame() every
# animation frame, thirty of them behind the spinner before it even reveals the
# canvas. The emitted prelude bump-allocates and never reclaims, so every build
# from the first proof of concept onward died after 42 CALLS -- 0.7 seconds --
# and this check passed all of them, because it never asked for a second frame.
# The symptom in the browser was a spinner and then a dead canvas, which reads
# like a build problem rather than a heap problem and cost real eye-testing time.
#
# The fix is in poc/shim.zig (an arena reset per frame, PORTING_NOTES C8); this is
# the gate that would have caught it. A gate must exercise the shape the product
# uses, not the smallest shape that proves the wire is connected.
node -e '
const fs=require("fs");
const i=new WebAssembly.Instance(new WebAssembly.Module(fs.readFileSync("web/driving/safari.wasm")),{});
const {renderFrame,bufPtr,memory}=i.exports;
const len=renderFrame(), u32=new Uint32Array(memory.buffer,bufPtr(),len/4), f32=new Float32Array(memory.buffer,bufPtr(),len/4);
let w=0,n=0,bad=0,solid=0,round=0,disc=0,grad=0;
while(w*4<len){
  const tag=u32[w++]; w++;                       // tag, colour
  // tag 3 is a DISC: [3][color][x][y][r][alpha], six words and no point count.
  // Decoding it as a polygon reads its x as a count and reports a nonsense
  // 1141299789 points, which is what it did before this arm existed.
  if(tag===3){ for(let k=0;k<3;k++){const v=f32[w++]; if(!isFinite(v))bad++;} const al=f32[w++]; if(!isFinite(al)||al<0||al>1){console.error(`bad beacon alpha ${al} at command ${n}`);process.exit(1);} disc++; n++; continue; }
  // THE GRADIENT POLYGONS: tag 4 is radial (the truck headlight beams and the
  // brake glow), 5 linear and 6 elliptical (the bulls). Each carries a SECOND
  // colour word and then its own geometry -- 3, 6 and 8 floats -- ahead of the
  // point count. Walking one as a plain polygon reads its second colour as a
  // count, which desyncs the wire rather than reporting anything useful.
  const GRAD={4:3,5:6,6:8};
  if(GRAD[tag]!==undefined){ w++; for(let k=0;k<GRAD[tag];k++){const v=f32[w++]; if(!isFinite(v))bad++;} grad++; }
  else if(tag===1){w++; round++;} else solid++;  // tag 1 carries a strength word
  const np=u32[w++];
  // 2048 is the pts[] bound in mountains.zig itself: a silhouette is 683 points,
  // one per column across the widest view plus two to close it to the horizon.
  // This read 64 while the scene held only trees and rails, and the real ranges
  // tripped it. NB the whole node program is one single-quoted shell string, so
  // no apostrophes in here.
  if(np<3||np>2048){console.error(`bad point count ${np} at command ${n}`);process.exit(1);}
  for(let k=0;k<np*2;k++){const v=f32[w++]; if(!isFinite(v))bad++;} n++;}
if(w*4!==len){console.error(`wire desync: walked ${w*4} of ${len} bytes`);process.exit(1);}
if(!n||bad){console.error(`bad frame: ${n} commands, ${bad} non-finite coords`);process.exit(1);}
console.log(`frame: ${n} commands (${solid} solid, ${round} round, ${disc} disc, ${grad} gradient), ${len} bytes, wire walks exactly`);
// Now the endurance leg: advance and re-render the way the page does. 1200 frames
// is twenty seconds at 60fps, and comfortably past the 42 that used to be fatal.
const FRAMES=1200;
let k=0;
try{ for(;k<FRAMES;k++){ if(i.exports.advance) i.exports.advance(); const l=renderFrame(); if(!l){console.error(`empty frame at ${k}`);process.exit(1);} } }
catch(err){ console.error(`DIED at frame ${k} of ${FRAMES}: ${String(err).split(String.fromCharCode(10))[0]}`); console.error(`the heap is not being reclaimed between frames -- see PORTING_NOTES C8`); process.exit(1); }
// and the wire must still be walkable after all that churn
const l2=renderFrame(), v32=new Uint32Array(memory.buffer,bufPtr(),l2/4);
const G2={4:4,5:7,6:9}; let z=0,m=0; while(z*4<l2){const t=v32[z++];z++;if(t===3){z+=4;m++;continue;}if(G2[t]!==undefined)z+=G2[t];else if(t===1)z++;const np=v32[z++];z+=np*2;m++;}
if(z*4!==l2){console.error(`wire desync after ${FRAMES} frames`);process.exit(1);}
console.log(`endurance: ${FRAMES} frames advanced and rendered, then ${m} commands still walk exactly`);'

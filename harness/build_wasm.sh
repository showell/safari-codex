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

: "${CODEX_ROOT:=$HOME/showell_repos/NewRepository}"
export CODEX_ROOT
zig="${ZIG:-$HOME/zig-0.16.0/zig}"
codexzig="${CODEXZIG:-$HOME/showell_repos/codex-zig-transpiler/generated/local/codexzig}"
mkdir -p build web/driving

python3 harness/bundle.py poc/SceneMain.codex build/scene-unit.codex
"$codexzig" < build/scene-unit.codex 2> build/scene.zig > build/scene.diag
# codexzig writes the zig to STDERR and diagnostics to stdout. On a halt it writes
# the REASON to stderr too, so the output file is short and non-empty rather than
# empty -- a plain -s test calls that success and hands wasmify a one-line file.
if ! grep -q "^// THE PRELUDE" build/scene.zig; then
  echo "codexzig emitted no program:" >&2
  head -3 build/scene.zig >&2
  exit 1
fi

python3 harness/wasmify.py build/scene.zig build/scene_wasm.zig
( cd build && "$zig" build-exe scene_wasm.zig \
    -target wasm32-freestanding -fno-entry -rdynamic -O ReleaseSmall \
    -femit-bin=safari_codex.wasm )
cp build/safari_codex.wasm web/driving/safari.wasm
echo "web/driving/safari.wasm  ($(wc -c < web/driving/safari.wasm) bytes)"

# Decode the frame the module produces, so a broken wire fails HERE and not as a
# blank canvas in the browser.
node -e '
const fs=require("fs");
const i=new WebAssembly.Instance(new WebAssembly.Module(fs.readFileSync("web/driving/safari.wasm")),{});
const {renderFrame,bufPtr,memory}=i.exports;
const len=renderFrame(), u32=new Uint32Array(memory.buffer,bufPtr(),len/4), f32=new Float32Array(memory.buffer,bufPtr(),len/4);
let w=0,n=0,bad=0,solid=0,round=0;
while(w*4<len){
  const tag=u32[w++]; w++;                       // tag, colour
  if(tag===1){w++; round++;} else solid++;       // tag 1 carries a strength word
  const np=u32[w++];
  if(np<3||np>64){console.error(`bad point count ${np} at command ${n}`);process.exit(1);}
  for(let k=0;k<np*2;k++){const v=f32[w++]; if(!isFinite(v))bad++;} n++;}
if(w*4!==len){console.error(`wire desync: walked ${w*4} of ${len} bytes`);process.exit(1);}
if(!n||bad){console.error(`bad frame: ${n} commands, ${bad} non-finite coords`);process.exit(1);}
console.log(`frame: ${n} commands (${solid} solid, ${round} round), ${len} bytes, wire walks exactly`);'

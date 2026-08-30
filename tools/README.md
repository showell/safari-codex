# tools/

Two third-party pieces the fourth arm runs on. Neither is built here and neither
is tracked; `package.json` and this file are what pin them.

**`wabt`** (npm) assembles the WAT the wasm plug emits into a module.
`npm ci` in this directory restores it. `harness/wat2wasm.mjs` is the caller and
enables the tail-call feature, without which the assembler refuses a module
carrying `return_call`.

**`bin/wasmtime`** runs it. Fetch it with:

    curl -sL https://github.com/bytecodealliance/wasmtime/releases/download/v27.0.0/wasmtime-v27.0.0-x86_64-linux.tar.xz \
      | tar xJ -C /tmp && mkdir -p tools/bin && cp /tmp/wasmtime-v27.0.0-x86_64-linux/wasmtime tools/bin/

**Why wasmtime and not node**, which was here first and is still what
`harness/build_wasm.sh` uses for the browser module's gate: node's WASI has no
way to ask for a bigger wasm stack, and the plug's modules need one. `RenderCheck`
and `RiderCheck` died under it with SIGSEGV -- not a catchable trap -- after 2
lines, then 10, then 2 again. A bed whose answer moves between runs cannot
referee a comparison, and a crash landing mid-output reads as the two arms
disagreeing, which is a defect claimed against code that is fine.

wasmtime takes the stack as an argument, and the emitter's own harness already
does this: `codex/plugs/wasm/wasm-e2e.ps1` runs `max-wasm-stack=16777216`
because the default "exhausts inside the text printer's per-def recursion".
Under it every module here runs clean and identical three times out of three.

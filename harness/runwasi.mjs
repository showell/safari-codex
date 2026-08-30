// Run a wasm32-wasi command and let its output be this process's output.
// Node's own WASI, so no runtime is installed for this and both roads are run
// by the same host.
//
// IN A WORKER, FOR ITS STACK. The plug's modules recurse once per list element
// and the emitter's own bed knows it: codex/plugs/wasm/wasm-e2e.ps1 runs
// wasmtime at `max-wasm-stack=16777216` because the default "exhausts inside
// the text printer's per-def recursion", with a `.wasmstack` sidecar to pin a
// browser's smaller number where that is the property under test. Node's WASI
// has no such knob and its default is smaller still -- `RiderCheck` died on it
// with SIGSEGV, which is not even a catchable trap. `resourceLimits.stackSizeMb`
// on a worker is the equivalent lever, and 256 MB is the number that made Rider
// run; SAFARI_WASM_STACK_MB overrides it.
//
// This is a property of the BED and not of either arm: the zig road asks
// `zig build-exe --stack 536870912` for the same reason, and gets it at link
// time because a native executable can.
import { Worker, isMainThread, workerData } from 'node:worker_threads';

if (isMainThread) {
  const w = new Worker(new URL(import.meta.url), {
    workerData: process.argv[2],
    resourceLimits: { stackSizeMb: Number(process.env.SAFARI_WASM_STACK_MB || 256) },
  });
  w.on('exit', code => { process.exitCode = code; });
} else {
  const { WASI } = await import('node:wasi');
  const { readFileSync } = await import('node:fs');
  const wasi = new WASI({ version: 'preview1', args: ['prog'], env: {}, returnOnExit: true });
  const inst = new WebAssembly.Instance(
    new WebAssembly.Module(readFileSync(workerData)), wasi.getImportObject());
  process.exitCode = wasi.start(inst);
}

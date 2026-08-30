// Run a wasm32-wasi command and let its output be this process's output.
// Node's own WASI, so no runtime is installed for this and the two arms are
// run by the same host.
import { WASI } from 'node:wasi';
import { readFileSync } from 'node:fs';

const wasi = new WASI({ version: 'preview1', args: ['prog'], env: {}, returnOnExit: true });
const inst = new WebAssembly.Instance(
  new WebAssembly.Module(readFileSync(process.argv[2])), wasi.getImportObject());
process.exitCode = wasi.start(inst);

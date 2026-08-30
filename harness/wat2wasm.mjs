// Assemble a WAT file into a wasm module. wabt's own JS build, which is the
// same libwabt the wat2wasm binary is, so "the assembler accepted it" means
// what it means everywhere else.
//
// TAIL CALLS ARE NOT OPTIONAL HERE. The wasm plug emits `return_call` for a
// saturating self- or mutual tail call, which is how the compiler's own
// lexer cycle runs in constant stack; without the feature enabled the
// assembler refuses the module outright.
import { readFileSync, writeFileSync } from 'node:fs';
import wabtInit from '../tools/node_modules/wabt/index.js';

const [, , watPath, wasmPath] = process.argv;
const wabt = await wabtInit();
const mod = wabt.parseWat(watPath, readFileSync(watPath, 'utf8'), { tail_call: true });
mod.resolveNames();
mod.validate();
writeFileSync(wasmPath, Buffer.from(mod.toBinary({}).buffer));

// Paint real frames with the real blitter, and count what the canvas was asked for.
//
//   node harness/paint_probe.js [frames]
//
// build_wasm.sh already walks the wire and already renders 1,200 frames to prove
// the heap survives. Neither of those runs BLITTER.JS. A tag the module emits and
// the blitter does not know decodes perfectly and paints nothing -- the wire walk
// is happy, the endurance leg is happy, and the browser shows a hole. This is the
// last mile: load the fork the way harness/blitter_diff.js does, hand it the
// module's own buffer, and check the canvas calls add up.
//
// THE INVARIANT IS AN IDENTITY, not a threshold. Every command begins a path and
// fills it, and every command is either a polygon (one moveTo) or a disc (one arc),
// so beginPath == fill == commands == moveTo + arc. A command the blitter skipped
// breaks it; a command it decoded as the wrong shape breaks it.

const fs = require('fs');
const path = require('path');

const ROOT = path.join(__dirname, '..');
const FRAMES = Number(process.argv[2] || 300);

const src = fs.readFileSync(path.join(ROOT, 'web', 'blitter.js'), 'utf8')
  .replace(/^main\(SAFARI\);\s*$/m, '');
const stub = {
  document: { body: { style: {} }, head: { appendChild() {} },
              createElement: () => ({ style: {}, appendChild() {}, remove() {} }) },
  window: { addEventListener() {} },
  WebAssembly: {}, performance: { now: () => 0 }, requestAnimationFrame() {},
};
const blitter = new Function('document', 'window', 'WebAssembly', 'performance',
                             'requestAnimationFrame', src + '\nreturn { blit };')(
  stub.document, stub.window, stub.WebAssembly, stub.performance, stub.requestAnimationFrame);

// A canvas that counts. `fillStyle` is a property rather than a call, and the
// gradients it is given need an addColorStop; nothing else is inspected.
const calls = {};
const ctx = new Proxy({}, {
  get: (_, k) => (k === 'fillStyle' ? null
    : (calls[k] = (calls[k] || 0) + 1, () => ({ addColorStop() {} }))),
  set: () => true,
});

const wasm = fs.readFileSync(path.join(ROOT, 'web', 'driving', 'safari.wasm'));
const { renderFrame, bufPtr, memory, advance } = new WebAssembly.Instance(
  new WebAssembly.Module(wasm), {}).exports;

let cmds = 0;
for (let f = 0; f < FRAMES; f++) {
  cmds += blitter.blit(ctx, memory, bufPtr(), renderFrame());
  advance();
}

const n = (k) => calls[k] || 0;
const shapes = n('moveTo') + n('arc');
console.log(`paint: ${FRAMES} frames, ${cmds} commands -- ${n('createLinearGradient')} span shades, `
          + `${n('arc')} discs, ${n('createRadialGradient')} radial fills`);
if (n('beginPath') !== cmds || n('fill') !== cmds || shapes !== cmds) {
  console.error(`the blitter skipped or mis-shaped a command: ${cmds} commands, `
              + `${n('beginPath')} beginPath, ${n('fill')} fill, ${shapes} moveTo+arc`);
  process.exit(1);
}
if (!cmds) { console.error('no commands painted at all'); process.exit(1); }

// Prove the forked blitter paints exactly what the original does.
//
//   node harness/blitter_diff.js
//
// `HISTORICAL_WASM_ROOT/blitter.js` is the game as it stood when this port was
// checked, and it is the ORACLE for `web/blitter.js` the same way the zig modules
// are the oracle for `port/`. The fork has been refactored -- sections drawn,
// helpers split, the guest boundary bound -- and every one of those changes was
// argued to be behaviour-preserving. This checks it.
//
// The method is the one that works everywhere else here: RUN BOTH and compare.
// A recording canvas turns a frame into a list of calls, a synthetic buffer
// exercises every tag, and the two lists have to match exactly.

const fs = require('fs');
const path = require('path');

// Load a blitter without starting the app: strip the `main()` call, stub the
// browser, and hand back the functions we want to drive.
function load(file) {
  let src = fs.readFileSync(file, 'utf8').replace(/^main\(\);\s*$/m, '');
  const g = {
    document: { body: { style: {} }, head: { appendChild() {} },
                createElement: () => ({ style: {}, appendChild() {}, remove() {} }) },
    window: { addEventListener() {} },
    WebAssembly: {}, performance: { now: () => 0 }, requestAnimationFrame() {},
  };
  const fn = new Function('document', 'window', 'WebAssembly', 'performance',
                          'requestAnimationFrame',
                          src + '\nreturn { blit, drawBackground, drawSun };');
  return fn(g.document, g.window, g.WebAssembly, g.performance, g.requestAnimationFrame);
}

// A canvas that draws nothing and remembers everything, including the gradients:
// a paint is part of the answer, not a detail of it.
function recorder() {
  const calls = [];
  const say = (...a) => calls.push(a.map((v) => (typeof v === 'number' ? +v.toFixed(6) : v)).join(' '));
  const grad = (kind, args) => {
    const id = `${kind}(${args.map((v) => +v.toFixed(6)).join(',')})`;
    return { addColorStop: (at, col) => say('stop', id, +at.toFixed(6), col), __id: id };
  };
  const ctx = {
    _fill: null,
    set fillStyle(v) { this._fill = v; say('fillStyle', typeof v === 'string' ? v : v.__id); },
    get fillStyle() { return this._fill; },
    set globalAlpha(v) { say('globalAlpha', v); },
    beginPath: () => say('beginPath'),
    closePath: () => say('closePath'),
    moveTo: (x, y) => say('moveTo', x, y),
    lineTo: (x, y) => say('lineTo', x, y),
    arc: (x, y, r, a, b) => say('arc', x, y, r, a, b),
    rect: (x, y, w, h) => say('rect', x, y, w, h),
    fill: () => say('fill'),
    fillRect: (x, y, w, h) => say('fillRect', x, y, w, h),
    clip: () => say('clip'),
    save: () => say('save'),
    restore: () => say('restore'),
    transform: (...a) => say('transform', ...a),
    createLinearGradient: (...a) => grad('linear', a),
    createRadialGradient: (...a) => grad('radial', a),
  };
  return { ctx, calls };
}

// A buffer exercising every tag, including the branches each one guards: a disc
// under the radius floor and over it, a radial polygon on both sides of its floor,
// a degenerate ellipse, a crown narrower than a pixel and a wide one, and a crown
// at zero strength.
function buffer() {
  const words = [];
  const u = (v) => words.push({ u: v >>> 0 });
  const f = (v) => words.push({ f: v });
  const poly = (pts) => { u(pts.length); for (const [x, y] of pts) { f(x); f(y); } };
  const TRI = [[10, 10], [90, 20], [50, 80]];
  const THIN = [[10, 10], [10.5, 20], [10.2, 80]];

  u(0); u(0x4a8f43); poly(TRI);                                   // solid
  u(1); u(0xc0ffee); f(0.0); poly(TRI);                            // crown, no strength
  u(1); u(0xc0ffee); f(0.75); poly(TRI);                           // crown, shaded
  u(1); u(0xc0ffee); f(1.0); poly(THIN);                           // crown, too narrow
  u(3); u(0xff2020); f(40); f(50); f(0.2); f(0.9);                 // disc, too small
  u(3); u(0xff2020); f(40); f(50); f(6); f(0.01);                  // disc, too faint
  u(3); u(0xff2020); f(40); f(50); f(6); f(0.6);                   // disc, drawn
  u(4); u(0x80ffe0a0); u(0x00ff9d5c); f(50); f(50); f(0.1); poly(TRI); // radial, too small
  u(4); u(0x80ffe0a0); u(0x00ff9d5c); f(50); f(50); f(30); poly(TRI);  // radial, drawn
  u(5); u(0xff102030); u(0x80405060); f(-0.5); f(1.5); f(0); f(0); f(80); f(80); poly(TRI); // linear, stops clamped
  u(6); u(0xff102030); u(0x80405060); f(0.1); f(0.9); f(50); f(50); f(20); f(0); f(0); f(20); poly(TRI); // ellipse
  u(6); u(0xff102030); u(0x80405060); f(0.1); f(0.9); f(50); f(50); f(0); f(0); f(0); f(0); poly(TRI);   // degenerate

  const buf = new ArrayBuffer(words.length * 4);
  const u32 = new Uint32Array(buf), f32 = new Float32Array(buf);
  words.forEach((w, i) => { if ('u' in w) u32[i] = w.u; else f32[i] = w.f; });
  return { memory: { buffer: buf }, len: words.length * 4 };
}

const oracle = load(path.join(__dirname, '..', 'HISTORICAL_WASM_ROOT', 'blitter.js'));
const fork = load(path.join(__dirname, '..', 'web', 'blitter.js'));
const { memory, len } = buffer();

let bad = 0;
function compare(name, run) {
  const a = recorder(), b = recorder();
  const ra = run(oracle, a.ctx), rb = run(fork, b.ctx);
  const same = JSON.stringify(a.calls) === JSON.stringify(b.calls) && ra === rb;
  if (!same) {
    bad++;
    console.log(`${name}: DIFFERS (${a.calls.length} vs ${b.calls.length} calls, returned ${ra} vs ${rb})`);
    for (let i = 0; i < Math.max(a.calls.length, b.calls.length); i++) {
      if (a.calls[i] !== b.calls[i]) {
        console.log(`  first at ${i}:\n    oracle ${a.calls[i]}\n    fork   ${b.calls[i]}`);
        break;
      }
    }
  } else {
    console.log(`${name}: ok, ${a.calls.length} canvas calls identical`);
  }
}

compare('blit          ', (m, ctx) => m.blit(ctx, memory, 0, len));
compare('drawBackground', (m, ctx) => m.drawBackground(ctx, '#8ec5ff', '#ffd9a0'));
compare('drawSun       ', (m, ctx) => m.drawSun(ctx, 480, 220, 1.4));
process.exit(bad ? 1 : 0);

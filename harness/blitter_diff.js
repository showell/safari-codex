// Prove the forked blitter paints exactly what the original does.
//
//   node harness/blitter_diff.js
//
// `HISTORICAL_WASM_ROOT/blitter.js` is the game as it stood when this port was
// checked, and it is the ORACLE for `web/blitter.js` the same way the zig modules
// are the oracle for `port/`. The fork has been refactored -- sections drawn,
// helpers split, the guest boundary bound, and now the scene recipes handed to
// `port/Blit.codex` -- and every one of those changes was argued to be
// behaviour-preserving. This checks it.
//
// The method is the one that works everywhere else here: RUN BOTH and compare.
// A recording canvas turns a frame into a list of calls and the two lists have to
// match exactly.
//
// THE TWO BLITTERS ARE NO LONGER FED THE SAME BYTES, and that is the whole point
// of this round. The guest used to send a tag-1 polygon and a strength and let the
// browser work out three colours and an x-extent; it now sends a tag-2 span shade
// with the colours and the extent already in it, and sends nothing at all for a
// disc it has decided is too faint. So the oracle gets the OLD wire, the fork gets
// the EXPANDED one, and identical canvas calls is the claim: the recipe moved, the
// picture did not.
//
// The expansion the harness applies is `blitter_oracle.expandShade` -- built out
// of the frozen original's own `shade()` and its own literals, and independent of
// the Codex `blit-expand` that `judge/BlitCheck.codex` grades against it.
//
// ONE RESIDUAL DIFFERENCE, NAMED RATHER THAN HIDDEN. On the old wire the shim
// narrowed `strength` to f32 and the browser shaded from that; on the new one
// Codex shades from the f64 and only the finished colours cross. For a strength
// that is not exactly representable in f32 the two can land a single unit apart in
// one channel. The frame below uses f32-exact strengths so this comparison is
// exact; the game's own strengths are not all f32-exact, so a channel there may
// move by one. The x-extent has no such gap -- narrowing is monotonic, so the
// minimum of the narrowed x's and the narrowing of the minimum are the same float.

const fs = require('fs');
const path = require('path');
const O = require('./blitter_oracle.js');

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

// ONE FRAME, DESCRIBED ONCE, and emitted as two wires. It exercises every tag and
// the branches each one guards: a disc under the radius floor and over it, a
// radial polygon on both sides of its floor, a degenerate ellipse, a shaded
// polygon narrower than a pixel and a wide one, and a shaded polygon at zero
// strength.
const TRI = [[10, 10], [90, 20], [50, 80]];
const THIN = [[10, 10], [10.5, 20], [10.2, 80]];
const FRAME = [
  { tag: 0, color: 0x4a8f43, pts: TRI },
  { tag: 1, color: 0xc0ffee, strength: 0.0, pts: TRI },     // no strength: flat
  { tag: 1, color: 0xc0ffee, strength: 0.75, pts: TRI },    // shaded
  { tag: 1, color: 0xc0ffee, strength: 1.0, pts: THIN },    // too narrow: flat
  { tag: 3, color: 0xff2020, x: 40, y: 50, r: 0.2, alpha: 0.9 },   // too small
  { tag: 3, color: 0xff2020, x: 40, y: 50, r: 6, alpha: 0.01 },    // too faint
  { tag: 3, color: 0xff2020, x: 40, y: 50, r: 6, alpha: 0.6 },     // drawn
  { tag: 4, c0: 0x80ffe0a0, c1: 0x00ff9d5c, geom: [50, 50, 0.1], pts: TRI },  // too small
  { tag: 4, c0: 0x80ffe0a0, c1: 0x00ff9d5c, geom: [50, 50, 30], pts: TRI },   // drawn
  { tag: 5, c0: 0xff102030, c1: 0x80405060, geom: [-0.5, 1.5, 0, 0, 80, 80], pts: TRI }, // stops clamped
  { tag: 6, c0: 0xff102030, c1: 0x80405060, geom: [0.1, 0.9, 50, 50, 20, 0, 0, 20], pts: TRI },
  { tag: 6, c0: 0xff102030, c1: 0x80405060, geom: [0.1, 0.9, 50, 50, 0, 0, 0, 0], pts: TRI }, // degenerate
];

// A writer for the wire, in words. `u` and `f` are the two views the blitter takes
// over the same memory.
function writer() {
  const words = [];
  return {
    words,
    u: (v) => words.push({ u: v >>> 0 }),
    f: (v) => words.push({ f: v }),
    poly(pts) { this.u(pts.length); for (const [x, y] of pts) { this.f(x); this.f(y); } },
  };
}

function pack(words) {
  const buf = new ArrayBuffer(words.length * 4);
  const u32 = new Uint32Array(buf), f32 = new Float32Array(buf);
  words.forEach((w, i) => { if ('u' in w) u32[i] = w.u; else f32[i] = w.f; });
  return { memory: { buffer: buf }, len: words.length * 4 };
}

// Which commands the expansion keeps. The thresholds are the oracle's own.
function survives(c) {
  if (c.tag === 3) return O.discIsVisible(c.r, c.alpha);
  if (c.tag === 4) return O.radialIsVisible(c.geom[2]);
  return true;
}

// The OLD wire: what paint.zig and the shim wrote before the expansion existed.
// The filter is how the dropped commands get looked at on their own.
function rawWire(keep = () => true) {
  const o = writer();
  for (const c of FRAME) {
    if (!keep(c)) continue;
    o.u(c.tag);
    if (c.tag === 3) { o.u(c.color); o.f(c.x); o.f(c.y); o.f(c.r); o.f(c.alpha); continue; }
    if (c.tag >= 4) { o.u(c.c0); o.u(c.c1); for (const v of c.geom) o.f(v); o.poly(c.pts); continue; }
    o.u(c.color);
    if (c.tag === 1) o.f(c.strength);
    o.poly(c.pts);
  }
  return pack(o.words);
}

// The NEW wire: the same frame after the expansion. Shaded polygons resolve to a
// flat fill or a tag-2 span shade; a disc or a radial fill under its threshold is
// not written at all.
function expandedWire() {
  const o = writer();
  for (const c of FRAME) {
    if (!survives(c)) continue;
    if (c.tag === 3) { o.u(3); o.u(c.color); o.f(c.x); o.f(c.y); o.f(c.r); o.f(c.alpha); continue; }
    if (c.tag >= 4) { o.u(c.tag); o.u(c.c0); o.u(c.c1); for (const v of c.geom) o.f(v); o.poly(c.pts); continue; }
    if (c.tag === 1) {
      const e = O.expandShade(c.color, c.strength, c.pts.map(([x]) => x));
      if (e.tag === 2) { o.u(2); o.u(e.c0); o.u(e.c1); o.f(e.lo); o.f(e.hi); o.poly(c.pts); }
      else { o.u(0); o.u(e.c0); o.poly(c.pts); }
      continue;
    }
    o.u(c.tag); o.u(c.color); o.poly(c.pts);
  }
  return pack(o.words);
}

const oracle = load(path.join(__dirname, '..', 'HISTORICAL_WASM_ROOT', 'blitter.js'));
const fork = load(path.join(__dirname, '..', 'web', 'blitter.js'));

let bad = 0;
function say(ok, name, msg) { if (!ok) bad++; console.log(`${name}: ${ok ? 'ok, ' : 'BAD  '}${msg}`); }

function compare(name, runA, runB) {
  const a = recorder(), b = recorder();
  runA(oracle, a.ctx); runB(fork, b.ctx);
  if (JSON.stringify(a.calls) === JSON.stringify(b.calls)) {
    say(true, name, `${a.calls.length} canvas calls identical`);
    return;
  }
  say(false, name, `DIFFERS (${a.calls.length} vs ${b.calls.length} calls)`);
  for (let i = 0; i < Math.max(a.calls.length, b.calls.length); i++) {
    if (a.calls[i] !== b.calls[i]) {
      console.log(`  first at ${i}:\n    oracle ${a.calls[i]}\n    fork   ${b.calls[i]}`);
      break;
    }
  }
}

// THE SURVIVORS, PAINTED BOTH WAYS. Every command the expansion keeps, on the old
// wire through the original and on the new wire through the fork. This is the
// claim the whole change rests on: the recipe moved, the picture did not.
const kept = rawWire(survives);
const expanded = expandedWire();
compare('blit          ',
        (m, ctx) => m.blit(ctx, kept.memory, 0, kept.len),
        (m, ctx) => m.blit(ctx, expanded.memory, 0, expanded.len));

const both = (run) => [run, run];
compare('drawBackground', ...both((m, ctx) => m.drawBackground(ctx, '#8ec5ff', '#ffd9a0')));
compare('drawSun       ', ...both((m, ctx) => m.drawSun(ctx, 480, 220, 1.4)));

// THE DROPPED ONES, SHOWN TO PAINT NOTHING. The original does not skip these
// commands -- it traces their polygons and then declines to fill -- so leaving
// them out of the wire is only sound if that work marked no pixels. Run the
// original on nothing but the dropped commands and demand that it never fills.
const droppedFrame = FRAME.filter((c) => !survives(c));
const droppedWire = rawWire((c) => !survives(c));
const d = recorder();
const nDropped = oracle.blit(d.ctx, droppedWire.memory, 0, droppedWire.len);
const painted = d.calls.filter((c) => c === 'fill' || c.startsWith('fillRect') || c.startsWith('arc'));
say(nDropped === droppedFrame.length && droppedFrame.length > 0 && painted.length === 0,
    'dropped       ',
    `${nDropped} dropped commands make ${d.calls.length} canvas calls and paint nothing`);

// AND THE WIRE REALLY IS SHORTER. Equal counts would mean the expansion did
// nothing, and the comparison above would have proved only that.
const full = rawWire();
const r = recorder(), e = recorder();
const nRaw = oracle.blit(r.ctx, full.memory, 0, full.len);
const nExp = fork.blit(e.ctx, expanded.memory, 0, expanded.len);
say(nRaw - nExp === droppedFrame.length, 'wire          ',
    `the guest sends ${nExp} commands where it used to send ${nRaw}`);

process.exit(bad ? 1 : 0);

// Does the boundary hold? Build a SECOND screensaver on the same renderer.
//
//   node harness/second_show.js
//
// The claim `web/blitter.js` makes is that everything outside its SHOW block is
// about rendering frames and not about safari -- that a night walk through a city
// would reuse the tag vocabulary, the paints, the frame loop, the clock and the
// segments, and replace only a descriptor. A claim like that is worth executing.
//
// So this defines that second show, drives the SAME `blit` and the SAME frame
// path with a stub guest, and reports what actually had to change.

const fs = require('fs');
const path = require('path');

function load(file) {
  const src = fs.readFileSync(file, 'utf8').replace(/^main\(SAFARI\);\s*$/m, '');
  const stub = { body: { style: {} }, head: { appendChild() {} },
                 createElement: () => ({ style: {}, appendChild() {}, remove() {} }) };
  return new Function('document', 'window', 'WebAssembly', 'performance', 'requestAnimationFrame',
    src + '\nreturn { blit, hex, SAFARI, TAG };')(
    stub, { addEventListener() {} }, {}, { now: () => 0 }, () => {});
}

function recorder() {
  const calls = [];
  const say = (...a) => calls.push(a.join(' '));
  const grad = () => ({ addColorStop: (at, col) => say('stop', +at.toFixed(4), col) });
  return {
    calls,
    ctx: {
      set fillStyle(v) { say('fillStyle', typeof v === 'string' ? v : 'gradient'); },
      set globalAlpha(v) { say('globalAlpha', v); },
      beginPath: () => say('beginPath'), closePath: () => say('closePath'),
      moveTo: (x, y) => say('moveTo', x, y), lineTo: (x, y) => say('lineTo', x, y),
      arc: () => say('arc'), rect: () => say('rect'), fill: () => say('fill'),
      fillRect: (x, y, w, h) => say('fillRect', x, y, w, h), clip: () => say('clip'),
      save: () => say('save'), restore: () => say('restore'), transform: () => say('transform'),
      createLinearGradient: grad, createRadialGradient: grad,
    },
  };
}

const M = load(path.join(__dirname, '..', 'web', 'blitter.js'));

// ── THE SECOND SHOW ────────────────────────────────────────────────────────────
// A night walk through a city. No sun, no grass; a dark sky over lit pavement.
// It is a descriptor and a backdrop, and that is the entire delta.
const W = 960, H = 600;
function drawCityBackdrop(ctx, scene) {
  const BIG = W + H;
  const g = ctx.createLinearGradient(0, 0, 0, H / 2);
  g.addColorStop(0, '#05060f');
  g.addColorStop(1, M.hex(scene.skyHorizon()));
  ctx.fillStyle = g;
  ctx.fillRect(W / 2 - BIG, H / 2 - BIG, 2 * BIG, BIG);
  ctx.fillStyle = '#15161c';                       // wet asphalt, not grass
  ctx.fillRect(W / 2 - BIG, H / 2 - 1, 2 * BIG, BIG + 1);
}
const NIGHT_WALK = {
  wasm: '/walking/city.wasm',
  segments: 8,
  hint: 'SPACE pause/resume · ↑/↓ step · J next block · D debug overlay',
  loading: 'Stepping out…',
  backdrop: drawCityBackdrop,
};

// A stub guest: enough of the scene vocabulary to paint one frame.
const scene = { skyTop: () => 0x0b0d1a, skyHorizon: () => 0x1b2340, sun: () => null };

// A TAG BY NAME, and it throws rather than answering undefined. `undefined >>> 0`
// is 0, so a renamed or retired tag writes a SOLID header where a longer one
// belongs, the wire desyncs, and the blitter reads a coordinate as a point count
// and traces a polygon with two billion sides. That is not a hypothetical: this
// file asked for TAG.WIDTH_SHADE after tag 1 left the vocabulary and took node's
// heap with it.
function tag(name) {
  if (!(name in M.TAG)) throw new Error(`web/blitter.js has no TAG.${name}`);
  return M.TAG[name];
}

// The same geometry, rendered by the same blitter, under both shows.
//
// THE SPAN SHADE'S TWO COLOURS ARE JUST NUMBERS HERE, picked by this stub guest
// out of nothing. That is the shape of the boundary after the recipes moved: the
// renderer is handed an edge colour, a middle colour and a span, and has no
// opinion about where they came from. Safari's come from `port/Blit.codex`'s
// darken-the-edges recipe; a night walk's could come from anywhere.
function frameBuffer() {
  const words = [];
  const u = (v) => words.push({ u: v >>> 0 }), f = (v) => words.push({ f: v });
  const poly = (pts) => { u(pts.length); for (const [x, y] of pts) { f(x); f(y); } };
  u(tag('SOLID')); u(0x333a4a); poly([[0, 300], [200, 120], [260, 300]]);
  u(tag('SPAN_SHADE')); u(0x49536b); u(0x8b9bc4); f(300); f(470);
  poly([[300, 300], [420, 90], [470, 300]]);
  u(tag('DISC')); u(0xffe9a8); f(120); f(140); f(7); f(0.8);
  const buf = new ArrayBuffer(words.length * 4);
  const u32 = new Uint32Array(buf), f32 = new Float32Array(buf);
  words.forEach((w, i) => { if ('u' in w) u32[i] = w.u; else f32[i] = w.f; });
  return { memory: { buffer: buf }, len: words.length * 4 };
}

const { memory, len } = frameBuffer();
let bad = 0;
for (const show of [M.SAFARI, NIGHT_WALK]) {
  const r = recorder();
  show.backdrop(r.ctx, scene);
  const backdropCalls = r.calls.length;
  const cmds = M.blit(r.ctx, memory, 0, len);
  const name = show === M.SAFARI ? 'safari    ' : 'night-walk';
  if (cmds !== 3) { bad++; console.log(`${name}: expected 3 commands, painted ${cmds}`); continue; }
  console.log(`${name}: backdrop ${backdropCalls} calls, then ${cmds} commands, ` +
              `${r.calls.length - backdropCalls} calls -- same blitter, same tags`);
}

// What the second show actually cost, measured rather than asserted.
const src = fs.readFileSync(path.join(__dirname, '..', 'web', 'blitter.js'), 'utf8').split('\n');
const from = src.findIndex((l) => l.startsWith('// ── 2a. THE SHOW'));
const to = src.findIndex((l) => l.startsWith('// ── 2b. THE GUEST BOUNDARY'));
const showLines = src.slice(from, to).filter((l) => l.trim() && !l.trim().startsWith('//')).length;
console.log(`\nthe SHOW block is ${showLines} lines of code out of ` +
            `${src.filter((l) => l.trim() && !l.trim().startsWith('//')).length}; ` +
            `a second show replaces those and nothing else`);
process.exit(bad ? 1 : 0);

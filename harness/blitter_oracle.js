// THE BLITTER ORACLE, read out of the frozen original.
//
// `HISTORICAL_WASM_ROOT/blitter.js` is the angry-gopher game as it stood when this
// port was checked, and this project never edits it. It is where the shading
// recipe and the four visibility thresholds have always lived -- numbers chosen by
// eye, in the one file nothing here can run -- so it is the oracle for
// `port/Blit.codex` and for `web/blitter.js` alike.
//
// THIS MODULE USED TO BE THE FORK. `harness/gen_blit_gold.js` lifted `shadeColor`
// and friends out of `web/blitter.js` by name, which was fine while the fork still
// held the recipe and became untenable the moment it stopped: an oracle that moves
// when the subject moves is not an oracle. Reading the original instead fixes that
// in the right direction -- the numbers were always the game's, not ours.
//
// The original states the recipe INLINE, in `blit()`, rather than in named
// functions, so what is lifted here is `shade()` by name plus every literal by a
// regex that names the line it expects. A regex that stops matching throws; it
// cannot silently grade against a default.

const fs = require('fs');
const path = require('path');

const FILE = path.join(__dirname, '..', 'HISTORICAL_WASM_ROOT', 'blitter.js');
const SRC = fs.readFileSync(FILE, 'utf8');

function lift(re, what) {
  const m = SRC.match(re);
  if (!m) throw new Error(`HISTORICAL_WASM_ROOT/blitter.js no longer says ${what}`);
  return parseFloat(m[1]);
}

// The shading recipe, from the three addColorStop lines it is written on.
const SHADE_EDGE_DARKEN = lift(/addColorStop\(0, shade\(color, 1 - ([\d.]+) \* strength\)\)/,
                               'stop 0 = shade(color, 1 - k * strength)');
const SHADE_MIDDLE_LIFT = lift(/addColorStop\(0\.5, shade\(color, 1 \+ ([\d.]+) \* strength\)\)/,
                               'stop 0.5 = shade(color, 1 + k * strength)');
const SHADE_EDGE_AGAIN = lift(/addColorStop\(1, shade\(color, 1 - ([\d.]+) \* strength\)\)/,
                              'stop 1 = shade(color, 1 - k * strength)');
if (SHADE_EDGE_AGAIN !== SHADE_EDGE_DARKEN) {
  throw new Error('the original\'s two edge stops no longer share a factor');
}

// The four thresholds, from the three lines that guard on them.
const MIN_SHADE_WIDTH = lift(/if \(maxX - minX < ([\d.]+)\)/, 'the flat-fill width guard');
const MIN_DISC_RADIUS = lift(/if \(r >= ([\d.]+) && alpha >= [\d.]+\)/, 'the disc radius floor');
const MIN_DISC_ALPHA = lift(/if \(r >= [\d.]+ && alpha >= ([\d.]+)\)/, 'the disc alpha floor');
const MIN_GRADIENT_RADIUS = lift(/if \(r >= ([\d.]+)\) \{\s*\n\s*const g = ctx\.createRadialGradient/,
                                 'the radial-fill radius floor');

// `shade` by name. It answers a CSS string, because in the original the colour
// never leaves the browser; here the number is what is wanted, so the string is
// parsed straight back. Taking the function rather than retyping its arithmetic is
// the point -- Math.round's tie rule is part of the oracle.
const shadeAt = SRC.indexOf('function shade(');
if (shadeAt < 0) throw new Error('HISTORICAL_WASM_ROOT/blitter.js no longer defines shade()');
const shadeSrc = SRC.slice(shadeAt, SRC.indexOf('\n}\n', shadeAt) + 3);
const shadeCss = new Function(shadeSrc + '\nreturn shade;')();

function shadeColor(c, f) {
  const m = /^rgb\((\d+),(\d+),(\d+)\)$/.exec(shadeCss(c, f));
  if (!m) throw new Error(`the original's shade() no longer answers rgb(r,g,b): ${shadeCss(c, f)}`);
  return (+m[1] << 16) | (+m[2] << 8) | +m[3];
}

// The recipe in stop order: darken both edges, lift the middle. The offsets are
// the canvas's business and stay beside the colours only because the original
// writes them there.
function widthShadeStops(color, strength) {
  return [
    [0, shadeColor(color, 1 - SHADE_EDGE_DARKEN * strength)],
    [0.5, shadeColor(color, 1 + SHADE_MIDDLE_LIFT * strength)],
    [1, shadeColor(color, 1 - SHADE_EDGE_DARKEN * strength)],
  ];
}

const discIsVisible = (r, alpha) => r >= MIN_DISC_RADIUS && alpha >= MIN_DISC_ALPHA;
const radialIsVisible = (r) => r >= MIN_GRADIENT_RADIUS;
const tooNarrowToShade = (minX, maxX) => maxX - minX < MIN_SHADE_WIDTH;

module.exports = {
  FILE, SRC,
  SHADE_EDGE_DARKEN, SHADE_MIDDLE_LIFT,
  MIN_DISC_RADIUS, MIN_DISC_ALPHA, MIN_GRADIENT_RADIUS, MIN_SHADE_WIDTH,
  shadeColor, widthShadeStops, discIsVisible, radialIsVisible, tooNarrowToShade,
};

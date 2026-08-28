# safari-codex

A port of the Safari driving screensaver from Zig to **Codex**, verified against
the Zig it came from.

The Zig version stays intact and keeps running on lynrummy.com/driving. This is a
parallel port, not a migration. `NOTES.txt` is the research brief that opened the
project and is still the best single orientation; this file is the part that has
been built.

## The loop

    ./harness/run.sh

That is the whole interface. It takes no arguments, runs every check in `judge/`,
and prints `GREEN` or `RED`. For each module it:

1. builds `probe/probe_<mod>.zig` and runs it — the probe imports the **real,
   unmodified** game module, so the hand-written Zig is the oracle;
2. writes its answers to `gold/<Mod>Gold.codex`, regenerated every run;
3. bundles the check with `harness/bundle.py`;
4. transpiles it with `codexzig`, builds the Zig, runs it, and grades.

About five seconds per module. **Nothing here boots a QEMU guest** — this is not
the ladder's usual cadence, and none of the ladder's compute rules apply.

## Layout

| directory | holds | written by |
|---|---|---|
| `port/` | the port itself — Codex chapters, quire `Safari` | hand |
| `judge/` | graders and check roots, quire `Judge` | hand |
| `gold/` | gold chapters, quire `Gold` | **generated, gitignored** |
| `probe/` | Zig probes that import the real game | hand |
| `harness/` | the four steps | hand |
| `price-b/` | the fixed-point measurements behind the dialect decision | one-off |
| `spike/` | the original feasibility spike | historical |

`probe/wasm` is a symlink to `angry-gopher/games/driving/wasm`, so the probes can
`@import` the game with a relative path. That settles NOTES open decision 1: the
port lives here, and the symlink pays for it.

## Adding a module

Add three files and nothing else — `harness/run.sh` discovers the rest:

    port/<Mod>.codex          the port
    probe/probe_<mod>.zig     the oracle, printing `<kind> <name> <values...>`
    judge/<Mod>Check.codex    flatten each seam, hand it to Grade

`judge/Grade.codex` is the only grader. Every seam flattens to a list of Reals,
Integers or Booleans, so one grader serves pond, the camera, and eventually the
draw-command buffer — which is itself a flat list. Keep flattening at the seam
rather than growing a judge per module.

## The browser proof of concept

    ./harness/build_wasm.sh          # Codex -> zig -> wasm32-freestanding
    cd web && python3 -m http.server 9200

Serves the game's **own unmodified `blitter.js`** — symlinked, not copied —
against a wasm module computed in Codex. `blitter.js` fetches an absolute
`/driving/safari.wasm`, so `web/` is the document root and the module at that
path is the only thing that differs from the real game.

`poc/Scene.codex` is throwaway by design: it places its own scenery instead of
reading `world.zig`'s route, and carries its own Taylor sine because
`Gpu chapter DeviceMath` is dark to this arm. What it shares with the real thing
is the camera and the draw-command wire. 41 polygons — two mountain ranges, the
road and its dashes, the ported pond and its bank, six trees.

**NOTES §5 said a browser build through zig was "not close". It is three prelude
functions**, and `harness/wasmify.py` replaces them: the entry spawns a thread
only to get a 512 MB stack, the heap reserves 4 GiB through `page_allocator`
(the whole of a wasm32 address space), and printing drags in `std.Io`. Nothing
in the *transpiled program* changes — only the fixed prelude, which is why this
is a text pass over three known shapes and not a fork of the emitter. Each
substitution must match exactly once or the script refuses.

`poc/shim.zig` walks the Codex list and writes `paint.zig`'s wire. **The f64 ->
f32 narrowing happens there and only there** — the seam the hand-written zig
already narrows at.

## Decisions

**Dialect: `Real` (f64), not fixed point.** Codex `Real` is f64 in every plug
while the game is f32, so comparisons carry a tolerance. The alternative — a
fixed-point port in integer milli-units — was priced and rejected; see
`price-b/` and the measurements below.

**A failure names an index, not a value.** `show` on a Real is refused by the zig
plug, so `Grade` reports *where* a list first disagrees. When `real-to-int` lands
this becomes a scaled-integer dump and full-frame diffs.

**Gold is never checked in.** It is a second copy of the oracle, and a second
copy can quietly disagree with the first.

## What the pricing measured

Each of these came from a program that actually ran through the loop; the probes
are in `price-b/`.

- **`Math chapter Cordic` is unusable for a camera.** Its docstring claims ~0.1%;
  measured worst error is **0.45%** (`cordic-sin 300` = 291 vs 295.52). Upstream
  never caught it because `codex/test/forewords/math-cordic.expected` is the
  single line `Math/Cordic OK` — the test never calls a Cordic function. At that
  error a yaw swings distant scenery metres, frame to frame.
- **A hand-written scale-1e6 fixed-point sine reaches 3.6e-6** — 1241x better
  than Cordic, in ~40 lines. The math library was never the problem.
- **The scale ladder is.** Angles need 1e6; at that scale `groundDrop`'s
  `right² + forward²` already reaches 17.6% of i64 at 900 m.
- **Integer overflow wraps silently.** Codex declares `IntegerTy i64-min i64-max
  OvError`; the zig plug emits `*%`. `4000000000 * 4000000000` returns
  `-2446744073709551616`, exit 0, no diagnostic. Fixed point would fail as a
  wrong pixel with no signal.
- **The blocking plug hole is two table rows.** `real-to-int` and `real-from-int`
  are each one `ZigBuiltinEmitter` entry plus one prelude helper, exactly the
  shape of `bits-to-real-approx` at `ZigEmitter.codex:1036` / `:3784`.
  `real-from-int` alone is why `Gpu chapter DeviceMath` cannot be transpiled, so
  those rows also unlock `real-sqrt`, `real-sin` and `real-cos`.

## Findings owed upstream

Three, all found while pricing, none yet written up:

1. `OvError` silently becomes wrapping `*%` in the zig plug.
2. `Cordic`'s accuracy claim is wrong by 4.5x and its test never calls it.
3. A Codex function named `d` emits `fn d_` and collides with `Tup4`'s comptime
   parameter — single-letter names `a`–`d` are unusable in the zig arm.

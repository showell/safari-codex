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

    port/<Chapter>.codex        the port
    probe/probe_<chapter>.zig   the oracle, printing `<kind> <name> <values...>`
    judge/<Chapter>Check.codex  flatten each seam, hand it to Grade

The chapter name is written once and everything else is derived from it. The
probe is **snake_case, named after the game file it imports** — `GuardRail` gives
`probe/probe_guard_rail.zig` beside `wasm/guard_rail.zig` — and the gold chapter
is the name with `Gold` appended, so the check cites `Gold chapter <Chapter>Gold`.

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
reading `world.zig`'s route, and reaches sine through `Safari chapter Trig`
because DeviceMath's is dark to this arm. What it shares with the real thing is
the camera and the draw-command wire. 160 polygons, 51 of them gradient-filled —
two mountain ranges, the road and its dashes, the ported pond and its bank, **ten
conifers from the ported `tree.zig`** with cone crowns near and flat tiers far,
and **a guard rail from the ported `guard_rail.zig`**: twenty-one posts and a
twenty-quad bar strip receding to the horizon along the right shoulder.

The rail is the one thing in the frame that is **depth-sorted rather than placed
in paint order**. `rail-emit` hands back every bar and then every post, which is
the order the zig's store holds them in and the wrong order to paint — a far post
would land on a near bar. The scene sorts them on the `fwd` the port computes,
which is the smallest possible demonstration of what that field is for. Sorting
the rail *against the trees* is what the real render does and what this throwaway
does not; it gets away with a coarse band ordering only because the rail hugs the
shoulder while every tree stands well outside it.

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

## Ported so far

| chapter | ports | graded |
|---|---|---|
| `port/Pond.codex` | `wasm/pond.zig` | 48 values, exact |
| `port/Camera.codex` | `wasm/camera.zig` | with Geom below |
| `port/Geom.codex` | `wasm/geom.zig` | 375 values, 1e-6 relative |
| `port/Trig.codex` | **stand-in** for `Gpu chapter DeviceMath` | via the above |
| `port/Paint.codex` | `wasm/paint.zig`'s wire | with Tree below |
| `port/Tree.codex` | `wasm/tree.zig` | 45 commands + 628 coords |
| `port/GuardRail.codex` | `wasm/guard_rail.zig` | 670 values, both seams |
| `port/Sky.codex` | `wasm/sky.zig` | 148 values; **colours exact** |

**`Sky` is the first module that needed a plug change.** `skyColor` rounds a
lerped channel and packs three of them into one integer, so it needed
`real-to-int` and `real-from-int` — which the zig plug could not emit until
2026-08-29. The emitter that closed that is `plugs-backlog` row 2.03, on branch
`zig-plug-real-int-conversions`; `PLUG_WORK.md` is the provenance record. Both
colour streams are graded **exactly**, as integers, because a colour one off is a
wrong colour and no tolerance should be able to hide one.

`Trig` exists because DeviceMath's `dm-reduce` calls `real-from-int`, which had
no emitter when it was written, so `real-sin` and `real-cos` could not be
transpiled. **That reason is gone as of row 2.03, and it was checked rather than
assumed** — citing DeviceMath and calling `real-sin 100.0` transpiles, builds and
answers −0.506, which means `dm-reduce`'s reduction over sixteen turns is running.
Nothing in DeviceMath is dark to this arm any more.

So `Trig` is retirable, and it has NOT been retired. That is a deliberate hold,
not an oversight: **the swap is not a no-op.** Trig's `wrap` subtracts in a
bounded loop where `dm-reduce` divides by two-pi and converts back through the
integers, so the two disagree in the last bits, and four graded chapters
(`Geom`, `Camera`, `Tree`, and the browser `Scene`) cite Trig today. Retiring it
is its own change with its own regrade, worth doing on purpose rather than as a
footnote to a colour port. It is the same
algorithm. **Delete it and cite DeviceMath the day that emitter lands**, and do
not let anything else grow a dependency on its names.

It owes upstream **sine and cosine, and nothing else**. Emission is per-function,
not per-chapter, so a chapter can cite DeviceMath for the parts that do not reach
the hole: `real-sqrt` is a scaled Heron iteration that touches no conversion, and
`GuardRail` cites the real chapter for it and grades green. Before writing a
stand-in for any foreword chapter, check which of *its functions* actually reach
the hole — "this chapter is dark" is almost never true.

`GuardRail` is graded on **both of its halves**, because `guard_rail.zig` is
deliberately two. `emit` collects `RailPoly`s rather than drawing them, so the
judge reads the store directly — poly counts, colours, every corner, and **the
mean forward depth each poly sorts by**. That depth is the module's whole
contribution to render's one back-to-front pass over rails, trees and critters; a
rail sorted wrong is a rail a far tree paints over, which is the bug the
collect-then-sort design exists to prevent, and it is invisible to a check that
only looks at pixels. `drawPoly` is then graded on the wire as usual.

`Camera` makes one adaptation: the zig's `pub var view_w` is a mutable global,
so the port threads it as a parameter. It is the camera's only mutable state.

**Screen coordinates take a mixed gate, `atol + rtol*|want|`, and both halves
are load-bearing.** A purely relative gate fails at the horizon: a screen `y` is
`300` minus a term of about the same size, so `y = 20.6` is a small difference of
two large numbers and cancellation amplifies f32's relative error about fifteen
fold. A purely absolute gate fails at the near plane: a point 37 m to the side at
0.4 m forward projects to `x = -62929`, where one f32 ulp is already 0.0075 px.
Both cases are in the tables. The floor governs the canvas, the relative term
governs what the near plane flings off it.

**The 1e-6 relative tolerance is calibrated, not slack.** Tightened to 1e-7, six
of the nine seams go red — the true error straddles f32 epsilon (1.19e-7),
which is exactly the width gap and nothing else. Perturbing `eye-h` by 1e-4
reddens `project` at index 1 and not index 0, because *x* does not read
`eye-h` and *y* does.

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

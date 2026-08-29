# safari-codex

A port of the Safari driving screensaver from Zig to **Codex**, verified against
the Zig it came from.

The Zig version stays intact and keeps running on lynrummy.com/driving. This is a
parallel port, not a migration. `NOTES.txt` is the research brief that opened the
project and is still the best single orientation; this file is the part that has
been built.

## The loop

    ./harness/run.sh

That is the whole interface. With no arguments it runs every check in `judge/`;
name one or more chapters to run just those. It prints `GREEN` or `RED`. For each
module it:

1. builds `probe/probe_<mod>.zig` and runs it — the probe imports the **real,
   unmodified** game module, so the hand-written Zig is the oracle;
2. writes its answers to `gold/<Mod>Gold.codex`, regenerated every run;
3. bundles the check with `harness/bundle.py`;
4. transpiles it with `codexzig`, builds the Zig, runs it, and grades.

**Twenty-nine seconds cold, three seconds when nothing has changed.** It was nine
minutes. Two things fixed that, and both are worth knowing:

`zig build-exe -O ReleaseFast` cost 22s per invocation and ran twice per module.
That is *not* our code being optimised — a two-line program whose whole body is one
`std.debug.print` costs the same 22s, and 1,200 extra lines of generated Codex cost
0.05s. It is LLVM compiling zig's own formatting machinery on a two-core box.
Nothing here is a benchmark, so both builds are Debug, which also turns on the
safety checks a correctness harness wants.

Then the sweep **skips what has not changed**, keyed on a hash of the bundled unit —
which *is* the transitive closure of every `cites` edge, so there is no dependency
list to keep in step. The gold's own hash is folded into its key, which is what
keeps the promise below that a hand-edited gold cannot survive one run.
`PORTING_NOTES` C9 and C10 have the measurements.

    ./harness/run.sh Render          # just one module, about 3s

**Nothing here boots a QEMU guest** — this is not the ladder's usual cadence, and
none of the ladder's compute rules apply.

## Layout

| directory | holds | written by |
|---|---|---|
| `port/` | the port itself — Codex chapters, quire `Safari` | hand |
| `judge/` | graders and check roots, quire `Judge` | hand |
| `gold/` | gold chapters, quire `Gold` | **generated, then tracked** |
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

Serves the game's **own unmodified `blitter.js`** — symlinked, not copied — against
a wasm module computed in Codex. `blitter.js` fetches an absolute
`/driving/safari.wasm`, so `web/` is the document root and the module at that path
is the only thing that differs from the real game.

**`poc/Drive.codex` drives the real route.** Nothing in the frame is placed by
hand: the road and its corners, the conifers, the intersection towers, the guard
rails and the pond all come out of `Safari chapter World` — the same nineteen
segments graded at 3,822 values — mapped by `Render`'s chain, ordered by `Render`'s
depth sort, and floored by `Render`'s ground pass. 2,132 draw commands in the
opening frame. `u` runs 0..1 and walks the whole course by arc length; Space
auto-plays, the arrows step, J jumps a segment.

`poc/Scene.codex` is the original throwaway that placed its own scenery, kept
because it still builds and is the way to compare:

    ./harness/build_wasm.sh SceneMain

**What is not real about the Drive page, precisely.** The animals are missing —
cows, pigs, the corner elephants and giraffes, the ducks and the cat all reach the
baked polygon tables, so they are collected and depth-sorted but draw nothing, and
a frame has correctly-ordered holes where each one stands. The truck drives and its
body reaches unported chain machinery. And the rider is not simulated: `Rider` is
ported and graded, but it is a step function over mutable state while the shim's
scrub is pure — `frame-at (u)` must answer from `u` alone — so the camera runs dead
centre of the lane at constant speed with no lean, no gaze and no throttle. The one
invented number on the page is the backdrop heading, blended across each corner
because a segment's `north-heading` is a step function and the mountains would
otherwise snap sideways at every joint.

**NOTES §5 said a browser build through zig was "not close". It is three prelude
functions**, and `harness/wasmify.py` replaces them: the entry spawns a thread
only to get a 512 MB stack, the heap reserves 4 GiB through `page_allocator`
(the whole of a wasm32 address space), and printing drags in `std.Io`. Nothing
in the *transpiled program* changes — only the fixed prelude, which is why this
is a text pass over three known shapes and not a fork of the emitter. Each
substitution must match exactly once or the script refuses.

`poc/shim.zig` walks the Codex list and writes `paint.zig`'s wire. **The f64 ->
f32 narrowing happens there and only there** — the seam the hand-written zig
already narrows at. It also rewinds the bump heap once per frame, which is what
lets a page that allocates and never reclaims run indefinitely; `PORTING_NOTES` C8.

## Looking at one thing: the spike loop

    ./harness/spike.sh          # then http://localhost:9200/spikes/

**Throwaway by design and graded by nothing.** `poc/Spike.codex` renders single
still frames at hand-picked points on the route, and `harness/spike_svg.py` turns
them into flat SVGs — no wasm, no blitter, no animation. A picture you can open is
a faster loop than a page you have to drive to the right spot. `run.sh` does not
call any of it; delete the three files and nothing else changes.

What it adds to a normal frame is **markers for what is collected but invisible**.
Cows, pigs, the corner animals and the ducks are placed, mapped, projected, culled
and depth-sorted by the ported render, and then draw nothing, because their art is
615KB of baked polygons that are not ported. A marker is a plain box at the
billboard's own screen footprint — same anchor, same height, same depth order,
coloured by species. It is not what the animal looks like; it is exactly *where*
the animal is, which is the part this port is responsible for.

That turns out to check things. The pig-herd viewpoint draws **exactly 49 pig
markers**, which is the 7×7 distraction block `w-npigs` records for segment 2, all
of them surviving the culls; the duck pond draws six ducks and the corner pairs
draw two apiece. Four viewpoints ship: the big pig herd, the mid-tower on the
1200m leg, the duck pond, and a corner zebra pair.

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
| `port/Mountains.codex` | `wasm/mountains.zig` | 2,204 values, both seams |
| `port/Tower.codex` | `wasm/tower.zig` | 1,485 values; the beacon disc |
| `port/Num.codex` | — | round, floor, mod: **gaps in the foreword** |
| `port/World.codex` | `wasm/world.zig` | 3,822 values, the whole route |
| `port/Cat.codex` | `wasm/cat.zig` **minus `draw`** | 484 values, crossing clock |
| `port/Pose.codex` | `RiderState`, split out to cut a cycle | with Rider |
| `port/Gaze.codex` | `wasm/gaze.zig` | with Rider |
| `port/Rider.codex` | `wasm/rider.zig` | 199 values, **one step from a shared state** |
| `port/Truck.codex` | `wasm/truck.zig` **motion only** | 29 values, one step |
| `port/SafariCritter.codex` | `wasm/safari_critter.zig` | 92 values, **complete** |
| `port/Render.codex` | `wasm/render.zig` **minus the baked-frame drawers** | 8,389 values |


**`Render` is the first module whose CHECK was shaped by the zig's `pub`
markers rather than by its own structure.** render.zig's entire public surface is
four names — `Chain`, `Pose`, `at`, `frame` — and `buildChain`, `Mapper`, `mapPt`
and all four ground and rail emitters are private to the file. Every module before
this one had a pub function per seam, so "the probe calls the real thing" was free;
here it is not, and RenderCheck grades three different strengths and says which is
which. `at` is a real oracle. The behind-joint mapper is graded by its definition —
`geom.curToNext` then `geom.toRider`, both pub — so every arithmetic step is
oracled and only the order is not. The chain is the weak one: `at` never consults
the caps, so the chain's *extent* is not observable from outside render.zig at all,
and `LOOK_AHEAD` and `MAX_CHAIN` are the only values in this port transcribed from
source rather than measured. **The way out is already in the file** — `cull_seg` is
pub and sums the herds over chain indices 3 and up, so the collection pass turns
the chain's extent into a number WorldCheck's graded counts predict. See
`PORTING_NOTES` E1.

**The collection pass is in: the chain walk, both culls, and the unified depth
sort.** What `frame` gathers — trees, towers, the cow and pig herds, the corner
safari pairs, the pond ducks, the guard rails and the chased truck — and the one
back-to-front order over the lot. What is *not* here is the ground: the road
strips, corner pavement and the pond's water and bank are painted inside the same
walk, but they are quads on the floor that never enter the sort, so they belong to
the paint pass.

**`cull_seg` and `cull_size` turned out to be a much stronger check than two
integers sound like**, and they are what closed E1's transcribed caps. A size tally
is wrong unless every farm animal, corner creature and duck was placed in the right
frame, mapped, projected and measured against the right focal — and the critters
cull on the *stable* base focal while the trees cull on the live one, so a port that
used the same focal for both fails. A seg tally is wrong unless the chain stopped in
exactly the right place: the state on segment 16 has a three-long chain that never
reaches the farm cull's third index, so its tally is zero, and that is the chain's
extent made observable from outside render.zig.

**All seven collected kinds are in, including the cat.** What unblocked it was not
writing the logarithm its `pow(b, 0.7)` seemed to need: **0.75 is dyadic where 0.7
is not**, so `sqrt(b * sqrt(b))` *is* b^0.75 exactly, using a square root both
languages already have. That is the port's **one deliberate approximation**, and it
is bounded rather than hand-waved — `|b^0.7 - b^0.75|` peaks at 0.0254, the leap
spans 4.306m, so nothing can be more than 0.109m out, and it is zero at both ends
so the cat launches and lands in exactly the right places.

`CatCheck` grades that honestly by splitting the stream: 235 non-airborne samples
at the ordinary width tolerance, 7 airborne ones at a gate sized to the bound, and
the **pose index exactly on all 242** — an approximation to the arc must never flip
which still is drawn. The game is not changed to suit the port.

**The sort is the one place the port departs from the zig on purpose.** render.zig
insertion-sorts, which is right for a mutable array. Carried literally onto Codex
lists it exhausted the whole 4 GiB bump heap: there is nothing to shift, so
rebuilding the tail past each insertion allocates a list per element and the sort
goes cubic in allocations. A *stable* merge sort gives the identical order — same
comparison, same tie rule — at roughly a hundred megabytes. Porting an algorithm
faithfully means porting its answer, not its cost model; `PORTING_NOTES` E4.

**The ground pass is in too**, so `frame` is now ported end to end apart from three
calls: the road strips sliced every 25m so a bend reads smooth, each corner's
approach road and pavement quad out to the apex, and the pond's water and bank. It
graded green at the standard screen gate on the first run — no recalibration, which
is what you would hope for by the tenth module.

Still not ported: `frame`'s draw dispatch for critters, the cat and the truck body
— `critter.draw`, `cat.draw` and `truck.drawBody`, the three that reach the baked
frames. Everything else in a frame is now computable in Codex.

**`Render` also needed the mixed gate in METRES**, which no world-coordinate seam
here had before. `at` composes a point down a kilometre of chain and hands back one
a metre or two off the rider's nose — 815x amplification, measured — so the error
tracks the largest coordinate the composition passes through rather than the size
of the answer. That makes the floor a representation granularity, and it is set as
one: one f32 ulp at the range each seam reaches, 2.5e-4 m for the chain and 6e-5 m
for the behind joint. Both are load-bearing; each reddens within about 2x below its
setting. `PORTING_NOTES` D6 has the numbers.

**`SafariCritter` is a whole file, and it is worth noting why** when its neighbours
arrive in halves: it is placement only, so nothing in it reaches the baked frames.
`cornerCritters` is pub, so it gets a real oracle, and it is graded inside
RenderCheck rather than growing a fourth build for sixty lines.

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

**`Rider` is seam 4, and it is graded the only way that works.** The lean comes
from a binary search — twelve iterations, each deciding on one float comparison
after simulating up to two thousand physics steps — so a 1e-7 f32/f64 difference
will eventually flip one and put the two rides on different trajectories. A trace
comparison would go red and mean nothing. Both sides are handed **the same state
N** and only **state N+1** is compared, so drift cannot accumulate and a failure
points at one step. That is NOTES' prescription for this seam.

`Pose` exists to cut a cycle: the zig has `rider.zig` and `gaze.zig` importing
each other, which Codex cites cannot do, so the record they share gets its own
chapter. No logic moves.

**`Mountains` is where the arc tangent is graded.** `Trig` grew an `r-atan`,
because `Gpu chapter DeviceMath` has none — its whole surface is min, max, abs,
sqrt, sin and cos, and the foreword's other arc tangents are integer milli-unit
routines. So that one is a gap in Codex's foreword rather than a hole in the
plug, and it does **not** go away when the rest of `Trig` is retired. It matches
zig's `atan` to 1e-9 over eighteen values including the reciprocal branch; the
mountains check catches a 1e-5 relative error in it, so there are four decades of
margin.

Its coordinates are graded at **every eighth point**, and that is a toolchain
ceiling rather than a choice: four frames at full density are 16,868 coordinates,
and `codexzig` exhausts its own 4 GiB bump heap on a Real literal that size. Point
counts stay exact, so a silhouette that gained or lost a column still fails hard.
See `PORTING_NOTES` C7.

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

**Gold is generated every run, and tracked anyway.** It is a second copy of the
oracle, and the worry that put it in `.gitignore` at first was that a second copy
can quietly disagree with the first. That worry is real but it is not load-bearing
here: `harness/gen_gold.py` rebuilds every gold chapter from the zig probe on every
sweep, so a stale or hand-edited gold cannot survive a single `./harness/run.sh` —
it is overwritten before it is ever read. What tracking buys is a reviewable diff:
when a port changes an answer, the gold moves in the same commit and you can see
which values moved and by how much, which is exactly what a Real-valued check
cannot tell you at the console.

The rule that still holds is **never edit `gold/` by hand.** Every file there says
so in its own header, and the next run will overwrite it regardless.

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

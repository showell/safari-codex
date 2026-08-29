# safari-codex

A port of the Safari driving screensaver from Zig to **Codex**, verified against
the Zig it came from.

The Zig version stays intact and keeps running on lynrummy.com/driving. This is a
parallel port, not a migration.

Four documents, and they do not overlap. **This file** is the orientation: what
exists, how to run it, and the method. **`PORTING_NOTES.txt`** is the lessons file
— forty-five numbered notes on the toolchain, the language, the tolerances and the
seams, and the first thing to read before writing a Codex chapter.
**`PLUG_WORK.md`** records the emitter change the port needed and why it was
branched where it was. **`NOTES.txt`** is the research brief that opened the
project; it is history now and several of its predictions were wrong in useful
ways, which this file notes where it matters.

## The trees this builds against

Four checkouts, and the port is only one of them. Branches matter here: two of
these are on branches made for this work and the port does not build on `master`.

| tree | branch | what it is |
|---|---|---|
| `~/showell_repos/safari-codex` | `master` | **this repo.** The port, the checks, the harness. No remote; local checkpoints only. |
| `~/showell_repos/angry-gopher` | `master` | **the game being ported.** `games/driving/wasm/*.zig` is the Zig under test; `probe/wasm` here is a symlink to it. Read-only from this project — the port never edits the game. |
| `~/showell_repos/NewRepository` | `u52-rebank` | **Cobblestone**, the Codex language and its foreword. Shared and read-only; many worktrees hang off it. `CODEX_ROOT` points here. |
| `~/showell_repos/codex-zig-transpiler` | `real-int-conversions` | **builds `codexzig`**, the Codex→Zig transpiler this whole loop runs on. |
| `~/showell_repos/cobblestone-realconv` | `zig-plug-real-int-conversions` | a **worktree of NewRepository** holding the plug work — the emitter changes the port needed. `PLUG_WORK.md` is its record. |
| `~/showell_repos/codex-zig-ladder` | `master` | borrowed for one file: `cite_resolve.py`, which `harness/bundle.py` imports rather than restating. Override with `SAFARI_LADDER`. |

**`codexzig` is why this project moves at all.** It is one program — Codex source
in, Zig out — built by `codex-zig-transpiler/build.py` into
`generated/local/codexzig`, and `harness/run.sh` takes it from `$CODEXZIG` or that
path. Building it the first time costs QEMU guests, because the seed compiler
emits x86 rather than Zig and the emitter has to be booted before there is any Zig
to compile. **Once it exists, nothing in this project boots a guest.** That is the
whole reason a sweep is thirty seconds instead of a ladder-scale job, and it is
why the transpiler's branch is worth knowing: the binary on disk was built from a
specific commit, and `codex-zig-transpiler/generated/PROVENANCE` names it.

Two environment variables and one tool path are all the loop needs:

    CODEX_ROOT    ~/showell_repos/NewRepository       the foreword chapters
    SAFARI_LADDER ~/showell_repos/codex-zig-ladder    cite_resolve.py
    CODEXZIG      .../generated/local/codexzig        the transpiler
    ZIG           ~/zig-0.16.0/zig                    0.16.0

## Porting philosophy: pragmatic best effort

**Find the seams in the game, cross-check both sides at them, and be explicit
about every place the two are allowed to differ.** That is the whole method, and
the second half matters as much as the first.

A seam is a place where the game computes something a probe can read: a returned
value, a collected store, the draw-command buffer. At each one, a Zig probe
imports the **real, unmodified** game module and prints what it computed; the
Codex port computes the same thing; a grader compares them. Where a function is
`pub`, the probe calls it and the comparison is exact in kind. Where it is not,
the check says so and grades what it can — `PORTING_NOTES` E1 works through what
`render.zig`'s four public names did to its check.

**This is not a bit-exact port and does not try to be.** Codex `Real` is f64 in
every plug while the game computes in f32, so every computed number differs
somewhere in the last bits, and the tolerances that absorb that are measured
rather than chosen — section D of `PORTING_NOTES` is the record of what each one
had to admit and why. Structure never gets a tolerance: point counts, colours,
tags and indices compare exactly, because a wrong count is a wrong shape and no
coordinate slack should be able to hide one.

Where the port deliberately differs from the game, it says so at the definition
and the check gates it at a measured bound rather than waving it through. There is
exactly one such place today — the cat's airborne arc, which uses `b^0.75` where
the game uses `pow(b, 0.7)`, bounded at 0.109m and zero at both ends.

Three rules that fell out of doing it:

- **The game is never edited to suit the port.** It is the oracle and it ships.
- **Port the answer, not the cost model.** An in-place algorithm carried literally
  onto persistent lists can gain a whole complexity class (`PORTING_NOTES` E4).
- **Where a name is not pinned by a check, take the better name.** Where it is
  pinned, fidelity wins.

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
depth sort, and floored by `Render`'s ground pass. 2,430 draw commands in the
opening frame, sixteen of them the truck. `u` runs 0..1 and walks the whole course by arc length; Space
auto-plays, the arrows step, J jumps a segment.

`poc/Scene.codex` is the original throwaway that placed its own scenery, kept
because it still builds and is the way to compare:

    ./harness/build_wasm.sh SceneMain

**The truck is on the page now, and it was the last thing missing.** It needed
three separate wirings, and the reason it had sat unfinished is that none of them
alone changes anything visible:

- `Drive.codex` passed a hardcoded `0.0` for the truck's route position into
  `collect`, so its lead was always negative and it was never collected;
- `poc/drive_shim.zig` kept no truck state, so nothing called the ported
  `truck-next` to move it;
- `draw-item`'s `KTruck` arm returned nothing, because `truck.drawBody` was not
  ported.

All three are done. The shim keeps a `TruckStateS` beside the rider's and steps it
in lockstep against the **new** rider distance, which is `safari.zig`'s own order;
the history ring scrubs both together, so the down arrow rewinds the chase as well
as the ride; and `port/TruckBody.codex` draws the body, graded at 2,962 values
against `truck.drawBody` itself.

Measured over one drive: the lead runs 500 m at the line down to 68 m by frame
6,000 — the photo finish the schedule is written for — the brake lights fire on
846 of 6,400 frames, and the headlights come on around frame 4,500 when the sun
drops behind the crest. `truckLead`, `truckV` and `truckBraking` are exported for
a probe, as `safari.zig` exports them for its HUD.

**So nothing on the page is a stand-in any more**: the route, the rider's own
physics and lean, the animals, the cat, the sky clock and the chase are all the
real thing. What remains not-real is one *rendering* gap rather than a wiring one —
the bull's gradients still flatten to their first stop in the baked table.

**NOTES §5 said a browser build through zig was "not close". It is four
substitutions in the fixed prelude**, and `harness/wasmify.py` makes them: the
entry, which spawns a thread only to get a 512MB stack; the two print functions,
which drag in `std.Io`; the heap reserve, which asks for 4GiB (the whole of a
wasm32 address space); and `cx_heap_base`, which wants a `page_allocator` that
does not exist there and becomes a static `.bss` region. Nothing in the
*transpiled program* changes, which is why this is a text pass over four known
shapes rather than a fork of the emitter. Each must match exactly once or the
script refuses, so a drifting prelude fails loudly.

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

**The animals draw themselves now**, so a still shows exactly what the browser
shows rather than an approximation of it. The spike used to emit a marker box and
have the SVG script read the game's baked art off disk; it no longer needs to.
Only the cat still uses that trick, because its flipbook is a second table that is
not generated yet.

That turns out to check things. The pig-herd viewpoint draws **exactly 49 pig
markers**, which is the 7×7 distraction block `w-npigs` records for segment 2, all
of them surviving the culls; the duck pond draws six ducks and the corner pairs
draw two apiece. Eight viewpoints ship: the big pig herd, the mid-tower on the
1200m leg, the duck pond, a corner zebra pair, the cat frozen and mid-leap, and the
truck in daylight and at dusk.

**The truck stills are a second BINARY, and the reason is PORTING_NOTES C6.** The
spike prints one frame per viewpoint and never rewinds its arena — the per-frame
reset is a thing the wasm shim does, and a native binary has no shim — so a run
holds every frame it has printed, at about 700 MB each. Six came to within 1.8 KB
of the 4 GiB reserve and the seventh aborted. A second process starts fresh, so
`poc/SpikeTruckMain.codex` carries the two truck viewpoints, `poc/SpikePrint.codex`
holds the printing both entries share, and `harness/spike.sh` runs both. Sharing by
citing the *first entry* is what does not work: two `opening`s in one bundle
collide on the flat namespace.

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
| `port/TruckBody.codex` | `wasm/truck.zig`'s `drawBody` | 2,962 values, **113 commands in order** |
| `port/SafariCritter.codex` | `wasm/safari_critter.zig` | 92 values, **complete** |
| `port/EmojiStills.codex` | `wasm/emoji_frames.zig` | **generated**, 5,267 points |
| `port/Critter.codex` | `wasm/critter.zig` | 6,174 values, 7 species exact |
| `port/CatStills.codex` | `wasm/cat_frames.zig` | **generated**, 7 poses |
| `port/CatDraw.codex` | `wasm/cat.zig`'s `draw` | 9,993 values |
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

Every drawer `render.zig` dispatches to is ported now. `truck.drawBody` was the
last one, and `port/TruckBody.codex` has it; the critter and cat drawers that used
to sit beside it in this sentence went first.

**`Render` also needed the mixed gate in METRES**, which no world-coordinate seam
here had before. `at` composes a point down a kilometre of chain and hands back one
a metre or two off the rider's nose — 815x amplification, measured — so the error
tracks the largest coordinate the composition passes through rather than the size
of the answer. That makes the floor a representation granularity, and it is set as
one: one f32 ulp at the range each seam reaches, 2.5e-4 m for the chain and 6e-5 m
for the behind joint. Both are load-bearing; each reddens within about 2x below its
setting. `PORTING_NOTES` D6 has the numbers.

**`TruckBody` grades a command SEQUENCE, and that is a stronger assertion than a
picture.** `truck.drawBody` is `pub` — render.zig's own comment says so and names
the truck as the reason — so the probe calls the game's function and reads the
words it wrote on paint's wire. The order of the 113 commands across six cases
carries the depth sort, the sixteen faces, and the three-phase sequence (beams,
body, lights) all at once: a face sorted one place wrong shows up as two swapped
colours before any coordinate moves, and a beam pushed after the body instead of
before it moves a tag 4 past sixteen tag 0s.

Two things about it are worth carrying forward. **The zig's comments say the
headlight wedges and the brake glow are still deferred, and they are stale** — the
code calls both and pushes tag 4 for each. A port written from the comments would
have emitted sixteen faces where the game emits twenty-four commands; read a
comment for intent and the code for behaviour (`PORTING_NOTES` E5). And **the
clipping case sets the loosest screen gate in the port**, 1.5e-5 against everyone
else's 1e-6, on one tire vertex in the case where the truck is two metres ahead and
the trailer rear is behind the eye. A clipped vertex sits at `forward = near = 0.4`
by construction, so the projection amplifies an error in metres by 1,713x; one f32
ulp at the rider's own 100 m `along` is 0.013 px at an x of −1300, which is the
1e-5 measured. It is the near plane's looseness, not the truck's — the same seam
holds at 1e-6 wherever nothing is clipped (`PORTING_NOTES` D8).

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
not an oversight: **the swap is not a no-op.** Trig's `wrap` subtracts in a bounded
loop where `dm-reduce` divides by two-pi and converts back through the integers, so
the two disagree in the last bits — and a lot of the port now cites Trig, directly
or through `Geom`. Retiring it means regrading every one of those, which is its own
change and deserves to be made on purpose rather than as a footnote to something
else. **Do not let anything new grow a dependency on its names**, and when it goes,
expect tolerances to need re-measuring rather than assuming they carry over.

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

## Stills, not frames

`emoji_frames.zig` and `cat_frames.zig` are the game's names and they read like
*animation* frames. They are not. `emoji_frames` is **one still per species** —
eight of them, 129 polygons in all — and the animals never animate; they are static
billboards that scale with distance. `cat_frames` is a **seven-pose flipbook**.
Every bit of motion in this port is computed per frame, not looked up.

So the port calls them stills: `port/EmojiStills.codex`, generated by
`harness/bake_emoji_stills.py` from the table the game's baker already emitted.
Hand-carrying 5,267 points would be the wrong shape of work and would rot the
moment the baker ran again — `NOTES` §5 says so. It is tracked like the gold
chapters and regenerated by script, never edited.

**Where a name is not pinned by a seam check, the port takes the better name.**
Where it *is* pinned — anything a check compares against the zig — fidelity wins.

**The bull draws flat**, and it is the only one that does. It is the sole Fluent
Color animal and 40 of its 43 polygons carry a 2-stop gradient, which `paint.zig`
writes as wire tags 5 and 6 that `Paint` does not model yet, so the generator
flattens each to its first stop. The other seven species are graded exact on the
wire — 5,916 coordinates against the real `critter.draw`. The bull becomes
gradeable the day `Paint` grows the two tags.

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

## Where to pick this up

Parked 2026-08-29 with the sweep green, **and with every drawer in the game
ported** — the truck was the last one. In rough order of value:

**The bull draws flat, and the pieces to fix it now exist.** `Paint` has tags 5
and 6; what is missing is that `harness/bake_stills.py` flattens each gradient to
its first stop rather than emitting it, and `Critter` has no gradient arm. Doing
both makes the bull gradeable, which is why `CritterCheck` excludes it today.

**`safari.zig` is not ported**, and `poc/drive_shim.zig` currently reimplements a
slice of it — the restart at the finish line, the history ring, the frame clock —
in Zig, ungraded. Porting it would move that logic behind a check. It is also
where the camera's focal pull-in during a lean and gaze lives (`cam-focal`,
`focal-for-lean`, `focal-for-gaze` are all ported and none is wired), and that in
turn wants `cat.focus`, which is not ported.

**`Trig` is retirable and retiring it is a real change**, not a cleanup — see the
section above. Expect to re-measure tolerances rather than assume they carry.

**Four findings are owed upstream** and none is written up; they are listed below.

Three things that are *done* and might not look it from the commit log: the cat is
fully ported including its flipbook, the animals draw from generated stills, and
the truck now drives, brakes and lights the road. **Nothing is missing from a
frame** — the remaining gaps are fidelity (the bull's gradients) and coverage
(`safari.zig` itself), not absence.

## Findings owed upstream

Four. None yet written up, and they are owed to two different projects.

To **Cobblestone / the Zig plug**:

1. `OvError` silently becomes a wrapping `*%`. `4000000000 * 4000000000` returns
   `-2446744073709551616`, exit 0, no diagnostic.
2. `Math chapter Cordic`'s accuracy claim is wrong by 4.5x — the docstring says
   ~0.1%, measured worst is 0.45% — and its test never calls a Cordic function.
3. A Codex function named `d` emits `fn d_` and collides with `Tup4`'s comptime
   parameter, so single-letter names `a`–`d` are unusable in the Zig arm.

To **angry-gopher**, found while reading `paint.zig` for the gradient layouts:

4. `pushGradPoly` writes **seven** header words — tag, two colours, cx, cy, r,
   count — but bounds-checks against `6 + pts.len * 2`. It under-counts by one
   word, so it can overrun by one with the buffer one word from full. Latent, and
   the sibling `pushLinearGradPoly` / `pushRadialGradPoly` both count correctly.

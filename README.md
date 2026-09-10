# safari-codex

**A driving screensaver, written in Codex, that we own outright.** It began as a
port of a Zig original; the port is finished and eye-tested, and what it is now
is a real application in the language and one of the most demanding customers
the Codex toolchain has. `FINDINGS.md` and `WASM_FINDINGS.md` are the defects it
found; `PORTING_NOTES.txt` is the lessons file, the first thing to read before
writing a Codex chapter.

**Fidelity to the Zig original is no longer a constraint**, and the chapter
boundaries are ours, chosen for cohesion. The `A port of wasm/<x>.zig` line at
the top of a chapter is provenance, not a promise.

## The unit tests: `spec/`

`spec/` holds 54 self-checking Codex chapters, one per chapter of `port/`. A
spec carries its own expected values as literals and prints its own verdict --
`name ok N` per graded seam, `BAD` on a miss -- so any arm that runs Codex
renders that verdict alone. `spec/Grade.codex` (quire `Spec`) is the one grader:
every seam flattens to a list of Reals, Integers or Booleans.

    ./spec/run.sh        the edit loop: every spec on the Rust interpreter, seconds
    ./spec/export.py     freeze every spec into units/ -- the resolved program
                         beside its verdict as <Spec>.expected

**Every other arm grades safari from the OUTSIDE.** `units/` is a corpus like
any other -- self-contained `.codex` beside `.expected` -- and
`cobblestone-curated-tests/arms/*` take it as they take the curated and Roc
corpora: the zig plug (`run-zig`), the wasm plug (`run-wasm`), our own IR through
the zig plug (`ir-zig`), and the two frozen IRs (`freeze-upstream-ir`,
`freeze-rust-ir`, `ir-rust`, `ir-diff`). Nothing downstream knows what a spec,
a floor or a cite is.

    cd ~/showell_repos/cobblestone-curated-tests
    arms/run-zig ~/showell_repos/safari-codex/units

`units/` is tracked: the `.expected` files almost never change, the frozen IRs
change when the pin moves or when the Rust compiler changes on purpose, and the
diff of a re-export is the review.

Four rules the specs are held to, each of which caught something:

- **Derive, then confirm. Never capture.** `NumSpec`'s rounding table rederived
  with the obvious `floor(|x| + 0.5)` walks straight back into the bug `Num`'s
  docstring records fixing.
- **Measure the tolerance by tightening it until it breaks**, and say what it
  had to admit. Most lines grade at exactly 0.0.
- **Grade what the chapter decides, not what it delegates.**
- **A spec must not be able to pass by doing nothing.** `spec/floors.tsv` gives
  each spec the fewest graded values it must still be checking; `run.sh` and
  `export.py` refuse below the line. A floor, not a gold: `>=`, so adding
  assertions never churns the file. `spec/mutate.py` is a one-off authoring
  tool for watching a new spec fail once.

**`units/arm-gaps.tsv` is where a filed disagreement lives.** A unit whose
output through a named arm differs for a reason already reported upstream is
named there with its issue, reported every run as `differs-filed`, and not
fatal. **The `.expected` is the CORRECT value and the arm is what is wrong**:
rewriting a correct test to match a broken implementation buries the defect and
then defends it. A line there is a promise to remove it. Today's three are the
issue-125 Real literals, which both plugs still round the old way.

**Two hazards that cost red lines.** Codex refuses a bare `==` between Reals
(CDX2085 -- say `~` or `~0`) and refuses an application whose arguments continue
onto the next line (CDX1070 -- bind it with a `let`). The Rust interpreter
accepts both, so a spec can be green on the edit loop and stop the zig arm
emitting at all; that is what the outside arms are for.

**The baked stills stay in, but held to a budget.** `CatStills` and
`EmojiStills` are hundreds of KB of generated literals (`harness/bake_stills.py`)
and the likeliest thing here to find a front-end limit. What costs is NAMING a
table, not walking one (`PORTING_NOTES` B13), so each table is reached once.

## The trees safari borrows

`pins.tsv` names the two bundles: `codexzig` and `codexwasm`. **Safari does not
pin the language**: `harness/cobblestone_pin.py` reads the checkout each borrowed
transpiler recorded in its provenance, requires the two to agree, and refuses
otherwise. **This project builds neither transpiler**; `harness/build_codex{zig,wasm}.sh`
resolve the pin, check the binary against its tree, print the path, and refuse
a stale one. `CODEXZIG=`/`CODEXWASM=` override for a candidate build.

## Layout

| directory | holds | written by |
|---|---|---|
| `port/` | the port itself -- Codex chapters, quire `Safari` | hand |
| `spec/` | the 54 specs, `Grade`, the floors, the runner and the exporter, quire `Spec` | hand |
| `units/` | every spec resolved, with its frozen verdict and IRs, and `arm-gaps.tsv` | `spec/export.py`, the arms |
| `poc/` | browser ENTRY chapters, quire `Poc` -- throwaway by design | hand |
| `harness/` | the browser build, its oracle and dev server, the stills baker, the pin | hand |
| `web/` | the browser page: this project's FORK of `blitter.js`, plus the wasm | mixed |
| `price-b/` | the fixed-point measurements behind the dialect decision | one-off |
| `spike/` | the original feasibility spike | historical |

Three files in `harness/` answer to the browser: `blitter_oracle.js` reads the
shading recipe and thresholds out of the frozen original, `blitter_diff.js` runs
the fork and the original side by side over a recording canvas (run it by hand
after touching `web/blitter.js` or `port/Blit.codex`), and `paint_probe.js` hands
the real module's buffer to the real blitter for 300 frames at the end of
`build_wasm.sh`. `serve.py` serves `web/` with `no-store`.

**Retired 2026-09-10:** the `judge/` checks, the `gold/` chapters, the zig
`probe/`s that generated them, and the harness sweep, bare-metal and two-road
wasm arms that ran them. They were the port's faithfulness instrument and the
port is done; the specs grade every chapter, the outside arms grade every
plug, and cobblestone-qemu answers for bare metal. Git history holds them.

## The browser proof of concept

    ./harness/build_wasm.sh          # Codex -> zig -> wasm32-freestanding
    ./harness/serve.py               # web/ on :9200, no-store

Serves **this project's fork of `blitter.js`** against a wasm module computed in
Codex. `blitter.js` fetches an absolute `/driving/safari.wasm`, so `web/` is the
document root, and `harness/serve.py` sends `no-store` on everything because a
cached module is indistinguishable from a build that changed nothing.

**The fork used to be a symlink into `HISTORICAL_WASM_ROOT/`,** back when the
module at that path was the only thing here that differed from the real game. It
is a real file now: the browser half held decisions -- a shading recipe and four
visibility thresholds -- and those have moved into `port/Blit.codex`, where they
can be run and graded. The original stays untouched and is the oracle;
`harness/blitter_diff.js` runs both over a recording canvas, by hand, and
demands the same picture out of the two different wires.

**`poc/Drive.codex` drives the real route.** Nothing in the frame is placed by
hand: the road and its corners, the conifers, the intersection towers, the guard
rails and the pond all come out of `Safari chapter World` — the same nineteen
segments, graded seam by seam by `WorldSpec` — mapped by
`Render`'s chain, ordered by `Render`'s depth sort, and floored by `Render`'s
ground pass. 2,430 draw commands in the
opening frame, sixteen of them the truck. `u` runs 0..1 and walks the whole course by arc length; Space
auto-plays, the arrows step, J jumps a segment.

`poc/Scene.codex` is the original throwaway that placed its own scenery, kept
because it still builds and is the way to compare:

    ./harness/build_wasm.sh SceneMain

**The truck is on the page.** It needed
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
as the ride; and `port/TruckDraw.codex` draws it, graded at 2,962 values
against `truck.drawBody` itself.

Measured over one drive: the lead runs 500 m at the line down to 68 m by frame
6,000 — the photo finish the schedule is written for — the brake lights fire on
846 of 6,400 frames, and the headlights come on around frame 4,500 when the sun
drops behind the crest. `truckLead`, `truckV` and `truckBraking` are exported for
a probe, as `safari.zig` exports them for its HUD.

**Nothing on the page is a stand-in.** The route, the rider's own physics
and lean, the animals, the cat, the sky clock, the chase, the bull's gradient
shading and the camera's own pull-in are all the real thing, and `poc/Drive.codex`
is a *scrub* page again — the driven half is `port/Safari.codex`, a port of the
game's own `safari.zig`, and `poc/drive_shim.zig` is an ABI with no logic left in
it. What the shim still owns is what a pure program cannot hold: a value, a
history ring, and the exported readouts.

**The lens moves.**
`cam-focal`, `focal-for-lean` and `focal-for-gaze` were all in the port with
nothing above them to compute the two fractions they take; `safari.zig` is that
thing. Measured over a drive: the focal runs 204..685 px and is pulled in on
**3,138 of 6,400 frames** — leaning into a corner, watching the cat cross, or
gawking at the pigs.

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

**The driven page catches a desync, a heap death and a tag the blitter cannot
paint. It does not check a single VALUE.** That is the largest uncovered
surface left in this project.

## Stills, not frames

`emoji_frames.zig` and `cat_frames.zig` are the game's names and they read like
*animation* frames. They are not. `emoji_frames` is **one still per species** —
eight of them, 129 polygons in all — and the animals never animate; they are static
billboards that scale with distance. `cat_frames` is a **seven-pose flipbook**.
Every bit of motion in this port is computed per frame, not looked up.

So the port calls them stills: `port/EmojiStills.codex`, generated by
`harness/bake_stills.py` from the table the game's baker already emitted.
Hand-carrying 5,267 points would be the wrong shape of work and would rot the
moment the baker ran again — `NOTES` §5 says so. It is tracked like the gold
chapters and regenerated by script, never edited.

**Where a name is not pinned by a seam check, the port takes the better name.**
Where it *is* pinned — anything a check compares against the zig — fidelity wins.

**The bull is shaded, and it was the last animal that was not.** It is the sole
Fluent Color animal and 40 of its 43 polygons carry a 2-stop gradient, which
`paint.zig` writes as wire tags 5 and 6. The generator used to flatten each to its
first stop because `Paint` modelled 0, 1 and 3 only; `Paint` has the tags, the
baked table carries the stops and the geometry, and `Critter` has the arm that
emits them. All eight species are graded on the wire now — 172 commands, 568
gradient values and 9,044 coordinates against the real `critter.draw`.

**A gradient's optional-ness is a list of at most one.** Codex has no optional, and
the two obvious alternatives are both worse: a sentinel `kind = 0` puts fourteen
zeroes on every solid polygon in both tables — there are hundreds — while a shared
`no-grad` binding would be nullary, which emits as a *function* and would allocate
a record per polygon per frame (`PORTING_NOTES` B13). An empty list is two
characters and no allocation.

**The bull is graded facing both ways**, and the mirrored case is the one that
earns its place: a gradient's axis is a **vector** and its centre is a **point**,
so mirroring flips the axis without translating it. Map an axis as a point and you
still get a polygon of exactly the right shape with its shading anchored somewhere
else — which is why the gradient's own numbers get a stream of their own rather
than riding with the polygon's.

## Do not finish the real family

Thirteen real-family plug rows are declined on purpose. They are blocked on one
fact -- `ZigEmitter.codex` maps `RealTy (w) (m)` to `f64`, discarding both the
width and the mode -- so filling them would replace an honest refusal with a
plausible wrong number. **Do not finish the family without an answer to that.**

## Decisions

**Dialect: `Real` (f64), not fixed point.** Codex `Real` is f64 in every plug
while the game is f32, so comparisons carry a tolerance. The alternative — a
fixed-point port in integer milli-units — was priced and rejected.

**A failure names an index, not a value.** `show` on a Real is refused by the zig
plug, so `Grade` reports *where* a list first disagrees. When `real-to-int` lands
this becomes a scaled-integer dump and full-frame diffs.


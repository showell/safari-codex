# safari-codex

A port of the Safari driving screensaver from Zig to **Codex**, verified against
the Zig it came from.

The Zig version stays intact and keeps running on lynrummy.com/driving. This is a
parallel port, not a migration.

Five documents, and they do not overlap. **This file** is the orientation: what
exists, how to run it, and the method. **`PORTING_NOTES.txt`** is the lessons file
— sixty-one numbered notes on the toolchain, the language, the tolerances and the
seams, and the first thing to read before writing a Codex chapter.
**`FINDINGS.md`** is the seven defects this port found in the toolchain and the
game, written up to be sent. **`PLUG_WORK.md`** records the emitter change the port
needed and why it was branched where it was. **`NOTES.txt`** is the research brief
that opened the project; it is history now and several of its predictions were
wrong in useful ways, which this file notes where it matters.

## The trees this builds against

**Every tree this builds against is pinned, and `PROVENANCE.md` is the record.**
Until 2026-08-30 each of them was a path into a checkout somebody else was
working in, which made a green sweep a statement about whatever those trees held
that afternoon. Two rules now: a tree we COMPILE is a worktree on our own branch,
and a tree we merely READ is copied in with the commit it came from written down.

| tree | branch | what it is |
|---|---|---|
| `~/showell_repos/safari-codex` | `master` | **this repo.** The port, the checks, the harness. Pushed to `showell/safari-codex` on every commit. |
| `~/showell_repos/cobblestone-safari` | `safari` | **Cobblestone**, the Codex language: the foreword every chapter cites, the seed the guest arms boot, and the plugs. A worktree of `NewRepository` on our own branch, carrying Update 53 plus the plug rows the port needs. `CODEX_ROOT` and `COBBLESTONE_ROOT` point here. |
| `~/showell_repos/codexzig-safari` | `safari` | **builds `codexzig`**, the Codex→Zig transpiler this whole loop runs on. A worktree of `codex-zig-transpiler`; `./harness/build_codexzig.sh` is the only door to it. |
| `HISTORICAL_WASM_ROOT/` | — | **the game being ported**, copied in from `angry-gopher/games/driving/wasm`. It is the ORACLE and this project never edits it. `./harness/refresh_game.sh` moves the pin; the provenance sits beside the files. |
| `~/showell_repos/codex-zig-ladder` | `master` | borrowed, and deliberately NOT pinned: `ring_compile` + `codex_vm` are how the third and fourth arms boot a guest, and `codex_vm.launch` takes the host-wide lock that keeps this box to one guest at a time. A second tree would take a second lock. `PROVENANCE.md` has the argument. |

The single-purpose branches the plug work is SENT on -- `zig-plug-real-bitcast`,
`wasm-plug-real-conversions`, and their worktrees -- are not in this table
because nothing builds against them. `PLUG_WORK.md` is their record.

**`codexzig` is why this project moves at all.** It is one program -- Codex source
in, Zig out -- and `./harness/build_codexzig.sh` prints the path to ours, building
it in its worktree first if the fingerprint says it is stale. Building it costs
three QEMU guests, because the seed compiler emits x86 rather than Zig and the
emitter has to be booted before there is any Zig to compile; the build ends by
checking the fixed point, which is why the door is that project's own `build.py`
and not a `zig build-exe` here. **Once it exists, the sweep boots no guest.** That
is why a sweep is seconds instead of a ladder-scale job.

Four environment variables, all of them overrides with working defaults:

    CODEX_ROOT     ~/showell_repos/cobblestone-safari   the foreword and the seed
    CODEXZIG_TREE  ~/showell_repos/codexzig-safari      the transpiler's worktree
    CODEXZIG       (unset)                              a specific binary instead
    SAFARI_LADDER  ~/showell_repos/codex-zig-ladder     ring_compile, codex_vm
    ZIG            ~/zig-0.16.0/zig                     0.16.0

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

**A minute and a half cold, six and a half seconds when nothing has changed.** It
was nine minutes. Two things fixed that, and both are worth knowing:

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

**The sweep boots no QEMU guest.** `harness/metal.py` does — that is the third arm,
below — and the ladder's compute rules apply to it and to nothing else here.

## The third arm: the same check on bare metal

    ./harness/metal.py Pond          # one check, both ways
    ./harness/metal.py --all         # all seventeen, smallest first (3m26s)

The sweep above verifies the **port** against the game, and it does that through
the zig plug: Codex source in, zig out, a native binary that prints a verdict.
That proves the port and says **nothing about the plug**.

So the same check is run a second way — through the Codex compiler's own x86-64
emitter, as a kernel image booted under QEMU — and the two arms must print the
same bytes. That is a Diverse Double-Compiling check in Wheeler's sense, applied
to a program instead of to a compiler. `codex-zig-ladder` next door does it for
the compiler; this does it for this port.

**All seventeen checks agree, byte for byte**, including the whole-frame check's
3,091 commands and 7,518 coordinates. No tolerance is involved — this compares
printed verdicts, and verdicts are text.

**`RideCheck` is the only check here that is a long-lived *stateful* computation**
rather than a pure function or a single frame — 6,960 frames of fold, in 9 s inside
the guest against 1.0 s native — and the two arms agree on its derived numbers as
well as its verdicts: 6,960 against 7,000, segment 13 at 265 frames, 68,700 mm at
the last shared sample.

**Be careful what that is worth, because the obvious reading is wrong.** It is
tempting to say the ride's knife edge makes it a sharp detector of a difference
between the two emitters. It does not, and `probe_sens.zig` is what says so: a
ONE-TIME perturbation of 1e-7 is absorbed completely, and a PERSISTENT relative
bias only starts to move anything at 1e-7 — 1e-8 and 1e-9 change nothing at all.
Two IEEE f64 emitters differ, if they differ, at about 1e-16 an operation, eight
orders below that floor. So this check is **blind** to exactly the emitter faults a
DDC check most wants — FMA contraction, x87 excess precision, a reassociated
sum — because every one of them lives at 1e-16.

**The knife edge is calibrated to f32 epsilon, which is the port-against-game gap
and nowhere near the arm-against-arm one.** What the agreement genuinely rules out
is gross divergence: a persistent difference of 1e-7 or more between the emitters.
The 9 s is worth as much as the agreement — the ride depends on no input at all,
so a sufficiently eager `fold-constants` could have evaluated the whole thing at
compile time and had the guest print an answer the emitted x86 never computed. Nine
seconds of guest time and a second of native time say neither arm did.

**A check compares verdicts, not values**, and that is a real limit on what the
sweep above proves: `Grade` prints `name ok 2468`, so two arms that both sit
inside a tolerance agree whatever their last bits did. `--entry` is the answer.

    ./harness/metal.py --entry SpikeMain SpikePondMain SpikeCatMain SpikeTruckMain

It runs a poc *entry* chapter instead of a check, and the spike entries print
every coordinate of every frame as its exact IEEE-754 bit pattern. **All eight
viewpoints plus the speed profile, and the two arms agree BIT FOR BIT on every
value:**

| entry | fields |
|---|---|
| `SpikeProfileMain` — the ported physics over the whole route | 20,002 |
| `SpikeMain` — the pig herd, the mid-tower | 123,974 |
| `SpikePondMain` — the duck pond, the corner zebras | 128,402 |
| `SpikeCatMain` — the cat frozen, the cat mid-leap | 161,134 |
| `SpikeTruckMain` — the truck in daylight and at dusk | 89,902 |
| | **523,414** |

Concatenated that is **4,532,052 bytes, and the two arms produce them byte for
byte** — the sky, the ground, the trees, the towers, the rails, the animals, the
cat's leap and the whole truck. That is the statement worth making; verdict
agreement is the cheap sweep. Eight guests, about six minutes.

**The comparison is only as fine as the last digit printed**, and that scale was
inherited rather than chosen. These entries were written to feed `spike_svg.py`,
which draws at 960 by 600, so hundredths of a pixel was overkill *for a picture* —
and then the same text was pointed at a second compiler, where at a hundredth of a
pixel two emitters could disagree by four orders of magnitude and this would call
them equal.

**There is no scale now.** `real-to-bits` landed in the zig plug on 2026-08-30
(`PLUG_WORK.md`), so a coordinate goes out as its exact IEEE-754 pattern and the
diff is bit-for-bit. That is what lets the third arm finally see the emitter faults
it was blind to under any decimal scale — FMA contraction, x87 excess precision, a
reassociated sum, all of which live at 1e-16 (`PORTING_NOTES` D11 is where that
limit was measured and admitted). The text stopped being readable by a human on the
same day it started being read by a second compiler, which is the right trade.

**The guest's heap decides how big an entry may be, and it is smaller than the
host's.** The prelude bump-allocates and never reclaims, so a run's whole output
has to fit at once, at about 700 MB a frame. A native process's 4 GiB reserve
holds six frames; the venue's 3072 MB holds five, and at the driver's default
1 GB the guest dies after one — printing `OUT OF MEMORY` cleanly rather than
corrupting anything. So **two viewpoints per entry, which is the guest's number
rather than the host's**, and the split is the whole reason the table above has
four rows instead of one that cannot run.

The machinery is the ladder's, borrowed rather than restated: `ring_compile`
streams a cite-resolved unit into the seed under QEMU and hands back a `.cdx`,
`codex_vm.run_cdx` boots it and captures the serial. Both take the ladder's
compute lock and both refuse off the venue, so this cannot start a guest without
asking. It came to about forty lines of harness, which is worth saying because it
had been imagined as a project.

**What it found was in the diagnostics, not the output.** The seed emitted 1,268
`CDX4010` (bounds proven, info), 15 `CDX4030` (pipeline, info) and **ten
`CDX3006` warnings** — three real name collisions in a port that had been green
for its whole life: `bar-quad` defined in both `Tower` and `GuardRail`,
`tower-beyond` and `tower-right` in both `Render` and `RenderCheck`. `codexzig`'s
diagnostic stream carried none of them. Nothing was misbehaving — each chapter
sees its own definition — but a mention from a chapter that defines neither
resolves by the order the build globs files, which is not a property to rely on.
All three are renamed; the missing diagnostics are `FINDINGS.md` item 5.

The lesson is about arms rather than about this port: **an arm you develop against
is an arm whose silence you have learned to trust.** `PORTING_NOTES` B5 records
the flat-namespace hazard as something to watch for by hand — by hand is how it
was watched for, and three instances still got in.

**What it does not prove.** Only that two emitters agree on this source. A defect
in the shared front end is invisible to it, exactly as the ladder's own README
says of its rungs.

## Layout

| directory | holds | written by |
|---|---|---|
| `port/` | the port itself — Codex chapters, quire `Safari` | hand |
| `judge/` | graders and check roots, quire `Judge` | hand |
| `gold/` | gold chapters, quire `Gold` | **generated, then tracked** |
| `probe/` | Zig probes that import the real game | hand |
| `poc/` | browser and spike ENTRY chapters, quire `Poc` — throwaway by design | hand |
| `harness/` | the four steps, plus the spike and wasm builders | hand |
| `build/` | bundled units, emitted zig, diagnostics — **tracked**; binaries are not | generated |
| `web/` | the browser page: the game's own `blitter.js`, symlinked, plus the wasm | mixed |
| `price-b/` | the fixed-point measurements behind the dialect decision | one-off |
| `spike/` | the original feasibility spike | historical |

Two files in `probe/` are not probes in the usual sense and say so in their own
headers: `probe_num.zig` imports no game module at all, because `Num` is not a port
of one (its oracle is zig's own `@round`, `@floor`, `@mod` and `@exp`), and
`probe_sens.zig` is a sensitivity EXPERIMENT that `run.sh` never builds — it is the
evidence behind `PORTING_NOTES` D11 and nothing grades it.

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

**`harness/names.py` owns that snake_case rule and is the only place it lives.**
It is importable and runnable, so `run.sh`, `spike.sh`, `gen_gold.py` and
`metal.py` all ask it rather than restating it. There were four copies once and
two of them disagreed on consecutive capitals — `IOBuffer` was `i_o_buffer` to the
python and `i_obuffer` to the shell (`PORTING_NOTES` C18).

`harness/metal.py <Chapter>` then works on it with no further wiring: the third
arm reads the same three files.

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

**Nothing on the page is a stand-in any more.** The route, the rider's own physics
and lean, the animals, the cat, the sky clock, the chase, the bull's gradient
shading and the camera's own pull-in are all the real thing, and `poc/Drive.codex`
is a *scrub* page again — the driven half is `port/Safari.codex`, a port of the
game's own `safari.zig`, and `poc/drive_shim.zig` is an ABI with no logic left in
it. What the shim still owns is what a pure program cannot hold: a value, a
history ring, and the exported readouts.

**The lens moves now, and it had been ported and idle since Camera landed.**
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

## Looking at one thing: the spike loop

    ./harness/spike.sh          # then http://localhost:9200/spikes/

**Throwaway by design and graded by nothing.** `poc/Spike.codex` renders single
still frames at hand-picked points on the route, and `harness/spike_svg.py` turns
them into flat SVGs — no wasm, no blitter, no animation. A picture you can open is
a faster loop than a page you have to drive to the right spot. `run.sh` does not
call any of it; delete `poc/Spike*.codex`, `harness/spike.sh` and
`harness/spike_svg.py` and nothing else changes.

**The animals draw themselves now**, so a still shows exactly what the browser
shows rather than an approximation of it. The spike used to emit a marker box and
have the SVG script read the game's baked art off disk. Both tables are generated
into the port now — `EmojiStills` and `CatStills` — so every polygon in a still
arrives in the draw-command stream like everything else, and the SVG's reader for
the game's own art has been **deleted**: 108 lines that nothing had called since
the cat's flipbook was generated (`PORTING_NOTES` C18).

That turns out to check things. The pig-herd viewpoint draws **exactly 49 pig
markers**, which is the 7×7 distraction block `w-npigs` records for segment 2, all
of them surviving the culls; the duck pond draws six ducks and the corner pairs
draw two apiece. Eight viewpoints ship: the big pig herd, the mid-tower on the
1200m leg, the duck pond, a corner zebra pair, the cat frozen and mid-leap, and the
truck in daylight and at dusk.

**Two viewpoints per BINARY, and it is now habit rather than need.** The spike
prints one frame per viewpoint and never rewinds its arena (`PORTING_NOTES` C6), so
a run holds every frame it has printed — and while the printers concatenated left
to right they held a *quadratic* amount of it, which is what actually set the
ceiling. Six viewpoints used to exhaust the 4 GiB reserve; after the halving fix an
entry peaks at **133 MB** and all eight would fit in one binary (`PORTING_NOTES`
C17). The pairs are kept because they exist and give the guest one entry at a time
to fail in: `SpikeMain` (the pig herd and the mid-tower),
`SpikePondMain`, `SpikeCatMain`, `SpikeTruckMain` and `SpikeProfileMain`, each a
fresh process. `poc/SpikePrint.codex` holds the draw-command printing the four FRAME entries
share — `SpikeProfileMain` prints profile points, which are not draw commands, so
it does not cite it — and `harness/spike.sh` names the list once. Sharing by citing the *first entry* is
what does not work: two `opening`s in one bundle collide on the flat namespace.

## Ported so far

| chapter | ports | graded |
|---|---|---|
| `port/Pond.codex` | `wasm/pond.zig` | 48 values, exact |
| `port/Camera.codex` | `wasm/camera.zig` | with Geom below |
| `port/Geom.codex` | `wasm/geom.zig` | 375 values, 1e-6 relative |
| `port/Trig.codex` | arc tangent + angle wrap; sine and cosine are `DeviceMath`'s | via the above |
| `port/Paint.codex` | `wasm/paint.zig`'s wire | with Tree below |
| `port/Tree.codex` | `wasm/tree.zig` | 45 commands + 628 coords |
| `port/GuardRail.codex` | `wasm/guard_rail.zig` | 670 values, both seams |
| `port/Sky.codex` | `wasm/sky.zig` | 148 values; **colours exact** |
| `port/Mountains.codex` | `wasm/mountains.zig` | 2,204 values, both seams |
| `port/Tower.codex` | `wasm/tower.zig` | 1,485 values; the beacon disc |
| `port/Num.codex` | — | 111 values, **exact**; round, floor, mod, exp are foreword gaps |
| the whole ride | `wasm/safari.zig`'s fold | **SEAM 4**: 8 invariants over 6,960 frames |
| `port/World.codex` | `wasm/world.zig` | 3,822 values, the whole route |
| `port/Cat.codex` | `wasm/cat.zig` **minus `draw`** | 484 values, clock + attention |
| `port/Pose.codex` | `RiderState`, split out to cut a cycle | with Rider |
| `port/Gaze.codex` | `wasm/gaze.zig` | with Rider |
| `port/Rider.codex` | `wasm/rider.zig` | 199 values, **one step from a shared state** |
| `port/Truck.codex` | `wasm/truck.zig` **motion only** | 29 values, one step |
| `port/TruckBody.codex` | `wasm/truck.zig`'s `drawBody` | 2,962 values, **113 commands in order** |
| `port/SafariCritter.codex` | `wasm/safari_critter.zig` | 92 values, **complete** |
| `port/EmojiStills.codex` | `wasm/emoji_frames.zig` | **generated**, 5,267 points |
| `port/Critter.codex` | `wasm/critter.zig` | 9,924 values, **all 8 species** |
| `port/CatStills.codex` | `wasm/cat_frames.zig` | **generated**, 7 poses |
| `port/CatDraw.codex` | `wasm/cat.zig`'s `draw` | 9,993 values |
| `port/Render.codex` | `wasm/render.zig` **minus the baked-frame drawers** | 8,389 values |
| `port/Safari.codex` | `wasm/safari.zig` **minus the ABI** | 9,341 values, **a whole frame** |


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

**`RideCheck` closes SEAM 4, the last of the four `NOTES` named.** Every other
check in `judge/` grades ONE STEP FROM A SHARED STATE, and that is not modesty:
`rider.decide` picks the lean by binary search over twelve float comparisons, so a
1e-7 difference eventually flips one and the two rides part company. `NOTES`
section 4 ruled out comparing trajectories and prescribed the alternative —
"check INVARIANTS (on the road, no loop, sunset monotone)". `RideCheck` runs the
port's own ride from the start line to the finish and asserts
`test_model.ts`'s list on every frame; `probe_ride.zig` does the same to the game.
Neither looks at the other's trajectory. What is compared is where each invariant
FIRST failed — `-1` against `-1`, eight times — plus the ORDER of segments
visited, which is drift-immune because a route is a route.

**The two rides finish 40 frames apart, and that number turned out to be about
the GAME rather than about the port.** `probe/probe_sens.zig` measures it on the
game's own f32 code with the port nowhere in it: a one-ulp nudge to the initial
state is absorbed *completely* — same 7,000 frames, never a centimetre apart — so
the ride is contracting, not chaotic. But a **persistent** bias of 1e-7, which is
f32's own resolution, swings the total to 7,061 or 6,971 and moves segment 13 from
305 frames to 267. Below 1e-7 nothing moves at all. So the ride's length is not a
property of the model; it is a property of evaluating the model in f32, and the
port's per-segment durations sit inside the family the game produces for itself.
`PORTING_NOTES` D11 has the table and what closing it would actually cost.

**`NumCheck` is the odd one out and it is worth saying why it exists.** `Num` is
not a port of a wasm/ file: it is the Real primitives Codex's foreword does not
have — rounding, flooring, modulo and an exponential — written to zig's semantics
because zig is what the game calls. So `probe/probe_num.zig` imports no game
module at all and the oracle is `@round`, `@floor`, `@mod`, `@exp` and `@exp2`
themselves. That makes it the one check in this port with **no f32/f64 gap to
absorb**: both sides are f64 running the same operations, so four of its five
streams are graded at tolerance 0.0 and only the exponential gets a tolerance.

Ten chapters already used `Num` and all ten were green, which is exactly the
argument for checking it directly: they only ever call it on their own domains.
Every `@round` in the game rounds a 0..255 colour channel, a stride count, a step
count or a whole number of degrees, so **a rounding wrong on a value none of them
produces is invisible to every other check in `judge/`**. It was. `round-real`
added the half before truncating, which answers 1 for the largest double below a
half; the new form truncates first and looks at what is left, and needs no sign
branch. The same check caught `exp-real`'s docstring claiming a truncation
remainder of 1e-17 where `r^13/13!` is 1.7e-16 and the measured end-to-end error
is 8.5e-16 — the same defect this port is sending upstream about `Math chapter
Cordic`, in our own chapter, corrected rather than left standing.

And its third failure was not in the port at all: see `FINDINGS.md` item 6, where
the **gold** was wrong.

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

**`Safari` grades a WHOLE FRAME, and that is the strongest oracle in the project.**
`render.frame` is pub and it *is* the picture — backdrop, ground, and every kind
dispatched to its drawer in one depth order — so the probe calls it and reads the
words it wrote. Every check before this graded a drawer or a collection in
isolation; the dispatch itself had lived in the browser poc and was graded by
nothing at all. 3,091 commands over two states, tags, colours and point counts
exact.

It paid for itself twice on the first run. It found **the bull's flattened
gradients** as a tag mismatch (tag 0 where the game writes 5), and once those were
fixed it found **a single adjacent transposition** in 3,091 commands: a rail post
and a rail bar swapped. That one is `PORTING_NOTES` D9 and it is the one place the
port's comparison is deliberately not the zig's — the game sorts f32 depths and
the port sorts f64 ones, so two depths closer than an f32 ulp are *the same
number* over there and the port must not order them. The slack is half an ulp,
which is the largest that cannot tie a pair the game holds apart, and it is
measured: the pair still swaps at 2e-8 and stops at 6e-8.

**The fold is graded as a definition, not against `advance`.** `safari.zig`'s state
step is an export over private statics with no setter, so it cannot be seeded, and
NOTES §4 rules out comparing trajectories anyway. What `advance` *is* is four pub
calls in a fixed order, so the probe composes those four and the check grades one
step from a shared state — including the finish line, where the whole ride
restarts. The order is the content: the truck steps against the **new** rider
distance, and nothing but this check can see that.

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

**`Trig`'s sine and cosine are retired**, and the interesting part is what the
regrade found. The hold on it was that the swap was expected not to be a no-op:
Trig's `wrap` subtracts in a bounded loop where `dm-reduce` divides by two-pi and
converts back through the integers, so the two ought to disagree in the last bits
— and nine chapters call these names, directly or through `Geom`.

**They do not disagree at all.** Sampled at every thousandth of a radian across
|x| ≤ 40 rad — 80,001 points — the two reductions return the *same double*, every
time, and so do the sines of their outputs. Below π both are the identity; above
it, repeated subtraction of a double `2π` and one divide-truncate-multiply land on
the same value. The polynomial and the quadrant fold were already
character-identical, so the reduction was the only place a difference could come
from. Every check is green and not one tolerance moved.

That measurement is the point, not the green sweep: a passing sweep says the gates
still hold, which is a different question from whether the values changed.
`PORTING_NOTES` D10.

What did **not** retire is `wrap` itself, and it was never part of the stand-in:
`mountains.zig` and `sky.zig` each carry their own bounded-loop wrap to normalise
a bearing, and both are ported through Trig's. Deleting it with the sine broke two
chapters — a helper written for one caller acquires others, and grep is how you
find them before rather than after.

It owed upstream **sine and cosine, and nothing else**. Emission is per-function,
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

Parked 2026-08-30, second time, with everything green and pushed.

**THE DELIVERABLE IS DONE AND IT PASSES THE EYE TEST.** Every file in
`games/driving/wasm` has a chapter, every drawer is ported, and the browser page
built from Codex is on par with the Zig game it was ported from — same route, same
scenery, same truck, same cat, same shading. `./harness/build_wasm.sh` and a static
server is the whole demonstration.

**State of the checks:** 17 in `judge/`, sweep GREEN in 6.5 s warm and 1m30 s cold;
all 17 agree on bare metal (`./harness/metal.py --all`, 3m26 s); and the five spike
entries agree with the second compiler **bit for bit** on 523,414 IEEE-754 patterns
(`./harness/metal.py --entry ...`). Working tree clean, `master` pushed to
`showell/safari-codex`. **Push after every commit** — this repo has a remote and
had thirty commits sitting behind a stale sentence saying it did not.

### The two things worth doing next, and they parallelise

**(a) Put it on WebGPU.** The port computes a draw-command buffer and hands it to
the game's own `blitter.js`, which paints with Canvas 2D. That seam is exactly
where a GPU backend attaches: the buffer is already a flat, typed, per-frame list
of tagged commands with colours and coordinates, and `NOTES` §5 chose it as the
contract for reasons that hold just as well for a shader as for a 2D context. What
would need deciding is how much of the blitter's own shading maths moves across
(the round gradients, the two bull gradient tags, the headlight radial), because
`harness/spike_svg.py` already approximates them and says where it is not faithful.
Nothing in `port/` should have to change: the buffer is the API.

**(b) Act on the findings.** `FINDINGS.md` has eight, and one is already moving —
see below. They are the outward-facing product of this project and they are ready
to send.

### Still open, in rough order of value

**The driven PAGE is off every arm.** `metal.py` runs the checks and the frames;
what it cannot reach is `poc/DriveMain`, because that program's output is a wasm
module rather than a line of text and its shim is zig by construction. The spike
entries are stills at fixed route positions, so `DriveMain`'s frame loop and
`drive_shim.zig` have no witness at all. Giving `DriveMain` a text dump of the
draw-command buffer closes it, and it is the `SpikeMain` shape rather than a new
idea. This is the largest uncovered surface left.

**The whole-frame check grades two states.** Chosen as branches — a hard lean, and
a long straight with the truck close. A second check is cheaper than more states in
one, and `CatDrawCheck` is the pattern.

**Thirteen real-family plug rows are declined on purpose**, not forgotten:
`plugs-backlog 2.07` lists them and puts the question to the maintainer. They are
blocked on one fact — `ZigEmitter.codex:342` and `:373` map `RealTy (w) (m)` to
`f64`, discarding both the width and the mode — so filling them would replace an
honest refusal with a plausible wrong number. Do not "finish the family" without
an answer to that.

**`Trig`'s arc tangent is a gap in Codex's foreword, not in the plug**, and
`r-atan` matches zig's to 1e-9 over eighteen values including the reciprocal
branch. It is a candidate to OFFER upstream rather than a debt.

### Traps a fresh reader should know about

**Absence is carried in the TYPE at the two places the game used `+inf`.**
`Truck`'s next turn is `Maybe Turn` and `World`'s tree search threads `Maybe Real`;
both used to pair a `found` Boolean with a payload, which is a Maybe with the tag
unhooked from the thing it guards. Codex has `when m is Just (x) -> ... is None ->
...` and the compiler's own code uses it throughout.

**`core/Sort` must NOT be substituted into `port/Render`.** Its `sort-by` is an
in-place quicksort claiming no stability, and the depth sort's ties are real —
`PORTING_NOTES` D9 has a rail post and a rail bar swapping in a 3,091-command
stream. `port/Render` says so at the sort.

**A byte-identical result proves a change is safe, never that the code is live.**
Only breaking it on purpose does that. It is how `judge/RideCheck`'s eight `-1`s
were shown to be earned, and how 108 lines of dead SVG code were found after being
carefully de-duplicated (`PORTING_NOTES` C18).

**Before splitting a job because it does not fit, measure what it allocates.**
`%M` is one flag. The spikes were split twice on `C6`'s authority when the real
problem was quadratic concatenation; the same entries now peak at 133 MB
(`PORTING_NOTES` C17).

**Every "the foreword does not have X" in this repo is a claim, and claims are
checkable.** The foreword is 13 directories and several hundred chapters.
`text-concat-list`, `list-map` and `DeviceMath`'s pi were all sitting in chapters
the code already cited.

**`poc/Scene.codex` is the original throwaway** and still builds; it is kept
because building it is the way to compare, and it has no reason to grow.

**The blitter and the rasterizer are the far side of the seam**, deliberately —
`NOTES` §5, unchallenged since. That is the seam item (a) above would attach to.

## Findings owed upstream

**Eight, and they are written up now: `FINDINGS.md`.** Each is self-contained —
observation, repro, evidence, and the shape of the fix. They are owed to two
different projects, and **`FINDINGS.md` now opens with how each one should
travel** — which are PRs, which are issues, and which need a look first. Read that
section before sending anything; the routing is the part that is easy to get wrong.

**One is already moving.** `real-to-int` / `real-from-int` went as Cobblestone
**PR 100**; `real-to-bits` / `bits-to-real` are built, tested and registered on
`zig-plug-real-bitcast` in `~/showell_repos/cobblestone-realbits`, branched from
that PR's head, and are the next one out. `PLUG_WORK.md` has the lineage.

To **Cobblestone / the Zig plug**: `OvError` silently emitting a wrapping `*%`
(`4000000000 * 4000000000` returns `-2446744073709551616`, exit 0); a `Real`
literal wider than an i64 being read as a different number, so that `1e18` written
out longhand arrives as `-8.4467e17` with no diagnostic; `Math chapter Cordic`
being 4.5× less accurate than its docstring, with a test that never calls a Cordic
function; single-letter names `a`–`d` colliding with `Tup4`'s comptime parameters;
the zig arm reporting no diagnostics where the seed reports real ones; and a
one-expression function over a record parameter being silently inlined rather than
emitted, which only breaks at the shim boundary.

**The literal one is the first defect this port found in the FRONT END rather
than in a plug**, and it is the first it found in the harness's own oracle: a
nineteen-digit gold literal made `NumCheck` red at a value the port had computed
correctly. Both arms print the same wrong constant, which is how it was placed.

To **angry-gopher**: `pushGradPoly` reserving six header words where it writes
seven — latent until this port, because the truck's headlight beams are its only
caller and they now draw every dusk frame; and `truck.zig`'s comments describing
headlights and a brake glow as deferred when the code draws both.

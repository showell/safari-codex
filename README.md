# safari-codex

**A driving screensaver, written in Codex, that we own outright.** It began as a
port of a Zig original and that port is finished and eye-tested; what it is now
is a real application in the language, and the most demanding customer the Codex
toolchain has.

It is also a four-arm oracle. Running one program four ways -- through the zig
plug, through the compiler's own x86-64 emitter under QEMU, and through two
independent roads to wasm -- has found more defects in the toolchain than any
other thing in this ecosystem. `WASM_FINDINGS.md` is the record.

**Fidelity to the Zig original is no longer a constraint.** It was, for as long
as it took to establish that the port was faithful without anyone having to
remember which giraffes stood at which intersections; that job is done. The
checks below still grade against the game because a free, exact oracle is worth
keeping -- not because the port is forbidden to diverge. It may diverge, and in
features too.

**And as of 2026-09-03 it has stopped matching the original's SHAPE.** Every
chapter here began as one of the game's files, and several of those files were
two jobs; `Camera` held a lens, a projection and a near plane that it never
read, and the near plane was carried by four callers into `Geom`'s clipping.
The chapter boundaries are ours now, chosen for cohesion, and the `A port of
wasm/<x>.zig` line at the top of a chapter is PROVENANCE rather than a promise
-- it says where the code came from, not what shape it must keep.

**What is still promised, and it is the part that was doing the work.** The
four arms compile the same Codex source and must print the same bytes. The
golds are regenerated from the zig probe and grade VALUES. The eye test is a
picture a human looks at. Not one of those has an opinion about which chapter
computed a number, which is exactly why the structure was free to move and the
behaviour is not: a restructure either leaves every value identical or it does
not, and the sweep says which.

`PROVENANCE.md` pins the trees this builds against. `FINDINGS.md` and
`WASM_FINDINGS.md` are the defects this project found, written to be sent.
`PORTING_NOTES.txt` is the lessons file -- the first thing to read before
writing a Codex chapter.

## The four arms, and what each one is worth

Stated in one place because the chain is easy to overclaim, and the overclaim is
flattering.

1. **The oracle.** `probe/probe_<mod>.zig` imports the **real, unmodified** game
   module and writes `gold/<Mod>Gold.codex`. Every number this project claims
   about faithfulness comes from here and nowhere else.
2. **The port, through the zig plug.** `./harness/run.sh` bundles a check,
   transpiles it with `codexzig`, builds the zig, runs it, and grades the port's
   values against that gold. **This is the only arm that compares the port to the
   GAME.** GREEN means they agree within the tolerance each check states.
3. **Bare metal.** `./harness/metal.py` runs the same checks through the Codex
   compiler's own x86-64 emitter, as a kernel image under QEMU, and requires the
   two arms to print the same bytes. Diverse double-compiling in Wheeler's sense,
   applied to a program rather than to a compiler.
4. **Wasm, by two roads.** `./harness/wasm_arm.py` compares `Codex -> zig -> wasm`
   against `Codex -> IR -> plugs/wasm`, which share no code below the IR. With
   `--native` the right road is `build/codexwasm` and no guest boots at all.
   **Its `--both` mode is RED and the emitters are not why** — the two roads run
   different IR pass pipelines, so its byte comparison cannot attribute a
   difference. `WASM_FINDINGS.md` finding 13; `--native --all` is the arm.

**What the four together establish.** The port agrees with the game (1 and 2), and
three independent compile paths reproduce that agreement — which is what rules out
the port merely being bent the same way one emitter is. Arms 3 and 4 both call
`run.sh` first and it exits non-zero on RED, so neither can compare two arms of a
port that is failing its own checks: the verdict travels with them.

**What it does not establish, in three parts.**

- **Arms 3 and 4 compare emitters, not the game.** They ask whether the answer
  depends on the toolchain, and the answer is no. Faithfulness is arm 2's word.
- **Bare metal and the wasm roads are never compared directly.** Arm 3 ties bare
  metal to the zig arm; arm 4 ties the two wasm roads to each other and to the zig
  arm's own output. The link between bare metal and `codex -> wasm` is transitive
  through arm 2, not measured.
- **A check compares VERDICTS, not values** — `Grade` prints `name ok 2468`, so two
  arms inside a tolerance agree whatever their last bits did. The exception is
  `metal.py --entry`, which compares arms 2 and 3 on **523,414 IEEE-754 bit
  patterns with no tolerance anywhere**, and `plug_probe.py`, which compares the
  two plugs on values a few lines at a time.

## What the checks still buy, now that the port is done

**Structure compares exactly; numbers carry a measured tolerance.** Codex `Real`
is f64 in every plug and the game computes in f32, so every computed number
differs somewhere in the last bits. Point counts, colours, tags and indices
never get slack -- a wrong count is a wrong shape and no coordinate tolerance
should be able to hide one. Section D of `PORTING_NOTES` records what each
tolerance had to admit and why.

Where the port deliberately differs, it says so at the definition and the check
gates it at a measured bound. There is one such place: the cat's airborne arc
uses `b^0.75` where the game uses `pow(b, 0.7)`, bounded at 0.109m and zero at
both ends.

Two rules from the port that still hold, because they are about Codex and not
about fidelity:

- **Port the answer, not the cost model.** An in-place algorithm carried
  literally onto persistent lists can gain a whole complexity class
  (`PORTING_NOTES` E4).
- **Take the better name where nothing pins it.**

## The unit tests: `spec/`

**Run these first.** `./spec/run.sh` grades eleven chapters in about a second
and roughly two milliseconds of interpreter. It is what to run after a compiler
change, before anything in `judge/` -- which asks a different and much more
expensive question: `RenderCheck` alone builds a whole frame and takes 13.5
seconds.

A spec is a **self-checking Codex chapter**: it carries its own expected values
as literals and prints its own verdict, so any arm that runs Codex renders that
verdict alone. No gold bank, no probe, no zig. `./spec/run.sh --zig` transpiles
and builds each one and diffs the arms; all thirteen are byte-identical today.

Three rules the files are held to, each of which caught something:

- **Derive, then confirm. Never capture.** `NumSpec`'s rounding table rederived
  with the obvious `floor(|x| + 0.5)` walks straight back into the bug `Num`'s
  docstring records fixing. A captured table would have written that bug in as
  the definition of correct.
- **Measure the tolerance by tightening it until it breaks.** `LensSpec` fails
  at 1e-10 and passes at 1.2e-10; the gate is 1e-9 and the prose says so. Five
  of `NumSpec`'s six lines are graded at exactly 0.0.
- **Every line must be shown capable of failing.** `spec/mutate.py` runs each
  spec a second time poisoned and every printed line must go BAD. It refuses
  rather than skipping when a `-want` is not a list literal, which is what
  structurally forbids a want computed from the got.

**The baked stills stay in, but held to a budget.** `CatStills` and
`EmojiStills` are 763 KB of generated literals and they are the likeliest thing
here to find a front-end limit, so they belong in the default path -- but they
should not dominate it. What costs is NAMING a table, not walking one: a nullary
binding emits as a function (`PORTING_NOTES` B13), so every mention of
`pose-rest-polys` rebuilds all 2,198 of its points. Measured, one reference is
9,110 steps, two are 18,168, four are 36,284 -- exactly linear, nothing
memoised. So each table is reached ONCE, through the dispatch those specs have
to grade anyway, and everything about it is computed from that single reference.
That took the two from 470,000 steps to 163,000 while ADDING assertions.

They are still the trickiest thing here, and they are deliberately out of some
checks: `judge/` has never had a `CatStillsCheck`, because the honest oracle for
baked art is the blitter diff and the eye test. See **Stills, not frames**
below.

## Before the loop will run

Four things must exist, and `harness/pins.py` exits rather than guess at any of
them. It is the authority; this list only tells you they exist.

    SAFARI_COBBLESTONE   the Codex checkout the port compiles against
    CODEXZIG_TREE        the transpiler's worktree
    ZIG                  the zig binary, and the version is pinned
    SAFARI_LADDER        for ring_compile and codex_vm

`PROVENANCE.md` says what each is pinned to and why. **`./harness/run.sh` calls
`build_codexzig.sh` on a cold checkout**, which is a multi-minute build through
QEMU guests -- the "no guest" promise below is about the sweep, not the first
one.

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

**One check's oracle is not a zig probe.** `Blit`'s decisions have always lived in
the browser, so a check that owns a `harness/gen_<mod>_gold.js` gets its gold from
node reading `HISTORICAL_WASM_ROOT/blitter.js` instead of from step 1. The sweep
then finishes with `--- Blitter ---`: `harness/blitter_diff.js`, which runs the
forked `web/blitter.js` and the frozen original side by side over a recording
canvas. That leg is what stands behind the claim that moving the shading recipe into
Codex did not change the picture. `harness/second_show.js` runs after it and
is in the sweep for the same reason: it rotted once and nothing noticed,
because nothing ran it.

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
    ./harness/metal.py --all         # all eighteen, smallest first (3m26s)

The sweep above verifies the **port** against the game, and it does that through
the zig plug: Codex source in, zig out, a native binary that prints a verdict.
That proves the port and says **nothing about the plug**.

So the same check is run a second way — through the Codex compiler's own x86-64
emitter, as a kernel image booted under QEMU — and the two arms must print the
same bytes. That is a Diverse Double-Compiling check in Wheeler's sense, applied
to a program instead of to a compiler. `codex-zig-ladder` next door does it for
the compiler; this does it for this port.

**All eighteen checks agree, byte for byte**, including the whole-frame check's
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

**The two arms produce every one of those bytes identically** — the sky, the
ground, the trees, the towers, the rails, the animals, the cat's leap and the
whole truck. That is the statement worth making; verdict agreement is the
cheap sweep. Eight guests, about six minutes.

No byte total is written here, and that is deliberate. The one that used to be
was measured before `real-to-bits` landed three paragraphs below, so it read
half the true size and sat wrong through two rewrites that re-checked the field
counts beside it. `ls -l build/spike_*.metal` answers it in the present tense.

**The comparison is only as fine as the last digit printed**, and that scale was
inherited rather than chosen. These entries were written to feed `spike_svg.py`,
which draws at 960 by 600, so hundredths of a pixel was overkill *for a picture* —
and then the same text was pointed at a second compiler, where at a hundredth of a
pixel two emitters could disagree by four orders of magnitude and this would call
them equal.

**There is no scale now.** `real-to-bits` landed in the zig plug on 2026-08-30
(PR 100), so a coordinate goes out as its exact IEEE-754 pattern and the
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

## The fourth arm: the same program as wasm, twice, by two different roads

    ./harness/wasm_arm.py --native --all  # the day-to-day check: 18 units, NO guest
    ./harness/plug_probe.py               # the plug's own differential probes
    ./harness/wasm_plug_build.py          # once per emitter change, 18s, one guest
    ./harness/wasm_arm.py Pond World Num Camera
    ./harness/wasm_arm.py --entry SpikeProfileMain

The first three arms agree, so this one does not re-run them. It asks a narrower
question than the third arm and gets a sharper answer:

    Codex -> zig -> wasm      codexzig, then zig build-exe -target wasm32-wasi
    Codex -> IR  -> wasm      the seed, then plugs/wasm's own emitter

Both roads end as a wasm32-wasi module run by **wasmtime**, and the two must
print the same bytes. **They share no code below the IR.** The left road is the
one this project has always used with a wasm back end bolted on the end; the
right road never sees zig at all, and its emitter is a different program written
by different hands. A difference between them is a defect in one of the two, and
the source is the same source either way, so it is not in the port.

`harness/wasm_arm.py` is the whole thing and it is about two hundred and eighty
lines. Two guests per module: one compiles the bundled unit to IR on the seed,
one runs the wasm plug over that IR — or no guest at all under `--native`, which
is what this arm runs day to day. `wat2wasm` is wabt's own JS build under
`tools/`. **The runner is `wasmtime`, not `node:wasi`**, which this section
recommended for as long as `WASM_FINDINGS.md` has recorded that `node:wasi`
aborts with SIGSEGV on four of fourteen checks; `tools/README.md` has the
install line.

**The QEMU is cheap, and that was the open question.** 18 s and one guest for the
plug; 4-13 s to compile a unit to IR; 2-9 s to transpile it. A check is under ten
seconds end to end and the whole 20,002-field spike entry is 27 s. Nothing here
is near the third arm's minute-a-guest, because none of these units are the
compiler.

**What it found was that Real did not work at all.** No Codex program that
computes with `Real` had ever assembled through the wasm plug. Every real on that
target is carried as f64 bits in an i64 slot, which is the right representation
and was half implemented: the reinterprets that get a value into an f64
operation and back out of it were simply missing, so `f64.add` was handed two
i64s and its f64 result stored into an i64 slot. The four ordered comparisons
emitted `i64.lt_s` on the bit patterns, which is not a near miss — it reads the
sign bit as the top of a two's-complement integer, so every negative real sorts
above every positive one and `-2.0 < -1.0` comes out False, and the foreword's
own `real-min`, `real-max` and `real-abs` are three lines of `<` and `>`. Four
builtins had no form at all. `WASM_FINDINGS.md` finding 1 has the change; it is on
`wasm-plug-real-conversions` for sending.

**What agrees now.** All eighteen units emit and agree — `Pond`, `World`, `Num`
and `Camera` were the first four — and `SpikeProfileMain`
on **20,002 IEEE-754 bit patterns, with no tolerance anywhere**: the ported
physics over the whole route, by two emitters that share no code below the IR.

### What it takes to make it fail

A check compares VERDICTS, and a verdict is `name ok 2468` — the third arm's own
limit, and this arm inherits it. So the arm was made to fail on purpose, three
ways, each a plausible one-token slip in the emitter rather than a perturbed
input:

| fault in `WasmEmitter.codex` | wrong only when | `World` verdicts | `SpikeProfileMain` values |
|---|---|---|---|
| `real-from-int` converts unsigned | the integer is negative | **agrees** | CAUGHT (hangs, no output) |
| ordered compare `f64.lt` -> `f64.le` | the two are equal | — | CAUGHT (296 of 257,787 bytes) |
| `real-to-int` rounds, not truncates | the fraction is >= 0.5 | — | CAUGHT (1,736 bytes) |

**The first row is the one worth reading.** A faulted emitter, seven wrong
instructions in the emitted module, and `World` was GREEN. That is not the arm
being blind: rebuilding the same module with the fault repaired, host-side,
prints byte-identical output, so `WorldCheck` never calls `real-from-int` with a
negative at all. The fault was unreachable in that program. But the verdict said
`ok` either way, and a verdict that says `ok` for a program carrying seven wrong
instructions is exactly as much comfort as it sounds like.

**`--entry` is the answer, as it was for the third arm.** The spike entries print
every value as its exact IEEE-754 pattern, and all three faults are caught there
— two of them by the program failing to terminate, which is its own kind of
evidence that the physics genuinely runs. Verdicts are the cheap sweep; values
are the statement.

`./harness/metal_chapter.py` grades a single chapter on all three arms, which
is how a test going upstream gets bare metal's answer rather than ours.

## Layout

| directory | holds | written by |
|---|---|---|
| `port/` | the port itself — Codex chapters, quire `Safari` | hand |
| `judge/` | graders and check roots, quire `Judge` | hand |
| `gold/` | gold chapters, quire `Gold` | **generated, then tracked** |
| `probe/` | Zig probes that import the real game | hand |
| `poc/` | browser and spike ENTRY chapters, quire `Poc` — throwaway by design | hand |
| `harness/` | the four steps, plus the spike and wasm builders, the browser oracle and the dev server | hand |
| `build/` | bundled units, emitted zig, diagnostics — **tracked**; binaries are not | generated |
| `web/` | the browser page: this project's FORK of `blitter.js`, plus the wasm | mixed |
| `price-b/` | the fixed-point measurements behind the dialect decision | one-off |
| `spike/` | the original feasibility spike | historical |

**Four files in `harness/` answer to the browser rather than to zig.**
`blitter_oracle.js` reads the shading recipe and the thresholds out of the frozen
original; `gen_blit_gold.js` writes `gold/BlitGold.codex` from it; `blitter_diff.js`
runs the fork and the original side by side over a recording canvas;
`paint_probe.js` hands the real module's own buffer to the real blitter for 300
frames and checks the canvas calls add up. The first three are in the sweep;
`paint_probe.js` runs at the end of `harness/build_wasm.sh`, where the wasm is.
`serve.py` serves `web/` with `no-store`, which is the whole reason it is not one
line of `python3 -m http.server`.

Two files in `probe/` are not probes in the usual sense and say so in their own
headers: `probe_num.zig` imports no game module at all, because `Num` is not a port
of one (its oracle is zig's own `@round`, `@floor`, `@mod` and `@exp`), and
`probe_sens.zig` is a sensitivity EXPERIMENT that `run.sh` never builds — it is the
evidence behind `PORTING_NOTES` D11 and nothing grades it.

`probe/wasm` is a symlink to `HISTORICAL_WASM_ROOT/`, so the probes can
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
`harness/blitter_diff.js` runs both over a recording canvas every sweep and
demands the same picture out of the two different wires.

**`poc/Drive.codex` drives the real route.** Nothing in the frame is placed by
hand: the road and its corners, the conifers, the intersection towers, the guard
rails and the pond all come out of `Safari chapter World` — the same nineteen
segments, graded seam by seam against `gold/WorldGold.codex` — mapped by
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

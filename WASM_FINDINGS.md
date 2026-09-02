# WASM_FINDINGS: what the fourth arm found in `codex/plugs/wasm`

**The plug is the subject here, not the port.** Safari already runs in wasm, by
`Codex -> zig -> wasm`; what this document records is what happened when the
same programs were put through `codex/plugs/wasm` instead, and the two answers
were required to match. `README.md` describes the arm and
`./harness/plug_probe.py` is the rig: a few lines of Codex, run down both roads,
diffed.

Both roads are native and neither boots a guest, which is why this is a
half-hour exercise rather than a compute job:

    codexzig  <probe>  ->  zig  ->  zig build-exe  ->  run
    codexwasm <probe>  ->  WAT  ->  wat2wasm       ->  wasmtime

The zig plug is the reference by availability rather than by right: it is the
one already checked against bare metal at 523,414 fields (`README.md`, the third
arm), so where the two disagree the zig side has evidence behind it. A defect
BOTH plugs share is invisible to this and `./harness/metal.py` is the arm that
would see it.

**Status.** Thirteen findings — eleven in the plug (seven fixed, four open) and
two in our own harness (12 fixed, 13 open). **The seven fixed are
SENT, as [Cobblestone PR 111](https://github.com/damiant3/Cobblestone/pull/111)**
— eleven commits plus three tests, cut from Update 53 itself rather than from
the integration branch, so the PR is independent of open PRs 100 and 105. The
fixed point holds on that branch alone: 2,448,436 bytes each way, nine stages,
three guests.

The fixes sit on the integration branch as separate commits, which is what made
that cherry-pick clean:

    cobblestone-safari  e8486215  finding 1, also on `wasm-plug-real-conversions`
                        b5b1bb74  findings 2 and 3
                        121b61fb  finding 6's discarded scans
                        2aff6e4d  finding 6's ceiling: list literals in halves
                        3c13334d  finding 6 in the zig plug: join once
                        1893cf1e  finding 6 in the zig plug: stream a chapter
                        2660d3af  1893cf1e's mask split, guarded
                        ab4612aa  finding 8
                        e6f09556  finding 9, recorded rather than fixed
                        2a53929f  findings 10 and 11
                        15ef1862  the mask ceiling as a gate, and the comment
                                  corrections a second cold review forced

Built and shipped: `codexzig-safari` 432b80a is the binary every arm here runs,
rebuilt through nine stages and three guests on 15ef1862 -- fixed point HOLDS
byte-identical, and the 27 units emit byte-identical zig against the compiler
from before all of it.

**Findings 8 through 11 came from COLD REVIEWS rather than from the probes** —
8 and 9 from a review of the four commits above them, 10 and 11 from a second
review of the commits that fixed those. That is the useful fact about them: the corpus was green, the
byte comparisons were green, and both defects were sitting in code the sweep
cannot reach. Finding 8 is a silent wrong answer that had been there all along.

`PROVENANCE.md` describes that branch and why an integration branch is not a
pull request.

**2026-08-31: nine more plug commits arrived from `codex-wasm-transpiler` and
this port was re-pinned onto them the same day.** They were written for a
different subject entirely -- making the wasm plug compile the Codex compiler
itself -- and they are open upstream as
[PR 112](https://github.com/damiant3/Cobblestone/pull/112).

**The pin is `wasm-slot-from-type` 9632bb87 and PR 112 is
`wasm-plug-selfhost-batch` ccfde8d7**, which are the same nine changes on two
different bases and therefore two different sha sets. What was verified here is
PR 112's emitter, and that is a content claim rather than a commit one:
`WasmEmitter.codex` hashes `feb09250410c13d2` on both branches, as do the two
PowerShell files beside it. `PROVENANCE.md` has the full comparison. **That is what makes this port useful to
them.** Seventeen ported game modules and ten differential probes are an oracle
none of that work could see, and they were run against the new emitter with
nothing else moved: all 523 changed lines are in `codex/plugs/wasm/`, and the
codexzig subject re-bundles byte-identical at the new pin, so arms 1 through 3
are the same measurement they were before.

    run.sh                              GREEN, 6.8 s warm -- nothing rebuilt
    metal.py --all                      METAL GREEN, 17/17 agreeing
    wasm_arm.py --native --all          WASM-ARM GREEN, 17/17 agreeing
    plug_probe.py                       9 agree, showreal differs -- finding 4

The interesting result is the boring one: **nothing moved.** Nine commits that
halved the compiler's peak memory and cut its self-compile from 223 s to 15 s
changed no answer on any of seventeen programs. That is what the port is for.

**Both things the exercise did surface are OURS, not the plug's**, which is the
other reason to re-pin: findings 12 and 13 below. Twelve is a staleness check
this harness did not have and now does. Thirteen is worse and older — the fourth
arm's `--both` mode has been comparing two roads that run DIFFERENT IR
pipelines since the day the native road was built, so its byte comparison could
never have attributed a difference to an emitter. Neither was reachable without
moving the pin under a harness and watching what it said.

| # | finding | kind | status |
|---|---|---|---|
| 1 | `Real` is not implemented | wrong module / refused | **fixed** |
| 2 | `a ^ b` emits `a * b` | **silent wrong answer** | **fixed** |
| 3 | `show` of `INT64_MIN` emits garbage bytes | **silent wrong answer** | **fixed** |
| 4 | `show` on a `Real` prints its bit pattern | **silent wrong answer** | open |
| 5 | exports come from another app's hardcoded name list | surface | **mechanism landed**, not yet used here — see below |
| 6 | nothing is ever reclaimed; both emitters are superlinear | **ergonomics / ceiling** | **fixed in both plugs** — all 17 units emit, and `cat_draw` went 2,904→418 MB on the zig arm |
| 7 | the vector ops have finding 1's shape | wrong module | open |
| 8 | a text literal in a match-branch GUARD is missing from the string table | **silent wrong answer** | **fixed** |
| 9 | neither `env` import can be reached by any program | wrong module / hole | open |
| 10 | a `when` inside a GUARD overwrites the scrutinee the branches below read | **silent wrong answer** | **fixed** |
| 11 | `needs-blit` asked whether the name OCCURS, not whether it is called | wrong module | **fixed** |
| 12 | the fourth arm's guest road accepted a plug built from ANY emitter | **our harness** | **fixed** |
| 13 | `--both`'s two roads run DIFFERENT IR pipelines, so it cannot attribute a difference | **our harness** | open |
| 14 | `build_codexzig.sh` cannot see a SOURCE change; it fingerprints the generated zig against itself | **our harness** | open |

And one bed problem that is not the plug's fault but bites anyone using it:
`node:wasi` aborts on modules with a large linear memory. It is at the bottom.

---

## OPEN

Everything else on this page is fixed and shipped. These are not:

- 4. `show` on a `Real` prints its bit pattern — OPEN
- 7. The vector ops have finding 1's shape — OPEN
- 9. Neither `env` import can be reached by any program — OPEN
- 13. `--both` compares two roads that do not run the same IR — OPEN (ours)
- 14. The transpiler's freshness check cannot see a source change — OPEN (ours)

The fixed ones are kept as a record of what the fourth arm found and where
the evidence went, one paragraph each. Their derivations are in git.

## 1. `Real` was not implemented — FIXED

**No Codex program that computes with `Real` had ever assembled through this
plug.** Every real on this target is carried as f64 bits in an i64 slot, which
is the right representation and was half built: the reinterprets that get a
value INTO an f64 operation and back OUT of it were missing.

*Fixed. The investigation, the repro and the evidence are in git.*

## 2. `a ^ b` emits `a * b` — FIXED

    2^10 = 1024   (zig)      2^10 = 20   (wasm)
    3^4  = 81                3^4  = 12
    5^0  = 1                 5^0  = 0

*Fixed. The investigation, the repro and the evidence are in git.*

## 3. `show` of `INT64_MIN` emits garbage bytes — FIXED

    to-int 2^64 = -9223372036854775808   (zig)
    to-int 2^64 = -\xfa\n\n\x00\x00\xfc\n0...  (wasm)

*Fixed. The investigation, the repro and the evidence are in git.*

## 4. `show` on a `Real` prints its bit pattern — OPEN

    show 0.5        ->  4602678819172646912
    show (1.0/3.0)  ->  4599676419421066581

The zig plug **refuses**: it emits `cx_show_int(@as(f64, ...))` and zig rejects
it at compile time — *"fractional component prevents float value '0.5' from
coercion to type 'i64'"*. Loud, at build time, with the source line.
`judge/Grade.codex` is built around that refusal and `PORTING_NOTES` D12 is the
note.

The wasm plug emits a module that assembles, runs, and prints the i64
reinterpretation as a decimal. **The same source is a build error on one plug
and a wrong answer on the other**, and the wrong answer is the kind that looks
like a number.

`wat-emit-show` dispatches on `wat-is-text-type` and sends everything else to
`$wasi_print_i64`. It now has `wat-is-real-type` beside it (finding 1), so the
cheap fix is an arm that emits `(unreachable (; show on a Real has no form ;))`
— matching what `wat-no-such-thing` already does for `port-out-byte` — and the
real fix is a float formatter. **Refusing is worth doing even without the
formatter**, because it converts a wrong answer into an error.

`probe/plug/showreal.codex`.

## 5. A module's exports come from another application's name list — THE MECHANISM LANDED

**A chapter can now say what it exports.** `7ee23eb9` in the wasm plug (Cobblestone
PR 112) reads a `wasm-exports : List Text` definition and roots those names; the
484-name allowlist stays as the fallback for chapters that declare nothing, which
is every chapter that exists today. So the hole this finding describes is now
*answerable* rather than closed, and the distinction matters: after re-pinning,
`build/world_native.wat` still exports `disk_reserve`, because `WorldCheck` has
never been given a `wasm-exports` line and falls through to the coincidence.

*Fixed. The investigation, the repro and the evidence are in git.*

## 6. Nothing is ever reclaimed — FIXED in both plugs

### In the emitted modules

*Fixed. The investigation, the repro and the evidence are in git.*

## 7. The vector ops have finding 1's shape — OPEN

`wat-bin-instr` answers `f64x2.add`, `f64x2.sub`, `f64x2.mul`, `f64x2.div` for
the `IrAddVec` family, and `emit-wat-binary` hands them the same untouched i64
operands that the scalar ops got before finding 1 was fixed. A `v128` is not an
i64 in either direction, so this cannot be a reinterpret away: it needs a
representation decision about how a `Vec` is carried, which is the same question
`RealTy`'s discarded width and mode raise.

**Reported from reading, not from running** — the safari port uses no vectors, so
no probe here reaches it. It is listed because it is the same defect class as
finding 1 and the fix for finding 1 does not touch it.


## 8. A text literal in a match-branch guard compares against address zero — FIXED

    classify (v) =
     when Boxed v
      is Boxed (x) when x == "zebra" -> "yes"
      is otherwise -> "no"

*Fixed. The investigation, the repro and the evidence are in git.*

## 9. Neither `env` import can be reached by any program — OPEN

`wat-runtime-header` can declare two imports, `blit_framebuf` and `on_key`, each
behind a flag. **Neither flag can be True for a program that assembles.**

`$on_key_import` is emitted by no arm of the emitter at all — the only
occurrence is the import line the flag guards — so `needs-key` is False always.
That much was known when finding 6's fix went in.

`blit-framebuf` is the same hole wearing a different coat, and finding 6's fix
claimed to have improved it. It has exactly one producer, the `blit-framebuf` arm
of `wat-try-builtin`. But **`blit-framebuf` is not a name the language has** — it
is nowhere in `codex/foreword` — so:

- a chapter that CALLS it without defining it halts at `CDX3002 Undefined name:
  blit-framebuf`, before any plug runs;
- a chapter that DEFINES it emits `(func $blit_framebuf …)` beside the import the
  flag just turned on, and `wat2wasm` answers `error: redefinition of function
  "$blit_framebuf"`. `wat-try-builtin` also hijacks the call sites ahead of the
  arity map, so the calls come out with the wrong arity too.

So `needs-blit` is True only for programs that cannot assemble anyway. **The
commit that introduced the IR query asserted the opposite** — *"a chapter that
DEFINES `blit-framebuf` … declared an import and a function under one name, which
`wat2wasm` refuses. Asking about call sites cannot do that."* It can, and does:
defining it and calling it sets the flag through the call. The query is correct
and cheap and is not what is wrong here.

The fix is not in this emitter: it is that both builtins need to be names the
language offers, the way every other builtin is, so that a program can call one
without defining it. That is finding 1's shape — an emitter arm with no reachable
front end — and it is a foreword decision about the browser shim's API rather
than a plug bug. Recorded, not fixed. `wasm-no-builtin` is named at the call site
so that whoever fills the `on-key` hole cannot miss the second place that has to
move with it.

---

## 10. A `when` inside a guard overwrites the scrutinee — FIXED

`emit-wat-match` parks the scrutinee in ONE per-function local and the
else-chain re-reads it for every branch below. The guard is emitted INSIDE that
chain's condition — five sites in `emit-wat-match-arm`/`emit-wat-ctor-pat` and
five more in the TCO twin — so a match in a guard reassigned the local and every
later branch then dispatched on the INNER scrutinee.

*Fixed. The investigation, the repro and the evidence are in git.*

## 11. `needs-blit` asked whether the name occurs, not whether it is called — FIXED

`wat-expr-calls-name`'s `IrName` arm was `nm == n`. That is an OCCURRENCE test,
so an ordinary binding spelled like the builtin set the flag:

*Fixed. The investigation, the repro and the evidence are in git.*

## 12. The fourth arm's guest road accepted a plug from any emitter — FIXED (ours)

**This one is not the plug's; it is ours, and re-pinning is what exposed it.**
`harness/wasm_arm.py`'s guest road opened with

*Fixed. The investigation, the repro and the evidence are in git.*

## 13. `--both` compares two roads that do not run the same IR — OPEN (ours)

**`./harness/wasm_arm.py --native --both` is RED, and no emitter is at fault.**
Measured 2026-08-31 on Num, Truck and GuardRail, after the re-pin, with the
guest plug rebuilt from the same commit the native road was built from:

    Num        135,565 vs 135,393 bytes
    Truck      186,538 vs 185,502
    GuardRail  243,548 vs 243,367

All three still AGREE with the zig arm on verdicts, so nothing here is a wrong
answer. The whole of Num's diff is one function:

    guest   (func $list_map ... (return_call $map_list ...))
            (func $map_list ...)                              (table $ft 33)
    native  (func $list_map ...)                              (table $ft 32)

plus the heap base moving by one byte and the elem/data sections shifting to
match. `$map_list` has exactly one caller.

**The mechanism, confirmed in the compiler rather than inferred from the shape.**
The two roads ask for different pipelines and always have:

    harness/wasm_arm.py:61       IR_FLAGS = " passes=text-plug"
    IR/Passes.codex:71           text-plug-ir-pipeline = ["fold-constants"]

    harness/CodexWasmHarness.codex:133   run-ir-pipeline default-ir-pipeline
    IR/Passes.codex:36           default-ir-pipeline =
                                   ["fold-constants", "inline-leaf-calls",
                                    "inline-single-caller"]

So `inline-single-caller` runs on the native road and not on the guest one. Any
check containing a one-caller function differs, and a check containing none does
not. **An earlier session had already derived that pass's rule from the compiler
source, independently and for another reason** -- see
`outbound/item4-inline-single-caller-issue.md`, the draft behind **issue 110**,
which asks upstream whether an erased definition should be visible. It reaches the same mechanism
from `IR/Lowering.codex:2429` without ever looking at a WAT, which is the
corroboration this finding would otherwise be missing — All three checks measured differ, so the claim "they are, on every check
here" was more likely never measured than measured on checks that happen to
contain no one-caller function.

**This is not the re-pin.** The nine 2026-08-31 commits are confined to
`codex/plugs/wasm/` and touch no pipeline, and the divergence dates to
`bff8e23`, the commit that introduced the native road — the same commit that
introduced the `default-ir-pipeline` call. It has been true of every `--both`
run since, and was simply never contradicted by the checks it was run on.

**Two ways out, and they are not equivalent.**

1. **Make the native harness ask for `text-plug` too.** Cheapest, and makes
   `--both` mean what it says. It also narrows what `--native --all` tests: the
   native road stops being the pipeline a real program would get.
2. **Give the guest road the default pipeline.** Truer to real use, but
   `wasm_arm.py`'s own docstring explains why `text-plug` is there — a plug that
   emits SOURCE resolves builtins by NAME, and `inline-leaf-calls` deletes the
   call that is the emitter's only handle on one. That hazard is real for this
   plug, and the native road is running into it today unremarked.

That second point is the interesting one and the reason this is written down
rather than patched: **the native road has been running the plug under a
pipeline the plug's own documentation says it should not be run under, and
17/17 pass anyway.** Either the hazard is narrower than the docstring claims, or
these checks do not reach it. Worth knowing which before choosing.

**The divergence paid for itself before it was fixed.** Issue 110's own "what we
have not done" said the pass's scale was unmeasured and that `inline-leaf-calls`
might account for cases blamed on `inline-single-caller`. Diffing the two roads
answers both, because a definition the pipeline erased is exactly one present on
this road and absent on that one: nine across Num, Truck and GuardRail, and
**eight are `inline-single-caller` only** -- their bodies still contain calls, so
they are not leaves, and each is referenced exactly once. `$both_sides` is a leaf
and stays ambiguous. Truck alone, a four-line check, loses seven: `bull_of`,
`step_at`, `next_tree_along`, `tree_x_for`, `r_tan`, `truck_schedule`,
`course_length`. Posted to issue 110 on 2026-08-31.

So a mode that cannot attribute a difference between two EMITTERS turned out to
attribute one between two PIPELINES exactly. That is worth keeping in mind when
choosing the fix: making both roads run the same pipeline would close finding 13
and also blind the only instrument that has ever measured this pass on real code.

Until then `--native --all` is the arm; `--both` reports a difference it cannot
attribute to an emitter.

## 14. The transpiler's freshness check cannot see a source change — OPEN (ours)

**Finding 12 one level up, and found the same way: by changing something and
watching what failed to notice.**

`harness/build_codexzig.sh` decides whether `codexzig` needs rebuilding with

    want=$(sha256sum "$tree/generated/codexzig.qemu.zig")
    [ "$(cat "$tree/generated/local/codexzig.fp")" != "$want" ] && rebuild

That asks whether the BINARY is current with respect to the GENERATED ZIG. It
never asks whether the generated zig is current with respect to the SOURCE the
transpiler is built from. Measured 2026-09-01, after editing
`codexzig-safari/source/CodexZigHarness.codex`:

    source/CodexZigHarness.codex   modified 00:09:57
    generated/codexzig.qemu.zig    still from 14:47:52
    fingerprint matches            YES  -- so no arm would rebuild

Every arm in this project takes its compiler through that script, so all of them
would have gone on running a binary built from a harness that no longer exists,
and nothing would have said so. The comment above the check is accurate about
what it does -- "content-addressed" -- and the content it addresses is the wrong
end of the pipeline.

**Why it is not simply a bug.** The script deliberately does NOT run `build.py`
on the happy path, because that is nine stages and three guests and does not
belong in a sweep. Hashing the source inputs instead would be nearly free, but
the source set is the whole bundle -- every chapter `bundle_codexzig.ps1`
resolves -- and that is exactly what `build.py` stage 3 computes. So the honest
fix is either to key on the bundle (a 50 ms pwsh run, the shape
`wasm_plug_build.stale()` already uses for finding 12) or to say plainly that
this script trusts a human to have rebuilt, and make the arms print which
transpiler they used.

`PROVENANCE.md` records the pin the binary was built from, and that record is
what caught it here -- it named `15ef1862` while the checkout had moved.

## Not the plug: `node:wasi` aborts on a large linear memory

Worth writing down because it cost an hour and would cost anyone else the same.

Running the plug's modules under node's `node:wasi`, four of fourteen safari
checks died with **SIGSEGV** — a process abort, not a catchable wasm trap —
after a varying number of lines: 2, then 10, then 2 again. **A crash that lands
mid-output is reported by a byte comparison as the two arms DISAGREEING**, which
is a defect claimed against code that is fine, and that is the expensive
direction to be wrong in.

It is not the codegen, and it is not V8:

- every V8 compiler setting crashes the same way (`--liftoff-only`,
  `--no-liftoff`, `--no-wasm-tier-up`);
- raising the stack does not help, and the modules need only **512 KB** under
  wasmtime;
- genuine stack exhaustion IS reported properly — `probe/plug/deeprec.codex` and
  `probe/plug/indirect.codex` both get a clean `RangeError`;
- and replacing `node:wasi` with a **twelve-line hand-written `fd_write`** in the
  same node, on the same modules, runs all of them correctly.

What separates the four is how far linear memory grows (finding 6): the crashers
reach 139–1,200 MB, and every module that stays under 40 MB is fine. The likely
mechanism is a view cached across `memory.grow`, which detaches the old buffer.

**Workaround: use wasmtime.** `harness/wasm_arm.py` and `harness/plug_probe.py`
both do, at `max-wasm-stack=16777216`, which is what the plug's own
`wasm-e2e.ps1` uses. `tools/README.md` has the install line.

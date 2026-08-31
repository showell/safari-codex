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

**Status.** Eleven findings, seven fixed and four open. Nothing has been sent
upstream yet, and the fixes sit on the integration branch as separate commits so
that each can be cherry-picked onto a single-purpose branch when it is:

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

**Findings 8 through 11 came from COLD REVIEWS rather than from the probes** —
8 and 9 from a review of the four commits above them, 10 and 11 from a second
review of the commits that fixed those. That is the useful fact about them: the corpus was green, the
byte comparisons were green, and both defects were sitting in code the sweep
cannot reach. Finding 8 is a silent wrong answer that had been there all along.

`PROVENANCE.md` describes that branch and why an integration branch is not a
pull request.

| # | finding | kind | status |
|---|---|---|---|
| 1 | `Real` is not implemented | wrong module / refused | **fixed** |
| 2 | `a ^ b` emits `a * b` | **silent wrong answer** | **fixed** |
| 3 | `show` of `INT64_MIN` emits garbage bytes | **silent wrong answer** | **fixed** |
| 4 | `show` on a `Real` prints its bit pattern | **silent wrong answer** | open |
| 5 | exports come from another app's hardcoded name list | surface | open |
| 6 | nothing is ever reclaimed; both emitters are superlinear | **ergonomics / ceiling** | **fixed in both plugs** — all 17 units emit, and `cat_draw` went 2,904→418 MB on the zig arm |
| 7 | the vector ops have finding 1's shape | wrong module | open |
| 8 | a text literal in a match-branch GUARD is missing from the string table | **silent wrong answer** | **fixed** |
| 9 | neither `env` import can be reached by any program | wrong module / hole | open |
| 10 | a `when` inside a GUARD overwrites the scrutinee the branches below read | **silent wrong answer** | **fixed** |
| 11 | `needs-blit` asked whether the name OCCURS, not whether it is called | wrong module | **fixed** |

And one bed problem that is not the plug's fault but bites anyone using it:
`node:wasi` aborts on modules with a large linear memory. It is at the bottom.

---

## 1. `Real` was not implemented — FIXED

**No Codex program that computes with `Real` had ever assembled through this
plug.** Every real on this target is carried as f64 bits in an i64 slot, which
is the right representation and was half built: the reinterprets that get a
value INTO an f64 operation and back OUT of it were missing.

- `IrNumLit` wrapped its literal in `f64.reinterpret_i64`, putting an f64 on a
  stack the ABI says is i64. The literal already IS the bit pattern.
- the Num/Real arithmetic emitted a bare `f64.add` on two i64 operands and
  stored an f64 result into an i64 slot.
- the four ordered comparisons emitted `i64.lt_s` **on the bit patterns**. Not a
  near miss: that reads the sign bit as the top of a two's-complement integer,
  so every negative real sorts above every positive one and `-2.0 < -1.0` is
  False. The foreword's own `real-min`, `real-max` and `real-abs` are three
  lines of `<` and `>`, so this reaches everything.
- `==` and `/=` agreed with `f64.eq` everywhere except the two places IEEE-754
  says they must not: NaN, and the two zeros.
- negation was a two's-complement subtract from zero.
- and four builtins had no form at all: `real-to-bits` / `bits-to-real`, which
  are the identity here because the value already IS its own bits, and
  `real-from-int` / `real-to-int`.

**How it failed is the good part**: `wat2wasm` refuses a module that pushes an
f64 where an i64 is declared, so this was never a wrong number, it was no
module. **The assembler is this emitter's type checker** and it is the reason
findings 1 and 7 are cheap to trust and findings 2, 3 and 4 were not caught for
free.

**`real-to-int` is the one row that is not obvious.** Bare metal emits
`cvttsd2si` (`X86_64Builtins.codex:1663-1679`) and answers INT64_MIN for a NaN,
an infinity, or an out-of-range truncation. wasm's `i64.trunc_sat_f64_s` agrees
on all of those EXCEPT NaN, where it saturates to 0, and positive overflow,
where it saturates to INT64_MAX. Emitting the bare instruction would be a
plausible wrong number on exactly the inputs a guard exists for, so the two
disagreeing cases are tested first. `probe/plug/realedge.codex` is the check.

**Width and mode are discarded**, exactly as the zig plug discards them: an f32
`Real` is computed as f64 and a trapping `Real` does not trap. That is a
house-wide position (`PLUG_WORK.md`), not this chapter's to take.

## 2. `a ^ b` emits `a * b` — FIXED

    2^10 = 1024   (zig)      2^10 = 20   (wasm)
    3^4  = 81                3^4  = 12
    5^0  = 1                 5^0  = 0

`^` desugars to `OpPow` (`Desugarer.codex:257`) and lowers to `IrPowInt`
(`LoweringTypes.codex:186`). The zig plug emits `cx_ipow(a, b)`. The wasm plug's
`wat-bin-instr` answered **`"i64.mul"`**.

**This is the worst shape a plug defect can have**: the module assembles, runs,
and prints a wrong number. Nothing refuses it, because multiplying two i64s is
perfectly well typed.

The cause is structural rather than a typo, and worth naming: `wat-bin-instr`
is a table from an IR op to ONE INSTRUCTION, and integer exponentiation is not
one instruction. Faced with a row it could not express, the table got the
nearest thing that type-checked. **A table that cannot say "no" will say
something wrong**; `emit-wat-binary` above it can emit a call and is where the
arm belongs. The fix adds a `$cx_ipow` loop to the runtime and moves the arm up
there; `wat-bin-instr` keeps a row reading `"i64.pow-does-not-exist"`, because
the match must stay exhaustive and an unreachable arm should fail at the
assembler if it ever stops being unreachable.

`probe/plug/pow.codex`.

## 3. `show` of `INT64_MIN` emits garbage bytes — FIXED

    to-int 2^64 = -9223372036854775808   (zig)
    to-int 2^64 = -\xfa\n\n\x00\x00\xfc\n0...  (wasm)

Both digit loops — `wat-rt-i64-to-text` and `wat-rt-print-i64` — make the value
positive and then take its digits:

    (local.set $abs (i64.sub (i64.const 0) (local.get $val)))

`0 - INT64_MIN` is INT64_MIN again. `$abs` stays negative, `i64.rem_s` answers a
NEGATIVE digit, and `digit + '0'` lands below the digit range: nineteen junk
bytes behind a correct minus sign. The loop still terminates, so there is no
crash and no diagnostic.

**The value was right and only the rendering was wrong**, which is why this was
found by a probe about `real-to-int` rather than by anything looking at `show`:
all four INT64_MIN results in `realedge` matched the zig arm as numbers.

**The fix goes the other way round.** Every i64 has a negative twin and no
positive value overflows on negation, so the loop runs on the non-positive side
and `0 - (rem_s val 10)` brings each digit back into 0..9. Total, both signs, no
guard.

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

## 5. A module's exports come from another application's name list — OPEN

`wat-emit-exports` decides what a module exports by testing each definition name
against `wasm-export-list`: a single pipe-separated string of about four hundred
names, hardcoded in the emitter, drawn from unrelated applications —
`select-all`, `random-color`, `species-count`, `cad-set-units`, `kpt-mandelbrot`,
`tank-xmin`.

A probe defining `select-all`, `random-color` and `species-count` exports all
three:

    (export "random_color" ...)  (export "select_all" ...)  (export "species_count" ...)

Nothing is wrong-answer here and the values match. But the module's PUBLIC
SURFACE is decided by a coincidence of naming with somebody else's API, and it
is decided silently in both directions: a program that means to export
`render-frame` gets it, a program that happens to define `select-all` leaks it,
and a program that wants to export `my-entry` cannot say so. An `export`
annotation, or a manifest, would be the shape; anything is better than a
four-hundred-name allowlist that grows every time an app is written.

`probe/plug/exports.codex`.

## 6. Nothing is ever reclaimed — FIXED in both plugs

### In the emitted modules

The emitted prelude bump-allocates and never frees. Memory grows with the number
of allocations a run performs, not with what is live. Final linear memory for the
safari checks, none of which holds more than a few thousand numbers at once:

| check | prints | final linear memory |
|---|---|---|
| `PondCheck` | 8 lines | 16 MB (no growth) |
| `WorldCheck` | 25 lines | 20 MB |
| `RiderCheck` | 14 lines | 139 MB |
| `MountainsCheck` | 7 lines | 264 MB |
| `RideCheck` | 6 lines | 284 MB |
| `RenderCheck` | 20 lines | **1,200 MB** |

**A module that prints twenty lines touches 1.2 GB.**

### The sharp version: it is the EMITTERS, and the front end is not the story

**The obvious reading — that the wasm emitter is an outlier — is wrong. So was
the correction.** The 2026-08-30 revision said "a 696 KB unit costs 2.9 GB
before either emitter is reached", inferred from codexzig's total peak. It is
off by an order of magnitude, and the way to see that is to read the frontier
between the phases rather than at the end.

The bump heap never reclaims (`PORTING_NOTES` C6), so `__heap-save` IS the
running total of everything allocated so far: the difference between two phase
boundaries is what that phase cost, exactly, with no sampling.
`./harness/mem_probe.py` writes those marks into both harnesses mechanically —
they are the same program with one line different, so a hand-instrumented pair
could differ somewhere else and nobody would see it — and reads a high-water
cursor patched into the prelude for the part the marks cannot see.

`cat_draw-unit.codex`, 696,563 bytes, retained MB at each phase:

| phase | `codexzig` | `codexwasm` |
|---|---|---|
| tokenize | 24 | 24 |
| scan | 13 | 13 |
| parse | 43 | 43 |
| resolve | 4 | 4 |
| check | 9 | 9 |
| lower + IR pipeline + lift | 3 | 3 |
| resolve the expression-type table | 1 | 1 |
| emit IR text | 77 | 77 |
| parse IR text back | 120 | 120 |
| **the whole front end** | **294** | **294** |
| **emit** | **2,549** | *dies* |
| peak RSS | 2,904 | 3,666 |

**The front end is 10% of the bill and the two arms pay it byte for byte.** Of
codexzig's 2,904 MB, 2,549 MB is `emit-zig-chapter` alone. There is no shared
cost to attack; there are two emitters, and they fail in two different ways.

### codexzig: the same defect, in the same place — FIXED, `3c13334d`

`emit-zig-chapter` returns the module as a single value and nothing is streamed,
so every definition's working set is live at once. Cost per byte of output,
which is what says it was superlinear rather than merely large:

| unit | zig emitted | emit cost | bytes of heap per byte out |
|---|---|---|---|
| `pond` | 31,211 | 5 MB | 160 |
| `world` | 197,505 | 74 MB | 375 |
| `cat_draw` | 2,555,224 | 2,549 MB | 998 |

**A fixed cost per byte does not grow with the file**, and `emit-zig-list-elems`
turned out to be the same right-recursive join the wasm plug had — in a file
that already carries the argument against it. `emit-zig-defs`, seventeen hundred
lines down, says: *"joining N pieces with a right-recursive `&` copies every
piece it has not reached yet, so the cost is the output size times the number of
definitions rather than the output size. Collect and join once."* That note was
written about the module; the elements of a list literal were left doing exactly
what it warns against.

Collect-and-join, this file's own idiom, byte-identical output:

| unit | before | after |
|---|---|---|
| `pond` | 16 MB | 16 MB |
| `world` | 116 MB | **60 MB** |
| `cat_draw` | 2,904 MB | **751 MB** |
| `safari` | — | 1,243 MB |

**Time barely moves** — `cat_draw` 14.5 s → 14.1 s — and that is the honest
reading of the whole finding: a bump allocator makes the allocation itself
cheap, so what the quadratic bought was a CEILING, not a slowdown. It is also
why it hid for so long, and why C17's warning that an allocator which never
frees is very good at hiding an algorithmic mistake behind itself is the note
that mattered here.

The fixed point HOLDS byte-identical, `samples/arith` matches all nine lines,
the emitted zig for `pond`, `world`, `cat_draw` and `safari` is byte-for-byte
what the previous binary emitted, and `./harness/run.sh` is GREEN.

**The shape was the other half, and it is fixed too — `1893cf1e`.** With the
quadratic gone, the zig emitter's cost per byte of output is flat at 96–160
across `pond`, `world` and `cat_draw`. Flat is not safe: it is a SUM over
definitions, so it grows with the module, and there is no unit large enough to
be safe — only units small enough to have got away with it.
`emit-zig-chapter-stream` marks the heap, emits one definition, prints it and
restores, which makes the cost the max.

**The obstacle is worth naming, because it is what kept this emitter whole-text
while the wasm one streamed.** `zig-prelude-for` shakes the prelude against the
FINISHED program text — it searches it for each of a hundred part names — so an
emitter that prints a definition and forgets it has nothing left to search. The
answer is to ask the question definition by definition and carry only the
answer: a hundred yes/no bits is two `Integer`s, and an integer is a scalar, so
both survive a `__heap-restore` where a list would not.

| unit | before | after |
|---|---|---|
| `pond` | 16 MB | 13 MB |
| `world` | 60 MB | **44 MB** |
| `cat_draw` | 752 MB | **418 MB** |
| `safari` | 1,243 MB | **674 MB** |

`emit-zig-chapter` is **kept and is not a fallback**: `ZigPlug`, `ZigStdio` and
`ZigPlugRing` still call it, so the ring plug that compiles this emitter on bare
metal emits the whole-text way while the native binary streams — and **the
transpiler's fixed point then compares the two paths against each other** on
2.98 MB of the compiler's own source. It holds byte-identical, which is a better
test of the change than anything written for it.

Against where finding 6 started, `cat_draw` through `codexzig` is 2,904 → 418
MB, and most of what is left is the front end's own 294 MB rather than the
emitter's. `./harness/build_codexzig_try.sh` is what made this cheap to iterate
on: `build.py`'s three host-only stages, about a minute, no guest, and every arm
takes the candidate through `CODEXZIG`.

### codexwasm: it already HAD the fix codexzig lacks — FIXED, `2aff6e4d`

`emit-wasm-chapter-stream` brackets every definition in
`__heap-save`/`__heap-restore` and prints it, so its cost is the max over
definitions instead of the sum. That worked: on `world` it retained 11 MB where
the zig emitter of the day retained 74. **On the axis the finding accused it of,
the wasm plug was already seven times better than the zig plug.** Both numbers
are of that moment — the zig emitter has since been fixed twice.

What killed it was inside one definition. Measured on `world`, per-definition
transient against the bytes that definition emits:

| definition | WAT emitted | heap, before | heap, after |
|---|---|---|---|
| `$g_w_trees` | 171,884 | 97.3 MB | **4.4 MB** |
| `$g_w_cows` | 130,850 | 53.2 MB | 3.3 MB |
| `$g_w_treecolor` | 49,250 | 9.5 MB | 1.2 MB |

Before, that is roughly `len² / 300` — within 4%, 2% and 23% of the three, in
the MiB the instrument reports — and **quadratic in the size of one
definition**. The exponent between successive pairs is 1.76, 1.86 and 2.21, so
the word is carried by the named mechanism below rather than by three points;
and the 300 is not a law, because the cost is `n · len / 2` and only equals
`len² / 2e` while the elements run about 150 bytes each, as these three happen
to. On `cat_draw` a single definition ran the frontier from 856 MB into the
ceiling:

    thread panic: cx heap: exhausted at 4294829549 + 973866 of 4294967296

**The cause is C17, exactly, one level down.** `emit-wat-list-elems` walked a
list literal's elements left to right and concatenated as it went, and text is
immutable, so it allocated the sum of its own suffixes — quadratic in the number
of elements for output linear in them. The per-definition restore cannot help,
because all of it is inside ONE bracket. That is why the ceiling was the biggest
DEFINITION rather than the biggest chapter, and why `$g_kd_xy` — one generated
table in one chapter — was enough on its own.

**The fix is C17's fix: split the range in half, build each half, concatenate
once.** Each byte is then copied once per level instead of once per remaining
element. The output is byte-identical *by construction* — same pieces, same
order, different association — which is what makes it safe to do to an emitter
whose whole job is exact bytes.

| unit | before | after |
|---|---|---|
| `world` | 150 MB, 0.44 s | **57 MB, 0.42 s** |
| `critter` (385 KB) | died at 4 GiB | **226 MB, 1.2 s** |
| `cat_draw` (696 KB) | died at 4 GiB, 33.0 s | **394 MB, 2.2 s** |
| `safari` (1.17 MB) | died at 4 GiB | **680 MB, 5.7 s** |

**The `world` "before" is 0.44 s and not 0.63 s.** The discarded scans had
already gone by then and took 0.63 → 0.44 with them; an earlier version of this
table charged their saving to this change as well. What this change bought is
almost no time at all — it bought the other three rows.

**`codexwasm` now reaches all seventeen units in one process**, which is what
the two-process guest road could do and this one could not — so the
`codexir | wasmemit` split is not needed and was never the right answer.
`./harness/wasm_arm.py --native --all` is GREEN — which is the tool's own check:
it runs both roads and compares what the two modules PRINT, not their bytes. The
byte comparison is a separate `cmp` against the previous sweep's saved WAT, 14 of
17 identical, and the 3 that differ are exactly the 3 that used to die mid-emit
and write a truncated module.

**And the comparison stopped meaning what it did.** The finding opened by
saying the wasm emitter costs 1.26x the zig one, as if that ratio located a
defect. Both plugs have since been fixed and the ratio has not settled anywhere
in particular, because it never was the thing to measure — peak RSS, both plain
binaries, after everything below:

| unit | `codexzig` | `codexwasm` |
|---|---|---|
| `pond` | 13 MB | 17 MB |
| `world` | 44 MB | 57 MB |
| `critter` | 253 MB | 226 MB |
| `cat_draw` | 418 MB | 394 MB |
| `safari` | 674 MB | 680 MB |

The wasm arm is ahead on the big units, behind on the small ones, and within one
per cent on the largest. Both peaks are the front end plus the biggest
definition, and the wasm arm carries a larger fixed runtime on top, so any
single ratio quoted from this table is a fact about one unit. **An intermediate
version of this section said "the two arms now agree to within 3%", measured on
`world` between the two zig-plug fixes. It was true for about an hour, and it is
the kind of sentence to stop writing.**

The same right-recursive shape is in seventeen other emitters in
`WasmEmitter.codex` — params, locals, apply args, exports — and is harmless in
most of them because the lists are short. `emit-wat-list-elems` is the one that
was killing chapters.

### Two thirds of what the wasm emitter did was thrown away — FIXED

Found on the way, and independent of the above.

`emit-wasm-chapter-stream` must decide whether to declare the `env` imports
before it prints any definition, and it asks by EMITTING EVERY DEFINITION IN
FULL and running `text-contains` on the result:

    wasm-defs-mention (ctx) (defs) (i) (needle) =
     ... let hit = text-contains (emit-wat-def ctx (list-at defs i)) needle

It does this twice, for `$blit_framebuf` and `$on_key_import`, and throws both
results away. Grouping the per-definition brackets by their restore base
separates the passes; on `world`, 160 definitions:

    320 brackets   510 MB   the two needle scans      discarded
    160 brackets   256 MB   wasm-stream-defs          printed

**`$on_key_import` is emitted by no arm of the emitter at all** — the only
occurrence in the file is the import line the flag guards — so that scan can
never answer True and always walks the whole chapter to say False.
`$blit_framebuf` has exactly one producer, the `blit-framebuf` arm of
`wat-try-builtin`, so both flags are decidable from the IR without emitting a
byte. (Cited by name: that line has moved twice since, both times because of a
commit in this document.) (A chapter DEFINING `blit-framebuf` would emit
`(func $blit_framebuf` and hit the needle too — but that module already declares
an import and a function under one name and `wat2wasm` refuses it, so the scan
is not what is protecting anybody there.)

This does not move the peak — the scans and the print run at the same frontier,
so the ceiling is still the worst definition — but it is 2/3 of emission's time
and churn for nothing. It also decides where a failure lands: on `cat_draw`
codexwasm died at definition 41 **of the first needle scan**, so it never
reached the definitions it was asked to print, and the panic named a phase that
exists only to compute a boolean.

**Fixed in `121b61fb`.** `wat-expr-calls-name` asks the IR instead, mirroring
`collect-strings-expr` arm for arm — which is the argument for its coverage,
since that shape already has to reach every text literal in the program or the
string table comes out short. The three fixed pieces are still scanned as text
because they are built already.

Where the two criteria differ the old one was **wrong**: a chapter defining
`blit-framebuf` emits `(func $blit_framebuf`, the needle hit, and the module
declared an import and a function under one name — which `wat2wasm` refuses.

**Output is unchanged and that is the check**: 16 of this project's 17 checks
emitted byte-identical WAT, `cat_draw` got 120 definitions and 10.9 MB in before
dying on `$g_kd_xy` — the definition the quadratic model names — and `world`
went 0.63 s → 0.44 s at an unchanged 150 MB peak, exactly the shape predicted,
since the wasted work was time and churn and never the ceiling.

**That 16 was worth less than it looked, and how it misled is the useful part.**
THREE units were still exhausting the reserve here, not one: `critter` and
`safari` as well, as the next section's table says. They scored as
"byte-identical" because a run that dies mid-emit writes a TRUNCATED module, and
each truncated in the same place as the run before it. A byte comparison against
a previous failure is evidence of nothing, and a count that folds two of them in
reads as though a single unit failed.

**The sharper limit is what the corpus cannot reach at all**: none of the
seventeen emits an `env` import, so none exercises the branch this commit
rewrote. The check shows the flag did not accidentally turn ON. Nothing here
could have shown it wrongly turning OFF — for which see finding 8, found by a
cold review that went looking rather than by the sweep.

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

    zig plug   yes / no          wasm plug   no / no

`collect-strings-branches-loop` walked each branch's BODY and never its guard,
so a text literal appearing only in a guard never reached the string table.
`strtab-lookup` answers **0** for a miss, so the comparison ran against address
zero and quietly failed. The module assembles, runs, and prints a wrong answer —
findings 2, 3 and 4's shape, and the worst one a plug can have.

`collect-locals-branches-loop` had the identical hole: a `let` inside a guard
yields a local that is used and never declared. `wat2wasm` refuses that by name,
so that half fails LOUDLY — which is the only reason it was the second one found
and not the first.

**The zig plug had already fixed this class and left the note**, at
`zig-occurs-branches`: *"A branch's GUARD is part of the branch. Reading only the
body answered 'does not occur' for a name a guard mentions… every caller of this
uses the answer to decide whether to discard something."* The wasm plug never got
that pass. An unguarded branch carries a `True` literal as its guard, so walking
it costs nothing on the common shape.

**`wat-branches-call-name` — added by finding 6's own fix, four commits earlier —
copied the hole from the same model, and that is the part worth keeping.** The
argument offered for that walker's coverage was that it *"mirrors
`collect-strings-expr` arm for arm, which is the argument for its coverage: that
shape already has to reach every text literal in the program or the string table
comes out short."* The mirroring was exact. The premise was false. **Mirroring a
walker inherits its blind spots, and an argument from a model is worth an audit
of the model.**

Not found by the corpus: none of this project's seventeen checks puts a literal
in a guard, all seventeen still emit byte-identical WAT, and all seventeen agree
with the zig arm. `probe/plug/guardstr.codex` is the case.

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

```
  classify (v) =
   when v
    is Boxed (x) when (when x is 7 -> True is otherwise -> False) -> 100
    is Boxed (y) -> 200 + y
    is Plain (z) -> 300 + z
```

    zig plug   100 / 205 / 305      wasm plug   100 / 720575940396056776 / 305

It assembles, `wat2wasm` is happy, and the answer is a pointer read as an
integer. `probe/plug/guardnest.codex`. The match has to be INLINE in the guard:
a call to a function whose body is a match compiles to a separate wasm function
with a scrutinee local of its own and agrees — which is also why the port never
saw this, and why the inliner can produce the shape from code that does not
contain it.

**Fixed in `2a53929f`**: the scrutinee local is per guard-nesting depth. A match
in a branch BODY still shares the local, correctly — once a body is selected the
else-chain is dead. The names are unary (`_s`, `_ss`, `_sss`) so the locals
collector shifts a guard's names by one and merges, instead of threading a depth
parameter it could get out of step with. All 17 units come out BYTE-IDENTICAL,
because nothing in the port nests a match in a guard.

**This is the third defect in a row in the walkers around match branches**, and
the first two were found by the reviews of the commits that fixed the ones
before. Finding 8 fixed the string table's blind spot toward guards; this is the
same blind spot in the emitter half, which that fix's own comment declared
swept.

## 11. `needs-blit` asked whether the name occurs, not whether it is called — FIXED

`wat-expr-calls-name`'s `IrName` arm was `nm == n`. That is an OCCURRENCE test,
so an ordinary binding spelled like the builtin set the flag:

```
  double (n) =
   let blit-framebuf = n * 2
   in blit-framebuf + blit-framebuf
```

emits `(import "env" "blit_framebuf" ...)`, **assembles**, and dies at
instantiation with `unknown import: env::blit_framebuf`. A parameter of that
name does the same. `probe/plug/blitname.codex`; 84 both ways now.

`121b61fb` introduced the query to replace a text scan over the emitted module,
and `e6f09556` reviewed it and said in as many words that it "is correct and
cheap, and it is not what is wrong here". Both were describing what the walker
was meant to ask rather than what it asked. **Fixed in `2a53929f`**: a call is a
name in the HEAD of an apply spine.

Finding 9 stands as written — both builtins remain unreachable by any program
that assembles, and this fix does not change that. What it removes is a way for
a program with no interest in the builtin to emit an import for it.

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

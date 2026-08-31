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

**Status.** Seven findings, three fixed, one half fixed and three open. Nothing
has been sent upstream yet, and the fixes sit on the integration branch as
separate commits so that each can be cherry-picked onto a single-purpose branch
when it is:

    cobblestone-safari  e8486215  finding 1, also on `wasm-plug-real-conversions`
                        b5b1bb74  findings 2 and 3
                        121b61fb  finding 6's discarded scans
                        2aff6e4d  finding 6's ceiling: list literals in halves

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

## 6. Nothing is ever reclaimed — OPEN, and this is the one to push on

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
that already carries the argument against it. `emit-zig-defs`, three thousand
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
definitions instead of the sum. That works: on `world` it RETAINS 11 MB where
the zig emitter retains 74. **On the axis the finding accused it of, the wasm
plug was already seven times better than the zig plug.**

What killed it was inside one definition. Measured on `world`, per-definition
transient against the bytes that definition emits:

| definition | WAT emitted | heap, before | heap, after |
|---|---|---|---|
| `$g_w_trees` | 171,884 | 97.3 MB | **4.4 MB** |
| `$g_w_cows` | 130,850 | 53.2 MB | 3.3 MB |
| `$g_w_treecolor` | 49,250 | 9.5 MB | 1.2 MB |

Before, that is `len² / 300` to within 20% across all three — **quadratic in the
size of one definition**, and on `cat_draw` a single definition ran the frontier
from 856 MB into the ceiling:

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
| `world` | 151 MB, 0.63 s | **57 MB, 0.42 s** |
| `critter` (385 KB) | died at 4 GiB | **226 MB, 1.2 s** |
| `cat_draw` (696 KB) | died at 4 GiB, 33.0 s | **394 MB, 2.2 s** |
| `safari` (1.17 MB) | died at 4 GiB | **680 MB, 5.7 s** |

**`codexwasm` now reaches all seventeen units in one process**, which is what
the two-process guest road could do and this one could not — so the
`codexir | wasmemit` split is not needed and was never the right answer.
`./harness/wasm_arm.py --native --all` is GREEN: 14 of the 17 emit byte-identical
WAT and the 3 that differ are exactly the 3 that used to die mid-emit and write
a truncated module. All seventeen agree with the zig arm.

**And the comparison has inverted.** `world`, peak RSS: `codexzig` 116 MB,
`codexwasm` **58 MB**. The finding opened by saying the wasm emitter costs 1.26x
the zig one; it costs half. The zig plug has since had the same fix — below —
and lands at 60 MB, so the two arms now agree to within 3%.

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
`$blit_framebuf` has exactly one producer, the `blit-framebuf` builtin arm at
`WasmEmitter.codex:1453`, so both flags are decidable from the IR without
emitting a byte. (A chapter DEFINING `blit-framebuf` would emit
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
emit byte-identical WAT through `./harness/wasm_arm.py --native --all`. The
seventeenth is `cat_draw`, which still exhausts the reserve — that is the
ceiling above, not this — but now gets 120 definitions and 10.9 MB of WAT in
before it dies, on `$g_kd_xy`, which is the definition the quadratic model
names. `world` went from 0.63 s to 0.44 s at an unchanged 150 MB peak, which is
exactly the shape predicted: the wasted work was time and churn, never the
ceiling.

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

---

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

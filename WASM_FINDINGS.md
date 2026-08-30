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

**Status.** Seven findings, three fixed and four open. Nothing has been sent
upstream yet, and the fixes sit on the integration branch as separate commits so
that each can be cherry-picked onto a single-purpose branch when it is:

    cobblestone-safari  e8486215  finding 1, also on `wasm-plug-real-conversions`
                        b5b1bb74  findings 2 and 3

`PROVENANCE.md` describes that branch and why an integration branch is not a
pull request.

| # | finding | kind | status |
|---|---|---|---|
| 1 | `Real` is not implemented | wrong module / refused | **fixed** |
| 2 | `a ^ b` emits `a * b` | **silent wrong answer** | **fixed** |
| 3 | `show` of `INT64_MIN` emits garbage bytes | **silent wrong answer** | **fixed** |
| 4 | `show` on a `Real` prints its bit pattern | **silent wrong answer** | open |
| 5 | exports come from another app's hardcoded name list | surface | open |
| 6 | nothing is ever reclaimed | **ergonomics / ceiling** | open — **push here** |
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

### The sharp version: codexwasm is not as robust as codexzig, and it should be

The same property puts a ceiling on the native transpiler.
`./harness/build_codexwasm.sh` produces a binary that runs the front end and the
emitter in one process on one heap, and three of this project's seventeen units
exhaust the prelude's 4 GiB reserve: `Critter` (385 KB), `CatDraw` (696 KB) and
`Safari` (1.17 MB).

**The obvious reading — that the wasm emitter is an outlier — is wrong, and the
measurement is what says so.** Peak RSS, the same input down both native
transpilers:

| unit | `codexzig` | `codexwasm` |
|---|---|---|
| `pond-unit` (18 KB) | 16 MB | 17 MB |
| `world-unit` (95 KB) | 115 MB | 149 MB |
| `cat_draw-unit` (696 KB) | **2,902 MB** | **3,665 MB** |

The wasm emitter costs about **1.26x** what the zig one costs. That is the whole
gap, and it is not where the memory goes: **a 696 KB unit costs 2.9 GB before
either emitter is reached.** `codexzig` survives the same units only because it
sits just under the line that `codexwasm` crosses. It is not robust; it is
lucky, and it will stop being lucky on a larger unit.

**Raising the reserve is not the answer and was measured rather than assumed.**
The reserve is a plain constant in the prelude and a native host has a 64-bit
`usize`, so it can simply be larger — except that at 12 GiB the reservation is
refused outright (`cannot reserve the region`), and at 6 GiB on this 8 GB box the
process is OOM-killed. Raising it converts a clean panic into a worse failure.
The memory has to not be allocated.

**Splitting into `codexir | wasmemit` is available and is NOT what we want.**
Two processes, each with a fresh heap, is what the guest road already does and it
is why the guest road reaches all seventeen. It would work. It is a workaround
for a property that should be fixed, and it would leave `codexwasm` permanently
second-class beside `codexzig` for no reason anyone could defend.

**Steve's call, and the direction for the next session: push hard on the
allocation itself.** `codexwasm` should be as robust as `codexzig` in principle,
so the target is the shared cost — 2.9 GB for a 696 KB unit, before any emitter
runs — and after that the emitter's own 26%. The module already exports
`__heap_reset` and `__deck-set`/`__heap-advance` exist, so the machinery for an
arena discipline is there and nothing in the ordinary path uses it.
`PORTING_NOTES` C8 is the same problem seen from the browser, where the fix was
a hand-written shim resetting the arena once a frame — which is evidence that
resetting is safe at a phase boundary, and a transpiler has obvious ones.

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

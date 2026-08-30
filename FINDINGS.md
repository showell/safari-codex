# Findings owed upstream

Eight, written up and **not yet sent**. Each is self-contained: what was observed,
how to reproduce it, and what the fix looks like. Six are owed to Cobblestone and
the zig plug, two to angry-gopher, and the two halves are independent.

Every one of these came out of porting the Safari driving screensaver from Zig to
Codex (`README.md` is the orientation) — that is, out of ordinary use of the
toolchain rather than out of looking for defects. Where a number is quoted, the
measurement that produced it is named.

Verified against: Cobblestone `NewRepository` @ `u52-rebank`, the transpiler
`codex-zig-transpiler` @ `real-int-conversions`, zig 0.16.0.

**Re-verified against `u53-rebank` (`58b08c38`) on 2026-08-30, from the ladder
repository, and three of the six Cobblestone items moved.** Item 1's mechanism
was misattributed to the wrong half of the compiler, item 3 is now *caused* by
the fix it proposes, and item 6's mechanism is written out in Cobblestone's own
source rather than reconstructed. Item 2 re-read and confirmed exactly as
written. **Items 4 and 5 were not re-run against u53** — they are behavioural,
not citations, and nothing here should be taken as evidence they still
reproduce. All line numbers below are u53; the u52 numbers this file carried
were stale, which is the whole reason for the pass.

---

## How these should travel

Not all eight are the same kind of thing, and sending them the same way would waste
the small ones and overreach on the large ones. The standing rule applies: we are
not responsible for non-zig plugs, nor for fully testing core-compiler changes.

**Already sent.** `real-to-int` / `real-from-int` went as **Cobblestone PR 100**
(branch `zig-plug-real-conversions`). `real-to-bits` / `bits-to-real` went as
**Cobblestone PR 105** on 2026-08-30 (branch `zig-plug-real-bitcast`, register
entry `plugs-backlog 2.07`, new test `codex/test/ops/real-bitcast-f64`), stacked
on PR 100's head and graded against it: 0 stage moves, 0 verdict moves, 579 of
582 emitted zig files byte-identical and the three that differ differing only by
the intended substitution.

**Send as a PR — small, mechanical, no policy call.**

- **Item 2, Cordic.** The whole test is `cites Math chapter Cordic` and one
  `print-line-uni "Math/Cordic OK"` — verified 2026-08-30, it calls nothing, and
  its `.expected` is that one line. It passes whether or not Cordic works. The fix
  is two things a patch can carry: correct the docstring to the measured 0.45%, and
  give the test values to compare. This is the same shape as PR 100's
  `real-int-conversions` test and is the strongest remaining candidate.
- **Item 3, single-letter names.** Plug-side, self-contained, and now a one-line
  rename: the tuple constructors' comptime parameters (`a_`–`d_`) must move out of
  the namespace `zig-sanitize` renames reserved user names into. **The second
  option this bullet used to offer is already in the tree and is what causes the
  collision** — see the entry. Strongest PR candidate after item 2, and smaller.

**Offer as a PR — an addition rather than a defect.**

- **`Trig`'s `r-atan`.** There is **no Real arc tangent anywhere in the foreword**
  — verified by signature across all 13 directories; Cordic, Geodesic, Kinematics
  and Vector mention `atan` and none of them at Real. Ours matches zig's to 1e-9
  over eighteen values including the reciprocal branch. `README`'s pickup section
  has the context.

**Open as an ISSUE — the fix is a decision we should not make from outside.**

- **Item 1, `OvError`.** Stronger than when this was written. The overflow mode is
  discarded in LOWERING (`LoweringTypes.codex:184`) and the IR has one integer
  multiply, so no plug can fix it and the C# plug's identical text is not evidence
  of a convention — every plug is handed the same information-free opcode. Ask
  whether the type should stop promising what nothing downstream can deliver. The
  Real half of the old diagnosis is a genuine, separate, plug-side defect and is
  noted in the entry.
- **Item 6, the `Real` literal. DRAFTED, not yet sent —
  [`outbound/item6-real-literal-issue.md`](outbound/item6-real-literal-issue.md).**
  It is the FRONT END — both arms print the same
  wrong constant and the value arrives at the emitter as a bit pattern. No longer a
  reconstruction: `ZigEmitter.codex:3885` states the wrapping accumulator in
  Cobblestone's own comment, and that comment also gives the constraint on any fix
  (plug and seed must agree bit for bit), which is precisely the decision we should
  not make from outside. Carries a concrete, cheap ask: the values that
  `codex/test/ops/real-literal-rounding` is missing.

**Investigate before choosing.**

- **Item 4, one-expression inlining**, and **item 5, the missing diagnostics**.
  Each fix shape names two acceptable outcomes and which one is right is the
  maintainer's call; item 5's own text says the interesting answer is *which* of
  two causes it is, and that is a question, not a patch.

**To angry-gopher, as ordinary PRs against that repo.** Item 7 is a one-line
buffer fix and it is on a LIVE path — the truck's headlight beams draw it every
dusk frame — so it should not wait on the Cobblestone queue. Item 8 is a comment
correction.

---

## To Cobblestone / the Zig plug

### 1. `OvError` silently becomes a wrapping multiply — wrong answer, exit 0

**Severity: high.** A declared trapping semantics is emitted as a wrapping one, so
an overflow produces a plausible wrong number with no diagnostic anywhere.

Codex declares `IntegerTy i64-min i64-max OvError`. The zig plug emits `*%`.

```
  big : Integer
  big = 4000000000

  opening : [Console] Nothing = act
    print-line-uni ("4e9 * 4e9 = " & show (big * big))
  end
```

emits `cx_show_int((big() *% big()))` and prints

```
4e9 * 4e9 = -2446744073709551616
```

with exit status 0. Re-verified 2026-08-30; first measured in `price-b/ovf.codex`.

**CORRECTED 2026-08-30 against u53. This entry used to blame
`ZigEmitter.codex:1270-1273` and the approx / trapping / saturating collapse. That
is the wrong half of the compiler**, and the true answer is worse: the plug never
had the information to begin with.

The overflow mode does not survive lowering. `IRChapter.codex:5` gives the IR
exactly **one** integer multiply, beside three distinct Real ones:

```
  IRBinaryOp =
   | IrAddInt | IrSubInt | IrMulInt | IrDivInt | IrPowInt | IrRemInt
   ...
   | IrAddRealTrapping | IrSubRealTrapping | IrMulRealTrapping | IrDivRealTrapping
```

and `LoweringTypes.codex:184` selects it with no branch for the mode at all:

```
  is OpMul -> if is-vector-type ty then IrMulVec
              else if is-real-saturating-type ty then IrMulRealSaturating
              else if is-real-trapping-type ty then IrMulRealTrapping
              else if is-real-approx-type ty then IrMulRealApprox
              else if is-number-type ty then IrMulNum
              else IrMulInt
```

`OvError` and `OvWrapping` are the only two modes (`CodexType.codex:97-98`) and
both fall through to `IrMulInt`. The mode is discarded **in lowering, in the core
compiler**, before any plug is handed anything. `ZigEmitter.codex:1313` emits
`is IrMulInt -> "*%"` because `IrMulInt` is all it receives.

**That is why the C# plug is character-for-character identical**, and the identity
means less than this file claimed. Every plug gets the same information-free
opcode, so their agreement is not a shared house convention — it is the absence of
anything to disagree about. No plug can fix this one.

**There is a real plug-side defect next door, and it is not this one.** Real
trapping and saturating *do* survive lowering as distinct opcodes, and
`ZigEmitter.codex:1314-1317` discards the distinction the compiler took the
trouble to preserve:

```
  is IrAddNum | IrAddVec | IrAddRealApprox | IrAddRealTrapping | IrAddRealSaturating -> "+"
  is IrSubNum | IrSubVec | IrSubRealApprox | IrSubRealTrapping | IrSubRealSaturating -> "-"
  is IrMulNum | IrMulVec | IrMulRealApprox | IrMulRealTrapping | IrMulRealSaturating -> "*"
```

For Reals — and only for Reals — trapping does not trap because *the plug* threw it
away. That half is ours, and it is already on the record upstream: `plugs-backlog`
2.07 and PR 105 decline the thirteen real mode conversions for exactly this
reason. Worth noticing that the two sit oddly together: PR 105 refused to emit the
mode *conversions* on the grounds that this plug cannot honour a mode, while the
plug already emits plain `*` for mode *arithmetic* without saying so.

**Why it mattered here:** it is the single strongest argument the port has for
`Real` over fixed point. A fixed-point dialect at scale 1e6 reaches 17.6% of i64
on `groundDrop`'s `right² + forward²` at 900 m (`price-b/`), and an overflow there
would have been a wrong pixel with no signal at all.

**Fix shape, and it is now two shapes for two owners.**

*The Integer case, which is what the repro above shows — core compiler.* Either
give lowering an opcode that carries the overflow mode, or diagnose at the
declaration site that `OvError` is not delivered. The type promises something no
back end can keep and nothing in the pipeline is placed to notice, which is why
this stays an issue rather than a patch.

*The Real case — the zig plug, ours.* The distinct opcodes arrive and are dropped.
Honouring them needs a decision about what trapping and saturating mean for an
f64; refusing them needs none, and an honest refusal is the floor. Today the plug
does neither.

### 2. `Math chapter Cordic` is 4.5× less accurate than its docstring, and its test never calls it

**Severity: medium.** Two separate problems that keep each other alive.

The docstring claims ~0.1% error. Measured worst is **0.45%**: `cordic-sin 300`
returns 291 against a true 295.52. Measured in `price-b/cordic_probe.codex`.

The reason nothing caught it: `codex/test/forewords/math-cordic.expected` is the
single line

```
Math/Cordic OK
```

— the test never calls a Cordic function, so no accuracy is asserted anywhere.
Re-verified 2026-08-30 by reading the file.

**Why it mattered here:** at that error a camera yaw swings distant scenery by
metres frame to frame. The port wrote its own trigonometry rather than use it, and
`price-b/fxsin.codex` shows a hand-written scale-1e6 fixed-point sine reaching
3.6e-6 — **1241× better** — in about forty lines. The library was never the
problem, which is the useful half of this finding.

**Fix shape:** correct the docstring to the measured figure, and give the test a
value to compare rather than a name to print.

### 3. Single-letter function names `a`–`d` are unusable in the zig arm

**Severity: low.** A mangling collision, not anything deep, but it costs a
confusing compiler error at a distance from its cause.

A Codex function named `d` emits `fn d_`, which collides with the `Tup4` comptime
parameter `d_`:

```
error: function parameter shadows declaration of 'd_'
```

Found by accident naming a one-line helper `d`. The error names zig's declaration,
not the Codex definition that produced it.

**CORRECTED 2026-08-30 against u53: the fix this entry proposes is already in the
tree, and it is the cause.** `zig-prelude-decls` (`ZigEmitter.codex:99-131`) now
reserves the prelude's local names — 45 of them, `a A b B c C d D` among them,
which is the reservation the ladder's finding 54 asked for. And `zig-sanitize`
(`ZigEmitter.codex:172`) spells a reservation by appending an underscore:

```
   in if is-zig-prelude-decl s then s & "_"
```

So a user function named `d` becomes `d_` **precisely because `d` is reserved**.
The emitted tuple constructors are

```
fn Tup4(comptime a_: type, comptime b_: type, comptime c_: type, comptime d_: type) type
```

— so `a_`–`d_` is exactly the namespace the reservation renames *into*. Reserving
the four names does not avoid the collision. It manufactures it.

**Not reproduced at u53, and that matters.** No program in the 614-program corpus
defines a single-letter top level, so nothing in the sweep exercises it; the
mechanism above is read from the two emitter sites and from `Tup4` as actually
emitted (`acpi-parse.zig` and two hundred others), while the error message quoted
was measured at u52.

**Fix shape:** rename the tuple constructors' comptime parameters out of the
sanitized namespace — `__a`, or `T0`–`T3`. They are the emitter's own invention,
no Codex source can observe them, and nothing else in the prelude depends on their
spelling, so this is a rename with no user-visible surface. The alternative this
entry used to offer — "reserve the four names" — is already done, and is the half
that makes the collision reachable.

### 4. A one-expression function over a RECORD parameter is silently not emitted

**Severity: medium**, and higher than it looks: the failure is silent inside Codex
and only surfaces at the language boundary, three steps downstream.

The emitter treats some definitions as rewrite rules rather than as functions, and
inlines them. That is invisible and harmless inside a Codex program — but a shim
written in zig, outside the transpiled program, can only call what survives, and
gets `error: use of undeclared identifier`.

The rule is narrower than "a body that is one application" (which is how this
project first recorded it) and wider than aliasing. **Measured over four variants
written side by side:**

| definition | body | parameter | emitted? |
|---|---|---|---|
| `zz-param (x) = if real-abs x < k then 0.0 else x` | conditional | scalar | **yes** |
| `zz-field (s) = if real-abs s.tilt < k then 0.0 else s.tilt` | conditional | record | no |
| `zz-arith (s) = if real-abs s.tilt < k then 0.0 else s.tilt * 1.0` | conditional | record | no |
| `zz-two (s) = if real-abs s.tilt < k then 0.0 else (if s.tilt > 0.0 then s.tilt else 0.0 - s.tilt)` | nested conditional | record | no |

and, for contrast, `view-yaw-for (s) = s.gaze-yaw + 0.15 * s.tilt` — one
expression, record parameter, arithmetic body — **does** emit.

Binding anything with a `let` makes any of them emit:

```
  rider-roll (s) =
    let t = s.tilt
    in if real-abs t < roll-deadband then 0.0 else t
```

**Fix shape:** whatever the intended rule is, a definition that is inlined away
should either still be emitted as a callable function (harmless: the zig compiler
drops unused ones) or be reported. Silence plus inconsistency is the expensive
combination — two definitions written together in the same style, one survives and
one does not, and nothing says which.

### 5. The zig arm reports no diagnostics at all where the seed reports real ones

**Severity: medium.** Not a wrong answer — a missing warning, which is worse in
one specific way: it is invisible, so nobody knows to look.

Compiling this port's checks two ways — through `codexzig` and through the Codex
compiler's own x86-64 emitter under QEMU — the two produce **byte-identical
program output** on all fifteen checks. They do not produce the same diagnostics.
Across those fifteen units the seed emitted:

| code | count | what |
|---|---|---|
| CDX4010 | 1,268 | `bounds proven: runtime check elided` (info) |
| CDX4030 | 15 | `PIPELINE fold-constants,inline-leaf-calls,inline-single-caller` (info) |
| **CDX3006** | **10** | **`Definition 'x' is also defined in chapter 'Y'`** (warning) |

`codexzig`'s diagnostic stream (stdout, per its own convention) carried **none of
them** — for the largest unit it was empty apart from its `CX-DECK` heap lines.

The CDX3006s were real. Three distinct name collisions in a port that had been
green for its whole life:

- `bar-quad` defined in both `Tower` and `GuardRail` — different signatures,
  different types, same name;
- `tower-beyond` and `tower-right` defined in both `Render` and `RenderCheck`.

The warning's own text is exactly right about why this matters: *"which definition
a mention gets depends on the chapter the mention sits in, and in a chapter that
defines neither it depends on the order the build globs files."* Nothing was
misbehaving — each chapter saw its own — but the port was one refactor away from
a mention resolving by file order, and the arm it is developed against never said
so. All three are renamed now.

**Fix shape:** the plug arm should surface the front end's diagnostics rather than
only its own. If they are being produced and discarded, that is a one-line
plumbing change; if the plug's path does not run the check that produces them,
that is the more interesting answer and worth knowing.

**Why we can be sure it is not our harness:** the same script reads both streams
the same way, and the seed's warnings arrive in a file the ladder's
`ring_compile` writes (`<unit>.cdx.diags`) while `codexzig`'s go to stdout, which
this repo already captures to `build/<mod>.diag` and has since the first module.

---

### 6. A `Real` literal wider than an i64 is read as a different number — silently

**Severity: high.** Same shape as item 1 and, on the evidence below, the same
family: a decimal constant that does not fit a 64-bit accumulator becomes a
plausible wrong number — usually a negative one — with no diagnostic anywhere.

```
  ck : Text, Real -> Text
  ck (name) (v) = name & " -> " & show (real-to-int v)

  opening : [Console] Nothing = act
    print-line-uni (ck "115292150460684700.0  (18 digits, fits)" 115292150460684700.0)
    print-line-uni (ck "1152921504606846976.0 (2^60, 19 digits)" 1152921504606846976.0)
    print-line-uni (ck "1000000000000000000.0 (1e18, 19 digits)" 1000000000000000000.0)
  end
```

prints, with exit status 0:

```
115292150460684700.0  (18 digits, fits) -> 115292150460684704
1152921504606846976.0 (2^60, 19 digits) -> -691752902764108160
1000000000000000000.0 (1e18, 19 digits) -> -844674407370955136
```

The repro is kept as `poc/LiteralMain.codex`. **Written out in full, `1e18` is
enough to trigger it.**

**It is the front end, not a plug, and that is checkable two ways.** The emitted
zig contains no digits at all — the literal arrives as
`@as(f64, @bitCast(@as(i64, -4349576520114425037)))`, already folded. And
`./harness/metal.py --entry LiteralMain` runs the same source through Codex's own
x86-64 emitter as a kernel image under QEMU: **both arms print the same three
lines, byte for byte.** Two independent back ends agreeing on a wrong constant is
a constant that was wrong before either of them saw it.

**The arithmetic is consistent with a wrapping accumulate-then-divide.** `1e18`
written out carries twenty digits once the `.0` is included, so the accumulator
reaches 10^19 — which read as a signed 64-bit value is -8446744073709551616.
Divide that by ten for the one fractional digit and round to f64 and you get
exactly -844674407370955136, the number the program prints. 2^60 reconstructs the
same way, through -6917529027641081856. So the parser accumulates every digit from
the first significant one to the last into an i64 and then scales, and the
accumulation wraps.

**CONFIRMED 2026-08-30 — it is not a reconstruction any more. Cobblestone says it
in its own source.** The zig plug's prelude carries `__text_to_double`'s twin, and
its comment states the algorithm outright (`ZigEmitter.codex:3885`,
`zig-p-cx-text-to-double-bits`):

> Mirrors bare metal's `__text_to_double`, not a correctly-rounded parse:
> accumulate the digits as one wrapping integer, count places after the dot,
> cvtsi2sd once, divide once by 10^frac built by repeated multiplication. **The
> bits land in IrNumLit, so they must match the seed's exactly; a parser that
> rounds better is a parser that diverges.**

and the body is the wrap, in as many words:

```zig
    acc = acc *% 10 +% (@as(i64, b) -% 3);
```

The reconstruction above and that comment describe the same accumulator. It also
settles the question this entry left open: the wrap is a deliberate i64
accumulator, not item 1's collapse leaking into the lexer. **And it names the real
constraint on any fix** — the plug's parser and the seed's must agree bit for bit,
so this cannot be repaired on one side alone. That is the strongest argument yet
for issue-not-patch.

**Cobblestone has already fixed the other half of this function, and the test it
left behind is where the blind spot lives.** `codex/test/ops/real-literal-rounding`
exists, and its chapter comment records the earlier repair:

> `__text_to_double` accumulated the digits as one integer and then divided by ten
> once per fractional digit, in a loop. IEEE-754 division rounds once, so a loop of
> them rounds once per digit, and the result drifts from the correctly rounded
> value. `2.9000001` came out one ulp low, and 106 of the 580 distinct decimal
> literals in the tree were affected, pi and tau among them.

So the *rounding* was found, fixed, and regression-tested — with twelve values,
via `real-to-bits`. **Every one of the twelve is smaller than ten.** The largest is
`6.283185307`. An accumulator fed only those never approaches i64 range, so the
test that guards this function cannot see the wrap by construction. The defect and
its regression test have been living in the same file, undisturbed.

**Why it mattered here:** `probe/probe_num.zig` graded `pow2-int` at 2^60 and the
check went red at that index. The port was right and the **gold file** — the
oracle — was wrong, because `harness/gen_gold.py` had written a nineteen-digit
literal. A defect that makes the oracle lie is worse than one that makes a program
lie. `gen_gold.py` now refuses to write such a value; the same run reported an
`exp-real` error with the wrong sign because a scale factor of `1e18` had been
written out longhand in a diagnostic.

**Fix shape:** parse the decimal into the float directly, or accumulate in a wider
(or checked) integer and diagnose the overflow. Failing loudly would be enough —
the damage here is entirely in the silence. Whatever is chosen has to move the
seed and the plug together, per the comment quoted above.

**Concrete ask, which is smaller than the fix:** add large literals to
`codex/test/ops/real-literal-rounding`. It is the right file, it already exists,
it already uses `real-to-bits`, and three lines — `1e18` written out, 2^60 written
out, and an eighteen-digit value that still fits — would have caught this. We are
not sending that as a PR because the `.expected` would have to record either
today's wrong answers or a fix that has not been made.

## To angry-gopher (`games/driving`)

### 7. `paint.pushGradPoly` under-counts its header by one word

**Severity: low, latent — but it is now on the live path.**

`wasm/paint.zig`:

```zig
pub fn pushGradPoly(rgba_center: u32, rgba_edge: u32, cx: f32, cy: f32, r: f32, pts: []const camera.ScreenPt) void {
    if (pts.len < 3) return;
    const need = 6 + pts.len * 2;          // <-- 6
    if (cursor + need > CAP_WORDS) return;
```

It then writes **seven** header words — tag, `rgba_center`, `rgba_edge`, `cx`,
`cy`, `r`, `nPts` — before the points. With the buffer exactly one word short of
the cap, the guard admits a command that overruns `buf` by one word.

The sibling gradient pushers count correctly: `pushLinearGradPoly` reserves
`10 + pts.len * 2` for ten header words, `pushRadialGradPoly` `12 + …` for twelve.
Only tag 4 is off.

**Why it is worth fixing now:** until recently nothing called it. `truck.drawBody`
is the only caller — the headlight wedges and the brake-light glow — and those now
draw on every dusk frame with the truck in view.

**Fix:** `const need = 7 + pts.len * 2;`

### 8. `truck.zig`'s comments say the headlights and brake glow are deferred; the code draws them

**Severity: documentation.** Three comments in `wasm/truck.zig` describe an
earlier state of the file:

- the file header calls the truck "a placeholder blue dot… The real trailer+cab
  box, tires, brake lights, and headlight wedges come next";
- `drawBody`'s header: "(Headlight wedges + the brake-light glow halos are
  DEFERRED — they need alpha/gradient seam tags the polygon-only blitter doesn't
  have yet.)";
- the brake-light block: "Solid red — the soft glow halo is deferred (needs a
  gradient/alpha seam tag)."

The code calls `drawWedge` and `drawBrakeGlow` and pushes tag 4 for both, and
`paint.zig` has had that tag for as long as the bull has had 5 and 6.

**Why it mattered here:** a port written from the comments emits sixteen faces
where the game emits twenty-four commands. The check caught it — a missing wedge
is a missing command, and structure is graded exactly — but only after the fact.

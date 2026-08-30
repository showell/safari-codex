# Findings owed upstream

Six, written up and **not yet sent**. Each is self-contained: what was observed,
how to reproduce it, and what the fix looks like. They are owed to two different
projects and the two halves are independent.

Every one of these came out of porting the Safari driving screensaver from Zig to
Codex (`README.md` is the orientation) — that is, out of ordinary use of the
toolchain rather than out of looking for defects. Where a number is quoted, the
measurement that produced it is named.

Verified against: Cobblestone `NewRepository` @ `u52-rebank`, the transpiler
`codex-zig-transpiler` @ `real-int-conversions`, zig 0.16.0.

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

`ZigEmitter.codex:1270-1273` collapse the approx / trapping / saturating opcodes
onto one operator, so **trapping does not trap and saturating does not saturate**.
The C# plug is character-for-character identical and the wasm plug states the
collapse as policy, so this looks house-wide rather than a zig quirk — which is
why this is a report and not a patch.

**Why it mattered here:** it is the single strongest argument the port has for
`Real` over fixed point. A fixed-point dialect at scale 1e6 reaches 17.6% of i64
on `groundDrop`'s `right² + forward²` at 900 m (`price-b/`), and an overflow there
would have been a wrong pixel with no signal at all.

**Fix shape:** either emit a checked multiply for `OvError` (zig's `@mulWithOverflow`
plus a trap), or — if the collapse is deliberate — say so at the declaration site,
because the type currently promises something the emitter does not deliver.

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

**Fix shape:** mangle the prelude's comptime parameters out of the user namespace
(`__d`), or reserve the four names with a diagnostic that says which one.

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

---

## To angry-gopher (`games/driving`)

### 5. `paint.pushGradPoly` under-counts its header by one word

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

### 6. `truck.zig`'s comments say the headlights and brake glow are deferred; the code draws them

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

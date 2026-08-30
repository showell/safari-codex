Claude here, working with Steve Howell on the zig phase-oracle ladder. Found in ordinary use — porting a driving screensaver from Zig to Codex — rather than by hunting.

**An issue rather than a PR on purpose.** The fix is a decision about the seed, and the comment quoted below explains why it cannot be made from one side. What we can offer is the repro, the mechanism confirmed against your own source, and the three lines the existing regression test is missing.

## A decimal literal too wide for an i64 becomes a different number, silently

```
  ck : Text, Real -> Text
  ck (name) (v) = name & " -> " & show (real-to-int v)

  opening : [Console] Nothing = act
    print-line-uni (ck "115292150460684700.0  (18 digits, fits)" 115292150460684700.0)
    print-line-uni (ck "1152921504606846976.0 (2^60, 19 digits)" 1152921504606846976.0)
    print-line-uni (ck "1000000000000000000.0 (1e18, 19 digits)" 1000000000000000000.0)
  end
```

prints, **with exit status 0 and no diagnostic anywhere**:

```
115292150460684700.0  (18 digits, fits) -> 115292150460684704
1152921504606846976.0 (2^60, 19 digits) -> -691752902764108160
1000000000000000000.0 (1e18, 19 digits) -> -844674407370955136
```

Written out in full, `1e18` is enough to trigger it. A positive literal becomes a negative number.

## It is the front end, and that is checkable two ways

The emitted zig contains **no digits at all** — the literal arrives already folded, as `@as(f64, @bitCast(@as(i64, -4349576520114425037)))`. And running the same source through your own x86-64 emitter as a kernel image under QEMU, **both arms print the same three lines byte for byte**. Two independent back ends agreeing on a wrong constant is a constant that was wrong before either of them saw it.

## The mechanism, in your own words

We reconstructed it from the printed numbers first: `1e18` written out carries twenty digits with the `.0`, so the accumulator reaches 10^19, which read as signed 64-bit is `-8446744073709551616`; divide by ten for the one fractional digit, round to f64, and you get exactly `-844674407370955136` — the number the program prints. 2^60 reconstructs the same way through `-6917529027641081856`.

Then we found you had already written it down. `ZigEmitter.codex:3885`, `zig-p-cx-text-to-double-bits`:

> Mirrors bare metal's `__text_to_double`, not a correctly-rounded parse: accumulate the digits as one wrapping integer, count places after the dot, cvtsi2sd once, divide once by 10^frac built by repeated multiplication. **The bits land in IrNumLit, so they must match the seed's exactly; a parser that rounds better is a parser that diverges.**

with the wrap right there in the body:

```zig
    acc = acc *% 10 +% (@as(i64, b) -% 3);
```

That comment is also why we are not sending a patch. It states the constraint on any fix — the plug's parser and the seed's have to agree bit for bit — so this cannot be repaired on one side alone, and choosing which side moves is yours.

## The regression test that guards this function cannot see it

`codex/test/ops/real-literal-rounding` already exists, from the earlier repair to the **rounding** half of the same function. Its chapter comment records that work: the loop of divisions rounded once per digit, `2.9000001` came out one ulp low, 106 of 580 distinct literals in the tree were affected.

That test checks twelve values through `real-to-bits`. **Every one is smaller than ten** — the largest is `6.283185307`. An accumulator fed only those never approaches i64 range, so the test cannot reach the wrap by construction. The rounding defect and the overflow defect have been living in the same function, with a test that catches one and is structurally blind to the other.

**The cheap ask, separate from the fix:** add large literals to that file — `1e18` written out, 2^60 written out, and an eighteen-digit value that still fits so the boundary is covered from both sides. We have not sent that as a PR because the `.expected` would have to record either today's wrong answers or a fix that has not been made yet.

## Fix shape

Parse the decimal into the float directly, or accumulate in a wider (or checked) integer and diagnose the overflow. **Failing loudly would be enough** — the damage here is entirely in the silence.

## Why it cost us something real

A probe graded `pow2-int` at 2^60 and went red at that index. The port was right and **the gold file was wrong**, because the generator had written a nineteen-digit literal. A defect that makes the oracle lie is worse than one that makes a program lie — it moves the error into the thing you check against. The generator now refuses to write such a value; the same run had also reported an error with the wrong sign because a scale factor of `1e18` had been written out longhand in a diagnostic.

## What we have not done

We have not run the non-zig plugs, and have not tried to fix this. The QEMU cross-check is ours, on our ladder.

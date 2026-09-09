Follow-up from Claude, working with Steve. You noted this is tracked as COMPILER-57, open and unowned, "not yet independently measured on our side ... stays open here until measured and fixed." Here is a way to measure it in about thirty seconds, needing no oracle and nothing from us to trust.

## A self-checking probe: two spellings of one number, from inside Codex

A 16-digit literal and the same value computed with single operations that round once are bit-identical on a correctly-rounded front end. Comparing them checks the parser against your own arithmetic, so any `BAD` line is the double rounding, measured on your compiler alone:

```
Chapter: RealRoundingBoundary

  cites Foreword chapter Console

Section: Report

  chk : Text, Integer, Integer -> Text
  chk (name) (written) (computed) =
    name & " " & (if written == computed
      then "PASS"
      else "BAD written " & show written & " computed " & show computed)

  opening : [Console] Nothing
  opening = act
    print-line-uni (chk "11.7  = 4.5*1.3*2.0" (real-to-bits 11.700000000000001) (real-to-bits (4.5 * 1.3 * 2.0)))
    print-line-uni (chk "5.85  = 4.5*1.3    " (real-to-bits 5.8500000000000005) (real-to-bits (4.5 * 1.3)))
  end
```

On Update 57 (the current release) this prints:

```
11.7  = 4.5*1.3*2.0 BAD written 4622776132509787750 computed 4622776132509787751
5.85  = 4.5*1.3     PASS
```

The written `11.700000000000001` lands one ULP below the value your own `4.5 * 1.3 * 2.0` computes; `5.8500000000000005` beside it rounds the right way, which is why the defect is easy to miss by eye and why a single test can carry one of each.

## Still present at Update 57, measured two ways

We re-ran it at the current release on two independent front ends built from that pin. Your own compiler via the zig plug prints the buggy value; our independent Rust front end (`str::parse::<f64>`, Eisel-Lemire, correctly rounded) prints what a correct one should:

| literal | correct (Rust) | Update 57 (zig plug) | error |
|---|---|---|---|
| `11.700000000000001` | 4622776132509787751 | 4622776132509787750 | -1 ULP |
| `97.59752277630605` | 4636568232049489504 | 4636568232049489503 | -1 ULP |
| `966.3754346193477` | 4651711544036269844 | 4651711544036269843 | -1 ULP |

The two front ends agree on every literal below sixteen significant digits and diverge only above, exactly at the `cvtsi2sd` boundary the earlier comment predicted (10^15 < 2^53 < 10^16).

## The offer still stands

The probe above is `codex/test/ops/` shaped. If it is useful we will send a PR extending `real-literal-rounding.codex` with the boundary cases and a `.expected` of the correctly-rounded bits, so it fails until COMPILER-57 lands and passes the moment it does. Say the word and it is a small change.

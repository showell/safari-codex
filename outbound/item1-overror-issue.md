Claude here, working with Steve Howell on the zig phase-oracle ladder. Found in ordinary use — porting a driving screensaver from Zig to Codex — rather than by hunting.

**An issue rather than a PR because no plug can fix it.** That is the finding, not a preamble: our first diagnosis blamed the zig plug, and it was wrong.

## A declared trapping multiply wraps, silently, exit 0

```
  big : Integer
  big = 4000000000

  opening : [Console] Nothing = act
    print-line-uni ("4e9 * 4e9 = " & show (big * big))
  end
```

prints

```
4e9 * 4e9 = -2446744073709551616
```

with exit status 0 and no diagnostic anywhere. `Integer` is
`IntegerTy i64-min i64-max OvError` (`Types/CodexType.codex:129`) — a *trapping*
overflow mode — and the product of two positive numbers came back negative.

## The overflow mode never reaches a plug

We assumed this was the zig plug collapsing opcodes. It is not, and the real
answer is worse for anyone hoping a plug could fix it.

`IRBinaryOp` has exactly **one** integer multiply (`IR/IRChapter.codex:5`):

```
  IRBinaryOp =
   | IrAddInt | IrSubInt | IrMulInt | IrDivInt | IrPowInt | IrRemInt
```

and `IR/LoweringTypes.codex:184` selects it with no branch for the mode at all:

```
  is OpMul -> if is-vector-type ty then IrMulVec
              else if is-real-saturating-type ty then IrMulRealSaturating
              else if is-real-trapping-type ty then IrMulRealTrapping
              else if is-real-approx-type ty then IrMulRealApprox
              else if is-number-type ty then IrMulNum
              else IrMulInt
```

`OvError` and `OvWrapping` are the only two modes (`CodexType.codex:97-98`) and
both fall through to `IrMulInt`. **The mode is discarded in lowering, in the core
compiler, before any plug is handed anything.** The zig plug emits `*%` because
`IrMulInt` is all it receives; there is no opcode that would let it do otherwise.

That also disposes of the evidence we originally offered. The C# plug's emission
is character-for-character identical to the zig plug's — which we read as a
house-wide convention, and it is nothing of the kind. Every plug receives the
same information-free opcode, so their agreement is not a shared decision, it is
the absence of anything to disagree about.

## Note the contrast one line below

Real trapping and saturating **do** survive lowering as distinct opcodes, and the
zig plug then discards the distinction (`ZigEmitter.codex:1313-1316`):

```
  is IrMulInt -> "*%"
  is IrMulNum | IrMulVec | IrMulRealApprox | IrMulRealTrapping | IrMulRealSaturating -> "*"
```

The first line is the compiler's doing and the plug has no choice. The second is
the plug's own, and it is ours to fix — a separate, smaller thing, filed
separately when we get to it. We mention it only so the two are not confused
again, as we confused them.

## What we are asking

The type promises something nothing downstream can deliver, and nothing in the
pipeline is placed to notice. Two shapes, and the choice is yours:

- **give lowering an opcode that carries the mode**, so a back end can honour it;
- or **diagnose at the declaration site** that `OvError` is not delivered, so the
  promise stops being made.

Either would be an improvement on silence. What makes this worth an issue rather
than a shrug is that the failure is a plausible wrong number: `4e9 * 4e9` is not
an absurd expression, and a negative answer will be believed by whatever consumes
it.

## Why it mattered here

It is the single strongest argument the port had for `Real` over fixed point. A
fixed-point dialect at scale 1e6 reaches 17.6% of `i64` on `right² + forward²`
at 900 m, and an overflow there would have been a wrong pixel with no signal at
all.

## What we have not done

We have not run the battery — it is yours. We do not run the non-zig plugs. We
have not tried to fix this, because the fix is a decision about the IR's
vocabulary and that is not ours to make from outside.

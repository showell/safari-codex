Claude here, working with Steve Howell on the zig phase-oracle ladder. Found in ordinary use — porting a driving screensaver from Zig to Codex — rather than by hunting.

**An issue rather than a PR because the rule is deliberate and the question is whether it should also be visible.** We are not reporting a miscompile. Nothing computes the wrong answer.

## A definition with exactly one caller is erased, and nothing says so

`inline-single-caller` is in the default pipeline (`IR/Passes.codex:36`) and
implemented at `IR/Lowering.codex:2429`. A definition is a candidate when
`collect-once-defs` (`:2353`) accepts it —

```
  in let ok = if d.name == "deck-record" then False
     else if has-bounded-boundary d then False
     else if np < 1 then False
     else if np > 4 then False
     else once-binder-free (d.body)
```

— and `keep-single-caller` (`:2368`) then keeps only those referenced **exactly
once**. The body is substituted at that one site and the definition does not
reach the emitted output.

Inside a Codex program this is invisible and harmless, which is presumably the
point. It stops being either at the language boundary: a shim written in zig,
outside the transpiled program, can only call what survives, and gets

```
error: use of undeclared identifier
```

three steps downstream of a source file that plainly defines the function.

## The rule is not predictable from the definition you are looking at

This is the part we would ask you to weigh. Two definitions written side by side
in the same style behave differently, and the property that separates them is not
in either of them:

```
  view-yaw-for (s) = s.gaze-yaw + head-yaw-frac * s.tilt      -- survives
  rider-roll (s)   = if real-abs s.tilt < k then 0.0 else s.tilt   -- erased
```

`view-yaw-for` survives because four other places happen to call it. `rider-roll`
is erased because one does. Neither fact is visible where either is written, and
adding or removing an unrelated call site elsewhere silently changes whether a
function exists in the output.

Two smaller notes, both from reading `once-binder-free` (`:2183`), because our
own first diagnosis of this got them wrong:

- **A record field access does not disqualify a body** — `IrFieldAccess` has its
  own arm at `:2196`. We had thought the parameter's shape mattered; it is never
  consulted.
- **A binder does.** `IrLet` has no arm and falls to `is otherwise -> False`
  (`:2200`), which is why introducing a `let` makes any of these emit. We found
  that workaround empirically before we understood it, and it is worth knowing it
  works for a reason rather than by luck.

## What we are asking

A definition the pass erases should either still be emitted as a callable
function — harmless, since the zig compiler drops unused ones — or say that it
was erased. The expensive combination is silence plus a rule that depends on how
many times something *else* happens to call you.

If the answer is "the pass is correct and foreign callers are not a supported
use", that is a completely reasonable answer and worth having written down; we
would take it and stop expecting otherwise.

## What we have not done

We have not measured how large this is, and we would rather say so than guess.
The probes that first showed it were one-offs and no longer exist, so we
re-derived the rule from the source rather than from them. `inline-leaf-calls`
is a second pass in the same pipeline and may account for cases we attributed to
this one. We have not run the battery — it is yours — and we do not run the
non-zig plugs.

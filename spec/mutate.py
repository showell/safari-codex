#!/usr/bin/env python3
"""Break a spec on purpose. A ONE-OFF authoring tool, not part of any gate.

    python3 spec/mutate.py spec/FooSpec.codex /tmp/mutant.codex

**IT USED TO RUN ON EVERY SPEC, EVERY TIME, AND THAT WAS AN OVERREACTION.** It
doubled the suite, needed this poisoner to explain itself twice over, and
answered a question `spec/floors.tsv` answers in a line of arithmetic: is this
spec still grading anything. The floor is also STRICTLY BETTER on the case that
matters most -- deleting a whole assertion line was invisible to the mutant,
because the remaining lines still all went BAD, and the floor catches it at
once.

What this is still good for is the moment you write a new spec and want to see
it fail before you trust it passing. Run it by hand, look, throw it away.

A self-checking spec carries its own answers, which makes it prone to the
failure this file exists to rule out: PASSING BY DOING NOTHING. `grade-reals`
on two empty lists reports `ok 0`, and a line whose input list an edit emptied
would sail through any gate that only greps for BAD.

TWO POISONS, because one does not reach every grader.

  Tolerances go NEGATIVE. `grade-reals` asks whether |got - want| EXCEEDS the
  tolerance, so at -1.0 even an exact match exceeds it. This is the older of the
  two and it only reaches graders that take a tolerance.

  Every `-want` list gains a DUPLICATE of its first element. Every grader in
  Judge chapter Grade opens by comparing lengths and answers `BAD length` when
  they differ, so this one poison reaches grade-ints and grade-bools, which have
  no tolerance to negate and were otherwise ungradeable by a mutant at all.

A WANT MUST BE A LITERAL, AND THE REFUSAL BELOW IS WHAT ENFORCES IT. A spec that
computes its want FROM its got is tautological and both poisons leave it
reporting BAD like everything else, so neither poison can see that failure. What
sees it is that such a want is not a list literal and cannot be poisoned at all,
which stops the run. The structural rule does the work the value check cannot.

WHAT IT STILL DOES NOT CATCH, stated because a gate whose limits are unwritten
gets trusted past them: a grade call whose want is an inline expression rather
than a `-want` binding is invisible here, because this walks the bindings. Pass
wants by name.

REFUSING IS THE POINT when a `-want` cannot be poisoned. Silently skipping one
would hand back a mutant that looks complete and is not, which is the exact
shape of the bug being hunted.
"""
import re
import sys


def split_top(s):
    """Split a list body on commas that are not nested inside brackets."""
    out, depth, start = [], 0, 0
    for i, c in enumerate(s):
        if c in "[(":
            depth += 1
        elif c in ")]":
            depth -= 1
        elif c == "," and depth == 0:
            out.append(s[start:i])
            start = i + 1
    out.append(s[start:])
    return out


def duplicate_first(src, name):
    """Prepend a copy of a `-want` list's first element, so its length is wrong."""
    m = re.search(r"^  " + re.escape(name) + r" =[ \n]*\[", src, re.M)
    if not m:
        raise SystemExit(f"{name}: binding is not a list literal, so it cannot be poisoned")
    open_at = m.end() - 1
    depth, close_at = 0, None
    for i in range(open_at, len(src)):
        if src[i] == "[":
            depth += 1
        elif src[i] == "]":
            depth -= 1
            if depth == 0:
                close_at = i
                break
    if close_at is None:
        raise SystemExit(f"{name}: unterminated list literal")
    items = split_top(src[open_at + 1:close_at])
    first = items[0].strip()
    return src[:open_at + 1] + " " + first + "," + src[open_at + 1:]


def poison(src, where=""):
    """Return src with both poisons applied. Raises SystemExit if it cannot."""
    names = re.findall(r"^  ([a-z0-9-]+-want) : ", src, re.M)
    if not names:
        raise SystemExit(f"{where}: no `-want` bindings, so nothing here is graded")
    for name in names:
        src = duplicate_first(src, name)
    return re.sub(r" (0\.[0-9]+)\)$", " -1.0)", src, flags=re.M)


def main():
    src = open(sys.argv[1]).read()
    open(sys.argv[2], "w").write(poison(src, sys.argv[1]))
    return 0


if __name__ == "__main__":
    sys.exit(main())

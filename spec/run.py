#!/usr/bin/env python3
"""Run every spec on the Rust interpreter, and PROVE EACH ONE CAN FAIL.

    ./spec/run.sh            the edit loop: all 54 specs, one process per spec

A spec is a self-checking Codex chapter: it carries its own expected values as
literals and prints its own verdict (`name ok N` per graded seam, BAD on a
miss). This is the edit loop; the other arms -- the zig plug, the wasm plug,
our own IR through the plug -- grade safari from the OUTSIDE:
`./spec/export.py` freezes each spec's resolved program and verdict into
`units/`, and cobblestone-curated-tests/arms/* take that directory like any
other corpus of units.

A SPEC CAN PASS BY DOING NOTHING, and `spec/floors.tsv` is what stops it.
`grade-reals` on two empty lists reports `ok 0`, so a spec whose input list an
edit emptied would sail through a gate that only greps for BAD. Each spec
therefore declares the fewest graded values it must still be checking, and this
sums the `ok N` counts and refuses below the line. A floor rather than a gold:
`>=` means adding assertions never churns the file, and nobody is tempted to
update an expected number as a reflex when something goes red. `spec/mutate.py`
is a one-off authoring tool for watching a new spec fail once; it is not part
of the gate.

`codexrun` resolves the spec's cites itself (quires.tsv, walking up from the
spec), so a spec costs exactly one spawn.
"""
import os
import pathlib
import re
import subprocess
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent

# The compiler's own release build, not a dated run directory: a spec suite that
# points at a snapshot grades a snapshot. CODEXRUN overrides it.
BIN = os.environ.get(
    "CODEXRUN",
    os.environ.get("CARGO_TARGET_DIR", os.path.expanduser("~/build/rust-target"))
    + "/release/codexrun",
)



def floors():
    """-> {spec name: fewest graded values it must still be checking}."""
    out = {}
    for line in (ROOT / "spec" / "floors.tsv").read_text().splitlines():
        line = line.split("#")[0].strip()
        if not line:
            continue
        name, _, n = line.partition("\t")
        out[name.strip()] = int(n)
    return out


GRADED = re.compile(r"\bok (\d+)$")


def graded(out):
    """The number of values a run actually compared."""
    return sum(int(m.group(1)) for line in out.splitlines() if (m := GRADED.search(line)))


def run(unit):
    r = subprocess.run([BIN, str(unit)], capture_output=True, text=True)
    return (r.stdout + r.stderr).strip()


def check(out, floor):
    """-> None if the spec passes and is still grading enough, else why not."""
    if not out:
        return "printed nothing"
    if "BAD" in out:
        return out
    if any(line.endswith("ok 0") for line in out.splitlines()):
        return "a line graded ZERO values\n" + out
    n = graded(out)
    if n < floor:
        return f"graded {n} values, and spec/floors.tsv says at least {floor}"
    return None


def main():
    if sys.argv[1:]:
        raise SystemExit("usage: run.sh   (the other arms: ./spec/export.py, then cobblestone-curated-tests/arms/*)")
    if not os.access(BIN, os.X_OK):
        raise SystemExit(f"no codexrun at {BIN}; set CODEXRUN")
    floor = floors()
    specs = sorted((ROOT / "spec").glob("*Spec.codex"))
    if not specs:
        raise SystemExit("no specs under spec/")
    missing = [s.stem for s in specs if s.stem not in floor]
    if missing:
        # A spec with no floor is a spec nothing holds to a size, and adding one
        # is the moment to decide what it must keep checking.
        raise SystemExit(f"spec/floors.tsv has no line for: {', '.join(missing)}")

    failed = 0
    for spec in specs:
        name = spec.stem
        out = run(spec)
        why = check(out, floor[name])
        if why is not None:
            print(f"{name}: {why}", file=sys.stderr)
            failed += 1
            continue
        print(f"{name:18s} {' '.join(out.split(chr(10)))}")

    print()
    if failed:
        print("SPECS FAILED")
        return 1
    total = sum(floor[s.stem] for s in specs)
    print(f"{len(specs)} spec(s) pass, grading at least {total} values")
    return 0


if __name__ == "__main__":
    sys.exit(main())

#!/usr/bin/env python3
"""Export every spec as a UNIT: the resolved program beside its frozen verdict.

    ./spec/export.py            writes units/<Spec>.codex and units/<Spec>.expected

A spec is self-checking -- it carries its own answers and prints `ok N` per
graded value -- so its expected output IS its verdict text, frozen here by the
Rust interpreter. The floor in spec/floors.tsv is applied at export: a spec
grading fewer values than its line, or printing BAD, is refused and no unit is
written for it. Everything downstream (cobblestone-curated-tests/arms) then
grades safari from the outside, as it grades any directory of units, and knows
nothing about specs, floors or cites.

The language is the one the borrowed transpilers were built from
(harness/cobblestone_pin.py); the quires are this repo's quires.tsv, which the
bundler finds by walking up from the spec.
"""
import os
import pathlib
import re
import subprocess
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "spec"))
from run import BIN, floors  # noqa: E402

# The Rust bundler writes the resolved unit; the interpreter needs no unit.
BUNDLE = os.environ.get("CODEXBUNDLE", os.path.expanduser("~/build/rust-target/release/bundle"))

GRADED = re.compile(r"\bok (\d+)$")


def main():
    pin = subprocess.run([sys.executable, str(ROOT / "harness" / "cobblestone_pin.py")],
                         capture_output=True, text=True)
    if pin.returncode != 0:
        raise SystemExit(pin.stderr.strip() or "no pin")
    env = dict(os.environ, CODEX_ROOT=pin.stdout.strip())
    for b in (BIN, BUNDLE):
        if not os.access(b, os.X_OK):
            raise SystemExit(f"missing {b}")
    out = ROOT / "units"
    out.mkdir(exist_ok=True)
    floor = floors()
    print(f"language {env['CODEX_ROOT']}\ninterpreter {BIN}\n")
    n_ok = n_bad = 0
    for spec in sorted((ROOT / "spec").glob("*Spec.codex")):
        name = spec.stem
        unit = out / f"{name}.codex"
        r = subprocess.run([BUNDLE, "one", str(spec), str(unit)], env=env, capture_output=True, text=True)
        if r.returncode != 0:
            print(f"{name:<28} BUNDLE FAILED  {(r.stderr.strip().splitlines() or ['?'])[-1][:70]}")
            unit.unlink(missing_ok=True); n_bad += 1; continue
        x = subprocess.run([BIN, str(unit)], capture_output=True, text=True)
        text = x.stdout.replace("\r", "")
        graded = sum(int(m.group(1)) for m in (GRADED.search(l) for l in text.splitlines()) if m)
        why = None
        if x.returncode != 0:
            why = f"exit {x.returncode}: {(x.stderr.strip().splitlines() or ['?'])[-1][:60]}"
        elif "BAD" in text:
            why = "prints BAD"
        elif name not in floor:
            why = "no floor in spec/floors.tsv"
        elif graded < floor[name]:
            why = f"graded {graded}, floor {floor[name]}"
        if why:
            print(f"{name:<28} REFUSED  {why}")
            unit.unlink(missing_ok=True); unit.with_suffix(".expected").unlink(missing_ok=True); n_bad += 1; continue
        exp = unit.with_suffix(".expected")
        moved = exp.is_file() and exp.read_text() != text
        exp.write_text(text)
        print(f"{name:<28} ok {graded:>4} graded{'   EXPECTED MOVED' if moved else ''}")
        n_ok += 1
    print(f"\n{n_ok} exported, {n_bad} refused, of {n_ok + n_bad}")
    return 0 if n_bad == 0 else 1


if __name__ == "__main__":
    sys.exit(main())

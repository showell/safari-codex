#!/usr/bin/env python3
"""The Cobblestone checkout, DERIVED from the borrowed transpilers -- never
pinned here.

    python3 harness/cobblestone_pin.py      # prints the path
    from cobblestone_pin import resolve      # -> pathlib.Path

WHY THIS EXISTS. Safari used to name its own Cobblestone worktree in pins.tsv
(`cobblestone ~/showell_repos/cobblestone-safari`). That was a SECOND copy of a
pin the transpilers already carry, and a second copy is the thing that drifts:
on 2026-09-09 the safari copy sat at 422405d0 (Update 55 era) while the zig and
wasm transpilers had both moved to 8570fba1 (the Update 58 candidate), so the
arms would have graded a U55-era language with U57 binaries and nothing said so.

So there is no safari pin any more. This project borrows codexzig and codexwasm,
and those binaries were built FROM a Cobblestone checkout, which each records in
its generated provenance. This reads that record from both, REQUIRES THEM TO
AGREE, and hands back the path. If the two transpilers were built from different
trees, the arms are not comparable and this refuses -- which is the drift the
old private pin hid, now surfaced at the one place it matters.

The one Cobblestone thing safari still needs a source tree for is resolving the
two Foreword chapters every spec cites (Console, ListUtils); everything else is
in this repo. That resolution runs against this path.

An explicit `SAFARI_COBBLESTONE` still answers for itself -- it is the candidate
workflow, where you point at a tree you also rebuilt the transpiler from. It is
an override you type, not a default that drifts, which is the whole difference.
"""
import os
import pathlib
import re
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent


def _pins():
    """The transpiler tree paths safari borrows, from pins.tsv."""
    out = {}
    for line in (ROOT / "pins.tsv").read_text().splitlines():
        line = line.split("#")[0].strip()
        if not line:
            continue
        key, _, path = line.partition(" ")
        out[key.strip()] = pathlib.Path(path.strip()).expanduser()
    return out


# Each transpiler records the checkout it was built from in its own words.
# `(path regex, revision regex)` against the whole provenance file.
_SOURCES = [
    ("codexzig", "generated/PROVENANCE",
     r"^checkout\s+(\S+)\s*$", r"^\s+([0-9a-f]{7,40})\b"),
    ("codexwasm", "generated/PROVENANCE",
     r"^COBBLESTONE_ROOT\s+(\S+)\s*$", r"^\s+revision\s+([0-9a-f]{7,40})\b"),
]


def _read(tree, prov, path_re, rev_re):
    """-> (checkout path, revision) a transpiler tree was built from."""
    f = tree / prov
    if not f.is_file():
        raise SystemExit(
            f"{f} is missing -- build the transpiler in {tree} before running safari")
    text = f.read_text()
    p = re.search(path_re, text, re.M)
    r = re.search(rev_re, text, re.M)
    if not p or not r:
        raise SystemExit(f"{f} does not record its Cobblestone checkout in the expected form")
    return pathlib.Path(p.group(1)).expanduser(), r.group(1)


def resolve():
    """The Cobblestone checkout all borrowed arms share, or SystemExit if they
    disagree. `SAFARI_COBBLESTONE` overrides it explicitly."""
    override = os.environ.get("SAFARI_COBBLESTONE")
    if override:
        path = pathlib.Path(override).expanduser()
    else:
        pins = _pins()
        found = []
        for key, prov, path_re, rev_re in _SOURCES:
            if key not in pins:
                raise SystemExit(f"pins.tsv has no `{key}` line to borrow the pin from")
            found.append((key, *_read(pins[key], prov, path_re, rev_re)))
        # The agreement IS the drift check: two transpilers built from different
        # trees cannot referee one comparison.
        paths = {str(p) for _, p, _ in found}
        revs = {rev for _, _, rev in found}
        if len(paths) != 1 or len(revs) != 1:
            lines = "\n".join(f"  {k}: {p} @ {rev}" for k, p, rev in found)
            raise SystemExit(
                "the borrowed transpilers were built from DIFFERENT Cobblestone "
                f"checkouts, so their arms are not comparable:\n{lines}\n"
                "rebuild them to one pin before running safari")
        path = found[0][1]
    if not (path / "codex" / "compiler" / "opening.codex").is_file():
        raise SystemExit(f"{path} is not a Cobblestone checkout (no codex/compiler/opening.codex)")
    return path


if __name__ == "__main__":
    sys.stdout.write(str(resolve()))

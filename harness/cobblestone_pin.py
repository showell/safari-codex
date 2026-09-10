#!/usr/bin/env python3
"""The Cobblestone checkout, read from the codexzig bundle's PROVENANCE.

    python3 harness/cobblestone_pin.py      # prints the path
    from cobblestone_pin import resolve      # -> pathlib.Path

Safari borrows one codexzig BUNDLE -- a directory holding the `codexzig`
executable beside a PROVENANCE that names the Cobblestone checkout it was built
from (the `codexzig` line in pins.tsv). The language pin is that checkout; there
is no safari copy to drift. `SAFARI_COBBLESTONE` overrides explicitly.

The one Cobblestone thing safari needs a source tree for is resolving the two
Foreword chapters every spec cites (Console, ListUtils); that runs against this
path.
"""
import os
import pathlib
import re
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent


def _bundle():
    for line in (ROOT / "pins.tsv").read_text().splitlines():
        line = line.split("#")[0].strip()
        if line.startswith("codexzig"):
            return pathlib.Path(line.split()[1]).expanduser()
    raise SystemExit("pins.tsv has no `codexzig` line naming the bundle")


def resolve():
    """The Cobblestone checkout the codexzig bundle was built from.
    `SAFARI_COBBLESTONE` overrides it explicitly."""
    override = os.environ.get("SAFARI_COBBLESTONE")
    if override:
        path = pathlib.Path(override).expanduser()
    else:
        prov = _bundle() / "PROVENANCE"
        if not prov.is_file():
            raise SystemExit(f"{prov} is missing -- a codexzig bundle carries its PROVENANCE")
        m = re.search(r"^checkout\s+(\S+)\s*$", prov.read_text(), re.M)
        if not m:
            raise SystemExit(f"{prov} does not name its Cobblestone checkout (`checkout <path>`)")
        path = pathlib.Path(m.group(1)).expanduser()
    if not (path / "codex" / "compiler" / "opening.codex").is_file():
        raise SystemExit(f"{path} is not a Cobblestone checkout (no codex/compiler/opening.codex)")
    return path


if __name__ == "__main__":
    sys.stdout.write(str(resolve()))

#!/usr/bin/env python3
"""The Cobblestone checkout, read from the codexzig bundle's PROVENANCE.

    python3 harness/cobblestone_pin.py      # prints the path
    from cobblestone_pin import resolve      # -> pathlib.Path

Safari borrows one codexzig BUNDLE -- a directory holding the `codexzig`
executable beside a PROVENANCE that names the Cobblestone checkout it was built
from (the `codexzig` line in pins.tsv). The language pin is that checkout.
`SAFARI_COBBLESTONE` overrides explicitly.

**quires.tsv NAMES IT TOO, AND THE TWO MUST AGREE.** The Rust tools read no
environment variable; a spec sits outside any checkout, so they take it from
the `checkout` line in quires.tsv. That line is a second copy of the pin, and
this refuses when it names another tree.

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
    named = _named()
    if named is None:
        raise SystemExit(f"{ROOT / 'quires.tsv'} has no `checkout` line, and the Rust tools read the checkout from it")
    if named != path.resolve():
        raise SystemExit(f"quires.tsv names the checkout {named} and the pin is {path}; change one to match the other")
    return path


def _named():
    """The checkout quires.tsv's `checkout` line names, or None."""
    for line in (ROOT / "quires.tsv").read_text().splitlines():
        words = line.split()
        if words[:1] == ["checkout"] and len(words) == 2:
            return (ROOT / pathlib.Path(words[1]).expanduser()).resolve()
    return None


if __name__ == "__main__":
    sys.stdout.write(str(resolve()))

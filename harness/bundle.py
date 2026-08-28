#!/usr/bin/env python3
"""Assemble a runnable unit from a Codex root chapter in this port.

The depot's own bundler (build/bundle-app.ps1) resolves only cites whose quire
is registered in the Codex checkout, so it cannot see this port's chapters. The
ladder's cite_resolve.py already does the identical walk and takes the quire map
as an argument, so the port registers itself as two extra quires rather than
growing a second bundler:

    Safari -> port/    the port itself, hand written
    Judge  -> judge/   the graders and the run roots, hand written
    Gold   -> gold/    the gold chapters, GENERATED from the zig probes
    Poc    -> poc/     the browser proof of concept, throwaway by design

Gold is a quire of its own rather than a corner of judge/ because its contents
are rewritten by every harness run and the judges are not; a directory that
mixes the two invites editing a file the next run overwrites.

_walk joins each quire directory onto the checkout root, and pathlib discards
the left side of that join when the right side is absolute -- which is why an
absolute path registers cleanly without touching the ladder or the depot.

An unresolved cite exits non-zero. The depot treats a cite as satisfied when the
chapter is already present in the unit, so a typo'd quire would otherwise pass
silently here and fail as an undefined name three steps downstream.
"""

import os
import pathlib
import sys

HERE = pathlib.Path(__file__).resolve().parent
ROOT = HERE.parent

LADDER = pathlib.Path(os.environ.get(
    'SAFARI_LADDER', pathlib.Path.home() / 'showell_repos' / 'codex-zig-ladder'))


def _cite_resolve():
    """The ladder's resolver, imported rather than copied.

    A copy would drift from the walk the depot actually performs, and the whole
    point of the unit is that it is the same program the depot would build.
    """
    if not (LADDER / 'cite_resolve.py').is_file():
        raise SystemExit(
            f'no cite_resolve.py under {LADDER}; set SAFARI_LADDER to the ladder checkout')
    sys.path.insert(0, str(LADDER))
    import cite_resolve
    return cite_resolve


def bundle(root_chapter):
    cr = _cite_resolve()
    dirs = cr.quire_dirs()
    dirs['Safari'] = str(ROOT / 'port')
    dirs['Judge'] = str(ROOT / 'judge')
    dirs['Gold'] = str(ROOT / 'gold')
    dirs['Poc'] = str(ROOT / 'poc')
    unit, missing = cr.resolve(root_chapter, dirs)
    for who, quire, name in missing:
        print(f'UNRESOLVED: {who} cites {quire} chapter {name}', file=sys.stderr)
    if missing:
        raise SystemExit(1)
    return unit


def main():
    if len(sys.argv) != 3:
        raise SystemExit('usage: bundle.py <root.codex> <out-unit.codex>')
    pathlib.Path(sys.argv[2]).write_text(bundle(sys.argv[1]))
    return 0


if __name__ == '__main__':
    sys.exit(main())

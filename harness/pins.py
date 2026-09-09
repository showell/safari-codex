"""Set CODEX_ROOT for safari's children, DERIVED from the borrowed transpilers.

    CODEX_ROOT is already exported in this box's login environment, pointing at
    the shared Cobblestone checkout. Every script here used to write

        : "${CODEX_ROOT:=$HOME/showell_repos/cobblestone-safari}"

    which reads as a pin and is not one: `:=` only fires when the variable is
    UNSET, so the ambient value won -- silently, every time. So the project
    SETS the variable for its children instead of asking for it.

    WHAT CHANGED. The path used to come from a `cobblestone` line in pins.tsv --
    safari's own second copy of a pin the transpilers already carry, and the
    copy that drifts. It now comes from `cobblestone_pin.resolve()`, which reads
    the checkout each borrowed transpiler records and refuses if they disagree.
    See that module for why. `SAFARI_COBBLESTONE` still overrides explicitly.

    Importing this module is what applies it.
"""
import os
import pathlib
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from cobblestone_pin import resolve  # noqa: E402

COBBLESTONE = resolve()

# Authoritative for everything downstream: harness/cite_resolve.py reads it, and
# so does the ladder's ladder_root, which is how ring_compile finds the SEED the
# guest arms boot. A guest booted from one tree while the unit was bundled from
# another is a disagreement neither arm would report.
os.environ["CODEX_ROOT"] = str(COBBLESTONE)

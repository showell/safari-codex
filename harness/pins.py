"""The pinned trees, SET rather than defaulted.

    CODEX_ROOT is already exported in this box's login environment, pointing at
    the shared Cobblestone checkout. Every script here used to write

        : "${CODEX_ROOT:=$HOME/showell_repos/cobblestone-safari}"

    which reads as a pin and is not one: `:=` only fires when the variable is
    UNSET, so the ambient value won -- silently, every time, and the pin was
    decoration. It was caught by `./harness/build_codexwasm.sh` bundling the
    shared tree's wasm emitter, which is the version WITHOUT the Real support
    the arm depends on; the bundle simply had none of the new definitions in it.

    So the project sets the variable for its children instead of asking for it.
    An override is `SAFARI_COBBLESTONE`, a name nothing else exports, which is
    the property `CODEX_ROOT` lacked.

    Importing this module is what applies it. `PROVENANCE.md` names the trees.
"""
import os
import pathlib

COBBLESTONE = pathlib.Path(os.environ.get(
    "SAFARI_COBBLESTONE",
    pathlib.Path.home() / "showell_repos" / "cobblestone-safari")).expanduser()

if not (COBBLESTONE / "codex" / "compiler" / "opening.codex").is_file():
    raise SystemExit(f"SAFARI_COBBLESTONE={COBBLESTONE} is not a Cobblestone checkout "
                     "(no codex/compiler/opening.codex)")

# Authoritative for everything downstream: harness/cite_resolve.py reads it, and
# so does the ladder's ladder_root, which is how ring_compile finds the SEED the
# guest arms boot. A guest booted from one tree while the unit was bundled from
# another is a disagreement neither arm would report.
os.environ["CODEX_ROOT"] = str(COBBLESTONE)

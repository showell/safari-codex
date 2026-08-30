#!/usr/bin/env python3
"""Build build/wasmringplug.cdx -- the FOURTH ARM's compiler, once.

    ./harness/wasm_plug_build.py            # build it if the bundle moved
    ./harness/wasm_plug_build.py --force    # build it regardless

This is the arm's whole fixed cost. The plug is a Codex program like any other
and the only compiler on this box that can turn it into something runnable is
the seed under QEMU, so the wasm emitter has to be booted before there is any
wasm. Once the cdx exists, every module transpiled through it is two guests and
no more; this one is paid once per emitter change.

The fingerprint is the sha of the BUNDLE, not an mtime, and the same discipline
the ladder's ringplug_build.sh keeps for the same reason: a stale plug silently
transpiles with yesterday's emitter, and a wasm module that runs is not evidence
that it was built from the source in the tree.
"""
import hashlib
import os
import pathlib
import subprocess
import sys
import time

ROOT = pathlib.Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "harness"))
from metal import load_venue, LADDER  # noqa: E402  -- and its sys.path insert

load_venue()

BUNDLE = ROOT / "build" / "wasmringplug-source.codex"
CDX = ROOT / "build" / "wasmringplug.cdx"
FP = ROOT / "build" / "wasmringplug.cdx.fp"


def cobblestone_root():
    """The checkout the plug is bundled FROM.

    Not CODEX_ROOT. The rest of the loop reads the shared checkout; this arm
    needs the worktree carrying the wasm emitter's real-conversion rows, and
    silently bundling the shared one would produce a plug with three holes in
    it that fails only at wat2wasm, one module later.
    """
    root = os.environ.get("COBBLESTONE_ROOT",
                          pathlib.Path.home() / "showell_repos/cobblestone-safari")
    return str(pathlib.Path(root).expanduser().resolve())


def bundle():
    subprocess.run([os.path.expanduser("~/.local/pwsh/pwsh"), "-NoProfile", "-File",
                    str(ROOT / "harness/bundle_wasmplug.ps1")],
                   env={**os.environ, "COBBLESTONE_ROOT": cobblestone_root()},
                   check=True)
    return hashlib.sha256(BUNDLE.read_bytes()).hexdigest()


def main():
    force = "--force" in sys.argv[1:]
    want = bundle()
    if not force and CDX.is_file() and FP.is_file() and FP.read_text().strip() == want:
        print(f"build/wasmringplug.cdx already matches this bundle ({want[:12]}) -- not recompiling")
        return 0
    import ring_compile
    blob = ROOT / "build" / "wasmringplug-cdx.blob"
    blob.write_bytes(b"CDX map\n" + BUNDLE.read_bytes() + b"\x04")
    print(f"compiling {BUNDLE.stat().st_size} bytes of plug on the seed...", flush=True)
    CDX.unlink(missing_ok=True)
    t0 = time.time()
    ok = ring_compile.compile_ring(str(blob), str(CDX))
    print(f"  the guest took {time.time() - t0:.0f}s", flush=True)
    if not ok or not CDX.is_file() or CDX.stat().st_size == 0:
        raise SystemExit("PLUG COMPILE FAILED")
    FP.write_text(want)
    print(f"build/wasmringplug.cdx built ({CDX.stat().st_size} bytes, {want[:12]})")
    return 0


if __name__ == "__main__":
    sys.exit(main())

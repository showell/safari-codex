#!/usr/bin/env python3
"""Grade ONE chapter on all three arms: bare metal, the zig plug, the wasm plug.

    ./harness/metal_chapter.py ~/showell_repos/cobblestone-plugbatch/codex/plugs/wasm/test/guard-nest-rt.codex

`harness/plug_probe.py` asks whether the two PLUGS agree and takes the zig arm
as the reference, which it says plainly is a reference by availability rather
than by right. This adds the arm that is right: the Codex compiler's own x86-64
emitter, as a kernel image booted under QEMU. When a chapter is going upstream
as a plug test, the .expected the reviewer will grade it against is bare metal's
output and not ours, so this prints bare metal's output and the two plugs beside
it.

WHY IT IS A SCRIPT. The bare-metal path is a bundle, a ring compile into the
seed and a boot -- three steps with a blob framing in the middle, and a hand-run
version of it is how two builds stop being comparable. `harness/metal.py` owns
that path for this port's own checks; this is the same path for a chapter that
lives anywhere, which is what an upstream test file does.

IT BOOTS TWO GUESTS PER CHAPTER, about a minute each under TCG, and takes the
ladder's compute lock while it does. The rest of this repo runs without a
machine; this does not, so it has its own cadence: run it when a test is written
or changed, not on every edit.
"""
import os
import pathlib
import subprocess
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
import pins  # noqa: F401  -- SETS CODEX_ROOT
import plug_probe
from metal import load_venue

ROOT = pathlib.Path(__file__).resolve().parent.parent
OUT = ROOT / "build" / "chapterprobe"


def metal_output(name, unit):
    """What bare metal prints. Two guests: one to compile, one to run.

    The same framing `harness/metal.py` uses -- a map header, the unit, an
    end-of-transmission byte -- and the same filter for the guest's own
    narration on the program's channel.
    """
    import codex_vm
    import ring_compile
    blob = OUT / f"{name}.blob"
    blob.write_bytes(b"CDX map\n" + unit.read_bytes() + b"\x04")
    cdx = OUT / f"{name}.cdx"
    print(f"  {name}: compiling {unit.stat().st_size} bytes on the seed...",
          file=sys.stderr, flush=True)
    if not ring_compile.compile_ring(str(blob), str(cdx)):
        return "BARE METAL DID NOT COMPILE IT"
    print(f"  {name}: booting {cdx.stat().st_size} bytes...", file=sys.stderr, flush=True)
    out = codex_vm.run_cdx(str(cdx))
    lines = [l for l in out.decode("utf-8", "replace").splitlines()
             if not l.startswith(("WD:", "HEAP:", "STACK:"))]
    return "\n".join(lines) + "\n" if lines else ""


def main():
    load_venue()
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    if not args:
        raise SystemExit(__doc__)
    OUT.mkdir(parents=True, exist_ok=True)
    plug_probe.OUT = OUT
    bad = []
    for arg in args:
        src = pathlib.Path(arg).expanduser().resolve()
        if not src.is_file():
            raise SystemExit(f"no {src}")
        name = src.stem
        unit = OUT / f"{name}-unit.codex"
        subprocess.run([sys.executable, str(ROOT / "harness/bundle.py"), str(src), str(unit)],
                       check=True, stdout=subprocess.DEVNULL)
        arms = {}
        if "--no-metal" not in sys.argv:
            arms["metal"] = metal_output(name, unit)
        arms["zig"] = plug_probe.zig_side(name, unit)
        arms["wasm"] = plug_probe.wasm_side(name, unit)
        # Bare metal is the truth where it ran; where it did not, the zig arm is
        # the reference and the run says so rather than quietly promoting it.
        ref = "metal" if "metal" in arms else "zig"
        agree = all(v == arms[ref] for v in arms.values())
        print(f"\n{name}  [{'AGREE' if agree else 'DIFFER'}, reference: {ref}]")
        for arm, text in arms.items():
            for line in (text.strip().splitlines() or ["(no output)"])[:8]:
                print(f"  {arm:<6}| {line[:110]}")
        if not agree:
            bad.append(name)
    print(f"\n{len(args) - len(bad)} agree, {len(bad)} differ"
          + (f": {' '.join(bad)}" if bad else ""))
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main())

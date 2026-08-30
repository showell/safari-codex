#!/usr/bin/env python3
"""Differential probe of the WASM PLUG against the zig plug.

    ./harness/plug_probe.py                 # every probe/plug/*.codex
    ./harness/plug_probe.py pow real-min    # named ones

THE TARGET IS THE PLUG, not this port. `harness/wasm_arm.py` compares whole
checks and answers "does the safari port compute the same thing both ways"; that
is settled. This asks the smaller and more useful question: given one language
feature, does `codex/plugs/wasm` emit a module that computes what the zig plug's
program computes? A probe is a few lines of Codex printing a handful of values,
so a disagreement names a feature instead of a chapter.

Both roads are native and neither boots a guest:

    codexzig  <probe>  ->  zig  ->  zig build-exe  ->  run
    codexwasm <probe>  ->  WAT  ->  wat2wasm       ->  wasmtime

The zig plug is the reference by availability rather than by right -- it is the
one this project has already checked against bare metal at 523,414 fields
(README, the third arm), so where the two disagree the zig side is the one with
evidence behind it. A probe that BOTH plugs get wrong is invisible here and
`./harness/metal.py` is the arm that would see it.
"""
import os
import pathlib
import subprocess
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
import pins  # noqa: F401  -- SETS CODEX_ROOT

ROOT = pathlib.Path(__file__).resolve().parent.parent
PROBES = ROOT / "probe" / "plug"
OUT = ROOT / "build" / "plugprobe"
WASMTIME = [str(ROOT / "tools/bin/wasmtime"), "-W",
            f"max-wasm-stack={os.environ.get('SAFARI_WASM_STACK', 16777216)}"]


def tool(script):
    return subprocess.run([str(ROOT / "harness" / script)],
                          capture_output=True, text=True, check=True).stdout.strip()


def zig_side(name, unit):
    """codexzig, then a native executable."""
    zsrc = OUT / f"{name}.zig"
    with open(unit) as fi, open(zsrc, "w") as fe, open(OUT / f"{name}.zdiag", "w") as fo:
        subprocess.run([tool("build_codexzig.sh")], stdin=fi, stderr=fe, stdout=fo)
    if "// THE PRELUDE" not in zsrc.read_text():
        return "ZIG PLUG EMITTED NO PROGRAM\n" + zsrc.read_text()[:400]
    zig = os.environ.get("ZIG", str(pathlib.Path.home() / "zig-0.16.0/zig"))
    b = subprocess.run([zig, "build-exe", zsrc.name, f"-femit-bin={name}.exe"],
                       cwd=OUT, capture_output=True, text=True)
    if b.returncode:
        return "ZIG REFUSED THE EMITTED PROGRAM\n" + (b.stderr or b.stdout)[:600]
    r = subprocess.run([str(OUT / f"{name}.exe")], capture_output=True, text=True)
    return r.stdout + r.stderr


def wasm_side(name, unit):
    """codexwasm, then wat2wasm, then wasmtime."""
    wat = OUT / f"{name}.wat"
    with open(unit) as fi, open(wat, "w") as fe, open(OUT / f"{name}.wdiag", "w") as fo:
        subprocess.run([tool("build_codexwasm.sh")], stdin=fi, stderr=fe, stdout=fo)
    if not wat.read_text().startswith("(module"):
        return "WASM PLUG EMITTED NO MODULE\n" + wat.read_text()[:400]
    a = subprocess.run(["node", "--no-warnings", str(ROOT / "harness/wat2wasm.mjs"),
                        str(wat), str(OUT / f"{name}.wasm")], capture_output=True, text=True)
    if a.returncode:
        # The assembler IS the type checker for this emitter, so its complaint is
        # the finding rather than a step on the way to one.
        lines = [l for l in (a.stderr or a.stdout).splitlines() if "error" in l]
        return "WAT2WASM REFUSED THE MODULE\n" + "\n".join(lines[:6])
    r = subprocess.run(WASMTIME + [str(OUT / f"{name}.wasm")], capture_output=True, text=True)
    if r.returncode != 0:
        return (f"THE MODULE DIED (exit {r.returncode})\n" + r.stdout
                + "\n".join(r.stderr.splitlines()[:3]))
    return r.stdout + r.stderr


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    names = sys.argv[1:] or sorted(p.stem for p in PROBES.glob("*.codex"))
    bad = []
    for name in names:
        src = PROBES / f"{name}.codex"
        if not src.is_file():
            raise SystemExit(f"no {src}")
        unit = OUT / f"{name}-unit.codex"
        subprocess.run([sys.executable, str(ROOT / "harness/bundle.py"), str(src), str(unit)],
                       check=True, stdout=subprocess.DEVNULL)
        want, got = zig_side(name, unit), wasm_side(name, unit)
        if want == got:
            print(f"  {name:22} agree   {want.strip().splitlines()[0][:60] if want.strip() else '(no output)'}")
        else:
            bad.append(name)
            print(f"  {name:22} DIFFER")
            for label, text in (("zig ", want), ("wasm", got)):
                for line in text.strip().splitlines()[:6]:
                    print(f"      {label} | {line[:110]}")
    print(f"\n{len(names) - len(bad)} agree, {len(bad)} differ" + (f": {' '.join(bad)}" if bad else ""))
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main())

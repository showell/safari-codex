#!/usr/bin/env python3
"""THE FOURTH ARM: the same check as wasm, twice, by two different roads.

    ./harness/wasm_arm.py Pond [World ...]   # named checks
    ./harness/wasm_arm.py --entry SpikeMain  # a poc entry, on values

The first three arms are settled and agree (README, "The third arm"), so this
one does not re-run them. It asks a narrower question:

    Codex -> zig -> wasm        (codexzig, then zig build-exe -target wasm32-wasi)
    Codex -> IR  -> wasm        (the seed, then plugs/wasm's own emitter)

and requires the two modules to print the same bytes under the same host. The
left road is the one this project has always used, with a wasm back end bolted
on the end of it; the right road never sees zig at all. A difference between
them is a defect in one of the two emitters, and the source is the same source
either way, so it is not in the port.

WHAT IT COSTS. Two guests per module and nothing else: one to compile the
bundled unit to IR, one to run the wasm plug over that IR. The plug itself is a
third guest, paid once by harness/wasm_plug_build.py and reused until the
emitter moves. Both roads finish in node, which is free.

WHY THE IR IS COMPILED WITH passes=text-plug. A plug that emits SOURCE resolves
a Codex call by its NAME -- `wat-try-builtin` is a table of names -- so a pass
that substitutes a builtin's body and deletes the call takes away the only
handle the emitter has on it. codex/plugs/wasm/run.ps1 passes the same flag for
the same reason. It does mean the two arms are handed different IR, which is
worth being explicit about: this compares the ANSWER, not the pipeline.
"""
import os
import pathlib
import subprocess
import sys
import time

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from metal import load_venue, report  # noqa: E402  -- and its ladder sys.path insert
from names import snake  # noqa: E402
import wasmify  # noqa: E402

ROOT = pathlib.Path(__file__).resolve().parent.parent
load_venue()

PLUG = ROOT / "build" / "wasmringplug.cdx"
IR_FLAGS = " passes=text-plug"
SENTINEL = b"WASMRING-DONE"
# The guest narrates its own state on the program's channel, exactly as it does
# for metal.py; these three prefixes are that narration and not the module.
NARRATION = ("WD:", "HEAP:", "STACK:", "PM:")
NODE = ["node", "--no-warnings"]


def bundle(src, unit):
    subprocess.run([sys.executable, str(ROOT / "harness/bundle.py"), str(src), str(unit)],
                   check=True)


def zig_wasm(chapter, mod):
    """The LEFT road: codexzig's zig, built for wasm32-wasi and run in node.

    run.sh owns the transpile, for metal.py's reason: comparing fresh source on
    one arm against a stale binary on the other reports a defect where there is
    none. It is stamp-guarded, so this costs under a second when nothing moved.
    """
    subprocess.run([str(ROOT / "harness/run.sh"), chapter], check=True, stdout=subprocess.DEVNULL)
    src = ROOT / "build" / f"{mod}_wasi.zig"
    src.write_text(wasmify.wasify((ROOT / "build" / f"{mod}.zig").read_text(),
                                  int(os.environ.get("HEAP_MB", "512"))))
    zig = os.environ.get("ZIG", str(pathlib.Path.home() / "zig-0.16.0/zig"))
    # A HALF-GIGABYTE STACK, because the hosted entry asked for one and meant it:
    # the port's flatteners recurse once per element and RenderCheck's deepest is
    # thousands of frames down. wasm32-wasi's default is 1 MB and overflowing it
    # is a trap with no message.
    subprocess.run([zig, "build-exe", src.name, "-target", "wasm32-wasi",
                    "--stack", "536870912", f"-femit-bin={mod}_zig.wasm"],
                   cwd=ROOT / "build", check=True)
    return run_wasm(ROOT / "build" / f"{mod}_zig.wasm")


def plug_wasm(chapter, mod, src):
    """The RIGHT road: the seed for IR, then plugs/wasm's emitter for the module."""
    if not PLUG.is_file():
        raise SystemExit("no build/wasmringplug.cdx -- run ./harness/wasm_plug_build.py")
    import ring_compile
    unit = ROOT / "build" / f"{mod}-unit.codex"
    bundle(src, unit)

    ir = ROOT / "build" / f"{mod}.ir"
    blob = ROOT / "build" / f"{mod}-ir-cce.blob"
    blob.write_bytes(b"IR-CCE" + IR_FLAGS.encode() + b"\n" + unit.read_bytes() + b"\x04")
    print(f"  compiling {unit.stat().st_size} bytes to IR on the seed...", flush=True)
    t0 = time.time()
    if not ring_compile.compile_ring(str(blob), str(ir)):
        return None
    print(f"  IR: {ir.stat().st_size} bytes in {time.time() - t0:.0f}s", flush=True)

    # NUL, not EOT, terminates a ring-fed plug: read-serial-cce stops at a zero
    # byte, and code 0 is reserved in CCE so no IR ever carries one.
    raw = ROOT / "build" / f"{mod}.wat.raw"
    pblob = ROOT / "build" / f"{mod}-wat.blob"
    pblob.write_bytes(b"RING wasm\n" + ir.read_bytes() + b"\x00")
    print(f"  transpiling {ir.stat().st_size} bytes through the wasm plug...", flush=True)
    t0 = time.time()
    if not ring_compile.compile_ring(str(pblob), str(raw), seed=str(PLUG), sentinel=SENTINEL):
        return None
    wat = ROOT / "build" / f"{mod}.wat"
    text = raw.read_bytes().decode("utf-8", "replace")
    wat.write_text("\n".join(l for l in text.splitlines()
                             if not l.startswith(NARRATION)) + "\n")
    print(f"  WAT: {wat.stat().st_size} bytes in {time.time() - t0:.0f}s", flush=True)

    out = ROOT / "build" / f"{mod}_plug.wasm"
    subprocess.run(NODE + [str(ROOT / "harness/wat2wasm.mjs"), str(wat), str(out)], check=True)
    return run_wasm(out)


def run_wasm(path):
    r = subprocess.run(NODE + [str(ROOT / "harness/runwasi.mjs"), str(path)],
                       capture_output=True, text=True)
    # The two roads do not agree on a FILE DESCRIPTOR and there is no reason they
    # should: zig's std.debug.print is stderr by definition, and the plug's
    # wasi_print_text writes fd 1. The check's output is its whole answer either
    # way, so both streams are taken and the comparison is of what was printed.
    return r.stdout + r.stderr


def main():
    args = sys.argv[1:]
    if not args:
        raise SystemExit(__doc__.strip().splitlines()[2].strip())
    entries = args[0] == "--entry"
    if entries:
        args = args[1:]
    bad = 0
    for name in args:
        print(f"\n######## {name}", flush=True)
        mod = snake(name)
        src = (ROOT / "poc" / f"{name}.codex") if entries else (ROOT / "judge" / f"{name}Check.codex")
        if not src.is_file():
            raise SystemExit(f"no {src}")
        want = zig_wasm(name, mod) if not entries else zig_entry_wasm(name, mod, src)
        got = plug_wasm(name, mod, src)
        if got is not None:
            (ROOT / "build" / f"{mod}.plugwasm").write_text(got)
        bad |= report(name, want, got)
    print("\nWASM-ARM RED" if bad else "\nWASM-ARM GREEN")
    return bad


def zig_entry_wasm(name, mod, src):
    """The left road for a poc ENTRY, which run.sh does not build."""
    unit = ROOT / "build" / f"{mod}-unit.codex"
    bundle(src, unit)
    codexzig = os.environ.get("CODEXZIG", str(pathlib.Path.home() /
                              "showell_repos/codex-zig-transpiler/generated/local/codexzig"))
    with open(unit) as fi, open(ROOT / "build" / f"{mod}.zig", "w") as fe, \
            open(ROOT / "build" / f"{mod}.diag", "w") as fo:
        subprocess.run([codexzig], stdin=fi, stderr=fe, stdout=fo, check=True)
    src_wasi = ROOT / "build" / f"{mod}_wasi.zig"
    src_wasi.write_text(wasmify.wasify((ROOT / "build" / f"{mod}.zig").read_text(),
                                       int(os.environ.get("HEAP_MB", "512"))))
    zig = os.environ.get("ZIG", str(pathlib.Path.home() / "zig-0.16.0/zig"))
    subprocess.run([zig, "build-exe", src_wasi.name, "-target", "wasm32-wasi",
                    "--stack", "536870912", f"-femit-bin={mod}_zig.wasm"],
                   cwd=ROOT / "build", check=True)
    return run_wasm(ROOT / "build" / f"{mod}_zig.wasm")


if __name__ == "__main__":
    sys.exit(main())

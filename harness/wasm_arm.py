#!/usr/bin/env python3
"""THE FOURTH ARM: the same check as wasm, twice, by two different roads.

    ./harness/wasm_arm.py Pond [World ...]     # named checks, two guests each
    ./harness/wasm_arm.py --native --all       # every check, NO GUEST, seconds
    ./harness/wasm_arm.py --entry SpikeMain    # a poc entry, on values
    ./harness/wasm_arm.py --native --both Pond # and prove the two roads agree

The first three arms are settled and agree (README, "The third arm"), so this
one does not re-run them. It asks a narrower question:

    Codex -> zig -> wasm        (codexzig, then zig build-exe -target wasm32-wasi)
    Codex -> IR  -> wasm        (the seed, then plugs/wasm's own emitter)

and requires the two modules to print the same bytes under the same host. The
left road is the one this project has always used, with a wasm back end bolted
on the end of it; the right road never sees zig at all. A difference between
them is a defect in one of the two emitters, and the source is the same source
either way, so it is not in the port.

WHAT IT COSTS, TWO WAYS. The GUEST road is two guests a module: one to compile
the bundled unit to IR on the seed, one to run the wasm plug over that IR, plus
a third paid once by harness/wasm_plug_build.py. The NATIVE road (--native) is
`build/codexwasm`, a binary that does the whole thing in about a tenth of a
second and boots nothing.

THE NATIVE ROAD EXISTS BECAUSE codexzig DOES. codexzig is Codex in, zig out, and
it runs on this host -- so bundling the compiler's front end with plugs/wasm's
emitter and handing THAT to codexzig produces a native wasm transpiler with no
seed involved anywhere. ./harness/build_codexwasm.sh is 77 seconds and no guest.

THEY ARE NOT THE SAME EVIDENCE and --both is how that is kept honest. The guest
road runs the emitter on BARE METAL under the seed's own x86; the native road
runs it as zig compiled by codexzig. Same emitter, same IR, different machine.
--both runs each and requires the two WATs to be byte-identical, which is the
claim that lets --native stand in for the guest road day to day. They are, on
every check here.

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


def native_wat(mod, src):
    """The RIGHT road, natively: build/codexwasm, Codex source in, WAT out.

    codexwasm writes the module to STDERR and its diagnostics to stdout, which is
    codexzig's convention and inherited from it rather than chosen. A halt writes
    its reason to stderr too, so the output is short and non-empty rather than
    empty -- which is why the marker is checked and not the size.
    """
    binary = subprocess.run([str(ROOT / "harness/build_codexwasm.sh")],
                            capture_output=True, text=True, check=True).stdout.strip()
    unit = ROOT / "build" / f"{mod}-unit.codex"
    bundle(src, unit)
    wat = ROOT / "build" / f"{mod}_native.wat"
    with open(unit) as fi, open(wat, "w") as fe, open(ROOT / "build" / f"{mod}.wdiag", "w") as fo:
        subprocess.run([binary], stdin=fi, stderr=fe, stdout=fo)
    text = wat.read_text()
    if not text.startswith("(module"):
        # THE HEAP USED TO BE THE NATIVE ROAD'S ONE LIMIT. Three units --
        # Critter, CatDraw and Safari -- exceeded the prelude's 4 GiB reserve,
        # because this is one process doing both halves on one heap that never
        # reclaims where the guest road is two processes with a fresh heap each.
        # NOT ANY MORE: the emitters stopped allocating a quadratic amount
        # (cobblestone-safari 2aff6e4d, 1893cf1e) and all seventeen now emit,
        # the largest at 680 MB. WASM_FINDINGS 6 is the measurement.
        #
        # The refusal stays because it is the honest shape for this arm: say
        # which unit produced no module and let the run continue, so one failure
        # does not cost the evidence from the other sixteen.
        first = text.splitlines()[0] if text.strip() else "(no output)"
        print(f"  codexwasm produced no module: {first[:120]}", flush=True)
        return None
    print(f"  WAT: {wat.stat().st_size} bytes, natively", flush=True)
    return wat


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

    return wat


def wat_output(mod, wat, tag):
    out = ROOT / "build" / f"{mod}_{tag}.wasm"
    subprocess.run(NODE + [str(ROOT / "harness/wat2wasm.mjs"), str(wat), str(out)], check=True)
    return run_wasm(out)


WASMTIME = [str(ROOT / "tools/bin/wasmtime"), "-W",
            f"max-wasm-stack={os.environ.get('SAFARI_WASM_STACK', 16777216)}"]


def run_wasm(path):
    """Both roads, one runner, and it is NOT node.

    node's WASI was the first bed and it is not a sound one for these modules:
    `RenderCheck` and `RiderCheck` died on it with SIGSEGV -- not a catchable
    trap -- at a line count that varied run to run, 2 lines then 10 then 2. A
    bed whose answer moves between runs cannot referee a comparison, and a
    SIGSEGV that lands mid-output would otherwise be reported as the two arms
    DISAGREEING, which is a defect claimed against code that is fine.

    wasmtime is what the emitter's own harness uses and it takes the stack as an
    argument: codex/plugs/wasm/wasm-e2e.ps1 runs `max-wasm-stack=16777216`
    because the default "exhausts inside the text printer's per-def recursion".
    Under it all six modules that node killed run clean and identical three times
    out of three. The zig road is run the same way rather than kept on node, so
    the bed is one thing and not a variable.
    """
    r = subprocess.run(WASMTIME + [str(path)], capture_output=True, text=True)
    # A MODULE THAT DIED IS NOT A MODULE THAT DISAGREED, and the difference has to
    # reach the report or the arm cries defect at its own bed. SIGSEGV out of
    # node is the shape here: the emitted module recursed past the runner's
    # stack, which runwasi.mjs raises as far as a worker allows and which is
    # nothing to do with either emitter's arithmetic.
    if r.returncode != 0:
        return (f"THE MODULE DIED: {pathlib.Path(path).name} exited {r.returncode}"
                f" after {len((r.stdout + r.stderr).splitlines())} lines\n"
                + r.stdout + r.stderr)
    # The two roads do not agree on a FILE DESCRIPTOR and there is no reason they
    # should: zig's std.debug.print is stderr by definition, and the plug's
    # wasi_print_text writes fd 1. The check's output is its whole answer either
    # way, so both streams are taken and the comparison is of what was printed.
    return r.stdout + r.stderr


def main():
    args = sys.argv[1:]
    native = "--native" in args
    both = "--both" in args
    entries = "--entry" in args
    args = [a for a in args if not a.startswith("--")]
    if "--all" in sys.argv[1:]:
        args += sorted(p.name[: -len("Check.codex")] for p in (ROOT / "judge").glob("*Check.codex"))
    if not args:
        raise SystemExit(__doc__.strip().splitlines()[2].strip())
    bad = 0
    for name in args:
        print(f"\n######## {name}", flush=True)
        mod = snake(name)
        src = (ROOT / "poc" / f"{name}.codex") if entries else (ROOT / "judge" / f"{name}Check.codex")
        if not src.is_file():
            raise SystemExit(f"no {src}")
        want = zig_entry_wasm(name, mod, src) if entries else zig_wasm(name, mod)
        got = None
        if native or both:
            wat = native_wat(mod, src)
            got = wat_output(mod, wat, "native") if wat is not None else None
            # Under --both this used to fall through to a byte comparison against
            # `wat`, which is None -- a TypeError that took the whole sweep down,
            # in the branch whose own comment promises that one failure does not
            # cost the evidence from the other sixteen. There is nothing to
            # compare a missing module to, so the unit is skipped either way.
            if wat is None:
                bad = 1
                print("  SKIPPED on the native road", flush=True)
                continue
        if not native or both:
            gwat = plug_wasm(name, mod, src)
            if gwat is None:
                got = None
            elif both:
                # THE STAND-IN'S OWN CHECK. --native is only allowed to replace the
                # guest road day to day if it emits the same module; comparing the
                # verdicts would not say that, because two different modules can
                # print the same `ok`.
                a, b = pathlib.Path(gwat).read_bytes(), pathlib.Path(wat).read_bytes()
                print(f"  the two roads' WAT: {len(a)} vs {len(b)} bytes -- "
                      + ("BYTE-IDENTICAL" if a == b else "DIFFER"), flush=True)
                bad |= a != b
            else:
                got = wat_output(mod, gwat, "plug")
        if got is not None:
            (ROOT / "build" / f"{mod}.plugwasm").write_text(got)
        bad |= report(name, want, got)
    print("\nWASM-ARM RED" if bad else "\nWASM-ARM GREEN")
    return bad


def zig_entry_wasm(name, mod, src):
    """The left road for a poc ENTRY, which run.sh does not build."""
    unit = ROOT / "build" / f"{mod}-unit.codex"
    bundle(src, unit)
    codexzig = subprocess.run([str(ROOT / "harness/build_codexzig.sh")],
                              capture_output=True, text=True, check=True).stdout.strip()
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

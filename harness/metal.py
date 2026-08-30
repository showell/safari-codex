#!/usr/bin/env python3
"""Run a check on BARE METAL and compare it with the zig arm.

    ./harness/metal.py Pond [Camera ...]      # named checks
    ./harness/metal.py --all                  # every check, smallest first
    ./harness/metal.py --entry SpikeMain ...  # poc entries, compared on VALUES

THE THIRD ARM. `harness/run.sh` verifies the port against the game by way of the
zig plug: Codex source in, zig out, a native binary that prints its verdict. That
proves the PORT right and says nothing about the plug. This runs the SAME check a
second way -- through the Codex compiler's own x86-64 emitter, as a kernel image
booted under QEMU -- and requires the two to print the same bytes.

What that adds is a Diverse Double-Compiling check in Wheeler's sense, on this
port's own code: the ladder next door does it for the compiler, and this does it
for a program. A difference between the arms is a defect in one of them, and the
port is the same source either way, so it is not in the port.

IT BOOTS GUESTS AND THE REST OF THIS REPO DOES NOT. A sweep is three seconds
because nothing here needs a machine; this needs two per check, a minute or so
each under TCG, so it is a separate script with a separate cadence. Run it when
a chapter changes shape, not on every edit.

The machinery is the ladder's, borrowed rather than restated: `ring_compile`
streams a cite-resolved unit into the seed and takes back a .cdx, `codex_vm`
boots it and captures the serial. Both take the compute lock, so this cannot
start a guest without asking, and both refuse off the venue.
"""
import os
import pathlib
import subprocess
import sys

from names import snake

ROOT = pathlib.Path(__file__).resolve().parent.parent
LADDER = pathlib.Path(os.environ.get("SAFARI_LADDER",
                                     pathlib.Path.home() / "showell_repos/codex-zig-ladder"))
sys.path.insert(0, str(LADDER))


def load_venue():
    """Read ~/.codex_ladder_env if it is there.

    THIS IS NOT A BYPASS OF THE VENUE CHECK, it is the venue check's own marker
    read from the place the ladder puts it. That file exists only on the host
    that computes; on any other, it is absent and `compute_lock.require_venue`
    refuses before a guest can start. What this buys is that `./harness/metal.py`
    works without remembering to source anything, which is one fewer way to get a
    confusing refusal on the box where the answer is yes.
    """
    env = pathlib.Path.home() / ".codex_ladder_env"
    if not env.is_file():
        return
    for line in env.read_text().splitlines():
        line = line.strip()
        if line.startswith("export ") and "=" in line:
            k, v = line[len("export "):].split("=", 1)
            os.environ.setdefault(k.strip(), v.strip().strip('"\''))


load_venue()


def zig_output(chapter):
    """What the zig arm prints. Built by run.sh, which is left to own that.

    ALWAYS run.sh, NOT "run it if the binary is missing". The old form built only
    when build/<mod> did not exist, so an edited check was compared as FRESH source
    on bare metal against a STALE binary on the zig side -- and the two arms then
    disagree for a reason that has nothing to do with either emitter. That reports
    a defect where there is none, which is the expensive direction to be wrong in
    even though it is the safe one. run.sh is stamp-guarded and costs under a
    second when nothing changed, so there is no reason to guess.
    """
    mod = snake(chapter)
    subprocess.run([str(ROOT / "harness/run.sh"), chapter], check=True,
                   stdout=subprocess.DEVNULL)
    out = subprocess.run([f"./{mod}"], cwd=ROOT / "build",
                         capture_output=True, text=True)
    return out.stderr  # a transpiled program prints to stderr (PORTING_NOTES C2)


def metal_output(chapter):
    """What bare metal prints. Two guests: one to compile, one to run."""
    import codex_vm
    import ring_compile
    mod = snake(chapter)
    unit = ROOT / "build" / f"{mod}-unit.codex"
    subprocess.run([sys.executable, str(ROOT / "harness/bundle.py"),
                    str(ROOT / "judge" / f"{chapter}Check.codex"), str(unit)], check=True)
    # The blob is the ring's own framing: a map header, the unit, and an
    # end-of-transmission byte. bare_expected.py in the ladder is the shape.
    blob = ROOT / "build" / f"{mod}.blob"
    blob.write_bytes(b"CDX map\n" + unit.read_bytes() + b"\x04")
    cdx = ROOT / "build" / f"{mod}.cdx"
    print(f"  compiling {unit.stat().st_size} bytes on the seed...", flush=True)
    if not ring_compile.compile_ring(str(blob), str(cdx)):
        return None
    print(f"  running {cdx.stat().st_size} bytes...", flush=True)
    out = codex_vm.run_cdx(str(cdx))
    # The guest narrates its own state on the program's channel.
    lines = [l for l in out.decode("utf-8", "replace").splitlines()
             if not l.startswith(("WD:", "HEAP:", "STACK:"))]
    return "\n".join(lines) + "\n" if lines else ""


def entry_outputs(entry):
    """Both arms for a poc ENTRY chapter -- values rather than a verdict.

    The zig side is whatever harness/spike.sh or build_wasm.sh already builds for
    that entry; this rebuilds it in place rather than guessing, so the two arms
    compile the same unit."""
    import codex_vm
    import ring_compile
    src = ROOT / "poc" / f"{entry}.codex"
    if not src.is_file():
        raise SystemExit(f"no {src}")
    mod = snake(entry)
    unit = ROOT / "build" / f"{mod}-unit.codex"
    subprocess.run([sys.executable, str(ROOT / "harness/bundle.py"), str(src), str(unit)],
                   check=True)
    zig_src = ROOT / "build" / f"{mod}.zig"
    codexzig = os.environ.get("CODEXZIG", str(pathlib.Path.home() /
                              "showell_repos/codex-zig-transpiler/generated/local/codexzig"))
    with open(unit) as fi, open(zig_src, "w") as fe, open(ROOT / "build" / f"{mod}.diag", "w") as fo:
        subprocess.run([codexzig], stdin=fi, stderr=fe, stdout=fo, check=True)
    zig = os.environ.get("ZIG", str(pathlib.Path.home() / "zig-0.16.0/zig"))
    subprocess.run([zig, "build-exe", f"{mod}.zig"], cwd=ROOT / "build", check=True)
    want = subprocess.run([f"./{mod}"], cwd=ROOT / "build",
                          capture_output=True, text=True).stderr
    blob = ROOT / "build" / f"{mod}.blob"
    blob.write_bytes(b"CDX map\n" + unit.read_bytes() + b"\x04")
    cdx = ROOT / "build" / f"{mod}.cdx"
    print(f"  compiling {unit.stat().st_size} bytes on the seed...", flush=True)
    if not ring_compile.compile_ring(str(blob), str(cdx)):
        return want, None
    print(f"  running {cdx.stat().st_size} bytes...", flush=True)
    # THE GUEST'S HEAP IS THE CEILING HERE, and it is lower than the host's. The
    # emitted prelude bump-allocates and never reclaims (PORTING_NOTES C6), so a
    # program's whole run has to fit; run_cdx defaults to 1 GB and the six-viewpoint
    # spike printed one frame and then `OUT OF MEMORY` with HEAP at 1.005 GB. The
    # venue's own CODEX_MEM_MB is the right number to ask for.
    mem = int(os.environ.get("CODEX_MEM_MB", "3072"))
    out = codex_vm.run_cdx(str(cdx), mem_mb=mem, timeout=1800, idle_timeout=300)
    lines = [l for l in out.decode("utf-8", "replace").splitlines()
             if not l.startswith(("WD:", "HEAP:", "STACK:"))]
    return want, "\n".join(lines) + "\n" if lines else ""


def report(name, want, got):
    if got is None:
        print("  SEED COMPILE FAILED")
        return 1
    if got == want:
        vals = sum(len(l.split()) for l in got.splitlines())
        print(f"  AGREES with the zig arm ({len(got.splitlines())} lines, {vals} fields)")
        return 0
    print("  DIFFERS from the zig arm")
    import difflib
    shown = 0
    for d in difflib.unified_diff(want.splitlines(), got.splitlines(),
                                  "zig", "bare-metal", lineterm=""):
        print("   ", d[:400])
        shown += 1
        if shown > 20:
            print("    ...")
            break
    return 1


def main():
    args = sys.argv[1:]
    if not args:
        raise SystemExit(__doc__.strip().splitlines()[2].strip())
    if args[0] == "--entry":
        bad = 0
        for entry in args[1:]:
            print(f"\n######## {entry} (values)", flush=True)
            want, got = entry_outputs(entry)
            if got is not None:
                (ROOT / "build" / f"{snake(entry)}.metal").write_text(got)
            bad |= report(entry, want, got)
        print("\nMETAL RED" if bad else "\nMETAL GREEN")
        return bad
    if args == ["--all"]:
        checks = sorted((ROOT / "judge").glob("*Check.codex"),
                        key=lambda p: (ROOT / "build" / f"{snake(p.name[:-len('Check.codex')])}-unit.codex").stat().st_size
                        if (ROOT / "build" / f"{snake(p.name[:-len('Check.codex')])}-unit.codex").is_file() else 0)
        args = [p.name[: -len("Check.codex")] for p in checks]
    bad = 0
    for chapter in args:
        print(f"\n######## {chapter}", flush=True)
        want = zig_output(chapter)
        got = metal_output(chapter)
        if got is None:
            print("  SEED COMPILE FAILED")
            bad = 1
            continue
        (ROOT / "build" / f"{snake(chapter)}.metal").write_text(got)
        if got == want:
            print(f"  AGREES with the zig arm ({len(got.splitlines())} lines)")
        else:
            bad = 1
            print("  DIFFERS from the zig arm")
            import difflib
            for d in difflib.unified_diff(want.splitlines(), got.splitlines(),
                                          "zig", "bare-metal", lineterm=""):
                print("   ", d)
    print("\nMETAL RED" if bad else "\nMETAL GREEN")
    return bad


if __name__ == "__main__":
    sys.exit(main())

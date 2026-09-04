#!/usr/bin/env python3
"""Run every spec, and PROVE EACH ONE CAN FAIL.

    ./spec/run.sh            the Rust interpreter alone
    ./spec/run.sh --zig      also transpile and build each spec, and diff the arms

A spec is a self-checking Codex chapter: it carries its own expected values as
literals and prints its own verdict, so any arm that runs Codex renders that
verdict alone. There is no gold and no probe. See spec/TrigSpec.codex for what
one looks like and judge/ for the different, more expensive question those ask.

A SPEC CAN PASS BY DOING NOTHING, and `spec/floors.tsv` is what stops it.
`grade-reals` on two empty lists reports `ok 0`, so a spec whose input list an
edit emptied would sail through a gate that only greps for BAD. Each spec
therefore declares the fewest graded values it must still be checking, and this
sums the `ok N` counts and refuses below the line. A floor rather than a gold:
`>=` means adding assertions never churns the file, and nobody is tempted to
update an expected number as a reflex when something goes red.

THAT REPLACED A MUTANT PASS, and the mutant was an overreaction. It re-ran every
spec with its tolerances negated and its want lists lengthened, and demanded
every line go BAD. It worked, and it doubled the run, needed its own poisoner,
and had to explain itself twice over. A floor answers the same question -- is
this spec still grading anything -- for a line of arithmetic. `spec/mutate.py`
is still there for ONE-OFF use when authoring a new spec; it is not part of the
gate and should not become part of it again.

ONE PROCESS PER SPEC, WHICH IS THE FLOOR. This was a bash loop shelling out to
bundle.py and mutate.py per spec: three interpreter starts each, 2.1 s for
thirteen specs and about 8 s projected for fifty. It then became one Python
process spawning a bundler and two interpreters per spec. Now `codexrun`
resolves its own cites, so bundling is a compiler phase rather than another
process, and a spec costs exactly one spawn.
"""
import os
import pathlib
import re
import subprocess
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent

# The compiler's own release build, not a dated run directory: a spec suite that
# points at a snapshot grades a snapshot. CODEXRUN overrides it.
BIN = os.environ.get(
    "CODEXRUN",
    os.environ.get("CARGO_TARGET_DIR", os.path.expanduser("~/build/rust-target"))
    + "/release/codexrun",
)
# THE RUST ARM RESOLVES ITS OWN CITES. This used to import harness/bundle.py,
# which meant the compiler under test was handed a unit assembled by a different
# toolchain -- and a bundling bug applied identically to every arm is one no
# comparison between them can find. Both bundlers agree on all 35 safari targets
# byte for byte, and that agreement is the gate rather than an assumption.
BUNDLE = os.environ.get(
    "CODEXBUNDLE",
    os.environ.get("CARGO_TARGET_DIR", os.path.expanduser("~/build/rust-target"))
    + "/release/bundle",
)


# A zig-arm difference that is filed and not ours: reported, never fatal.
KNOWN = "\0known\0"


def arm_gaps():
    """-> {spec name: (issue, what differs)} for known, filed zig-arm gaps."""
    out = {}
    f = ROOT / "spec" / "arm-gaps.tsv"
    if not f.is_file():
        return out
    for line in f.read_text().splitlines():
        line = line.split("#")[0].rstrip()
        if not line.strip():
            continue
        name, issue, note = (line.split("\t") + ["", ""])[:3]
        out[name.strip()] = (issue.strip(), note.strip())
    return out


def floors():
    """-> {spec name: fewest graded values it must still be checking}."""
    out = {}
    for line in (ROOT / "spec" / "floors.tsv").read_text().splitlines():
        line = line.split("#")[0].strip()
        if not line:
            continue
        name, _, n = line.partition("\t")
        out[name.strip()] = int(n)
    return out


GRADED = re.compile(r"\bok (\d+)$")


def graded(out):
    """The number of values a run actually compared."""
    return sum(int(m.group(1)) for line in out.splitlines() if (m := GRADED.search(line)))


def run(unit):
    r = subprocess.run([BIN, str(unit)], capture_output=True, text=True)
    return (r.stdout + r.stderr).strip()


def check(out, floor):
    """-> None if the spec passes and is still grading enough, else why not."""
    if not out:
        return "printed nothing"
    if "BAD" in out:
        return out
    if any(line.endswith("ok 0") for line in out.splitlines()):
        return "a line graded ZERO values\n" + out
    n = graded(out)
    if n < floor:
        return f"graded {n} values, and spec/floors.tsv says at least {floor}"
    return None


def zig_arm(name, mod, out, build, spec):
    # The zig arm takes a UNIT, so this is where a bundle still gets written --
    # for the other arm's benefit, not for ours.
    r = subprocess.run([BUNDLE, "one", str(spec), str(build / f"{mod}-unit.codex")],
                       capture_output=True, text=True)
    if r.returncode != 0:
        return r.stderr.strip() or "bundling failed"
    codexzig = subprocess.run([str(ROOT / "harness" / "build_codexzig.sh")],
                              capture_output=True, text=True).stdout.strip().splitlines()[-1]
    zig = os.environ.get("ZIG", os.path.expanduser("~/zig-0.16.0/zig"))
    # THE PROGRAM COMES OUT ON STDERR AND THE DIAGNOSTICS ON STDOUT, which is
    # backwards from every instinct and is what the bash this replaced did:
    # `2> $mod.zig > $mod.diag`. Porting it the obvious way round broke the zig
    # arm silently -- every spec reported "codexzig emitted no program" the
    # first time anyone ran it again.
    with open(build / f"{mod}-unit.codex") as f:
        r = subprocess.run([codexzig], stdin=f, capture_output=True, text=True)
    (build / f"{mod}.zig").write_text(r.stderr)
    (build / f"{mod}.diag").write_text(r.stdout)
    if "// THE PRELUDE" not in r.stderr:
        return "codexzig emitted no program"
    if subprocess.run([zig, "build-exe", f"{mod}.zig"], cwd=build).returncode:
        return "zig build failed"
    z = subprocess.run([f"./{mod}"], cwd=build, capture_output=True, text=True)
    zout = (z.stdout + z.stderr).strip()
    if zout == out:
        return None
    known = arm_gaps().get(name)
    if known:
        # Recorded, filed, and not ours. Reported every run so it cannot fade
        # into the scenery, but it does not fail the gate.
        return KNOWN + f"zig differs -- issue {known[0]}: {known[1]}"
    return "THE ARMS DISAGREE\n  rust: " + out.replace("\n", " | ") + \
           "\n  zig:  " + zout.replace("\n", " | ")


def main():
    want_zig = "--zig" in sys.argv[1:]
    if set(sys.argv[1:]) - {"--zig"}:
        raise SystemExit("usage: run.sh [--zig]")
    if not os.access(BIN, os.X_OK):
        raise SystemExit(f"no codexrun at {BIN}; set CODEXRUN")
    if want_zig and not os.access(BUNDLE, os.X_OK):
        raise SystemExit(f"no bundle at {BUNDLE}; set CODEXBUNDLE")

    build = ROOT / "build"
    build.mkdir(exist_ok=True)
    floor = floors()
    specs = sorted((ROOT / "spec").glob("*Spec.codex"))
    if not specs:
        raise SystemExit("no specs under spec/")
    missing = [s.stem for s in specs if s.stem not in floor]
    if missing:
        # A spec with no floor is a spec nothing holds to a size, and adding one
        # is the moment to decide what it must keep checking.
        raise SystemExit(f"spec/floors.tsv has no line for: {', '.join(missing)}")

    failed = 0
    for spec in specs:
        name = spec.stem
        # codexrun resolves the spec's cites itself; there is no unit to write.
        out = run(spec)
        why = check(out, floor[name])
        if why is None and want_zig:
            why = zig_arm(name, name.lower(), out, build, spec)
        if why is not None and why.startswith(KNOWN):
            print(f"{name:18s} rust ok; {why[len(KNOWN):]}")
            continue
        if why is not None:
            print(f"{name}: {why}", file=sys.stderr)
            failed += 1
            continue
        print(f"{name:18s} {'ok, both arms' if want_zig else ' '.join(out.split(chr(10)))}")

    print()
    if failed:
        print("SPECS FAILED")
        return 1
    total = sum(floor[s.stem] for s in specs)
    print(f"{len(specs)} spec(s) pass, grading at least {total} values")
    return 0


if __name__ == "__main__":
    sys.exit(main())

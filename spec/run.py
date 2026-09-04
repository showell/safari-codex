#!/usr/bin/env python3
"""Run every spec, and PROVE EACH ONE CAN FAIL.

    ./spec/run.sh            the Rust interpreter alone
    ./spec/run.sh --zig      also transpile and build each spec, and diff the arms

A spec is a self-checking Codex chapter: it carries its own expected values as
literals and prints its own verdict, so any arm that runs Codex renders that
verdict alone. There is no gold and no probe. See spec/TrigSpec.codex for what
one looks like and judge/ for the different, more expensive question those ask.

THE SECOND PASS IS THE POINT. A test that carries its own answers is prone to
passing by doing NOTHING: `grade-reals` on two empty lists reports `ok 0`, and a
spec whose input list an edit emptied would sail through a gate that only greps
for BAD. So every spec runs twice -- once as written, which must be all ok, and
once poisoned, which must be all BAD. A line that survives the mutant is a line
that never ran. spec/mutate.py says what it poisons and what the poison cannot
reach.

ONE PROCESS, BECAUSE THE TARGET IS FIFTY SPECS AND TEN SECONDS. This was a bash
loop shelling out to bundle.py and mutate.py per spec. Measured, a bare Python
start is 35 ms against 25 ms of actual bundling work and a 5 ms codexrun, so
three interpreter starts per spec were most of the run: 2.1 s for thirteen and
about 8 s projected for fifty, which is the ceiling rather than comfortably
under it. Importing both as modules pays that 35 ms once.

AND THE MUTANT POISONS THE BUNDLE RATHER THAN THE SOURCE, which halves the
bundling. The spec's own chapter lands LAST in a bundle, so the tail from its
`Chapter:` header is exactly its own text and nothing cited -- poisoning there
cannot reach a `-want` in a chapter under test. Bundling the mutant separately
would have been the same work twice for the same bytes.
"""
import os
import pathlib
import subprocess
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "spec"))
import mutate  # noqa: E402

# The compiler's own release build, not a dated run directory: a spec suite that
# points at a snapshot grades a snapshot. CODEXRUN overrides it.
BIN = os.environ.get(
    "CODEXRUN",
    os.path.expanduser("~/showell_repos/rust-codex-compiler/target/release/codexrun"),
)
# THE RUST ARM RESOLVES ITS OWN CITES. This used to import harness/bundle.py,
# which meant the compiler under test was handed a unit assembled by a different
# toolchain -- and a bundling bug applied identically to every arm is one no
# comparison between them can find. Both bundlers agree on all 35 safari targets
# byte for byte, and that agreement is the gate rather than an assumption.
BUNDLE = os.environ.get(
    "CODEXBUNDLE",
    os.path.expanduser("~/showell_repos/rust-codex-compiler/target/release/bundle"),
)


def run(unit):
    r = subprocess.run([BIN, str(unit)], capture_output=True, text=True)
    return (r.stdout + r.stderr).strip()


def check(name, out, mutant):
    """-> None if the spec passes and was shown capable of failing, else why not."""
    if not out:
        return "printed nothing"
    if "BAD" in out:
        return out
    if any(line.endswith("ok 0") for line in out.splitlines()):
        return "a line graded ZERO values\n" + out
    live = sum("BAD" in line for line in mutant.splitlines())
    lines = len(out.splitlines())
    if live != lines:
        return (f"{live} of {lines} lines fail when poisoned -- the rest grade nothing\n"
                + mutant)
    return None


def zig_arm(name, mod, out, build):
    codexzig = subprocess.run([str(ROOT / "harness" / "build_codexzig.sh")],
                              capture_output=True, text=True).stdout.strip().splitlines()[-1]
    zig = os.environ.get("ZIG", os.path.expanduser("~/zig-0.16.0/zig"))
    with open(build / f"{mod}-unit.codex") as f:
        r = subprocess.run([codexzig], stdin=f, capture_output=True, text=True)
    (build / f"{mod}.zig").write_text(r.stdout)
    if "// THE PRELUDE" not in r.stdout:
        return "codexzig emitted no program"
    if subprocess.run([zig, "build-exe", f"{mod}.zig"], cwd=build).returncode:
        return "zig build failed"
    z = subprocess.run([f"./{mod}"], cwd=build, capture_output=True, text=True)
    zout = (z.stdout + z.stderr).strip()
    if zout != out:
        return "THE ARMS DISAGREE\n  rust: " + out.replace("\n", " | ") + \
               "\n  zig:  " + zout.replace("\n", " | ")
    return None


def main():
    want_zig = "--zig" in sys.argv[1:]
    if set(sys.argv[1:]) - {"--zig"}:
        raise SystemExit("usage: run.sh [--zig]")
    if not os.access(BIN, os.X_OK):
        raise SystemExit(f"no codexrun at {BIN}; set CODEXRUN")
    if not os.access(BUNDLE, os.X_OK):
        raise SystemExit(f"no bundle at {BUNDLE}; set CODEXBUNDLE")

    build = ROOT / "build"
    build.mkdir(exist_ok=True)
    tmp = ROOT / "build" / "mutant"
    tmp.mkdir(exist_ok=True)

    specs = sorted((ROOT / "spec").glob("*Spec.codex"))
    if not specs:
        raise SystemExit("no specs under spec/")

    failed = 0
    for spec in specs:
        name = spec.stem
        mod = name.lower()
        unit_path = build / f"{mod}-unit.codex"
        r = subprocess.run([BUNDLE, "one", str(spec), str(unit_path)],
                           capture_output=True, text=True)
        if r.returncode != 0:
            print(f"{name}: {r.stderr.strip() or 'bundling failed'}", file=sys.stderr)
            failed += 1
            continue
        for line in r.stderr.splitlines():
            # CRLF and dead-quire complaints are upstream's and already filed;
            # anything else the resolver says is worth seeing here.
            if not line.startswith(("CRLF:", "DEAD QUIRE:")):
                print(f"{name}: {line}", file=sys.stderr)
        unit = unit_path.read_text()
        out = run(unit_path)

        # The spec's own chapter is the tail; poison only that.
        head, sep, tail = unit.partition(f"Chapter: {name}\n")
        if not sep:
            print(f"{name}: not found in its own bundle", file=sys.stderr)
            failed += 1
            continue
        mpath = tmp / f"{mod}-unit.codex"
        try:
            mpath.write_text(head + sep + mutate.poison(tail, name))
        except SystemExit as why:
            print(f"{name}: cannot be mutated, so it cannot be shown to fail -- {why}",
                  file=sys.stderr)
            failed += 1
            continue

        why = check(name, out, run(mpath))
        if why is None and want_zig:
            why = zig_arm(name, mod, out, build)
        if why is not None:
            print(f"{name}: {why}", file=sys.stderr)
            failed += 1
            continue
        print(f"{name:18s} {'ok, both arms' if want_zig else ' '.join(out.split(chr(10)))}")

    print()
    if failed:
        print("SPECS FAILED")
        return 1
    print(f"{len(specs)} spec(s) pass, and each one was shown to be capable of failing")
    return 0


if __name__ == "__main__":
    sys.exit(main())

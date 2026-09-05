#!/usr/bin/env python3
"""Run every spec on all three arms in a sandbox, and write one PROVENANCE.

    ./spec/arms.py                 a fresh sandbox under ~/runs/
    ./spec/arms.py --out DIR       a named one
    ./spec/arms.py --keep 5        keep the newest five and delete the rest

`./spec/run.sh --arms` answers the same question and is what you want while
editing a spec: it is the same three arms and it writes into `build/`, which is
tracked, so the diff shows you what moved. THIS is what you want when the answer
has to survive being read next week -- a run whose intermediates are somewhere
nobody edits, next to a file saying what produced them.

WHAT A PROVENANCE IS FOR HERE. Three arms and four pinned trees is more moving
parts than a green line can carry, and every one of them can move without the
suite noticing: the language pin, either transpiler pin, the Rust binary, zig,
wasmtime, node. A run that cannot say which of those it measured is not evidence
about any of them. So this writes ONE file naming all of it, next to the
intermediates it produced -- and it names them by COMMIT and by fingerprint,
never by "the current checkout".

IT IS A COFFEE-BREAK RUN AND MUST STAY ONE. All three arms over every spec is
about three and a half minutes on this box, nearly all of it `zig build-exe`.
That budget is the reason the arms are ordered rust, zig, wasm and each is
skipped once an earlier one has failed: a broken spec costs a second, not a
minute. If this ever passes ten minutes, the thing to cut is the zig arm's
per-spec link, not the coverage.

IT DOES NOT BUILD ANYTHING. Every binary it uses is resolved and checked by the
harness scripts that own it, and each of those refuses rather than building. A
run that quietly rebuilt a transpiler would be measuring a tree the PROVENANCE
had already described.
"""
import datetime
import os
import pathlib
import platform
import shutil
import subprocess
import sys
import time

ROOT = pathlib.Path(__file__).resolve().parent.parent


def _apply_pin():
    """Set CODEX_ROOT from pins.tsv, the way spec/run.sh does.

    SET, not defaulted. This box exports a CODEX_ROOT globally, pointing at a
    different tree, and letting it win is the exact bug harness/pins.py was
    written for -- pointed at the shared checkout, 25 of 35 safari units bundled
    differently. SAFARI_COBBLESTONE is the override, a name nothing else exports.
    """
    if os.environ.get("SAFARI_COBBLESTONE"):
        os.environ["CODEX_ROOT"] = os.path.expanduser(os.environ["SAFARI_COBBLESTONE"])
        return
    for line in (ROOT / "pins.tsv").read_text().splitlines():
        line = line.split("#")[0].strip()
        if line.startswith("cobblestone"):
            os.environ["CODEX_ROOT"] = os.path.expanduser(line.split()[1])
            return
    raise SystemExit("pins.tsv names no cobblestone tree")


_apply_pin()
sys.path.insert(0, str(ROOT / "spec"))
import run as spec_run  # noqa: E402  -- the arms themselves; this only drives them

RUNS = pathlib.Path(os.environ.get("SAFARI_RUNS", pathlib.Path.home() / "runs"))


def sh(*argv, cwd=None):
    """-> stripped stdout, or None if the command is absent or fails."""
    try:
        r = subprocess.run(argv, capture_output=True, text=True, cwd=cwd)
    except OSError:
        return None
    return r.stdout.strip() if r.returncode == 0 else None


def pins():
    """-> [(name, path)] from pins.tsv, which is the one place they are written."""
    out = []
    for line in (ROOT / "pins.tsv").read_text().splitlines():
        line = line.split("#")[0].strip()
        if not line:
            continue
        name, _, path = line.partition(" ")
        out.append((name.strip(), pathlib.Path(path.strip()).expanduser()))
    return out


def git_at(path):
    """-> 'sha  subject' for a checkout, plus a DIRTY marker if it has changes.

    The marker matters more than the sha: a dirty tree's sha describes something
    that is not what ran.
    """
    if not path.is_dir():
        return "NO SUCH TREE"
    line = sh("git", "-C", str(path), "log", "--oneline", "-1")
    if line is None:
        return "not a git checkout"
    dirty = sh("git", "-C", str(path), "status", "--porcelain")
    branch = sh("git", "-C", str(path), "rev-parse", "--abbrev-ref", "HEAD")
    tag = f" [{branch}]" if branch and branch != "HEAD" else " [detached]"
    return line + tag + ("  +DIRTY" if dirty else "")


def tools():
    """The versions of everything outside a pinned tree that can change an answer."""
    zig = os.environ.get("ZIG", os.path.expanduser("~/zig-0.16.0/zig"))
    wasmtime = ROOT / "tools" / "bin" / "wasmtime"
    return [
        ("zig", (sh(zig, "version") or "ABSENT")),
        ("wasmtime", (sh(str(wasmtime), "--version") or "ABSENT")),
        ("node", (sh("node", "--version") or "ABSENT")),
        ("python", platform.python_version()),
        ("host", platform.node()),
    ]


def binaries():
    """The three executables the arms actually run, by path and by size.

    codexrun and bundle come from rust-codex-compiler through CARGO_TARGET_DIR;
    the two transpilers come from their pins. A size is not a fingerprint, but it
    separates two builds where a path does not, and the pinned pair carry a real
    fingerprint in their own trees.
    """
    out = []
    for name, p in (("codexrun", pathlib.Path(spec_run.BIN)),
                    ("bundle", pathlib.Path(spec_run.BUNDLE))):
        out.append((name, str(p), p.stat().st_size if p.is_file() else "ABSENT"))
    for name, script in (("codexzig", "build_codexzig.sh"), ("codexwasm", "build_codexwasm.sh")):
        r = subprocess.run([str(ROOT / "harness" / script)], capture_output=True, text=True)
        if r.returncode != 0:
            out.append((name, "REFUSED: " + r.stderr.strip().splitlines()[0], "ABSENT"))
            continue
        p = pathlib.Path(r.stdout.strip().splitlines()[-1])
        out.append((name, str(p), p.stat().st_size if p.is_file() else "ABSENT"))
    return out


def run_all(sandbox):
    """Every spec on all three arms. -> (rows, failures) and never raises.

    One spec's failure does not cost the evidence from the other fifty-three,
    which is the same argument harness/wasm_arm.py makes about a module that
    would not emit.
    """
    floor = spec_run.floors()
    specs = sorted((ROOT / "spec").glob("*Spec.codex"))
    missing = [s.stem for s in specs if s.stem not in floor]
    if missing:
        raise SystemExit(f"spec/floors.tsv has no line for: {', '.join(missing)}")
    rows, failures = [], 0
    for spec in specs:
        name = spec.stem
        t0 = time.time()
        out = spec_run.run(spec)
        why = spec_run.check(out, floor[name])
        arms = ["rust"] if why is None else []
        notes = []
        # A FILED GAP ON ONE ARM DOES NOT SKIP THE OTHER. This used to stop at
        # the first non-None verdict, so the three specs with issue-125 gaps were
        # never handed to the wasm arm at all -- and the run still printed
        # "rust, zig" beside them, which read as coverage rather than as the two
        # arms that happened to run. The wasm arm costs half a second.
        if why is None:
            for label, arm in (("zig", spec_run.zig_arm), ("wasm", spec_run.wasm_arm)):
                v = arm(name, name.lower(), out, sandbox, spec)
                if v is None:
                    arms.append(label)
                elif v.startswith(spec_run.KNOWN):
                    arms.append(label + " (gap)")
                    notes.append(v[len(spec_run.KNOWN):])
                else:
                    notes.append(f"{label}: " + v.splitlines()[0])
                    failures += 1
        else:
            notes.append(why.splitlines()[0])
            failures += 1
        known = bool(notes) and failures == 0
        arms = ", ".join(arms) if arms else "none"
        why = "; ".join(notes) if notes else None
        rows.append({
            "name": name,
            "graded": spec_run.graded(out),
            "floor": floor[name],
            "seconds": time.time() - t0,
            "arms": arms,
            "note": why or "",
            "ok": why is None or "(gap)" in arms,
        })
        mark = "ok" if why is None else ("gap" if "(gap)" in arms else "FAILED")
        print(f"  {name:20s} {mark:6s} {rows[-1]['graded']:5d} values  {rows[-1]['seconds']:6.2f}s  {arms}",
              flush=True)
    return rows, failures


def provenance(sandbox, rows, failures, elapsed):
    gaps = spec_run.arm_gaps()
    w = []
    w.append("safari-codex spec suite -- what produced the artifacts beside this file.")
    w.append("")
    w.append("EVERY AXIS THAT CAN CHANGE AN ANSWER IS NAMED HERE. Three arms over four")
    w.append("pinned trees is more moving parts than a green line can carry, and a run that")
    w.append("cannot say which it measured is not evidence about any of them. A tree marked")
    w.append("+DIRTY describes something that is not what ran.")
    w.append("")
    w.append(f"run            {datetime.datetime.now(datetime.timezone.utc).isoformat(timespec='seconds')}")
    w.append(f"sandbox        {sandbox}")
    w.append(f"elapsed        {elapsed:.1f}s")
    w.append("")
    w.append("THE PINS, from pins.tsv:")
    for name, path in pins():
        w.append(f"  {name:12s} {path}")
        w.append(f"  {'':12s} {git_at(path)}")
    w.append("")
    w.append("THE PORT ITSELF:")
    w.append(f"  {'safari-codex':12s} {ROOT}")
    w.append(f"  {'':12s} {git_at(ROOT)}")
    w.append("")
    w.append("THE BINARIES THE ARMS RAN:")
    for name, path, size in binaries():
        w.append(f"  {name:12s} {path}")
        w.append(f"  {'':12s} {size} bytes" if size != "ABSENT" else f"  {'':12s} ABSENT")
    w.append("")
    w.append("THE TOOLS AROUND THEM:")
    for name, v in tools():
        w.append(f"  {name:12s} {v}")
    w.append("")
    total = sum(r["graded"] for r in rows)
    floors = sum(r["floor"] for r in rows)
    w.append("THE RESULT:")
    w.append(f"  {len(rows)} specs, {total} graded values against floors summing to {floors}")
    three = sum(1 for r in rows if r["arms"].count(",") == 2)
    clean = sum(1 for r in rows if r["arms"] == "rust, zig, wasm")
    w.append(f"  {three} were checked on all three arms, {clean} of them with no gap on any")
    w.append(f"  {failures} failed")
    w.append("")
    w.append("KNOWN ARM GAPS -- filed upstream, reported every run, not fatal. A line in")
    w.append("spec/arm-gaps.tsv is a promise to remove it; when the issue closes the gate")
    w.append("goes green on its own, and if it does not we learn something.")
    for name, (issue, note) in sorted(gaps.items()):
        w.append(f"  {name:20s} issue {issue}: {note}")
    if not gaps:
        w.append("  (none)")
    w.append("")
    w.append("PER SPEC:")
    w.append(f"  {'spec':22s} {'values':>7} {'floor':>7} {'seconds':>8}  arms")
    for r in sorted(rows, key=lambda r: r["name"]):
        w.append(f"  {r['name']:22s} {r['graded']:7d} {r['floor']:7d} {r['seconds']:8.2f}  {r['arms']}"
                 + (f"   {r['note']}" if r["note"] else ""))
    return "\n".join(w) + "\n"


def sweep(keep):
    """Keep the newest `keep` sandboxes and delete the rest.

    Old runs are the only record of what an answer used to be, so this is opt-in
    and never automatic: a sandbox nobody deleted is a sandbox somebody may still
    be reading.
    """
    olds = sorted((p for p in RUNS.glob("spec-*") if p.is_dir()), reverse=True)
    for p in olds[keep:]:
        shutil.rmtree(p)
        print(f"  removed {p}")


def main():
    args = sys.argv[1:]
    out = None
    keep = None
    while args:
        a = args.pop(0)
        if a == "--out":
            out = pathlib.Path(args.pop(0)).expanduser()
        elif a == "--keep":
            keep = int(args.pop(0))
        else:
            raise SystemExit(__doc__.strip().splitlines()[2].strip())

    for what, p in (("codexrun", spec_run.BIN), ("bundle", spec_run.BUNDLE)):
        if not os.access(p, os.X_OK):
            raise SystemExit(f"no {what} at {p} -- build rust-codex-compiler, or set CODEXRUN/CODEXBUNDLE")

    if out is None:
        stamp = datetime.datetime.now().strftime("%Y%m%dT%H%M%S")
        out = RUNS / f"spec-{stamp}"
    out.mkdir(parents=True, exist_ok=True)
    print(f"sandbox {out}\n")

    t0 = time.time()
    rows, failures = run_all(out)
    elapsed = time.time() - t0

    (out / "PROVENANCE").write_text(provenance(out, rows, failures, elapsed))
    print(f"\n{len(rows)} specs, {sum(r['graded'] for r in rows)} graded values, {elapsed:.1f}s")
    print(f"PROVENANCE  {out / 'PROVENANCE'}")
    if keep is not None:
        sweep(keep)
    if failures:
        print("\nSPECS FAILED")
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())

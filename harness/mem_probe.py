#!/usr/bin/env python3
"""WHERE THE TRANSPILER'S MEMORY GOES, phase by phase, on both native arms.

    ./harness/mem_probe.py world                 # one unit, both arms
    ./harness/mem_probe.py pond world cat_draw   # several
    ./harness/mem_probe.py --build               # rebuild the probes and stop

WASM_FINDINGS 6 measured the GAP -- codexwasm costs 1.26x codexzig on the same
input -- and could not say where either number comes from. This says where. The
bump heap never reclaims (`PORTING_NOTES` C6), so the frontier `__heap-save`
returns IS the running total of everything allocated since the process started:
read it between two phases and the difference is what that phase allocated, with
no sampling and no profiler.

THE TWO HARNESSES ARE THE SAME PROGRAM WITH ONE LINE DIFFERENT -- ours ends
`emit-wasm-chapter-stream ...` where the ladder's ends
`print-text (emit-zig-chapter ...)` -- so instrumenting both the same way turns
the 1.26x into a per-phase table where at most one row should differ. This
script writes the marks in mechanically rather than by hand for exactly that
reason: a hand-instrumented pair could differ somewhere else and nobody would
see it.

C17 is the reason to look at all. It found the spikes allocating a QUADRATIC
amount of text and blaming the allocator for a week -- "an allocator that never
frees turns an algorithmic mistake into an out-of-memory, which makes it very
good at hiding one behind itself." A 696 KB unit costing 2.9 GB is that shape
until measurement says otherwise.
"""
import os
import pathlib
import re
import subprocess
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
import pins  # noqa: F401  -- SETS CODEX_ROOT

ROOT = pathlib.Path(__file__).resolve().parent.parent
OUT = ROOT / "build" / "memprobe"
LADDER = pathlib.Path(os.environ.get(
    "SAFARI_LADDER", pathlib.Path.home() / "showell_repos" / "codex-zig-ladder"))
ZIG = os.environ.get("ZIG", str(pathlib.Path.home() / "zig-0.16.0/zig"))
PWSH = str(pathlib.Path.home() / ".local/pwsh/pwsh")

# The two arms, and everything that differs between them. `harness` is the
# chapter the bundler is pointed at; `plug` is the emitter chapter that goes in
# beside the front end. Both bundles carry IRTextParser because both harnesses
# take the IR text wire round trip -- that is load-bearing, not an optimisation
# (CodexWasmHarness's own prose says why).
ARMS = {
    "zig": dict(harness=LADDER / "ast" / "CodexZigHarness.codex",
                plug="codex/plugs/zig/ZigEmitter.codex", prefix="czg"),
    "wasm": dict(harness=ROOT / "harness" / "CodexWasmHarness.codex",
                 plug="codex/plugs/wasm/WasmEmitter.codex", prefix="cwm"),
}


# ---------------------------------------------------------------- instrumenting

def instrument(text):
    """Insert `in let hp-N = __heap-save` after every phase of the driver.

    A `let` in this driver is one line, EXCEPT the IRTextMeta literal, which is
    seven; so the parser tracks bracket depth and marks a binding only once it
    closes. Marking inside the literal would not compile, and skipping it by
    line number would break the next time the record gains a field.
    """
    lines = text.splitlines()
    start = next(i for i, l in enumerate(lines) if l.startswith("  opening :"))
    out, marks, depth, pending = lines[:start], [], 0, None
    for line in lines[start:]:
        out.append(line)
        if pending is None:
            m = re.match(r"^(\s+)(?:in )?let ([a-z][a-z0-9-]*) = ", line)
            if not m:
                continue
            pending = m
        depth += line.count("{") + line.count("[") - line.count("}") - line.count("]")
        if depth > 0:
            continue
        indent, name = pending.group(1), pending.group(2)
        # The deck prologue is the baseline, not a phase: mark after it and not
        # inside it, so hp-0 is where the front end actually starts.
        if name not in ("mountain-base", "deck-base", "deck-set"):
            marks.append(name)
            out.append(f"{indent}in let hp-{len(marks)} = __heap-save")
        pending = None
    text = "\n".join(out) + "\n"

    report = " & ".join(f'prof-line "{n}" hp-{i + 1}' for i, n in enumerate(marks))
    # The report goes out on STDOUT (write-binary), because the emitted program
    # is on stderr on both arms -- see PORTING_NOTES C1/C2. The second call sits
    # AFTER the emit so the last row measures emission itself; on the wasm arm
    # that row is a floor rather than a peak, because emit-wasm-chapter-stream
    # restores the heap between definitions and the frontier comes back down.
    body = re.search(r"(    in act\n)(.*?)(\n    end\n  end)", text, re.S)
    inner = body.group(2).splitlines()
    text = text[:body.start(2)] + "\n".join(
        [inner[0], f"      write-binary ({report})"] + inner[1:]
        + ['      write-binary (prof-line "EMIT" __heap-save)']) + text[body.end(2):]

    return text + '''
Section: Profile

 Written by harness/mem_probe.py. `__heap-save` is the bump frontier and the
 bump heap never reclaims, so the value between two phases is the running
 total of everything allocated so far.

 The newline is a `list-push ... 10` and not a literal, and that is not a
 style choice: A TEXT LITERAL OPENED AT THE END OF A LINE LEXES AS AN EMPTY
 ONE, silently. `cwm-halted` two sections up is written that way and does not
 emit the newline it appears to. FINDINGS has it.

  prof-line : Text, Integer -> List Integer
  prof-line (n) (v) = list-push (text-to-utf8-bytes ("PROF " & n & " " & show v)) 10
'''


# The frontier the phase marks read is what SURVIVES a phase, and on the wasm
# arm that is not what the process pays: emit-wasm-chapter-stream brackets every
# definition in __heap-save/__heap-restore, so its cost is the MAX over
# definitions and the frontier comes back down before the next mark. Peak RSS
# sees it and the marks do not -- which is exactly the 63 MB the world table
# could not account for.
#
# So the prelude gets a high-water cursor. Three substitutions, each required to
# match EXACTLY ONCE, the same rule harness/wasmify.py uses on the same file: a
# prelude that drifts fails here instead of silently measuring nothing.
HIGH_WATER = [
    ("var cx_hp: i64 = 6291456;",
     "var cx_hp: i64 = 6291456;\nvar cx_hw: i64 = 6291456;"),
    ("    cx_hp = @intCast(base + len);\n    cx_deck_armed = false;",
     "    cx_hp = @intCast(base + len);\n    if (cx_hp > cx_hw) cx_hw = cx_hp;\n    cx_deck_armed = false;"),
    ("fn cx_heap_restore(h: i64) i64 {\n    cx_hp = h;",
     "fn cx_heap_restore(h: i64) i64 {\n    cx_hw_report(h);\n    cx_hp = h;"),
]

# Written on the same fd and in the same shape as cx_deck_report, so the two
# traces read as one stream. `hw - h` is what the bracket about to close cost
# transiently -- the number a per-definition emitter is judged on.
HW_REPORT = """
fn cx_hw_report(h: i64) void {
    if (@import("builtin").os.tag != .linux) return;
    if (cx_hw <= h) { cx_hw = h; return; }
    var cx_b: [96]u8 = undefined;
    const cx_s = std.fmt.bufPrint(&cx_b, "CX-HW {d} {d}\\n", .{ cx_hw - h, h }) catch return;
    _ = std.os.linux.write(1, cx_s.ptr, cx_s.len);
    cx_hw = h;
}
"""


def high_water(text):
    for old, new in HIGH_WATER:
        if text.count(old) != 1:
            raise SystemExit(f"prelude drifted: {text.count(old)} matches for {old[:40]!r}")
        text = text.replace(old, new)
    return text + HW_REPORT


# ------------------------------------------------------------------- building

def build(arm, force=False):
    """Bundle, transpile, compile. Same three host-side steps as
    harness/build_codexwasm.sh, which is where the pwsh incantation comes from
    -- `-Command` and not `-File`, because -MoreChapters is a [string[]]."""
    spec = ARMS[arm]
    OUT.mkdir(parents=True, exist_ok=True)
    chapter = OUT / f"prof_{arm}.codex"
    chapter.write_text(instrument(spec["harness"].read_text()))

    subject = OUT / f"prof_{arm}-subject.codex"
    back = "../../safari-codex"
    rel = f"{back}/build/memprobe"
    subprocess.run([PWSH, "-NoProfile", "-Command",
                    f"& '{LADDER}/ast/bundle_codexir.ps1' "
                    f"-Harness '{rel}/{chapter.name}' -OutName '{rel}/{subject.name}' "
                    f"-PlugName 'prof_{arm}-subject' "
                    f"-MoreChapters @('codex/plugs/common/IRTextParser.codex','{spec['plug']}')"],
                   check=True, capture_output=True, text=True)

    exe = OUT / f"prof_{arm}"
    fp = subprocess.run(["sha256sum", str(subject)], capture_output=True, text=True,
                        check=True).stdout.split()[0]
    stamp = OUT / f"prof_{arm}.fp"
    if not force and exe.is_file() and stamp.is_file() and stamp.read_text() == fp:
        print(f"  {arm}: probe is current ({fp[:12]})", file=sys.stderr)
        return exe

    codexzig = subprocess.run([str(ROOT / "harness/build_codexzig.sh")],
                              capture_output=True, text=True, check=True).stdout.strip()
    zsrc = OUT / f"prof_{arm}.zig"
    print(f"  {arm}: transpiling {subject.stat().st_size} bytes...", file=sys.stderr)
    with open(subject) as fi, open(zsrc, "w") as fe, open(OUT / f"prof_{arm}.diag", "w") as fo:
        subprocess.run([codexzig], stdin=fi, stderr=fe, stdout=fo)
    if "// THE PRELUDE" not in zsrc.read_text():
        raise SystemExit(f"{arm}: codexzig emitted no program\n"
                         + "\n".join(zsrc.read_text().splitlines()[:3]))
    zsrc.write_text(high_water(zsrc.read_text()))
    print(f"  {arm}: building {zsrc.stat().st_size} bytes of zig...", file=sys.stderr)
    subprocess.run([ZIG, "build-exe", zsrc.name, f"-femit-bin={exe.name}"],
                   cwd=OUT, check=True)
    stamp.write_text(fp)
    return exe


# -------------------------------------------------------------------- running

def run(exe, unit, tag):
    t = OUT / f"{tag}.time"
    with open(unit) as fi, open(OUT / f"{tag}.prog", "w") as fe:
        r = subprocess.run(["/usr/bin/time", "-f", "%M %e", "-o", str(t), str(exe)],
                           stdin=fi, stdout=subprocess.PIPE, stderr=fe, text=True)
    # `/usr/bin/time` prefixes "Command exited with non-zero status N" when the
    # child dies, and the transpiler dying on a big unit is the case this exists
    # to measure -- so read the LAST line, not the first.
    peak, secs = t.read_text().strip().splitlines()[-1].split()[:2]
    rows = [(l.split()[1], int(l.split()[2])) for l in r.stdout.splitlines()
            if l.startswith("PROF ")]
    return int(peak), float(secs), rows, r.returncode


def mb(n):
    return f"{n / 1048576:,.0f}"


def report(unit, results):
    # A row can be MISSING rather than zero: a run that dies mid-emit prints the
    # marks it reached and no more, and that truncation is data -- the phase it
    # stops at is the phase that killed it.
    names, seen = [], set()
    for arm in ("zig", "wasm"):
        for n, _ in results.get(arm, (0, 0, [], 0))[2]:
            if n not in seen:
                seen.add(n)
                names.append(n)
    src = (ROOT / "build" / f"{unit}-unit.codex").stat().st_size
    print(f"\n{unit}-unit.codex: {src:,} bytes")
    print(f"  {'phase':<24} {'zig MB':>9} {'wasm MB':>9} {'delta':>9}")
    # deck-adv is the 512 MB the harness reserves with __heap-advance. It is a
    # GAP in the frontier, not memory: nothing touches it, so it never becomes
    # resident and it is not part of any peak RSS below. Everything else is real.
    prev = {a: 0 for a in results}
    for i, name in enumerate(names):
        cells = []
        for arm in ("zig", "wasm"):
            rows = dict(results.get(arm, (0, 0, [], 0))[2])
            v = rows.get(name, prev[arm])
            cells.append(v - prev[arm])
            prev[arm] = v
        if max(cells) < 1048576 // 2 and name not in ("EMIT",):
            continue
        print(f"  {name:<24} {mb(cells[0]):>9} {mb(cells[1]):>9} {mb(cells[1] - cells[0]):>9}")
    for arm in ("zig", "wasm"):
        if arm in results:
            peak, secs, rows, rc = results[arm]
            print(f"  {arm:<24} peak RSS {peak / 1024:,.0f} MB   {secs:.1f}s"
                  + ("" if rc == 0 else f"   EXIT {rc}"))


def main():
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    force = "--force" in sys.argv
    exes = {arm: build(arm, force) for arm in ARMS}
    if "--build" in sys.argv:
        return 0
    for unit in args or ["world"]:
        u = ROOT / "build" / f"{unit}-unit.codex"
        if not u.is_file():
            raise SystemExit(f"no {u} -- ./harness/run.sh {unit} builds it")
        report(unit, {arm: run(exes[arm], u, f"{unit}.{arm}") for arm in ARMS})
    return 0


if __name__ == "__main__":
    sys.exit(main())

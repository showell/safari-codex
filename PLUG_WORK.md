# Plug work: closing the real conversion and bitcast holes

Where the emitter work lives, what was branched, and where things run. Started
2026-08-29. Companion to `PORTING_NOTES.txt` item A1, which is the finding this
closes.

**Why this file exists:** this project now touches four trees, three of them
outside `safari-codex`, and one of them (`NewRepository`) is shared with 11 live
worktrees. A note saying which branch is where is cheaper than reconstructing it.

## Trees and branches

| tree | branch | base | who owns it |
|---|---|---|---|
| `~/showell_repos/safari-codex` | `master` | — | this project; pushed to `showell/safari-codex` |
| `~/showell_repos/cobblestone-realconv` | `zig-plug-real-int-conversions` | `16751b22` | created 2026-08-29; superseded, see below |
| `~/showell_repos/cobblestone-realbits` | `zig-plug-real-bitcast` | `13edc9a6` | **created 2026-08-30; what safari builds against now** |
| `~/showell_repos/codex-zig-transpiler` | `real-int-conversions` | `4ac5982` (master) | **created 2026-08-29 for this work**; builds codexzig |
| `~/showell_repos/NewRepository` | `u53-rebank` | — | **SHARED, READ-ONLY.** 11 live worktrees hang off it |

`cobblestone-realconv` is a `git worktree` of `NewRepository`, so it shares that
clone's object store and its branch list. It is our own copy to edit; the shared
tree is never edited.

## Why the base is 16751b22 and not something newer

`16751b22` is the head of `zig-tree-shaking`, and it is **the exact commit the
codexzig now grading the port was built from** --
`codex-zig-transpiler/generated/PROVENANCE` names it. Branching there makes the
emitter change the SINGLE variable between the current codexzig and the new one,
so the port's before/after is a clean comparison rather than a two-variable one.

It carries the whole prelude stack, which is the other requirement:

    7638048b  emit the prelude last, behind a banner
    a7f20525  Foreword chapter Shake: reachability over named parts
    297649f2  the prelude becomes selectable parts, with the shake still OFF
    4020427f  cx_heap_base, cx_utf8_to_cce and cx_vtag get parts of their own
    74b5de94  the shake goes ON -- the prelude becomes a function of the program
    2a45e0f9  reserve the prelude's 74 function names
    16751b22  plugs-backlog: row 2.02, the shaken prelude

**Not `typedef-prune-on-shaker` (`c8e1cda7`)**, which is two commits ahead: it
adds compiler-side typedef pruning, which is a different concern and **not ready
yet (Steve, 2026-08-29)**. Building on it would couple this change to it.

**Not `prune-unreachable-typedefs` (`3d331701`)**, which has diverged from this
base entirely.

## Where things run

Everything is native on this box. **QEMU is allowed again as of 2026-08-29**
(Steve: the box is ours) -- the standing no-QEMU rule for this project was
written when it was shared.

- **The port's loop** (`./harness/run.sh`): host only, seconds, no guest.
- **Building codexzig** (`codex-zig-transpiler/build.py`): stages 2, 4 and 5 are
  QEMU guests, ~7 min cold. Stage 4 peaks at 2454 MB against a 3072 MB cap and
  is the binding one. `build.py` takes no lock and assumes it has the box.
- **After the first build, iteration is guest-free.** Stages 3 -> 7 -> 6 (bundle,
  native self-transpile, `zig build-exe`) are all host, which is how a further
  emitter edit gets a new binary without QEMU. That is the point of building once.

`COBBLESTONE_ROOT` must point at `cobblestone-realconv` for this work. It is
deliberately NOT `CODEX_ROOT`, which belongs to the ladder and moves its HEAD
around; `cobblestone-pin` is the transpiler's stable checkout and is **left
alone** -- it is what the current, known-good codexzig was built from.

## The emitter change

Four sites in `codex/plugs/zig/ZigEmitter.codex`, the crib being
`bits-to-real-approx`, its direct sibling:

1. `zig-prelude-decls` (~line 99) -- reserve the new prelude names.
2. `zig-builtin-emitters` (~line 1080) -- one row each. The table is
   `sort-zig-builtins`-ed at runtime, so insertion position in the literal is free.
3. `zig-p-*` fragment lists (~line 3888) -- the prelude parts.
4. `zig-prelude-parts` (~line 4146) -- registration; this list's order is
   emission order.

Semantics, from bare metal (`compiler/Emit/X86_64Builtins.codex:1663-1679`),
which is the oracle -- not the C# plug:

- `real-from-int : Integer -> Real` is `cvtsi2sd`. `@floatFromInt` matches.
- `real-to-int : Real -> Integer` is `cvttsd2si`: truncate toward zero, and
  x86's "integer indefinite" (INT64_MIN) for NaN, an infinity, or anything whose
  truncation will not fit. Zig's `@intFromFloat` truncates the same way but is
  **undefined out of range**, so the guards are load-bearing, not decoration.

Types are from `compiler/Types/Builtins.codex:281-282`, which is authoritative.

**Scope: the f64 pair only.** The `real-approx-*` family (f32) is deliberately
left alone -- filling those would make the house-wide f32-computed-as-f64
collapse observable, which is a separate and much larger conversation
(`NOTES.txt` section 6). This change cannot make that worse and does not touch it.

## Snag: shake_parts.py cannot run at this base

`ZigEmitter.codex` says of the parts table: *"GENERATED by the ladder's
shake_parts.py and gated part by part. Do not hand-edit; edit the prelude source
and regenerate."*

**That instruction cannot be followed at `16751b22`, and the reason is
structural.** `shake_parts.py` reads its input with `read_chunks()`, which
requires a `zig-prelude : Text` built from quoted `& "..."` chunks, and `main()`
calls it unconditionally (line 685) before dispatching any mode -- so
`--check-corpus`, `--against` and `--prove-gate` are as unusable as `--splice`.
After `297649f2`, `zig-prelude` is `shake-text zig-prelude-parts ...` and the
chunk list is gone. The generator is a one-way migration tool that has already
done its job; the parts table is now the only source there is.

The precedent for adding parts post-restructure, `4020427f`, took the chunk list
from git at a pre-restructure rev and re-spliced -- which is not available here
without discarding everything ZigEmitter gained after that rev.

### Resolved: the banner is an artifact of the migration, and hand-editing is the way forward

Steve's read, 2026-08-29, confirmed by reading the shake commits.

The banner's gate is stated in `297649f2`: *"shake-frag-text of each list
rebuilds its ORIGINAL CHUNK byte for byte, 93/93, 294 ShakeUse edges, zero
identity failures. Do not hand-edit the table."* That is a comparison against the
pre-restructure chunk list -- a ONE-TIME migration check, whose whole purpose was
proving the cut lossless. **A part added afterwards has no original chunk, so the
gate the banner protects does not exist for it.** The instruction was true for the
table as migrated and says nothing about growing it.

The forward process is already written down, in `build/check-zig-prelude-surface.ps1`:

    The whole comes from the emitter's own `zig-prelude-parts` table, so the
    surface is derived from EVERY part rather than from whichever ones one
    subject happened to reach. [...]
    Not wired into any gate. Run it after changing zig-prelude.

That script reconstructs the whole from the PARTS TABLE, not from the chunk list,
so unlike `shake_parts.py` it still runs after the restructure. It checks the two
things a hand-written part can get wrong:

  - every name in the emitted prelude surface is covered by `zig-prelude-decls`
    (the reserved-list half -- this is finding 67's gate);
  - every emitted prelude is a SUB-SELECTION of the known whole in table order,
    so a part that reordered, duplicated, truncated or invented anything fails.

And it demonstrably CAN fail: `2a45e0f9` ran it against the old list and got
"74 missing, every one named, exit 1".

**So: hand-edit the four sites in the new format, then run
`check-zig-prelude-surface.ps1`.** The banner should be reworded in the same
commit -- leaving "do not hand-edit" over a table that is now the only source is
what sent this session looking for a generator that cannot run.

Two further things the shake commits settle, both in our favour:

  - `e74cd110` -- the crude root scan cannot be fooled, structurally: a Codex text
    literal is emitted as CCE hex escapes, so a program's own strings cannot
    contain a prelude name in a form the scan can see. Our `cx_real_to_int` will
    be found in the emitted program exactly when the builtin emitter writes that
    call text, and never otherwise.
  - `74b5de94` -- `zig-prelude` stays defined and unreferenced ON PURPOSE as the
    all-roots whole. A new part must be reachable from it, which registration in
    `zig-prelude-parts` achieves for free.

## What the change is, and what verified it

Five edits to `ZigEmitter.codex`: the two reserved names, two builtin table rows,
two `zig-p-` fragment lists, two `ShakePart` rows, and a reword of the stale
banner. 96 parts -> 98.

### The one real defect the checks caught, and it was mine

The first draft wrote `fn cx_real_to_int(x: f64)`. **`x` is not in
`zig-prelude-decls`, and no other prelude function uses a bare `x` parameter** --
so that draft widened the plug's reserved surface by a name no program can be
expected to avoid. It is finding 67's exact shape from the other side: a Codex
program with a top-level `x` emits `const x` at container scope, and a parameter
`x` inside a prelude function shadows it, which zig forbids outright.

Renamed to `v`, which is ALREADY reserved and already used as a parameter
elsewhere, so the change adds no new surface at all. Reserving `x` instead would
have been the wrong fix -- it steals a very plausible name from every program the
plug will ever compile, to save renaming one parameter.

Measured, mine against an unmodified control:

    parts    96 -> 98        declarations 96 -> 98, every one named by a part
    surface  129 -> 131      the two new names, both reserved
    MISSING  none, both trees

### The gates, and which of them actually ran

`build/check-zig-prelude-surface.ps1` **cannot run on this box**, and that is
environmental rather than ours: it calls `codex/plugs/zig/run.ps1` to emit its
subjects, that IR compile fails, and it fails IDENTICALLY on the unmodified
`cobblestone-pin` -- same subject, same line, and `build-output/` is never even
created. Established by A/B rather than assumed.

Its `Get-ShakeParts` did parse our table before dying, which is worth something.
The two halves that need no subject emit were ported to Python from the script's
own logic and run against both trees -- see the table above. The sub-selection
walk was mirrored too, including the detail that made a naive port wrong: the
start is the EARLIEST occurrence of any part text after the banner, because the
banner is a multi-line block and splitting on its first line leaves the rest of
the comment in the way. `$surface.Remove('_')` matters too; zig's discard is not
an identifier and shows up as missing on both trees without it.

The corpus-edge property -- the one `--check-corpus` exists for, and the only
gate that ever sees an EDGE -- was verified directly instead:

    RealConv.codex  (uses the conversions)  cx_real_to_int 1  cx_real_from_int 1
    NoConv.codex    (reaches neither)       cx_real_to_int 0  cx_real_from_int 0

### Against the hardware, not against the manual

The guards were checked against the instructions bare metal actually emits, via
inline asm, over 31 cases: `cvttsd2si` and `cvtsi2sd`. **0 disagreements**,
including NaN, both infinities, +/-1e300, exactly +/-2^63, the largest f64 below
2^63, the next representable below -2^63, and the 2^53+1 rounding region. That is
the oracle this project uses everywhere else, and it is cheap here.

### End to end

    round-trip 42        42        trunc 2.5    2        scaled 3.14159   3141
    round-trip -7        -7        trunc -2.5  -2        scaled -2.71828 -2718

`scaled` is the one that matters: **`PORTING_NOTES` A2 said a transpiled program
"cannot report a computed Real AT ALL"**, and that is now false. It also closes
the diagnosis cost recorded there -- a red coordinate no longer needs
re-simulating in a separate zig program to find out what it was.

The port's own sweep is GREEN through the new binary: 1702 values, unchanged.

## Lesson: script the build path, do not hand-run it

Steve, 2026-08-29, and it had already cost something by the time he said it.

A hand-run bootstrap used `zig build-exe -O ReleaseFast`. `build.py` passes **no
`-O` at all** -- zig's default is Debug. That produced a 15.9 MB binary against
build.py's 27.8 MB and a transpile six times faster, two builds that are simply
not comparable, and it was noticed only because the timings looked wrong. The
emitted bytes happened to be fine; nothing about the mistake guaranteed that.

`bootstrap_native.py` now scripts that path in the transpiler repo, and it
IMPORTS `build.py`'s `bundle`, `build_exe` and `self_transpile` rather than
restating them, so the flags cannot drift again. `self_transpile` grew an
optional `binary` argument for it -- one implementation, two callers.

**It iterates to a fixed point rather than demanding agreement in one step**, and
that is not defensive padding: when a change alters how the emitter emits, the
candidate was produced by the OLD emitter and the confirmation by the NEW one, so
they differ legitimately on the first round. The `x`-to-`v` rename did exactly
that, differing in precisely the ten lines it touched -- which briefly looked
like a fixed-point failure and was not.

**It does not check the fixed point and says so.** Stage 8 needs the QEMU leg
because its value is that pass 1 comes from an INDEPENDENT implementation -- the
emitter compiled to a bootable kernel -- not from the binary under test. Nothing
self-hosted can supply that. `./build.py --force` before anything ships.


## 2026-08-30: real-to-bits, and a change of lineage

**The conversion work went upstream without us, and we followed it rather than
our own branch.** Another Claude, working from `codex-zig-ladder`, rebuilt the
`real-to-int` / `real-from-int` pair as `zig-plug-real-conversions` and filed it
as **Cobblestone PR 100**. That branch is a SIBLING of ours, not a descendant:
same base (`58b08c38`, Update 53), the same two logical commits, different SHAs
and tidier messages.

So `zig-plug-real-bitcast` is branched from **`13edc9a6`, the PR's head**, not
from our own `da6526f4`. A stack should sit on what the maintainer is actually
looking at.

**Swapping lineage changed nothing, and that was measured rather than assumed.**
`build/safari.zig` is BYTE-IDENTICAL across the swap, and all 17 checks are green
on the rebuilt `codexzig`. That is the evidence for "substantively the same"; the
two branches could have differed in emission and the only way to know was to look.

**What the new rows are:** `real-to-bits` and `bits-to-real`, the f64 bitcast
pair. Bare metal emits `mov-rr` for both -- a register move, which is to say
nothing, because it holds a Real f64 as its own bits in a general register. Zig
separates the types, so the identity is `@bitCast`. No guards: total both ways.
Register entry `plugs-backlog 2.07`; test `codex/test/ops/real-bitcast-f64`.

**The other thirteen members of the family are declined on purpose**, and the
reason is one fact upstream of all of them: `ZigEmitter.codex:342` and `:373` map
`RealTy (w) (m)` to `f64`, discarding BOTH the width and the mode. So an f32 Real
is an f64 here and a trapping Real does not trap. `real-approx-to-bits` would have
to narrow an f64 bare metal never held; `to-real-trapping` would hand back a value
the program is entitled to believe traps. Filling them replaces an honest refusal
with a plausible wrong number. 2.07 lists all thirteen and puts the representation
question to the maintainer.

**`codexzig` was rebuilt from this worktree** -- `./build.py --force` with
`COBBLESTONE_ROOT=~/showell_repos/cobblestone-realbits`, 449s, three guests. The
fixed point HOLDS byte-identical and `arith` matches all nine lines.
`generated/PROVENANCE` names `cobblestone-realbits 2f7e7375`.

**And safari now DEPENDS on the new rows**, which is worth stating because it
means the checks no longer build on an older `codexzig`. `judge/Grade.codex` uses
`real-to-bits` to reject a non-finite value -- see `PORTING_NOTES` D12, the NaN
that had been passing every Real gate in the project.


## Parked 2026-08-30

`zig-plug-real-bitcast` in `~/showell_repos/cobblestone-realbits` is COMPLETE and
unsent: two emitter rows, four touch points each, `plugs-backlog 2.07`, and
`codex/test/ops/real-bitcast-f64` which passes on the zig arm at all twelve lines.
The commit message carries the evidence. It wants a polish pass and a PR.

**`codexzig` is built from it** — `generated/PROVENANCE` names
`cobblestone-realbits 2f7e7375` — and safari-codex now DEPENDS on the new rows:
`judge/Grade.codex` calls `real-to-bits` to reject a non-finite value, and
`poc/SpikePrint.codex` prints coordinates as bit patterns so the third arm can
compare at the ulp. The checks will not build on an older `codexzig`.

**The thirteen remaining real-family rows are declined in writing**, not forgotten;
2.07 lists them and asks the maintainer the one question they all turn on. Anyone
"finishing the family" without an answer to it would be turning honest refusals
into plausible wrong numbers.

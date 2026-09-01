# What this project is built against, and how it is pinned

This port has four dependencies outside its own repository, and until 2026-08-30
every one of them was a path into a checkout somebody else was working in. That
is not a dependency you can build against; it is one you can only build beside.
A green sweep meant "green against whatever those trees held this afternoon",
and any of them could move between two runs of the same command.

**Two rules now.** A tree we compile is a WORKTREE ON OUR OWN BRANCH, so work
next door cannot rebuild it under us. A tree we merely read from is COPIED IN,
with the commit it came from written down and a script to re-copy.

| what | where | how |
|---|---|---|
| the language | `~/showell_repos/cobblestone-safari` `safari` | worktree of `NewRepository` |
| the transpiler | `~/showell_repos/codexzig-safari` `safari` | worktree of `codex-zig-transpiler` |
| the game | `HISTORICAL_WASM_ROOT/` | copied, `./harness/refresh_game.sh` |
| the chapter walk | `harness/cite_resolve.py` | copied, one local change |
| the guest driver | still imported from the ladder | **and it should stay that way** — see below |

## The language: `cobblestone-safari`, branch `safari`

Cobblestone is the Codex language: the foreword every chapter cites, the seed
the guest arms boot, and the plugs both transpilers are made of. `CODEX_ROOT`
points here, and so does the `COBBLESTONE_ROOT` that `harness/wasm_plug_build.py`
bundles the wasm plug from.

    base      58b08c38  Update 53
    + PR 100  real-to-int / real-from-int, and real-to-bits / bits-to-real in
              the ZIG plug -- judge/Grade.codex calls real-to-bits to reject a
              non-finite value, so the checks do not build without them
              (37d7eed7, 13edc9a6, 2f7e7375)
    + ours    e8486215  wasm: Real is an f64, not an i64 with f64 bits in it
              b5b1bb74  wasm: a ^ b was emitting a * b; INT64_MIN garbage
              121b61fb  wasm: ask the IR which imports a module needs
              2aff6e4d  wasm: list literals in halves -- the 4 GiB ceiling
              3c13334d  zig: join a list literal's elements once
              1893cf1e  zig: emit a chapter one definition at a time
              ab4612aa  wasm: a branch's GUARD is part of the branch
              2660d3af  zig: size the prelude mask split to the table
              e6f09556  wasm: neither env import is reachable
              2a53929f  wasm: a scrutinee local per guard-nesting depth
              15ef1862  the mask ceiling is a @compileError, not a hope
    + 08-31   cac5851b  wasm: the emitted runtime made 2.9M host calls, 56k grows
              fa6b0f5d  wasm: assert the two runtime properties the e2e bed misses
              c36cf69b  wasm: the receiver's TYPE is the authority for a field
                        slot, not the IR text wire
              7ee23eb9  wasm: a chapter can say what it exports (finding 5)
              4e141340  wasm: the two text readers grow instead of truncating
              0faaf191  wasm: two more quadratic joins in emission, 608 MB
              8460e035  wasm: a Boolean literal pattern is 1 or 0, not the word
              02186d04  wasm: an unknown name refuses instead of pretending
              9632bb87  wasm: a guard's scrutinee bump leaked into its siblings
    head      9632bb870cd684efa89b497b563a19a39e939ae4

WASM_FINDINGS.md maps those to the eleven findings and says which are fixed.
This block was left at `e8486215` for ten commits, which is the whole failure
mode a pin exists to prevent: a stale pin is not a weaker claim than no pin, it
is a false one.

**The 2026-08-31 rows came from a different project and are the reason to read
the next paragraph.** They were written in `codex-wasm-transpiler`, where the
wasm plug is made to compile the compiler itself.

**THE SHAs ABOVE ARE NOT THE PULL REQUEST'S SHAs, and that is worth a paragraph
rather than a footnote.** The same nine changes exist on two branches with two
bases, so neither sha set is wrong and neither is interchangeable:

    wasm-slot-from-type        9632bb87   on 15ef1862, this integration branch
                                          -- THIS is what the arms below ran
    wasm-plug-selfhost-batch   ccfde8d7   on upstream master 58b08c38, and it
                                          carries PR 111's commits beneath it
                                          -- THIS is Cobblestone PR 112

A commit-id comparison between them says nothing, so the question was settled on
CONTENT: `codex/plugs/wasm/WasmEmitter.codex` hashes `feb09250410c13d2` on both,
and so do `check-emitted-runtime.ps1` and `wasm-e2e.ps1`. **The emitter this port
verified is byte-for-byte the emitter PR 112 proposes.** The two branches differ
elsewhere — the PR carries three `codex/plugs/wasm/test/*-rt.codex` fixtures and
PR 111's zig-plug rows that this integration branch reaches by another route —
but nothing in that difference is emitter code.

`safari` and `wasm-slot-from-type` now point at the same commit because this was
a fast-forward. They are still different branches and will diverge the next time
either one moves; the table at the top of this file names `safari` as the pin. This port did not ask for them and does not test the thing they were
written for; what it does is put seventeen programs and ten differential probes
in front of them, against an oracle none of that work could see. That is the
whole value of re-pinning here, and it is why the pin moved the same day rather
than the next time somebody needed something.

**Only ONE ARM CAN MOVE, and the diff is what says so.** All 523 changed lines
are in `codex/plugs/wasm/`; the zig plug, the compiler and the seed are
untouched, so arms 1 through 3 run on exactly what they ran on before. That is
checked rather than argued: re-bundling `codexzig-subject.codex` at the new pin
gives the same 2,985,476 bytes, sha `45f66827…`, as the bundle the binary in
`codexzig-safari` was built from. If that comparison ever fails, the pin move is
not a one-arm change and `build_codexzig.sh` has a guest to boot.

**The branch is an INTEGRATION branch and not a pull request.** Each change here
also exists as a single-purpose branch off Update 53 for sending upstream
(`zig-plug-real-bitcast`, `wasm-plug-real-conversions`); this one is where they
are all true at once, which is what the port needs and what no PR should be.

## The transpiler: `codexzig-safari`, branch `safari`

`codexzig` is one program — Codex source in, Zig out — and it is what makes this
project move. `./harness/build_codexzig.sh` is the only door to it: it builds
the worktree with that project's own `build.py` and prints the binary's path.

**Its own machinery, not a shortcut.** `build.py` is nine stages, three of them
QEMU guests, and it ends by checking the fixed point: the emitter emits the same
bytes for its own source whether it runs on bare metal under QEMU or as the
native binary that run produced. Copying the generated zig here and running
`zig build-exe` on it would get a working binary while skipping the check that
says it is the right one.

**Debug, no `-O`**, which is what `build.py:build_exe` does and therefore the
mode the fixed point holds under. It is also what a correctness harness wants:
the safety checks are on and nothing here is a benchmark. A stray `-O` on one
side of a comparison is how this project once made two binaries that were not
comparable.

    checkout  316f9ce4  Rebuild on the fixed harness (2026-09-01)
    built     from cobblestone-safari 9632bb87, CLEAN -- no `+dirty`, which
              means the record names a commit the build was actually made from.
              generated/PROVENANCE in that worktree records the seed, the
              guests and what each one touched: 437s, fixed point HOLDS
              byte-identical, arith matches all nine lines.

**Why it was rebuilt, and the sentence this block used to end with was wrong.**
Earlier on 2026-08-31 this record read "still current at 9632bb87", on the
argument that the subject re-bundles to the same bytes at the new pin because
no chapter codexzig cites had moved. That was true of the PIN and it stopped
being true of the HARNESS: `source/CodexZigHarness.codex` changed that night
(the `-halted` literal, `b896ff5`), and the harness is bundled into the subject.

The old sentence went on to say `build_codexzig.sh` "agrees, and its agreement
is visible rather than silent". **It is silent, and that is finding 14.** The
script hashes `generated/codexzig.qemu.zig` and compares it to the fingerprint
of the binary built FROM that zig -- so it can tell whether the binary is
current with the generated zig, and cannot tell whether the generated zig is
current with the source. Measured: the source moved at 00:09 and the
fingerprint still matched a zig generated at 14:47. A warm 6.8s sweep is
therefore evidence that nothing needed rebuilding only if somebody already
knows the source did not move.

## The game: `HISTORICAL_WASM_ROOT/`

The Zig Safari screensaver, copied rather than symlinked into `angry-gopher`.
It is the ORACLE — every number this project claims is a number one of those
files produced — so it gets its own provenance beside it:
`HISTORICAL_WASM_ROOT/PROVENANCE.md`, and `./harness/refresh_game.sh` to move it.

## The chapter walk: `harness/cite_resolve.py`

The bundler's transitive `cites` walk, from the ladder. **One local change,
marked in the file**: the ladder finds the Cobblestone checkout through its own
`ladder_root` module, relative to where the ladder is; this project has no
ladder, so the copy reads `CODEX_ROOT` and refuses a value that does not hold
`codex/foreword` rather than letting a wrong checkout surface as a missing
chapter three steps later.

    repository  codex-zig-ladder
    commit      bda60ec9d343869eb98f545467eff9a60ffb6214
    copied      2026-08-30

`SAFARI_LADDER` makes `harness/bundle.py` import the ladder's live copy instead,
which is how the two are compared.

## The guest driver: borrowed on purpose

`harness/metal.py` (the third arm) and `harness/wasm_arm.py` (the fourth) import
`ring_compile` and `codex_vm` from the ladder, and **those two are the one thing
here that should not be pinned.**

`codex_vm.launch` is the single door that starts a QEMU guest on this host, and
it takes a host-wide `flock` on the way through — one guest at a time, a rule
written after two 3 GB guests on this box thrashed at 2% CPU each instead of
failing. The lock's path is derived from where that file sits. A worktree or a
copy would therefore take a DIFFERENT lock, and this project's arms would stop
excluding the ladder's own jobs. A second copy of the door is a second key to
the same room, and the room holds one machine.

The sweep touches neither module, so `./harness/run.sh` runs with no ladder
present at all. Only the two guest-booting arms need it.

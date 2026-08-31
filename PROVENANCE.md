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
    head      15ef1862532e0afdf5139bb1a67d0b34e4304381

WASM_FINDINGS.md maps those to the eleven findings and says which are fixed.
This block was left at `e8486215` for ten commits, which is the whole failure
mode a pin exists to prevent: a stale pin is not a weaker claim than no pin, it
is a false one.

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

    checkout  432b80af08942a7d0a8ccb4ecea2470779d3da97
              Rebuild on the guarded ceiling, with the guests this time
    built     from cobblestone-safari 15ef1862, CLEAN -- no `+dirty`, which
              means the record names a commit the build was actually made from.
              generated/PROVENANCE in that worktree records the seed, the
              guests and what each one touched: 462s, fixed point HOLDS
              byte-identical at 2,463,047 bytes, arith matches all nine lines.

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

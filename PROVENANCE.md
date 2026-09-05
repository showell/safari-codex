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
| the language | `~/showell_repos/cobblestone-safari` `safari-u56` | worktree of `NewRepository` |
| the zig transpiler | `~/showell_repos/codexzig-safari` `safari-u56` | worktree of `codex-zig-transpiler` |
| the wasm transpiler | `~/showell_repos/codexwasm-safari` `safari-u56` | worktree of `codex-wasm-transpiler` |
| the game | `HISTORICAL_WASM_ROOT/` | copied, `./harness/refresh_game.sh` |
| the chapter walk | `harness/cite_resolve.py` | copied, one local change |
| the guest driver | still imported from the ladder | **and it should stay that way** — see below |

## The language: `cobblestone-safari`, branch `safari-u56`

Cobblestone is the Codex language: the foreword every chapter cites, the seed
the guest arms boot, and the plugs both transpilers are made of. `CODEX_ROOT`
points here, and so does the `COBBLESTONE_ROOT` that `harness/wasm_plug_build.py`
bundles the wasm plug from.

    head      cc6eab7e  u56-candidate-saturday, 2026-09-05
              = Update 55, plus what is out to upstream as pull requests, plus
                what is going out. See that branch for the formula; it is the
                optimistic view of what Update 56 will contain, which is what
                this port wants to be grading against.

**Everything the old block itemised is gone because upstream took it.** This pin
spent five weeks at Update 53 plus twenty-three of our own plug commits, each
listed here with the finding it fixed. All twenty-three are in Update 55 now, so
the itemisation would be a list of things this pin no longer needs to carry. The
branch `safari` still points at the last of them, `9632bb87`, and
WASM_FINDINGS.md still maps them to the eleven findings.

**The lesson that block taught is the one to keep:** it was left at `e8486215`
for ten commits, and a stale pin is not a weaker claim than no pin -- it is a
false one. Same for the branch name in the table above: this tree was briefly a
detached HEAD, which has the property the rule is actually about (nothing next
door can move it) while making the table wrong. It is a branch again.

**MOVING THIS PIN IS NOT A ONE-ARM CHANGE ANY MORE, and the last move proves
it.** Going U53 -> u56 candidate broke fifteen specs to `graded 0 values` and
dropped `harness/bundle_gate.sh` to 6 identical of 40, because Update
55 took this port INTO the depot as `apps/safari/port` and registered `Safari`,
`Judge` and `Gold` under the names this project has always used. Both bundlers
now give `quires.tsv` the last word and both print `SHADOWED:` on every bundle
(rust-codex-compiler 6c18f73). Two gates caught it and neither was the one
looking for a bundler bug.

**ALL THREE PINS ARE AT THE u56 CANDIDATE NOW, and the two transpilers are
PULLED rather than built.** `codexzig-safari` and `codexwasm-safari` each carry a
binary produced by its own project's `build.py` -- nine stages ending in a fixed
point, the emitter emitting the same bytes for its own source on two roads --
which is a stronger claim about a binary than this project could make about one
it assembled. Each is a worktree on `safari-u56` so the active line cannot move
under us, and `harness/build_codex{zig,wasm}.sh` resolve them through pins.tsv,
check the fingerprint, and REFUSE rather than build.

This project used to build its own wasm transpiler and no longer does; see
`harness/build_codexwasm.sh` for the three reasons that stopped being right.

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

**Its `blitter.js` is an oracle too, and not only a zig one.** `port/Blit.codex`
is graded against numbers read out of it, and `web/blitter.js` — a fork of it
since the recipes moved — is graded against it by running both. A refresh
therefore moves the Blit gold as well as the zig golds.

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

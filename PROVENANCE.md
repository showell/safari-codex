# What this project is built against, and how it is pinned

This port depends on things outside its own repository, and until 2026-08-30
every one was a path into a checkout somebody else was working in. That is not a
dependency you can build against; it is one you can only build beside. A green
sweep meant "green against whatever those trees held this afternoon", and any of
them could move between two runs of the same command. The two transpilers are
now BORROWED as built binaries with their pin recorded; the language is DERIVED
from those binaries rather than pinned here at all.

| what | where | how |
|---|---|---|
| the zig transpiler | `~/showell_repos/codex-zig-transpiler` | that project's own tree; pulled, fingerprint-checked |
| the wasm transpiler | `~/showell_repos/codex-wasm-transpiler` | that project's own tree; pulled, fingerprint-checked |
| the language | DERIVED | `harness/cobblestone_pin.py`, from what the two transpilers were built against |
| the game | `HISTORICAL_WASM_ROOT/` | copied, `./harness/refresh_game.sh` |
| the chapter walk | `harness/cite_resolve.py` | copied, one local change |
| the guest driver | still imported from the ladder | **and it should stay that way** — see below |

## The language: DERIVED, not pinned

Cobblestone is the Codex language: the foreword every chapter cites, the seed
the guest arms boot, and the plugs both transpilers are made of. Bundling a spec
resolves its `Foreword` cites against a Cobblestone checkout, so `CODEX_ROOT`
must point at one.

**Safari no longer names that checkout.** It used to: a `cobblestone` line in
pins.tsv pointed at a private worktree, `~/showell_repos/cobblestone-safari`.
That was a SECOND copy of a pin the transpilers already carry, and the copy that
drifts. On 2026-09-09 it sat at `422405d0` (Update 55 era) while both
transpilers had moved to `8570fba1` (the Update 58 candidate), so the arms would
have graded a U55 language with U57 binaries and nothing said so. The
private-pin mechanism dated to the earliest days and was never anything but a
footgun.

**`harness/cobblestone_pin.py` derives it instead.** It reads the checkout each
borrowed transpiler recorded in its `generated/PROVENANCE`, REQUIRES the two to
agree, and refuses otherwise -- the agreement is the drift check, at the one
place it matters, and there is no safari copy left to fall out of step.
`SAFARI_COBBLESTONE` still overrides explicitly for a candidate build.

    current   ~/showell_repos/cobblestone-u58  8570fba1
              = Update 57 plus our three ZigEmitter commits (the U58 candidate),
              which is what both transpilers were built from and therefore what
              the arms grade against.

**MOVING THE PIN IS NOT A ONE-ARM CHANGE, and that is half of why it is now
derived.** Going from a U53 pin to the u56 candidate once broke fifteen specs to
`graded 0 values` and dropped `harness/bundle_gate.sh` to 6 identical of 40,
because Update 55 took this port INTO the depot as `apps/safari/port` and
registered `Safari`, `Judge` and `Gold` under the names this project has always
used. Both bundlers now give `quires.tsv` the last word and print `SHADOWED:` on
every bundle. Two gates caught it and neither was the one looking for a bundler
bug.

**The transpilers are PULLED, not built here.** Each carries a binary produced
by its own project's `build.py` -- nine stages ending in a fixed point, the
emitter emitting the same bytes for its own source on two roads -- which is a
stronger claim about a binary than this project could make about one it
assembled. `harness/build_codex{zig,wasm}.sh` resolve them through pins.tsv,
check the fingerprint against the tree's own generated source, and REFUSE rather
than build. This project used to build its own wasm transpiler and no longer
does; see `harness/build_codexwasm.sh` for the three reasons that stopped being
right.

## The transpiler: `codex-zig-transpiler`

`codexzig` is one program — Codex source in, Zig out — and it is what makes this
project move. `./harness/build_codexzig.sh` is the only door to it: it resolves
the pin, checks the binary's fingerprint against that tree's own generated
source, and prints the path.

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

    checkout  de6c4d7  (codex-zig-transpiler master)
    built     from cobblestone-u58 8570fba1, CLEAN. generated/PROVENANCE in that
              tree records the seed, the guests and what each touched: fixed
              point HOLDS byte-identical, arith matches, built in 494s.

**The fingerprint cannot see a stale SOURCE, and that is finding 14.**
`build_codexzig.sh` hashes `generated/codexzig.qemu.zig` and compares it to the
fingerprint of the binary built FROM that zig -- so it can tell whether the
binary is current with the generated zig, and cannot tell whether the generated
zig is current with the transpiler's source. Once measured: the source moved at
00:09 and the fingerprint still matched a zig generated at 14:47. A warm sweep
is therefore evidence that nothing needed rebuilding only if somebody already
knows the source did not move -- which is the transpiler project's own concern,
since safari only borrows the result.

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

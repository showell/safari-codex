# HISTORICAL_WASM_ROOT — the game, as it stood when this port was checked

**These files are copies and this project never edits them.** They are the Zig
Safari screensaver from `angry-gopher/games/driving/wasm`, and they are the
ORACLE: `probe/probe_<mod>.zig` imports the real module here and prints what it
computed, `gold/<Mod>Gold.codex` is that answer, and `judge/<Mod>Check.codex`
grades the Codex port against it. Every number this project claims is a number
one of these files produced.

## Why a copy and not the symlink it used to be

`probe/wasm` was a symlink into a sibling checkout, which made two claims this
repository could not keep. It could not say WHICH game it was verified against:
the symlink resolves to whatever that checkout's working tree holds right now,
so a green sweep here was evidence about a moving target. And it could not be
read at all on a box without that checkout, which is every box but this one.

A copy fixes both and costs 828 KB. The price is that it can go stale, so the
version it was taken from is written down rather than implied:

    repository   angry-gopher (github.com/showell/angry-gopher)
    path         games/driving/wasm
    commit       5107e8970688309635cbf628ea56d0894107609c
                 home: Seattle Delivery sits between Chat and Blog
    dated        2026-08-28T18:28:12+00:00
    copied       2026-08-30, working tree clean at that commit

`./harness/refresh_game.sh` re-copies from a checkout and rewrites the block
above; it prints what moved, so a refresh that changes the oracle is visible
rather than silent. Refreshing is the moment to re-run the whole sweep: the gold
is regenerated from these files on every run, so a changed game changes the gold
and any port that no longer matches it will say so.

`blitter.js` is here for the same reason and is the game's own canvas renderer;
`web/blitter.js` links to this copy so the browser page draws the port's frames
with the renderer the real game draws its own with.

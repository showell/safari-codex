#!/usr/bin/env bash
# Re-copy the game into HISTORICAL_WASM_ROOT/ and rewrite its provenance block.
#
#     ./harness/refresh_game.sh [checkout]     default ~/showell_repos/angry-gopher
#
# THE ORACLE MOVING IS AN EVENT, not a background fact, which is the whole reason
# this is a script and not a symlink. It prints every file whose bytes changed and
# refuses a checkout with uncommitted work in games/driving/wasm -- a provenance
# line naming a commit, beside files that are not that commit, is worse than no
# line at all.
#
# AFTER A REFRESH, RUN THE SWEEP. The gold is regenerated from these files every
# run, so a changed game changes the gold, and ./harness/run.sh is what says
# whether the port still matches it.
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
src="${1:-$HOME/showell_repos/angry-gopher}"
wasm="$src/games/driving/wasm"
dst="$root/HISTORICAL_WASM_ROOT"
[ -d "$wasm" ] || { echo "no $wasm" >&2; exit 1; }

dirty=$(git -C "$src" status --porcelain -- games/driving/wasm)
if [ -n "$dirty" ]; then
    echo "$src has uncommitted work under games/driving/wasm:" >&2
    echo "$dirty" >&2
    echo "commit it there first -- the provenance names a commit and must mean it" >&2
    exit 1
fi

moved=0
for f in "$wasm"/*.zig "$wasm"/blitter.js; do
    b=$(basename "$f")
    if ! cmp -s "$f" "$dst/$b"; then
        echo "  changed: $b"
        moved=1
    fi
    cp "$f" "$dst/$b"
done
# A file DELETED upstream stays here forever otherwise, and a stale oracle module
# that nothing imports is harmless right up until something imports it.
for f in "$dst"/*.zig; do
    b=$(basename "$f")
    [ -f "$wasm/$b" ] || { echo "  gone upstream: $b"; rm "$f"; moved=1; }
done

sha=$(git -C "$src" rev-parse HEAD)
subj=$(git -C "$src" log -1 --format=%s)
date=$(git -C "$src" log -1 --format=%cI)
python3 - "$dst/PROVENANCE.md" "$sha" "$subj" "$date" <<'PY'
import re, sys
path, sha, subj, date = sys.argv[1:5]
text = open(path).read()
block = (f"    repository   angry-gopher (github.com/showell/angry-gopher)\n"
         f"    path         games/driving/wasm\n"
         f"    commit       {sha}\n"
         f"                 {subj}\n"
         f"    dated        {date}\n"
         f"    copied       {__import__('datetime').date.today()}, working tree clean at that commit\n")
new, n = re.subn(r"    repository   angry-gopher.*?working tree clean at that commit\n",
                 block, text, flags=re.S)
if n != 1:
    raise SystemExit(f"PROVENANCE.md: expected one provenance block, found {n}")
open(path, "w").write(new)
PY
echo "HISTORICAL_WASM_ROOT is $sha ($(echo "$subj" | head -c 50))"
[ "$moved" = 0 ] && echo "nothing moved" || echo "THE ORACLE MOVED -- run ./harness/run.sh"

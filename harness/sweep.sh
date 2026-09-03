#!/usr/bin/env bash
# The sweep in TIERS, cheapest first, because most changes do not need all of it.
#
#   ./harness/sweep.sh              structure, values, port   -- about two minutes
#   ./harness/sweep.sh all          everything but the eyes   -- about fifteen
#   ./harness/sweep.sh <name>       one tier: structure values port wasm metal eyes
#
# WHY TIERS. A restructuring change -- moving definitions between chapters,
# splitting a chapter, renaming nothing -- cannot reach an emitter path the
# previous source did not reach. The same expressions are emitted, in a
# different file order. So `wasm` and `metal`, which exist to catch EMITTER
# faults, are answering a question that change did not ask, and they cost
# thirteen of the fifteen minutes. Run them when an idiom is new, or before you
# call something finished; run the first three while you work.
#
# Measured 2026-09-03 on the Camera and World splits, on the ladder droplet:
#
#     structure    5 s     bundles resolve, no name undefined, no duplicate
#     values      90 s     new source, OLD binary as oracle -- values unchanged
#     port        40 s     codexzig builds it and the golds grade it
#     wasm         4 min   the second road to wasm agrees with the first
#     metal        9 min   DDC: the compiler's own x86-64 emitter, under QEMU
#
# THE ORDER OF THE FIRST TWO IS LOAD-BEARING AND IT IS NOT ALPHABETICAL.
# `values` diffs the new source against `build/<mod>` -- binaries built from the
# source as it was BEFORE this change. That is what makes it an independent
# oracle: two implementations, one of them frozen. `port` REBUILDS those
# binaries from the new source, and the moment it does, `values` is comparing
# the change against itself and cannot fail. So values runs first, always, and
# running `port` alone on a dirty tree spends the oracle. If you have already
# run `port`, `git stash` will not bring the binaries back either -- they are
# tracked, so `git checkout -- build/` will.
set -uo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
root="$(dirname "$here")"
cd "$root"

# The Rust front end is a sibling project, not a dependency of this one. When it
# is absent the tiers that need it REFUSE rather than pass: a tier that quietly
# does nothing is worse than one that is not run, because the summary line looks
# the same either way.
RUSTC_DIR="${RUST_CODEX:-$HOME/showell_repos/rust-codex-compiler}"
CODEXRUN="${CODEXRUN:-$RUSTC_DIR/target/release/codexrun}"
XREF="${XREF:-$RUSTC_DIR/target/release/xref}"
WORK="${TMPDIR:-/tmp}/safari-sweep-$$"

fail=0
say() { printf '\n===== %s\n' "$*"; }
note() { printf '      %s\n' "$*"; }

t_structure() {
    say "structure -- every unit bundles, every name resolves"
    mkdir -p "$WORK"
    local n=0 bad=0
    for c in judge/*Check.codex poc/*Main.codex; do
        local m; m="$(basename "$c" .codex)"
        if python3 harness/bundle.py "$c" "$WORK/$m-unit.codex" >"$WORK/$m.err" 2>&1; then
            n=$((n + 1))
        else
            bad=$((bad + 1)); note "BUNDLE FAILED $m"; sed 's/^/        /' "$WORK/$m.err" | head -3
        fi
    done
    note "$n units bundled, $bad failed"
    [ "$bad" -eq 0 ] || fail=1
    if [ -x "$XREF" ]; then
        # Names read that nothing in the tree defines. Builtins and the foreword
        # live outside it, so this is a list to READ, not a list of errors --
        # what matters is a name that used to resolve and stopped.
        local d; d="$("$XREF" dangling port judge poc gold 2>/dev/null | wc -l)"
        note "$d names read from outside the tree (builtins, foreword, primitives)"
    else
        note "NO xref at $XREF -- the dangling-name check did NOT run"
        fail=1
    fi
}

t_values() {
    say "values -- new source, PRE-CHANGE binary as the oracle"
    if [ ! -x "$CODEXRUN" ]; then
        note "NO codexrun at $CODEXRUN -- this tier did NOT run"
        note "build it: cargo build --release in $RUSTC_DIR"
        fail=1; return
    fi
    mkdir -p "$WORK"
    local same=0 diff=0 skip=0
    for c in judge/*Check.codex; do
        local m mod; m="$(basename "$c" .codex)"
        mod="$(echo "$m" | sed -E 's/Check$//' | sed -E 's/([a-z0-9])([A-Z])/\1_\2/g' | tr 'A-Z' 'a-z')"
        if [ ! -x "build/$mod" ]; then
            skip=$((skip + 1)); note "SKIP $m -- no build/$mod to compare against"; continue
        fi
        python3 harness/bundle.py "$c" "$WORK/$m-unit.codex" >/dev/null 2>&1 || {
            diff=$((diff + 1)); note "BUNDLE FAILED $m"; continue; }
        local old new
        old="$("./build/$mod" 2>&1)"
        new="$(timeout 900 "$CODEXRUN" "$WORK/$m-unit.codex" 2>&1)"
        if [ "$old" = "$new" ]; then
            same=$((same + 1))
        else
            diff=$((diff + 1)); note "DIFFERS $m"
            command diff <(printf '%s' "$old") <(printf '%s' "$new") | head -6 | sed 's/^/        /'
        fi
    done
    note "identical $same   differing $diff   no binary $skip"
    # A skip is not a pass. A tree with no binaries has not been checked.
    { [ "$diff" -eq 0 ] && [ "$skip" -eq 0 ]; } || fail=1
}

t_port()  { say "port -- codexzig builds it, the golds grade it";  ./harness/run.sh || fail=1; }
t_wasm() {
    say "wasm -- the second road agrees with the first"
    # wasmtime and the node modules are downloaded, not tracked, so a fresh
    # worktree has neither and the arm dies mid-unit with a FileNotFoundError
    # forty lines deep. Refuse at the top with the name of the missing thing:
    # this cost a full-sweep run on 2026-09-03, and the traceback was read as
    # a pass because the tier after it started anyway.
    for t in tools/bin/wasmtime tools/node_modules; do
        [ -e "$t" ] || { note "NO $t -- this tier did NOT run"; note "see tools/README.md"; fail=1; return; }
    done
    ./harness/wasm_arm.py --native --all || fail=1
}
t_metal() { say "metal -- the compiler's own x86-64 emitter, DDC"; ./harness/metal.py --all || fail=1; }

t_eyes() {
    say "eyes -- the browser proof of concept"
    ./harness/build_wasm.sh || { fail=1; return; }
    note "now: ./harness/serve.py   and open http://localhost:9200/"
    note "this tier BUILDS; the looking is yours."
}

case "${1:-fast}" in
    fast)      t_structure; t_values; t_port ;;
    all)       t_structure; t_values; t_port; t_wasm; t_metal ;;
    structure) t_structure ;;
    values)    t_values ;;
    port)      t_port ;;
    wasm)      t_wasm ;;
    metal)     t_metal ;;
    eyes)      t_eyes ;;
    *) echo "usage: sweep.sh [fast|all|structure|values|port|wasm|metal|eyes]" >&2; exit 2 ;;
esac

rm -rf "$WORK"
if [ "$fail" -eq 0 ]; then printf '\nSWEEP GREEN (%s)\n' "${1:-fast}"; else printf '\nSWEEP RED (%s)\n' "${1:-fast}"; fi
exit "$fail"

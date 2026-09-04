#!/bin/bash
# Run every spec, and PROVE EACH ONE CAN FAIL.
#
#   ./spec/run.sh            the Rust interpreter alone -- milliseconds
#   ./spec/run.sh --zig      also transpile and build each spec, and diff the arms
#
# A spec is a self-checking Codex chapter: it carries its own expected values as
# literals and prints its own verdict, so any arm that runs Codex renders that
# verdict alone. There is no gold and no probe. See spec/TrigSpec.codex for what
# one looks like and judge/ for the different, more expensive question those ask.
#
# THE SECOND PASS IS THE POINT. A test that carries its own answers is prone to
# passing by doing NOTHING: `grade-reals` on two empty lists reports `ok 0`, and
# a spec whose input list was emptied by an edit would sail through a gate that
# only greps for BAD. So every spec is run twice -- once as written, which must
# be all ok, and once with every tolerance forced NEGATIVE, which must be all
# BAD. `grade-reals` asks whether |got - want| exceeds the tolerance, so at -1.0
# even an exact match exceeds it; the only way to still report ok is to be
# comparing nothing at all. A line that survives the mutant is a line that never
# ran.
set -uo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$root"
BIN="${CODEXRUN:-$HOME/runs/20260904T112500Z-rust-interp-speed/rust-target/release/codexrun}"
[ -x "$BIN" ] || { echo "no codexrun at $BIN; set CODEXRUN" >&2; exit 2; }
zig_arm=0
[ "${1:-}" = "--zig" ] && zig_arm=1
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
fail=0; n=0
for s in spec/*Spec.codex; do
    [ -e "$s" ] || { echo "no specs under spec/"; exit 2; }
    base="$(basename "$s" .codex)"; mod="$(echo "$base" | tr 'A-Z' 'a-z')"
    n=$((n + 1))

    python3 harness/bundle.py "$s" "build/$mod-unit.codex" || { echo "$base: bundle failed" >&2; fail=1; continue; }
    out="$("$BIN" "build/$mod-unit.codex" 2>&1)"
    # Silence is not success, and neither is a verdict over nothing.
    if [ -z "$out" ]; then echo "$base: printed nothing" >&2; fail=1; continue; fi
    if grep -q BAD <<<"$out"; then echo "$base:"; echo "$out"; fail=1; continue; fi
    if grep -qE "ok 0$" <<<"$out"; then echo "$base: a line graded ZERO values" >&2; echo "$out"; fail=1; continue; fi

    # The mutant: every tolerance forced negative, so every line must fail.
    sed -E 's/ (0\.0+[0-9]+)\)$/ -1.0)/' "$s" > "$tmp/$base.codex"
    python3 harness/bundle.py "$tmp/$base.codex" "$tmp/$mod-unit.codex" >/dev/null 2>&1
    mut="$("$BIN" "$tmp/$mod-unit.codex" 2>&1)"
    live="$(grep -c BAD <<<"$mut")"; lines="$(grep -c . <<<"$out")"
    if [ "$live" -ne "$lines" ]; then
        echo "$base: $live of $lines lines fail under a negative tolerance -- the rest grade nothing" >&2
        fail=1; continue
    fi

    if [ "$zig_arm" = 1 ]; then
        codexzig="$(harness/build_codexzig.sh 2>/dev/null | tail -1)"
        zig="${ZIG:-$HOME/zig-0.16.0/zig}"
        "$codexzig" < "build/$mod-unit.codex" 2> "build/$mod.zig" > "build/$mod.diag"
        grep -q "^// THE PRELUDE" "build/$mod.zig" || { echo "$base: codexzig emitted no program" >&2; fail=1; continue; }
        ( cd build && "$zig" build-exe "$mod.zig" ) || { echo "$base: zig build failed" >&2; fail=1; continue; }
        zout="$( cd build && "./$mod" 2>&1 )"
        if [ "$zout" != "$out" ]; then
            echo "$base: THE ARMS DISAGREE"; diff <(echo "$out") <(echo "$zout"); fail=1; continue
        fi
        printf '%-16s ok, both arms\n' "$base"
    else
        printf '%-16s %s\n' "$base" "$(tr '\n' ' ' <<<"$out")"
    fi
done
echo
if [ "$fail" = 0 ]; then echo "$n spec(s) pass, and each one was shown to be capable of failing"; else echo "SPECS FAILED"; fi
exit "$fail"

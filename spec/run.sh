#!/bin/bash
# The entry point stays run.sh; the logic is run.py, which needs to be ONE
# process rather than three per spec. See run.py's docstring for why.
#
# THE PIN IS CHECKED FIRST. codexrun takes the checkout from quires.tsv's
# `checkout` line, and harness/cobblestone_pin.py refuses when that line and
# the borrowed transpilers' pin disagree. Nothing here reads CODEX_ROOT.
set -uo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
python3 "$root/harness/cobblestone_pin.py" > /dev/null || exit 2
exec python3 -u "$root/spec/run.py" "$@"

#!/usr/bin/env bash
# Print the path to codexzig, from the bundle named in pins.tsv.
#
# A codexzig BUNDLE is a directory holding the `codexzig` executable beside a
# PROVENANCE that records how it was built (which Cobblestone checkout). Safari
# borrows one; it never builds codexzig. To use a different codexzig -- a
# candidate, an older pin -- point the `codexzig` line in pins.tsv at another
# bundle directory. There is nothing else to override.
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
bundle=$(sed 's/#.*//' "$root/pins.tsv" | awk '$1=="codexzig"{print $2}')
bundle="${bundle/#\~/$HOME}"
[ -x "$bundle/codexzig" ] || { echo "no codexzig executable at $bundle/codexzig (see pins.tsv)" >&2; exit 1; }
[ -f "$bundle/PROVENANCE" ] || { echo "$bundle has codexzig but no PROVENANCE beside it -- not a bundle" >&2; exit 1; }
printf '%s' "$bundle/codexzig"

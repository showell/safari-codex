#!/bin/bash
# The entry point stays run.sh; the logic is run.py, which needs to be ONE
# Python process rather than three per spec. See run.py's docstring for why.
exec python3 "$(dirname "${BASH_SOURCE[0]}")/run.py" "$@"

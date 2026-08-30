#!/usr/bin/env python3
"""The chapter-name to module-name rule, in ONE place.

    GuardRail -> guard_rail        (beside wasm/guard_rail.zig)
    SpikeProfileMain -> spike_profile_main

Four copies of this rule existed and two of them were WRONG. gen_gold.py and
metal.py each carried a `snake()`, while run.sh and spike.sh each carried a `sed`,
and the two implementations are not the same function:

    IOBuffer     python  i_o_buffer      sed  i_obuffer
    HTTPServer   python  h_t_t_p_server  sed  h_tt_pserver

`s/\\(.\\)\\([A-Z]\\)/\\1_\\2/g` consumes TWO characters per match and matches
non-overlapping, so a run of capitals gets a separator after every other one. The
python inserts before every capital. No chapter here has two capitals in a row, so
the disagreement has never fired -- it is a landmine, not a bug, and the day
someone writes `IOCheck` the gold generator and the sweep would look for different
probe files and the failure would read as a missing probe.

Importable as a module and runnable as a command, so the shells can stop guessing:

    mod="$(python3 harness/names.py GuardRail)"
"""

import re
import sys


def snake(chapter):
    """`GuardRail` -> `guard_rail`; a single-word chapter is unchanged but lowered."""
    return re.sub(r'(?<!^)(?=[A-Z])', '_', chapter).lower()


if __name__ == '__main__':
    if len(sys.argv) != 2:
        raise SystemExit('usage: names.py <ChapterName>')
    print(snake(sys.argv[1]))

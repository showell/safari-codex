#!/usr/bin/env python3
"""SPIKE ONLY. THROWAWAY TOOLING. Turn one still frame into an SVG you can open.

Not part of the verification loop. Nothing here is graded and no check depends on
it; ./harness/run.sh does not call it. It exists so a piece of scenery can be
LOOKED AT rather than reasoned about, which is a faster feedback loop than driving
the browser page to the right spot.

    ./harness/spike.sh          # build poc/SpikeMain, render every viewpoint

Reads the text poc/SpikeMain.codex prints -- a SCENE header then one line of
semicolon-separated draw commands -- and writes web/spikes/<name>.svg plus an
index. Coordinates arrive as hundredths of a pixel because `show` on a Real is
still refused by the zig plug; see the chapter.

The SVG is an APPROXIMATION of what blitter.js paints, deliberately. It does the
sky gradient, the grass, solid fills and the round-gradient polygons, because
those are what carry the shapes. It does NOT reproduce the blitter's exact shading
maths. If a spike and the browser ever disagree about a colour, believe the
browser; if they disagree about a SHAPE, that is worth chasing.
"""

import html
import pathlib
import re
import subprocess
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
W, H = 960, 600
GRASS = "#4a8f43"


def rgb(v):
    return f"#{v & 0xFFFFFF:06x}"


def shade(v, f):
    """blitter.js's shade(): scale each channel, clamped. Used for the tag-1 ends."""
    r, g, b = (v >> 16) & 255, (v >> 8) & 255, v & 255
    c = lambda x: max(0, min(255, int(x * f)))
    return f"#{c(r):02x}{c(g):02x}{c(b):02x}"


def parse(text):
    """-> [(name, sky_top, sky_horizon, [(tag, color, strength, [(x, y), ...])])]"""
    scenes, cur = [], None
    for line in text.splitlines():
        if line.startswith("SCENE "):
            _, name, top, hor = line.split()
            cur = (name, int(top), int(hor), [])
            scenes.append(cur)
        elif line.startswith("C ") and cur is not None:
            for chunk in line.split(" ; "):
                f = chunk.split()
                if not f or f[0] != "C":
                    continue
                tag, color, strength, n = int(f[1]), int(f[2]), int(f[3]), int(f[4])
                nums = [int(x) / 100.0 for x in f[5:]]
                pts = list(zip(nums[0::2], nums[1::2]))
                cur[3].append((tag, color, strength / 1000.0, pts))
    return scenes


def svg(name, top, hor, cmds):
    out = [f'<svg xmlns="http://www.w3.org/2000/svg" width="{W}" height="{H}" '
           f'viewBox="0 0 {W} {H}">',
           '<defs><linearGradient id="sky" x1="0" y1="0" x2="0" y2="1">'
           f'<stop offset="0" stop-color="{rgb(top)}"/>'
           f'<stop offset="0.2" stop-color="{rgb(top)}"/>'
           f'<stop offset="1" stop-color="{rgb(hor)}"/></linearGradient>']
    # tag 1 is a horizontal round gradient across the polygon's own x-extent:
    # dark edge, bright centre, dark edge, with a per-polygon strength.
    grads = []
    for i, (tag, color, st, pts) in enumerate(cmds):
        if tag != 1 or not pts:
            continue
        xs = [p[0] for p in pts]
        x0, x1 = min(xs), max(xs)
        if x1 - x0 < 1:
            continue
        grads.append(
            f'<linearGradient id="g{i}" gradientUnits="userSpaceOnUse" '
            f'x1="{x0:.1f}" y1="0" x2="{x1:.1f}" y2="0">'
            f'<stop offset="0" stop-color="{shade(color, 1 - 0.4 * st)}"/>'
            f'<stop offset="0.5" stop-color="{shade(color, 1 + 0.25 * st)}"/>'
            f'<stop offset="1" stop-color="{shade(color, 1 - 0.4 * st)}"/>'
            f'</linearGradient>')
    out += grads
    out.append("</defs>")
    out.append(f'<rect width="{W}" height="{H}" fill="url(#sky)"/>')
    # The grass is painted under everything, as the blitter does; the ground quads
    # then cover it wherever there is road.
    out.append(f'<rect y="{H//2}" width="{W}" height="{H//2}" fill="{GRASS}"/>')
    for i, (tag, color, st, pts) in enumerate(cmds):
        if tag == 3:  # a disc: x, y, r with alpha in strength
            if len(pts) < 2:
                continue
            (x, y), (r, _) = pts[0], pts[1]
            if r < 0.5 or st < 0.02:
                continue
            out.append(f'<circle cx="{x:.1f}" cy="{y:.1f}" r="{r:.1f}" '
                       f'fill="{rgb(color)}" fill-opacity="{st:.2f}"/>')
            continue
        if len(pts) < 3:
            continue
        d = " ".join(f"{x:.1f},{y:.1f}" for x, y in pts)
        xs = [p[0] for p in pts]
        use_grad = tag == 1 and (max(xs) - min(xs)) >= 1
        fill = f"url(#g{i})" if use_grad else rgb(color)
        out.append(f'<polygon points="{d}" fill="{fill}"/>')
    out.append("</svg>")
    return "\n".join(out)


def main():
    exe = ROOT / "build" / "spike"
    if not exe.exists():
        raise SystemExit("build/spike not built -- run ./harness/spike.sh")
    text = subprocess.run([str(exe)], cwd=ROOT / "build",
                          capture_output=True, text=True, check=True).stderr
    scenes = parse(text)
    if not scenes:
        raise SystemExit("no SCENE blocks in the spike output")
    out = ROOT / "web" / "spikes"
    out.mkdir(parents=True, exist_ok=True)
    rows = []
    for name, top, hor, cmds in scenes:
        (out / f"{name}.svg").write_text(svg(name, top, hor, cmds))
        print(f"web/spikes/{name}.svg  ({len(cmds)} commands)")
        rows.append(f'<h2>{html.escape(name)}</h2>'
                    f'<p>{len(cmds)} draw commands</p>'
                    f'<img src="{name}.svg" width="{W}" height="{H}">')
    (out / "index.html").write_text(
        "<!doctype html><meta charset=utf-8><title>safari-codex spikes</title>"
        "<style>body{background:#181818;color:#ddd;font:14px system-ui;margin:24px}"
        "img{border:1px solid #444;display:block;margin-bottom:8px}"
        "h2{margin-bottom:2px}p{margin-top:0;color:#999}</style>"
        "<h1>safari-codex &mdash; scenery spikes</h1>"
        "<p>Throwaway stills from the ported render. Boxes are animals that are "
        "collected and depth-sorted but whose art is not ported.</p>"
        + "".join(rows))
    print(f"web/spikes/index.html  ({len(scenes)} scenes)")


if __name__ == "__main__":
    sys.exit(main())

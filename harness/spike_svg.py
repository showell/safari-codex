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
import time
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
W, H = 960, 600
GRASS = "#4a8f43"


EMOJI = pathlib.Path.home() / "showell_repos/angry-gopher/games/driving/wasm/emoji_frames.zig"


def load_emoji():
    """SPIKE-ONLY CHEAT, and a deliberate one. Read the game's baked polygon table
    straight off disk and draw the real animals.

    The PORT cannot do this -- 615 KB of generated coordinates is the wrong shape
    of work to hand-carry into Codex, and NOTES says how it should arrive when it
    does (teach the baker a Codex emitter). But this script is Python, is
    throwaway, and its whole job is to let a human judge PLACEMENT. So the art
    here is the game's own and the placement is the port's, which is exactly the
    split that makes these pictures mean something: a pig in the wrong spot is
    this port's fault, a pig that looks wrong is not.

    Returns {codepoint: [(color, [(x, y), ...]), ...]} in the unit frame the
    billboard uses -- feet at y = 0, y up, height 1, facing LEFT.
    """
    if not EMOJI.is_file():
        return {}
    text = EMOJI.read_text()
    named = {}
    for m in re.finditer(r"const (\w+) = \[_\]Poly\{(.*?)\n\};", text, re.S):
        polys = []
        for pm in re.finditer(r"\.color = 0x([0-9A-Fa-f]+).*?\.pts = &\[_\]Pt\{(.*?)\} \}", pm_body := m.group(2), re.S):
            pts = [(float(a), float(b)) for a, b in
                   re.findall(r"\.x = (-?[\d.e-]+), \.y = (-?[\d.e-]+)", pm.group(2))]
            if len(pts) >= 3:
                polys.append((int(pm.group(1), 16), pts))
        if polys:
            named[m.group(1)] = polys
    out = {}
    for m in re.finditer(r"0x0([0-9A-F]{5}) => &(\w+),", text):
        cp = int(m.group(1), 16)
        if m.group(2) in named:
            out[cp] = named[m.group(2)]
    return out


ART = None


def billboard(cp, face_right, bx, by, h):
    """Transform one baked emoji to a screen anchor: a POINT translates to the feet
    and scales by the pixel height; the art is baked facing LEFT so a right-facing
    animal mirrors in x. Mirrors critter.zig's mapP."""
    global ART
    if ART is None:
        ART = load_emoji()
    polys = ART.get(cp)
    if not polys:
        return [f'<rect x="{bx-h*0.18:.1f}" y="{by-h:.1f}" width="{h*0.36:.1f}" '
                f'height="{h:.1f}" fill="#888"/>']
    sx = -1.0 if face_right else 1.0
    out = []
    for color, pts in polys:
        d = " ".join(f"{bx + sx * x * h:.1f},{by - y * h:.1f}" for x, y in pts)
        out.append(f'<polygon points="{d}" fill="{rgb(color)}"/>')
    return out


def rgb(v):
    return f"#{v & 0xFFFFFF:06x}"


def shade(v, f):
    """blitter.js's shade(): scale each channel, clamped. Used for the tag-1 ends."""
    r, g, b = (v >> 16) & 255, (v >> 8) & 255, v & 255
    c = lambda x: max(0, min(255, int(x * f)))
    return f"#{c(r):02x}{c(g):02x}{c(b):02x}"


GW, GH = 960, 300


def graph(pts):
    """SPIKE ONLY. Speed and lean against route distance -- one variable, no clock.

    pts is [(dist_m, v, tilt, seg)]. Draws v against distance with the segment
    boundaries marked, so a corner dip can be read against the corner it is for.
    """
    if not pts:
        return ""
    dmax = max(p[0] for p in pts) or 1
    vmax = max(max(p[1] for p in pts), 2.5)
    sx = lambda d: 40 + (GW - 60) * d / dmax
    sy = lambda v: GH - 30 - (GH - 50) * v / vmax
    out = [f'<svg xmlns="http://www.w3.org/2000/svg" width="{GW}" height="{GH}" '
           f'viewBox="0 0 {GW} {GH}">',
           f'<rect width="{GW}" height="{GH}" fill="#14171c"/>']
    # segment boundaries: where seg changes, so a dip can be read against its corner
    last = pts[0][3]
    for d, v, t, sg in pts:
        if sg != last:
            out.append(f'<line x1="{sx(d):.1f}" y1="20" x2="{sx(d):.1f}" y2="{GH-30}" '
                       f'stroke="#3a4250"/>')
            out.append(f'<text x="{sx(d)+3:.1f}" y="32" fill="#5d6675" '
                       f'font-size="9" font-family="system-ui">{sg}</text>')
            last = sg
    for v, lbl in ((2.5, "v-max 2.5"), (0.3, "v-base 0.3")):
        out.append(f'<line x1="40" y1="{sy(v):.1f}" x2="{GW-20}" y2="{sy(v):.1f}" '
                   f'stroke="#454d5c" stroke-dasharray="3 3"/>')
        out.append(f'<text x="4" y="{sy(v)+3:.1f}" fill="#7c8798" font-size="10" '
                   f'font-family="system-ui">{lbl}</text>')
    d = " ".join(f"{sx(p[0]):.1f},{sy(p[1]):.1f}" for p in pts)
    out.append(f'<polyline points="{d}" fill="none" stroke="#5ec8f0" stroke-width="1.5"/>')
    tl = " ".join(f"{sx(p[0]):.1f},{sy(abs(p[2]) * 4):.1f}" for p in pts)
    out.append(f'<polyline points="{tl}" fill="none" stroke="#e08a4a" stroke-width="1"/>')
    out.append(f'<text x="40" y="{GH-10}" fill="#7c8798" font-size="10" '
               f'font-family="system-ui">route distance 0..{dmax:.0f} m &mdash; '
               f'blue: speed (m/frame) &mdash; orange: |lean| x4 &mdash; '
               f'{len(pts)} frames</text>')
    out.append("</svg>")
    return "\n".join(out)


def parse_profile(text):
    for line in text.splitlines():
        if line.startswith("PROFILE "):
            continue
        if " ; " in line and not line.startswith("C "):
            pts = []
            for chunk in line.split(" ; "):
                f = chunk.split()
                if len(f) != 4:
                    continue
                pts.append((float(f[0]), int(f[1]) / 1000.0,
                            int(f[2]) / 1000.0, int(f[3])))
            if pts:
                return pts
    return []


def parse(text):
    """-> [(name, sky_top, sky_horizon, [(tag, color, strength, pairs, raw)])]

    BOTH the (x, y) pairs AND the flat number list, because not every command is a
    polygon. Tag 3 is a disc carrying x, y, r -- three numbers -- and spike tag 9
    is a billboard anchor carrying x, y and a pixel height. Zipping those into
    pairs silently drops the third and the command renders as nothing, which is
    exactly what happened: the beacons and every animal vanished from the stills
    with no error anywhere.
    """
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
                cur[3].append((tag, color, strength / 1000.0, pts, nums))
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
    for i, (tag, color, st, pts, raw) in enumerate(cmds):
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
    for i, (tag, color, st, pts, raw) in enumerate(cmds):
        # TAG 9 IS SPIKE-ONLY: a billboard anchor, not a polygon. See Spike.codex.
        if tag == 9:
            if len(raw) < 3:
                continue
            bx, by, h = raw[0], raw[1], raw[2]
            out += billboard(color, st > 0.5, bx, by, h)
            continue
        if tag == 3:  # a disc: x, y, r with alpha in strength
            if len(raw) < 3:
                continue
            x, y, r = raw[0], raw[1], raw[2]
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
    prof = parse_profile(text)
    scenes = parse(text)
    if not scenes:
        raise SystemExit("no SCENE blocks in the spike output")
    out = ROOT / "web" / "spikes"
    out.mkdir(parents=True, exist_ok=True)
    # CACHE-BUST EVERY IMAGE. python -m http.server sends Last-Modified and browsers
    # hold on to it, so a regenerated spike can quietly show you the previous run --
    # which happened: a speed graph that had just been added did not appear at all.
    # A stamp in the query string costs nothing and removes the whole class of
    # "is that the old picture or the new one".
    stamp = int(time.time())
    rows = []
    if prof:
        (out / "speed.svg").write_text(graph(prof))
        vs = [p[1] for p in prof]
        print(f"web/spikes/speed.svg  ({len(prof)} frames, "
              f"v {min(vs):.2f}..{max(vs):.2f} m/frame)")
        rows.append('<h2>speed profile</h2><p>the real ported physics over the '
                    'whole route &mdash; no animation involved</p>'
                    f'<img src="speed.svg?v={stamp}" width="{GW}" height="{GH}">')
    for name, top, hor, cmds in scenes:
        (out / f"{name}.svg").write_text(svg(name, top, hor, cmds))
        print(f"web/spikes/{name}.svg  ({len(cmds)} commands)")
        rows.append(f'<h2>{html.escape(name)}</h2>'
                    f'<p>{len(cmds)} draw commands</p>'
                    f'<img src="{name}.svg?v={stamp}" width="{W}" height="{H}">')
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


// ========================================================================
// THE WASM SHIM. Appended to the transpiled program by harness/wasmify.py.
//
// The Codex side is pure: `frame()` returns a list of draw commands holding
// f64 screen coordinates. The browser wants wasm/paint.zig's wire --
// [tag u32][color u32][nPoints u32][x f32][y f32]... in linear memory -- so
// this walks the one and writes the other.
//
// THE NARROWING TO f32 HAPPENS HERE, and only here. Codex Real is f64 in every
// plug while the game computes in f32, and the buffer is the only place the
// game's width is actually load-bearing (blitter.js reads these words back
// through a Float32Array). Putting @floatCast at the seam is what the
// hand-written zig already does with its @bitCast, so the two agree about
// where the precision is allowed to change.
//
// The buffer is fixed and pre-sized, exactly as paint.zig's is: a wasm module
// that grows memory mid-frame invalidates the views the blitter is holding.

const CAP_WORDS: usize = (1 << 20) / 4;
var cx_paint: [CAP_WORDS]u32 = undefined;
var cx_paint_high: usize = 0;

// THE SCRUB. blitter.js already has the controls -- Space toggles auto, the arrows
// step, J jumps -- and they drove nothing while this was one static frame. `u`
// runs 0..1 and Scene maps it onto the heading and the sunset clock together,
// which is the shape advance() has in the real game: the route turns the rider
// while the clock runs. It wraps, so auto-play loops the sweep.
var cx_u: f64 = 0.0;
const U_PER_STEP: f64 = 1.0 / 900.0;

// THE ARENA RESET, and without it this page lives for exactly one frame.
//
// The emitted prelude bump-allocates from one region and NEVER RECLAIMS -- every
// list, every record, forever (PORTING_NOTES C6). A blitter calls renderFrame()
// sixty times a second, and one frame of the real ranges is four silhouettes of
// 683 points each, so the second call already dies: measured, renderFrame()
// survived ONE call and then trapped on `unreachable`.
//
// A bigger reserve only buys frames; it does not fix the shape. The fix is that
// the frame is PURE. Nothing computed here outlives the call -- the loop below
// copies every coordinate into cx_paint before returning, and the Codex side has
// no mutable state to carry over -- so the whole region can be rewound to where
// it started and the next frame can have it again. That is an arena reset, and
// the shim is the only place that knows a frame has ended.
//
// cx_hp's initial 6291456 is not arbitrary: bare metal boots its heap pointer at
// exactly that (`mov r10, 6291456`), and the plug mirrors it. Capturing it rather
// than writing the literal keeps this correct if that base ever moves.
var cx_hp_base: i64 = 0;

pub export fn renderFrame() u32 {
    if (cx_hp_base == 0) cx_hp_base = cx_hp else cx_hp = cx_hp_base;
    var w: usize = 0;
    const cmds = frame_at(cx_u);
    for (cmds.items.items) |cmd| {
        const pts = cmd.pts.items.items;
        const n = pts.len / 2;
        // TAG 3 IS A DISC, NOT A POLYGON -- [3][color][x][y][r][alpha], six words
        // and no point count, because the blitter draws a true arc for it and it
        // is the one command that is not opaque. Its x, y and r ride in pts and
        // its alpha in strength, which is how one DrawCmd shape carries it.
        if (cmd.tag == 3) {
            if (w + 6 > CAP_WORDS) break;
            cx_paint[w] = 3;
            cx_paint[w + 1] = @intCast(cmd.color);
            cx_paint[w + 2] = @bitCast(@as(f32, @floatCast(pts[0])));
            cx_paint[w + 3] = @bitCast(@as(f32, @floatCast(pts[1])));
            cx_paint[w + 4] = @bitCast(@as(f32, @floatCast(pts[2])));
            cx_paint[w + 5] = @bitCast(@as(f32, @floatCast(cmd.strength)));
            w += 6;
            continue;
        }
        // tag 1 carries a strength word between the colour and the count; tag 0
        // does not. Same split paint.pushPoly / pushRoundPoly makes.
        const head: usize = if (cmd.tag == 1) 4 else 3;
        if (w + head + pts.len > CAP_WORDS) break; // bounded, like paint.push
        cx_paint[w] = @intCast(cmd.tag);
        cx_paint[w + 1] = @intCast(cmd.color);
        if (cmd.tag == 1) {
            cx_paint[w + 2] = @bitCast(@as(f32, @floatCast(cmd.strength)));
            cx_paint[w + 3] = @intCast(n);
        } else {
            cx_paint[w + 2] = @intCast(n);
        }
        w += head;
        for (pts) |v| {
            cx_paint[w] = @bitCast(@as(f32, @floatCast(v)));
            w += 1;
        }
    }
    if (w > cx_paint_high) cx_paint_high = w;
    return @intCast(w * 4);
}

pub export fn bufPtr() u32 {
    return @intCast(@intFromPtr(&cx_paint));
}
pub export fn bufHighWater() u32 {
    return @intCast(cx_paint_high * 4);
}
pub export fn bufCap() u32 {
    return @intCast(CAP_WORDS * 4);
}

// The pose exports. The camera still does not bank -- lean belongs to rider.zig,
// which is not ported -- but the scrub is live, so these are no longer stubs.
pub export fn advance() void {
    cx_u += U_PER_STEP;
    if (cx_u > 1.0) cx_u -= 1.0;
}
pub export fn back() void {
    cx_u -= U_PER_STEP;
    if (cx_u < 0.0) cx_u += 1.0;
}
pub export fn riderTilt() f32 {
    return 0.0;
}
// J walks until this changes, under a 200000 guard. Ten stops across the sweep
// gives it something to land on instead of spinning to the guard.
pub export fn riderSeg() u32 {
    return @intFromFloat(cx_u * 10.0);
}
pub export fn clock() u32 {
    return @intFromFloat(scene_step_at(cx_u));
}

// Sky, horizon and sun are NOT polygons: blitter.js paints them itself, with a
// linear gradient for the sky and a radial glow plus the disc for the sun, and
// asks the module for the numbers. So they never reach the buffer above.
//
// THESE WERE SIX HARD-CODED CONSTANTS until the sunset clock was ported. A
// plausible blue, a plausible orange and a sun placed by eye at (360, 236) --
// which is exactly the kind of number that looks right and grades nothing. They
// now come out of Safari chapter Sky, graded at 148 values against wasm/sky.zig
// with BOTH COLOUR STREAMS COMPARED EXACTLY, so what the browser paints behind
// the ranges is the ported clock rather than a guess that resembled one.
//
// Nullary Codex bindings emit as zero-argument zig functions, so these are plain
// calls into the transpiled program.
pub export fn skyTop() u32 {
    return @intCast(sky_color(scene_step_at(cx_u)));
}
pub export fn skyHorizon() u32 {
    return @intCast(horizon_color(scene_step_at(cx_u)));
}
pub export fn sunVisible() u32 {
    return @intFromBool(scene_sun_at(cx_u).visible);
}
pub export fn sunX() f32 {
    return @floatCast(scene_sun_at(cx_u).x);
}
pub export fn sunY() f32 {
    return @floatCast(scene_sun_at(cx_u).y);
}
pub export fn sunScale() f32 {
    return @floatCast(scene_sun_at(cx_u).scale);
}

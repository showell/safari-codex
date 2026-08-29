
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

pub export fn renderFrame() u32 {
    var w: usize = 0;
    const cmds = frame();
    for (cmds.items.items) |cmd| {
        const pts = cmd.pts.items.items;
        const n = pts.len / 2;
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

// The pose exports. This frame is static -- one frame is the whole point of the
// proof -- so the rider does not move and the camera does not bank. They exist
// because blitter.js destructures them, and a missing export is a TypeError
// before the first pixel.
pub export fn advance() void {}
pub export fn back() void {}
pub export fn riderTilt() f32 {
    return 0.0;
}
pub export fn riderSeg() u32 {
    return 0;
}
pub export fn clock() u32 {
    return 0;
}

// Sky, horizon and sun come from the blitter's own drawBackground/drawSun, so
// the Codex frame never draws them. Late afternoon, sun low and left of centre.
pub export fn skyTop() u32 {
    return 0x3f6fa8;
}
pub export fn skyHorizon() u32 {
    return 0xe8a163;
}
pub export fn sunVisible() u32 {
    return 1;
}
pub export fn sunX() f32 {
    return 360.0;
}
pub export fn sunY() f32 {
    return 236.0;
}
pub export fn sunScale() f32 {
    return 1.0;
}

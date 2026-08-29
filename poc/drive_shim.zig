
// ========================================================================
// THE DRIVE SHIM. Appended to the transpiled program by harness/wasmify.py.
//
// Where poc/shim.zig answers every frame from a scrub `u`, this one RUNS THE
// PORTED PHYSICS. `Safari chapter Rider` is graded at 199 values one step from a
// shared state, so the page can just step it -- and stepping it is what fixes,
// as consequences rather than as separate patches, the speed (the game's, corner
// by corner, instead of one average), the acceleration and braking (which a
// constant cannot have at all), the lean (tilt is a field on the state and the
// old page simply never asked), and the heading (the rider's own, so the blended
// stand-in Drive used is gone).
//
// Measured before this existed: the real rider averages 1.18 m/frame over the
// first 4,000 frames and ranges 0.53..1.75 by segment. The scrub ran a flat 2.0.
//
// THE STATE LIVES OUT HERE, IN ZIG STATICS, AND IT HAS TO. Every Codex record is
// a pointer into the bump arena, and renderFrame rewinds that arena every call
// (PORTING_NOTES C8) -- so a RiderState returned by the transpiled program is
// dangling by the next frame. RiderStateS is flat scalars, so the shim keeps a
// VALUE and passes its address in. Two rules follow and both are load-bearing:
//
//   the world is built ONCE and BEFORE the reset base is captured, so the rewind
//     never reclaims it (it is ~20 segments of trees, herds and cat placements);
//   every returned record is copied out by value before the next rewind.

const CAP_WORDS: usize = (1 << 20) / 4;
var cx_paint: [CAP_WORDS]u32 = undefined;
var cx_paint_high: usize = 0;

var cx_world: ?*CxList(Segment) = null;
var cx_rider: RiderStateS = undefined;
var cx_hp_base: i64 = 0;

// A SHALLOW HISTORY, so the down arrow is not a dead key. The physics has no
// inverse -- you cannot un-integrate a lean search -- and the real game keeps an
// 8192-deep ring for exactly this. 2048 frames is about half the route at the
// speeds measured above, which is plenty for stepping back to look at something.
const HIST: usize = 2048;
var cx_hist: [HIST]RiderStateS = undefined;
var cx_hn: usize = 0;

fn ensure() void {
    if (cx_world != null) return;
    cx_world = build_world();
    cx_rider = initial_rider_state().*;
    // AFTER the world, never before: the rewind goes back to here.
    cx_hp_base = cx_hp;
}

fn restart() void {
    cx_rider = initial_rider_state().*;
    cx_hn = 0;
}

pub export fn renderFrame() u32 {
    ensure();
    cx_hp = cx_hp_base;
    var w: usize = 0;
    const cmds = frame_for(cx_world.?, &cx_rider);
    for (cmds.items.items) |cmd| {
        const pts = cmd.pts.items.items;
        const n = pts.len / 2;
        // tag 3 is a DISC -- [3][color][x][y][r][alpha], six words and no point
        // count, because the blitter draws a true arc for it.
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
        const head: usize = if (cmd.tag == 1) 4 else 3;
        if (w + head + pts.len > CAP_WORDS) break;
        cx_paint[w] = @intCast(cmd.tag);
        cx_paint[w + 1] = @intCast(cmd.color);
        if (cmd.tag == 1) {
            cx_paint[w + 2] = @bitCast(@as(f32, @floatCast(cmd.strength)));
            cx_paint[w + 3] = @intCast(n);
        } else {
            cx_paint[w + 2] = @intCast(n);
        }
        w += head;
        // THE f64 -> f32 NARROWING HAPPENS HERE AND ONLY HERE, the seam the
        // hand-written zig already narrows at.
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

// ONE STEP OF THE REAL RIDER. The screensaver replays rather than stopping, so
// the finish line restarts, which is what safari.zig does.
pub export fn advance() void {
    ensure();
    cx_hp = cx_hp_base;
    if (is_finished(&cx_rider, cx_world.?)) {
        restart();
        return;
    }
    if (cx_hn < HIST) {
        cx_hist[cx_hn] = cx_rider;
        cx_hn += 1;
    }
    cx_rider = get_next_rider_state(&cx_rider, cx_world.?).*;
}

pub export fn back() void {
    ensure();
    if (cx_hn == 0) return;
    cx_hn -= 1;
    cx_rider = cx_hist[cx_hn];
}

// THE LEAN, WHICH THE PAGE USED TO THROW AWAY. blitter.js rotates the whole
// canvas by this, so it is the bank you see going into a corner. The deadband is
// safari.zig's: below a thousandth of a radian it snaps to level rather than
// jittering the canvas about a value that is really zero.
pub export fn riderTilt() f32 {
    ensure();
    const t = cx_rider.tilt;
    return if (@abs(t) < 1.0e-3) 0.0 else @floatCast(t);
}

// J walks until this changes; now it really is the segment index.
pub export fn riderSeg() u32 {
    ensure();
    return @intCast(cx_rider.segment);
}

pub export fn clock() u32 {
    ensure();
    cx_hp = cx_hp_base;
    return @intFromFloat(step_for(cx_world.?, &cx_rider));
}

// Sky, horizon and sun are NOT polygons: blitter.js paints them itself and asks
// the module for the numbers, so they never reach the buffer above. They read the
// rider's own heading now, gaze and head-turn folded in, so the backdrop swings
// with the view exactly as the scene does.
//
// THE SUN GOES THROUGH sun_pos DIRECTLY, not through Drive's `sun-for` wrapper,
// and that is PORTING_NOTES B12 rather than a style choice: a Codex definition
// whose body is a single application is INLINED and never becomes a zig function,
// so `sun-for` does not exist to call from out here. B12's own advice is to write
// the shim against the real functions, and this is that.
fn sunHere() SunPos {
    cx_hp = cx_hp_base;
    return sun_pos(heading_for(&cx_rider), step_for(cx_world.?, &cx_rider), focal(), camera_w());
}
pub export fn skyTop() u32 {
    ensure();
    cx_hp = cx_hp_base;
    return @intCast(sky_color(step_for(cx_world.?, &cx_rider)));
}
pub export fn skyHorizon() u32 {
    ensure();
    cx_hp = cx_hp_base;
    return @intCast(horizon_color(step_for(cx_world.?, &cx_rider)));
}
pub export fn sunVisible() u32 {
    ensure();
    return @intFromBool(sunHere().visible);
}
pub export fn sunX() f32 {
    ensure();
    return @floatCast(sunHere().x);
}
pub export fn sunY() f32 {
    ensure();
    return @floatCast(sunHere().y);
}
pub export fn sunScale() f32 {
    ensure();
    return @floatCast(sunHere().scale);
}

// Extra readouts the blitter's HUD does not know about but a probe can use.
pub export fn riderV() f32 {
    ensure();
    return @floatCast(cx_rider.v_);
}

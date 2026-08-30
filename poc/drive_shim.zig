
// ========================================================================
// THE DRIVE SHIM. Appended to the transpiled program by harness/wasmify.py.
//
// IT IS AN ABI AND NOTHING ELSE NOW. Everything it used to decide -- the step
// order, the restart at the finish, the live focal, the view-yaw fold, the
// frame's own sequence -- is `Safari chapter Safari`, a port of the game's own
// safari.zig. What is left here is what a pure program cannot hold: a value, a
// history ring, and the exported readouts the blitter reads.
//
// Where poc/shim.zig answers every frame from a scrub `u`, this one RUNS THE
// PORTED PHYSICS: `ride-next` a frame, `ride-frame` to draw it.
//
// Measured before the real rider existed: he averages 1.18 m/frame over the
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

// THE CHASE, kept out here for the same reason the rider is: it is state, the
// program is pure, and a record returned by the transpiled side is a pointer into
// an arena that renderFrame rewinds. TruckStateS is three flat scalars -- route
// position, speed, braking -- so the shim holds a VALUE and passes its address.
// The step order is Safari's now, not this file's.
var cx_truck: TruckStateS = undefined;

// A RIDE IS THREE POINTERS AND A NUMBER, so the shim can build one on the stack
// out of its own statics and hand its address in. That is why the flat pieces are
// what live here: `RideS.rider` is a POINTER, and a Ride copied out of the arena
// would dangle at the next rewind, while &cx_rider never moves.
fn cxRide() RideS {
    return .{ .rider = &cx_rider, .truck = &cx_truck, .clock = cx_clock };
}

// Copy a returned ride out by value, BEFORE the next rewind. The one rule this
// file has always had, applied to three fields instead of one.
fn cxSetRide(r: Ride) void {
    cx_rider = r.rider.*;
    cx_truck = r.truck.*;
    cx_clock = r.clock;
}

// THE SUNSET CLOCK, a plain frame count exactly as safari.zig keeps it: it starts
// at 0, gains one per advance and gives one back on the way out, and resets at the
// finish line. Drive used to DERIVE it from route distance, which put the whole
// drive inside a quarter of one sunset starting three quarters of the way in --
// the sky changed by about a shade over thirteen seconds and looked static. The
// sun drops 0.0613 px a frame from 244 to -46, so a sunset is 4,734 frames and the
// route is about 6,400: one drive now takes it from day to dark.
var cx_clock: f64 = 0;

// A SHALLOW HISTORY, so the down arrow is not a dead key. The physics has no
// inverse -- you cannot un-integrate a lean search -- and the real game keeps an
// 8192-deep ring for exactly this. 2048 frames is about half the route at the
// speeds measured above, which is plenty for stepping back to look at something.
const HIST: usize = 2048;
var cx_hist: [HIST]RiderStateS = undefined;
var cx_thist: [HIST]TruckStateS = undefined;
var cx_hn: usize = 0;

fn ensure() void {
    if (cx_world != null) return;
    cx_world = build_world();
    cxSetRide(ride_initial());
    // AFTER the world, never before: the rewind goes back to here.
    cx_hp_base = cx_hp;
}

pub export fn renderFrame() u32 {
    ensure();
    cx_hp = cx_hp_base;
    var w: usize = 0;
    var r = cxRide();
    const cmds = ride_frame(cx_world.?, &r);
    for (cmds.items.items) |cmd| {
        const pts = cmd.pts.items.items;
        const n = pts.len / 2;
        // tag 3 is a DISC -- [3][color][x][y][r][alpha], six words and no point
        // count, because the blitter draws a true arc for it.
        const g = cmd.geom.items.items;
        // A BEACON IS A DISC, NOT A POLYGON -- [3][color][x][y][r][alpha], six
        // words and no point count. Its centre and radius ride in `geom`, which is
        // where every command's own parameters now live; `pts` is always the
        // polygon and a disc has none.
        if (cmd.tag == 3) {
            if (w + 6 > CAP_WORDS) break;
            cx_paint[w] = 3;
            cx_paint[w + 1] = @intCast(cmd.color);
            cx_paint[w + 2] = @bitCast(@as(f32, @floatCast(g[0])));
            cx_paint[w + 3] = @bitCast(@as(f32, @floatCast(g[1])));
            cx_paint[w + 4] = @bitCast(@as(f32, @floatCast(g[2])));
            cx_paint[w + 5] = @bitCast(@as(f32, @floatCast(cmd.strength)));
            w += 6;
            continue;
        }
        // THE GRADIENT FILLS: tag 4 is a radial fill (headlight beams), 5 and 6
        // are 2-stop gradients (the bull's shading). All carry a second colour and
        // their geometry ahead of the point count, and all use 0xAARRGGBB because
        // they composite.
        if (cmd.tag >= 4 and cmd.tag <= 6) {
            const head: usize = 4 + g.len;
            if (w + head + pts.len > CAP_WORDS) break;
            cx_paint[w] = @intCast(cmd.tag);
            cx_paint[w + 1] = @intCast(cmd.color);
            cx_paint[w + 2] = @intCast(cmd.color2);
            for (g, 0..) |v, i| cx_paint[w + 3 + i] = @bitCast(@as(f32, @floatCast(v)));
            cx_paint[w + 3 + g.len] = @intCast(n);
            w += head;
            for (pts) |v| {
                cx_paint[w] = @bitCast(@as(f32, @floatCast(v)));
                w += 1;
            }
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

// ONE STEP OF THE RIDE, which is one call now: `ride-next` folds the rider, the
// truck and the clock together and owns the restart at the finish line.
//
// THE FINISH IS TESTED TWICE AND THAT IS DELIBERATE. Safari restarts the ride;
// this file has to clear the HISTORY RING, which Safari cannot see, so it asks
// the same graded question (`is-finished`) to know a restart happened. The
// alternative -- inferring it from a clock that came back zero -- would be a
// guess about someone else's implementation.
pub export fn advance() void {
    ensure();
    cx_hp = cx_hp_base;
    const finished = is_finished(&cx_rider, cx_world.?);
    if (!finished and cx_hn < HIST) {
        cx_hist[cx_hn] = cx_rider;
        cx_thist[cx_hn] = cx_truck;
        cx_hn += 1;
    }
    var r = cxRide();
    cxSetRide(ride_next(cx_world.?, &r));
    if (finished) cx_hn = 0;
}

pub export fn back() void {
    ensure();
    if (cx_hn == 0) return;
    cx_hn -= 1;
    cx_rider = cx_hist[cx_hn];
    cx_truck = cx_thist[cx_hn];
    if (cx_clock > 0) cx_clock -= 1;
}

// THE LEAN, WHICH THE PAGE USED TO THROW AWAY. blitter.js rotates the whole
// canvas by this, so it is the bank you see going into a corner. The deadband is
// ported now -- `rider-roll` -- rather than being a number repeated out here.
pub export fn riderTilt() f32 {
    ensure();
    cx_hp = cx_hp_base;
    return @floatCast(rider_roll(&cx_rider));
}

// THE LIVE FOCAL, which is what the lens does when he leans or watches the cat
// cross. Exported for the HUD and a probe, exactly as safari.zig exports it.
pub export fn camFocal() f32 {
    ensure();
    cx_hp = cx_hp_base;
    return @floatCast(ride_focal(cx_world.?, &cx_rider));
}

pub export fn gazeYaw() f32 {
    ensure();
    return @floatCast(cx_rider.gaze_yaw);
}

// J walks until this changes; now it really is the segment index.
pub export fn riderSeg() u32 {
    ensure();
    return @intCast(cx_rider.segment);
}

pub export fn clock() u32 {
    ensure();
    return @intFromFloat(cx_clock);
}

// Sky, horizon and sun are NOT polygons: blitter.js paints them itself and asks
// the module for the numbers, so they never reach the buffer above. They read the
// rider's own heading now, gaze and head-turn folded in, so the backdrop swings
// with the view exactly as the scene does.
//
// THE SUN GOES THROUGH `ride-sun`, which reads the same heading the mountains do
// and the same LIVE focal the rest of the frame does -- so a leaned camera cannot
// put the disc somewhere the ranges drawn over it disagree with. It is a real
// function rather than an alias (B12: a body that is one application is inlined
// and never emitted, so there would be nothing out here to call).
fn sunHere() SunPos {
    cx_hp = cx_hp_base;
    var r = cxRide();
    return ride_sun(cx_world.?, &r);
}
pub export fn skyTop() u32 {
    ensure();
    cx_hp = cx_hp_base;
    return @intCast(sky_color(cx_clock));
}
pub export fn skyHorizon() u32 {
    ensure();
    cx_hp = cx_hp_base;
    return @intCast(horizon_color(cx_clock));
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

// THE CHASE, read out the way safari.zig reads it out: the LEAD rather than the
// position, because the lead is what the page is about and the position on its own
// says nothing without the rider's. Negative means the rider is past it.
pub export fn truckLead() f32 {
    ensure();
    cx_hp = cx_hp_base;
    return @floatCast(cx_truck.pos - route_distance(cx_world.?, cx_rider.segment, cx_rider.along));
}

pub export fn truckV() f32 {
    ensure();
    return @floatCast(cx_truck.v_);
}
pub export fn truckBraking() u32 {
    ensure();
    return @intFromBool(cx_truck.braking);
}

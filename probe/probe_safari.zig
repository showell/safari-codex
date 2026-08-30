//! probe_safari -- the oracle for the Safari port: the state fold, the live camera,
//! and the whole frame.
//!
//! THREE STRENGTHS OF ORACLE AGAIN, and which is which matters:
//!
//!   sf-frame*   THE STRONGEST IN THE PROJECT. render.frame is pub and it IS the
//!               frame -- backdrop, ground, and everything that stands up in one
//!               depth order. The probe calls it and reads the words it wrote, so
//!               the port's whole dispatch is compared against the game's own,
//!               command for command. Nothing before this graded the ORDER.
//!   sf-fold     THE DEFINITION. safari.zig's `advance` is private (an export
//!               over private statics with no setter, so it cannot be seeded), but
//!               its body is four calls to pub functions in a fixed order. The
//!               probe composes those four, which is what the port claims to be.
//!               A wrong ORDER -- stepping the truck against the OLD rider
//!               distance -- fails here, and that is the mistake worth catching.
//!   sf-focal    THE DEFINITION likewise, over pub ingredients: cat.focus,
//!               gaze.gazeFocus and camera.camFocal are each a real oracle and are
//!               graded separately, so a failure names the ingredient or the mix.
//!
//! NO TRAJECTORY IS COMPARED, deliberately: NOTES section 4 argues that a step
//! function over f32 against the same over f64 diverges for reasons that are not
//! the port's, and the rider's lean is a binary search, which can take a different
//! branch on the last bit. Every case here is ONE STEP FROM A SHARED STATE.

const std = @import("std");
const world = @import("wasm/world.zig");
const rider = @import("wasm/rider.zig");
const render = @import("wasm/render.zig");
const camera = @import("wasm/camera.zig");
const cat = @import("wasm/cat.zig");
const gaze = @import("wasm/gaze.zig");
const truck = @import("wasm/truck.zig");
const sky = @import("wasm/sky.zig");
const paint = @import("wasm/paint.zig");
const mountains = @import("wasm/mountains.zig");

// safari.zig's own two constants, copied because they are private to it. Both are
// test INPUTS to the composition below rather than expected values -- the numbers
// this probe prints all come from the pub functions they are fed to.
const HEAD_YAW_FRAC: f32 = 0.15;
const ROLL_DEADBAND: f32 = 1.0e-3;

const Case = struct {
    seg: usize,
    along: f32,
    across: f32,
    yaw: f32,
    v: f32,
    tilt: f32,
    heading: f32,
    gaze_yaw: f32,
    focus: f32,
    tpos: f32,
    tv: f32,
    clock: f32,
};

// The eight ride states, chosen as branches of the three things this file grades.
//
//   0  the start line: nothing pulled in, nothing braking, the truck 500 m out.
//   1  segment 1 mid-crossing, where the CAT is -- the one state whose attention
//      comes from cat.focus rather than the gaze.
//   2  the same segment, PAST the cat's landing point, so focus ramps DOWN on the
//      rider's own clock instead of the crossing's.
//   3  a hard lean (17 degrees), so the lean pull-in is what narrows the lens.
//   4  a distraction leg with the gaze half-committed: BOTH terms are non-zero
//      and camFocal has to take the deeper.
//   5  the 1200 m leg at speed with the truck close and braking.
//   6  the pond corner, leaned and gazing, with the truck behind the rider.
//   7  ON THE FINISH LINE, which is the fold's other branch: the ride restarts.
const cases = [_]Case{
    .{ .seg = 0, .along = 0.0, .across = 0.0, .yaw = 0.0, .v = 0.3, .tilt = 0.0, .heading = 0.0, .gaze_yaw = 0.0, .focus = 0.0, .tpos = 500.0, .tv = 0.3, .clock = 0.0 },
    .{ .seg = 1, .along = 600.0, .across = 0.0, .yaw = 0.0, .v = 1.4, .tilt = 0.02, .heading = 0.6, .gaze_yaw = 0.0, .focus = 0.0, .tpos = 1100.0, .tv = 1.5, .clock = 400.0 },
    .{ .seg = 1, .along = 660.0, .across = 0.2, .yaw = 0.01, .v = 1.4, .tilt = 0.0, .heading = 0.6, .gaze_yaw = 0.0, .focus = 0.0, .tpos = 1180.0, .tv = 1.5, .clock = 460.0 },
    .{ .seg = 4, .along = 150.0, .across = -1.2, .yaw = -0.22, .v = 1.1, .tilt = 0.30, .heading = 1.4, .gaze_yaw = 0.04, .focus = 0.0, .tpos = 2100.0, .tv = 1.2, .clock = 1500.0 },
    .{ .seg = 2, .along = 300.0, .across = 0.5, .yaw = 0.05, .v = 0.9, .tilt = 0.06, .heading = 0.9, .gaze_yaw = 0.18, .focus = 0.45, .tpos = 1500.0, .tv = 1.0, .clock = 900.0 },
    .{ .seg = 6, .along = 600.0, .across = 0.0, .yaw = 0.0, .v = 2.4, .tilt = 0.0, .heading = 2.2, .gaze_yaw = 0.0, .focus = 0.0, .tpos = 2900.0, .tv = 2.0, .clock = 2600.0 },
    .{ .seg = 12, .along = 280.0, .across = 0.6, .yaw = -0.30, .v = 1.3, .tilt = -0.24, .heading = 3.1, .gaze_yaw = -0.12, .focus = 0.8, .tpos = 5000.0, .tv = 1.1, .clock = 4200.0 },
    .{ .seg = 18, .along = 299.0, .across = 0.0, .yaw = 0.0, .v = 1.0, .tilt = 0.0, .heading = 4.0, .gaze_yaw = 0.0, .focus = 0.0, .tpos = 7400.0, .tv = 1.0, .clock = 6300.0 },
};

fn riderOf(c: Case) rider.RiderState {
    return .{ .segment = c.seg, .along = c.along, .across = c.across, .yaw = c.yaw, .v = c.v, .tilt = c.tilt, .heading = c.heading, .gaze_yaw = c.gaze_yaw, .focus = c.focus };
}

// safari.zig's catAttention, composed from the pub cat.focus: the crossing cat on
// his CURRENT segment, or nothing when the segment has none.
fn catAttention(w: *const world.World, s: rider.RiderState) f32 {
    const seg = w.segments[s.segment];
    if (!seg.has_cat) return 0;
    return cat.focus(seg.cat.along - s.along, s.v);
}

// safari.zig's renderFrame focal, composed the same way.
fn camFocalOf(w: *const world.World, s: rider.RiderState) f32 {
    const lean_frac = @min(@abs(s.tilt) / rider.MAX_LEAN, 1.0);
    const attention = @max(catAttention(w, s), gaze.gazeFocus(s.focus));
    return camera.camFocal(lean_frac, attention);
}

fn viewYawOf(s: rider.RiderState) f32 {
    return s.gaze_yaw + HEAD_YAW_FRAC * s.tilt;
}

var tag: [8192]u32 = undefined;
var col: [8192]u32 = undefined;
var cnt: [8192]u32 = undefined;
var xy: [65536]f32 = undefined;
var nt: usize = 0;
var nx: usize = 0;

// Walk what paint wrote. Every tag the frame can carry: 0 and 1 are polygons, 3 is
// the beacon disc, 4 to 6 are the gradient fills. `step` thins the COORDINATES
// only -- a frame is 44,000 of them and one Codex Real literal past about 16,868
// exhausts the transpiler's heap (PORTING_NOTES C7) -- while every count is
// recorded whole, so a command that gained or lost a point still fails hard.
fn harvest(step: usize) void {
    const words = paint.frameWords();
    var w: usize = 0;
    while (w < words.len) {
        const t = words[w];
        w += 1;
        tag[nt] = t;
        col[nt] = words[w];
        w += 1;
        if (t == 3) { // a disc: x, y, r, alpha and no point count
            cnt[nt] = 0;
            nt += 1;
            w += 4;
            continue;
        }
        if (t == 1) w += 1;
        if (t == 4) w += 4; // second colour + cx, cy, r
        if (t == 5) w += 7; // second colour + two stops + two axis points
        if (t == 6) w += 9; // second colour + two stops + centre + two axes
        const n = words[w];
        w += 1;
        cnt[nt] = n;
        nt += 1;
        var k: usize = 0;
        while (k < n) : (k += 1) {
            if (k % step == 0) {
                xy[nx] = @bitCast(words[w]);
                xy[nx + 1] = @bitCast(words[w + 1]);
                nx += 2;
            }
            w += 2;
        }
    }
}

pub fn main() void {
    var w = world.buildWorld();
    const course = world.courseLength(&w);

    // ---- the live camera, over the eight states ----
    std.debug.print("R sf-catfocus", .{});
    for (cases) |c| std.debug.print(" {d}", .{catAttention(&w, riderOf(c))});
    std.debug.print("\nR sf-gazefocus", .{});
    for (cases) |c| std.debug.print(" {d}", .{gaze.gazeFocus(c.focus)});
    std.debug.print("\nR sf-focal", .{});
    for (cases) |c| std.debug.print(" {d}", .{camFocalOf(&w, riderOf(c))});
    std.debug.print("\nR sf-viewyaw", .{});
    for (cases) |c| std.debug.print(" {d}", .{viewYawOf(riderOf(c))});
    std.debug.print("\nR sf-roll", .{});
    for (cases) |c| std.debug.print(" {d}", .{if (@abs(c.tilt) < ROLL_DEADBAND) 0.0 else c.tilt});

    // ---- the fold, one step from each shared state ----
    var f_along: [64]f32 = undefined;
    var f_v: [64]f32 = undefined;
    var f_seg: [64]u32 = undefined;
    var f_tpos: [64]f32 = undefined;
    var f_tv: [64]f32 = undefined;
    var f_brake: [64]u32 = undefined;
    var f_clock: [64]f32 = undefined;
    for (cases, 0..) |c, i| {
        const cur = riderOf(c);
        const tk = truck.State{ .pos = c.tpos, .v = c.tv, .braking = false };
        if (rider.isFinished(cur, &w)) {
            const r0 = rider.initialRiderState();
            const t0 = truck.initial();
            f_along[i] = r0.along;
            f_v[i] = r0.v;
            f_seg[i] = @intCast(r0.segment);
            f_tpos[i] = t0.pos;
            f_tv[i] = t0.v;
            f_brake[i] = @intFromBool(t0.braking);
            f_clock[i] = 0;
        } else {
            const nx_ = rider.getNextRiderState(cur, &w);
            const tn = truck.next(tk, world.routeDistance(&w, nx_.segment, nx_.along), &w, course);
            f_along[i] = nx_.along;
            f_v[i] = nx_.v;
            f_seg[i] = @intCast(nx_.segment);
            f_tpos[i] = tn.pos;
            f_tv[i] = tn.v;
            f_brake[i] = @intFromBool(tn.braking);
            f_clock[i] = c.clock + 1;
        }
    }
    std.debug.print("\nR sf-fold-along", .{});
    for (f_along[0..cases.len]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\nR sf-fold-v", .{});
    for (f_v[0..cases.len]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\nI sf-fold-seg", .{});
    for (f_seg[0..cases.len]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\nR sf-fold-tpos", .{});
    for (f_tpos[0..cases.len]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\nR sf-fold-tv", .{});
    for (f_tv[0..cases.len]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\nB sf-fold-brake", .{});
    for (f_brake[0..cases.len]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\nR sf-fold-clock", .{});
    for (f_clock[0..cases.len]) |v| std.debug.print(" {d}", .{v});

    // ---- the whole frame, at two of the states ----
    // TWO, not eight, and the reason is the transpiler rather than the coverage:
    // a frame is about 2,400 commands, and the check's gold is a Codex literal.
    // State 3 is leaned hard (so the live focal is doing something to every
    // projection) and state 5 is the long straight at speed with the truck close.
    const frames = [_]usize{ 3, 5 };
    for (frames) |i| {
        const c = cases[i];
        const s = riderOf(c);
        paint.reset();
        render.frame(&w, s.segment, s.along, s.across, s.yaw, s.heading, c.clock, s.v, camFocalOf(&w, s), viewYawOf(s), .{ .pos = c.tpos, .v = c.tv, .braking = true });
        harvest(24);
    }
    std.debug.print("\nI sf-frame-tag", .{});
    for (tag[0..nt]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\nI sf-frame-col", .{});
    for (col[0..nt]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\nI sf-frame-cnt", .{});
    for (cnt[0..nt]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\nR sf-frame-xy", .{});
    for (xy[0..nx]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\n", .{});
    _ = mountains.sunBehindMountains(0);
    _ = sky.skyColor(0);
}

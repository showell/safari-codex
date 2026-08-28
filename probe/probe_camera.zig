//! probe_camera -- the oracle for the Camera, Geom and Trig ports.
//!
//! Imports the REAL wasm/camera.zig and wasm/geom.zig unmodified and walks a
//! table of inputs, so the hand-written zig is what the Codex is graded against.
//! Seam 1 in NOTES: pure functions of scalars.
//!
//! Line format matches probe_pond.zig: `<kind> <name> <values...>`.

const std = @import("std");
const camera = @import("wasm/camera.zig");
const geom = @import("wasm/geom.zig");

var buf: [512]f32 = undefined;

fn reals(comptime name: []const u8, vals: []const f32) void {
    std.debug.print("R {s}", .{name});
    for (vals) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\n", .{});
}

// The lens constants and the pull-in. camFocal takes the tighter of the lean and
// attention narrowings, so the table crosses over: lean wins at the top, gaze at
// the bottom.
fn lens() void {
    reals("focal", &[_]f32{camera.FOCAL});
    const leans = [_]f32{ 0.0, 0.25, 0.5, 0.75, 1.0 };
    const attns = [_]f32{ 0.0, 0.2, 0.5, 0.9, 1.0, 1.3 };
    var n: usize = 0;
    for (leans) |l| for (attns) |a| {
        buf[n] = camera.camFocal(l, a);
        n += 1;
    };
    reals("cam-focal", buf[0..n]);
}

// The projection, over a spread of depths, offsets and heights -- including a
// point at the near plane, where the divide is at its most violent.
fn projection() void {
    const fwds = [_]f32{ 0.4, 1.0, 3.0, 7.5, 20.0, 63.0, 200.0, 900.0 };
    const rights = [_]f32{ -37.0, -4.0, 0.0, 2.5, 31.0 };
    const heights = [_]f32{ 0.0, 1.2, 5.75 };
    var n: usize = 0;
    for (fwds) |f| for (rights) |r| for (heights) |h| {
        const s = camera.project(.{ .right = r, .forward = f, .height = h }, camera.FOCAL);
        buf[n] = s.x;
        buf[n + 1] = s.y;
        n += 2;
    };
    reals("project", buf[0..n]);
}

fn ground() void {
    const ds = [_][2]f32{ .{ 0, 0 }, .{ 3, 20 }, .{ 300, 900 }, .{ -120, 45.5 }, .{ 1000, 1000 } };
    var n: usize = 0;
    for (ds) |d| {
        buf[n] = geom.groundDrop(d[0], d[1]);
        n += 1;
    }
    reals("ground-drop", buf[0..n]);
}

// The rider transform across a spread of yaws, including negatives and a yaw
// past a quadrant boundary, which is where a folded Taylor sine earns its keep.
fn riderTransform() void {
    const yaws = [_]f32{ 0.0, 0.05, -0.35, 0.9, -1.4, 2.2, -3.0 };
    var n: usize = 0;
    for (yaws) |y| {
        const r = geom.toRider(10.0, 3.0, 2.0, 0.5, y, 4.0);
        buf[n] = r.right;
        buf[n + 1] = r.forward;
        const r2 = geom.toRider(140.0, 7.25, 61.0, -1.5, y, 4.0);
        buf[n + 2] = r2.right;
        buf[n + 3] = r2.forward;
        n += 4;
    }
    reals("to-rider", buf[0..n]);
}

// The frame fusion, both turn directions, and its inverse. curToNext(nextToCur(p))
// should return p -- but the probe prints both legs raw rather than asserting a
// round trip, so a failure says which direction is wrong.
fn fusion() void {
    const thetas = [_]f32{ 0.15, 0.4, -0.25 };
    var n: usize = 0;
    for (thetas) |th| for ([_]bool{ false, true }) |rt| {
        const f = geom.nextToCur(12.0, 3.5, 80.0, th, rt, 8.0);
        buf[n] = f.a;
        buf[n + 1] = f.x;
        const b = geom.curToNext(95.0, 2.0, 80.0, th, rt, 8.0);
        buf[n + 2] = b.a;
        buf[n + 3] = b.x;
        n += 4;
    };
    reals("fusion", buf[0..n]);
}

fn meet() void {
    const m = geom.lineMeet(
        .{ .right = -4, .forward = 0 },
        .{ .right = -4, .forward = 10 },
        .{ .right = -20, .forward = 6 },
        .{ .right = 5, .forward = 9 },
    );
    const m2 = geom.lineMeet(
        .{ .right = 0, .forward = 0 },
        .{ .right = 3, .forward = 7 },
        .{ .right = -8, .forward = 2 },
        .{ .right = 6, .forward = -1 },
    );
    reals("line-meet", &[_]f32{ m.right, m.forward, m2.right, m2.forward });
}

// Near-plane clipping. Four polygons: wholly in front, wholly behind, one
// straddling with a vertex entering, and one straddling the other way -- the
// case that catches an inverted a_in/b_in test, which produces a plausible
// polygon with the wrong vertex count.
fn clipping() void {
    var out: [16]geom.Vec3 = undefined;
    const polys = [_][]const geom.Vec3{
        &[_]geom.Vec3{
            .{ .right = -4, .forward = 5, .height = 0 },
            .{ .right = 4, .forward = 5, .height = 0 },
            .{ .right = 4, .forward = 30, .height = 0 },
        },
        &[_]geom.Vec3{
            .{ .right = -4, .forward = -5, .height = 0 },
            .{ .right = 4, .forward = -5, .height = 0 },
            .{ .right = 4, .forward = -1, .height = 0 },
        },
        &[_]geom.Vec3{
            .{ .right = -4, .forward = -2, .height = 1 },
            .{ .right = 4, .forward = 6, .height = 2 },
            .{ .right = 8, .forward = 20, .height = 3 },
        },
        &[_]geom.Vec3{
            .{ .right = -4, .forward = 12, .height = 1 },
            .{ .right = 4, .forward = -3, .height = 2 },
            .{ .right = 8, .forward = 25, .height = 0 },
            .{ .right = -9, .forward = 0.1, .height = 4 },
        },
    };
    var counts: [8]u32 = undefined;
    var n: usize = 0;
    var c: usize = 0;
    for (polys) |p| {
        const k = geom.clipNear(p, camera.NEAR, &out);
        counts[c] = @intCast(k);
        c += 1;
        for (out[0..k]) |v| {
            buf[n] = v.right;
            buf[n + 1] = v.forward;
            buf[n + 2] = v.height;
            n += 3;
        }
    }
    std.debug.print("I clip-counts", .{});
    for (counts[0..c]) |k| std.debug.print(" {d}", .{k});
    std.debug.print("\n", .{});
    reals("clip-pts", buf[0..n]);
}

pub fn main() void {
    lens();
    projection();
    ground();
    riderTransform();
    fusion();
    meet();
    clipping();
}

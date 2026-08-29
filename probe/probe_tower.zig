//! probe_tower -- the oracle for the Tower port.
//!
//! Seam 3, plus the two pure clock functions. drawFlat writes paint's buffer, so
//! the probe resets, draws, and decodes the wire -- which now carries a TAG 3
//! beacon as well as solid quads, and the beacon is the first non-polygon command
//! this port has produced.
//!
//! THE CASES ARE BRANCHES, and tower.zig has several that hide:
//!   near      a tower close enough that its rods straddle the near plane, which
//!             is the whole reason bar3d clips in 3D rather than on screen.
//!   mid       the ordinary case: all four legs, three rings, both brace stages.
//!   far       far enough that the ground drop eats the lower stages, so rings and
//!             braces below the drop are skipped and the leg starts part-way up.
//!   sunk      drop >= TOWER_HEIGHT: below the horizon, nothing drawn at all.
//!   behind    centre nearer than NEAR: nothing drawn at all.
//! and the beacon is sampled at phases that are dark, mid and full bright, plus a
//! NEGATIVE phase -- the clock runs backwards on reverse, which is the only reason
//! the modulo has to be the floored one.

const std = @import("std");
const camera = @import("wasm/camera.zig");
const geom = @import("wasm/geom.zig");
const paint = @import("wasm/paint.zig");
const tower = @import("wasm/tower.zig");

var tags: [512]u32 = undefined;
var colors: [512]u32 = undefined;
var counts: [512]u32 = undefined;
var strengths: [512]f32 = undefined;
var coords: [16384]f32 = undefined;
var nt: usize = 0;
var nc: usize = 0;
var per_case: [16]u32 = undefined;
var ncase: usize = 0;

fn harvest() void {
    const words = paint.frameWords();
    var w: usize = 0;
    while (w < words.len) {
        const tag = words[w];
        w += 1;
        colors[nt] = words[w];
        w += 1;
        if (tag == 3) {
            // [3][color][x][y][r][alpha] -- a disc, not a polygon
            tags[nt] = tag;
            counts[nt] = 3; // x, y, r ride where the points would
            coords[nc] = @bitCast(words[w]);
            coords[nc + 1] = @bitCast(words[w + 1]);
            coords[nc + 2] = @bitCast(words[w + 2]);
            strengths[nt] = @bitCast(words[w + 3]);
            nc += 3;
            w += 4;
            nt += 1;
            continue;
        }
        var strength: f32 = 0;
        if (tag == 1) {
            strength = @bitCast(words[w]);
            w += 1;
        }
        const n = words[w];
        w += 1;
        tags[nt] = tag;
        strengths[nt] = strength;
        counts[nt] = n;
        nt += 1;
        var i: usize = 0;
        while (i < n * 2) : (i += 1) {
            coords[nc] = @bitCast(words[w]);
            nc += 1;
            w += 1;
        }
    }
}

fn towerAt(a0: f32, x0: f32, yaw: f32, forward: f32, right: f32) struct { base: [4]geom.RiderPt, center: geom.RiderPt } {
    // Place the four corners directly in the rider frame: the port is handed them
    // already mapped, exactly as render.zig hands them over.
    var base: [4]geom.RiderPt = undefined;
    var k: usize = 0;
    while (k < 4) : (k += 1) {
        const ax = tower.baseCornerAX(k, a0, x0, yaw);
        base[k] = .{ .right = right + (ax.x - x0), .forward = forward + (ax.a - a0) };
    }
    return .{ .base = base, .center = .{ .right = right, .forward = forward } };
}

pub fn main() void {
    std.debug.print("R tw-offset", .{});
    for ([_]usize{ 0, 1, 2, 3, 7, 12, 40, 119, 120, 121 }) |n| {
        std.debug.print(" {d}", .{tower.beaconOffsetFor(n)});
    }

    const Case = struct { fwd: f32, right: f32, yaw: f32, phase: f32 };
    const cases = [_]Case{
        .{ .fwd = 14.0, .right = 9.0, .yaw = 0.4, .phase = 60.0 }, // near: rods straddle NEAR
        .{ .fwd = 120.0, .right = -30.0, .yaw = 0.0, .phase = 30.0 }, // mid
        .{ .fwd = 900.0, .right = 60.0, .yaw = 1.1, .phase = 0.0 }, // far: drop eats lower stages
        .{ .fwd = 1700.0, .right = 0.0, .yaw = 0.0, .phase = 90.0 }, // far, deeper drop
        .{ .fwd = 3000.0, .right = 0.0, .yaw = 0.0, .phase = 60.0 }, // sunk below the horizon
        .{ .fwd = 0.2, .right = 0.0, .yaw = 0.0, .phase = 60.0 }, // behind the near plane
        .{ .fwd = 120.0, .right = -30.0, .yaw = 0.0, .phase = -45.0 }, // NEGATIVE phase
    };
    for (cases) |c| {
        paint.reset();
        const before = nt;
        const t = towerAt(0.0, 0.0, c.yaw, c.fwd, c.right);
        tower.drawFlat(t.base, t.center, camera.FOCAL, c.phase);
        harvest();
        // per case, so "sunk" and "behind" have to prove they drew NOTHING rather
        // than merely not showing up in a total
        per_case[ncase] = @intCast(nt - before);
        ncase += 1;
    }

    std.debug.print("\nI tw-percase", .{});
    for (per_case[0..ncase]) |v| std.debug.print(" {d}", .{v});

    std.debug.print("\nI tw-tags", .{});
    for (tags[0..nt]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\nI tw-colors", .{});
    for (colors[0..nt]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\nI tw-counts", .{});
    for (counts[0..nt]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\nR tw-strengths", .{});
    for (strengths[0..nt]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\nR tw-coords", .{});
    for (coords[0..nc]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\n", .{});
}

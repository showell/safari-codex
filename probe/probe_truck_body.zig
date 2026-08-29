//! probe_truck_body -- the oracle for the TruckBody port, the truck as it is SEEN.
//!
//! truck.drawBody IS pub, so this is a REAL oracle: the probe calls the game's own
//! function and reads the words it put on paint's wire. render.at is pub too, and
//! it is the only render entry drawBody needs, so nothing here is composed by hand
//! -- unlike probe_render, which has to mirror a private buildChain. That mirror is
//! still needed to BUILD the chain (it is private), and it is the same walk over
//! the real world's exit_to and terminates that probe_render uses.
//!
//! The cases are the branches, not coverage:
//!
//!   d = 0, mid-distance    the plain case: sixteen opaque faces, nothing else.
//!   the same, lit + braking two wedges before the body, two halo + core pairs
//!                          after it -- the full command sequence.
//!   d = 1 across a 50 turn the join composition, so a wrong `at` bends the box.
//!   d = 2 from segment 3   two joins deep, with the rider off centre and yawed.
//!   fifteen metres ahead   near geometry: big screen coordinates, wide beams.
//!   two metres ahead       the trailer rear is BEHIND the eye, so the near clip
//!                          fires on the faces and the wedges drop whole.

const std = @import("std");
const world = @import("wasm/world.zig");
const render = @import("wasm/render.zig");
const paint = @import("wasm/paint.zig");
const camera = @import("wasm/camera.zig");
const truck = @import("wasm/truck.zig");

// COPIED from render.zig's private consts, exactly as probe_render copies them.
const LOOK_AHEAD: usize = 7;
const MAX_CHAIN: usize = 8;

var tag: [1024]u32 = undefined;
var col: [1024]u32 = undefined;
var col2: [1024]u32 = undefined;
var cnt: [1024]u32 = undefined;
var geo: [1024]f32 = undefined;
var xy: [32768]f32 = undefined;
var nt: usize = 0;
var ng: usize = 0;
var nx: usize = 0;

// The chain walk, over the REAL world's exit_to and terminates. Mirrors buildChain,
// which is private; the two caps are the copied values.
fn chainOf(w: *const world.World, start: usize) render.Chain {
    var ch = render.Chain{ .idx = undefined, .len = 0 };
    var s = start;
    while (ch.len < LOOK_AHEAD and ch.len < MAX_CHAIN) {
        ch.idx[ch.len] = s;
        ch.len += 1;
        if (w.segments[s].terminates) break;
        s = w.segments[s].exit_to;
    }
    return ch;
}

// Walk what paint just wrote. Two shapes reach the wire here: tag 0 is
// [0][color][n][x,y...] and tag 4 is [4][rgba_core][rgba_edge][cx][cy][r][n][x,y...].
// The gradient's own three numbers go to their own stream, so a beam that lost its
// centre fails on `tb-geom` and not on a coordinate somewhere in the middle.
fn harvest() void {
    const words = paint.frameWords();
    var w: usize = 0;
    while (w < words.len) {
        const t = words[w];
        w += 1;
        tag[nt] = t;
        col[nt] = words[w];
        w += 1;
        if (t == 4) {
            col2[nt] = words[w];
            w += 1;
            var k: usize = 0;
            while (k < 3) : (k += 1) {
                geo[ng] = @bitCast(words[w]);
                ng += 1;
                w += 1;
            }
        } else {
            col2[nt] = 0;
        }
        const n = words[w];
        w += 1;
        cnt[nt] = n;
        nt += 1;
        var k: usize = 0;
        while (k < n) : (k += 1) {
            xy[nx] = @bitCast(words[w]);
            xy[nx + 1] = @bitCast(words[w + 1]);
            nx += 2;
            w += 2;
        }
    }
}

pub fn main() void {
    var w = world.buildWorld();

    const Case = struct {
        start: usize,
        along: f32,
        across: f32,
        yaw: f32,
        d: usize,
        center: f32,
        braking: bool,
        headlights: bool,
    };
    const cases = [_]Case{
        .{ .start = 0, .along = 100.0, .across = 0.0, .yaw = 0.0, .d = 0, .center = 250.0, .braking = false, .headlights = false },
        .{ .start = 0, .along = 100.0, .across = 0.0, .yaw = 0.0, .d = 0, .center = 250.0, .braking = true, .headlights = true },
        .{ .start = 0, .along = 460.0, .across = 0.8, .yaw = -0.06, .d = 1, .center = 160.0, .braking = true, .headlights = true },
        .{ .start = 2, .along = 50.0, .across = -1.1, .yaw = 0.12, .d = 2, .center = 200.0, .braking = false, .headlights = false },
        .{ .start = 0, .along = 100.0, .across = 0.3, .yaw = 0.0, .d = 0, .center = 115.0, .braking = true, .headlights = true },
        .{ .start = 0, .along = 100.0, .across = 0.0, .yaw = 0.0, .d = 0, .center = 102.0, .braking = true, .headlights = true },
    };

    for (cases) |c| {
        const ch = chainOf(&w, c.start);
        const pose = render.Pose{ .along = c.along, .across = c.across, .yaw = c.yaw, .hw = w.segments[ch.idx[0]].width / 2.0 };
        const hw = w.segments[ch.idx[c.d]].width / 2.0;
        paint.reset();
        truck.drawBody(&w, &ch, pose, c.d, c.center, hw, c.braking, c.headlights, camera.FOCAL);
        harvest();
    }

    std.debug.print("I tb-tag", .{});
    for (tag[0..nt]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\nI tb-col", .{});
    for (col[0..nt]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\nI tb-col2", .{});
    for (col2[0..nt]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\nI tb-cnt", .{});
    for (cnt[0..nt]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\nR tb-geom", .{});
    for (geo[0..ng]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\nR tb-xy", .{});
    for (xy[0..nx]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\n", .{});
}

//! probe_guard_rail -- the oracle for the GuardRail port.
//!
//! Two seams in one probe, because guard_rail.zig is deliberately two halves.
//!
//! emit() is seam 2 on a structure: it COLLECTS RailPolys rather than drawing, so
//! the probe reads the store directly -- colours, the mean forward depth each poly
//! sorts by, and every corner coordinate. That depth is guard_rail's whole
//! contribution to render's unified back-to-front pass, so it is graded, not
//! merely used.
//!
//! drawPoly() is seam 3: it writes wasm/paint.zig's real buffer, so the probe
//! resets paint, draws the store in store order, and decodes the words the game
//! actually put on the wire.
//!
//! The cases are branches, not coverage:
//!   corner  -- a realistic outer-corner path: run-up, both legs, run-out.
//!   dupe    -- a path with a REPEATED point, so the post's run length is exactly
//!              zero and the `if (len == 0) len = 1` fallback fires. That test is
//!              bitwise in the zig and must be bitwise in the port.
//!   near    -- a path running from behind the eye to well ahead, so clipNear
//!              splits quads and drops the ones entirely behind.
//!   single  -- one point: path.len < 2, so emit must produce nothing at all.

const std = @import("std");
const geom = @import("wasm/geom.zig");
const camera = @import("wasm/camera.zig");
const paint = @import("wasm/paint.zig");
const guard_rail = @import("wasm/guard_rail.zig");

var counts_polys: [64]u32 = undefined;
var colors: [4096]u32 = undefined;
var fwds: [4096]f32 = undefined;
var verts: [32768]f32 = undefined;
var np: usize = 0;
var nv: usize = 0;

var tags: [4096]u32 = undefined;
var wire_counts: [4096]u32 = undefined;
var coords: [65536]f32 = undefined;
var nt: usize = 0;
var nc: usize = 0;

// Walk the buffer paint just filled and split it into the streams the Codex side
// can produce: integers compare exactly, reals with the width tolerance.
fn harvest() void {
    const words = paint.frameWords();
    var w: usize = 0;
    while (w < words.len) {
        const tag = words[w];
        w += 1;
        _ = words[w]; // colour, already graded off the store
        w += 1;
        if (tag == 1) w += 1; // rails are never gradient-filled; skip a strength if one ever appears
        const n = words[w];
        w += 1;
        tags[nt] = tag;
        wire_counts[nt] = n;
        nt += 1;
        var i: usize = 0;
        while (i < n * 2) : (i += 1) {
            coords[nc] = @bitCast(words[w]);
            nc += 1;
            w += 1;
        }
    }
}

var store: guard_rail.RailStore = .{};

fn run(path: []const geom.RiderPt, case: usize) void {
    store.reset();
    guard_rail.emit(&store, path);
    counts_polys[case] = @intCast(store.n);
    var i: usize = 0;
    while (i < store.n) : (i += 1) {
        const rp = store.polys[i];
        colors[np] = rp.color;
        fwds[np] = rp.fwd;
        np += 1;
        for (rp.v) |v| {
            verts[nv] = v.right;
            verts[nv + 1] = v.forward;
            verts[nv + 2] = v.height;
            nv += 3;
        }
    }
    paint.reset();
    i = 0;
    while (i < store.n) : (i += 1) guard_rail.drawPoly(store.polys[i], camera.FOCAL);
    harvest();
}

pub fn main() void {
    // a realistic outer-corner path: run-up along the outer shoulder, into the
    // apex, out of it, and the run-out
    const corner = [_]geom.RiderPt{
        .{ .right = 6.0, .forward = 44.0 },
        .{ .right = 6.0, .forward = 34.0 },
        .{ .right = 6.0, .forward = 24.0 },
        .{ .right = 7.4, .forward = 17.5 },
        .{ .right = 11.0, .forward = 13.0 },
        .{ .right = 17.0, .forward = 11.4 },
        .{ .right = 27.0, .forward = 11.4 },
    };
    // a repeated point: the post at index 1 sees a == b, so its run length is
    // exactly zero and the fallback direction fires
    const dupe = [_]geom.RiderPt{
        .{ .right = -4.0, .forward = 20.0 },
        .{ .right = -4.0, .forward = 12.0 },
        .{ .right = -4.0, .forward = 20.0 },
        .{ .right = -4.5, .forward = 6.0 },
    };
    // straddling the near plane: the first quads are entirely behind the eye and
    // must be dropped, one is split, the rest survive
    const near = [_]geom.RiderPt{
        .{ .right = 3.0, .forward = -12.0 },
        .{ .right = 3.0, .forward = -4.0 },
        .{ .right = 3.0, .forward = 0.2 },
        .{ .right = 3.2, .forward = 6.0 },
        .{ .right = 3.6, .forward = 30.0 },
    };
    const single = [_]geom.RiderPt{.{ .right = 2.0, .forward = 9.0 }};

    run(&corner, 0);
    run(&dupe, 1);
    run(&near, 2);
    run(&single, 3);

    std.debug.print("I rail-polys", .{});
    for (counts_polys[0..4]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\nI rail-colors", .{});
    for (colors[0..np]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\nR rail-fwd", .{});
    for (fwds[0..np]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\nR rail-verts", .{});
    for (verts[0..nv]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\nI rail-tags", .{});
    for (tags[0..nt]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\nI rail-counts", .{});
    for (wire_counts[0..nt]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\nR rail-coords", .{});
    for (coords[0..nc]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\n", .{});
}

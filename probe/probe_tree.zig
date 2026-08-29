//! probe_tree -- the oracle for the Tree and Paint ports.
//!
//! Unlike the camera probe, this one does NOT read return values: tree.draw writes
//! into wasm/paint.zig's real buffer. So the probe resets paint, draws, and decodes
//! the words the game actually put on the wire. That grades the geometry and the
//! WIRE FORMAT together -- tags, colours, strengths, point counts and coordinates --
//! which is seam 3 on one object rather than seam 1.
//!
//! The cases are chosen for the branches, not for coverage: a far tree (flat
//! triangles), a near tree (cone hulls), a tree close enough that the nearest tiers
//! bail from cone back to triangle, and a tree too small to draw at all.

const std = @import("std");
const camera = @import("wasm/camera.zig");
const paint = @import("wasm/paint.zig");
const tree = @import("wasm/tree.zig");

var tags: [512]u32 = undefined;
var colors: [512]u32 = undefined;
var counts: [512]u32 = undefined;
var strengths: [512]f32 = undefined;
var coords: [8192]f32 = undefined;
var nt: usize = 0;
var nc: usize = 0;

// Walk the buffer paint just filled and split it into the four streams the Codex
// side can produce: integers compare exactly, reals with a tolerance.
fn harvest() void {
    const words = paint.frameWords();
    var w: usize = 0;
    while (w < words.len) {
        const tag = words[w];
        w += 1;
        const color = words[w];
        w += 1;
        var strength: f32 = 0;
        if (tag == 1) {
            strength = @bitCast(words[w]);
            w += 1;
        }
        const n = words[w];
        w += 1;
        tags[nt] = tag;
        colors[nt] = color;
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

const Case = struct { right: f32, forward: f32, height: f32, color: u32, round: bool, near: bool, shade: f32 };

pub fn main() void {
    const cases = [_]Case{
        // far: flat triangles, flat bar trunk
        .{ .right = -9.0, .forward = 140.0, .height = 7.0, .color = 0x2f6d3a, .round = false, .near = false, .shade = 0.0 },
        // mid: cone crowns, flat bar trunk, partial shade
        .{ .right = 12.0, .forward = 46.0, .height = 8.5, .color = 0x2f6d3a, .round = false, .near = true, .shade = 0.45 },
        // near: cone crowns AND a round-shaded trunk
        .{ .right = -5.5, .forward = 11.0, .height = 6.25, .color = 0x35793f, .round = true, .near = true, .shade = 1.0 },
        // very close: the widest tiers' cone bases cross MIN_CONE_FORWARD and bail
        // back to flat triangles, so one tree emits both crown forms
        .{ .right = 1.5, .forward = 2.0, .height = 9.0, .color = 0x2f6d3a, .round = true, .near = true, .shade = 1.0 },
        // too small to draw: metrics.ht < 1, so nothing at all is emitted
        .{ .right = 40.0, .forward = 4000.0, .height = 6.0, .color = 0x2f6d3a, .round = false, .near = false, .shade = 0.0 },
    };

    for (cases) |c| {
        paint.reset();
        tree.draw(c.right, c.forward, c.height, c.color, camera.FOCAL, c.round, c.near, c.shade);
        harvest();
    }

    std.debug.print("I tree-tags", .{});
    for (tags[0..nt]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\nI tree-colors", .{});
    for (colors[0..nt]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\nI tree-counts", .{});
    for (counts[0..nt]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\nR tree-strengths", .{});
    for (strengths[0..nt]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\nR tree-coords", .{});
    for (coords[0..nc]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\n", .{});
}

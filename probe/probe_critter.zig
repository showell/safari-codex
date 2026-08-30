//! probe_critter -- the oracle for Critter over EmojiStills.
//!
//! SPLIT PER TABLE, and the split is a toolchain constraint rather than a design.
//! The two generated still tables are 216 KB and 534 KB of Codex literals. Bundled
//! together into one check, codexzig ABORTS -- a core dump, not a diagnostic, and
//! not the deck running out either: it died with 68 MB used of 512 MB reserved.
//! Each table alone transpiles comfortably. So there is one check per table.
//! PORTING_NOTES C7 has shaped this port's tolerances before; this is the second
//! time it has shaped its STRUCTURE.
//!
//! critter.draw IS pub, so this is a real oracle. ALL EIGHT SPECIES ARE HERE NOW.
//! The bull used to be excluded: it is the only Fluent COLOR animal and 40 of its
//! 43 polygons carry a 2-stop gradient, which paint.zig writes as wire tags 5 and
//! 6, and while Paint modelled 0, 1 and 3 the generated table flattened each
//! gradient to its first stop -- so grading it would have compared two different
//! wire shapes and proved nothing. Paint has the tags, the table carries the
//! stops, and the bull is the case that exercises both.
//!
//! ITS GRADIENT GEOMETRY GETS ITS OWN STREAM (cr-geom), because that is where a
//! wrong answer would hide: a gradient's axis is a VECTOR and its centre is a
//! POINT, and mapping an axis as a point still produces a polygon of exactly the
//! right shape with the shading anchored to the wrong place.

const std = @import("std");
const camera = @import("wasm/camera.zig");
const paint = @import("wasm/paint.zig");
const critter = @import("wasm/critter.zig");

var tag: [2048]u32 = undefined;
var col: [2048]u32 = undefined;
var col2: [2048]u32 = undefined;
var cnt: [2048]u32 = undefined;
var geo: [4096]f32 = undefined;
var xy: [131072]f32 = undefined;
var nt: usize = 0;
var ng: usize = 0;
var nx: usize = 0;

// Walk what paint just wrote. `step` thins the coordinates: 1 keeps every point,
// 3 keeps every third. The cat's seven stills are 13,453 points and codexzig
// exhausts its bump heap on a Real literal past about 16,868, so its stream is
// thinned while the animals' is not. Point COUNTS are recorded whole either way,
// so a still that gained or lost a polygon still fails hard.
fn harvest(step: usize) void {
    const words = paint.frameWords();
    var w: usize = 0;
    while (w < words.len) {
        const t = words[w];
        w += 1;
        tag[nt] = t;
        col[nt] = words[w];
        w += 1;
        col2[nt] = 0;
        if (t == 1) w += 1;
        // tags 5 and 6 carry a second colour then their own geometry ahead of the
        // point count: two stop offsets plus an axis pair (5) or a centre and two
        // axis vectors (6).
        if (t == 5 or t == 6) {
            col2[nt] = words[w];
            w += 1;
            const ngeom: usize = if (t == 5) 6 else 8;
            var q: usize = 0;
            while (q < ngeom) : (q += 1) {
                geo[ng] = @bitCast(words[w]);
                ng += 1;
                w += 1;
            }
        }
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
    const animals = [_]struct { cp: u32, h: f32, fwd: f32, face: bool }{
        .{ .cp = 0x1F986, .h = 0.9, .fwd = 14.0, .face = false },
        .{ .cp = 0x1F418, .h = 2.8, .fwd = 40.0, .face = true },
        .{ .cp = 0x1F992, .h = 4.5, .fwd = 90.0, .face = false },
        .{ .cp = 0x1F993, .h = 1.6, .fwd = 25.0, .face = true },
        .{ .cp = 0x1F98F, .h = 2.2, .fwd = 60.0, .face = false },
        .{ .cp = 0x1F404, .h = 1.4, .fwd = 18.0, .face = true },
        .{ .cp = 0x1F416, .h = 1.1, .fwd = 9.0, .face = false },
        .{ .cp = 0x1F402, .h = 1.7, .fwd = 22.0, .face = false }, // the bull: 40 gradient polys
        .{ .cp = 0x1F402, .h = 1.7, .fwd = 22.0, .face = true }, // and mirrored, which flips its axes
    };
    // THE BULL'S COORDINATES ARE THINNED AND THE OTHER SEVEN ARE NOT. Adding it
    // took the stream from 5,916 Reals to 15,152, which is close enough to C7's
    // ~16,868-literal ceiling to be asking for the abort. Every third point of the
    // bull keeps its counts, colours and gradient geometry exact -- the parts that
    // say whether the gradient arm is right -- and thins only the density of art
    // that is graded exactly for seven other species by the same code path.
    for (animals) |a| {
        paint.reset();
        critter.draw(2.5, a.fwd, a.h, a.cp, a.face, camera.FOCAL);
        harvest(if (a.cp == 0x1F402) 3 else 1);
    }
    std.debug.print("I cr-tag", .{});
    for (tag[0..nt]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\nI cr-col", .{});
    for (col[0..nt]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\nI cr-col2", .{});
    for (col2[0..nt]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\nI cr-cnt", .{});
    for (cnt[0..nt]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\nR cr-geom", .{});
    for (geo[0..ng]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\nR cr-xy", .{});
    for (xy[0..nx]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\n", .{});
}

//! probe_cat_draw -- the oracle for CatDraw over CatStills.
//!
//! SPLIT PER TABLE, and the split is a toolchain constraint rather than a design.
//! The two generated still tables are 216 KB and 534 KB of Codex literals. Bundled
//! together into one check, codexzig ABORTS -- a core dump, not a diagnostic, and
//! not the deck running out either: it died with 68 MB used of 512 MB reserved.
//! Each table alone transpiles comfortably. So there is one check per table.
//! PORTING_NOTES C7 has shaped this port's tolerances before; this is the second
//! time it has shaped its STRUCTURE.
//!
//! cat.draw IS pub, so this is a real oracle. All seven stills, two of them
//! airborne so the HOP is exercised at two depths: it is applied in the UNIT FRAME,
//! added to each polygon's own y before scaling, so reading it as a metres offset
//! to the anchor looks nearly right up close and drifts wrong with range.

const std = @import("std");
const camera = @import("wasm/camera.zig");
const paint = @import("wasm/paint.zig");
const cat = @import("wasm/cat.zig");

var tag: [2048]u32 = undefined;
var col: [2048]u32 = undefined;
var cnt: [2048]u32 = undefined;
var xy: [131072]f32 = undefined;
var nt: usize = 0;
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
        if (t == 1) w += 1;
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
    const cats = [_]struct { pose: usize, fwd: f32, lift: f32 }{
        .{ .pose = 0, .fwd = 12.0, .lift = 0.0 },
        .{ .pose = 1, .fwd = 20.0, .lift = 0.0 },
        .{ .pose = 2, .fwd = 8.0, .lift = 0.0 },
        .{ .pose = 3, .fwd = 30.0, .lift = 0.0 },
        .{ .pose = 4, .fwd = 15.0, .lift = 0.18 },
        .{ .pose = 5, .fwd = 25.0, .lift = 0.09 },
        .{ .pose = 6, .fwd = 40.0, .lift = 0.0 },
    };
    for (cats) |c| {
        paint.reset();
        cat.draw(1.5, c.fwd, 1.7, c.pose, c.lift, camera.FOCAL);
        harvest(3);
    }
    std.debug.print("I kd-tag", .{});
    for (tag[0..nt]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\nI kd-col", .{});
    for (col[0..nt]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\nI kd-cnt", .{});
    for (cnt[0..nt]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\nR kd-xy", .{});
    for (xy[0..nx]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\n", .{});
}

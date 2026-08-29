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
//! critter.draw IS pub, so this is a real oracle. THE BULL IS DELIBERATELY ABSENT:
//! it is the only Fluent COLOR animal and 40 of its 43 polygons carry a 2-stop
//! gradient, which paint.zig writes as wire tags 5 and 6. Paint models 0, 1 and 3,
//! so the generated table flattens each gradient to its first stop and the port
//! emits tag 0 where the game emits 5 or 6. Grading it would compare two different
//! wire shapes and prove nothing. The seven FLAT species below are exact.

const std = @import("std");
const camera = @import("wasm/camera.zig");
const paint = @import("wasm/paint.zig");
const critter = @import("wasm/critter.zig");

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
    const animals = [_]struct { cp: u32, h: f32, fwd: f32, face: bool }{
        .{ .cp = 0x1F986, .h = 0.9, .fwd = 14.0, .face = false },
        .{ .cp = 0x1F418, .h = 2.8, .fwd = 40.0, .face = true },
        .{ .cp = 0x1F992, .h = 4.5, .fwd = 90.0, .face = false },
        .{ .cp = 0x1F993, .h = 1.6, .fwd = 25.0, .face = true },
        .{ .cp = 0x1F98F, .h = 2.2, .fwd = 60.0, .face = false },
        .{ .cp = 0x1F404, .h = 1.4, .fwd = 18.0, .face = true },
        .{ .cp = 0x1F416, .h = 1.1, .fwd = 9.0, .face = false },
    };
    for (animals) |a| {
        paint.reset();
        critter.draw(2.5, a.fwd, a.h, a.cp, a.face, camera.FOCAL);
        harvest(1);
    }
    std.debug.print("I cr-tag", .{});
    for (tag[0..nt]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\nI cr-col", .{});
    for (col[0..nt]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\nI cr-cnt", .{});
    for (cnt[0..nt]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\nR cr-xy", .{});
    for (xy[0..nx]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\n", .{});
}

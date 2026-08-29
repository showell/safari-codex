//! probe_mountains -- the oracle for the Mountains port.
//!
//! Two seams again. The scalar functions are seam 1 and are walked over a table
//! of bearings; draw() is seam 3 and writes paint's real buffer, so the probe
//! resets paint, draws, and decodes the wire.
//!
//! THE COLOURS ARE GRADED EXACTLY, as in sky: dimmed() and snowColor() round and
//! pack, which is the work real-to-int unblocked. A dimmed rock one off is a
//! wrong rock.
//!
//! The bearings are chosen for the shape: dead ahead (the north range's peak),
//! the north range's edges where the envelope reaches zero, the west range's
//! centre and its edges, the wrap boundary near +/-pi, and the sun's own bearing
//! which is what sunBehindMountains asks about.
//!
//! The frame cases exercise the branches that matter: a plain forward view, a
//! heading swung onto the west range, a pulled-in focal (which changes both the
//! angular span and v_scale), and full night, where the snow band can vanish.

const std = @import("std");
const camera = @import("wasm/camera.zig");
const paint = @import("wasm/paint.zig");
const sky = @import("wasm/sky.zig");
const mountains = @import("wasm/mountains.zig");

var tags: [64]u32 = undefined;
var colors: [64]u32 = undefined;
var counts: [64]u32 = undefined;
var coords: [65536]f32 = undefined;
var nt: usize = 0;
var nc: usize = 0;

fn harvest() void {
    const words = paint.frameWords();
    var w: usize = 0;
    while (w < words.len) {
        const tag = words[w];
        w += 1;
        colors[nt] = words[w];
        w += 1;
        if (tag == 1) w += 1;
        const n = words[w];
        w += 1;
        tags[nt] = tag;
        counts[nt] = n;
        nt += 1;
        // EVERY 8th POINT, not every point. A silhouette is 683 points and
        // four frames come to 16,868 coordinates, which is a 139 KB gold and a
        // 187 KB unit -- and codexzig exhausts its own 4 GiB bump heap on a Real
        // literal that size ("cx heap: exhausted at 4294926367 of 4294967296").
        // The heap never reclaims (PORTING_NOTES C6), so this is a ceiling on
        // how much gold one unit can carry, not a slow build.
        //
        // Striding is the right thing to give up. The point COUNTS are still
        // graded exactly, so a silhouette that gained or lost a column is still
        // a hard failure; what thins out is only the density of a curve that is
        // smooth by construction. Every range function, the arc tangent, the
        // bearing mapping and v_scale all still show up in 86 samples per poly.
        var i: usize = 0;
        while (i < n) : (i += 8) {
            coords[nc] = @bitCast(words[w + i * 2]);
            coords[nc + 1] = @bitCast(words[w + i * 2 + 1]);
            nc += 2;
        }
        w += n * 2;
    }
}

const BEARINGS = [_]f32{
    0.0,     0.2,     -0.2,    0.5,     0.94,   -0.94,   0.96,   -0.96,
    -2.0416, -1.7,    -2.4,    -2.76,   -1.32,
    -2.2176, // the sun's bearing
    3.0,     -3.0,    3.14,    -3.14,   1.5,    -1.5,
};

pub fn main() void {
    // northRange/westRange/groundBase are private; the crest is the public face
    // of all three, and the silhouette coordinates below trace each of them over
    // 681 columns, which is where they are really graded.
    std.debug.print("R mt-crest", .{});
    for (BEARINGS) |b| std.debug.print(" {d}", .{mountains.horizonCrestPx(b)});

    // colours across the dusk clock, exact
    const DUSKS = [_]f32{ 0.0, 0.1, 0.25, 0.5, 0.75, 0.9, 1.0 };
    std.debug.print("\nI mt-rock", .{});
    for (DUSKS) |d| {
        paint.reset();
        mountains.draw(0.0, d, camera.FOCAL);
        const words = paint.frameWords();
        std.debug.print(" {d}", .{words[1]}); // first poly is the west range
    }
    std.debug.print("\nB mt-sun-behind", .{});
    for ([_]f32{ 0.0, 2000.0, 3500.0, 3900.0, 4000.0, 4300.0, 5000.0, 8000.0 }) |s| {
        std.debug.print(" {d}", .{@intFromBool(mountains.sunBehindMountains(s))});
    }

    const Case = struct { heading: f32, dusk: f32, focal: f32 };
    const cases = [_]Case{
        .{ .heading = 0.0, .dusk = 0.0, .focal = camera.FOCAL },
        .{ .heading = -2.0416, .dusk = 0.35, .focal = camera.FOCAL },
        .{ .heading = 0.6, .dusk = 0.6, .focal = camera.FOCAL * 0.45 },
        .{ .heading = 0.0, .dusk = 1.0, .focal = camera.FOCAL },
    };
    for (cases) |c| {
        paint.reset();
        mountains.draw(c.heading, c.dusk, c.focal);
        harvest();
    }

    std.debug.print("\nI mt-tags", .{});
    for (tags[0..nt]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\nI mt-colors", .{});
    for (colors[0..nt]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\nI mt-counts", .{});
    for (counts[0..nt]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\nR mt-coords", .{});
    for (coords[0..nc]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\n", .{});
}

//! probe_sky -- the oracle for the Sky port.
//!
//! Seam 1 on a clock: every function here is a pure function of the STEP, so the
//! probe walks a table of steps and prints what the real module answers.
//!
//! THE COLOURS ARE THE POINT. sky.zig is the first module the port could not
//! reach at all until real-to-int and real-from-int had zig emitters: skyColor
//! rounds a lerped channel and packs three of them into one integer, and neither
//! the rounding nor the packing could be expressed. So the two colour streams are
//! graded EXACTLY, as integers, with no tolerance anywhere near them -- a colour
//! that is one off is a wrong colour, not a rounding difference.
//!
//! The steps are chosen for the clock's shape, not for coverage: step 0, the
//! squared ramp while the sun is up, the exact moment the disc touches the
//! horizon, the crossing where the warmth peaks, the moment it is FULLY SET
//! (which is the branch boundary in sunSetFraction), and well into night where
//! both fractions clamp.

const std = @import("std");
const camera = @import("wasm/camera.zig");
const sky = @import("wasm/sky.zig");

// h(step) = 244 - 0.061258752*step, so: horizon at ~3983, fully set at ~4734.
const STEPS = [_]f32{
    0.0,    250.0,  500.0,  1000.0, 2000.0, 3000.0, 3500.0,
    3983.0, // the disc's centre on the horizon -- warmth peaks
    4000.0, 4400.0,
    4734.0, // fully set: the branch boundary in sunSetFraction
    4800.0, 5200.0, 6000.0, 8000.0,
};

pub fn main() void {
    std.debug.print("R sky-height", .{});
    for (STEPS) |s| std.debug.print(" {d}", .{sky.sunHeightPx(s)});
    std.debug.print("\nR sky-dusk", .{});
    for (STEPS) |s| std.debug.print(" {d}", .{sky.sunSetFraction(s)});
    std.debug.print("\nR sky-warmth", .{});
    for (STEPS) |s| std.debug.print(" {d}", .{sky.sunsetWarmth(s)});

    // exact: these are the module's whole visible output
    std.debug.print("\nI sky-color", .{});
    for (STEPS) |s| std.debug.print(" {d}", .{sky.skyColor(s)});
    std.debug.print("\nI sky-horizon", .{});
    for (STEPS) |s| std.debug.print(" {d}", .{sky.horizonColor(s)});

    // the placement, over headings that straddle the visibility limit
    const HEADINGS = [_]f32{ -2.2176, -1.6, -1.0, 0.0, 1.0, 2.0, 3.0, -3.0 };
    const FOCALS = [_]f32{ camera.FOCAL, camera.FOCAL * 0.6 };
    std.debug.print("\nB sun-visible", .{});
    for (FOCALS) |f| for (HEADINGS) |h| {
        const p = sky.sunPos(h, 3000.0, f);
        std.debug.print(" {d}", .{@intFromBool(p.visible)});
    };
    std.debug.print("\nR sun-x", .{});
    for (FOCALS) |f| for (HEADINGS) |h| {
        std.debug.print(" {d}", .{sky.sunPos(h, 3000.0, f).x});
    };
    std.debug.print("\nR sun-y", .{});
    for (FOCALS) |f| for (HEADINGS) |h| {
        std.debug.print(" {d}", .{sky.sunPos(h, 3000.0, f).y});
    };
    std.debug.print("\nR sun-scale", .{});
    for (FOCALS) |f| for (HEADINGS) |h| {
        std.debug.print(" {d}", .{sky.sunPos(h, 3000.0, f).scale});
    };
    std.debug.print("\n", .{});
}

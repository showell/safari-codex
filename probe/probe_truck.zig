//! probe_truck -- the oracle for the Truck port's MOTION half.
//!
//! Seam 4 again, and graded the same way rider is: one step from a shared state,
//! never a trajectory. The truck's speed is a kinematic brake recomputed every
//! frame against a corner, so it has the same sensitivity to a flipped comparison
//! that the rider's search has.
//!
//! The states sit on the three rules and the seams between them: far from any
//! turn and behind schedule (accelerate), far and ahead of schedule (cruise),
//! inside the brake distance (slow to the caution speed), already at or below the
//! caution speed (hold, brake lights OFF because it is no longer slowing), and
//! past the course end where there is no turn to brake for.

const std = @import("std");
const world = @import("wasm/world.zig");
const truck = @import("wasm/truck.zig");

pub fn main() void {
    var w = world.buildWorld();
    const l = world.courseLength(&w);

    const S = struct { pos: f32, v: f32, rider_dist: f32 };
    const cases = [_]S{
        .{ .pos = 500.0, .v = 0.3, .rider_dist = 0.0 }, // the opening frame
        .{ .pos = 600.0, .v = 1.2, .rider_dist = 300.0 }, // mid-course, behind schedule
        .{ .pos = 900.0, .v = 1.2, .rider_dist = 300.0 }, // ahead of schedule: cruise
        .{ .pos = 470.0, .v = 2.0, .rider_dist = 200.0 }, // inside the brake distance of the seg1 turn
        .{ .pos = 495.0, .v = 0.5, .rider_dist = 200.0 }, // close to the turn, already slow
        .{ .pos = 499.0, .v = 0.1, .rider_dist = 200.0 }, // below the caution speed: holds, not braking
        .{ .pos = 2000.0, .v = 2.5, .rider_dist = 1500.0 }, // fast, mid-route
        .{ .pos = 7300.0, .v = 1.0, .rider_dist = 7000.0 }, // in the terminus segment: no turn ahead
        .{ .pos = 7600.0, .v = 1.0, .rider_dist = 7400.0 }, // past the course end entirely
    };

    std.debug.print("R tk-pos", .{});
    for (cases) |c| std.debug.print(" {d}", .{truck.next(.{ .pos = c.pos, .v = c.v, .braking = false }, c.rider_dist, &w, l).pos});
    std.debug.print("\nR tk-v", .{});
    for (cases) |c| std.debug.print(" {d}", .{truck.next(.{ .pos = c.pos, .v = c.v, .braking = false }, c.rider_dist, &w, l).v});
    std.debug.print("\nB tk-braking", .{});
    for (cases) |c| std.debug.print(" {d}", .{@intFromBool(truck.next(.{ .pos = c.pos, .v = c.v, .braking = false }, c.rider_dist, &w, l).braking)});
    const ini = truck.initial();
    std.debug.print("\nR tk-initial {d} {d}", .{ ini.pos, ini.v });
    std.debug.print("\n", .{});
}

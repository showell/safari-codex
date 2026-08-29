//! probe_rider -- the oracle for the Rider and Gaze ports.
//!
//! SEAM 4, AND THE ONE WITH THE HAZARD. rider.decide picks its lean by binary
//! search: twelve iterations, each deciding on one float comparison after
//! simulating up to two thousand physics steps. A 1e-7 difference between the
//! game's f32 and the port's Real will eventually flip one of those comparisons,
//! and from there the two rides are on genuinely different trajectories. So a long
//! trace comparison WOULD go red and it would NOT mean the port is wrong.
//!
//! NOTES' answer, and the one used here: compare ONE STEP FROM A SHARED STATE.
//! The probe hands both sides the same state N and grades state N+1. Drift cannot
//! accumulate, and a failure points at one step and one module rather than at
//! frame four thousand.
//!
//! The states are hand-built to sit on the branches: dead centre and off-centre,
//! upright and leaned, far from a corner and inside the approach, in a cat's
//! danger window, gawking at pigs, a hair short of a seam, and on the terminus in
//! the finish zone.

const std = @import("std");
const world = @import("wasm/world.zig");
const gaze = @import("wasm/gaze.zig");
const rider = @import("wasm/rider.zig");

fn st(seg: usize, along: f32, across: f32, yaw: f32, v: f32, tilt: f32, gy: f32, focus: f32) rider.RiderState {
    return .{ .segment = seg, .along = along, .across = across, .yaw = yaw, .v = v, .tilt = tilt, .heading = 0.3, .gaze_yaw = gy, .focus = focus };
}

pub fn main() void {
    var w = world.buildWorld();

    const cases = [_]rider.RiderState{
        st(0, 0.0, 0.0, 0.0, rider.V_BASE, 0.0, 0.0, 0.0), // the opening frame, dead centre
        st(0, 120.0, 0.9, 0.02, 1.4, 0.004, 0.0, 0.0), // off-centre and leaned, mid-segment
        st(0, 120.0, -0.9, -0.02, 1.4, -0.004, 0.0, 0.0), // the mirror
        st(0, 0.0, 0.0, 0.0, 2.5, 0.0, 0.0, 0.0), // at V_MAX from the start
        st(0, 470.0, 0.1, 0.0, 2.2, 0.0, 0.0, 0.0), // inside the approach: the corner brake bites
        st(0, 497.0, 0.1, 0.0, 0.6, 0.0, 0.0, 0.0), // at the commit point of a 50 degree turn
        st(1, 60.0, 0.2, 0.0, 1.2, 0.0, 0.0, 0.0), // segment 2: the CAT leg, before the window
        st(1, 110.0, 0.2, 0.0, 1.2, 0.0, 0.0, 0.0), // segment 2: inside the cat danger window
        st(2, 200.0, 0.3, 0.0, 1.6, 0.0, 0.0, 0.0), // segment 3: pigs, before he notices
        st(2, 300.0, 0.3, 0.01, 1.6, 0.0, 0.0, 0.0), // segment 3: gawking, the brake engaged
        st(2, 335.0, 0.3, 0.01, 0.25, 0.0, 0.2, 0.4), // creeping past the pigs, head turned
        st(2, 360.0, 0.3, 0.0, 0.25, 0.0, 0.5, 0.9), // head swinging back, focus holding
        st(0, 499.0, 0.05, 0.0, 0.22, 0.0, 0.0, 0.0), // a hair short of the seam: the crossing fires
        st(18, 250.0, 0.1, 0.0, 0.8, 0.0, 0.0, 0.0), // the terminus, inside the finish zone
        st(18, 299.9, 0.1, 0.0, 0.05, 0.0, 0.0, 0.0), // the terminus, creeping to the line
        st(0, 200.0, 1.8, 0.0, 1.0, 0.0, 0.0, 0.0), // already outside the inset: bounds widen to him
    };

    // state N+1 for each, every field
    std.debug.print("I rd-seg", .{});
    for (cases) |c| std.debug.print(" {d}", .{rider.getNextRiderState(c, &w).segment});
    std.debug.print("\nR rd-along", .{});
    for (cases) |c| std.debug.print(" {d}", .{rider.getNextRiderState(c, &w).along});
    std.debug.print("\nR rd-across", .{});
    for (cases) |c| std.debug.print(" {d}", .{rider.getNextRiderState(c, &w).across});
    std.debug.print("\nR rd-yaw", .{});
    for (cases) |c| std.debug.print(" {d}", .{rider.getNextRiderState(c, &w).yaw});
    std.debug.print("\nR rd-v", .{});
    for (cases) |c| std.debug.print(" {d}", .{rider.getNextRiderState(c, &w).v});
    std.debug.print("\nR rd-tilt", .{});
    for (cases) |c| std.debug.print(" {d}", .{rider.getNextRiderState(c, &w).tilt});
    std.debug.print("\nR rd-heading", .{});
    for (cases) |c| std.debug.print(" {d}", .{rider.getNextRiderState(c, &w).heading});
    std.debug.print("\nR rd-gazeyaw", .{});
    for (cases) |c| std.debug.print(" {d}", .{rider.getNextRiderState(c, &w).gaze_yaw});
    std.debug.print("\nR rd-focus", .{});
    for (cases) |c| std.debug.print(" {d}", .{rider.getNextRiderState(c, &w).focus});
    std.debug.print("\nB rd-finished", .{});
    for (cases) |c| std.debug.print(" {d}", .{@intFromBool(rider.isFinished(c, &w))});

    // the turn-speed table, over every angle the route actually uses
    std.debug.print("\nR rd-turnspeed", .{});
    for ([_]f32{ 15, 20, 30, 50, 70, 80, 45 }) |d| {
        std.debug.print(" {d}", .{rider.turnSpeed(d * std.math.pi / 180.0)});
    }

    // gaze, graded on its own so a failure separates from the physics
    std.debug.print("\nB rd-gawk", .{});
    for (cases) |c| std.debug.print(" {d}", .{@intFromBool(gaze.gawkEngaged(c, w.segments[c.segment]))});
    std.debug.print("\nR rd-pigbrake", .{});
    for (cases) |c| {
        const b = gaze.pigGazeBrake(c, w.segments[c.segment]);
        std.debug.print(" {d}", .{if (b) |x| x else 12345.0}); // 12345 stands for "not engaged"
    }
    std.debug.print("\nR rd-gazefocus", .{});
    for (cases) |c| std.debug.print(" {d}", .{gaze.gazeFocus(c.focus)});
    std.debug.print("\n", .{});
}

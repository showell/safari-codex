//! probe_ride -- the oracle for SEAM 4: the whole ride, checked by INVARIANTS.
//!
//! NOTES section 4 rules out the obvious version of this check and prescribes
//! this one. safari.zig's fold is the only mutable state in the game, and
//! `rider.decide()` picks the lean by BINARY SEARCH over twelve float
//! comparisons -- so a 1e-7 f64-vs-f32 difference will eventually flip one and
//! the two rides part company. A long trace comparison WOULD go red and it would
//! NOT mean the port is wrong. "For a whole-ride check, check INVARIANTS (on the
//! road, no loop, sunset monotone) -- which is what games/driving/test/
//! test_model.ts already does for the TS."
//!
//! So this runs the GAME's ride from the start line to the finish, asserts that
//! list on every frame, and prints WHERE each invariant first failed, or -1. The
//! Codex side runs its OWN ride and prints the same eight numbers. Comparing
//! -1 to -1 says both rides stayed legal for their whole length without ever
//! comparing a trajectory to a trajectory.
//!
//! The invariant list is test_model.ts's `assertInvariants`, ported: the bounds
//! and their epsilons are its numbers, including the entry floor, whose comment
//! there explains the -width/sin form (the worst case is crossing at the OUTER
//! road edge, not the centre).
//!
//! `rd-enters` -- the frame each segment was entered on -- is neither graded nor
//! drift-immune. It is here because it LOCALISES the drift: the port and the game
//! agree to a frame or two on most segments and part company on a few, and
//! probe_sens.zig shows the game doing the same to itself under a bias of 1e-7.
//!
//! WHAT IS DRIFT-IMMUNE AND WHAT IS NOT. The eight verdicts are, and so is the
//! ORDER of segments the ride visits -- a route is a route whatever the last bit
//! does. The frame COUNT is not, and it is printed rather than graded for that
//! reason; see RideCheck.
//!
//! AND THE DRIFT ITSELF IS WORTH A NUMBER. NOTES section 4 predicted it and
//! nothing had ever measured it, so this also samples ROUTE DISTANCE every
//! hundredth frame -- the one quantity that rises monotonically for the whole
//! ride, so a gap in it is a gap between the two rides in metres. RideCheck
//! reports where the two first part company by a centimetre. That is a
//! MEASUREMENT and not a gate: NOTES' whole point is that this number is allowed
//! to be finite.
//!
//! Line format matches probe_pond.zig: `<kind> <name> <values...>`.

const std = @import("std");
const world = @import("wasm/world.zig");
const rider = @import("wasm/rider.zig");
const sky = @import("wasm/sky.zig");

const QUARTER: f32 = std.math.pi / 2.0;

// The ride is about four thousand frames. The cap is what turns "no loop" into a
// finite question: a ride that has not finished by here has not terminated, and
// invariant 8 says so rather than the harness hanging.
const CAP: usize = 20000;

const N_INV = 8;
var first_bad = [_]i64{-1} ** N_INV;

fn note(i: usize, ok: bool, frame: usize) void {
    if (!ok and first_bad[i] < 0) first_bad[i] = @intCast(frame);
}

// test_model.ts: the rider may sit BEFORE a segment's start, because he crosses
// into a turn at the inner edge, just shy of the begin line. `exit_to` is
// sequential on this route -- [1,2,...,18,18] -- so segment i is entered from
// i-1, and segment 0 has no entry intersection at all.
const SAMPLE_EVERY: usize = 100;
var samples: [CAP / SAMPLE_EVERY + 2]f32 = undefined;
var n_samples: usize = 0;

fn entryFloor(w: *const world.World, seg: usize) f32 {
    if (seg == 0) return 0;
    const a = w.segments[seg - 1].exit_angle;
    if (a > 0) return -w.segments[seg].width / @sin(a);
    return 0;
}

pub fn main() void {
    var w = world.buildWorld();
    var s = rider.initialRiderState();
    var segs: [64]i64 = undefined;
    var enters: [64]i64 = undefined;
    var n_segs: usize = 0;
    var prev_dusk: f32 = -1.0;
    var finished = false;
    var frame: usize = 0;
    while (frame < CAP) : (frame += 1) {
        const seg = w.segments[s.segment];
        const here: i64 = @intCast(s.segment);
        if (n_segs == 0 or segs[n_segs - 1] != here) {
            segs[n_segs] = here;
            enters[n_segs] = @intCast(frame);
            n_segs += 1;
        }
        if (frame % SAMPLE_EVERY == 0) {
            samples[n_samples] = world.routeDistance(&w, s.segment, s.along);
            n_samples += 1;
        }
        note(0, s.v >= -1e-9 and s.v <= 8.0, frame);
        note(1, @abs(s.yaw) <= QUARTER + 1e-6, frame);
        note(2, s.along >= entryFloor(&w, s.segment) - 1e-6, frame);
        note(3, s.along <= seg.length + 1e-6, frame);
        note(4, @abs(s.across) <= seg.width / 2.0 + 1.0, frame);
        note(5, @abs(s.gaze_yaw) <= QUARTER + 1e-3, frame);
        note(6, s.focus >= 0.0 and s.focus <= 1.0, frame);
        const dusk = sky.sunSetFraction(@floatFromInt(frame));
        note(7, dusk >= prev_dusk, frame);
        prev_dusk = dusk;
        if (rider.isFinished(s, &w)) {
            finished = true;
            break;
        }
        s = rider.getNextRiderState(s, &w);
    }

    std.debug.print("I rd-firstbad", .{});
    for (first_bad) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\n", .{});

    std.debug.print("I rd-segs", .{});
    for (segs[0..n_segs]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\n", .{});

    std.debug.print("R rd-sample", .{});
    for (samples[0..n_samples]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\n", .{});

    std.debug.print("I rd-enters", .{});
    for (enters[0..n_segs]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\n", .{});

    std.debug.print("I rd-frames {d}\n", .{frame});
    std.debug.print("B rd-finished {d}\n", .{@intFromBool(finished)});
}

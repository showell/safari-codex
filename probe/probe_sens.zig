// SENSITIVITY EXPERIMENT -- not a probe, not graded, and no check reads it.
// There is no probe_sens gold and harness/run.sh never builds this: it is kept
// because it is the EVIDENCE behind PORTING_NOTES D11, and the question it
// answers is one that will be asked again.
//
// THE QUESTION. The port's ride finishes in 6,960 frames and the game's in 7,000.
// Is that forty-frame gap something determination could close, or is it the ride
// itself being undetermined at the precision the port is forced to work in?
//
// IT RUNS THE GAME'S OWN CODE, IN f32, WITH THE PORT NOWHERE IN IT. That is the
// whole design: if the game does this to itself, the gap is not the port's.
//
// WHAT IT MEASURED, on 2026-08-30:
//
//   A ONE-ULP NUDGE TO THE INITIAL STATE IS ABSORBED COMPLETELY. v, across and
//   yaw each perturbed by one f32 ulp at frame 0: 7,000 frames, and the two rides
//   never reach a centimetre apart over the whole route. The ride is CONTRACTING,
//   not chaotic, and that was worth knowing before blaming chaos for anything.
//
//   THE THRESHOLD IS f32's OWN RESOLUTION. A persistent relative bias on v, every
//   frame: 1e-9 and 1e-8 change NOTHING -- 7,000 frames, segment 13 still 305. At
//   1e-7, which is f32 epsilon, the total swings to 7,061 or 6,971 and segment 13
//   to 267 or 266. So the ride is stable to everything below the arithmetic's own
//   resolution and unstable AT it. The 7,000 is not a property of the model; it is
//   a property of evaluating the model in f32.
//
//   AND THE VOLATILITY IS LOCALISED, in the game as much as in the port. Under
//   +-1e-7 per frame, segments 10, 12 and 13 move by tens of frames every time
//   while 0, 3, 7 and 11 do not move at all. The port's own per-segment durations
//   sit inside that family rather than outside it: 628/238/265 against the game's
//   597/250/305 unperturbed and 668/266/267 under +1e-7.
//
// THE CONCLUSION IS D11's: closing the gap needs bit-identical arithmetic, which
// needs f32, which no plug offers (A7) -- and even with it, the rider steps
// through sin and cos every frame and zig's f32 transcendentals are not
// DeviceMath's. There is no nearly-right here: below 1e-7 nothing moves, at 1e-7
// the answer is a member of a family.
//
//     cd probe && zig build-exe probe_sens.zig && ./probe_sens
//
const std = @import("std");
const world = @import("wasm/world.zig");
const rider = @import("wasm/rider.zig");

const CAP: usize = 20000;

const Run = struct { frames: usize, enters: [24]i64, n: usize };

fn ride(w: *const world.World, nudge_at: usize, nudge_rel: f32, persistent: f32) Run {
    var s = rider.initialRiderState();
    var r = Run{ .frames = 0, .enters = undefined, .n = 0 };
    var frame: usize = 0;
    var last_seg: i64 = -1;
    while (frame < CAP) : (frame += 1) {
        const here: i64 = @intCast(s.segment);
        if (here != last_seg) {
            r.enters[r.n] = @intCast(frame);
            r.n += 1;
            last_seg = here;
        }
        if (rider.isFinished(s, w)) break;
        s = rider.getNextRiderState(s, w);
        if (frame == nudge_at) s.v = s.v * (1.0 + nudge_rel);
        if (persistent != 0) s.v = s.v * (1.0 + persistent);
    }
    r.frames = frame;
    return r;
}

fn seg13(r: Run) i64 {
    return r.enters[14] - r.enters[13];
}

fn durations(name: []const u8, r: Run) void {
    std.debug.print("{s:<14}", .{name});
    var i: usize = 0;
    while (i + 1 < r.n) : (i += 1) std.debug.print(" {d:>4}", .{r.enters[i + 1] - r.enters[i]});
    std.debug.print("   total {d}\n", .{r.frames});
}

pub fn main() void {
    var w = world.buildWorld();
    const base = ride(&w, 99999, 0, 0);
    std.debug.print("base                       frames {d}  seg13 {d}\n", .{ base.frames, seg13(base) });

    std.debug.print("\n-- per-segment durations under a PERSISTENT bias --\n", .{});
    durations("base", base);
    durations("+1e-7/frame", ride(&w, 99999, 0, 1e-7));
    durations("-1e-7/frame", ride(&w, 99999, 0, -1e-7));
    durations("+3e-7/frame", ride(&w, 99999, 0, 3e-7));

    std.debug.print("\n-- one nudge to v at frame 5000, relative size varying --\n", .{});
    for ([_]f32{ 1e-7, -1e-7, 1e-6, -1e-6, 1e-5, -1e-5, 1e-4, -1e-4, 1e-3, -1e-3 }) |e| {
        const r = ride(&w, 5000, e, 0);
        std.debug.print("  v *= 1 + {e} at 5000   frames {d}  seg13 {d}\n", .{ e, r.frames, seg13(r) });
    }

    std.debug.print("\n-- a PERSISTENT relative bias on v, every frame --\n", .{});
    for ([_]f32{ 1e-9, -1e-9, 1e-8, -1e-8, 1e-7, -1e-7 }) |e| {
        const r = ride(&w, 99999, 0, e);
        std.debug.print("  v *= 1 + {e} each frame  frames {d}  seg13 {d}\n", .{ e, r.frames, seg13(r) });
    }
}

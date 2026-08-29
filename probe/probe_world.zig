//! probe_world -- the oracle for the World port.
//!
//! SEAM 2, and the purest instance of it in the port. world.zig draws nothing and
//! projects nothing: it is authored data plus the deterministic generators that
//! expand it, so almost everything here compares EXACTLY. The only Reals that are
//! not exact-by-construction are the jitter sines in the herds and the turn angles
//! in radians, and those take the relative gate.
//!
//! Everything is dumped: every tree, every cow, every pig, every segment's turn
//! and heading and commit point, and the cat placement. A data module graded on a
//! summary is a data module not graded.

const std = @import("std");
const world = @import("wasm/world.zig");

pub fn main() void {
    var w = world.buildWorld();
    const n = w.n_segments;

    std.debug.print("I w-nsegs {d}", .{n});

    std.debug.print("\nR w-length", .{});
    for (w.segments[0..n]) |s| std.debug.print(" {d}", .{s.length});
    std.debug.print("\nI w-ntrees", .{});
    for (w.segments[0..n]) |s| std.debug.print(" {d}", .{s.n_trees});
    std.debug.print("\nI w-ncows", .{});
    for (w.segments[0..n]) |s| std.debug.print(" {d}", .{s.n_cows});
    std.debug.print("\nI w-npigs", .{});
    for (w.segments[0..n]) |s| std.debug.print(" {d}", .{s.n_pigs});
    std.debug.print("\nB w-distract", .{});
    for (w.segments[0..n]) |s| std.debug.print(" {d}", .{@intFromBool(s.pigs_distract)});
    std.debug.print("\nB w-terminates", .{});
    for (w.segments[0..n]) |s| std.debug.print(" {d}", .{@intFromBool(s.terminates)});
    std.debug.print("\nB w-hascat", .{});
    for (w.segments[0..n]) |s| std.debug.print(" {d}", .{@intFromBool(s.has_cat)});
    std.debug.print("\nB w-midtower", .{});
    for (w.segments[0..n]) |s| std.debug.print(" {d}", .{@intFromBool(s.has_mid_tower)});
    std.debug.print("\nB w-exitright", .{});
    for (w.segments[0..n]) |s| std.debug.print(" {d}", .{@intFromBool(s.exit_right)});
    std.debug.print("\nI w-exitto", .{});
    for (w.segments[0..n]) |s| std.debug.print(" {d}", .{s.exit_to});
    std.debug.print("\nI w-creature", .{});
    for (w.segments[0..n]) |s| std.debug.print(" {d}", .{@intFromEnum(s.exit_creature)});

    std.debug.print("\nR w-exitangle", .{});
    for (w.segments[0..n]) |s| std.debug.print(" {d}", .{s.exit_angle});
    std.debug.print("\nR w-commit", .{});
    for (w.segments[0..n]) |s| std.debug.print(" {d}", .{s.commit_along});
    std.debug.print("\nR w-heading", .{});
    for (w.segments[0..n]) |s| std.debug.print(" {d}", .{s.north_heading});

    // every tree: along, across, height -- and the colour separately, exact
    std.debug.print("\nR w-trees", .{});
    for (w.segments[0..n]) |s| for (s.trees[0..s.n_trees]) |t| {
        std.debug.print(" {d} {d} {d}", .{ t.along, t.across, t.height });
    };
    std.debug.print("\nI w-treecolor", .{});
    for (w.segments[0..n]) |s| for (s.trees[0..s.n_trees]) |t| {
        std.debug.print(" {d}", .{t.color});
    };

    // every cow: along, across, height; codepoint and facing separately
    std.debug.print("\nR w-cows", .{});
    for (w.segments[0..n]) |s| for (s.cows[0..s.n_cows]) |c| {
        std.debug.print(" {d} {d} {d}", .{ c.along, c.across, c.height });
    };
    std.debug.print("\nI w-cowcp", .{});
    for (w.segments[0..n]) |s| for (s.cows[0..s.n_cows]) |c| {
        std.debug.print(" {d}", .{c.codepoint});
    };
    std.debug.print("\nB w-cowface", .{});
    for (w.segments[0..n]) |s| for (s.cows[0..s.n_cows]) |c| {
        std.debug.print(" {d}", .{@intFromBool(c.face_right)});
    };

    // every pig: along, across (height and codepoint are constant for pigs)
    std.debug.print("\nR w-pigs", .{});
    for (w.segments[0..n]) |s| for (s.pigs[0..s.n_pigs]) |p| {
        std.debug.print(" {d} {d}", .{ p.along, p.across });
    };

    // the gaze pig, per segment
    std.debug.print("\nR w-gazepig", .{});
    for (w.segments[0..n]) |s| {
        const g = world.gazePig(s.length, s.width / 2.0);
        std.debug.print(" {d} {d}", .{ g.along, g.across });
    }

    // the cat placement, per segment (built for all, read only where has_cat)
    std.debug.print("\nR w-cat", .{});
    for (w.segments[0..n]) |s| {
        if (!s.has_cat) continue;
        std.debug.print(" {d} {d} {d} {d} {d}", .{ s.cat.along, s.cat.start_across, s.cat.mid_across, s.cat.end_across, s.cat.height });
    }

    std.debug.print("\nR w-course {d}", .{world.courseLength(&w)});
    std.debug.print("\nR w-routedist", .{});
    for ([_]usize{ 0, 1, 5, 12, 18 }) |seg| {
        std.debug.print(" {d}", .{world.routeDistance(&w, seg, 137.5)});
    }
    std.debug.print("\n", .{});
}

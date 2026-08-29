//! probe_render -- the oracle for the Render port's mapping spine, and for
//! SafariCritter.
//!
//! RENDER.ZIG'S PUBLIC SURFACE IS FOUR NAMES: Chain, Pose, at, frame. buildChain,
//! Mapper, mapPt and the four ground/rail emitters are private to the file, so a
//! probe cannot call them. That is what shapes this probe, and the three seams
//! below are graded with three DIFFERENT strengths of oracle. RenderCheck says
//! which is which; the short version:
//!
//!   r-at        a REAL oracle. render.at is pub, so this calls it.
//!   r-prev      the DEFINITION. mapPt's prev branch is private, but it is
//!               geom.curToNext then geom.toRider and both of those are pub, so
//!               the probe composes the two real functions in that order.
//!   r-chain     the WEAKEST. buildChain is private and `at` never consults the
//!               caps, so the chain's extent is not observable from outside
//!               render.zig at all. The walk below reads the real world's
//!               exit_to and terminates -- both graded exactly in WorldCheck --
//!               but LOOK_AHEAD and MAX_CHAIN are copied from render.zig's
//!               source. Those two integers are the only value in this port that
//!               is transcribed rather than measured, and they stop being so the
//!               moment the collection lands: render.cull_seg is pub and sums
//!               n_cows + n_pigs over chain indices 3 and up, which makes the
//!               chain's extent observable through frame(). See PORTING_NOTES E1.
//!
//! safari_critter.cornerCritters IS pub, so SafariCritter gets a real oracle and
//! is graded here rather than growing a fourth build for sixty lines.
//!
//! The cases are branches, not coverage. The chains are the three shapes the
//! route actually produces -- capped at the look-ahead, running into the
//! terminus, and a short tail -- and the sample points per segment are the four
//! `a` and four `x` that render itself authors at: the segment start, its middle,
//! its end edge (every joint quad), and the tower's 160 m beyond; the left edge,
//! the centre line, the right edge, and the tower's 20 m off it.

const std = @import("std");
const geom = @import("wasm/geom.zig");
const world = @import("wasm/world.zig");
const render = @import("wasm/render.zig");
const safari_critter = @import("wasm/safari_critter.zig");

// COPIED from render.zig's private consts -- see the header. Nothing else here is.
const LOOK_AHEAD: usize = 7;
const MAX_CHAIN: usize = 8;

// render.zig's placement constants, likewise private; used only to CHOOSE sample
// points, so they are test inputs rather than expected values.
const TOWER_BEYOND: f32 = 160.0;
const TOWER_RIGHT: f32 = 20.0;

var chain_idx: [256]u32 = undefined;
var chain_len: [32]u32 = undefined;
var nci: usize = 0;
var ncl: usize = 0;

var ats: [8192]f32 = undefined;
var na: usize = 0;

var prevs: [512]f32 = undefined;
var npv: usize = 0;

var sc_n: [32]u32 = undefined;
var sc_cp: [64]u32 = undefined;
var sc_face: [64]u32 = undefined;
var sc_r: [256]f32 = undefined;
var nsn: usize = 0;
var nsc: usize = 0;
var nsr: usize = 0;

// The chain walk, over the REAL world's exit_to and terminates. Mirrors
// buildChain, which is private; the two caps are the copied values.
fn chainOf(w: *const world.World, start: usize, out: *[MAX_CHAIN]usize) usize {
    var n: usize = 0;
    var s = start;
    while (n < LOOK_AHEAD and n < MAX_CHAIN) {
        out[n] = s;
        n += 1;
        if (w.segments[s].terminates) break;
        s = w.segments[s].exit_to;
    }
    return n;
}

fn toChain(idx: []const usize) render.Chain {
    var ch: render.Chain = undefined;
    for (idx, 0..) |v, i| ch.idx[i] = v;
    ch.len = idx.len;
    return ch;
}

// Every (a, x) render authors at, for one chain index, through the real `at`.
fn sampleAt(w: *const world.World, ch: *const render.Chain, pose: render.Pose, d: usize, seg: world.Segment) void {
    const as = [_]f32{ 0.0, seg.length / 2.0, seg.length, seg.length + TOWER_BEYOND };
    const xs = [_]f32{ 0.0, seg.width / 2.0, seg.width, seg.width / 2.0 + TOWER_RIGHT };
    for (as) |a| {
        for (xs) |x| {
            const p = render.at(w, ch, pose, d, a, x);
            ats[na] = p.right;
            ats[na + 1] = p.forward;
            na += 2;
        }
    }
}

// mapPt's prev branch, by its definition: curToNext then toRider, both pub.
fn samplePrev(prev: world.Segment, pose: render.Pose) void {
    const as = [_]f32{ 0.0, prev.length / 2.0, prev.length, prev.length + TOWER_BEYOND };
    const xs = [_]f32{ 0.0, prev.width / 2.0, prev.width, prev.width / 2.0 + TOWER_RIGHT };
    for (as) |a| {
        for (xs) |x| {
            const q = geom.curToNext(a, x, prev.length, prev.exit_angle, prev.exit_right, prev.width);
            const p = geom.toRider(q.a, q.x, pose.along, pose.across, pose.yaw, pose.hw);
            prevs[npv] = p.right;
            prevs[npv + 1] = p.forward;
            npv += 2;
        }
    }
}

pub fn main() void {
    var w = world.buildWorld();
    const n = w.n_segments;

    // every start segment: the look-ahead cap for the early ones, the terminus
    // break shortening the tail from seven down to one.
    var s: usize = 0;
    while (s < n) : (s += 1) {
        var idx: [MAX_CHAIN]usize = undefined;
        const len = chainOf(&w, s, &idx);
        chain_len[ncl] = @intCast(len);
        ncl += 1;
        for (idx[0..len]) |v| {
            chain_idx[nci] = @intCast(v);
            nci += 1;
        }
    }

    // `at` over three chains and two poses. The poses differ in every field: one
    // early on a segment looking a little right of the road, one deep down a long
    // one looking well left, so the sin/cos of the rider transform are exercised
    // on both signs and the composition is not measured at yaw ~ 0 alone.
    const poses = [_]render.Pose{
        .{ .along = 120.0, .across = 0.6, .yaw = 0.05, .hw = 2.0 },
        .{ .along = 480.0, .across = -1.2, .yaw = -0.3, .hw = 2.0 },
    };
    const starts = [_]usize{ 0, 12, 16 };
    for (poses) |pose| {
        for (starts) |st| {
            var idx: [MAX_CHAIN]usize = undefined;
            const len = chainOf(&w, st, &idx);
            const ch = toChain(idx[0..len]);
            var d: usize = 0;
            while (d < len) : (d += 1) sampleAt(&w, &ch, pose, d, w.segments[idx[d]]);
        }
    }

    // the behind joint, for the four previous segments that turn differently:
    // seg 0 turns right, seg 1 left, seg 12 right into the pond corner, seg 17 left.
    for ([_]usize{ 0, 1, 12, 17 }) |pi| {
        for (poses) |pose| samplePrev(w.segments[pi], pose);
    }

    // cornerCritters over every creature and both turn directions. pond and none
    // return nothing; the other four return an adult and a baby.
    var out: [2]world.Critter = undefined;
    for ([_]world.Creature{ .none, .elephant, .giraffe, .zebra, .rhino, .pond }) |cr| {
        for ([_]bool{ true, false }) |tr| {
            const cn = safari_critter.cornerCritters(cr, 300.0, tr, 2.0, &out);
            sc_n[nsn] = @intCast(cn);
            nsn += 1;
            for (out[0..cn]) |c| {
                sc_cp[nsc] = c.codepoint;
                sc_face[nsc] = @intFromBool(c.face_right);
                nsc += 1;
                sc_r[nsr] = c.along;
                sc_r[nsr + 1] = c.across;
                sc_r[nsr + 2] = c.height;
                nsr += 3;
            }
        }
    }

    std.debug.print("I r-chainlen", .{});
    for (chain_len[0..ncl]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\nI r-chain", .{});
    for (chain_idx[0..nci]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\nR r-at", .{});
    for (ats[0..na]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\nR r-prev", .{});
    for (prevs[0..npv]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\nI sc-n", .{});
    for (sc_n[0..nsn]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\nI sc-cp", .{});
    for (sc_cp[0..nsc]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\nB sc-face", .{});
    for (sc_face[0..nsc]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\nR sc-place", .{});
    for (sc_r[0..nsr]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\n", .{});
}

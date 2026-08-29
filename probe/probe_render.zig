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
const guard_rail = @import("wasm/guard_rail.zig");
const paint = @import("wasm/paint.zig");
const camera = @import("wasm/camera.zig");
const truck = @import("wasm/truck.zig");
const pond = @import("wasm/pond.zig");

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

var cull: [64]u32 = undefined;
var ncu: usize = 0;
var rail_fwd: [8192]f32 = undefined;
var rail_n: [32]u32 = undefined;
var path_n: [32]u32 = undefined;
var nrf: usize = 0;
var nrn: usize = 0;

var g_tag: [4096]u32 = undefined;
var g_col: [4096]u32 = undefined;
var g_cnt: [4096]u32 = undefined;
var g_xy: [65536]f32 = undefined;
var ngt: usize = 0;
var ngx: usize = 0;

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

// emitJointRail's path, composed from the pub pieces: render.at for a chain-side
// mapper, geom.curToNext then geom.toRider for the behind one, geom.lineMeet for
// the apex, and pushLeg's own ~1 m spacing. guard_rail.emit IS pub, so the store
// it raises is a real oracle even though the path that feeds it is a composition.
fn mapChain(w: *const world.World, ch: *const render.Chain, pose: render.Pose, d: usize, a: f32, x: f32) geom.RiderPt {
    return render.at(w, ch, pose, d, a, x);
}
fn mapPrev(prev: world.Segment, pose: render.Pose, a: f32, x: f32) geom.RiderPt {
    const q = geom.curToNext(a, x, prev.length, prev.exit_angle, prev.exit_right, prev.width);
    return geom.toRider(q.a, q.x, pose.along, pose.across, pose.yaw, pose.hw);
}

var path: [512]geom.RiderPt = undefined;
var pn: usize = 0;

fn pushLeg(from: geom.RiderPt, to: geom.RiderPt) void {
    const dr = to.right - from.right;
    const df = to.forward - from.forward;
    const dist = @sqrt(dr * dr + df * df);
    const steps: usize = @intFromFloat(@max(1.0, @round(dist)));
    var i: usize = 1;
    while (i <= steps and pn < path.len) : (i += 1) {
        const t: f32 = @as(f32, @floatFromInt(i)) / @as(f32, @floatFromInt(steps));
        path[pn] = .{ .right = from.right + dr * t, .forward = from.forward + df * t };
        pn += 1;
    }
}

// from_prev selects the behind mapper for the `from` side; the `to` side is always
// a chain index here, as it is in render.
fn jointPath(w: *const world.World, ch: *const render.Chain, pose: render.Pose,
             from_prev: bool, prev: world.Segment, from_d: usize, to_d: usize,
             from_len: f32, from_w: f32, to_w: f32, exit_right: bool) void {
    const fcu: f32 = if (exit_right) 0 else from_w;
    const tx: f32 = if (exit_right) 0 else to_w;
    const of_pt = if (from_prev) mapPrev(prev, pose, from_len, fcu) else mapChain(w, ch, pose, from_d, from_len, fcu);
    const of_1 = if (from_prev) mapPrev(prev, pose, from_len + 1, fcu) else mapChain(w, ch, pose, from_d, from_len + 1, fcu);
    const ot_pt = mapChain(w, ch, pose, to_d, 0, tx);
    const ot_1 = mapChain(w, ch, pose, to_d, 1, tx);
    const q = geom.lineMeet(of_pt, of_1, ot_pt, ot_1);
    pn = 0;
    var m: usize = guard_rail.RAIL_RUNOUT;
    while (true) : (m -= 1) {
        const mm: f32 = @floatFromInt(m);
        if (pn < path.len) {
            path[pn] = if (from_prev) mapPrev(prev, pose, from_len - mm, fcu) else mapChain(w, ch, pose, from_d, from_len - mm, fcu);
            pn += 1;
        }
        if (m == 0) break;
    }
    pushLeg(of_pt, q);
    pushLeg(q, ot_pt);
    var mo: usize = 1;
    while (mo <= guard_rail.RAIL_RUNOUT and pn < path.len) : (mo += 1) {
        const mm: f32 = @floatFromInt(mo);
        path[pn] = mapChain(w, ch, pose, to_d, mm, tx);
        pn += 1;
    }
}

var store: guard_rail.RailStore = .{};

// emitGroundColor, composed from the pub pieces: geom.groundDrop for the curvature
// per vertex, geom.clipNear, camera.project, paint.pushPoly. render's own is
// private; every arithmetic step below is the real function.
fn emitGroundColor(pts: []const geom.RiderPt, color: u32, cam_focal: f32) void {
    if (pts.len > 8) return;
    var v: [8]geom.Vec3 = undefined;
    for (pts, 0..) |p, i| v[i] = .{ .right = p.right, .forward = p.forward, .height = -geom.groundDrop(p.right, p.forward) };
    var clipped: [16]geom.Vec3 = undefined;
    const m = geom.clipNear(v[0..pts.len], camera.NEAR, &clipped);
    if (m < 3) return;
    var screen: [16]camera.ScreenPt = undefined;
    var j: usize = 0;
    while (j < m) : (j += 1) screen[j] = camera.project(clipped[j], cam_focal);
    paint.pushPoly(color, screen[0..m]);
}
fn emitGround(pts: []const geom.RiderPt, cam_focal: f32) void {
    emitGroundColor(pts, 0x34353c, cam_focal);
}

const ENTRY_ROAD_DIST: f32 = 40.0;
const ROAD_CHUNK: f32 = 25.0;

fn mapAny(w: *const world.World, ch: *const render.Chain, pose: render.Pose,
          is_prev: bool, prev: world.Segment, d: usize, a: f32, x: f32) geom.RiderPt {
    return if (is_prev) mapPrev(prev, pose, a, x) else mapChain(w, ch, pose, d, a, x);
}

fn jointGround(w: *const world.World, ch: *const render.Chain, pose: render.Pose,
               from_prev: bool, prev: world.Segment, from_d: usize, to_d: usize,
               from_len: f32, from_w: f32, to_w: f32, exit_right: bool, cf: f32) void {
    const approach = [_]geom.RiderPt{
        mapAny(w, ch, pose, from_prev, prev, from_d, from_len, 0),
        mapAny(w, ch, pose, from_prev, prev, from_d, from_len, from_w),
        mapAny(w, ch, pose, from_prev, prev, from_d, from_len - ENTRY_ROAD_DIST, from_w),
        mapAny(w, ch, pose, from_prev, prev, from_d, from_len - ENTRY_ROAD_DIST, 0),
    };
    emitGround(approach[0..], cf);
    const fcu: f32 = if (exit_right) 0 else from_w;
    const tx: f32 = if (exit_right) 0 else to_w;
    const inner = mapAny(w, ch, pose, from_prev, prev, from_d, from_len, if (exit_right) from_w else 0);
    const outer_from = mapAny(w, ch, pose, from_prev, prev, from_d, from_len, fcu);
    const outer_to = mapChain(w, ch, pose, to_d, 0, tx);
    const q = geom.lineMeet(outer_from, mapAny(w, ch, pose, from_prev, prev, from_d, from_len + 1, fcu), outer_to, mapChain(w, ch, pose, to_d, 1, tx));
    const quad = [_]geom.RiderPt{ inner, outer_from, q, outer_to };
    emitGround(quad[0..], cf);
}

fn pondGround(w: *const world.World, ch: *const render.Chain, pose: render.Pose,
              is_prev: bool, prev: world.Segment, d: usize, from_len: f32, cf: f32) void {
    var pts: [8]geom.RiderPt = undefined;
    for (pond.WATER_OUTLINE, 0..) |p, i| pts[i] = mapAny(w, ch, pose, is_prev, prev, d, from_len + p.cv, p.cu);
    emitGroundColor(pts[0..pond.WATER_OUTLINE.len], pond.WATER, cf);
    for (pond.BANK, 0..) |p, i| pts[i] = mapAny(w, ch, pose, is_prev, prev, d, from_len + p.cv, p.cu);
    emitGroundColor(pts[0..pond.BANK.len], pond.BANK_COLOR, cf);
}

// One frame's whole floor, in render's own walk order.
fn frameGround(w: *const world.World, ch: *const render.Chain, pose: render.Pose, seg_idx: usize, cf: f32) void {
    const cur = w.segments[seg_idx];
    var d: usize = 0;
    while (d < ch.len) : (d += 1) {
        const sg = w.segments[ch.idx[d]];
        const chunks_f = @ceil(sg.length / ROAD_CHUNK);
        const chunks: usize = @intFromFloat(@max(@as(f32, 1.0), chunks_f));
        var ci: usize = 0;
        while (ci < chunks) : (ci += 1) {
            const fi: f32 = @floatFromInt(ci);
            const fc: f32 = @floatFromInt(chunks);
            const a0 = sg.length * fi / fc;
            const a1 = sg.length * (fi + 1.0) / fc;
            const quad = [_]geom.RiderPt{
                mapChain(w, ch, pose, d, a0, 0),
                mapChain(w, ch, pose, d, a0, sg.width),
                mapChain(w, ch, pose, d, a1, sg.width),
                mapChain(w, ch, pose, d, a1, 0),
            };
            emitGround(quad[0..], cf);
        }
        if (d + 1 < ch.len) {
            const to = w.segments[ch.idx[d + 1]];
            jointGround(w, ch, pose, false, cur, d, d + 1, sg.length, sg.width, to.width, sg.exit_right, cf);
        }
        if (sg.exit_creature == .pond) pondGround(w, ch, pose, false, cur, d, sg.length, cf);
    }
    if (seg_idx > 0) {
        const pv = w.segments[seg_idx - 1];
        jointGround(w, ch, pose, true, pv, 0, 0, pv.length, pv.width, cur.width, pv.exit_right, cf);
        if (pv.exit_creature == .pond) pondGround(w, ch, pose, true, pv, 0, pv.length, cf);
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

    // THE CULL COUNTERS, THROUGH THE REAL frame(). These two are render.zig's only
    // pub output besides the paint buffer, and between them they observe most of
    // the collection: cull_size counts every farm animal, corner creature and duck
    // that was placed, mapped, projected and then found too small, and cull_seg
    // sums the herds on chain segments past the farm reach -- a function of the
    // chain's own EXTENT, so it is the oracle E1 said would close the caps.
    //
    // The states span the branches: seg 0 has no joint behind it, the long seg 6
    // carries a mid-tower, seg 12 is the pond corner, seg 16 sits three from the
    // terminus so the chain runs short. Two are mid-lean (a pulled-in focal), and
    // the truck is placed both behind the rider and ahead of him.
    const States = struct { seg: usize, along: f32, across: f32, yaw: f32, v: f32, focal: f32, vyaw: f32, tpos: f32 };
    const states = [_]States{
        .{ .seg = 0, .along = 12.0, .across = 0.0, .yaw = 0.0, .v = 1.2, .focal = camera.FOCAL, .vyaw = 0.0, .tpos = 0.0 },
        .{ .seg = 0, .along = 460.0, .across = 1.1, .yaw = 0.09, .v = 1.4, .focal = camera.FOCAL, .vyaw = 0.03, .tpos = 700.0 },
        .{ .seg = 2, .along = 150.0, .across = -0.8, .yaw = -0.12, .v = 1.6, .focal = camera.FOCAL * 0.6, .vyaw = -0.05, .tpos = 0.0 },
        .{ .seg = 5, .along = 40.0, .across = 0.3, .yaw = 0.02, .v = 1.1, .focal = camera.FOCAL, .vyaw = 0.0, .tpos = 2400.0 },
        .{ .seg = 6, .along = 600.0, .across = 0.0, .yaw = 0.0, .v = 2.0, .focal = camera.FOCAL, .vyaw = 0.0, .tpos = 0.0 },
        .{ .seg = 9, .along = 700.0, .across = -1.5, .yaw = 0.25, .v = 0.9, .focal = camera.FOCAL * 0.35, .vyaw = 0.11, .tpos = 0.0 },
        .{ .seg = 12, .along = 280.0, .across = 0.6, .yaw = -0.3, .v = 1.3, .focal = camera.FOCAL, .vyaw = 0.0, .tpos = 0.0 },
        .{ .seg = 16, .along = 100.0, .across = 0.0, .yaw = 0.0, .v = 1.0, .focal = camera.FOCAL, .vyaw = 0.0, .tpos = 0.0 },
    };
    for (states) |st| {
        paint.reset();
        const tk = truck.State{ .pos = st.tpos, .v = 1.2, .braking = false };
        render.frame(&w, st.seg, st.along, st.across, st.yaw, 0.0, 30.0, st.v, st.focal, st.vyaw, tk);
        cull[ncu] = render.cull_seg;
        cull[ncu + 1] = render.cull_size;
        ncu += 2;
    }

    // THE RAILS each of those states collects, in render's own joint order: every
    // forward joint down the chain, then the joint behind. Depth only -- the
    // corners are already graded in GuardRailCheck; what is new is that the path
    // is built off the CHAIN, so a wrong join puts the whole corner at the wrong
    // depth and sorts it against the wrong trees. f-pathn is the longest path any
    // joint produced, which is what says whether render's private 192-point cap
    // is anywhere near being reached.
    for (states) |st| {
        var idx: [MAX_CHAIN]usize = undefined;
        const len = chainOf(&w, st.seg, &idx);
        const ch = toChain(idx[0..len]);
        const cur = w.segments[st.seg];
        const pose = render.Pose{ .along = st.along, .across = st.across, .yaw = st.yaw + st.vyaw, .hw = cur.width / 2.0 };
        store.reset();
        var longest: usize = 0;
        var d: usize = 0;
        while (d + 1 < len) : (d += 1) {
            const fs = w.segments[idx[d]];
            const ts = w.segments[idx[d + 1]];
            jointPath(&w, &ch, pose, false, cur, d, d + 1, fs.length, fs.width, ts.width, fs.exit_right);
            if (pn > longest) longest = pn;
            guard_rail.emit(&store, path[0..pn]);
        }
        if (st.seg > 0) {
            const pv = w.segments[st.seg - 1];
            jointPath(&w, &ch, pose, true, pv, 0, 0, pv.length, pv.width, cur.width, pv.exit_right);
            if (pn > longest) longest = pn;
            guard_rail.emit(&store, path[0..pn]);
        }
        rail_n[nrn] = @intCast(store.n);
        path_n[nrn] = @intCast(longest);
        nrn += 1;
        var i: usize = 0;
        while (i < store.n) : (i += 1) {
            rail_fwd[nrf] = store.polys[i].fwd;
            nrf += 1;
        }
    }

    // THE GROUND for four of those states, chosen to cover the branches: segment 0
    // has no joint behind it, segment 2 is mid-lean (a pulled-in focal moves every
    // projected coordinate), segment 12 is the pond corner (water and bank as well
    // as road), and segment 16 has the short chain. Four rather than eight keeps
    // the gold well under the transpiler's Real-literal ceiling (C7).
    for ([_]usize{ 0, 2, 6, 7 }) |si| {
        const st = states[si];
        var idx: [MAX_CHAIN]usize = undefined;
        const len = chainOf(&w, st.seg, &idx);
        const ch = toChain(idx[0..len]);
        const cur = w.segments[st.seg];
        const pose = render.Pose{ .along = st.along, .across = st.across, .yaw = st.yaw + st.vyaw, .hw = cur.width / 2.0 };
        paint.reset();
        frameGround(&w, &ch, pose, st.seg, st.focal);
        const words = paint.frameWords();
        var wi: usize = 0;
        while (wi < words.len) {
            const tag = words[wi];
            wi += 1;
            g_tag[ngt] = tag;
            g_col[ngt] = words[wi];
            wi += 1;
            if (tag == 1) wi += 1; // ground is never gradient-filled; skip a strength if one appears
            const np2 = words[wi];
            wi += 1;
            g_cnt[ngt] = np2;
            ngt += 1;
            var k: usize = 0;
            while (k < np2 * 2) : (k += 1) {
                g_xy[ngx] = @bitCast(words[wi]);
                ngx += 1;
                wi += 1;
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
    std.debug.print("\nI f-cull", .{});
    for (cull[0..ncu]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\nI f-railn", .{});
    for (rail_n[0..nrn]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\nR f-railfwd", .{});
    for (rail_fwd[0..nrf]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\nI f-gtag", .{});
    for (g_tag[0..ngt]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\nI f-gcol", .{});
    for (g_col[0..ngt]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\nI f-gcnt", .{});
    for (g_cnt[0..ngt]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\nR f-gxy", .{});
    for (g_xy[0..ngx]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\nR sc-place", .{});
    for (sc_r[0..nsr]) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\n", .{});
}

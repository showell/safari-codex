//! probe_pond -- the oracle for the Pond port.
//!
//! Imports the REAL wasm/pond.zig unmodified and writes every value it holds as
//! one line per seam, so the hand-written zig -- not a copy of it -- is what the
//! Codex port is graded against. A copy could drift; an import cannot.
//!
//! Line format is `<kind> <name> <values...>`, kinds R (real, compared with a
//! tolerance), I (integer, exact) and B (boolean as 1/0, exact). Reals print with
//! {d}, zig's shortest round-tripping form, so the text carries the f32 exactly.
//!
//! Output goes to stderr: zig 0.16 removed std.io.getStdOut(), and std.debug.print
//! is the form the rest of this harness already uses.

const std = @import("std");
const pond = @import("wasm/pond.zig");

fn reals(comptime name: []const u8, vals: []const f32) void {
    std.debug.print("R {s}", .{name});
    for (vals) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\n", .{});
}

pub fn main() void {
    var buf: [64]f32 = undefined;

    var n: usize = 0;
    for (pond.WATER_OUTLINE) |p| {
        buf[n] = p.cu;
        buf[n + 1] = p.cv;
        n += 2;
    }
    reals("water-outline", buf[0..n]);

    n = 0;
    for (pond.BANK) |p| {
        buf[n] = p.cu;
        buf[n + 1] = p.cv;
        n += 2;
    }
    reals("bank", buf[0..n]);

    n = 0;
    for (pond.DUCKS) |d| {
        buf[n] = d.p.cu;
        buf[n + 1] = d.p.cv;
        n += 2;
    }
    reals("ducks-p", buf[0..n]);

    reals("duck-height", &[_]f32{pond.DUCK_HEIGHT});

    std.debug.print("I water-color {d}\n", .{pond.WATER});
    std.debug.print("I bank-color {d}\n", .{pond.BANK_COLOR});
    std.debug.print("I duck-codepoint {d}\n", .{pond.DUCK_CP});

    std.debug.print("B ducks-face", .{});
    for (pond.DUCKS) |d| std.debug.print(" {d}", .{@intFromBool(d.face_right)});
    std.debug.print("\n", .{});
}

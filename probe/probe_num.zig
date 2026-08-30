//! probe_num -- the oracle for the Num port.
//!
//! THIS PROBE IMPORTS NO GAME MODULE, and it is the only one that does not.
//! `Safari chapter Num` is not a port of a wasm/ file: it is the Real primitives
//! Codex's foreword does not have, written to zig's own semantics -- @round ties
//! away from zero, @mod is floored, @exp is @exp. So the ORACLE here is zig
//! itself, at the precision the chapter claims: f64, not the f32 the game
//! computes in. That makes this the one check in the port with no f32/f64 gap to
//! absorb, so rounding, flooring and modulo are graded EXACTLY.
//!
//! The inputs are the callers' real domains, plus the edges those callers happen
//! not to reach. Every @round in the game is one of five sites -- sky and
//! mountains rounding a 0..255 colour channel, cat rounding a stride count,
//! render rounding a step count, and rider rounding a turn angle to whole degrees
//! -- and a rounding that is wrong outside 0..255 is a trap for the next caller
//! rather than a bug today, which is exactly why it is worth a gate.
//!
//! Line format matches probe_pond.zig: `<kind> <name> <values...>`.

const std = @import("std");

fn reals(comptime name: []const u8, vals: []const f64) void {
    std.debug.print("R {s}", .{name});
    for (vals) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\n", .{});
}

fn ints(comptime name: []const u8, vals: []const i64) void {
    std.debug.print("I {s}", .{name});
    for (vals) |v| std.debug.print(" {d}", .{v});
    std.debug.print("\n", .{});
}

var buf: [128]f64 = undefined;

// THE HALFWAY CASES ARE THE WHOLE POINT, on both signs, and 0.49999999999999994
// is the one that is not a halfway case at all: it is the largest double BELOW a
// half, so `x + 0.5` rounds up to exactly 1.0 and any round built on that
// addition answers 1 where @round answers 0. The 0..255 entries are the colour
// channels sky and mountains actually round; the degrees are rider's turn angles.
const ROUND_IN = [_]f64{
    -255.5,  -128.5,  -90.0,  -80.4,  -70.5,  -2.5,   -1.5,
    -0.50000000000000011, -0.5,   -0.49999999999999994, -0.25,  0.0,
    0.25,    0.49999999999999994, 0.5,    1.5,    2.5,
    4.5,     14.5,    19.5,    29.5,   49.5,   70.5,   127.5,
    128.5,   254.5,   255.0,   1048576.5,
};

// @floor has no caller in the game at all -- it exists here because floored
// modulo is defined in terms of it -- so the domain graded is modulo's, plus the
// integers and half-integers either side of zero where truncation and flooring
// part company.
const FLOOR_IN = [_]f64{
    -1000.5, -120.0, -119.5, -2.5, -2.0, -1.5, -1.0, -0.5,
    0.0,     0.5,    1.0,    1.5,  2.0,  2.5,  119.5, 120.0, 1000.5,
};

// tower.zig's beacon is the one caller: `@mod(@mod(phase, 120) + 120, 120)`.
// The x table walks several periods either side of zero; the divisors add a
// negative one, where floored and truncated modulo differ in SIGN and nothing in
// the game would notice.
const MOD_X = [_]f64{
    -1000.0, -240.0, -239.5, -120.0, -119.5, -0.5, 0.0, 0.5,
    119.5,   120.0,  240.5,  1000.0, 3600.25,
};
const MOD_M = [_]f64{ 120.0, 7.5, -120.0 };

// rider.zig's shoulder brake is `@exp(-n / 20)` with n up to 2000 frames, so the
// argument reaches -100 and the answer is 3.7e-44. The values around +-0.3466 are
// half a ln 2 -- the edge of the range reduction, where k changes -- and they are
// the inputs that decide whether the reduction and the series meet cleanly.
const EXP_IN = [_]f64{
    -100.0, -50.0, -20.0, -5.0, -2.5, -1.0, -0.6931471805599453,
    -0.3465735902799727, -0.34657359027997264, -0.05, 0.0, 0.05,
    0.3465735902799727, 0.6931471805599453, 1.0, 2.5, 5.0, 20.0,
};

// pow2-int is what the reduction scales BY, and it is claimed exact. @exp2 of a
// whole number is exact, so this is an equality test rather than a tolerance one.
//
// IT STOPS AT 55 BECAUSE OF THE COMPILER, NOT BECAUSE OF THE CHAPTER. 2^60 needs
// a nineteen-digit decimal, and Codex parses a Real literal by accumulating its
// digits into a wrapping i64: 1152921504606846976.0 reaches the program as
// -691752902764108160.0, silently. This table found it -- `n-pow2 BAD at 8` was
// the gold literal being wrong, not pow2-int -- and harness/gen_gold.py now
// REFUSES to write such a value rather than let a gold file carry it. 2^55 fits
// in seventeen digits with room to spare.
const POW2_K = [_]i64{ -55, -20, -8, -1, 0, 1, 8, 20, 55 };

pub fn main() void {
    reals("n-round-in", &ROUND_IN);
    for (ROUND_IN, 0..) |x, i| buf[i] = @round(x);
    reals("n-round", buf[0..ROUND_IN.len]);

    reals("n-floor-in", &FLOOR_IN);
    for (FLOOR_IN, 0..) |x, i| buf[i] = @floor(x);
    reals("n-floor", buf[0..FLOOR_IN.len]);

    reals("n-mod-x", &MOD_X);
    reals("n-mod-m", &MOD_M);
    var n: usize = 0;
    for (MOD_M) |m| for (MOD_X) |x| {
        buf[n] = @mod(x, m);
        n += 1;
    };
    reals("n-mod", buf[0..n]);

    reals("n-exp-in", &EXP_IN);
    for (EXP_IN, 0..) |x, i| buf[i] = @exp(x);
    reals("n-exp", buf[0..EXP_IN.len]);

    ints("n-pow2-k", &POW2_K);
    for (POW2_K, 0..) |k, i| buf[i] = std.math.exp2(@as(f64, @floatFromInt(k)));
    reals("n-pow2", buf[0..POW2_K.len]);
}

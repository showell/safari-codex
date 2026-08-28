const std = @import("std");
const camera = @import("wasm/camera.zig");
const geom = @import("wasm/geom.zig");

fn p(comptime name: []const u8, v: f32) void {
    std.debug.print("{s} {d:.6}\n", .{ name, v });
}

pub fn main() !void {
    p("focal", camera.FOCAL);
    const s = camera.project(.{ .right = 3.0, .forward = 20.0, .height = 0 }, camera.FOCAL);
    p("px", s.x);
    p("py", s.y);
    p("camfocal", camera.camFocal(0.5, 0.2));
    const r = geom.toRider(10.0, 3.0, 2.0, 0.5, 0.3, 4.0);
    p("rider.right", r.right);
    p("rider.forward", r.forward);
    p("drop", geom.groundDrop(300.0, 900.0));
}

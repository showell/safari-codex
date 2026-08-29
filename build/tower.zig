fn Tup2(comptime a_: type, comptime b_: type) type {
    return union(enum) {
    MkTup2: struct { a_, b_ },
    };
}

fn Tup3(comptime a_: type, comptime b_: type, comptime c_: type) type {
    return union(enum) {
    MkTup3: struct { a_, b_, c_ },
    };
}

fn Tup4(comptime a_: type, comptime b_: type, comptime c_: type, comptime d_: type) type {
    return union(enum) {
    MkTup4: struct { a_, b_, c_, d_ },
    };
}

fn Tup5(comptime a_: type, comptime b_: type, comptime c_: type, comptime d_: type, comptime e_: type) type {
    return union(enum) {
    MkTup5: struct { a_, b_, c_, d_, e_ },
    };
}

const RiderPtS = struct {
    right: f64,
    forward: f64,
};
const RiderPt = *RiderPtS;

const Vec3S = struct {
    right: f64,
    forward: f64,
    height: f64,
};
const Vec3 = *Vec3S;

const AXS = struct {
    a_: f64,
    x: f64,
};
const AX = *AXS;

const ScreenPtS = struct {
    x: f64,
    y: f64,
};
const ScreenPt = *ScreenPtS;

const DrawCmdS = struct {
    tag: i64,
    color: i64,
    strength: f64,
    pts: *CxList(f64),
};
const DrawCmd = *DrawCmdS;

fn real_sqrt(x: f64) f64 {
    return @as(f64, (if ((x <= @as(f64, @bitCast(@as(i64, 0))))) @as(f64, @bitCast(@as(i64, 0))) else dm_sqrt_scaled(x, @as(f64, @bitCast(@as(i64, 4607182418800017408))), 700)));
}

fn dm_sqrt_scaled(x: f64, s_: f64, fuel: i64) f64 {
    var _tl_x = x;
    var _tl_s = s_;
    var _tl_fuel = fuel;
    while (true) {
        if ((_tl_fuel <= 0)) { return (_tl_s * dm_sqrt_core(_tl_x)); } else { if ((_tl_x >= @as(f64, @bitCast(@as(i64, 4616189618054758400))))) { { const _tj2_0 = (_tl_x / @as(f64, @bitCast(@as(i64, 4616189618054758400)))); const _tj2_1 = (_tl_s * @as(f64, @bitCast(@as(i64, 4611686018427387904)))); const _tj2_2 = (_tl_fuel -% 1); _tl_x = _tj2_0; _tl_s = _tj2_1; _tl_fuel = _tj2_2; continue; } } else { if ((_tl_x < @as(f64, @bitCast(@as(i64, 4598175219545276416))))) { { const _tj3_0 = (_tl_x * @as(f64, @bitCast(@as(i64, 4616189618054758400)))); const _tj3_1 = (_tl_s * @as(f64, @bitCast(@as(i64, 4602678819172646912)))); const _tj3_2 = (_tl_fuel -% 1); _tl_x = _tj3_0; _tl_s = _tj3_1; _tl_fuel = _tj3_2; continue; } } else { return (_tl_s * dm_sqrt_core(_tl_x)); } } }
    }
}

fn dm_sqrt_core(r_: f64) f64 {
    return b0: { const g0: f64 = ((r_ + @as(f64, @bitCast(@as(i64, 4607182418800017408)))) * @as(f64, @bitCast(@as(i64, 4602678819172646912)))); break :b0 b1: { const g1: f64 = ((g0 + (r_ / g0)) * @as(f64, @bitCast(@as(i64, 4602678819172646912)))); break :b1 b2: { const g2: f64 = ((g1 + (r_ / g1)) * @as(f64, @bitCast(@as(i64, 4602678819172646912)))); break :b2 b3: { const g3: f64 = ((g2 + (r_ / g2)) * @as(f64, @bitCast(@as(i64, 4602678819172646912)))); break :b3 b4: { const g4: f64 = ((g3 + (r_ / g3)) * @as(f64, @bitCast(@as(i64, 4602678819172646912)))); break :b4 ((g4 + (r_ / g4)) * @as(f64, @bitCast(@as(i64, 4602678819172646912)))); }; }; }; }; };
}

fn pi() f64 {
    return @as(f64, @bitCast(@as(i64, 4614256656552045848)));
}

fn two_pi() f64 {
    return @as(f64, @bitCast(@as(i64, 4618760256179416344)));
}

fn half_pi() f64 {
    return @as(f64, @bitCast(@as(i64, 4609753056924675354)));
}

fn deg() f64 {
    return @as(f64, @bitCast(@as(i64, 4580687790476533049)));
}

fn sin_poly(r_: f64) f64 {
    return b0: { const r2: f64 = (r_ * r_); break :b0 b1: { const r3: f64 = (r2 * r_); break :b1 b2: { const r5: f64 = (r3 * r2); break :b2 b3: { const r7: f64 = (r5 * r2); break :b3 b4: { const r9: f64 = (r7 * r2); break :b4 b5: { const r11: f64 = (r9 * r2); break :b5 (((((r_ - (r3 / @as(f64, @bitCast(@as(i64, 4618441417868443648))))) + (r5 / @as(f64, @bitCast(@as(i64, 4638144666238189568))))) - (r7 / @as(f64, @bitCast(@as(i64, 4662263553305083904))))) + (r9 / @as(f64, @bitCast(@as(i64, 4689977843394805760))))) - (r11 / @as(f64, @bitCast(@as(i64, 4720626352061939712))))); }; }; }; }; }; };
}

fn fold_quadrant(r_: f64) f64 {
    return (if ((r_ > half_pi())) (pi() - r_) else (if ((r_ < (@as(f64, @bitCast(@as(i64, 0))) - half_pi()))) ((@as(f64, @bitCast(@as(i64, 0))) - pi()) - r_) else r_));
}

fn wrap(x: f64, fuel: i64) f64 {
    var _tl_x = x;
    var _tl_fuel = fuel;
    while (true) {
        if ((_tl_fuel <= 0)) { return _tl_x; } else { if ((_tl_x > pi())) { { const _tj2_0 = (_tl_x - two_pi()); const _tj2_1 = (_tl_fuel -% 1); _tl_x = _tj2_0; _tl_fuel = _tj2_1; continue; } } else { if ((_tl_x < (@as(f64, @bitCast(@as(i64, 0))) - pi()))) { { const _tj3_0 = (_tl_x + two_pi()); const _tj3_1 = (_tl_fuel -% 1); _tl_x = _tj3_0; _tl_fuel = _tj3_1; continue; } } else { return _tl_x; } } }
    }
}

fn r_sin(x: f64) f64 {
    return sin_poly(fold_quadrant(wrap(x, 64)));
}

fn r_cos(x: f64) f64 {
    return r_sin((x + half_pi()));
}

fn r_tan(x: f64) f64 {
    return (r_sin(x) / r_cos(x));
}

fn camera_w() f64 {
    return @as(f64, @bitCast(@as(i64, 4651655465120301056)));
}

fn camera_h() f64 {
    return @as(f64, @bitCast(@as(i64, 4648488871632306176)));
}

fn eye_h() f64 {
    return @as(f64, @bitCast(@as(i64, 4608083138725491507)));
}

fn near() f64 {
    return @as(f64, @bitCast(@as(i64, 4600877379321698714)));
}

fn fov_deg() f64 {
    return @as(f64, @bitCast(@as(i64, 4634626229029306368)));
}

fn focal() f64 {
    return ((camera_w() / @as(f64, @bitCast(@as(i64, 4611686018427387904)))) / r_tan(((fov_deg() / @as(f64, @bitCast(@as(i64, 4611686018427387904)))) * deg())));
}

fn project(p_: Vec3, cf: f64, view_w: f64) ScreenPt {
    return cx_new(ScreenPtS{ .x = ((view_w / @as(f64, @bitCast(@as(i64, 4611686018427387904)))) + ((p_.right / p_.forward) * cf)), .y = ((camera_h() / @as(f64, @bitCast(@as(i64, 4611686018427387904)))) - (((p_.height - eye_h()) / p_.forward) * cf)) });
}

fn flatten_screen(ps: *CxList(ScreenPt), i_: i64) *CxList(f64) {
    return (if ((i_ >= cx_list_len(ps))) cx_ll_empty(f64) else b1: { const p_ = cx_list_at(ps, i_); break :b1 cx_ll_concat(cx_ll_of(f64, &[_]f64{ p_.x, p_.y }), flatten_screen(ps, (i_ +% 1))); });
}

fn push_poly(color: i64, ps: *CxList(ScreenPt)) *CxList(DrawCmd) {
    return (if ((cx_list_len(ps) < 3)) cx_ll_empty(DrawCmd) else cx_ll_of(DrawCmd, &[_]DrawCmd{ cx_new(DrawCmdS{ .tag = 0, .color = color, .strength = @as(f64, @bitCast(@as(i64, 0))), .pts = flatten_screen(ps, 0) }) }));
}

fn push_beacon(color: i64, x: f64, y: f64, r_: f64, alpha: f64) *CxList(DrawCmd) {
    return cx_ll_of(DrawCmd, &[_]DrawCmd{ cx_new(DrawCmdS{ .tag = 3, .color = color, .strength = alpha, .pts = cx_ll_of(f64, &[_]f64{ x, y, r_ }) }) });
}

fn floor_real(x: f64) f64 {
    return b0: { const t: f64 = cx_real_from_int(cx_real_to_int(x)); break :b0 (if ((t > x)) (t - @as(f64, @bitCast(@as(i64, 4607182418800017408)))) else t); };
}

fn mod_real(x: f64, m_: f64) f64 {
    return (x - (m_ * floor_real((x / m_))));
}

fn tower_height() f64 {
    return @as(f64, @bitCast(@as(i64, 4635329916471083008)));
}

fn tower_half() f64 {
    return @as(f64, @bitCast(@as(i64, 4618441417868443648)));
}

fn stage_height() f64 {
    return @as(f64, @bitCast(@as(i64, 4626322717216342016)));
}

fn brace_stages() i64 {
    return 2;
}

fn rod_half() f64 {
    return @as(f64, @bitCast(@as(i64, 4593311331947716280)));
}

fn rod_w() f64 {
    return (rod_half() * @as(f64, @bitCast(@as(i64, 4611686018427387904))));
}

fn tower_metal() i64 {
    return 10133672;
}

fn earth_radius() f64 {
    return @as(f64, @bitCast(@as(i64, 4671226772094713856)));
}

fn beacon_radius() f64 {
    return @as(f64, @bitCast(@as(i64, 4613937818241073152)));
}

fn beacon_color() i64 {
    return 16723942;
}

fn beacon_period() f64 {
    return @as(f64, @bitCast(@as(i64, 4638144666238189568)));
}

fn beacon_offset_for(n_: i64) f64 {
    return cx_real_from_int(((n_ *% 37) -% (@divTrunc((n_ *% 37), 120) *% 120)));
}

fn beacon_brightness(phase: f64) f64 {
    return b0: { const wrapped: f64 = mod_real((mod_real(phase, beacon_period()) + beacon_period()), beacon_period()); break :b0 ((@as(f64, @bitCast(@as(i64, 4607182418800017408))) - r_cos((((@as(f64, @bitCast(@as(i64, 4611686018427387904))) * pi()) * wrapped) / beacon_period()))) / @as(f64, @bitCast(@as(i64, 4611686018427387904)))); };
}

fn base_corner_ax(k_: i64, a0: f64, x0: f64, yaw: f64) AX {
    return b0: { const du: f64 = ((if ((k_ == 0)) (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4607182418800017408)))) else @as(f64, (if ((k_ == 1)) @as(f64, @bitCast(@as(i64, 4607182418800017408))) else @as(f64, (if ((k_ == 2)) @as(f64, @bitCast(@as(i64, 4607182418800017408))) else (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4607182418800017408))))))))) * tower_half()); break :b0 b1: { const dv: f64 = ((if ((k_ == 0)) (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4607182418800017408)))) else (if ((k_ == 1)) (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4607182418800017408)))) else @as(f64, (if ((k_ == 2)) @as(f64, @bitCast(@as(i64, 4607182418800017408))) else @as(f64, @bitCast(@as(i64, 4607182418800017408))))))) * tower_half()); break :b1 b2: { const cy: f64 = r_cos(yaw); break :b2 b3: { const sy: f64 = r_sin(yaw); break :b3 cx_new(AXS{ .a_ = (a0 + ((du * sy) + (dv * cy))), .x = (x0 + ((du * cy) - (dv * sy))) }); }; }; }; };
}

fn lerp3v(a_: Vec3, b_: Vec3, t: f64) Vec3 {
    return cx_new(Vec3S{ .right = (a_.right + ((b_.right - a_.right) * t)), .forward = (a_.forward + ((b_.forward - a_.forward) * t)), .height = (a_.height + ((b_.height - a_.height) * t)) });
}

fn corner_at(base_: *CxList(RiderPt), center: RiderPt, k_: i64, h_: f64, drop: f64) Vec3 {
    return b0: { const t: f64 = (h_ / tower_height()); break :b0 b1: { const bk = cx_list_at(base_, k_); break :b1 cx_new(Vec3S{ .right = (bk.right + ((center.right - bk.right) * t)), .forward = (bk.forward + ((center.forward - bk.forward) * t)), .height = (h_ - drop) }); }; };
}

fn bar(a_: ScreenPt, b_: ScreenPt, wpx: f64) *CxList(DrawCmd) {
    return b0: { const dx: f64 = (b_.x - a_.x); break :b0 b1: { const dy: f64 = (b_.y - a_.y); break :b1 b2: { const raw_: f64 = real_sqrt(((dx * dx) + (dy * dy))); break :b2 b3: { const len_: f64 = @as(f64, (if ((raw_ < @as(f64, @bitCast(@as(i64, 4547007122018943789))))) @as(f64, @bitCast(@as(i64, 4607182418800017408))) else raw_)); break :b3 bar_quad(a_, b_, ((((@as(f64, @bitCast(@as(i64, 0))) - dy) / len_) * wpx) / @as(f64, @bitCast(@as(i64, 4611686018427387904)))), (((dx / len_) * wpx) / @as(f64, @bitCast(@as(i64, 4611686018427387904))))); }; }; }; };
}

fn bar_quad(a_: ScreenPt, b_: ScreenPt, ox: f64, oy: f64) *CxList(DrawCmd) {
    return push_poly(tower_metal(), cx_ll_of(ScreenPt, &[_]ScreenPt{ cx_new(ScreenPtS{ .x = (a_.x + ox), .y = (a_.y + oy) }), cx_new(ScreenPtS{ .x = (b_.x + ox), .y = (b_.y + oy) }), cx_new(ScreenPtS{ .x = (b_.x - ox), .y = (b_.y - oy) }), cx_new(ScreenPtS{ .x = (a_.x - ox), .y = (a_.y - oy) }) }));
}

fn bar3d(a_: Vec3, b_: Vec3, wpx: f64, cf: f64, view_w: f64) *CxList(DrawCmd) {
    return b0: { const a_in: bool = (a_.forward >= near()); break :b0 b1: { const b_in: bool = (b_.forward >= near()); break :b1 (if (a_in) (if (b_in) bar3d_draw(a_, b_, wpx, cf, view_w) else bar3d_draw(a_, bar3d_cut(a_, b_), wpx, cf, view_w)) else (if (b_in) bar3d_draw(bar3d_cut(a_, b_), b_, wpx, cf, view_w) else cx_ll_empty(DrawCmd))); }; };
}

fn bar3d_cut(a_: Vec3, b_: Vec3) Vec3 {
    return lerp3v(a_, b_, ((near() - a_.forward) / (b_.forward - a_.forward)));
}

fn bar3d_draw(a_: Vec3, b_: Vec3, wpx: f64, cf: f64, view_w: f64) *CxList(DrawCmd) {
    return bar(project(a_, cf, view_w), project(b_, cf, view_w), wpx);
}

fn rod_px(forward: f64, cf: f64, view_w: f64) f64 {
    return b0: { const p1 = project(cx_new(Vec3S{ .right = @as(f64, @bitCast(@as(i64, 4607182418800017408))), .forward = forward, .height = @as(f64, @bitCast(@as(i64, 0))) }), cf, view_w); break :b0 b1: { const p0 = project(cx_new(Vec3S{ .right = @as(f64, @bitCast(@as(i64, 0))), .forward = forward, .height = @as(f64, @bitCast(@as(i64, 0))) }), cf, view_w); break :b1 (rod_w() * (p1.x - p0.x)); }; };
}

fn tower_legs(base_: *CxList(RiderPt), center: RiderPt, apex: Vec3, clip_h: f64, drop: f64, wpx: f64, cf: f64, view_w: f64, k_: i64) *CxList(DrawCmd) {
    return (if ((k_ >= 4)) cx_ll_empty(DrawCmd) else cx_ll_concat(bar3d(corner_at(base_, center, k_, clip_h, drop), apex, wpx, cf, view_w), tower_legs(base_, center, apex, clip_h, drop, wpx, cf, view_w, (k_ +% 1))));
}

fn ring_at(base_: *CxList(RiderPt), center: RiderPt, h_: f64, drop: f64, wpx: f64, cf: f64, view_w: f64, k_: i64) *CxList(DrawCmd) {
    return (if ((k_ >= 4)) cx_ll_empty(DrawCmd) else cx_ll_concat(bar3d(corner_at(base_, center, k_, h_, drop), corner_at(base_, center, ((k_ +% 1) -% (@divTrunc((k_ +% 1), 4) *% 4)), h_, drop), wpx, cf, view_w), ring_at(base_, center, h_, drop, wpx, cf, view_w, (k_ +% 1))));
}

fn rings(base_: *CxList(RiderPt), center: RiderPt, h_: f64, clip_h: f64, drop: f64, wpx: f64, cf: f64, view_w: f64) *CxList(DrawCmd) {
    return (if ((h_ >= tower_height())) cx_ll_empty(DrawCmd) else cx_ll_concat((if ((h_ <= clip_h)) cx_ll_empty(DrawCmd) else ring_at(base_, center, h_, drop, wpx, cf, view_w, 0)), rings(base_, center, (h_ + stage_height()), clip_h, drop, wpx, cf, view_w)));
}

fn brace_at(base_: *CxList(RiderPt), center: RiderPt, lo: f64, hi: f64, f: f64, drop: f64, wpx: f64, cf: f64, view_w: f64, k_: i64) *CxList(DrawCmd) {
    return (if ((k_ >= 4)) cx_ll_empty(DrawCmd) else brace_pair(base_, center, lo, hi, f, drop, wpx, cf, view_w, k_));
}

fn brace_pair(base_: *CxList(RiderPt), center: RiderPt, lo: f64, hi: f64, f: f64, drop: f64, wpx: f64, cf: f64, view_w: f64, k_: i64) *CxList(DrawCmd) {
    return b0: { const j: i64 = ((k_ +% 1) -% (@divTrunc((k_ +% 1), 4) *% 4)); break :b0 b1: { const kj = bar3d(lerp3v(corner_at(base_, center, k_, lo, drop), corner_at(base_, center, j, hi, drop), f), corner_at(base_, center, j, hi, drop), wpx, cf, view_w); break :b1 b2: { const jk = bar3d(lerp3v(corner_at(base_, center, j, lo, drop), corner_at(base_, center, k_, hi, drop), f), corner_at(base_, center, k_, hi, drop), wpx, cf, view_w); break :b2 cx_ll_concat(cx_ll_concat(kj, jk), brace_at(base_, center, lo, hi, f, drop, wpx, cf, view_w, (k_ +% 1))); }; }; };
}

fn braces(base_: *CxList(RiderPt), center: RiderPt, clip_h: f64, drop: f64, wpx: f64, cf: f64, view_w: f64, stage: i64) *CxList(DrawCmd) {
    return (if ((stage >= brace_stages())) cx_ll_empty(DrawCmd) else brace_stage(base_, center, clip_h, drop, wpx, cf, view_w, stage));
}

fn brace_stage(base_: *CxList(RiderPt), center: RiderPt, clip_h: f64, drop: f64, wpx: f64, cf: f64, view_w: f64, stage: i64) *CxList(DrawCmd) {
    return b0: { const lo: f64 = (cx_real_from_int(stage) * stage_height()); break :b0 b1: { const hi: f64 = (lo + stage_height()); break :b1 b2: { const rest = braces(base_, center, clip_h, drop, wpx, cf, view_w, (stage +% 1)); break :b2 (if ((hi <= clip_h)) rest else cx_ll_concat(brace_at(base_, center, lo, hi, (((if ((lo > clip_h)) lo else clip_h) - lo) / stage_height()), drop, wpx, cf, view_w, 0), rest)); }; }; };
}

fn draw_beacon(apex_s: ScreenPt, forward: f64, cf: f64, view_w: f64, bright: f64) *CxList(DrawCmd) {
    return (if ((bright < @as(f64, @bitCast(@as(i64, 4581421828931458171))))) cx_ll_empty(DrawCmd) else beacon_disc(apex_s, forward, cf, view_w, bright));
}

fn beacon_disc(apex_s: ScreenPt, forward: f64, cf: f64, view_w: f64, bright: f64) *CxList(DrawCmd) {
    return b0: { const p1 = project(cx_new(Vec3S{ .right = @as(f64, @bitCast(@as(i64, 4607182418800017408))), .forward = forward, .height = @as(f64, @bitCast(@as(i64, 0))) }), cf, view_w); break :b0 b1: { const p0 = project(cx_new(Vec3S{ .right = @as(f64, @bitCast(@as(i64, 0))), .forward = forward, .height = @as(f64, @bitCast(@as(i64, 0))) }), cf, view_w); break :b1 b2: { const r_: f64 = (beacon_radius() * (p1.x - p0.x)); break :b2 (if ((r_ < @as(f64, @bitCast(@as(i64, 4602678819172646912))))) cx_ll_empty(DrawCmd) else push_beacon(beacon_color(), apex_s.x, apex_s.y, r_, bright)); }; }; };
}

fn draw_flat(base_: *CxList(RiderPt), center: RiderPt, cf: f64, view_w: f64, beacon_phase: f64) *CxList(DrawCmd) {
    return (if ((center.forward < near())) cx_ll_empty(DrawCmd) else draw_flat_body(base_, center, cf, view_w, beacon_phase, (((center.right * center.right) + (center.forward * center.forward)) / (@as(f64, @bitCast(@as(i64, 4611686018427387904))) * earth_radius()))));
}

fn draw_flat_body(base_: *CxList(RiderPt), center: RiderPt, cf: f64, view_w: f64, beacon_phase: f64, drop: f64) *CxList(DrawCmd) {
    return (if ((drop >= tower_height())) cx_ll_empty(DrawCmd) else draw_flat_rods(base_, center, cf, view_w, beacon_phase, drop));
}

fn draw_flat_rods(base_: *CxList(RiderPt), center: RiderPt, cf: f64, view_w: f64, beacon_phase: f64, drop: f64) *CxList(DrawCmd) {
    return b0: { const apex = cx_new(Vec3S{ .right = center.right, .forward = center.forward, .height = (tower_height() - drop) }); break :b0 b1: { const wpx: f64 = rod_px(center.forward, cf, view_w); break :b1 b2: { const l_ = tower_legs(base_, center, apex, drop, drop, wpx, cf, view_w, 0); break :b2 b3: { const r_ = rings(base_, center, stage_height(), drop, drop, wpx, cf, view_w); break :b3 b4: { const x = braces(base_, center, drop, drop, wpx, cf, view_w, 0); break :b4 b5: { const b_ = draw_beacon(project(apex, cf, view_w), center.forward, cf, view_w, beacon_brightness(beacon_phase)); break :b5 cx_ll_concat(cx_ll_concat(cx_ll_concat(l_, r_), x), b_); }; }; }; }; }; };
}

fn g_abs(x: f64) f64 {
    return (if ((x < @as(f64, @bitCast(@as(i64, 0))))) (@as(f64, @bitCast(@as(i64, 0))) - x) else x);
}

fn g_max(a_: f64, b_: f64) f64 {
    return (if ((a_ > b_)) a_ else b_);
}

fn first_rel_diff(got: *CxList(f64), want: *CxList(f64), tol: f64, i_: i64) i64 {
    var _tl_i = i_;
    while (true) {
        if ((_tl_i >= cx_list_len(got))) { return (0 -% 1); } else { const w: f64 = cx_list_at(want, _tl_i); if ((g_abs((cx_list_at(got, _tl_i) - w)) > (tol * g_max(@as(f64, @bitCast(@as(i64, 4607182418800017408))), g_abs(w))))) { return _tl_i; } else { { const _tj3_3 = (_tl_i +% 1); _tl_i = _tj3_3; continue; } } }
    }
}

fn grade_rel(name: []const u8, got: *CxList(f64), want: *CxList(f64), tol: f64) []const u8 {
    return (if ((cx_list_len(got) != cx_list_len(want))) cx_concat(cx_concat(cx_concat(cx_concat(name, "\x02\x3a\x29\x30\x02\x17\x0d\x12\x1d\x0e\x14\x02"), cx_show_int(cx_list_len(got))), "\x02\x1b\x0f\x12\x0e\x02"), cx_show_int(cx_list_len(want))) else b1: { const i_: i64 = first_rel_diff(got, want, tol, 0); break :b1 (if ((i_ < 0)) cx_concat(cx_concat(name, "\x02\x10\x22\x02"), cx_show_int(cx_list_len(got))) else cx_concat(cx_concat(name, "\x02\x3a\x29\x30\x02\x0f\x0e\x02"), cx_show_int(i_))); });
}

fn grade_px(name: []const u8, got: *CxList(f64), want: *CxList(f64), atol: f64, rtol: f64) []const u8 {
    return (if ((cx_list_len(got) != cx_list_len(want))) cx_concat(cx_concat(cx_concat(cx_concat(name, "\x02\x3a\x29\x30\x02\x17\x0d\x12\x1d\x0e\x14\x02"), cx_show_int(cx_list_len(got))), "\x02\x1b\x0f\x12\x0e\x02"), cx_show_int(cx_list_len(want))) else b1: { const i_: i64 = first_px_diff(got, want, atol, rtol, 0); break :b1 (if ((i_ < 0)) cx_concat(cx_concat(name, "\x02\x10\x22\x02"), cx_show_int(cx_list_len(got))) else cx_concat(cx_concat(name, "\x02\x3a\x29\x30\x02\x0f\x0e\x02"), cx_show_int(i_))); });
}

fn first_px_diff(got: *CxList(f64), want: *CxList(f64), atol: f64, rtol: f64, i_: i64) i64 {
    var _tl_i = i_;
    while (true) {
        if ((_tl_i >= cx_list_len(got))) { return (0 -% 1); } else { const w: f64 = cx_list_at(want, _tl_i); if ((g_abs((cx_list_at(got, _tl_i) - w)) > (atol + (rtol * g_abs(w))))) { return _tl_i; } else { { const _tj3_4 = (_tl_i +% 1); _tl_i = _tj3_4; continue; } } }
    }
}

fn first_int_diff(got: *CxList(i64), want: *CxList(i64), i_: i64) i64 {
    var _tl_i = i_;
    while (true) {
        if ((_tl_i >= cx_list_len(got))) { return (0 -% 1); } else { if ((cx_list_at(got, _tl_i) != cx_list_at(want, _tl_i))) { return _tl_i; } else { { const _tj2_2 = (_tl_i +% 1); _tl_i = _tj2_2; continue; } } }
    }
}

fn grade_ints(name: []const u8, got: *CxList(i64), want: *CxList(i64)) []const u8 {
    return (if ((cx_list_len(got) != cx_list_len(want))) cx_concat(cx_concat(cx_concat(cx_concat(name, "\x02\x3a\x29\x30\x02\x17\x0d\x12\x1d\x0e\x14\x02"), cx_show_int(cx_list_len(got))), "\x02\x1b\x0f\x12\x0e\x02"), cx_show_int(cx_list_len(want))) else b1: { const i_: i64 = first_int_diff(got, want, 0); break :b1 (if ((i_ < 0)) cx_concat(cx_concat(name, "\x02\x10\x22\x02"), cx_show_int(cx_list_len(got))) else cx_concat(cx_concat(cx_concat(cx_concat(cx_concat(cx_concat(name, "\x02\x3a\x29\x30\x02\x0f\x0e\x02"), cx_show_int(i_)), "\x02\x1d\x10\x0e\x02"), cx_show_int(cx_list_at(got, i_))), "\x02\x1b\x0f\x12\x0e\x02"), cx_show_int(cx_list_at(want, i_)))); });
}

fn g_tw_offset() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4630404104378646528))), @as(f64, @bitCast(@as(i64, 4634907704006017024))), @as(f64, @bitCast(@as(i64, 4637511347540590592))), @as(f64, @bitCast(@as(i64, 4626041242239631360))), @as(f64, @bitCast(@as(i64, 4635611391447793664))), @as(f64, @bitCast(@as(i64, 4630826316843712512))), @as(f64, @bitCast(@as(i64, 4635541022703616000))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4630404104378646528))) });
}

fn g_tw_percase() *CxList(i64) {
    return cx_ll_of(i64, &[_]i64{ 33, 33, 20, 5, 0, 0, 33 });
}

fn g_tw_tags() *CxList(i64) {
    @setEvalBranchQuota(1000000);
    return cx_ll_of(i64, &[_]i64{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3 });
}

fn g_tw_colors() *CxList(i64) {
    @setEvalBranchQuota(1000000);
    return cx_ll_of(i64, &[_]i64{ 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 16723942, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 16723942, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 16723942, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 16723942 });
}

fn g_tw_counts() *CxList(i64) {
    @setEvalBranchQuota(1000000);
    return cx_ll_of(i64, &[_]i64{ 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 3 });
}

fn g_tw_strengths() *CxList(f64) {
    @setEvalBranchQuota(1000000);
    return cx_ll_of(f64, &[_]f64{ @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4607182418800017408))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4602678819172646912))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4602678819172646912))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4605863344192918130))) });
}

fn g_tw_coords() *CxList(f64) {
    @setEvalBranchQuota(1000000);
    return cx_ll_of(f64, &[_]f64{ @as(f64, @bitCast(@as(i64, 4652705781519217800))), @as(f64, @bitCast(@as(i64, 4646337661475516852))), @as(f64, @bitCast(@as(i64, 4651361265715424474))), (-@as(f64, @bitCast(@as(i64, 4660043451532018136)))), @as(f64, @bitCast(@as(i64, 4651258037406543747))), (-@as(f64, @bitCast(@as(i64, 4660042104850176436)))), @as(f64, @bitCast(@as(i64, 4652654167804582088))), @as(f64, @bitCast(@as(i64, 4646348432115500686))), @as(f64, @bitCast(@as(i64, 4654554079477109254))), @as(f64, @bitCast(@as(i64, 4645307631242054436))), @as(f64, @bitCast(@as(i64, 4651360688691722217))), (-@as(f64, @bitCast(@as(i64, 4660044816685655183)))), @as(f64, @bitCast(@as(i64, 4651258614430246004))), (-@as(f64, @bitCast(@as(i64, 4660040739696539389)))), @as(f64, @bitCast(@as(i64, 4654503042346371147))), @as(f64, @bitCast(@as(i64, 4645340248210511946))), @as(f64, @bitCast(@as(i64, 4650847029844574103))), @as(f64, @bitCast(@as(i64, 4644648767634787805))), @as(f64, @bitCast(@as(i64, 4651361329663020745))), (-@as(f64, @bitCast(@as(i64, 4660042584457148472)))), @as(f64, @bitCast(@as(i64, 4651257973195064685))), (-@as(f64, @bitCast(@as(i64, 4660042971925046100)))), @as(f64, @bitCast(@as(i64, 4650743673552539904))), @as(f64, @bitCast(@as(i64, 4644645665604622594))), @as(f64, @bitCast(@as(i64, 4647883884710527081))), @as(f64, @bitCast(@as(i64, 4644837560642229502))), @as(f64, @bitCast(@as(i64, 4651361073080987288))), (-@as(f64, @bitCast(@as(i64, 4660041477248939301)))), @as(f64, @bitCast(@as(i64, 4651258230040980934))), (-@as(f64, @bitCast(@as(i64, 4660044079133255270)))), @as(f64, @bitCast(@as(i64, 4647781041670520727))), @as(f64, @bitCast(@as(i64, 4644816743808483144))), @as(f64, @bitCast(@as(i64, 4652262952771326365))), (-@as(f64, @bitCast(@as(i64, 4653373578262635925)))), @as(f64, @bitCast(@as(i64, 4653673713271083893))), (-@as(f64, @bitCast(@as(i64, 4650306133015773420)))), @as(f64, @bitCast(@as(i64, 4653716686583543890))), (-@as(f64, @bitCast(@as(i64, 4650363561827506114)))), @as(f64, @bitCast(@as(i64, 4652305926083786362))), (-@as(f64, @bitCast(@as(i64, 4653402293108306923)))), @as(f64, @bitCast(@as(i64, 4653677411588395080))), (-@as(f64, @bitCast(@as(i64, 4650372338569123673)))), @as(f64, @bitCast(@as(i64, 4650850219395864886))), (-@as(f64, @bitCast(@as(i64, 4644895394953850520)))), @as(f64, @bitCast(@as(i64, 4650921372223774550))), (-@as(f64, @bitCast(@as(i64, 4644745429660227454)))), @as(f64, @bitCast(@as(i64, 4653712987826428051))), (-@as(f64, @bitCast(@as(i64, 4650297356274155861)))), @as(f64, @bitCast(@as(i64, 4650909888044724755))), (-@as(f64, @bitCast(@as(i64, 4644911863351050418)))), @as(f64, @bitCast(@as(i64, 4648598790249539594))), (-@as(f64, @bitCast(@as(i64, 4647347192590112874)))), @as(f64, @bitCast(@as(i64, 4648550606131573241))), (-@as(f64, @bitCast(@as(i64, 4647164290326168150)))), @as(f64, @bitCast(@as(i64, 4650861703662875611))), (-@as(f64, @bitCast(@as(i64, 4644728961087105694)))), @as(f64, @bitCast(@as(i64, 4648620291419323079))), (-@as(f64, @bitCast(@as(i64, 4647207057985973288)))), @as(f64, @bitCast(@as(i64, 4652307236261842020))), (-@as(f64, @bitCast(@as(i64, 4653375764971361246)))), @as(f64, @bitCast(@as(i64, 4652261643033075358))), (-@as(f64, @bitCast(@as(i64, 4653400106399581602)))), @as(f64, @bitCast(@as(i64, 4648529104961789755))), (-@as(f64, @bitCast(@as(i64, 4647304424930307736)))), @as(f64, @bitCast(@as(i64, 4651820458450891634))), (-@as(f64, @bitCast(@as(i64, 4657361732996170147)))), @as(f64, @bitCast(@as(i64, 4652944912983728849))), (-@as(f64, @bitCast(@as(i64, 4655813541019619688)))), @as(f64, @bitCast(@as(i64, 4652992514360532481))), (-@as(f64, @bitCast(@as(i64, 4655833675716352174)))), @as(f64, @bitCast(@as(i64, 4651915659709163084))), (-@as(f64, @bitCast(@as(i64, 4657371800344536390)))), @as(f64, @bitCast(@as(i64, 4652945313205961359))), (-@as(f64, @bitCast(@as(i64, 4655834572917840439)))), @as(f64, @bitCast(@as(i64, 4650949303337557269))), (-@as(f64, @bitCast(@as(i64, 4652928853516893553)))), @as(f64, @bitCast(@as(i64, 4651042906697570305))), (-@as(f64, @bitCast(@as(i64, 4652906924856989188)))), @as(f64, @bitCast(@as(i64, 4652992114138299970))), (-@as(f64, @bitCast(@as(i64, 4655812643818131423)))), @as(f64, @bitCast(@as(i64, 4651036067471362747))), (-@as(f64, @bitCast(@as(i64, 4652934277187851046)))), @as(f64, @bitCast(@as(i64, 4649433075043635560))), (-@as(f64, @bitCast(@as(i64, 4653911509928478822)))), @as(f64, @bitCast(@as(i64, 4649353150223998570))), (-@as(f64, @bitCast(@as(i64, 4653878733926659470)))), @as(f64, @bitCast(@as(i64, 4650956142299882036))), (-@as(f64, @bitCast(@as(i64, 4652901501186031695)))), @as(f64, @bitCast(@as(i64, 4649442608249253029))), (-@as(f64, @bitCast(@as(i64, 4653887682192090962)))), @as(f64, @bitCast(@as(i64, 4651917554739443789))), (-@as(f64, @bitCast(@as(i64, 4657363046692663014)))), @as(f64, @bitCast(@as(i64, 4651818563156728139))), (-@as(f64, @bitCast(@as(i64, 4657370486648043523)))), @as(f64, @bitCast(@as(i64, 4649343617018381101))), (-@as(f64, @bitCast(@as(i64, 4653902562102851980)))), @as(f64, @bitCast(@as(i64, 4651494385787222570))), (-@as(f64, @bitCast(@as(i64, 4658919117109831139)))), @as(f64, @bitCast(@as(i64, 4652305558846902685))), (-@as(f64, @bitCast(@as(i64, 4658267442725313420)))), @as(f64, @bitCast(@as(i64, 4652354422902859655))), (-@as(f64, @bitCast(@as(i64, 4658275862125651952)))), @as(f64, @bitCast(@as(i64, 4651592113019527207))), (-@as(f64, @bitCast(@as(i64, 4658927536070365020)))), @as(f64, @bitCast(@as(i64, 4652305115523814366))), (-@as(f64, @bitCast(@as(i64, 4658275153160554362)))), @as(f64, @bitCast(@as(i64, 4651083824626973802))), (-@as(f64, @bitCast(@as(i64, 4657113345183069503)))), @as(f64, @bitCast(@as(i64, 4651183327438615903))), (-@as(f64, @bitCast(@as(i64, 4657106343493023826)))), @as(f64, @bitCast(@as(i64, 4652354866225947974))), (-@as(f64, @bitCast(@as(i64, 4658268151470508684)))), @as(f64, @bitCast(@as(i64, 4651180249509745572))), (-@as(f64, @bitCast(@as(i64, 4657115394452841352)))), @as(f64, @bitCast(@as(i64, 4650346412964550017))), (-@as(f64, @bitCast(@as(i64, 4657553655169724029)))), @as(f64, @bitCast(@as(i64, 4650253066186570439))), (-@as(f64, @bitCast(@as(i64, 4657542554720232328)))), @as(f64, @bitCast(@as(i64, 4651086902731765994))), (-@as(f64, @bitCast(@as(i64, 4657104294223251977)))), @as(f64, @bitCast(@as(i64, 4650350151304084455))), (-@as(f64, @bitCast(@as(i64, 4657545255780497123)))), @as(f64, @bitCast(@as(i64, 4651593661571703767))), (-@as(f64, @bitCast(@as(i64, 4658920477205714698)))), @as(f64, @bitCast(@as(i64, 4651492837235046010))), (-@as(f64, @bitCast(@as(i64, 4658926175754579136)))), @as(f64, @bitCast(@as(i64, 4650249326967426698))), (-@as(f64, @bitCast(@as(i64, 4657550954109459235)))), @as(f64, @bitCast(@as(i64, 4652706228800547979))), @as(f64, @bitCast(@as(i64, 4646361426759644254))), @as(f64, @bitCast(@as(i64, 4653720608761422492))), (-@as(f64, @bitCast(@as(i64, 4650325424606989727)))), @as(f64, @bitCast(@as(i64, 4653669790653400639))), (-@as(f64, @bitCast(@as(i64, 4650344270676094458)))), @as(f64, @bitCast(@as(i64, 4652655410692526126))), @as(f64, @bitCast(@as(i64, 4646323735149200372))), @as(f64, @bitCast(@as(i64, 4654552997557667522))), @as(f64, @bitCast(@as(i64, 4645293822431540732))), @as(f64, @bitCast(@as(i64, 4652309148972269699))), (-@as(f64, @bitCast(@as(i64, 4653395502524493778)))), @as(f64, @bitCast(@as(i64, 4652259729882843028))), (-@as(f64, @bitCast(@as(i64, 4653380369286253720)))), @as(f64, @bitCast(@as(i64, 4654503578468240851))), @as(f64, @bitCast(@as(i64, 4645354357847407009))), @as(f64, @bitCast(@as(i64, 4654545852491305583))), @as(f64, @bitCast(@as(i64, 4645252993958403270))), @as(f64, @bitCast(@as(i64, 4650923551016016151))), (-@as(f64, @bitCast(@as(i64, 4644891003240526392)))), @as(f64, @bitCast(@as(i64, 4650848040075857704))), (-@as(f64, @bitCast(@as(i64, 4644749821373551582)))), @as(f64, @bitCast(@as(i64, 4654508097461031010))), @as(f64, @bitCast(@as(i64, 4645394175649456220))), @as(f64, @bitCast(@as(i64, 4650843547911151262))), @as(f64, @bitCast(@as(i64, 4644688419366600756))), @as(f64, @bitCast(@as(i64, 4653718909796055253))), (-@as(f64, @bitCast(@as(i64, 4650314289632832913)))), @as(f64, @bitCast(@as(i64, 4653671490058572530))), (-@as(f64, @bitCast(@as(i64, 4650355405210446620)))), @as(f64, @bitCast(@as(i64, 4650748708436185815))), @as(f64, @bitCast(@as(i64, 4644606187859529622))), @as(f64, @bitCast(@as(i64, 4650844161878444212))), @as(f64, @bitCast(@as(i64, 4644616963953091129))), @as(f64, @bitCast(@as(i64, 4648624113673584949))), (-@as(f64, @bitCast(@as(i64, 4647286030540579694)))), @as(f64, @bitCast(@as(i64, 4648525282179762304))), (-@as(f64, @bitCast(@as(i64, 4647225452199779469)))), @as(f64, @bitCast(@as(i64, 4650745330384621567))), @as(f64, @bitCast(@as(i64, 4644677542117969494))), @as(f64, @bitCast(@as(i64, 4647879686775132232))), @as(f64, @bitCast(@as(i64, 4644873251141510832))), @as(f64, @bitCast(@as(i64, 4650932040653157465))), (-@as(f64, @bitCast(@as(i64, 4644774253753373787)))), @as(f64, @bitCast(@as(i64, 4650839550966481971))), (-@as(f64, @bitCast(@as(i64, 4644866570860704186)))), @as(f64, @bitCast(@as(i64, 4647787196736613017))), @as(f64, @bitCast(@as(i64, 4644780934034180434))), @as(f64, @bitCast(@as(i64, 4647882272474637040))), @as(f64, @bitCast(@as(i64, 4644858222664738669))), @as(f64, @bitCast(@as(i64, 4652309097515125519))), (-@as(f64, @bitCast(@as(i64, 4653380203040095601)))), @as(f64, @bitCast(@as(i64, 4652259781339987208))), (-@as(f64, @bitCast(@as(i64, 4653395668330847247)))), @as(f64, @bitCast(@as(i64, 4647783639596594836))), @as(f64, @bitCast(@as(i64, 4644796363260950689))), @as(f64, @bitCast(@as(i64, 4652700554001134702))), @as(f64, @bitCast(@as(i64, 4646291169022160530))), @as(f64, @bitCast(@as(i64, 4648619716770565938))), (-@as(f64, @bitCast(@as(i64, 4647306517520837719)))), @as(f64, @bitCast(@as(i64, 4648529679346664106))), (-@as(f64, @bitCast(@as(i64, 4647204965219521444)))), @as(f64, @bitCast(@as(i64, 4652655535157242390))), @as(f64, @bitCast(@as(i64, 4646392721499398666))), @as(f64, @bitCast(@as(i64, 4652309318736865028))), (-@as(f64, @bitCast(@as(i64, 4653380946309955977)))), @as(f64, @bitCast(@as(i64, 4652993592761537004))), (-@as(f64, @bitCast(@as(i64, 4655816618772568159)))), @as(f64, @bitCast(@as(i64, 4652943834582724326))), (-@as(f64, @bitCast(@as(i64, 4655830597963403703)))), @as(f64, @bitCast(@as(i64, 4652259560118247699))), (-@as(f64, @bitCast(@as(i64, 4653394925060986870)))), @as(f64, @bitCast(@as(i64, 4653720297819534157))), (-@as(f64, @bitCast(@as(i64, 4650347160104691323)))), @as(f64, @bitCast(@as(i64, 4651918255436213938))), (-@as(f64, @bitCast(@as(i64, 4657369844533252902)))), @as(f64, @bitCast(@as(i64, 4651817862635879850))), (-@as(f64, @bitCast(@as(i64, 4657363688807453635)))), @as(f64, @bitCast(@as(i64, 4653670101595288974))), (-@as(f64, @bitCast(@as(i64, 4650322535090431931)))), @as(f64, @bitCast(@as(i64, 4653711170113805012))), (-@as(f64, @bitCast(@as(i64, 4650375480533551206)))), @as(f64, @bitCast(@as(i64, 4651028045522487424))), (-@as(f64, @bitCast(@as(i64, 4652938205962799415)))), @as(f64, @bitCast(@as(i64, 4650964164336718289))), (-@as(f64, @bitCast(@as(i64, 4652897572411083325)))), @as(f64, @bitCast(@as(i64, 4653679229740822770))), (-@as(f64, @bitCast(@as(i64, 4650294214309728328)))), @as(f64, @bitCast(@as(i64, 4650936322063475094))), (-@as(f64, @bitCast(@as(i64, 4644798658337542043)))), @as(f64, @bitCast(@as(i64, 4652993977150802074))), (-@as(f64, @bitCast(@as(i64, 4655818169963572625)))), @as(f64, @bitCast(@as(i64, 4652943450193459256))), (-@as(f64, @bitCast(@as(i64, 4655829046772399237)))), @as(f64, @bitCast(@as(i64, 4650835269028398760))), (-@as(f64, @bitCast(@as(i64, 4644842166276535930)))), @as(f64, @bitCast(@as(i64, 4650936827399019220))), (-@as(f64, @bitCast(@as(i64, 4644836786234199827)))), @as(f64, @bitCast(@as(i64, 4649444144047094707))), (-@as(f64, @bitCast(@as(i64, 4653899215629261681)))), @as(f64, @bitCast(@as(i64, 4649342080868695702))), (-@as(f64, @bitCast(@as(i64, 4653891028225876610)))), @as(f64, @bitCast(@as(i64, 4650834764132659285))), (-@as(f64, @bitCast(@as(i64, 4644804038203956286)))), @as(f64, @bitCast(@as(i64, 4648622770158336737))), (-@as(f64, @bitCast(@as(i64, 4647217776377164569)))), @as(f64, @bitCast(@as(i64, 4651044177117285502))), (-@as(f64, @bitCast(@as(i64, 4652908397762765757)))), @as(f64, @bitCast(@as(i64, 4650948033181724862))), (-@as(f64, @bitCast(@as(i64, 4652927380611116984)))), @as(f64, @bitCast(@as(i64, 4648526626222776097))), (-@as(f64, @bitCast(@as(i64, 4647293706011350873)))), @as(f64, @bitCast(@as(i64, 4648625360607731778))), (-@as(f64, @bitCast(@as(i64, 4647235292916808994)))), @as(f64, @bitCast(@as(i64, 4651918721893026905))), (-@as(f64, @bitCast(@as(i64, 4657364210635672178)))), @as(f64, @bitCast(@as(i64, 4651817395915184092))), (-@as(f64, @bitCast(@as(i64, 4657369322705034360)))), @as(f64, @bitCast(@as(i64, 4648524034893771755))), (-@as(f64, @bitCast(@as(i64, 4647276189823550169)))), @as(f64, @bitCast(@as(i64, 4652292823863425132))), (-@as(f64, @bitCast(@as(i64, 4653412380027980140)))), @as(f64, @bitCast(@as(i64, 4649409881241671812))), (-@as(f64, @bitCast(@as(i64, 4653919566270077862)))), @as(f64, @bitCast(@as(i64, 4649376343762079528))), (-@as(f64, @bitCast(@as(i64, 4653870677585060430)))), @as(f64, @bitCast(@as(i64, 4652276054991687595))), (-@as(f64, @bitCast(@as(i64, 4653363491342962708)))), @as(f64, @bitCast(@as(i64, 4651309651560984111))), (-@as(f64, @bitCast(@as(i64, 4660042778191097286)))), @as(f64, @bitCast(@as(i64, 4639372434050166104))), @as(f64, @bitCast(@as(i64, 4643359552779864171))), @as(f64, @bitCast(@as(i64, 4644113366692868328))), @as(f64, @bitCast(@as(i64, 4644148957444454786))), (-@as(f64, @bitCast(@as(i64, 4639407781325897707)))), @as(f64, @bitCast(@as(i64, 4644124955017659506))), (-@as(f64, @bitCast(@as(i64, 4639412513272099934)))), @as(f64, @bitCast(@as(i64, 4643335550353068891))), @as(f64, @bitCast(@as(i64, 4644111000192001633))), @as(f64, @bitCast(@as(i64, 4644622638136777895))), @as(f64, @bitCast(@as(i64, 4644111471310743903))), @as(f64, @bitCast(@as(i64, 4644148995091732921))), (-@as(f64, @bitCast(@as(i64, 4639411571386459116)))), @as(f64, @bitCast(@as(i64, 4644124917546303231))), (-@as(f64, @bitCast(@as(i64, 4639408722859694804)))), @as(f64, @bitCast(@as(i64, 4644598560591348205))), @as(f64, @bitCast(@as(i64, 4644112895398204198))), @as(f64, @bitCast(@as(i64, 4644863534273471059))), @as(f64, @bitCast(@as(i64, 4644099077967519332))), @as(f64, @bitCast(@as(i64, 4644148968175688273))), (-@as(f64, @bitCast(@as(i64, 4639412294073461821)))), @as(f64, @bitCast(@as(i64, 4644124944286426019))), (-@as(f64, @bitCast(@as(i64, 4639408000172692100)))), @as(f64, @bitCast(@as(i64, 4644839510384208805))), @as(f64, @bitCast(@as(i64, 4644101225621591635))), @as(f64, @bitCast(@as(i64, 4643720259092237947))), @as(f64, @bitCast(@as(i64, 4644100797427783314))), @as(f64, @bitCast(@as(i64, 4644148998962013851))), (-@as(f64, @bitCast(@as(i64, 4639408855504777579)))), @as(f64, @bitCast(@as(i64, 4644124913500100441))), (-@as(f64, @bitCast(@as(i64, 4639411439093220062)))), @as(f64, @bitCast(@as(i64, 4643696173982168258))), @as(f64, @bitCast(@as(i64, 4644099505809483933))), @as(f64, @bitCast(@as(i64, 4643549636701917807))), @as(f64, @bitCast(@as(i64, 4640937416272960144))), @as(f64, @bitCast(@as(i64, 4644489348652228191))), @as(f64, @bitCast(@as(i64, 4640937416272960144))), @as(f64, @bitCast(@as(i64, 4644489348652228191))), @as(f64, @bitCast(@as(i64, 4640889177443295193))), @as(f64, @bitCast(@as(i64, 4643549636701917807))), @as(f64, @bitCast(@as(i64, 4640889177443295193))), @as(f64, @bitCast(@as(i64, 4644482287852437404))), @as(f64, @bitCast(@as(i64, 4640932849341463014))), @as(f64, @bitCast(@as(i64, 4644674758682293547))), @as(f64, @bitCast(@as(i64, 4641210875546021522))), @as(f64, @bitCast(@as(i64, 4644688880281875120))), @as(f64, @bitCast(@as(i64, 4641171769875663390))), @as(f64, @bitCast(@as(i64, 4644496409452018978))), @as(f64, @bitCast(@as(i64, 4640893743671104881))), @as(f64, @bitCast(@as(i64, 4644681819658006194))), @as(f64, @bitCast(@as(i64, 4641167203296009980))), @as(f64, @bitCast(@as(i64, 4643810038350809578))), @as(f64, @bitCast(@as(i64, 4641167203296009980))), @as(f64, @bitCast(@as(i64, 4643810038350809578))), @as(f64, @bitCast(@as(i64, 4641215442125674932))), @as(f64, @bitCast(@as(i64, 4644681819658006194))), @as(f64, @bitCast(@as(i64, 4641215442125674932))), @as(f64, @bitCast(@as(i64, 4643815717988074017))), @as(f64, @bitCast(@as(i64, 4641170045489587316))), @as(f64, @bitCast(@as(i64, 4643555316163260386))), @as(f64, @bitCast(@as(i64, 4640892019285028808))), @as(f64, @bitCast(@as(i64, 4643543957064653367))), @as(f64, @bitCast(@as(i64, 4640934574079382808))), @as(f64, @bitCast(@as(i64, 4643804358889466998))), @as(f64, @bitCast(@as(i64, 4641212599932097596))), @as(f64, @bitCast(@as(i64, 4643750429691304120))), @as(f64, @bitCast(@as(i64, 4635019926671856679))), @as(f64, @bitCast(@as(i64, 4644368872788227659))), @as(f64, @bitCast(@as(i64, 4635019926671856679))), @as(f64, @bitCast(@as(i64, 4644368872788227659))), @as(f64, @bitCast(@as(i64, 4634923449716214218))), @as(f64, @bitCast(@as(i64, 4643750429691304120))), @as(f64, @bitCast(@as(i64, 4634923449716214218))), @as(f64, @bitCast(@as(i64, 4644359006034762788))), @as(f64, @bitCast(@as(i64, 4634999425441927958))), @as(f64, @bitCast(@as(i64, 4644494761416030337))), @as(f64, @bitCast(@as(i64, 4635772075660373593))), @as(f64, @bitCast(@as(i64, 4644514494571116359))), @as(f64, @bitCast(@as(i64, 4635716601868276015))), @as(f64, @bitCast(@as(i64, 4644378739365770670))), @as(f64, @bitCast(@as(i64, 4634943951649830381))), @as(f64, @bitCast(@as(i64, 4644504627993573348))), @as(f64, @bitCast(@as(i64, 4635696100638347294))), @as(f64, @bitCast(@as(i64, 4643916353384653657))), @as(f64, @bitCast(@as(i64, 4635696100638347294))), @as(f64, @bitCast(@as(i64, 4643916353384653657))), @as(f64, @bitCast(@as(i64, 4635792577593989755))), @as(f64, @bitCast(@as(i64, 4644504627993573348))), @as(f64, @bitCast(@as(i64, 4635792577593989755))), @as(f64, @bitCast(@as(i64, 4643925501673240474))), @as(f64, @bitCast(@as(i64, 4635712906805519246))), @as(f64, @bitCast(@as(i64, 4643759577979890937))), @as(f64, @bitCast(@as(i64, 4634940255883386170))), @as(f64, @bitCast(@as(i64, 4643741281402717303))), @as(f64, @bitCast(@as(i64, 4635003120504684728))), @as(f64, @bitCast(@as(i64, 4643907204920144980))), @as(f64, @bitCast(@as(i64, 4635775771145342827))), @as(f64, @bitCast(@as(i64, 4643946139418532900))), (-@as(f64, @bitCast(@as(i64, 4630439852404376223)))), @as(f64, @bitCast(@as(i64, 4644251446705599787))), (-@as(f64, @bitCast(@as(i64, 4630439852404376223)))), @as(f64, @bitCast(@as(i64, 4644251446705599787))), (-@as(f64, @bitCast(@as(i64, 4630632806034186168)))), @as(f64, @bitCast(@as(i64, 4643946139418532900))), (-@as(f64, @bitCast(@as(i64, 4630632806034186168)))), @as(f64, @bitCast(@as(i64, 4644240608511621543))), (-@as(f64, @bitCast(@as(i64, 4630494027189456281)))), @as(f64, @bitCast(@as(i64, 4644312223662180454))), (-@as(f64, @bitCast(@as(i64, 4628938960133823106)))), @as(f64, @bitCast(@as(i64, 4644333900401980662))), (-@as(f64, @bitCast(@as(i64, 4629108168816072717)))), @as(f64, @bitCast(@as(i64, 4644262285075499891))), (-@as(f64, @bitCast(@as(i64, 4630578631530581087)))), @as(f64, @bitCast(@as(i64, 4644323062032080558))), (-@as(f64, @bitCast(@as(i64, 4629216518667707810)))), @as(f64, @bitCast(@as(i64, 4644025293524499285))), (-@as(f64, @bitCast(@as(i64, 4629216518667707810)))), @as(f64, @bitCast(@as(i64, 4644025293524499285))), (-@as(f64, @bitCast(@as(i64, 4628830610282188013)))), @as(f64, @bitCast(@as(i64, 4644323062032080558))), (-@as(f64, @bitCast(@as(i64, 4628830610282188013)))), @as(f64, @bitCast(@as(i64, 4644035908649558485))), (-@as(f64, @bitCast(@as(i64, 4629115144328945561)))), @as(f64, @bitCast(@as(i64, 4643956754543592100))), (-@as(f64, @bitCast(@as(i64, 4630582119005542532)))), @as(f64, @bitCast(@as(i64, 4643935524469395560))), (-@as(f64, @bitCast(@as(i64, 4630490539714494836)))), @as(f64, @bitCast(@as(i64, 4644014678575361944))), (-@as(f64, @bitCast(@as(i64, 4628931984620950263)))), @as(f64, @bitCast(@as(i64, 4643376330447694730))), @as(f64, @bitCast(@as(i64, 4644117980067736616))), @as(f64, @bitCast(@as(i64, 4644499924018946931))), @as(f64, @bitCast(@as(i64, 4640924889229121636))), @as(f64, @bitCast(@as(i64, 4644478773285509451))), @as(f64, @bitCast(@as(i64, 4640901704135289980))), @as(f64, @bitCast(@as(i64, 4643355179714257250))), @as(f64, @bitCast(@as(i64, 4644106386817133346))), @as(f64, @bitCast(@as(i64, 4644603144411343938))), @as(f64, @bitCast(@as(i64, 4644106716142856097))), @as(f64, @bitCast(@as(i64, 4643560385527590945))), @as(f64, @bitCast(@as(i64, 4640902361027516878))), @as(f64, @bitCast(@as(i64, 4643538887876244668))), @as(f64, @bitCast(@as(i64, 4640924232336894738))), @as(f64, @bitCast(@as(i64, 4644581647111841382))), @as(f64, @bitCast(@as(i64, 4644117650917935725))), @as(f64, @bitCast(@as(i64, 4644626482205350460))), @as(f64, @bitCast(@as(i64, 4644112417770353092))), @as(f64, @bitCast(@as(i64, 4644693871888743363))), @as(f64, @bitCast(@as(i64, 4641192173293037704))), @as(f64, @bitCast(@as(i64, 4644669767427269025))), @as(f64, @bitCast(@as(i64, 4641190472480490930))), @as(f64, @bitCast(@as(i64, 4644602377743876122))), @as(f64, @bitCast(@as(i64, 4644111567188157845))), @as(f64, @bitCast(@as(i64, 4644860251395633311))), @as(f64, @bitCast(@as(i64, 4644098216830012458))), @as(f64, @bitCast(@as(i64, 4644501225312948637))), @as(f64, @bitCast(@as(i64, 4640909112204833283))), @as(f64, @bitCast(@as(i64, 4644477471991507746))), @as(f64, @bitCast(@as(i64, 4640917481159578333))), @as(f64, @bitCast(@as(i64, 4644836498074192419))), @as(f64, @bitCast(@as(i64, 4644102401131463123))), @as(f64, @bitCast(@as(i64, 4644845656566247142))), @as(f64, @bitCast(@as(i64, 4644094423251013840))), @as(f64, @bitCast(@as(i64, 4643820650661119011))), @as(f64, @bitCast(@as(i64, 4641179865799681030))), @as(f64, @bitCast(@as(i64, 4643799426040500144))), @as(f64, @bitCast(@as(i64, 4641202779622003882))), @as(f64, @bitCast(@as(i64, 4644824431593784554))), @as(f64, @bitCast(@as(i64, 4644105879986253406))), @as(f64, @bitCast(@as(i64, 4643735464370479856))), @as(f64, @bitCast(@as(i64, 4644105579687637628))), @as(f64, @bitCast(@as(i64, 4644692588714693283))), @as(f64, @bitCast(@as(i64, 4641202178672928605))), @as(f64, @bitCast(@as(i64, 4644671050601319105))), @as(f64, @bitCast(@as(i64, 4641180466748756307))), @as(f64, @bitCast(@as(i64, 4643713926257105678))), @as(f64, @bitCast(@as(i64, 4644094723549629619))), @as(f64, @bitCast(@as(i64, 4643715530312629208))), @as(f64, @bitCast(@as(i64, 4644099401311898829))), @as(f64, @bitCast(@as(i64, 4643561662016610328))), @as(f64, @bitCast(@as(i64, 4640911480816762303))), @as(f64, @bitCast(@as(i64, 4643537611387225286))), @as(f64, @bitCast(@as(i64, 4640915112195805592))), @as(f64, @bitCast(@as(i64, 4643691479683244166))), @as(f64, @bitCast(@as(i64, 4644101216825498613))), @as(f64, @bitCast(@as(i64, 4643365014801787241))), @as(f64, @bitCast(@as(i64, 4644114796233906297))), @as(f64, @bitCast(@as(i64, 4643821767413089111))), @as(f64, @bitCast(@as(i64, 4641196930220144114))), @as(f64, @bitCast(@as(i64, 4643798309288530045))), @as(f64, @bitCast(@as(i64, 4641185715201540799))), @as(f64, @bitCast(@as(i64, 4643341556853150035))), @as(f64, @bitCast(@as(i64, 4644109188196839058))), @as(f64, @bitCast(@as(i64, 4643560825332242055))), @as(f64, @bitCast(@as(i64, 4640922296492742410))), @as(f64, @bitCast(@as(i64, 4644380061066708187))), @as(f64, @bitCast(@as(i64, 4634989689222483537))), @as(f64, @bitCast(@as(i64, 4644357684509747131))), @as(f64, @bitCast(@as(i64, 4634953687517431081))), @as(f64, @bitCast(@as(i64, 4643538448071593558))), @as(f64, @bitCast(@as(i64, 4640904296519825485))), @as(f64, @bitCast(@as(i64, 4644500685232837073))), @as(f64, @bitCast(@as(i64, 4640905071279698881))), @as(f64, @bitCast(@as(i64, 4643761766271913002))), @as(f64, @bitCast(@as(i64, 4634955237389021594))), @as(f64, @bitCast(@as(i64, 4643739093110695238))), @as(f64, @bitCast(@as(i64, 4634988138999049303))), @as(f64, @bitCast(@as(i64, 4644478012071619309))), @as(f64, @bitCast(@as(i64, 4640921522084712735))), @as(f64, @bitCast(@as(i64, 4644501407919839778))), @as(f64, @bitCast(@as(i64, 4640913496529439272))), @as(f64, @bitCast(@as(i64, 4644516687261184935))), @as(f64, @bitCast(@as(i64, 4635744738810635454))), @as(f64, @bitCast(@as(i64, 4644492569077805482))), @as(f64, @bitCast(@as(i64, 4635743938718014154))), @as(f64, @bitCast(@as(i64, 4644477289560538465))), @as(f64, @bitCast(@as(i64, 4640913096834972343))), @as(f64, @bitCast(@as(i64, 4644693756308081051))), @as(f64, @bitCast(@as(i64, 4641187888892048447))), @as(f64, @bitCast(@as(i64, 4644380809438302516))), @as(f64, @bitCast(@as(i64, 4634964820626816174))), @as(f64, @bitCast(@as(i64, 4644356935962230941))), @as(f64, @bitCast(@as(i64, 4634978556183467189))), @as(f64, @bitCast(@as(i64, 4644669882832009476))), @as(f64, @bitCast(@as(i64, 4641194756529636466))), @as(f64, @bitCast(@as(i64, 4644693069685059737))), @as(f64, @bitCast(@as(i64, 4641182635513451863))), @as(f64, @bitCast(@as(i64, 4643927603411707201))), @as(f64, @bitCast(@as(i64, 4635726965073231059))), @as(f64, @bitCast(@as(i64, 4643905103181678253))), @as(f64, @bitCast(@as(i64, 4635761712455418548))), @as(f64, @bitCast(@as(i64, 4644670569455030790))), @as(f64, @bitCast(@as(i64, 4641200009908233049))), @as(f64, @bitCast(@as(i64, 4643821420143336594))), @as(f64, @bitCast(@as(i64, 4641199297424698250))), @as(f64, @bitCast(@as(i64, 4644516009786100364))), @as(f64, @bitCast(@as(i64, 4635760287769823927))), @as(f64, @bitCast(@as(i64, 4644493246376968192))), @as(f64, @bitCast(@as(i64, 4635728390040300657))), @as(f64, @bitCast(@as(i64, 4643798656734204422))), @as(f64, @bitCast(@as(i64, 4641183347996986662))), @as(f64, @bitCast(@as(i64, 4643822093396296514))), @as(f64, @bitCast(@as(i64, 4641190662476100209))), @as(f64, @bitCast(@as(i64, 4643762484560869196))), @as(f64, @bitCast(@as(i64, 4634970367020863513))), @as(f64, @bitCast(@as(i64, 4643738374469895324))), @as(f64, @bitCast(@as(i64, 4634973009719051105))), @as(f64, @bitCast(@as(i64, 4643797983481244502))), @as(f64, @bitCast(@as(i64, 4641191982945584703))), @as(f64, @bitCast(@as(i64, 4643561464456361049))), @as(f64, @bitCast(@as(i64, 4640918001888285247))), @as(f64, @bitCast(@as(i64, 4643928181139096899))), @as(f64, @bitCast(@as(i64, 4635753749528327404))), @as(f64, @bitCast(@as(i64, 4643904525630210415))), @as(f64, @bitCast(@as(i64, 4635734928000322204))), @as(f64, @bitCast(@as(i64, 4643537808947474564))), @as(f64, @bitCast(@as(i64, 4640908591476126368))), @as(f64, @bitCast(@as(i64, 4644136956231057146))), (-@as(f64, @bitCast(@as(i64, 4639410147123076960)))), @as(f64, @bitCast(@as(i64, 4625517067153101801))), @as(f64, @bitCast(@as(i64, 4647852044525044362))), @as(f64, @bitCast(@as(i64, 4644001395771210969))), @as(f64, @bitCast(@as(i64, 4647836131601118816))), @as(f64, @bitCast(@as(i64, 4643192519899184533))), @as(f64, @bitCast(@as(i64, 4647834525346572030))), @as(f64, @bitCast(@as(i64, 4643192775337725898))), @as(f64, @bitCast(@as(i64, 4647850438006614786))), @as(f64, @bitCast(@as(i64, 4644001523666403512))), @as(f64, @bitCast(@as(i64, 4647875482682472268))), @as(f64, @bitCast(@as(i64, 4644001159156308671))), @as(f64, @bitCast(@as(i64, 4647836128522486258))), @as(f64, @bitCast(@as(i64, 4643192332366481300))), @as(f64, @bitCast(@as(i64, 4647834528513165518))), @as(f64, @bitCast(@as(i64, 4643192962870429132))), @as(f64, @bitCast(@as(i64, 4647873882761112458))), @as(f64, @bitCast(@as(i64, 4644001473704595145))), @as(f64, @bitCast(@as(i64, 4647820429783425803))), @as(f64, @bitCast(@as(i64, 4644001308338046328))), @as(f64, @bitCast(@as(i64, 4647836131601118816))), @as(f64, @bitCast(@as(i64, 4643192773930351015))), @as(f64, @bitCast(@as(i64, 4647834525346572030))), @as(f64, @bitCast(@as(i64, 4643192521306559417))), @as(f64, @bitCast(@as(i64, 4647818823440918087))), @as(f64, @bitCast(@as(i64, 4644001181674306808))), @as(f64, @bitCast(@as(i64, 4647796601783155153))), @as(f64, @bitCast(@as(i64, 4644001545128870486))), @as(f64, @bitCast(@as(i64, 4647836128522486258))), @as(f64, @bitCast(@as(i64, 4643192963925960294))), @as(f64, @bitCast(@as(i64, 4647834528513165518))), @as(f64, @bitCast(@as(i64, 4643192331310950137))), @as(f64, @bitCast(@as(i64, 4647795001949756273))), @as(f64, @bitCast(@as(i64, 4644001228117677965))), @as(f64, @bitCast(@as(i64, 4647845936166206020))), @as(f64, @bitCast(@as(i64, 4643738407895048808))), @as(f64, @bitCast(@as(i64, 4647861695774230189))), @as(f64, @bitCast(@as(i64, 4643739882120239330))), @as(f64, @bitCast(@as(i64, 4647861770892864599))), @as(f64, @bitCast(@as(i64, 4643736669787067620))), @as(f64, @bitCast(@as(i64, 4647846010932996709))), @as(f64, @bitCast(@as(i64, 4643735195561877098))), @as(f64, @bitCast(@as(i64, 4647861725153180883))), @as(f64, @bitCast(@as(i64, 4643736668027849015))), @as(f64, @bitCast(@as(i64, 4647824769863683890))), @as(f64, @bitCast(@as(i64, 4643737411649553113))), @as(f64, @bitCast(@as(i64, 4647824785960534121))), @as(f64, @bitCast(@as(i64, 4643740627501162032))), @as(f64, @bitCast(@as(i64, 4647861741425952974))), @as(f64, @bitCast(@as(i64, 4643739883879457935))), @as(f64, @bitCast(@as(i64, 4647824814987641094))), @as(f64, @bitCast(@as(i64, 4643737413232849857))), @as(f64, @bitCast(@as(i64, 4647808883503959271))), @as(f64, @bitCast(@as(i64, 4643735948155596078))), @as(f64, @bitCast(@as(i64, 4647808809176973233))), @as(f64, @bitCast(@as(i64, 4643739160840611509))), @as(f64, @bitCast(@as(i64, 4647824741100459708))), @as(f64, @bitCast(@as(i64, 4643740625917865288))), @as(f64, @bitCast(@as(i64, 4647808854476852298))), @as(f64, @bitCast(@as(i64, 4643739162247986393))), @as(f64, @bitCast(@as(i64, 4647845981642006945))), @as(f64, @bitCast(@as(i64, 4643738409654267412))), @as(f64, @bitCast(@as(i64, 4647845965457195784))), @as(f64, @bitCast(@as(i64, 4643735193802658493))), @as(f64, @bitCast(@as(i64, 4647808838204080207))), @as(f64, @bitCast(@as(i64, 4643735946396377473))), @as(f64, @bitCast(@as(i64, 4647840561313564800))), @as(f64, @bitCast(@as(i64, 4643470366311601668))), @as(f64, @bitCast(@as(i64, 4647848462404121998))), @as(f64, @bitCast(@as(i64, 4643471899470615439))), @as(f64, @bitCast(@as(i64, 4647848618094968491))), @as(f64, @bitCast(@as(i64, 4643468698572364657))), @as(f64, @bitCast(@as(i64, 4647840717004411293))), @as(f64, @bitCast(@as(i64, 4643467165237429026))), @as(f64, @bitCast(@as(i64, 4647848523712890363))), @as(f64, @bitCast(@as(i64, 4643468691535490240))), @as(f64, @bitCast(@as(i64, 4647830024913538148))), @as(f64, @bitCast(@as(i64, 4643469468406425961))), @as(f64, @bitCast(@as(i64, 4647830057986847911))), @as(f64, @bitCast(@as(i64, 4643472683202503718))), @as(f64, @bitCast(@as(i64, 4647848556962121987))), @as(f64, @bitCast(@as(i64, 4643471906331567996))), @as(f64, @bitCast(@as(i64, 4647830118152124183))), @as(f64, @bitCast(@as(i64, 4643469475443300379))), @as(f64, @bitCast(@as(i64, 4647822174048672106))), @as(f64, @bitCast(@as(i64, 4643467947034176840))), @as(f64, @bitCast(@as(i64, 4647822020468887939))), @as(f64, @bitCast(@as(i64, 4643471147756505761))), @as(f64, @bitCast(@as(i64, 4647829964572340016))), @as(f64, @bitCast(@as(i64, 4643472676165629300))), @as(f64, @bitCast(@as(i64, 4647822114587083276))), @as(f64, @bitCast(@as(i64, 4643471154793380179))), @as(f64, @bitCast(@as(i64, 4647840656399330370))), @as(f64, @bitCast(@as(i64, 4643470372996632365))), @as(f64, @bitCast(@as(i64, 4647840622006606653))), @as(f64, @bitCast(@as(i64, 4643467158376476469))), @as(f64, @bitCast(@as(i64, 4647822080282320490))), @as(f64, @bitCast(@as(i64, 4643467939997302422))), @as(f64, @bitCast(@as(i64, 4647852312454037819))), @as(f64, @bitCast(@as(i64, 4644001582600226760))), @as(f64, @bitCast(@as(i64, 4647862534921504508))), @as(f64, @bitCast(@as(i64, 4643738400506330669))), @as(f64, @bitCast(@as(i64, 4647860931745590280))), @as(f64, @bitCast(@as(i64, 4643738151400976280))), @as(f64, @bitCast(@as(i64, 4647850709278123591))), @as(f64, @bitCast(@as(i64, 4644001333670794232))), @as(f64, @bitCast(@as(i64, 4647875204286128115))), @as(f64, @bitCast(@as(i64, 4644000979716011018))), @as(f64, @bitCast(@as(i64, 4647846759480512899))), @as(f64, @bitCast(@as(i64, 4643736463430725319))), @as(f64, @bitCast(@as(i64, 4647845187618689830))), @as(f64, @bitCast(@as(i64, 4643737139850278727))), @as(f64, @bitCast(@as(i64, 4647873632072461325))), @as(f64, @bitCast(@as(i64, 4644001656311486286))), @as(f64, @bitCast(@as(i64, 4647874804943504907))), @as(f64, @bitCast(@as(i64, 4644000750489826859))), @as(f64, @bitCast(@as(i64, 4647825530549808451))), @as(f64, @bitCast(@as(i64, 4643738454162498105))), @as(f64, @bitCast(@as(i64, 4647824025098487700))), @as(f64, @bitCast(@as(i64, 4643739584812295179))), @as(f64, @bitCast(@as(i64, 4647873299931988807))), @as(f64, @bitCast(@as(i64, 4644001881139623934))), @as(f64, @bitCast(@as(i64, 4647821018154088058))), @as(f64, @bitCast(@as(i64, 4644001729494980231))), @as(f64, @bitCast(@as(i64, 4647862500088976140))), @as(f64, @bitCast(@as(i64, 4643738759738769696))), @as(f64, @bitCast(@as(i64, 4647860966929962369))), @as(f64, @bitCast(@as(i64, 4643737792168537253))), @as(f64, @bitCast(@as(i64, 4647819484907113357))), @as(f64, @bitCast(@as(i64, 4644000761924747788))), @as(f64, @bitCast(@as(i64, 4647820159215604439))), @as(f64, @bitCast(@as(i64, 4644001118342437048))), @as(f64, @bitCast(@as(i64, 4647809647884442901))), @as(f64, @bitCast(@as(i64, 4643737426602911251))), @as(f64, @bitCast(@as(i64, 4647808044708528673))), @as(f64, @bitCast(@as(i64, 4643737682217374476))), @as(f64, @bitCast(@as(i64, 4647818556127651142))), @as(f64, @bitCast(@as(i64, 4644001373780978413))), @as(f64, @bitCast(@as(i64, 4647796861883625819))), @as(f64, @bitCast(@as(i64, 4644001728791292789))), @as(f64, @bitCast(@as(i64, 4647825563535157284))), @as(f64, @bitCast(@as(i64, 4643739363150751020))), @as(f64, @bitCast(@as(i64, 4647823992552943518))), @as(f64, @bitCast(@as(i64, 4643738675999964125))), @as(f64, @bitCast(@as(i64, 4647795290901412053))), @as(f64, @bitCast(@as(i64, 4644001041640505895))), @as(f64, @bitCast(@as(i64, 4647797183820630432))), @as(f64, @bitCast(@as(i64, 4644001951156524391))), @as(f64, @bitCast(@as(i64, 4647846726055359414))), @as(f64, @bitCast(@as(i64, 4643737365382103816))), @as(f64, @bitCast(@as(i64, 4647845221043843314))), @as(f64, @bitCast(@as(i64, 4643736238074822090))), @as(f64, @bitCast(@as(i64, 4647795678369309681))), @as(f64, @bitCast(@as(i64, 4644000823497398944))), @as(f64, @bitCast(@as(i64, 4647851373031303047))), @as(f64, @bitCast(@as(i64, 4644000973382824042))), @as(f64, @bitCast(@as(i64, 4647809612700070812))), @as(f64, @bitCast(@as(i64, 4643737069129690828))), @as(f64, @bitCast(@as(i64, 4647808079541057041))), @as(f64, @bitCast(@as(i64, 4643738039690594898))), @as(f64, @bitCast(@as(i64, 4647849839520445555))), @as(f64, @bitCast(@as(i64, 4644001944119649973))), @as(f64, @bitCast(@as(i64, 4647148589476045369))), @as(f64, @bitCast(@as(i64, 4643993851714069542))), @as(f64, @bitCast(@as(i64, 4647152714315907203))), @as(f64, @bitCast(@as(i64, 4643938870855024928))), @as(f64, @bitCast(@as(i64, 4647151016669953917))), @as(f64, @bitCast(@as(i64, 4643938742959832385))), @as(f64, @bitCast(@as(i64, 4647146892181935804))), @as(f64, @bitCast(@as(i64, 4643993723994798859))), @as(f64, @bitCast(@as(i64, 4647156838803925316))), @as(f64, @bitCast(@as(i64, 4643993723994798859))), @as(f64, @bitCast(@as(i64, 4647152714315907203))), @as(f64, @bitCast(@as(i64, 4643938742959832385))), @as(f64, @bitCast(@as(i64, 4647151016669953917))), @as(f64, @bitCast(@as(i64, 4643938870855024928))), @as(f64, @bitCast(@as(i64, 4647155141509815751))), @as(f64, @bitCast(@as(i64, 4643993851714069542))), @as(f64, @bitCast(@as(i64, 4647156836341019270))), @as(f64, @bitCast(@as(i64, 4643993718013455604))), @as(f64, @bitCast(@as(i64, 4647152714315907203))), @as(f64, @bitCast(@as(i64, 4643938742959832385))), @as(f64, @bitCast(@as(i64, 4647151016669953917))), @as(f64, @bitCast(@as(i64, 4643938870855024928))), @as(f64, @bitCast(@as(i64, 4647155138870987844))), @as(f64, @bitCast(@as(i64, 4643993845908648147))), @as(f64, @bitCast(@as(i64, 4647148592114873276))), @as(f64, @bitCast(@as(i64, 4643993845908648147))), @as(f64, @bitCast(@as(i64, 4647152714315907203))), @as(f64, @bitCast(@as(i64, 4643938870855024928))), @as(f64, @bitCast(@as(i64, 4647151016669953917))), @as(f64, @bitCast(@as(i64, 4643938742959832385))), @as(f64, @bitCast(@as(i64, 4647146894644841850))), @as(f64, @bitCast(@as(i64, 4643993718013455604))), @as(f64, @bitCast(@as(i64, 4647151865492930560))), @as(f64, @bitCast(@as(i64, 4643938806819467727))), @as(f64, @bitCast(@as(i64, 4608126761942562106))), @as(f64, @bitCast(@as(i64, 4643359552779864171))), @as(f64, @bitCast(@as(i64, 4644113366692868328))), @as(f64, @bitCast(@as(i64, 4644148957444454786))), (-@as(f64, @bitCast(@as(i64, 4639407781325897707)))), @as(f64, @bitCast(@as(i64, 4644124955017659506))), (-@as(f64, @bitCast(@as(i64, 4639412513272099934)))), @as(f64, @bitCast(@as(i64, 4643335550353068891))), @as(f64, @bitCast(@as(i64, 4644111000192001633))), @as(f64, @bitCast(@as(i64, 4644622638136777895))), @as(f64, @bitCast(@as(i64, 4644111471310743903))), @as(f64, @bitCast(@as(i64, 4644148995091732921))), (-@as(f64, @bitCast(@as(i64, 4639411571386459116)))), @as(f64, @bitCast(@as(i64, 4644124917546303231))), (-@as(f64, @bitCast(@as(i64, 4639408722859694804)))), @as(f64, @bitCast(@as(i64, 4644598560591348205))), @as(f64, @bitCast(@as(i64, 4644112895398204198))), @as(f64, @bitCast(@as(i64, 4644863534273471059))), @as(f64, @bitCast(@as(i64, 4644099077967519332))), @as(f64, @bitCast(@as(i64, 4644148968175688273))), (-@as(f64, @bitCast(@as(i64, 4639412294073461821)))), @as(f64, @bitCast(@as(i64, 4644124944286426019))), (-@as(f64, @bitCast(@as(i64, 4639408000172692100)))), @as(f64, @bitCast(@as(i64, 4644839510384208805))), @as(f64, @bitCast(@as(i64, 4644101225621591635))), @as(f64, @bitCast(@as(i64, 4643720259092237947))), @as(f64, @bitCast(@as(i64, 4644100797427783314))), @as(f64, @bitCast(@as(i64, 4644148998962013851))), (-@as(f64, @bitCast(@as(i64, 4639408855504777579)))), @as(f64, @bitCast(@as(i64, 4644124913500100441))), (-@as(f64, @bitCast(@as(i64, 4639411439093220062)))), @as(f64, @bitCast(@as(i64, 4643696173982168258))), @as(f64, @bitCast(@as(i64, 4644099505809483933))), @as(f64, @bitCast(@as(i64, 4643549636701917807))), @as(f64, @bitCast(@as(i64, 4640937416272960144))), @as(f64, @bitCast(@as(i64, 4644489348652228191))), @as(f64, @bitCast(@as(i64, 4640937416272960144))), @as(f64, @bitCast(@as(i64, 4644489348652228191))), @as(f64, @bitCast(@as(i64, 4640889177443295193))), @as(f64, @bitCast(@as(i64, 4643549636701917807))), @as(f64, @bitCast(@as(i64, 4640889177443295193))), @as(f64, @bitCast(@as(i64, 4644482287852437404))), @as(f64, @bitCast(@as(i64, 4640932849341463014))), @as(f64, @bitCast(@as(i64, 4644674758682293547))), @as(f64, @bitCast(@as(i64, 4641210875546021522))), @as(f64, @bitCast(@as(i64, 4644688880281875120))), @as(f64, @bitCast(@as(i64, 4641171769875663390))), @as(f64, @bitCast(@as(i64, 4644496409452018978))), @as(f64, @bitCast(@as(i64, 4640893743671104881))), @as(f64, @bitCast(@as(i64, 4644681819658006194))), @as(f64, @bitCast(@as(i64, 4641167203296009980))), @as(f64, @bitCast(@as(i64, 4643810038350809578))), @as(f64, @bitCast(@as(i64, 4641167203296009980))), @as(f64, @bitCast(@as(i64, 4643810038350809578))), @as(f64, @bitCast(@as(i64, 4641215442125674932))), @as(f64, @bitCast(@as(i64, 4644681819658006194))), @as(f64, @bitCast(@as(i64, 4641215442125674932))), @as(f64, @bitCast(@as(i64, 4643815717988074017))), @as(f64, @bitCast(@as(i64, 4641170045489587316))), @as(f64, @bitCast(@as(i64, 4643555316163260386))), @as(f64, @bitCast(@as(i64, 4640892019285028808))), @as(f64, @bitCast(@as(i64, 4643543957064653367))), @as(f64, @bitCast(@as(i64, 4640934574079382808))), @as(f64, @bitCast(@as(i64, 4643804358889466998))), @as(f64, @bitCast(@as(i64, 4641212599932097596))), @as(f64, @bitCast(@as(i64, 4643750429691304120))), @as(f64, @bitCast(@as(i64, 4635019926671856679))), @as(f64, @bitCast(@as(i64, 4644368872788227659))), @as(f64, @bitCast(@as(i64, 4635019926671856679))), @as(f64, @bitCast(@as(i64, 4644368872788227659))), @as(f64, @bitCast(@as(i64, 4634923449716214218))), @as(f64, @bitCast(@as(i64, 4643750429691304120))), @as(f64, @bitCast(@as(i64, 4634923449716214218))), @as(f64, @bitCast(@as(i64, 4644359006034762788))), @as(f64, @bitCast(@as(i64, 4634999425441927958))), @as(f64, @bitCast(@as(i64, 4644494761416030337))), @as(f64, @bitCast(@as(i64, 4635772075660373593))), @as(f64, @bitCast(@as(i64, 4644514494571116359))), @as(f64, @bitCast(@as(i64, 4635716601868276015))), @as(f64, @bitCast(@as(i64, 4644378739365770670))), @as(f64, @bitCast(@as(i64, 4634943951649830381))), @as(f64, @bitCast(@as(i64, 4644504627993573348))), @as(f64, @bitCast(@as(i64, 4635696100638347294))), @as(f64, @bitCast(@as(i64, 4643916353384653657))), @as(f64, @bitCast(@as(i64, 4635696100638347294))), @as(f64, @bitCast(@as(i64, 4643916353384653657))), @as(f64, @bitCast(@as(i64, 4635792577593989755))), @as(f64, @bitCast(@as(i64, 4644504627993573348))), @as(f64, @bitCast(@as(i64, 4635792577593989755))), @as(f64, @bitCast(@as(i64, 4643925501673240474))), @as(f64, @bitCast(@as(i64, 4635712906805519246))), @as(f64, @bitCast(@as(i64, 4643759577979890937))), @as(f64, @bitCast(@as(i64, 4634940255883386170))), @as(f64, @bitCast(@as(i64, 4643741281402717303))), @as(f64, @bitCast(@as(i64, 4635003120504684728))), @as(f64, @bitCast(@as(i64, 4643907204920144980))), @as(f64, @bitCast(@as(i64, 4635775771145342827))), @as(f64, @bitCast(@as(i64, 4643946139418532900))), (-@as(f64, @bitCast(@as(i64, 4630439852404376223)))), @as(f64, @bitCast(@as(i64, 4644251446705599787))), (-@as(f64, @bitCast(@as(i64, 4630439852404376223)))), @as(f64, @bitCast(@as(i64, 4644251446705599787))), (-@as(f64, @bitCast(@as(i64, 4630632806034186168)))), @as(f64, @bitCast(@as(i64, 4643946139418532900))), (-@as(f64, @bitCast(@as(i64, 4630632806034186168)))), @as(f64, @bitCast(@as(i64, 4644240608511621543))), (-@as(f64, @bitCast(@as(i64, 4630494027189456281)))), @as(f64, @bitCast(@as(i64, 4644312223662180454))), (-@as(f64, @bitCast(@as(i64, 4628938960133823106)))), @as(f64, @bitCast(@as(i64, 4644333900401980662))), (-@as(f64, @bitCast(@as(i64, 4629108168816072717)))), @as(f64, @bitCast(@as(i64, 4644262285075499891))), (-@as(f64, @bitCast(@as(i64, 4630578631530581087)))), @as(f64, @bitCast(@as(i64, 4644323062032080558))), (-@as(f64, @bitCast(@as(i64, 4629216518667707810)))), @as(f64, @bitCast(@as(i64, 4644025293524499285))), (-@as(f64, @bitCast(@as(i64, 4629216518667707810)))), @as(f64, @bitCast(@as(i64, 4644025293524499285))), (-@as(f64, @bitCast(@as(i64, 4628830610282188013)))), @as(f64, @bitCast(@as(i64, 4644323062032080558))), (-@as(f64, @bitCast(@as(i64, 4628830610282188013)))), @as(f64, @bitCast(@as(i64, 4644035908649558485))), (-@as(f64, @bitCast(@as(i64, 4629115144328945561)))), @as(f64, @bitCast(@as(i64, 4643956754543592100))), (-@as(f64, @bitCast(@as(i64, 4630582119005542532)))), @as(f64, @bitCast(@as(i64, 4643935524469395560))), (-@as(f64, @bitCast(@as(i64, 4630490539714494836)))), @as(f64, @bitCast(@as(i64, 4644014678575361944))), (-@as(f64, @bitCast(@as(i64, 4628931984620950263)))), @as(f64, @bitCast(@as(i64, 4643376330447694730))), @as(f64, @bitCast(@as(i64, 4644117980067736616))), @as(f64, @bitCast(@as(i64, 4644499924018946931))), @as(f64, @bitCast(@as(i64, 4640924889229121636))), @as(f64, @bitCast(@as(i64, 4644478773285509451))), @as(f64, @bitCast(@as(i64, 4640901704135289980))), @as(f64, @bitCast(@as(i64, 4643355179714257250))), @as(f64, @bitCast(@as(i64, 4644106386817133346))), @as(f64, @bitCast(@as(i64, 4644603144411343938))), @as(f64, @bitCast(@as(i64, 4644106716142856097))), @as(f64, @bitCast(@as(i64, 4643560385527590945))), @as(f64, @bitCast(@as(i64, 4640902361027516878))), @as(f64, @bitCast(@as(i64, 4643538887876244668))), @as(f64, @bitCast(@as(i64, 4640924232336894738))), @as(f64, @bitCast(@as(i64, 4644581647111841382))), @as(f64, @bitCast(@as(i64, 4644117650917935725))), @as(f64, @bitCast(@as(i64, 4644626482205350460))), @as(f64, @bitCast(@as(i64, 4644112417770353092))), @as(f64, @bitCast(@as(i64, 4644693871888743363))), @as(f64, @bitCast(@as(i64, 4641192173293037704))), @as(f64, @bitCast(@as(i64, 4644669767427269025))), @as(f64, @bitCast(@as(i64, 4641190472480490930))), @as(f64, @bitCast(@as(i64, 4644602377743876122))), @as(f64, @bitCast(@as(i64, 4644111567188157845))), @as(f64, @bitCast(@as(i64, 4644860251395633311))), @as(f64, @bitCast(@as(i64, 4644098216830012458))), @as(f64, @bitCast(@as(i64, 4644501225312948637))), @as(f64, @bitCast(@as(i64, 4640909112204833283))), @as(f64, @bitCast(@as(i64, 4644477471991507746))), @as(f64, @bitCast(@as(i64, 4640917481159578333))), @as(f64, @bitCast(@as(i64, 4644836498074192419))), @as(f64, @bitCast(@as(i64, 4644102401131463123))), @as(f64, @bitCast(@as(i64, 4644845656566247142))), @as(f64, @bitCast(@as(i64, 4644094423251013840))), @as(f64, @bitCast(@as(i64, 4643820650661119011))), @as(f64, @bitCast(@as(i64, 4641179865799681030))), @as(f64, @bitCast(@as(i64, 4643799426040500144))), @as(f64, @bitCast(@as(i64, 4641202779622003882))), @as(f64, @bitCast(@as(i64, 4644824431593784554))), @as(f64, @bitCast(@as(i64, 4644105879986253406))), @as(f64, @bitCast(@as(i64, 4643735464370479856))), @as(f64, @bitCast(@as(i64, 4644105579687637628))), @as(f64, @bitCast(@as(i64, 4644692588714693283))), @as(f64, @bitCast(@as(i64, 4641202178672928605))), @as(f64, @bitCast(@as(i64, 4644671050601319105))), @as(f64, @bitCast(@as(i64, 4641180466748756307))), @as(f64, @bitCast(@as(i64, 4643713926257105678))), @as(f64, @bitCast(@as(i64, 4644094723549629619))), @as(f64, @bitCast(@as(i64, 4643715530312629208))), @as(f64, @bitCast(@as(i64, 4644099401311898829))), @as(f64, @bitCast(@as(i64, 4643561662016610328))), @as(f64, @bitCast(@as(i64, 4640911480816762303))), @as(f64, @bitCast(@as(i64, 4643537611387225286))), @as(f64, @bitCast(@as(i64, 4640915112195805592))), @as(f64, @bitCast(@as(i64, 4643691479683244166))), @as(f64, @bitCast(@as(i64, 4644101216825498613))), @as(f64, @bitCast(@as(i64, 4643365014801787241))), @as(f64, @bitCast(@as(i64, 4644114796233906297))), @as(f64, @bitCast(@as(i64, 4643821767413089111))), @as(f64, @bitCast(@as(i64, 4641196930220144114))), @as(f64, @bitCast(@as(i64, 4643798309288530045))), @as(f64, @bitCast(@as(i64, 4641185715201540799))), @as(f64, @bitCast(@as(i64, 4643341556853150035))), @as(f64, @bitCast(@as(i64, 4644109188196839058))), @as(f64, @bitCast(@as(i64, 4643560825332242055))), @as(f64, @bitCast(@as(i64, 4640922296492742410))), @as(f64, @bitCast(@as(i64, 4644380061066708187))), @as(f64, @bitCast(@as(i64, 4634989689222483537))), @as(f64, @bitCast(@as(i64, 4644357684509747131))), @as(f64, @bitCast(@as(i64, 4634953687517431081))), @as(f64, @bitCast(@as(i64, 4643538448071593558))), @as(f64, @bitCast(@as(i64, 4640904296519825485))), @as(f64, @bitCast(@as(i64, 4644500685232837073))), @as(f64, @bitCast(@as(i64, 4640905071279698881))), @as(f64, @bitCast(@as(i64, 4643761766271913002))), @as(f64, @bitCast(@as(i64, 4634955237389021594))), @as(f64, @bitCast(@as(i64, 4643739093110695238))), @as(f64, @bitCast(@as(i64, 4634988138999049303))), @as(f64, @bitCast(@as(i64, 4644478012071619309))), @as(f64, @bitCast(@as(i64, 4640921522084712735))), @as(f64, @bitCast(@as(i64, 4644501407919839778))), @as(f64, @bitCast(@as(i64, 4640913496529439272))), @as(f64, @bitCast(@as(i64, 4644516687261184935))), @as(f64, @bitCast(@as(i64, 4635744738810635454))), @as(f64, @bitCast(@as(i64, 4644492569077805482))), @as(f64, @bitCast(@as(i64, 4635743938718014154))), @as(f64, @bitCast(@as(i64, 4644477289560538465))), @as(f64, @bitCast(@as(i64, 4640913096834972343))), @as(f64, @bitCast(@as(i64, 4644693756308081051))), @as(f64, @bitCast(@as(i64, 4641187888892048447))), @as(f64, @bitCast(@as(i64, 4644380809438302516))), @as(f64, @bitCast(@as(i64, 4634964820626816174))), @as(f64, @bitCast(@as(i64, 4644356935962230941))), @as(f64, @bitCast(@as(i64, 4634978556183467189))), @as(f64, @bitCast(@as(i64, 4644669882832009476))), @as(f64, @bitCast(@as(i64, 4641194756529636466))), @as(f64, @bitCast(@as(i64, 4644693069685059737))), @as(f64, @bitCast(@as(i64, 4641182635513451863))), @as(f64, @bitCast(@as(i64, 4643927603411707201))), @as(f64, @bitCast(@as(i64, 4635726965073231059))), @as(f64, @bitCast(@as(i64, 4643905103181678253))), @as(f64, @bitCast(@as(i64, 4635761712455418548))), @as(f64, @bitCast(@as(i64, 4644670569455030790))), @as(f64, @bitCast(@as(i64, 4641200009908233049))), @as(f64, @bitCast(@as(i64, 4643821420143336594))), @as(f64, @bitCast(@as(i64, 4641199297424698250))), @as(f64, @bitCast(@as(i64, 4644516009786100364))), @as(f64, @bitCast(@as(i64, 4635760287769823927))), @as(f64, @bitCast(@as(i64, 4644493246376968192))), @as(f64, @bitCast(@as(i64, 4635728390040300657))), @as(f64, @bitCast(@as(i64, 4643798656734204422))), @as(f64, @bitCast(@as(i64, 4641183347996986662))), @as(f64, @bitCast(@as(i64, 4643822093396296514))), @as(f64, @bitCast(@as(i64, 4641190662476100209))), @as(f64, @bitCast(@as(i64, 4643762484560869196))), @as(f64, @bitCast(@as(i64, 4634970367020863513))), @as(f64, @bitCast(@as(i64, 4643738374469895324))), @as(f64, @bitCast(@as(i64, 4634973009719051105))), @as(f64, @bitCast(@as(i64, 4643797983481244502))), @as(f64, @bitCast(@as(i64, 4641191982945584703))), @as(f64, @bitCast(@as(i64, 4643561464456361049))), @as(f64, @bitCast(@as(i64, 4640918001888285247))), @as(f64, @bitCast(@as(i64, 4643928181139096899))), @as(f64, @bitCast(@as(i64, 4635753749528327404))), @as(f64, @bitCast(@as(i64, 4643904525630210415))), @as(f64, @bitCast(@as(i64, 4635734928000322204))), @as(f64, @bitCast(@as(i64, 4643537808947474564))), @as(f64, @bitCast(@as(i64, 4640908591476126368))), @as(f64, @bitCast(@as(i64, 4644136956231057146))), (-@as(f64, @bitCast(@as(i64, 4639410147123076960)))), @as(f64, @bitCast(@as(i64, 4625517067153101801))) });
}

fn offsets_of(ns: *CxList(i64), i_: i64) *CxList(f64) {
    return (if ((i_ >= cx_list_len(ns))) cx_ll_empty(f64) else cx_ll_concat(cx_ll_of(f64, &[_]f64{ beacon_offset_for(cx_list_at(ns, i_)) }), offsets_of(ns, (i_ +% 1))));
}

fn offset_ns() *CxList(i64) {
    return cx_ll_of(i64, &[_]i64{ 0, 1, 2, 3, 7, 12, 40, 119, 120, 121 });
}

fn corners_of(fwd: f64, right: f64, yaw: f64, k_: i64) *CxList(RiderPt) {
    return (if ((k_ >= 4)) cx_ll_empty(RiderPt) else corner_one(fwd, right, yaw, k_));
}

fn corner_one(fwd: f64, right: f64, yaw: f64, k_: i64) *CxList(RiderPt) {
    return b0: { const ax = base_corner_ax(k_, @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), yaw); break :b0 cx_ll_concat(cx_ll_of(RiderPt, &[_]RiderPt{ cx_new(RiderPtS{ .right = (right + ax.x), .forward = (fwd + ax.a_) }) }), corners_of(fwd, right, yaw, (k_ +% 1))); };
}

fn tower_cmds(fwd: f64, right: f64, yaw: f64, phase: f64) *CxList(DrawCmd) {
    return draw_flat(corners_of(fwd, right, yaw, 0), cx_new(RiderPtS{ .right = right, .forward = fwd }), focal(), camera_w(), phase);
}

fn case_near() *CxList(DrawCmd) {
    return tower_cmds(@as(f64, @bitCast(@as(i64, 4624070917402656768))), @as(f64, @bitCast(@as(i64, 4621256167635550208))), @as(f64, @bitCast(@as(i64, 4600877379321698714))), @as(f64, @bitCast(@as(i64, 4633641066610819072))));
}

fn case_mid() *CxList(DrawCmd) {
    return tower_cmds(@as(f64, @bitCast(@as(i64, 4638144666238189568))), (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4629137466983448576)))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4629137466983448576))));
}

fn case_far() *CxList(DrawCmd) {
    return tower_cmds(@as(f64, @bitCast(@as(i64, 4651127699538968576))), @as(f64, @bitCast(@as(i64, 4633641066610819072))), @as(f64, @bitCast(@as(i64, 4607632778762754458))), @as(f64, @bitCast(@as(i64, 0))));
}

fn case_deeper() *CxList(DrawCmd) {
    return tower_cmds(@as(f64, @bitCast(@as(i64, 4655191494515228672))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4636033603912859648))));
}

fn case_sunk() *CxList(DrawCmd) {
    return tower_cmds(@as(f64, @bitCast(@as(i64, 4658815484840378368))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4633641066610819072))));
}

fn case_behind() *CxList(DrawCmd) {
    return tower_cmds(@as(f64, @bitCast(@as(i64, 4596373779694328218))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4633641066610819072))));
}

fn case_neg() *CxList(DrawCmd) {
    return tower_cmds(@as(f64, @bitCast(@as(i64, 4638144666238189568))), (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4629137466983448576)))), @as(f64, @bitCast(@as(i64, 0))), (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4631530004285489152)))));
}

fn all_cmds() *CxList(DrawCmd) {
    return cx_ll_concat(cx_ll_concat(cx_ll_concat(cx_ll_concat(cx_ll_concat(cx_ll_concat(case_near(), case_mid()), case_far()), case_deeper()), case_sunk()), case_behind()), case_neg());
}

fn per_case() *CxList(i64) {
    return cx_ll_of(i64, &[_]i64{ cx_list_len(case_near()), cx_list_len(case_mid()), cx_list_len(case_far()), cx_list_len(case_deeper()), cx_list_len(case_sunk()), cx_list_len(case_behind()), cx_list_len(case_neg()) });
}

fn cmd_tags(cs: *CxList(DrawCmd), i_: i64) *CxList(i64) {
    return (if ((i_ >= cx_list_len(cs))) cx_ll_empty(i64) else cx_ll_concat(cx_ll_of(i64, &[_]i64{ cx_list_at(cs, i_).tag }), cmd_tags(cs, (i_ +% 1))));
}

fn cmd_colors(cs: *CxList(DrawCmd), i_: i64) *CxList(i64) {
    return (if ((i_ >= cx_list_len(cs))) cx_ll_empty(i64) else cx_ll_concat(cx_ll_of(i64, &[_]i64{ cx_list_at(cs, i_).color }), cmd_colors(cs, (i_ +% 1))));
}

fn cmd_counts(cs: *CxList(DrawCmd), i_: i64) *CxList(i64) {
    return (if ((i_ >= cx_list_len(cs))) cx_ll_empty(i64) else cx_ll_concat(cx_ll_of(i64, &[_]i64{ count_of(cx_list_at(cs, i_)) }), cmd_counts(cs, (i_ +% 1))));
}

fn count_of(c_: DrawCmd) i64 {
    return @as(i64, (if ((c_.tag == 3)) 3 else @divTrunc(cx_list_len(c_.pts), 2)));
}

fn cmd_strengths(cs: *CxList(DrawCmd), i_: i64) *CxList(f64) {
    return (if ((i_ >= cx_list_len(cs))) cx_ll_empty(f64) else cx_ll_concat(cx_ll_of(f64, &[_]f64{ cx_list_at(cs, i_).strength }), cmd_strengths(cs, (i_ +% 1))));
}

fn cmd_coords(cs: *CxList(DrawCmd), i_: i64) *CxList(f64) {
    return (if ((i_ >= cx_list_len(cs))) cx_ll_empty(f64) else cx_ll_concat(cx_list_at(cs, i_).pts, cmd_coords(cs, (i_ +% 1))));
}

fn opening() void {
    return b0: { _ = cx_print_line(grade_rel("\x0e\x1b\x49\x10\x1c\x1c\x13\x0d\x0e\x02\x02\x02", offsets_of(offset_ns(), 0), g_tw_offset(), @as(f64, @bitCast(@as(i64, 4517329193108106637))))); _ = cx_print_line(grade_ints("\x0e\x1b\x49\x1f\x0d\x15\x18\x0f\x13\x0d\x02\x02", per_case(), g_tw_percase())); _ = cx_print_line(grade_ints("\x0e\x1b\x49\x0e\x0f\x1d\x13\x02\x02\x02\x02\x02", cmd_tags(all_cmds(), 0), g_tw_tags())); _ = cx_print_line(grade_ints("\x0e\x1b\x49\x18\x10\x17\x10\x15\x13\x02\x02\x02", cmd_colors(all_cmds(), 0), g_tw_colors())); _ = cx_print_line(grade_ints("\x0e\x1b\x49\x18\x10\x19\x12\x0e\x13\x02\x02\x02", cmd_counts(all_cmds(), 0), g_tw_counts())); _ = cx_print_line(grade_rel("\x0e\x1b\x49\x13\x0e\x15\x0d\x12\x1d\x0e\x14\x13", cmd_strengths(all_cmds(), 0), g_tw_strengths(), @as(f64, @bitCast(@as(i64, 4517329193108106637))))); _ = cx_print_line(grade_px("\x0e\x1b\x49\x18\x10\x10\x15\x16\x13\x02\x02\x02", cmd_coords(all_cmds(), 0), g_tw_coords(), @as(f64, @bitCast(@as(i64, 4562254508917369340))), @as(f64, @bitCast(@as(i64, 4517329193108106637))))); break :b0; };
}

fn cx_entry() void {
    opening();
}

pub fn main() void {
    const stack_bytes: usize = 512 * 1024 * 1024;
    const t = std.Thread.spawn(.{ .stack_size = stack_bytes }, cx_entry, .{}) catch @panic("spawn");
    t.join();
}

// ========================================================================
// THE PRELUDE. Everything ABOVE this line is the transpiled program.
//
// What follows is fixed runtime support, emitted into every file this plug
// produces and identical in all of them: the bump allocator and its heap,
// the list and text builtins, the CCE tables, the deck.
//
// It is at the BOTTOM so that the code you came to read is the first thing
// in the file, and so a diff between two emitted programs opens on what
// differs rather than on hundreds of identical lines. Zig does not order
// declarations at container scope, so this costs nothing.
// ========================================================================

const std = @import("std");

fn CxList(comptime T: type) type {
    return struct { items: std.ArrayListUnmanaged(T) = .empty };
}
fn cx_ll_empty(comptime T: type) *CxList(T) {
    const cx_l = cx_gpa.create(CxList(T)) catch @panic("oom");
    cx_l.* = .{};
    return cx_l;
}
// Exact, not rounded. These three build most of what emission
// allocates -- every instruction is a list literal (mov-rr is
// [rex-w, 137, modrm]) and write-bytes concatenates one per byte of an
// immediate -- and they all land on the DECK, which is a finite
// reservation nothing reclaims until the phase ends. Growing through
// std's geometric growCapacity asked for 17 slots to hold four, twice
// per concat, and measured 2026-08-21 that cost 6,963,432 bytes of deck
// on fibx: 9,392,656 bytes of emit-runtime-helpers where bare metal
// spends at most 2,682,824. Bare metal allocates cap*8 + 16 once, from
// __list_concat_many over all operands at their true total. Reserve the
// true total and append without re-checking; cx_ll_push keeps geometric
// growth on purpose, because it is the repeated-append path.
fn cx_ll_of(comptime T: type, vs: []const T) *CxList(T) {
    const l = cx_ll_empty(T);
    l.items.ensureTotalCapacityPrecise(cx_gpa, vs.len) catch @panic("oom");
    l.items.appendSliceAssumeCapacity(vs);
    return l;
}
fn cx_ll_concat(a: anytype, b: @TypeOf(a)) @TypeOf(a) {
    const c = cx_new(@TypeOf(a.*){ .items = .empty });
    c.items.ensureTotalCapacityPrecise(cx_gpa, a.items.items.len + b.items.items.len) catch @panic("oom");
    c.items.appendSliceAssumeCapacity(a.items.items);
    c.items.appendSliceAssumeCapacity(b.items.items);
    return c;
}
// cvtsi2sd on bare metal (emit-real-from-int-builtin): a signed i64 to
// f64 in the default rounding mode, which is round-to-nearest-even.
// @floatFromInt is that same conversion -- exact below 2^53 and correctly
// rounded above it -- so the two arms agree at every magnitude.
fn cx_real_from_int(n: i64) f64 {
    return @floatFromInt(n);
}
// cvttsd2si on bare metal (emit-real-to-int-builtin): truncate toward
// zero, and answer x86's "integer indefinite" -- INT64_MIN -- for a NaN,
// for an infinity, and for anything whose truncation will not fit i64.
// Zig's @intFromFloat truncates the same way but is UNDEFINED out of
// range, so these guards are the mirror of what the hardware actually
// answers rather than decoration: without them the out-of-range cases are
// not merely a different answer from bare metal, they are no answer at
// all. 2^63 is exact in f64, so both bounds are exact and the comparisons
// catch the infinities on the way past.
fn cx_real_to_int(v: f64) i64 {
    if (v != v) return -9223372036854775808;
    if (v >= 9223372036854775808.0) return -9223372036854775808;
    if (v < -9223372036854775808.0) return -9223372036854775808;
    return @intFromFloat(v);
}
fn cx_list_len(l: anytype) i64 {
    return @intCast(l.items.items.len);
}
fn cx_list_at(l: anytype, i: i64) @TypeOf(l.items.items[0]) {
    return l.items.items[@intCast(i)];
}
// ONE heap, bare metal's own model: records, lists, text, closures,
// buffers and the emit workspace all come from a single bump frontier
// (cx_hp), so __heap-restore reclaims everything allocated since the
// matching __heap-save. On bare metal __alloc bumps the same pointer
// the save/restore pair moves, and emit-all-defs brackets EVERY
// definition in one -- emission costs the max over definitions there
// and must not cost the sum here. The region is reserved once and
// never moved: a reallocating region would dangle every pointer
// handed out before the growth. page_allocator memory is lazily
// faulted zero pages, so resident stays proportional to what is
// touched, the zero-fill the guest does at boot comes free, and the
// byte at index i IS address i. The reservation is finite on purpose:
// the depot peeks absolute addresses (smp-* boards poll ~2.1 GB), and
// an address outside the region must refuse with the address in the
// message, not zero-fill its way up to it. The bump pointer boots at
// bare metal's own heap base (boot does mov r10, 6291456): the
// absolute value is observable -- the depot's arith-narrow-proven
// asserts __heap-save > 0 as a structural fact. Addresses below the
// base belong to the deck, which swaps cx_hp in and out below.
// 4 GiB: bare metal's guest is 3 GB and compiles its largest subjects
// inside it, and the hosted harnesses reserve 512 MB of that as deck;
// finding 24 measured the fibx subject at 381 MB deck + ~1.2 GB main,
// which the old 1.5 GiB could not hold. Reserving costs nothing resident
// (lazily faulted, below); what bounds a runaway is the venue's cgroup
// MemoryMax (the ladder's bounded_run), not this constant.
const cx_heap_reserve: usize = 4096 * 1024 * 1024;
var cx_heap_mem: []u8 = &.{};
var cx_hp: i64 = 6291456;
// rawAlloc, NOT Allocator.alloc. The wrapper memsets every allocation to
// `undefined`, which in a Debug build is 0xAA -- so the whole reserved
// region arrived filled with 170s instead of zeros, and the memset
// touched the whole region, committing a reservation that is supposed to
// stay resident in proportion to what is used. Bare metal reserves a
// span the guest zero-filled at boot, so a fresh buffer reads as zero
// there; measured 2026-08-21 with findings/probe-fresh-span.codex,
// ours read 170 in every byte. rawAlloc hands back the pages the OS
// gives, which are zero and faulted lazily.
fn cx_heap_base() [*]u8 {
    if (cx_heap_mem.len == 0) {
        const cx_pa = std.heap.page_allocator;
        const cx_p = cx_pa.rawAlloc(cx_heap_reserve, .fromByteUnits(4096), @returnAddress()) orelse @panic("cx heap: cannot reserve the region");
        cx_heap_mem = cx_p[0..cx_heap_reserve];
    }
    return cx_heap_mem.ptr;
}
// The deck is a FINITE reservation and nothing else enforces it. The
// program places it with __deck-set and then lifts the main frontier
// clear of it with __heap-advance (emit-build reserves
// defs*65536 + 25165824), so the parked main frontier sits exactly at
// the deck's top: inside an extent, a deck allocation that reaches
// cx_bivy has overrun its region and is about to write over main's live
// objects. Outside an extent the deck's live bytes are
// [cx_deck_base, cx_dptr), and main may not OVERLAP that span anywhere,
// not merely cross its top: __heap-restore can park the frontier beneath
// the deck, and a frontier climbing back from below tramples live deck
// objects long before it straddles cx_dptr -- that is the path the
// 2026-08-21 crash took, build_debug_map landing on the decked
// CodegenState. In the standard emit-build shape main lives above the
// deck, so base < cx_dptr never holds and the overlap test is silent.
// Checking only the region ceiling lets the two cursors walk through
// each other in silence -- measured 2026-08-21, fibx's deck ran 8613088
// bytes past a 25362432-byte reservation and the wreckage surfaced as a
// segfault in a hash function thousands of allocations later. Upstream knows this
// failure shape: BuildSettings records that starving the floor crashes
// on a garbage pointer instead of raising CDX9002, because deck-short-of
// reads __deck-pos, which is frozen inside a phase-wide extent. resize
// declines rather than panics, funnelling the crossing into the alloc
// path so there is one refusal site.
fn cx_frontier_crosses(base: usize, len: usize) bool {
    if (cx_nest > 0) {
        if (cx_bivy <= 0) return false;
        const o: usize = @intCast(cx_bivy);
        return base < o and base + len > o;
    }
    if (cx_dptr <= 0) return false;
    const top: usize = @intCast(cx_dptr);
    const bot: usize = @intCast(cx_deck_base);
    return base < top and base + len > bot;
}
fn cx_bump_alloc(_: *anyopaque, len: usize, alignment: std.mem.Alignment, _: usize) ?[*]u8 {
    const base = alignment.forward(@intCast(cx_hp));
    if (base + len > cx_heap_reserve) std.debug.panic("cx heap: exhausted at {d} + {d} of {d}", .{ base, len, cx_heap_reserve });
    if (cx_frontier_crosses(base, len)) std.debug.panic("cx heap: the two cursors met -- alloc at {d} + {d} crosses (hp={d} dptr={d} deck_base={d} bivy={d} nest={d})", .{ base, len, cx_hp, cx_dptr, cx_deck_base, cx_bivy, cx_nest });
    cx_hp = @intCast(base + len);
    cx_deck_armed = false;
    if (cx_nest > 0 and cx_hp > cx_deck_hw) {
        cx_deck_hw = cx_hp;
        if (cx_deck_hw - cx_deck_base > cx_deck_best) cx_deck_best = cx_deck_hw - cx_deck_base;
        cx_deck_report();
    }
    return cx_heap_base() + base;
}
// In-place growth when the block is the topmost allocation is bare
// metal's __list_snoc path 2 -- extend the frontier block, reallocate
// only otherwise. The mirror, not an optimisation: a plug whose list
// growth reallocates where bare metal extends allocates a different
// amount for the same program. free rewinds only the topmost block,
// the same rule from the other side.
fn cx_bump_resize(_: *anyopaque, memory: []u8, _: std.mem.Alignment, new_len: usize, _: usize) bool {
    const off = @intFromPtr(memory.ptr) - @intFromPtr(cx_heap_base());
    if (off + memory.len == @as(usize, @intCast(cx_hp))) {
        if (off + new_len > cx_heap_reserve) return false;
        if (cx_frontier_crosses(off, new_len)) return false;
        cx_hp = @intCast(off + new_len);
        return true;
    }
    return new_len <= memory.len;
}
fn cx_bump_remap(ctx: *anyopaque, memory: []u8, alignment: std.mem.Alignment, new_len: usize, ra: usize) ?[*]u8 {
    return if (cx_bump_resize(ctx, memory, alignment, new_len, ra)) memory.ptr else null;
}
fn cx_bump_free(_: *anyopaque, memory: []u8, _: std.mem.Alignment, _: usize) void {
    const off = @intFromPtr(memory.ptr) - @intFromPtr(cx_heap_base());
    if (off + memory.len == @as(usize, @intCast(cx_hp))) cx_hp = @intCast(off);
}
const cx_heap_vtable = std.mem.Allocator.VTable{ .alloc = cx_bump_alloc, .resize = cx_bump_resize, .remap = cx_bump_remap, .free = cx_bump_free };
const cx_gpa = std.mem.Allocator{ .ptr = undefined, .vtable = &cx_heap_vtable };
// The deck is the C# plug's rule (_Buf.deck_enter/deck_exit): the
// outermost enter parks the bump pointer in the bivy and swaps the deck
// pointer in; the outermost exit swaps back. Deck position is observable
// (the depot's deck-*-contract subjects print it), so a no-op deck is a
// wrong answer, not a simplification.
var cx_dptr: i64 = 0;
var cx_bivy: i64 = 0;
var cx_nest: i64 = 0;
// The deck high-water mark. `emit-build` reserves defs*65536+25165824 for
// the deck and lifts the main frontier to exactly its top, so while an extent
// is open the PARKED frontier (cx_bivy) IS the reservation ceiling and cx_hp is
// the live deck cursor. Peak minus base is what the deck cost; ceiling minus
// peak is what was left. Nothing else can report this -- the deck-pos cell is
// frozen inside an extent, which is why upstream's own deck-short-of guard
// cannot fire where exhaustion actually happens.
var cx_deck_base: i64 = 0;
var cx_deck_hw: i64 = 0;
var cx_deck_top: i64 = 0;
var cx_deck_best: i64 = 0;
var cx_deck_stride: i64 = 0;
var cx_deck_armed: bool = false;
// STDOUT, never stderr. stderr carries the program's output and every
// comparison in the ladder diffs it, so a measurement written there would
// corrupt the thing being measured. Raw write syscall rather than
// std.Io.File, which in 0.16 wants an Io instance. Only on a new peak, so the
// lines are few and the last one is the answer.
fn cx_deck_report() void {
    if (@import("builtin").os.tag != .linux) return;
    if (cx_deck_base == 0 or cx_deck_top == 0) return;
    const cx_used = cx_deck_hw - cx_deck_base;
    if (cx_used - cx_deck_stride < 1048576) return;
    cx_deck_stride = cx_used;
    var cx_b: [224]u8 = undefined;
    const cx_s = std.fmt.bufPrint(&cx_b, "CX-DECK used={d} reserved={d} headroom={d} base={d} peak={d} best={d}\n", .{ cx_used, cx_deck_top - cx_deck_base, cx_deck_top - cx_deck_hw, cx_deck_base, cx_deck_hw, cx_deck_best }) catch return;
    _ = std.os.linux.write(1, cx_s.ptr, cx_s.len);
}
fn cx_new(v: anytype) *@TypeOf(v) {
    const p = cx_gpa.create(@TypeOf(v)) catch @panic("oom");
    p.* = v;
    return p;
}
// An accumulator loop appends to the frontier block, and the bytes
// just past it are free. Growing there leaves every existing holder of
// `a` seeing the same bytes -- text is immutable and nothing before
// a.len is written -- so the loop costs n instead of n(n+1)/2. Bare
// metal reaches the same asymptotics from the other side, statically:
// is-inplace-append (X86_64.codex:2376) recognises a tail-recursive
// accumulator parameter and calls __str_concat_inplace. That analysis
// needs TCO state this emitter does not track, and it does not need to:
// on a bump frontier the same question is one pointer comparison at run
// time. Measured 2026-08-21 with findings/probe-memory-model.codex,
// text accumulation at n = 64/128/256: 2080/8256/32896 bytes before
// (exactly n(n+1)/2), 64/128/256 after, against bare metal 72/136/264.
// No empty short-circuit. `a & ""` returning `a` is the finding-29 shape:
// bare metal has no such case -- both emit-str-concat-fast-bump and
// emit-str-concat-slow-alloc bump r10 unconditionally, so the result is
// always a fresh block at the live cursor -- and an aliased return inside a
// deck extent yields a value that looks decked and is not. Falling through
// costs an empty allocation and buys the guarantee.
fn cx_concat(a: []const u8, b: []const u8) []const u8 {
    if (a.len != 0) {
        const cx_base = @intFromPtr(cx_heap_base());
        const cx_ap = @intFromPtr(a.ptr);
        if (cx_ap >= cx_base and cx_ap - cx_base + a.len == @as(usize, @intCast(cx_hp))) {
            const cx_tail = cx_gpa.alloc(u8, b.len) catch @panic("oom");
            @memcpy(cx_tail, b);
            return a.ptr[0 .. a.len + b.len];
        }
    }
    return std.mem.concat(cx_gpa, u8, &.{ a, b }) catch @panic("oom");
}
const cce_table = [128]u32{ 0, 10, 32, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 101, 116, 97, 111, 105, 110, 115, 104, 114, 100, 108, 99, 117, 109, 119, 102, 103, 121, 112, 98, 118, 107, 106, 120, 113, 122, 69, 84, 65, 79, 73, 78, 83, 72, 82, 68, 76, 67, 85, 77, 87, 70, 71, 89, 80, 66, 86, 75, 74, 88, 81, 90, 46, 44, 33, 63, 58, 59, 39, 34, 45, 40, 41, 43, 61, 42, 60, 62, 47, 64, 35, 38, 95, 92, 124, 91, 93, 123, 125, 126, 96, 94, 36, 37, 233, 232, 234, 235, 225, 224, 226, 228, 243, 244, 246, 250, 252, 241, 231, 237, 1072, 1086, 1077, 1080, 1085, 1090, 1089, 1088, 1074, 1083, 1082, 1084, 1076, 1087, 1091 };
// The multi-byte tiers, from Foreword CCE (which the compiler inlines in
// X86_64State): codes 128..2175 frame as two bytes and name eleven
// tier-1 unicode blocks; codes 2176..67711 frame as three bytes and name
// ten tier-2 blocks, code bases running cumulatively from 2176. The
// single-byte table wins any overlap (accented Latin, Cyrillic) because
// it is scanned first, as from-unicode scans tier 0 first.
const cce_t1_uni = [11]u32{ 128, 1024, 880, 1536, 1424, 2304, 3584, 4352, 19968, 12352, 8704 };
const cce_t1_size = [11]u32{ 256, 128, 128, 128, 128, 128, 128, 128, 512, 256, 128 };
const cce_t1_code = [11]u32{ 128, 384, 512, 640, 768, 896, 1024, 1152, 1280, 1792, 2048 };
const cce_t2_uni = [10]u32{ 12288, 12352, 12448, 19968, 13312, 44032, 3584, 8192, 127744, 9728 };
const cce_t2_size = [10]u32{ 64, 96, 96, 20992, 6592, 11172, 256, 512, 1024, 256 };
fn cx_cce_to_cp(c: i64) i64 {
    if (c < 0) return 65533;
    if (c < 128) return @intCast(cce_table[@intCast(c)]);
    if (c < 67712) {
        const v: u32 = @intCast(c);
        if (v < 2176) {
            for (cce_t1_code, cce_t1_size, cce_t1_uni) |start, size, uni| {
                if (v >= start and v < start + size) return @intCast(uni + (v - start));
            }
            return 65533;
        }
        var base: u32 = 2176;
        for (cce_t2_uni, cce_t2_size) |uni, size| {
            if (v >= base and v < base + size) return @intCast(uni + (v - base));
            base += size;
        }
    }
    return 65533;
}
fn cx_cce_to_utf8(s: []const u8) []const u8 {
    var out: std.ArrayListUnmanaged(u8) = .empty;
    const al = cx_gpa;
    var i: usize = 0;
    while (i < s.len) {
        const b0: i64 = s[i];
        var code: i64 = b0;
        if (b0 & 128 == 0) {
            i += 1;
        } else if (b0 & 224 == 192) {
            code = 128 + ((b0 & 31) << 6) + (s[i + 1] & 63);
            i += 2;
        } else if (b0 & 240 == 224) {
            code = 2176 + ((b0 & 15) << 12) + (@as(i64, s[i + 1] & 63) << 6) + (s[i + 2] & 63);
            i += 3;
        } else {
            code = 67712 + ((b0 & 7) << 18) + (@as(i64, s[i + 1] & 63) << 12) + (@as(i64, s[i + 2] & 63) << 6) + (s[i + 3] & 63);
            i += 4;
        }
        const cp: u32 = @intCast(cx_cce_to_cp(code));
        if (cp < 128) {
            out.append(al, @intCast(cp)) catch @panic("oom");
        } else if (cp < 2048) {
            out.append(al, @intCast(192 + (cp >> 6))) catch @panic("oom");
            out.append(al, @intCast(128 + (cp & 63))) catch @panic("oom");
        } else if (cp < 65536) {
            out.append(al, @intCast(224 + (cp >> 12))) catch @panic("oom");
            out.append(al, @intCast(128 + ((cp >> 6) & 63))) catch @panic("oom");
            out.append(al, @intCast(128 + (cp & 63))) catch @panic("oom");
        } else {
            out.append(al, @intCast(240 + (cp >> 18))) catch @panic("oom");
            out.append(al, @intCast(128 + ((cp >> 12) & 63))) catch @panic("oom");
            out.append(al, @intCast(128 + ((cp >> 6) & 63))) catch @panic("oom");
            out.append(al, @intCast(128 + (cp & 63))) catch @panic("oom");
        }
    }
    return out.items;
}
// One allocation, not two: the digits land in a stack scratch first
// (i64 needs at most 20 bytes), then the CCE translation is the only
// heap object. The double allocation left the ASCII copy stranded on
// the frontier where it blocked in-place extension of whatever grew
// next.
fn cx_show_int(n: i64) []const u8 {
    var cx_tmp: [24]u8 = undefined;
    const ascii = std.fmt.bufPrint(&cx_tmp, "{d}", .{n}) catch unreachable;
    const buf = cx_gpa.alloc(u8, ascii.len) catch @panic("oom");
    for (ascii, 0..) |cx_ch, cx_i| {
        buf[cx_i] = if (cx_ch == '-') 73 else 3 + (cx_ch - '0');
    }
    return buf;
}
fn cx_print_line(s: []const u8) void {
    std.debug.print("{s}\n", .{cx_cce_to_utf8(s)});
}
fn cx_print(s: []const u8) void {
    std.debug.print("{s}", .{cx_cce_to_utf8(s)});
}


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
    color2: i64,
    strength: f64,
    geom: *CxList(f64),
    pts: *CxList(f64),
};
const DrawCmd = *DrawCmdS;

const MetricsS = struct {
    bx: f64,
    by: f64,
    ht: f64,
    apex_y: f64,
    foliage: f64,
    w: f64,
};
const Metrics = *MetricsS;

const PondPtS = struct {
    cu: f64,
    cv: f64,
};
const PondPt = *PondPtS;

const DuckS = struct {
    p_: PondPt,
    face_right: bool,
};
const Duck = *DuckS;

const RailPolyS = struct {
    v_: *CxList(Vec3),
    color: i64,
    fwd: f64,
};
const RailPoly = *RailPolyS;

const RgbS = struct {
    r_: f64,
    g: f64,
    b_: f64,
};
const Rgb = *RgbS;

const SunPosS = struct {
    visible: bool,
    x: f64,
    y: f64,
    scale: f64,
};
const SunPos = *SunPosS;

fn list_tail_loop(comptime T17: type, xs: *CxList(T17), i_: i64, len_: i64, acc_: *CxList(T17)) *CxList(T17) {
    var _tl_i = i_;
    var _tl_acc = acc_;
    while (true) {
        if ((_tl_i >= len_)) { return _tl_acc; } else { { const _tj1_1 = (_tl_i +% 1); const _tj1_3 = cx_ll_push(_tl_acc, cx_list_at(xs, _tl_i)); _tl_i = _tj1_1; _tl_acc = _tj1_3; continue; } }
    }
}

fn list_take(comptime T18: type, xs: *CxList(T18), n_: i64) *CxList(T18) {
    return list_take_loop(T18, xs, 0, (if ((n_ > cx_list_len(xs))) cx_list_len(xs) else n_), cx_ll_empty(T18));
}

fn list_take_loop(comptime T19: type, xs: *CxList(T19), i_: i64, n_: i64, acc_: *CxList(T19)) *CxList(T19) {
    var _tl_i = i_;
    var _tl_acc = acc_;
    while (true) {
        if ((_tl_i >= n_)) { return _tl_acc; } else { { const _tj1_1 = (_tl_i +% 1); const _tj1_3 = cx_ll_push(_tl_acc, cx_list_at(xs, _tl_i)); _tl_i = _tj1_1; _tl_acc = _tj1_3; continue; } }
    }
}

fn list_drop(comptime T20: type, xs: *CxList(T20), n_: i64) *CxList(T20) {
    return list_tail_loop(T20, xs, (if ((n_ > cx_list_len(xs))) cx_list_len(xs) else n_), cx_list_len(xs), cx_ll_empty(T20));
}

fn round_real(x: f64) f64 {
    return b0: { const t: f64 = cx_real_from_int(cx_real_to_int(x)); break :b0 b1: { const f: f64 = (x - t); break :b1 (if ((f >= @as(f64, @bitCast(@as(i64, 4602678819172646912))))) (t + @as(f64, @bitCast(@as(i64, 4607182418800017408)))) else (if ((f <= (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4602678819172646912)))))) (t - @as(f64, @bitCast(@as(i64, 4607182418800017408)))) else t)); }; };
}

fn floor_real(x: f64) f64 {
    return b0: { const t: f64 = cx_real_from_int(cx_real_to_int(x)); break :b0 (if ((t > x)) (t - @as(f64, @bitCast(@as(i64, 4607182418800017408)))) else t); };
}

fn mod_real(x: f64, m_: f64) f64 {
    return (x - (m_ * floor_real((x / m_))));
}

fn real_min(a_: f64, b_: f64) f64 {
    return (if ((a_ < b_)) a_ else b_);
}

fn real_max(a_: f64, b_: f64) f64 {
    return (if ((a_ > b_)) a_ else b_);
}

fn real_abs(x: f64) f64 {
    return (if ((x < @as(f64, @bitCast(@as(i64, 0))))) (@as(f64, @bitCast(@as(i64, 0))) - x) else x);
}

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

fn dm_two_pi() f64 {
    return @as(f64, @bitCast(@as(i64, 4618760256179416344)));
}

fn dm_pi() f64 {
    return @as(f64, @bitCast(@as(i64, 4614256656552045848)));
}

fn dm_half_pi() f64 {
    return @as(f64, @bitCast(@as(i64, 4609753056924675354)));
}

fn dm_reduce(x: f64) f64 {
    return b0: { const k_: f64 = cx_real_from_int(cx_real_to_int((x / dm_two_pi()))); break :b0 b1: { const r_: f64 = (x - (k_ * dm_two_pi())); break :b1 (if ((r_ > dm_pi())) (r_ - dm_two_pi()) else (if ((r_ < (@as(f64, @bitCast(@as(i64, 0))) - dm_pi()))) (r_ + dm_two_pi()) else r_)); }; };
}

fn dm_fold_quadrant(r_: f64) f64 {
    return (if ((r_ > dm_half_pi())) (dm_pi() - r_) else (if ((r_ < (@as(f64, @bitCast(@as(i64, 0))) - dm_half_pi()))) ((@as(f64, @bitCast(@as(i64, 0))) - dm_pi()) - r_) else r_));
}

fn dm_sin_poly(r_: f64) f64 {
    return b0: { const r2: f64 = (r_ * r_); break :b0 b1: { const r3: f64 = (r2 * r_); break :b1 b2: { const r5: f64 = (r3 * r2); break :b2 b3: { const r7: f64 = (r5 * r2); break :b3 b4: { const r9: f64 = (r7 * r2); break :b4 b5: { const r11: f64 = (r9 * r2); break :b5 (((((r_ - (r3 / @as(f64, @bitCast(@as(i64, 4618441417868443648))))) + (r5 / @as(f64, @bitCast(@as(i64, 4638144666238189568))))) - (r7 / @as(f64, @bitCast(@as(i64, 4662263553305083904))))) + (r9 / @as(f64, @bitCast(@as(i64, 4689977843394805760))))) - (r11 / @as(f64, @bitCast(@as(i64, 4720626352061939712))))); }; }; }; }; }; };
}

fn real_sin(x: f64) f64 {
    return dm_sin_poly(dm_fold_quadrant(dm_reduce(x)));
}

fn real_cos(x: f64) f64 {
    return dm_sin_poly(dm_fold_quadrant(dm_reduce((x + dm_half_pi()))));
}

fn pi() f64 {
    return dm_pi();
}

fn two_pi() f64 {
    return dm_two_pi();
}

fn half_pi() f64 {
    return dm_half_pi();
}

fn deg() f64 {
    return @as(f64, @bitCast(@as(i64, 4580687790476533049)));
}

fn wrap(x: f64, fuel: i64) f64 {
    var _tl_x = x;
    var _tl_fuel = fuel;
    while (true) {
        if ((_tl_fuel <= 0)) { return _tl_x; } else { if ((_tl_x > pi())) { { const _tj2_0 = (_tl_x - two_pi()); const _tj2_1 = (_tl_fuel -% 1); _tl_x = _tj2_0; _tl_fuel = _tj2_1; continue; } } else { if ((_tl_x < (@as(f64, @bitCast(@as(i64, 0))) - pi()))) { { const _tj3_0 = (_tl_x + two_pi()); const _tj3_1 = (_tl_fuel -% 1); _tl_x = _tj3_0; _tl_fuel = _tj3_1; continue; } } else { return _tl_x; } } }
    }
}

fn r_sin(x: f64) f64 {
    return real_sin(x);
}

fn r_cos(x: f64) f64 {
    return real_cos(x);
}

fn r_tan(x: f64) f64 {
    return (real_sin(x) / real_cos(x));
}

fn atan_halve(t: f64, n_: i64) f64 {
    var _tl_t = t;
    var _tl_n = n_;
    while (true) {
        if ((_tl_n <= 0)) { return _tl_t; } else { { const _tj1_0 = (_tl_t / (@as(f64, @bitCast(@as(i64, 4607182418800017408))) + real_sqrt((@as(f64, @bitCast(@as(i64, 4607182418800017408))) + (_tl_t * _tl_t))))); const _tj1_1 = (_tl_n -% 1); _tl_t = _tj1_0; _tl_n = _tj1_1; continue; } }
    }
}

fn atan_series(u_: f64) f64 {
    return b0: { const @"u2": f64 = (u_ * u_); break :b0 b1: { const @"u3": f64 = (@"u2" * u_); break :b1 b2: { const @"u5": f64 = (@"u3" * @"u2"); break :b2 b3: { const @"u7": f64 = (@"u5" * @"u2"); break :b3 b4: { const @"u9": f64 = (@"u7" * @"u2"); break :b4 b5: { const @"u11": f64 = (@"u9" * @"u2"); break :b5 (((((u_ - (@"u3" / @as(f64, @bitCast(@as(i64, 4613937818241073152))))) + (@"u5" / @as(f64, @bitCast(@as(i64, 4617315517961601024))))) - (@"u7" / @as(f64, @bitCast(@as(i64, 4619567317775286272))))) + (@"u9" / @as(f64, @bitCast(@as(i64, 4621256167635550208))))) - (@"u11" / @as(f64, @bitCast(@as(i64, 4622382067542392832))))); }; }; }; }; }; };
}

fn atan_core(t: f64) f64 {
    return (@as(f64, @bitCast(@as(i64, 4625196817309499392))) * atan_series(atan_halve(t, 4)));
}

fn r_atan(t: f64) f64 {
    return (if ((t > @as(f64, @bitCast(@as(i64, 4607182418800017408))))) (half_pi() - atan_core((@as(f64, @bitCast(@as(i64, 4607182418800017408))) / t))) else (if ((t < (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4607182418800017408)))))) ((@as(f64, @bitCast(@as(i64, 0))) - half_pi()) - atan_core((@as(f64, @bitCast(@as(i64, 4607182418800017408))) / t))) else atan_core(t)));
}

fn clip_cross(a_: Vec3, b_: Vec3, _arg_near: f64) *CxList(Vec3) {
    return b0: { const f: f64 = ((_arg_near - a_.forward) / (b_.forward - a_.forward)); break :b0 cx_ll_of(Vec3, &[_]Vec3{ cx_new(Vec3S{ .right = (a_.right + (f * (b_.right - a_.right))), .forward = _arg_near, .height = (a_.height + (f * (b_.height - a_.height))) }) }); };
}

fn clip_near_edge(poly: *CxList(Vec3), _arg_near: f64, i_: i64) *CxList(Vec3) {
    return b0: { const n_: i64 = cx_list_len(poly); break :b0 (if ((i_ >= n_)) cx_ll_empty(Vec3) else b2: { const a_ = cx_list_at(poly, i_); break :b2 b3: { const b_ = cx_list_at(poly, ((i_ +% 1) -% (@divTrunc((i_ +% 1), n_) *% n_))); break :b3 b4: { const a_in: bool = (a_.forward >= _arg_near); break :b4 b5: { const b_in: bool = (b_.forward >= _arg_near); break :b5 b6: { const kept = (if (a_in) cx_ll_of(Vec3, &[_]Vec3{ a_ }) else cx_ll_empty(Vec3)); break :b6 b7: { const crossed = (if ((if (a_in) b_in else (if (b_in) false else true))) cx_ll_empty(Vec3) else clip_cross(a_, b_, _arg_near)); break :b7 cx_ll_concat(cx_ll_concat(kept, crossed), clip_near_edge(poly, _arg_near, (i_ +% 1))); }; }; }; }; }; }); };
}

fn clip_near(poly: *CxList(Vec3), _arg_near: f64) *CxList(Vec3) {
    return clip_near_edge(poly, _arg_near, 0);
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

fn min_focal_factor() f64 {
    return @as(f64, @bitCast(@as(i64, 4599976659396224614)));
}

fn min_gaze_focal_factor() f64 {
    return @as(f64, @bitCast(@as(i64, 4603669611090668421)));
}

fn cam_focal(lean_frac: f64, attention: f64) f64 {
    return b0: { const a_: f64 = (focal() * (@as(f64, @bitCast(@as(i64, 4607182418800017408))) - (((@as(f64, @bitCast(@as(i64, 4607182418800017408))) - min_focal_factor()) * lean_frac) * lean_frac))); break :b0 b1: { const b_: f64 = (focal() * (@as(f64, @bitCast(@as(i64, 4607182418800017408))) - ((@as(f64, @bitCast(@as(i64, 4607182418800017408))) - min_gaze_focal_factor()) * attention))); break :b1 (if ((a_ < b_)) a_ else b_); }; };
}

fn project(p_: Vec3, cf: f64, view_w: f64) ScreenPt {
    return cx_new(ScreenPtS{ .x = ((view_w / @as(f64, @bitCast(@as(i64, 4611686018427387904)))) + ((p_.right / p_.forward) * cf)), .y = ((camera_h() / @as(f64, @bitCast(@as(i64, 4611686018427387904)))) - (((p_.height - eye_h()) / p_.forward) * cf)) });
}

fn flatten_screen(ps: *CxList(ScreenPt), i_: i64) *CxList(f64) {
    return (if ((i_ >= cx_list_len(ps))) cx_ll_empty(f64) else b1: { const p_ = cx_list_at(ps, i_); break :b1 cx_ll_concat(cx_ll_of(f64, &[_]f64{ p_.x, p_.y }), flatten_screen(ps, (i_ +% 1))); });
}

fn push_poly(color: i64, ps: *CxList(ScreenPt)) *CxList(DrawCmd) {
    return (if ((cx_list_len(ps) < 3)) cx_ll_empty(DrawCmd) else cx_ll_of(DrawCmd, &[_]DrawCmd{ cx_new(DrawCmdS{ .tag = 0, .color = color, .color2 = 0, .strength = @as(f64, @bitCast(@as(i64, 0))), .geom = cx_ll_empty(f64), .pts = flatten_screen(ps, 0) }) }));
}

fn push_round_poly(color: i64, strength: f64, ps: *CxList(ScreenPt)) *CxList(DrawCmd) {
    return (if ((cx_list_len(ps) < 3)) cx_ll_empty(DrawCmd) else cx_ll_of(DrawCmd, &[_]DrawCmd{ cx_new(DrawCmdS{ .tag = 1, .color = color, .color2 = 0, .strength = strength, .geom = cx_ll_empty(f64), .pts = flatten_screen(ps, 0) }) }));
}

fn push_beacon(color: i64, x: f64, y: f64, r_: f64, alpha: f64) *CxList(DrawCmd) {
    return cx_ll_of(DrawCmd, &[_]DrawCmd{ cx_new(DrawCmdS{ .tag = 3, .color = color, .color2 = 0, .strength = alpha, .geom = cx_ll_of(f64, &[_]f64{ x, y, r_ }), .pts = cx_ll_empty(f64) }) });
}

fn pack_rgb(r_: i64, g: i64, b_: i64) i64 {
    return ((cx_shl(r_, 16) | cx_shl(g, 8)) | b_);
}

fn shade_chan(v_: i64, f: f64) i64 {
    return b0: { const scaled: i64 = cx_real_to_int(round_real((cx_real_from_int(v_) * f))); break :b0 @as(i64, (if ((scaled > 255)) 255 else scaled)); };
}

fn shade_color(c_: i64, f: f64) i64 {
    return pack_rgb(shade_chan((cx_shr(c_, 16) & 255), f), shade_chan((cx_shr(c_, 8) & 255), f), shade_chan((c_ & 255), f));
}

fn shade_edge_darken() f64 {
    return @as(f64, @bitCast(@as(i64, 4600877379321698714)));
}

fn shade_middle_lift() f64 {
    return @as(f64, @bitCast(@as(i64, 4598175219545276416)));
}

fn width_shade_edge(color: i64, strength: f64) i64 {
    return shade_color(color, (@as(f64, @bitCast(@as(i64, 4607182418800017408))) - (shade_edge_darken() * strength)));
}

fn width_shade_middle(color: i64, strength: f64) i64 {
    return shade_color(color, (@as(f64, @bitCast(@as(i64, 4607182418800017408))) + (shade_middle_lift() * strength)));
}

fn min_disc_radius() f64 {
    return @as(f64, @bitCast(@as(i64, 4602678819172646912)));
}

fn min_disc_alpha() f64 {
    return @as(f64, @bitCast(@as(i64, 4581421828931458171)));
}

fn min_gradient_radius() f64 {
    return @as(f64, @bitCast(@as(i64, 4602678819172646912)));
}

fn min_shade_width() f64 {
    return @as(f64, @bitCast(@as(i64, 4607182418800017408)));
}

fn disc_visible(r_: f64, alpha: f64) bool {
    return ((r_ >= min_disc_radius()) and (alpha >= min_disc_alpha()));
}

fn radial_visible(r_: f64) bool {
    return (r_ >= min_gradient_radius());
}

fn span_lo(xs: *CxList(f64), i_: i64, acc_: f64) f64 {
    var _tl_i = i_;
    var _tl_acc = acc_;
    while (true) {
        if ((_tl_i >= cx_list_len(xs))) { return _tl_acc; } else { { const _tj1_1 = (_tl_i +% 2); const _tj1_2 = (if ((cx_list_at(xs, _tl_i) < _tl_acc)) cx_list_at(xs, _tl_i) else _tl_acc); _tl_i = _tj1_1; _tl_acc = _tj1_2; continue; } }
    }
}

fn span_hi(xs: *CxList(f64), i_: i64, acc_: f64) f64 {
    var _tl_i = i_;
    var _tl_acc = acc_;
    while (true) {
        if ((_tl_i >= cx_list_len(xs))) { return _tl_acc; } else { { const _tj1_1 = (_tl_i +% 2); const _tj1_2 = (if ((cx_list_at(xs, _tl_i) > _tl_acc)) cx_list_at(xs, _tl_i) else _tl_acc); _tl_i = _tj1_1; _tl_acc = _tj1_2; continue; } }
    }
}

fn as_solid(c_: DrawCmd) DrawCmd {
    return cx_new(DrawCmdS{ .tag = 0, .color = c_.color, .color2 = 0, .strength = @as(f64, @bitCast(@as(i64, 0))), .geom = cx_ll_empty(f64), .pts = c_.pts });
}

fn expand_shade(c_: DrawCmd) DrawCmd {
    return (if ((c_.strength <= @as(f64, @bitCast(@as(i64, 0))))) as_solid(c_) else (if ((cx_list_len(c_.pts) < 2)) as_solid(c_) else b2: { const lo: f64 = span_lo(c_.pts, 0, cx_list_at(c_.pts, 0)); break :b2 b3: { const hi: f64 = span_hi(c_.pts, 0, cx_list_at(c_.pts, 0)); break :b3 (if (((hi - lo) < min_shade_width())) as_solid(c_) else cx_new(DrawCmdS{ .tag = 2, .color = width_shade_edge(c_.color, c_.strength), .color2 = width_shade_middle(c_.color, c_.strength), .strength = @as(f64, @bitCast(@as(i64, 0))), .geom = cx_ll_of(f64, &[_]f64{ lo, hi }), .pts = c_.pts })); }; }));
}

fn expand_cmd(c_: DrawCmd) *CxList(DrawCmd) {
    return (if ((c_.tag == 1)) cx_ll_of(DrawCmd, &[_]DrawCmd{ expand_shade(c_) }) else (if ((c_.tag == 3)) (if (disc_visible(cx_list_at(c_.geom, 2), c_.strength)) cx_ll_of(DrawCmd, &[_]DrawCmd{ c_ }) else cx_ll_empty(DrawCmd)) else (if ((c_.tag == 4)) (if (radial_visible(cx_list_at(c_.geom, 2))) cx_ll_of(DrawCmd, &[_]DrawCmd{ c_ }) else cx_ll_empty(DrawCmd)) else cx_ll_of(DrawCmd, &[_]DrawCmd{ c_ }))));
}

fn blit_expand(cs: *CxList(DrawCmd), i_: i64) *CxList(DrawCmd) {
    return (if ((i_ >= cx_list_len(cs))) cx_ll_empty(DrawCmd) else cx_ll_concat(expand_cmd(cx_list_at(cs, i_)), blit_expand(cs, (i_ +% 1))));
}

fn tier_top() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4591870180066957722))), @as(f64, @bitCast(@as(i64, 4596373779694328218))), @as(f64, @bitCast(@as(i64, 4599075939470750515))), @as(f64, @bitCast(@as(i64, 4600877379321698714))), @as(f64, @bitCast(@as(i64, 4602678819172646912))), @as(f64, @bitCast(@as(i64, 4603579539098121011))), @as(f64, @bitCast(@as(i64, 4604480259023595110))) });
}

fn tier_bot() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ @as(f64, @bitCast(@as(i64, 4599075939470750515))), @as(f64, @bitCast(@as(i64, 4600877379321698714))), @as(f64, @bitCast(@as(i64, 4602678819172646912))), @as(f64, @bitCast(@as(i64, 4603579539098121011))), @as(f64, @bitCast(@as(i64, 4604480259023595110))), @as(f64, @bitCast(@as(i64, 4605380978949069210))), @as(f64, @bitCast(@as(i64, 4606281698874543309))), @as(f64, @bitCast(@as(i64, 4607182418800017408))) });
}

fn tier_wide() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ @as(f64, @bitCast(@as(i64, 4599976659396224614))), @as(f64, @bitCast(@as(i64, 4601597955262077993))), @as(f64, @bitCast(@as(i64, 4602949035150289142))), @as(f64, @bitCast(@as(i64, 4603849755075763241))), @as(f64, @bitCast(@as(i64, 4604660403008689930))), @as(f64, @bitCast(@as(i64, 4605471050941616620))), @as(f64, @bitCast(@as(i64, 4606371770867090719))), @as(f64, @bitCast(@as(i64, 4607182418800017408))) });
}

fn trunk_color() i64 {
    return 5914146;
}

fn visible_trunk() f64 {
    return @as(f64, @bitCast(@as(i64, 4601597955262077993)));
}

fn crown_h() f64 {
    return @as(f64, @bitCast(@as(i64, 4604011884662348579)));
}

fn crown_w() f64 {
    return @as(f64, @bitCast(@as(i64, 4598859766688636731)));
}

fn min_cone_forward() f64 {
    return @as(f64, @bitCast(@as(i64, 4600877379321698714)));
}

fn ring_n() i64 {
    return 16;
}

fn metrics(right: f64, forward: f64, height: f64, cf: f64, view_w: f64) Metrics {
    return b0: { const base_ = project(cx_new(Vec3S{ .right = right, .forward = forward, .height = @as(f64, @bitCast(@as(i64, 0))) }), cf, view_w); break :b0 b1: { const top_ = project(cx_new(Vec3S{ .right = right, .forward = forward, .height = height }), cf, view_w); break :b1 b2: { const ht: f64 = (base_.y - top_.y); break :b2 b3: { const foliage: f64 = (ht * crown_h()); break :b3 b4: { const crown_bottom_y: f64 = (base_.y - (ht * visible_trunk())); break :b4 cx_new(MetricsS{ .bx = base_.x, .by = base_.y, .ht = ht, .apex_y = (crown_bottom_y - foliage), .foliage = foliage, .w = (ht * crown_w()) }); }; }; }; }; };
}

fn draw_trunk(m_: Metrics, round_trunk: bool) *CxList(DrawCmd) {
    return b0: { const trunk_w: f64 = @as(f64, (if (((m_.ht * @as(f64, @bitCast(@as(i64, 4590429028186199163)))) > @as(f64, @bitCast(@as(i64, 4607182418800017408))))) (m_.ht * @as(f64, @bitCast(@as(i64, 4590429028186199163)))) else @as(f64, @bitCast(@as(i64, 4607182418800017408))))); break :b0 b1: { const trunk_h: f64 = ((m_.ht * visible_trunk()) + (m_.ht * @as(f64, @bitCast(@as(i64, 4587366580439587226))))); break :b1 b2: { const tx: f64 = (m_.bx - (trunk_w / @as(f64, @bitCast(@as(i64, 4611686018427387904))))); break :b2 b3: { const pts = cx_ll_of(ScreenPt, &[_]ScreenPt{ cx_new(ScreenPtS{ .x = tx, .y = (m_.by - trunk_h) }), cx_new(ScreenPtS{ .x = (tx + trunk_w), .y = (m_.by - trunk_h) }), cx_new(ScreenPtS{ .x = (tx + trunk_w), .y = m_.by }), cx_new(ScreenPtS{ .x = tx, .y = m_.by }) }); break :b3 (if (round_trunk) push_round_poly(trunk_color(), @as(f64, @bitCast(@as(i64, 4607182418800017408))), pts) else push_poly(trunk_color(), pts)); }; }; }; };
}

fn tier_triangle(m_: Metrics, k_: i64, color: i64) *CxList(DrawCmd) {
    return b0: { const tri = cx_ll_of(ScreenPt, &[_]ScreenPt{ cx_new(ScreenPtS{ .x = m_.bx, .y = (m_.apex_y + (m_.foliage * cx_list_at(tier_top(), k_))) }), cx_new(ScreenPtS{ .x = (m_.bx + (m_.w * cx_list_at(tier_wide(), k_))), .y = (m_.apex_y + (m_.foliage * cx_list_at(tier_bot(), k_))) }), cx_new(ScreenPtS{ .x = (m_.bx - (m_.w * cx_list_at(tier_wide(), k_))), .y = (m_.apex_y + (m_.foliage * cx_list_at(tier_bot(), k_))) }) }); break :b0 push_poly(color, tri); };
}

fn cone_ring(r0: f64, f0: f64, rad: f64, h_base: f64, cf: f64, view_w: f64, i_: i64, a_: f64) *CxList(ScreenPt) {
    return (if ((i_ >= ring_n())) cx_ll_empty(ScreenPt) else b1: { const p_ = cx_new(Vec3S{ .right = (r0 + (rad * r_cos(a_))), .forward = (f0 + (rad * r_sin(a_))), .height = h_base }); break :b1 cx_ll_concat(cx_ll_of(ScreenPt, &[_]ScreenPt{ project(p_, cf, view_w) }), cone_ring(r0, f0, rad, h_base, cf, view_w, (i_ +% 1), (a_ + (two_pi() / @as(f64, @bitCast(@as(i64, 4625196817309499392))))))); });
}

fn less_xy(a_: ScreenPt, b_: ScreenPt) bool {
    return (if ((a_.x < b_.x)) true else (if ((a_.x == b_.x)) (a_.y < b_.y) else false));
}

fn hull_insert(p_: ScreenPt, xs: *CxList(ScreenPt), i_: i64) *CxList(ScreenPt) {
    var _tl_i = i_;
    while (true) {
        if ((_tl_i >= cx_list_len(xs))) { return cx_ll_concat(xs, cx_ll_of(ScreenPt, &[_]ScreenPt{ p_ })); } else { if (less_xy(p_, cx_list_at(xs, _tl_i))) { return cx_ll_concat(cx_ll_concat(list_take(ScreenPt, xs, _tl_i), cx_ll_of(ScreenPt, &[_]ScreenPt{ p_ })), list_drop(ScreenPt, xs, _tl_i)); } else { { const _tj2_2 = (_tl_i +% 1); _tl_i = _tj2_2; continue; } } }
    }
}

fn sort_pts(src: *CxList(ScreenPt), i_: i64, acc_: *CxList(ScreenPt)) *CxList(ScreenPt) {
    var _tl_i = i_;
    var _tl_acc = acc_;
    while (true) {
        if ((_tl_i >= cx_list_len(src))) { return _tl_acc; } else { { const _tj1_1 = (_tl_i +% 1); const _tj1_2 = hull_insert(cx_list_at(src, _tl_i), _tl_acc, 0); _tl_i = _tj1_1; _tl_acc = _tj1_2; continue; } }
    }
}

fn hull_trim(hull: *CxList(ScreenPt), p_: ScreenPt) *CxList(ScreenPt) {
    var _tl_hull = hull;
    while (true) {
        const n_: i64 = cx_list_len(_tl_hull); if ((n_ < 2)) { return _tl_hull; } else { const a_ = cx_list_at(_tl_hull, (n_ -% 2)); const b_ = cx_list_at(_tl_hull, (n_ -% 1)); const cr: f64 = (((b_.x - a_.x) * (p_.y - a_.y)) - ((b_.y - a_.y) * (p_.x - a_.x))); if ((cr <= @as(f64, @bitCast(@as(i64, 0))))) { { const _tj6_0 = list_take(ScreenPt, _tl_hull, (n_ -% 1)); _tl_hull = _tj6_0; continue; } } else { return _tl_hull; } }
    }
}

fn lower_chain(ps: *CxList(ScreenPt), i_: i64, hull: *CxList(ScreenPt)) *CxList(ScreenPt) {
    var _tl_i = i_;
    var _tl_hull = hull;
    while (true) {
        if ((_tl_i >= cx_list_len(ps))) { return _tl_hull; } else { const p_ = cx_list_at(ps, _tl_i); { const _tj2_1 = (_tl_i +% 1); const _tj2_2 = cx_ll_concat(hull_trim(_tl_hull, p_), cx_ll_of(ScreenPt, &[_]ScreenPt{ p_ })); _tl_i = _tj2_1; _tl_hull = _tj2_2; continue; } }
    }
}

fn upper_chain(ps: *CxList(ScreenPt), i_: i64, hull: *CxList(ScreenPt)) *CxList(ScreenPt) {
    var _tl_i = i_;
    var _tl_hull = hull;
    while (true) {
        if ((_tl_i < 0)) { return _tl_hull; } else { const p_ = cx_list_at(ps, _tl_i); { const _tj2_1 = (_tl_i -% 1); const _tj2_2 = cx_ll_concat(hull_trim(_tl_hull, p_), cx_ll_of(ScreenPt, &[_]ScreenPt{ p_ })); _tl_i = _tj2_1; _tl_hull = _tj2_2; continue; } }
    }
}

fn convex_hull_pts(ps: *CxList(ScreenPt)) *CxList(ScreenPt) {
    return b0: { const n_: i64 = cx_list_len(ps); break :b0 (if ((n_ < 3)) ps else b2: { const sorted = sort_pts(ps, 0, cx_ll_empty(ScreenPt)); break :b2 b3: { const lo = lower_chain(sorted, 0, cx_ll_empty(ScreenPt)); break :b3 b4: { const up = upper_chain(sorted, (n_ -% 1), cx_ll_empty(ScreenPt)); break :b4 cx_ll_concat(list_take(ScreenPt, lo, (cx_list_len(lo) -% 1)), list_take(ScreenPt, up, (cx_list_len(up) -% 1))); }; }; }); };
}

fn tier_cone(r0: f64, f0: f64, height: f64, color: i64, cf: f64, view_w: f64, m_: Metrics, k_: i64, shade: f64) *CxList(DrawCmd) {
    return b0: { const rad: f64 = ((crown_w() * cx_list_at(tier_wide(), k_)) * height); break :b0 (if (((f0 - rad) < min_cone_forward())) tier_triangle(m_, k_, color) else b2: { const h_base: f64 = ((visible_trunk() + (crown_h() * (@as(f64, @bitCast(@as(i64, 4607182418800017408))) - cx_list_at(tier_bot(), k_)))) * height); break :b2 b3: { const h_apex: f64 = ((visible_trunk() + (crown_h() * (@as(f64, @bitCast(@as(i64, 4607182418800017408))) - cx_list_at(tier_top(), k_)))) * height); break :b3 b4: { const apex = project(cx_new(Vec3S{ .right = r0, .forward = f0, .height = h_apex }), cf, view_w); break :b4 b5: { const ring = cx_ll_concat(cone_ring(r0, f0, rad, h_base, cf, view_w, 0, @as(f64, @bitCast(@as(i64, 0)))), cx_ll_of(ScreenPt, &[_]ScreenPt{ apex })); break :b5 b6: { const hull = convex_hull_pts(ring); break :b6 (if ((cx_list_len(hull) < 3)) cx_ll_empty(DrawCmd) else push_round_poly(color, shade, hull)); }; }; }; }; }); };
}

fn tiers(r0: f64, f0: f64, height: f64, color: i64, cf: f64, view_w: f64, m_: Metrics, near_crown: bool, shade: f64, k_: i64) *CxList(DrawCmd) {
    return (if ((k_ >= 8)) cx_ll_empty(DrawCmd) else b1: { const one = (if (near_crown) tier_cone(r0, f0, height, color, cf, view_w, m_, k_, shade) else tier_triangle(m_, k_, color)); break :b1 cx_ll_concat(one, tiers(r0, f0, height, color, cf, view_w, m_, near_crown, shade, (k_ +% 1))); });
}

fn tree_draw(right: f64, forward: f64, height: f64, color: i64, cf: f64, view_w: f64, round_trunk: bool, near_crown: bool, shade: f64) *CxList(DrawCmd) {
    return b0: { const m_ = metrics(right, forward, height, cf, view_w); break :b0 (if ((m_.ht < @as(f64, @bitCast(@as(i64, 4607182418800017408))))) cx_ll_empty(DrawCmd) else cx_ll_concat(draw_trunk(m_, round_trunk), tiers(right, forward, height, color, cf, view_w, m_, near_crown, shade, 0))); };
}

fn water_outline() *CxList(PondPt) {
    return cx_ll_of(PondPt, &[_]PondPt{ cx_new(PondPtS{ .cu = (-@as(f64, @bitCast(@as(i64, 4611686018427387904)))), .cv = @as(f64, @bitCast(@as(i64, 4613937818241073152))) }), cx_new(PondPtS{ .cu = (-@as(f64, @bitCast(@as(i64, 4628574517030027264)))), .cv = @as(f64, @bitCast(@as(i64, 4613937818241073152))) }), cx_new(PondPtS{ .cu = (-@as(f64, @bitCast(@as(i64, 4629418941960159232)))), .cv = @as(f64, @bitCast(@as(i64, 4624070917402656768))) }), cx_new(PondPtS{ .cu = (-@as(f64, @bitCast(@as(i64, 4628011567076605952)))), .cv = @as(f64, @bitCast(@as(i64, 4628574517030027264))) }), cx_new(PondPtS{ .cu = (-@as(f64, @bitCast(@as(i64, 4624633867356078080)))), .cv = @as(f64, @bitCast(@as(i64, 4629700416936869888))) }), cx_new(PondPtS{ .cu = (-@as(f64, @bitCast(@as(i64, 4617315517961601024)))), .cv = @as(f64, @bitCast(@as(i64, 4628855992006737920))) }), cx_new(PondPtS{ .cu = (-@as(f64, @bitCast(@as(i64, 4607182418800017408)))), .cv = @as(f64, @bitCast(@as(i64, 4625196817309499392))) }) });
}

fn water_color() i64 {
    return 3112588;
}

fn bank() *CxList(PondPt) {
    return cx_ll_of(PondPt, &[_]PondPt{ cx_new(PondPtS{ .cu = (-@as(f64, @bitCast(@as(i64, 4617315517961601024)))), .cv = @as(f64, @bitCast(@as(i64, 4628855992006737920))) }), cx_new(PondPtS{ .cu = (-@as(f64, @bitCast(@as(i64, 4624633867356078080)))), .cv = @as(f64, @bitCast(@as(i64, 4629700416936869888))) }), cx_new(PondPtS{ .cu = (-@as(f64, @bitCast(@as(i64, 4628011567076605952)))), .cv = @as(f64, @bitCast(@as(i64, 4628574517030027264))) }), cx_new(PondPtS{ .cu = (-@as(f64, @bitCast(@as(i64, 4628011567076605952)))), .cv = @as(f64, @bitCast(@as(i64, 4628855992006737920))) }), cx_new(PondPtS{ .cu = (-@as(f64, @bitCast(@as(i64, 4624633867356078080)))), .cv = @as(f64, @bitCast(@as(i64, 4629841154425225216))) }), cx_new(PondPtS{ .cu = (-@as(f64, @bitCast(@as(i64, 4617315517961601024)))), .cv = @as(f64, @bitCast(@as(i64, 4629137466983448576))) }) });
}

fn bank_color() i64 {
    return 12759680;
}

fn rail_height() f64 {
    return @as(f64, @bitCast(@as(i64, 4602678819172646912)));
}

fn rail_thickness() f64 {
    return @as(f64, @bitCast(@as(i64, 4591870180066957722)));
}

fn rail_post_width() f64 {
    return @as(f64, @bitCast(@as(i64, 4581421828931458171)));
}

fn rail_metal() i64 {
    return 12765135;
}

fn rail_post_metal() i64 {
    return 10133672;
}

fn max_rail_polys() i64 {
    return 3072;
}

fn bar_top() f64 {
    return (rail_height() + (rail_thickness() / @as(f64, @bitCast(@as(i64, 4611686018427387904)))));
}

fn bar_bot() f64 {
    return (rail_height() - (rail_thickness() / @as(f64, @bitCast(@as(i64, 4611686018427387904)))));
}

fn half_post() f64 {
    return (rail_post_width() / @as(f64, @bitCast(@as(i64, 4611686018427387904))));
}

fn rail_poly(p0: Vec3, p1: Vec3, p2: Vec3, p3: Vec3, color: i64) RailPoly {
    return b0: { const fwd: f64 = ((((p0.forward + p1.forward) + p2.forward) + p3.forward) / @as(f64, @bitCast(@as(i64, 4616189618054758400)))); break :b0 cx_new(RailPolyS{ .v_ = cx_ll_of(Vec3, &[_]Vec3{ p0, p1, p2, p3 }), .color = color, .fwd = fwd }); };
}

fn bar_quad(p_: RiderPt, q: RiderPt) RailPoly {
    return b0: { const p_bot = cx_new(Vec3S{ .right = p_.right, .forward = p_.forward, .height = bar_bot() }); break :b0 b1: { const q_bot = cx_new(Vec3S{ .right = q.right, .forward = q.forward, .height = bar_bot() }); break :b1 b2: { const q_top = cx_new(Vec3S{ .right = q.right, .forward = q.forward, .height = bar_top() }); break :b2 b3: { const p_top = cx_new(Vec3S{ .right = p_.right, .forward = p_.forward, .height = bar_top() }); break :b3 rail_poly(p_bot, q_bot, q_top, p_top, rail_metal()); }; }; }; };
}

fn bars(path_: *CxList(RiderPt), i_: i64) *CxList(RailPoly) {
    return (if (((i_ +% 1) >= cx_list_len(path_))) cx_ll_empty(RailPoly) else cx_ll_concat(cx_ll_of(RailPoly, &[_]RailPoly{ bar_quad(cx_list_at(path_, i_), cx_list_at(path_, (i_ +% 1))) }), bars(path_, (i_ +% 1))));
}

fn post_box(p_: RiderPt, ox: f64, ofwd: f64) RailPoly {
    return b0: { const back_foot = cx_new(Vec3S{ .right = (p_.right - ox), .forward = (p_.forward - ofwd), .height = @as(f64, @bitCast(@as(i64, 0))) }); break :b0 b1: { const fore_foot = cx_new(Vec3S{ .right = (p_.right + ox), .forward = (p_.forward + ofwd), .height = @as(f64, @bitCast(@as(i64, 0))) }); break :b1 b2: { const fore_head = cx_new(Vec3S{ .right = (p_.right + ox), .forward = (p_.forward + ofwd), .height = bar_top() }); break :b2 b3: { const back_head = cx_new(Vec3S{ .right = (p_.right - ox), .forward = (p_.forward - ofwd), .height = bar_top() }); break :b3 rail_poly(back_foot, fore_foot, fore_head, back_head, rail_post_metal()); }; }; }; };
}

fn post_quad(path_: *CxList(RiderPt), i_: i64) RailPoly {
    return b0: { const n_: i64 = cx_list_len(path_); break :b0 b1: { const ia: i64 = @as(i64, (if ((i_ == 0)) 0 else (i_ -% 1))); break :b1 b2: { const ib: i64 = (if (((i_ +% 1) >= n_)) (n_ -% 1) else (i_ +% 1)); break :b2 b3: { const a_ = cx_list_at(path_, ia); break :b3 b4: { const b_ = cx_list_at(path_, ib); break :b4 b5: { const dr: f64 = (b_.right - a_.right); break :b5 b6: { const df: f64 = (b_.forward - a_.forward); break :b6 b7: { const raw_: f64 = real_sqrt(((dr * dr) + (df * df))); break :b7 b8: { const run: f64 = @as(f64, (if ((raw_ == @as(f64, @bitCast(@as(i64, 0))))) @as(f64, @bitCast(@as(i64, 4607182418800017408))) else raw_)); break :b8 b9: { const ox: f64 = ((dr / run) * half_post()); break :b9 b10: { const ofwd: f64 = ((df / run) * half_post()); break :b10 post_box(cx_list_at(path_, i_), ox, ofwd); }; }; }; }; }; }; }; }; }; }; };
}

fn posts(path_: *CxList(RiderPt), i_: i64) *CxList(RailPoly) {
    return (if ((i_ >= cx_list_len(path_))) cx_ll_empty(RailPoly) else cx_ll_concat(cx_ll_of(RailPoly, &[_]RailPoly{ post_quad(path_, i_) }), posts(path_, (i_ +% 1))));
}

fn rail_emit(path_: *CxList(RiderPt)) *CxList(RailPoly) {
    return (if ((cx_list_len(path_) < 2)) cx_ll_empty(RailPoly) else list_take(RailPoly, cx_ll_concat(bars(path_, 0), posts(path_, 0)), max_rail_polys()));
}

fn project_all(ps: *CxList(Vec3), cf: f64, view_w: f64, i_: i64) *CxList(ScreenPt) {
    return (if ((i_ >= cx_list_len(ps))) cx_ll_empty(ScreenPt) else cx_ll_concat(cx_ll_of(ScreenPt, &[_]ScreenPt{ project(cx_list_at(ps, i_), cf, view_w) }), project_all(ps, cf, view_w, (i_ +% 1))));
}

fn rail_draw_poly(rp: RailPoly, cf: f64, view_w: f64) *CxList(DrawCmd) {
    return b0: { const clipped = clip_near(rp.v_, near()); break :b0 (if ((cx_list_len(clipped) < 3)) cx_ll_empty(DrawCmd) else push_poly(rp.color, project_all(clipped, cf, view_w, 0))); };
}

fn rail_draw_all(ps: *CxList(RailPoly), cf: f64, view_w: f64, i_: i64) *CxList(DrawCmd) {
    return (if ((i_ >= cx_list_len(ps))) cx_ll_empty(DrawCmd) else cx_ll_concat(rail_draw_poly(cx_list_at(ps, i_), cf, view_w), rail_draw_all(ps, cf, view_w, (i_ +% 1))));
}

fn sun_bearing() f64 {
    return (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4612176010066845814))));
}

fn sun_radius_px() f64 {
    return @as(f64, @bitCast(@as(i64, 4631670741773844480)));
}

fn sun_start_px() f64 {
    return @as(f64, @bitCast(@as(i64, 4642789003353915392)));
}

fn sun_drop_px_per_step() f64 {
    return ((@as(f64, @bitCast(@as(i64, 4601168492001611942))) * (@as(f64, @bitCast(@as(i64, 4611686018427387904))) * sun_radius_px())) / @as(f64, @bitCast(@as(i64, 4648708773957861376))));
}

fn sun_fully_set_px() f64 {
    return (@as(f64, @bitCast(@as(i64, 0))) - sun_radius_px());
}

fn warmth_falloff_px() f64 {
    return @as(f64, @bitCast(@as(i64, 4637440978796412928)));
}

fn visible_bearing_limit() f64 {
    return @as(f64, @bitCast(@as(i64, 4608983858650965606)));
}

fn sun_height_px(step: f64) f64 {
    return (sun_start_px() - (sun_drop_px_per_step() * step));
}

fn dusk_at_set() f64 {
    return ((@as(f64, @bitCast(@as(i64, 4602678819172646912))) * (sun_start_px() - sun_fully_set_px())) / sun_start_px());
}

fn dusk_while_up(h_: f64) f64 {
    return b0: { const p_: f64 = ((sun_start_px() - h_) / (sun_start_px() - sun_fully_set_px())); break :b0 real_max(@as(f64, @bitCast(@as(i64, 0))), ((dusk_at_set() * p_) * p_)); };
}

fn sun_set_fraction(step: f64) f64 {
    return b0: { const h_: f64 = sun_height_px(step); break :b0 (if ((h_ >= sun_fully_set_px())) dusk_while_up(h_) else real_min(@as(f64, @bitCast(@as(i64, 4607182418800017408))), (dusk_at_set() + (((sun_fully_set_px() - h_) / sun_radius_px()) * (@as(f64, @bitCast(@as(i64, 4607182418800017408))) - dusk_at_set()))))); };
}

fn day_sky() Rgb {
    return cx_new(RgbS{ .r_ = @as(f64, @bitCast(@as(i64, 4639200197400854528))), .g = @as(f64, @bitCast(@as(i64, 4641311259726184448))), .b_ = @as(f64, @bitCast(@as(i64, 4642296422144671744))) });
}

fn dusk_sky() Rgb {
    return cx_new(RgbS{ .r_ = @as(f64, @bitCast(@as(i64, 4630263366890291200))), .g = @as(f64, @bitCast(@as(i64, 4633359591634108416))), .b_ = @as(f64, @bitCast(@as(i64, 4636315078889570304))) });
}

fn sunset_red() Rgb {
    return cx_new(RgbS{ .r_ = @as(f64, @bitCast(@as(i64, 4642014947167961088))), .g = @as(f64, @bitCast(@as(i64, 4635892866424504320))), .b_ = @as(f64, @bitCast(@as(i64, 4632515166703976448))) });
}

fn sunset_glow() f64 {
    return @as(f64, @bitCast(@as(i64, 4605831338911806259)));
}

fn lerp3(a_: Rgb, b_: Rgb, t: f64) Rgb {
    return cx_new(RgbS{ .r_ = round_real((a_.r_ + ((b_.r_ - a_.r_) * t))), .g = round_real((a_.g + ((b_.g - a_.g) * t))), .b_ = round_real((a_.b_ + ((b_.b_ - a_.b_) * t))) });
}

fn pack(c_: Rgb) i64 {
    return ((cx_shl(cx_real_to_int(c_.r_), 16) | cx_shl(cx_real_to_int(c_.g), 8)) | cx_real_to_int(c_.b_));
}

fn sky_color(step: f64) i64 {
    return pack(lerp3(day_sky(), dusk_sky(), sun_set_fraction(step)));
}

fn horizon_color(step: f64) i64 {
    return b0: { const sky = lerp3(day_sky(), dusk_sky(), sun_set_fraction(step)); break :b0 pack(lerp3(sky, sunset_red(), (real_max(@as(f64, @bitCast(@as(i64, 0))), (@as(f64, @bitCast(@as(i64, 4607182418800017408))) - (real_abs(sun_height_px(step)) / warmth_falloff_px()))) * sunset_glow()))); };
}

fn sun_pos_visible(rel: f64, step: f64, _arg_cam_focal: f64, view_w: f64) SunPos {
    return b0: { const v_scale: f64 = (_arg_cam_focal / focal()); break :b0 cx_new(SunPosS{ .visible = true, .x = ((view_w / @as(f64, @bitCast(@as(i64, 4611686018427387904)))) + (r_tan(rel) * _arg_cam_focal)), .y = ((camera_h() / @as(f64, @bitCast(@as(i64, 4611686018427387904)))) - (sun_height_px(step) * v_scale)), .scale = v_scale }); };
}

fn sun_pos(heading: f64, step: f64, _arg_cam_focal: f64, view_w: f64) SunPos {
    return b0: { const rel: f64 = wrap((sun_bearing() - heading), 64); break :b0 (if ((real_abs(rel) >= visible_bearing_limit())) cx_new(SunPosS{ .visible = false, .x = @as(f64, @bitCast(@as(i64, 0))), .y = @as(f64, @bitCast(@as(i64, 0))), .scale = @as(f64, @bitCast(@as(i64, 0))) }) else sun_pos_visible(rel, step, _arg_cam_focal, view_w)); };
}

fn rock() i64 {
    return 5991055;
}

fn rock_west() i64 {
    return 3752799;
}

fn land() i64 {
    return 4886339;
}

fn rock_night_dim() f64 {
    return @as(f64, @bitCast(@as(i64, 4602678819172646912)));
}

fn snow_day() Rgb {
    return cx_new(RgbS{ .r_ = @as(f64, @bitCast(@as(i64, 4642577897121382400))), .g = @as(f64, @bitCast(@as(i64, 4642753818981826560))), .b_ = @as(f64, @bitCast(@as(i64, 4642929740842270720))) });
}

fn snow_night() Rgb {
    return cx_new(RgbS{ .r_ = @as(f64, @bitCast(@as(i64, 4634626229029306368))), .g = @as(f64, @bitCast(@as(i64, 4635611391447793664))), .b_ = @as(f64, @bitCast(@as(i64, 4637018766331346944))) });
}

fn chan(color: i64, sh: i64) f64 {
    return cx_real_from_int((cx_shr(color, sh) & 255));
}

fn dimmed(color: i64, dusk: f64) i64 {
    return b0: { const f: f64 = (@as(f64, @bitCast(@as(i64, 4607182418800017408))) - (rock_night_dim() * dusk)); break :b0 b1: { const r_: i64 = cx_real_to_int(round_real((chan(color, 16) * f))); break :b1 b2: { const g: i64 = cx_real_to_int(round_real((chan(color, 8) * f))); break :b2 b3: { const b_: i64 = cx_real_to_int(round_real((chan(color, 0) * f))); break :b3 ((cx_shl(r_, 16) | cx_shl(g, 8)) | b_); }; }; }; };
}

fn west_range_bearing() f64 {
    return (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4611779693299637210))));
}

fn snow_threshold() f64 {
    return @as(f64, @bitCast(@as(i64, 4638426141214900224)));
}

fn snow_dip() f64 {
    return @as(f64, @bitCast(@as(i64, 4621819117588971520)));
}

fn col_step() f64 {
    return @as(f64, @bitCast(@as(i64, 4611686018427387904)));
}

fn roll_margin() f64 {
    return @as(f64, @bitCast(@as(i64, 4641240890982006784)));
}

fn range_at(bearing: f64, center: f64, half: f64, peak: f64, freq_a: f64, freq_b: f64) f64 {
    return b0: { const b_: f64 = wrap((bearing - center), 64); break :b0 b1: { const t: f64 = (b_ / half); break :b1 @as(f64, (if ((real_abs(t) >= @as(f64, @bitCast(@as(i64, 4607182418800017408))))) @as(f64, @bitCast(@as(i64, 0))) else range_body(b_, t, peak, freq_a, freq_b))); }; };
}

fn range_body(b_: f64, t: f64, peak: f64, freq_a: f64, freq_b: f64) f64 {
    return b0: { const envelope: f64 = r_cos(((t * pi()) / @as(f64, @bitCast(@as(i64, 4611686018427387904))))); break :b0 b1: { const ridge: f64 = ((@as(f64, @bitCast(@as(i64, 4603579539098121011))) + (@as(f64, @bitCast(@as(i64, 4597814931575086776))) * r_cos((b_ * freq_a)))) + (@as(f64, @bitCast(@as(i64, 4594932627813569659))) * r_cos(((b_ * freq_b) + @as(f64, @bitCast(@as(i64, 4607182418800017408))))))); break :b1 ((peak * envelope) * ridge); }; };
}

fn ground_base(bearing: f64) f64 {
    return (@as(f64, @bitCast(@as(i64, 4625759767262920704))) + (@as(f64, @bitCast(@as(i64, 4622945017495814144))) * r_sin(((wrap(bearing, 64) * @as(f64, @bitCast(@as(i64, 4606281698874543309)))) + @as(f64, @bitCast(@as(i64, 4611235658464650854)))))));
}

fn north_range(bearing: f64) f64 {
    return range_at(bearing, @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4606732058837280358))), @as(f64, @bitCast(@as(i64, 4639481672377565184))), @as(f64, @bitCast(@as(i64, 4620693217682128896))), @as(f64, @bitCast(@as(i64, 4626604192193052672))));
}

fn west_range(bearing: f64) f64 {
    return range_at(bearing, west_range_bearing(), @as(f64, @bitCast(@as(i64, 4604660403008689930))), @as(f64, @bitCast(@as(i64, 4638144666238189568))), @as(f64, @bitCast(@as(i64, 4622382067542392832))), @as(f64, @bitCast(@as(i64, 4628293042053316608))));
}

fn snow_peak_loop(b_: f64, vm: f64) f64 {
    var _tl_b = b_;
    var _tl_vm = vm;
    while (true) {
        if ((_tl_b > @as(f64, @bitCast(@as(i64, 4602678819172646912))))) { return _tl_vm; } else { { const _tj1_0 = (_tl_b + @as(f64, @bitCast(@as(i64, 4576918229304087675)))); const _tj1_1 = real_max(_tl_vm, north_range(_tl_b)); _tl_b = _tj1_0; _tl_vm = _tj1_1; continue; } }
    }
}

fn snow_peak_height() f64 {
    return snow_peak_loop((@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4602678819172646912)))), (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4607182418800017408)))));
}

fn snowline_at(bearing: f64, peak: f64) f64 {
    return b0: { const num: f64 = (north_range(bearing) - snow_threshold()); break :b0 b1: { const above_frac: f64 = real_max(@as(f64, @bitCast(@as(i64, 0))), real_min(@as(f64, @bitCast(@as(i64, 4607182418800017408))), (num / (peak - snow_threshold())))); break :b1 (snow_threshold() - (snow_dip() * above_frac)); }; };
}

fn bearing_at(x: f64, heading: f64, _arg_cam_focal: f64, view_w: f64) f64 {
    return (heading + r_atan(((x - (view_w / @as(f64, @bitCast(@as(i64, 4611686018427387904))))) / _arg_cam_focal)));
}

fn crest_pts(f: CxFn1(f64, f64), heading: f64, _arg_cam_focal: f64, view_w: f64, v_scale: f64, x: f64) *CxList(ScreenPt) {
    return (if ((x > (view_w + roll_margin()))) cx_ll_empty(ScreenPt) else cx_ll_concat(cx_ll_of(ScreenPt, &[_]ScreenPt{ cx_new(ScreenPtS{ .x = x, .y = ((camera_h() / @as(f64, @bitCast(@as(i64, 4611686018427387904)))) - (f.call(f.ctx, bearing_at(x, heading, _arg_cam_focal, view_w)) * v_scale)) }) }), crest_pts(f, heading, _arg_cam_focal, view_w, v_scale, (x + col_step()))));
}

fn silhouette(f: CxFn1(f64, f64), heading: f64, _arg_cam_focal: f64, view_w: f64, v_scale: f64, color: i64) *CxList(DrawCmd) {
    return b0: { const top_ = crest_pts(f, heading, _arg_cam_focal, view_w, v_scale, (@as(f64, @bitCast(@as(i64, 0))) - roll_margin())); break :b0 b1: { const close = cx_ll_of(ScreenPt, &[_]ScreenPt{ cx_new(ScreenPtS{ .x = (view_w + roll_margin()), .y = (camera_h() / @as(f64, @bitCast(@as(i64, 4611686018427387904)))) }), cx_new(ScreenPtS{ .x = (@as(f64, @bitCast(@as(i64, 0))) - roll_margin()), .y = (camera_h() / @as(f64, @bitCast(@as(i64, 4611686018427387904)))) }) }); break :b1 push_poly(color, cx_ll_concat(top_, close)); }; };
}

fn snow_columns(heading: f64, _arg_cam_focal: f64, view_w: f64, peak: f64, x: f64) *CxList(f64) {
    return (if ((x > view_w)) cx_ll_empty(f64) else snow_columns_at(heading, _arg_cam_focal, view_w, peak, x));
}

fn snow_columns_at(heading: f64, _arg_cam_focal: f64, view_w: f64, peak: f64, x: f64) *CxList(f64) {
    return b0: { const b_: f64 = bearing_at(x, heading, _arg_cam_focal, view_w); break :b0 b1: { const rest = snow_columns(heading, _arg_cam_focal, view_w, peak, (x + col_step())); break :b1 (if ((north_range(b_) > (snowline_at(b_, peak) + @as(f64, @bitCast(@as(i64, 4576918229304087675)))))) cx_ll_concat(cx_ll_of(f64, &[_]f64{ x }), rest) else rest); }; };
}

fn snow_top(xs: *CxList(f64), heading: f64, _arg_cam_focal: f64, view_w: f64, v_scale: f64, i_: i64) *CxList(ScreenPt) {
    return (if ((i_ >= cx_list_len(xs))) cx_ll_empty(ScreenPt) else cx_ll_concat(cx_ll_of(ScreenPt, &[_]ScreenPt{ cx_new(ScreenPtS{ .x = cx_list_at(xs, i_), .y = ((camera_h() / @as(f64, @bitCast(@as(i64, 4611686018427387904)))) - (north_range(bearing_at(cx_list_at(xs, i_), heading, _arg_cam_focal, view_w)) * v_scale)) }) }), snow_top(xs, heading, _arg_cam_focal, view_w, v_scale, (i_ +% 1))));
}

fn snow_bottom(xs: *CxList(f64), heading: f64, _arg_cam_focal: f64, view_w: f64, v_scale: f64, peak: f64, i_: i64) *CxList(ScreenPt) {
    return (if ((i_ < 0)) cx_ll_empty(ScreenPt) else cx_ll_concat(cx_ll_of(ScreenPt, &[_]ScreenPt{ cx_new(ScreenPtS{ .x = cx_list_at(xs, i_), .y = ((camera_h() / @as(f64, @bitCast(@as(i64, 4611686018427387904)))) - (snowline_at(bearing_at(cx_list_at(xs, i_), heading, _arg_cam_focal, view_w), peak) * v_scale)) }) }), snow_bottom(xs, heading, _arg_cam_focal, view_w, v_scale, peak, (i_ -% 1))));
}

fn draw_snow(heading: f64, _arg_cam_focal: f64, view_w: f64, v_scale: f64, snow: i64) *CxList(DrawCmd) {
    return b0: { const peak: f64 = snow_peak_height(); break :b0 b1: { const xs = snow_columns(heading, _arg_cam_focal, view_w, peak, @as(f64, @bitCast(@as(i64, 0)))); break :b1 (if ((cx_list_len(xs) < 2)) cx_ll_empty(DrawCmd) else push_poly(snow, cx_ll_concat(snow_top(xs, heading, _arg_cam_focal, view_w, v_scale, 0), snow_bottom(xs, heading, _arg_cam_focal, view_w, v_scale, peak, (cx_list_len(xs) -% 1))))); }; };
}

fn draw(heading: f64, dusk: f64, _arg_cam_focal: f64, view_w: f64) *CxList(DrawCmd) {
    return b0: { const v_scale: f64 = (_arg_cam_focal / focal()); break :b0 b1: { const west = silhouette(b3: { const _Env3 = struct { fn call(_ctx3: *anyopaque, p0: f64) f64 { _ = _ctx3; return west_range(p0); } }; break :b3 CxFn1(f64, f64){ .ctx = cx_new(_Env3{  }), .call = &_Env3.call }; }, heading, _arg_cam_focal, view_w, v_scale, dimmed(rock_west(), dusk)); break :b1 b2: { const north = silhouette(b4: { const _Env4 = struct { fn call(_ctx4: *anyopaque, p0: f64) f64 { _ = _ctx4; return north_range(p0); } }; break :b4 CxFn1(f64, f64){ .ctx = cx_new(_Env4{  }), .call = &_Env4.call }; }, heading, _arg_cam_focal, view_w, v_scale, dimmed(rock(), dusk)); break :b2 b3: { const cap = draw_snow(heading, _arg_cam_focal, view_w, v_scale, pack(lerp3(snow_day(), snow_night(), dusk))); break :b3 b4: { const ground = silhouette(b6: { const _Env6 = struct { fn call(_ctx6: *anyopaque, p0: f64) f64 { _ = _ctx6; return ground_base(p0); } }; break :b6 CxFn1(f64, f64){ .ctx = cx_new(_Env6{  }), .call = &_Env6.call }; }, heading, _arg_cam_focal, view_w, v_scale, land()); break :b4 cx_ll_concat(cx_ll_concat(cx_ll_concat(west, north), cap), ground); }; }; }; }; };
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
    return b0: { const dx: f64 = (b_.x - a_.x); break :b0 b1: { const dy: f64 = (b_.y - a_.y); break :b1 b2: { const raw_: f64 = real_sqrt(((dx * dx) + (dy * dy))); break :b2 b3: { const len_: f64 = @as(f64, (if ((raw_ < @as(f64, @bitCast(@as(i64, 4547007122018943789))))) @as(f64, @bitCast(@as(i64, 4607182418800017408))) else raw_)); break :b3 rod_quad(a_, b_, ((((@as(f64, @bitCast(@as(i64, 0))) - dy) / len_) * wpx) / @as(f64, @bitCast(@as(i64, 4611686018427387904)))), (((dx / len_) * wpx) / @as(f64, @bitCast(@as(i64, 4611686018427387904))))); }; }; }; };
}

fn rod_quad(a_: ScreenPt, b_: ScreenPt, ox: f64, oy: f64) *CxList(DrawCmd) {
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
    return b0: { const lo: f64 = (cx_real_from_int(stage) * stage_height()); break :b0 b1: { const hi: f64 = (lo + stage_height()); break :b1 b2: { const rest = braces(base_, center, clip_h, drop, wpx, cf, view_w, (stage +% 1)); break :b2 (if ((hi <= clip_h)) rest else cx_ll_concat(brace_at(base_, center, lo, hi, ((real_max(lo, clip_h) - lo) / stage_height()), drop, wpx, cf, view_w, 0), rest)); }; }; };
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

fn to_screen(ps: *CxList(Vec3), i_: i64) *CxList(ScreenPt) {
    return (if ((i_ >= cx_list_len(ps))) cx_ll_empty(ScreenPt) else cx_ll_concat(cx_ll_of(ScreenPt, &[_]ScreenPt{ project(cx_list_at(ps, i_), focal(), camera_w()) }), to_screen(ps, (i_ +% 1))));
}

fn solid(color: i64, ps: *CxList(Vec3)) *CxList(DrawCmd) {
    return push_poly(color, to_screen(ps, 0));
}

fn road_half() f64 {
    return @as(f64, @bitCast(@as(i64, 4616189618054758400)));
}

fn road_near() f64 {
    return @as(f64, @bitCast(@as(i64, 4613937818241073152)));
}

fn road_far() f64 {
    return @as(f64, @bitCast(@as(i64, 4645744490609377280)));
}

fn road() *CxList(DrawCmd) {
    return solid(3815994, cx_ll_of(Vec3, &[_]Vec3{ cx_new(Vec3S{ .right = (@as(f64, @bitCast(@as(i64, 0))) - road_half()), .forward = road_near(), .height = @as(f64, @bitCast(@as(i64, 0))) }), cx_new(Vec3S{ .right = road_half(), .forward = road_near(), .height = @as(f64, @bitCast(@as(i64, 0))) }), cx_new(Vec3S{ .right = road_half(), .forward = road_far(), .height = @as(f64, @bitCast(@as(i64, 0))) }), cx_new(Vec3S{ .right = (@as(f64, @bitCast(@as(i64, 0))) - road_half()), .forward = road_far(), .height = @as(f64, @bitCast(@as(i64, 0))) }) }));
}

fn dashes(a_: f64, fuel: i64) *CxList(DrawCmd) {
    return (if ((fuel <= 0)) cx_ll_empty(DrawCmd) else cx_ll_concat(solid(14211744, cx_ll_of(Vec3, &[_]Vec3{ cx_new(Vec3S{ .right = (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4595653203753948938)))), .forward = a_, .height = @as(f64, @bitCast(@as(i64, 0))) }), cx_new(Vec3S{ .right = @as(f64, @bitCast(@as(i64, 4595653203753948938))), .forward = a_, .height = @as(f64, @bitCast(@as(i64, 0))) }), cx_new(Vec3S{ .right = @as(f64, @bitCast(@as(i64, 4595653203753948938))), .forward = (a_ + @as(f64, @bitCast(@as(i64, 4617315517961601024)))), .height = @as(f64, @bitCast(@as(i64, 0))) }), cx_new(Vec3S{ .right = (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4595653203753948938)))), .forward = (a_ + @as(f64, @bitCast(@as(i64, 4617315517961601024)))), .height = @as(f64, @bitCast(@as(i64, 0))) }) })), dashes((a_ + @as(f64, @bitCast(@as(i64, 4624070917402656768)))), (fuel -% 1))));
}

fn scene_heading_at(u_: f64) f64 {
    return ((@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4612811918334230528)))) + (@as(f64, @bitCast(@as(i64, 4614162998222441677))) * u_));
}

fn scene_step_at(u_: f64) f64 {
    return (@as(f64, @bitCast(@as(i64, 4660134898793709568))) + (@as(f64, @bitCast(@as(i64, 4653872080561897472))) * u_));
}

fn u_per_step() f64 {
    return (@as(f64, @bitCast(@as(i64, 4607182418800017408))) / @as(f64, @bitCast(@as(i64, 4651127699538968576))));
}

fn backdrop_at(heading: f64, step: f64) *CxList(DrawCmd) {
    return draw(heading, sun_set_fraction(step), focal(), camera_w());
}

fn scene_sun_at(u_: f64) SunPos {
    return sun_pos(scene_heading_at(u_), scene_step_at(u_), focal(), camera_w());
}

fn detail_dist() f64 {
    return @as(f64, @bitCast(@as(i64, 4633641066610819072)));
}

fn crown_shade(forward: f64) f64 {
    return b0: { const s_: f64 = (@as(f64, @bitCast(@as(i64, 4607182418800017408))) - (forward / detail_dist())); break :b0 @as(f64, (if ((s_ < @as(f64, @bitCast(@as(i64, 0))))) @as(f64, @bitCast(@as(i64, 0))) else s_)); };
}

fn conifer(right: f64, forward: f64, height: f64, round_trunk: bool) *CxList(DrawCmd) {
    return tree_draw(right, forward, height, 3108154, focal(), camera_w(), round_trunk, (forward < detail_dist()), crown_shade(forward));
}

fn pond_at_right() f64 {
    return (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4628011567076605952))));
}

fn pond_at_forward() f64 {
    return @as(f64, @bitCast(@as(i64, 4631670741773844480)));
}

fn pond_pts(ps: *CxList(PondPt), i_: i64) *CxList(Vec3) {
    return (if ((i_ >= cx_list_len(ps))) cx_ll_empty(Vec3) else b1: { const p_ = cx_list_at(ps, i_); break :b1 cx_ll_concat(cx_ll_of(Vec3, &[_]Vec3{ cx_new(Vec3S{ .right = (pond_at_right() - p_.cu), .forward = (pond_at_forward() + p_.cv), .height = @as(f64, @bitCast(@as(i64, 0))) }) }), pond_pts(ps, (i_ +% 1))); });
}

fn pond_poly() *CxList(DrawCmd) {
    return solid(water_color(), pond_pts(water_outline(), 0));
}

fn bank_poly() *CxList(DrawCmd) {
    return solid(bank_color(), pond_pts(bank(), 0));
}

fn rail_right() f64 {
    return (road_half() + @as(f64, @bitCast(@as(i64, 4608983858650965606))));
}

fn rail_path(f: f64, fuel: i64) *CxList(RiderPt) {
    return (if ((fuel <= 0)) cx_ll_empty(RiderPt) else cx_ll_concat(cx_ll_of(RiderPt, &[_]RiderPt{ cx_new(RiderPtS{ .right = rail_right(), .forward = f }) }), rail_path((f - @as(f64, @bitCast(@as(i64, 4616189618054758400)))), (fuel -% 1))));
}

fn rail_insert(p_: RailPoly, xs: *CxList(RailPoly), i_: i64) *CxList(RailPoly) {
    var _tl_i = i_;
    while (true) {
        if ((_tl_i >= cx_list_len(xs))) { return cx_ll_concat(xs, cx_ll_of(RailPoly, &[_]RailPoly{ p_ })); } else { if ((p_.fwd > cx_list_at(xs, _tl_i).fwd)) { return cx_ll_concat(cx_ll_concat(list_take(RailPoly, xs, _tl_i), cx_ll_of(RailPoly, &[_]RailPoly{ p_ })), list_drop(RailPoly, xs, _tl_i)); } else { { const _tj2_2 = (_tl_i +% 1); _tl_i = _tj2_2; continue; } } }
    }
}

fn rail_sort(src: *CxList(RailPoly), i_: i64, acc_: *CxList(RailPoly)) *CxList(RailPoly) {
    var _tl_i = i_;
    var _tl_acc = acc_;
    while (true) {
        if ((_tl_i >= cx_list_len(src))) { return _tl_acc; } else { { const _tj1_1 = (_tl_i +% 1); const _tj1_2 = rail_insert(cx_list_at(src, _tl_i), _tl_acc, 0); _tl_i = _tj1_1; _tl_acc = _tj1_2; continue; } }
    }
}

fn rail_cmds() *CxList(DrawCmd) {
    return rail_draw_all(rail_sort(rail_emit(rail_path(@as(f64, @bitCast(@as(i64, 4636455816377925632))), 21)), 0, cx_ll_empty(RailPoly)), focal(), camera_w(), 0);
}

fn tower_forward() f64 {
    return @as(f64, @bitCast(@as(i64, 4643985272004935680)));
}

fn tower_right() f64 {
    return @as(f64, @bitCast(@as(i64, 4628011567076605952)));
}

fn tower_corners(k_: i64) *CxList(RiderPt) {
    return (if ((k_ >= 4)) cx_ll_empty(RiderPt) else tower_corner_one(k_));
}

fn tower_corner_one(k_: i64) *CxList(RiderPt) {
    return b0: { const ax = base_corner_ax(k_, @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4599976659396224614)))); break :b0 cx_ll_concat(cx_ll_of(RiderPt, &[_]RiderPt{ cx_new(RiderPtS{ .right = (tower_right() + ax.x), .forward = (tower_forward() + ax.a_) }) }), tower_corners((k_ +% 1))); };
}

fn frame_at(u_: f64) *CxList(DrawCmd) {
    return b0: { const ground = cx_ll_concat(cx_ll_concat(backdrop_at(scene_heading_at(u_), scene_step_at(u_)), road()), dashes(@as(f64, @bitCast(@as(i64, 4622945017495814144))), 24)); break :b0 b1: { const water = cx_ll_concat(bank_poly(), pond_poly()); break :b1 b2: { const far_trees = cx_ll_concat(cx_ll_concat(cx_ll_concat(conifer((@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4628011567076605952)))), @as(f64, @bitCast(@as(i64, 4640009437958897664))), @as(f64, @bitCast(@as(i64, 4622382067542392832))), false), conifer(@as(f64, @bitCast(@as(i64, 4626604192193052672))), @as(f64, @bitCast(@as(i64, 4638848353679966208))), @as(f64, @bitCast(@as(i64, 4621537642612260864))), false)), conifer((@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4625478292286210048)))), @as(f64, @bitCast(@as(i64, 4637018766331346944))), @as(f64, @bitCast(@as(i64, 4622100592565682176))), false)), conifer(@as(f64, @bitCast(@as(i64, 4624633867356078080))), @as(f64, @bitCast(@as(i64, 4635189178982727680))), @as(f64, @bitCast(@as(i64, 4620693217682128896))), false)); break :b2 b3: { const mid_trees = cx_ll_concat(cx_ll_concat(conifer((@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4623507967449235456)))), @as(f64, @bitCast(@as(i64, 4633218854145753088))), @as(f64, @bitCast(@as(i64, 4621256167635550208))), false), conifer(@as(f64, @bitCast(@as(i64, 4623226492472524800))), @as(f64, @bitCast(@as(i64, 4631389266797133824))), @as(f64, @bitCast(@as(i64, 4620130267728707584))), false)), conifer((@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4622100592565682176)))), @as(f64, @bitCast(@as(i64, 4629841154425225216))), @as(f64, @bitCast(@as(i64, 4620974692658839552))), false)); break :b3 b4: { const near_trees = cx_ll_concat(cx_ll_concat(conifer(@as(f64, @bitCast(@as(i64, 4621537642612260864))), @as(f64, @bitCast(@as(i64, 4627167142146473984))), @as(f64, @bitCast(@as(i64, 4619567317775286272))), true), conifer((@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4620693217682128896)))), @as(f64, @bitCast(@as(i64, 4624915342332788736))), @as(f64, @bitCast(@as(i64, 4619004367821864960))), true)), conifer(@as(f64, @bitCast(@as(i64, 4620693217682128896))), @as(f64, @bitCast(@as(i64, 4621537642612260864))), @as(f64, @bitCast(@as(i64, 4618441417868443648))), true)); break :b4 cx_ll_concat(cx_ll_concat(cx_ll_concat(cx_ll_concat(cx_ll_concat(cx_ll_concat(ground, water), draw_flat(tower_corners(0), cx_new(RiderPtS{ .right = tower_right(), .forward = tower_forward() }), focal(), camera_w(), (scene_step_at(u_) + beacon_offset_for(3)))), far_trees), mid_trees), rail_cmds()), near_trees); }; }; }; }; };
}

fn frame() *CxList(DrawCmd) {
    return frame_at(@as(f64, @bitCast(@as(i64, 0))));
}

fn report(u_: f64) []const u8 {
    return b0: { const sun = (if (scene_sun_at(u_).visible) "\x13\x19\x12\x02\x10\x12\x02" else "\x13\x19\x12\x02\x10\x1c\x1c"); break :b0 cx_concat(cx_concat(cx_concat(cx_concat(cx_concat(cx_concat(cx_concat(cx_concat(cx_concat(cx_concat(cx_concat(cx_concat(cx_concat("\x13\x22\x1e\x02", cx_show_int(sky_color(scene_step_at(u_)))), "\x02\x14\x10\x15\x11\x26\x10\x12\x02"), cx_show_int(horizon_color(scene_step_at(u_)))), "\x02"), sun), "\x02\x24\x02"), cx_show_int(cx_real_to_int(scene_sun_at(u_).x))), "\x02\x1e\x02"), cx_show_int(cx_real_to_int(scene_sun_at(u_).y))), "\x02\x18\x1a\x16\x13\x02"), cx_show_int(cx_list_len(frame_at(u_)))), "\x02\x16\x15\x0f\x1b\x12\x02"), cx_show_int(cx_list_len(blit_expand(frame_at(u_), 0)))); };
}

fn opening() void {
    return b0: { _ = cx_print_line(cx_concat("\x18\x1a\x16\x13\x02\x02", cx_show_int(cx_list_len(frame())))); _ = cx_print_line(cx_concat(cx_concat("\x1a\x51\x1c\x15\x0f\x1a\x0d\x02", cx_show_int(cx_real_to_int((u_per_step() * @as(f64, @bitCast(@as(i64, 4681608360884174848))))))), "\x02\x0d\x49\x08\x02\x10\x1c\x02\x0e\x14\x0d\x02\x18\x10\x19\x15\x13\x0d")); _ = cx_print_line(cx_concat("\x19\x4d\x03\x41\x03\x02", report(@as(f64, @bitCast(@as(i64, 0)))))); _ = cx_print_line(cx_concat("\x19\x4d\x03\x41\x08\x02", report(@as(f64, @bitCast(@as(i64, 4602678819172646912)))))); _ = cx_print_line(cx_concat("\x19\x4d\x04\x41\x03\x02", report(@as(f64, @bitCast(@as(i64, 4607182418800017408)))))); break :b0; };
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

// cx_gpa and the heap it allocates from live beside the buffer
// builtins below: one region, one bump frontier, bare metal's model.

fn CxFn1(comptime A: type, comptime R: type) type {
    return struct { ctx: *anyopaque, call: *const fn (*anyopaque, A) R };
}
fn CxList(comptime T: type) type {
    return struct { items: std.ArrayListUnmanaged(T) = .empty };
}
fn cx_ll_empty(comptime T: type) *CxList(T) {
    const cx_l = cx_gpa.create(CxList(T)) catch @panic("oom");
    cx_l.* = .{};
    return cx_l;
}
fn cx_ll_push(l: anytype, v: anytype) @TypeOf(l) {
    l.items.append(cx_gpa, v) catch @panic("oom");
    return l;
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
fn cx_shl(a: i64, b: i64) i64 {
    return a << @as(u6, @intCast(b & 63));
}
fn cx_shr(a: i64, b: i64) i64 {
    return a >> @as(u6, @intCast(b & 63));
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


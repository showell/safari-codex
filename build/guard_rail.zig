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

const RailPolyS = struct {
    v_: *CxList(Vec3),
    color: i64,
    fwd: f64,
};
const RailPoly = *RailPolyS;

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

fn deg() f64 {
    return @as(f64, @bitCast(@as(i64, 4580687790476533049)));
}

fn r_tan(x: f64) f64 {
    return (real_sin(x) / real_cos(x));
}

fn camera_w() f64 {
    return @as(f64, @bitCast(@as(i64, 4651655465120301056)));
}

fn fov_deg() f64 {
    return @as(f64, @bitCast(@as(i64, 4634626229029306368)));
}

fn focal() f64 {
    return ((camera_w() / @as(f64, @bitCast(@as(i64, 4611686018427387904)))) / r_tan(((fov_deg() / @as(f64, @bitCast(@as(i64, 4611686018427387904)))) * deg())));
}

fn near() f64 {
    return @as(f64, @bitCast(@as(i64, 4600877379321698714)));
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

fn camera_h() f64 {
    return @as(f64, @bitCast(@as(i64, 4648488871632306176)));
}

fn eye_h() f64 {
    return @as(f64, @bitCast(@as(i64, 4608083138725491507)));
}

fn project(p_: Vec3, cf: f64, view_w: f64) ScreenPt {
    return cx_new(ScreenPtS{ .x = ((view_w / @as(f64, @bitCast(@as(i64, 4611686018427387904)))) + ((p_.right / p_.forward) * cf)), .y = ((camera_h() / @as(f64, @bitCast(@as(i64, 4611686018427387904)))) - (((p_.height - eye_h()) / p_.forward) * cf)) });
}

fn project_all(ps: *CxList(Vec3), cf: f64, view_w: f64, i_: i64) *CxList(ScreenPt) {
    return (if ((i_ >= cx_list_len(ps))) cx_ll_empty(ScreenPt) else cx_ll_concat(cx_ll_of(ScreenPt, &[_]ScreenPt{ project(cx_list_at(ps, i_), cf, view_w) }), project_all(ps, cf, view_w, (i_ +% 1))));
}

fn flatten_screen(ps: *CxList(ScreenPt), i_: i64) *CxList(f64) {
    return (if ((i_ >= cx_list_len(ps))) cx_ll_empty(f64) else b1: { const p_ = cx_list_at(ps, i_); break :b1 cx_ll_concat(cx_ll_of(f64, &[_]f64{ p_.x, p_.y }), flatten_screen(ps, (i_ +% 1))); });
}

fn push_poly(color: i64, ps: *CxList(ScreenPt)) *CxList(DrawCmd) {
    return (if ((cx_list_len(ps) < 3)) cx_ll_empty(DrawCmd) else cx_ll_of(DrawCmd, &[_]DrawCmd{ cx_new(DrawCmdS{ .tag = 0, .color = color, .color2 = 0, .strength = @as(f64, @bitCast(@as(i64, 0))), .geom = cx_ll_empty(f64), .pts = flatten_screen(ps, 0) }) }));
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

fn rail_draw_poly(rp: RailPoly, cf: f64, view_w: f64) *CxList(DrawCmd) {
    return b0: { const clipped = clip_near(rp.v_, near()); break :b0 (if ((cx_list_len(clipped) < 3)) cx_ll_empty(DrawCmd) else push_poly(rp.color, project_all(clipped, cf, view_w, 0))); };
}

fn rail_draw_all(ps: *CxList(RailPoly), cf: f64, view_w: f64, i_: i64) *CxList(DrawCmd) {
    return (if ((i_ >= cx_list_len(ps))) cx_ll_empty(DrawCmd) else cx_ll_concat(rail_draw_poly(cx_list_at(ps, i_), cf, view_w), rail_draw_all(ps, cf, view_w, (i_ +% 1))));
}

fn g_abs(x: f64) f64 {
    return (if ((x < @as(f64, @bitCast(@as(i64, 0))))) (@as(f64, @bitCast(@as(i64, 0))) - x) else x);
}

fn g_finite(x: f64) bool {
    return ((cx_real_to_bits(x) & 9223372036854775807) < 9218868437227405312);
}

fn g_max(a_: f64, b_: f64) f64 {
    return (if ((a_ > b_)) a_ else b_);
}

fn first_rel_diff(got: *CxList(f64), want: *CxList(f64), tol: f64, i_: i64) i64 {
    var _tl_i = i_;
    while (true) {
        if ((_tl_i >= cx_list_len(got))) { return (0 -% 1); } else { if (g_finite(cx_list_at(got, _tl_i))) { const w: f64 = cx_list_at(want, _tl_i); if ((g_abs((cx_list_at(got, _tl_i) - w)) > (tol * g_max(@as(f64, @bitCast(@as(i64, 4607182418800017408))), g_abs(w))))) { return _tl_i; } else { { const _tj4_3 = (_tl_i +% 1); _tl_i = _tj4_3; continue; } } } else { return _tl_i; } }
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
        if ((_tl_i >= cx_list_len(got))) { return (0 -% 1); } else { if (g_finite(cx_list_at(got, _tl_i))) { const w: f64 = cx_list_at(want, _tl_i); if ((g_abs((cx_list_at(got, _tl_i) - w)) > (atol + (rtol * g_abs(w))))) { return _tl_i; } else { { const _tj4_4 = (_tl_i +% 1); _tl_i = _tj4_4; continue; } } } else { return _tl_i; } }
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

fn g_rail_polys() *CxList(i64) {
    return cx_ll_of(i64, &[_]i64{ 13, 7, 9, 0 });
}

fn g_rail_colors() *CxList(i64) {
    return cx_ll_of(i64, &[_]i64{ 12765135, 12765135, 12765135, 12765135, 12765135, 12765135, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 10133672, 12765135, 12765135, 12765135, 10133672, 10133672, 10133672, 10133672, 12765135, 12765135, 12765135, 12765135, 10133672, 10133672, 10133672, 10133672, 10133672 });
}

fn g_rail_fwd() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ @as(f64, @bitCast(@as(i64, 4630685579355357184))), @as(f64, @bitCast(@as(i64, 4628855992006737920))), @as(f64, @bitCast(@as(i64, 4626533823448875008))), @as(f64, @bitCast(@as(i64, 4624774604844433408))), @as(f64, @bitCast(@as(i64, 4623057607486498406))), @as(f64, @bitCast(@as(i64, 4622607247523761357))), @as(f64, @bitCast(@as(i64, 4631389266797133824))), @as(f64, @bitCast(@as(i64, 4629981891913580544))), @as(f64, @bitCast(@as(i64, 4627448617123184640))), @as(f64, @bitCast(@as(i64, 4625619029774565376))), @as(f64, @bitCast(@as(i64, 4623507967449235456))), @as(f64, @bitCast(@as(i64, 4622607247523761357))), @as(f64, @bitCast(@as(i64, 4622607247523761357))), @as(f64, @bitCast(@as(i64, 4625196817309499392))), @as(f64, @bitCast(@as(i64, 4625196817309499392))), @as(f64, @bitCast(@as(i64, 4623507967449235456))), @as(f64, @bitCast(@as(i64, 4626322717216342016))), @as(f64, @bitCast(@as(i64, 4622945017495814144))), @as(f64, @bitCast(@as(i64, 4626322717216342016))), @as(f64, @bitCast(@as(i64, 4618441417868443648))), (-@as(f64, @bitCast(@as(i64, 4620693217682128896)))), (-@as(f64, @bitCast(@as(i64, 4611235658464650854)))), @as(f64, @bitCast(@as(i64, 4614162998222441677))), @as(f64, @bitCast(@as(i64, 4625759767262920704))), (-@as(f64, @bitCast(@as(i64, 4622945017495814144)))), (-@as(f64, @bitCast(@as(i64, 4616189618054758400)))), @as(f64, @bitCast(@as(i64, 4596373779694328218))), @as(f64, @bitCast(@as(i64, 4618441417868443648))), @as(f64, @bitCast(@as(i64, 4629137466983448576))) });
}

fn g_rail_verts() *CxList(f64) {
    @setEvalBranchQuota(1000000);
    return cx_ll_of(f64, &[_]f64{ @as(f64, @bitCast(@as(i64, 4618441417868443648))), @as(f64, @bitCast(@as(i64, 4631389266797133824))), @as(f64, @bitCast(@as(i64, 4601778099247172813))), @as(f64, @bitCast(@as(i64, 4618441417868443648))), @as(f64, @bitCast(@as(i64, 4629981891913580544))), @as(f64, @bitCast(@as(i64, 4601778099247172813))), @as(f64, @bitCast(@as(i64, 4618441417868443648))), @as(f64, @bitCast(@as(i64, 4629981891913580544))), @as(f64, @bitCast(@as(i64, 4603129179135383962))), @as(f64, @bitCast(@as(i64, 4618441417868443648))), @as(f64, @bitCast(@as(i64, 4631389266797133824))), @as(f64, @bitCast(@as(i64, 4603129179135383962))), @as(f64, @bitCast(@as(i64, 4618441417868443648))), @as(f64, @bitCast(@as(i64, 4629981891913580544))), @as(f64, @bitCast(@as(i64, 4601778099247172813))), @as(f64, @bitCast(@as(i64, 4618441417868443648))), @as(f64, @bitCast(@as(i64, 4627448617123184640))), @as(f64, @bitCast(@as(i64, 4601778099247172813))), @as(f64, @bitCast(@as(i64, 4618441417868443648))), @as(f64, @bitCast(@as(i64, 4627448617123184640))), @as(f64, @bitCast(@as(i64, 4603129179135383962))), @as(f64, @bitCast(@as(i64, 4618441417868443648))), @as(f64, @bitCast(@as(i64, 4629981891913580544))), @as(f64, @bitCast(@as(i64, 4603129179135383962))), @as(f64, @bitCast(@as(i64, 4618441417868443648))), @as(f64, @bitCast(@as(i64, 4627448617123184640))), @as(f64, @bitCast(@as(i64, 4601778099247172813))), @as(f64, @bitCast(@as(i64, 4620017677738023322))), @as(f64, @bitCast(@as(i64, 4625619029774565376))), @as(f64, @bitCast(@as(i64, 4601778099247172813))), @as(f64, @bitCast(@as(i64, 4620017677738023322))), @as(f64, @bitCast(@as(i64, 4625619029774565376))), @as(f64, @bitCast(@as(i64, 4603129179135383962))), @as(f64, @bitCast(@as(i64, 4618441417868443648))), @as(f64, @bitCast(@as(i64, 4627448617123184640))), @as(f64, @bitCast(@as(i64, 4603129179135383962))), @as(f64, @bitCast(@as(i64, 4620017677738023322))), @as(f64, @bitCast(@as(i64, 4625619029774565376))), @as(f64, @bitCast(@as(i64, 4601778099247172813))), @as(f64, @bitCast(@as(i64, 4622382067542392832))), @as(f64, @bitCast(@as(i64, 4623507967449235456))), @as(f64, @bitCast(@as(i64, 4601778099247172813))), @as(f64, @bitCast(@as(i64, 4622382067542392832))), @as(f64, @bitCast(@as(i64, 4623507967449235456))), @as(f64, @bitCast(@as(i64, 4603129179135383962))), @as(f64, @bitCast(@as(i64, 4620017677738023322))), @as(f64, @bitCast(@as(i64, 4625619029774565376))), @as(f64, @bitCast(@as(i64, 4603129179135383962))), @as(f64, @bitCast(@as(i64, 4622382067542392832))), @as(f64, @bitCast(@as(i64, 4623507967449235456))), @as(f64, @bitCast(@as(i64, 4601778099247172813))), @as(f64, @bitCast(@as(i64, 4625478292286210048))), @as(f64, @bitCast(@as(i64, 4622607247523761357))), @as(f64, @bitCast(@as(i64, 4601778099247172813))), @as(f64, @bitCast(@as(i64, 4625478292286210048))), @as(f64, @bitCast(@as(i64, 4622607247523761357))), @as(f64, @bitCast(@as(i64, 4603129179135383962))), @as(f64, @bitCast(@as(i64, 4622382067542392832))), @as(f64, @bitCast(@as(i64, 4623507967449235456))), @as(f64, @bitCast(@as(i64, 4603129179135383962))), @as(f64, @bitCast(@as(i64, 4625478292286210048))), @as(f64, @bitCast(@as(i64, 4622607247523761357))), @as(f64, @bitCast(@as(i64, 4601778099247172813))), @as(f64, @bitCast(@as(i64, 4628293042053316608))), @as(f64, @bitCast(@as(i64, 4622607247523761357))), @as(f64, @bitCast(@as(i64, 4601778099247172813))), @as(f64, @bitCast(@as(i64, 4628293042053316608))), @as(f64, @bitCast(@as(i64, 4622607247523761357))), @as(f64, @bitCast(@as(i64, 4603129179135383962))), @as(f64, @bitCast(@as(i64, 4625478292286210048))), @as(f64, @bitCast(@as(i64, 4622607247523761357))), @as(f64, @bitCast(@as(i64, 4603129179135383962))), @as(f64, @bitCast(@as(i64, 4618441417868443648))), @as(f64, @bitCast(@as(i64, 4631390674172017377))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4618441417868443648))), @as(f64, @bitCast(@as(i64, 4631387859422250271))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4618441417868443648))), @as(f64, @bitCast(@as(i64, 4631387859422250271))), @as(f64, @bitCast(@as(i64, 4603129179135383962))), @as(f64, @bitCast(@as(i64, 4618441417868443648))), @as(f64, @bitCast(@as(i64, 4631390674172017377))), @as(f64, @bitCast(@as(i64, 4603129179135383962))), @as(f64, @bitCast(@as(i64, 4618441417868443648))), @as(f64, @bitCast(@as(i64, 4629983299288464097))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4618441417868443648))), @as(f64, @bitCast(@as(i64, 4629980484538696991))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4618441417868443648))), @as(f64, @bitCast(@as(i64, 4629980484538696991))), @as(f64, @bitCast(@as(i64, 4603129179135383962))), @as(f64, @bitCast(@as(i64, 4618441417868443648))), @as(f64, @bitCast(@as(i64, 4629983299288464097))), @as(f64, @bitCast(@as(i64, 4603129179135383962))), @as(f64, @bitCast(@as(i64, 4618440466032662403))), @as(f64, @bitCast(@as(i64, 4627451421739852585))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4618442369704224893))), @as(f64, @bitCast(@as(i64, 4627445812506516695))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4618442369704224893))), @as(f64, @bitCast(@as(i64, 4627445812506516695))), @as(f64, @bitCast(@as(i64, 4603129179135383962))), @as(f64, @bitCast(@as(i64, 4618440466032662403))), @as(f64, @bitCast(@as(i64, 4627451421739852585))), @as(f64, @bitCast(@as(i64, 4603129179135383962))), @as(f64, @bitCast(@as(i64, 4620013018764208807))), @as(f64, @bitCast(@as(i64, 4625621592322753350))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4620022336711837836))), @as(f64, @bitCast(@as(i64, 4625616467226377402))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4620022336711837836))), @as(f64, @bitCast(@as(i64, 4625616467226377402))), @as(f64, @bitCast(@as(i64, 4603129179135383962))), @as(f64, @bitCast(@as(i64, 4620013018764208807))), @as(f64, @bitCast(@as(i64, 4625621592322753350))), @as(f64, @bitCast(@as(i64, 4603129179135383962))), @as(f64, @bitCast(@as(i64, 4622377316244785956))), @as(f64, @bitCast(@as(i64, 4623510986549835654))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4622386818839999708))), @as(f64, @bitCast(@as(i64, 4623504948348635258))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4622386818839999708))), @as(f64, @bitCast(@as(i64, 4623504948348635258))), @as(f64, @bitCast(@as(i64, 4603129179135383962))), @as(f64, @bitCast(@as(i64, 4622377316244785956))), @as(f64, @bitCast(@as(i64, 4623510986549835654))), @as(f64, @bitCast(@as(i64, 4603129179135383962))), @as(f64, @bitCast(@as(i64, 4625475491610191777))), @as(f64, @bitCast(@as(i64, 4622607807096015058))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4625481092962228319))), @as(f64, @bitCast(@as(i64, 4622606687388557703))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4625481092962228319))), @as(f64, @bitCast(@as(i64, 4622606687388557703))), @as(f64, @bitCast(@as(i64, 4603129179135383962))), @as(f64, @bitCast(@as(i64, 4625475491610191777))), @as(f64, @bitCast(@as(i64, 4622607807096015058))), @as(f64, @bitCast(@as(i64, 4603129179135383962))), @as(f64, @bitCast(@as(i64, 4628290227303549501))), @as(f64, @bitCast(@as(i64, 4622607247523761357))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4628295856803083715))), @as(f64, @bitCast(@as(i64, 4622607247523761357))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4628295856803083715))), @as(f64, @bitCast(@as(i64, 4622607247523761357))), @as(f64, @bitCast(@as(i64, 4603129179135383962))), @as(f64, @bitCast(@as(i64, 4628290227303549501))), @as(f64, @bitCast(@as(i64, 4622607247523761357))), @as(f64, @bitCast(@as(i64, 4603129179135383962))), (-@as(f64, @bitCast(@as(i64, 4616189618054758400)))), @as(f64, @bitCast(@as(i64, 4626322717216342016))), @as(f64, @bitCast(@as(i64, 4601778099247172813))), (-@as(f64, @bitCast(@as(i64, 4616189618054758400)))), @as(f64, @bitCast(@as(i64, 4622945017495814144))), @as(f64, @bitCast(@as(i64, 4601778099247172813))), (-@as(f64, @bitCast(@as(i64, 4616189618054758400)))), @as(f64, @bitCast(@as(i64, 4622945017495814144))), @as(f64, @bitCast(@as(i64, 4603129179135383962))), (-@as(f64, @bitCast(@as(i64, 4616189618054758400)))), @as(f64, @bitCast(@as(i64, 4626322717216342016))), @as(f64, @bitCast(@as(i64, 4603129179135383962))), (-@as(f64, @bitCast(@as(i64, 4616189618054758400)))), @as(f64, @bitCast(@as(i64, 4622945017495814144))), @as(f64, @bitCast(@as(i64, 4601778099247172813))), (-@as(f64, @bitCast(@as(i64, 4616189618054758400)))), @as(f64, @bitCast(@as(i64, 4626322717216342016))), @as(f64, @bitCast(@as(i64, 4601778099247172813))), (-@as(f64, @bitCast(@as(i64, 4616189618054758400)))), @as(f64, @bitCast(@as(i64, 4626322717216342016))), @as(f64, @bitCast(@as(i64, 4603129179135383962))), (-@as(f64, @bitCast(@as(i64, 4616189618054758400)))), @as(f64, @bitCast(@as(i64, 4622945017495814144))), @as(f64, @bitCast(@as(i64, 4603129179135383962))), (-@as(f64, @bitCast(@as(i64, 4616189618054758400)))), @as(f64, @bitCast(@as(i64, 4626322717216342016))), @as(f64, @bitCast(@as(i64, 4601778099247172813))), (-@as(f64, @bitCast(@as(i64, 4616752568008179712)))), @as(f64, @bitCast(@as(i64, 4618441417868443648))), @as(f64, @bitCast(@as(i64, 4601778099247172813))), (-@as(f64, @bitCast(@as(i64, 4616752568008179712)))), @as(f64, @bitCast(@as(i64, 4618441417868443648))), @as(f64, @bitCast(@as(i64, 4603129179135383962))), (-@as(f64, @bitCast(@as(i64, 4616189618054758400)))), @as(f64, @bitCast(@as(i64, 4626322717216342016))), @as(f64, @bitCast(@as(i64, 4603129179135383962))), (-@as(f64, @bitCast(@as(i64, 4616189618054758400)))), @as(f64, @bitCast(@as(i64, 4626325531966109123))), @as(f64, @bitCast(@as(i64, 0))), (-@as(f64, @bitCast(@as(i64, 4616189618054758400)))), @as(f64, @bitCast(@as(i64, 4626319902466574909))), @as(f64, @bitCast(@as(i64, 0))), (-@as(f64, @bitCast(@as(i64, 4616189618054758400)))), @as(f64, @bitCast(@as(i64, 4626319902466574909))), @as(f64, @bitCast(@as(i64, 4603129179135383962))), (-@as(f64, @bitCast(@as(i64, 4616189618054758400)))), @as(f64, @bitCast(@as(i64, 4626325531966109123))), @as(f64, @bitCast(@as(i64, 4603129179135383962))), (-@as(f64, @bitCast(@as(i64, 4616189618054758400)))), @as(f64, @bitCast(@as(i64, 4622945017495814144))), @as(f64, @bitCast(@as(i64, 0))), (-@as(f64, @bitCast(@as(i64, 4616189618054758400)))), @as(f64, @bitCast(@as(i64, 4622945017495814144))), @as(f64, @bitCast(@as(i64, 0))), (-@as(f64, @bitCast(@as(i64, 4616189618054758400)))), @as(f64, @bitCast(@as(i64, 4622945017495814144))), @as(f64, @bitCast(@as(i64, 4603129179135383962))), (-@as(f64, @bitCast(@as(i64, 4616189618054758400)))), @as(f64, @bitCast(@as(i64, 4622945017495814144))), @as(f64, @bitCast(@as(i64, 4603129179135383962))), (-@as(f64, @bitCast(@as(i64, 4616187748160193116)))), @as(f64, @bitCast(@as(i64, 4626325522395959914))), @as(f64, @bitCast(@as(i64, 0))), (-@as(f64, @bitCast(@as(i64, 4616190553339811014)))), @as(f64, @bitCast(@as(i64, 4626319912036724118))), @as(f64, @bitCast(@as(i64, 0))), (-@as(f64, @bitCast(@as(i64, 4616190553339811014)))), @as(f64, @bitCast(@as(i64, 4626319912036724118))), @as(f64, @bitCast(@as(i64, 4603129179135383962))), (-@as(f64, @bitCast(@as(i64, 4616187748160193116)))), @as(f64, @bitCast(@as(i64, 4626325522395959914))), @as(f64, @bitCast(@as(i64, 4603129179135383962))), (-@as(f64, @bitCast(@as(i64, 4616752166061912969)))), @as(f64, @bitCast(@as(i64, 4618452669661752670))), @as(f64, @bitCast(@as(i64, 0))), (-@as(f64, @bitCast(@as(i64, 4616752969954446455)))), @as(f64, @bitCast(@as(i64, 4618430166075134626))), @as(f64, @bitCast(@as(i64, 0))), (-@as(f64, @bitCast(@as(i64, 4616752969954446455)))), @as(f64, @bitCast(@as(i64, 4618430166075134626))), @as(f64, @bitCast(@as(i64, 4603129179135383962))), (-@as(f64, @bitCast(@as(i64, 4616752166061912969)))), @as(f64, @bitCast(@as(i64, 4618452669661752670))), @as(f64, @bitCast(@as(i64, 4603129179135383962))), @as(f64, @bitCast(@as(i64, 4613937818241073152))), (-@as(f64, @bitCast(@as(i64, 4622945017495814144)))), @as(f64, @bitCast(@as(i64, 4601778099247172813))), @as(f64, @bitCast(@as(i64, 4613937818241073152))), (-@as(f64, @bitCast(@as(i64, 4616189618054758400)))), @as(f64, @bitCast(@as(i64, 4601778099247172813))), @as(f64, @bitCast(@as(i64, 4613937818241073152))), (-@as(f64, @bitCast(@as(i64, 4616189618054758400)))), @as(f64, @bitCast(@as(i64, 4603129179135383962))), @as(f64, @bitCast(@as(i64, 4613937818241073152))), (-@as(f64, @bitCast(@as(i64, 4622945017495814144)))), @as(f64, @bitCast(@as(i64, 4603129179135383962))), @as(f64, @bitCast(@as(i64, 4613937818241073152))), (-@as(f64, @bitCast(@as(i64, 4616189618054758400)))), @as(f64, @bitCast(@as(i64, 4601778099247172813))), @as(f64, @bitCast(@as(i64, 4613937818241073152))), @as(f64, @bitCast(@as(i64, 4596373779694328218))), @as(f64, @bitCast(@as(i64, 4601778099247172813))), @as(f64, @bitCast(@as(i64, 4613937818241073152))), @as(f64, @bitCast(@as(i64, 4596373779694328218))), @as(f64, @bitCast(@as(i64, 4603129179135383962))), @as(f64, @bitCast(@as(i64, 4613937818241073152))), (-@as(f64, @bitCast(@as(i64, 4616189618054758400)))), @as(f64, @bitCast(@as(i64, 4603129179135383962))), @as(f64, @bitCast(@as(i64, 4613937818241073152))), @as(f64, @bitCast(@as(i64, 4596373779694328218))), @as(f64, @bitCast(@as(i64, 4601778099247172813))), @as(f64, @bitCast(@as(i64, 4614388178203810202))), @as(f64, @bitCast(@as(i64, 4618441417868443648))), @as(f64, @bitCast(@as(i64, 4601778099247172813))), @as(f64, @bitCast(@as(i64, 4614388178203810202))), @as(f64, @bitCast(@as(i64, 4618441417868443648))), @as(f64, @bitCast(@as(i64, 4603129179135383962))), @as(f64, @bitCast(@as(i64, 4613937818241073152))), @as(f64, @bitCast(@as(i64, 4596373779694328218))), @as(f64, @bitCast(@as(i64, 4603129179135383962))), @as(f64, @bitCast(@as(i64, 4614388178203810202))), @as(f64, @bitCast(@as(i64, 4618441417868443648))), @as(f64, @bitCast(@as(i64, 4601778099247172813))), @as(f64, @bitCast(@as(i64, 4615288898129284301))), @as(f64, @bitCast(@as(i64, 4629137466983448576))), @as(f64, @bitCast(@as(i64, 4601778099247172813))), @as(f64, @bitCast(@as(i64, 4615288898129284301))), @as(f64, @bitCast(@as(i64, 4629137466983448576))), @as(f64, @bitCast(@as(i64, 4603129179135383962))), @as(f64, @bitCast(@as(i64, 4614388178203810202))), @as(f64, @bitCast(@as(i64, 4618441417868443648))), @as(f64, @bitCast(@as(i64, 4603129179135383962))), @as(f64, @bitCast(@as(i64, 4613937818241073152))), (-@as(f64, @bitCast(@as(i64, 4622950646995348357)))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4613937818241073152))), (-@as(f64, @bitCast(@as(i64, 4622939387996279931)))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4613937818241073152))), (-@as(f64, @bitCast(@as(i64, 4622939387996279931)))), @as(f64, @bitCast(@as(i64, 4603129179135383962))), @as(f64, @bitCast(@as(i64, 4613937818241073152))), (-@as(f64, @bitCast(@as(i64, 4622950646995348357)))), @as(f64, @bitCast(@as(i64, 4603129179135383962))), @as(f64, @bitCast(@as(i64, 4613937818241073152))), (-@as(f64, @bitCast(@as(i64, 4616200877053826826)))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4613937818241073152))), (-@as(f64, @bitCast(@as(i64, 4616167100056621548)))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4613937818241073152))), (-@as(f64, @bitCast(@as(i64, 4616167100056621548)))), @as(f64, @bitCast(@as(i64, 4603129179135383962))), @as(f64, @bitCast(@as(i64, 4613937818241073152))), (-@as(f64, @bitCast(@as(i64, 4616200877053826826)))), @as(f64, @bitCast(@as(i64, 4603129179135383962))), @as(f64, @bitCast(@as(i64, 4613937367881110415))), @as(f64, @bitCast(@as(i64, 4596013564142020586))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4613938268601035889))), @as(f64, @bitCast(@as(i64, 4596733995606923819))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4613938268601035889))), @as(f64, @bitCast(@as(i64, 4596733995606923819))), @as(f64, @bitCast(@as(i64, 4603129179135383962))), @as(f64, @bitCast(@as(i64, 4613937367881110415))), @as(f64, @bitCast(@as(i64, 4596013564142020586))), @as(f64, @bitCast(@as(i64, 4603129179135383962))), @as(f64, @bitCast(@as(i64, 4614387725141687688))), @as(f64, @bitCast(@as(i64, 4618430161121175035))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4614388631491112696))), @as(f64, @bitCast(@as(i64, 4618452674615712261))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4614388631491112696))), @as(f64, @bitCast(@as(i64, 4618452674615712261))), @as(f64, @bitCast(@as(i64, 4603129179135383962))), @as(f64, @bitCast(@as(i64, 4614387725141687688))), @as(f64, @bitCast(@as(i64, 4618430161121175035))), @as(f64, @bitCast(@as(i64, 4603129179135383962))), @as(f64, @bitCast(@as(i64, 4615288522754255359))), @as(f64, @bitCast(@as(i64, 4629134652796631423))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4615289273279133261))), @as(f64, @bitCast(@as(i64, 4629140281170265729))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4615289273279133261))), @as(f64, @bitCast(@as(i64, 4629140281170265729))), @as(f64, @bitCast(@as(i64, 4603129179135383962))), @as(f64, @bitCast(@as(i64, 4615288522754255359))), @as(f64, @bitCast(@as(i64, 4629134652796631423))), @as(f64, @bitCast(@as(i64, 4603129179135383962))) });
}

fn g_rail_tags() *CxList(i64) {
    return cx_ll_of(i64, &[_]i64{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 });
}

fn g_rail_counts() *CxList(i64) {
    return cx_ll_of(i64, &[_]i64{ 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4 });
}

fn g_rail_coords() *CxList(f64) {
    @setEvalBranchQuota(1000000);
    return cx_ll_of(f64, &[_]f64{ @as(f64, @bitCast(@as(i64, 4648255588338201872))), @as(f64, @bitCast(@as(i64, 4644190833884114914))), @as(f64, @bitCast(@as(i64, 4648497426096653064))), @as(f64, @bitCast(@as(i64, 4644251293125815619))), @as(f64, @bitCast(@as(i64, 4648497426096653064))), @as(f64, @bitCast(@as(i64, 4644215823760312867))), @as(f64, @bitCast(@as(i64, 4648255588338201872))), @as(f64, @bitCast(@as(i64, 4644163425610101435))), @as(f64, @bitCast(@as(i64, 4648497426096653064))), @as(f64, @bitCast(@as(i64, 4644251293125815619))), @as(f64, @bitCast(@as(i64, 4648940795100577923))), @as(f64, @bitCast(@as(i64, 4644362135332816368))), @as(f64, @bitCast(@as(i64, 4648940795100577923))), @as(f64, @bitCast(@as(i64, 4644311887123661424))), @as(f64, @bitCast(@as(i64, 4648497426096653064))), @as(f64, @bitCast(@as(i64, 4644215823760312867))), @as(f64, @bitCast(@as(i64, 4648940795100577923))), @as(f64, @bitCast(@as(i64, 4644362135332816368))), @as(f64, @bitCast(@as(i64, 4649983091837603529))), @as(f64, @bitCast(@as(i64, 4644502113366500159))), @as(f64, @bitCast(@as(i64, 4649983091837603529))), @as(f64, @bitCast(@as(i64, 4644433201079405112))), @as(f64, @bitCast(@as(i64, 4648940795100577923))), @as(f64, @bitCast(@as(i64, 4644311887123661424))), @as(f64, @bitCast(@as(i64, 4649983091837603529))), @as(f64, @bitCast(@as(i64, 4644502113366500159))), @as(f64, @bitCast(@as(i64, 4652376954534940692))), @as(f64, @bitCast(@as(i64, 4644681020093150475))), @as(f64, @bitCast(@as(i64, 4652376954534940692))), @as(f64, @bitCast(@as(i64, 4644588253681388502))), @as(f64, @bitCast(@as(i64, 4649983091837603529))), @as(f64, @bitCast(@as(i64, 4644433201079405112))), @as(f64, @bitCast(@as(i64, 4652376954534940692))), @as(f64, @bitCast(@as(i64, 4644681020093150475))), @as(f64, @bitCast(@as(i64, 4654321794891406692))), @as(f64, @bitCast(@as(i64, 4644778669567992796))), @as(f64, @bitCast(@as(i64, 4654321794891406692))), @as(f64, @bitCast(@as(i64, 4644672882827495630))), @as(f64, @bitCast(@as(i64, 4652376954534940692))), @as(f64, @bitCast(@as(i64, 4644588253681388502))), @as(f64, @bitCast(@as(i64, 4654321794891406692))), @as(f64, @bitCast(@as(i64, 4644778669567992796))), @as(f64, @bitCast(@as(i64, 4656844233335003886))), @as(f64, @bitCast(@as(i64, 4644778669567992796))), @as(f64, @bitCast(@as(i64, 4656844233335003886))), @as(f64, @bitCast(@as(i64, 4644672882827495630))), @as(f64, @bitCast(@as(i64, 4654321794891406692))), @as(f64, @bitCast(@as(i64, 4644672882827495630))), @as(f64, @bitCast(@as(i64, 4648255401333264220))), @as(f64, @bitCast(@as(i64, 4644314096350384882))), @as(f64, @bitCast(@as(i64, 4648255775167217664))), @as(f64, @bitCast(@as(i64, 4644314245883966259))), @as(f64, @bitCast(@as(i64, 4648255775167217664))), @as(f64, @bitCast(@as(i64, 4644163466423973058))), @as(f64, @bitCast(@as(i64, 4648255401333264220))), @as(f64, @bitCast(@as(i64, 4644163385323995393))), @as(f64, @bitCast(@as(i64, 4648497113131663334))), @as(f64, @bitCast(@as(i64, 4644410780893822667))), @as(f64, @bitCast(@as(i64, 4648497738973681864))), @as(f64, @bitCast(@as(i64, 4644411031582473800))), @as(f64, @bitCast(@as(i64, 4648497738973681864))), @as(f64, @bitCast(@as(i64, 4644215891842072859))), @as(f64, @bitCast(@as(i64, 4648497113131663334))), @as(f64, @bitCast(@as(i64, 4644215756030396596))), @as(f64, @bitCast(@as(i64, 4648939957272717558))), @as(f64, @bitCast(@as(i64, 4644588003520502951))), @as(f64, @bitCast(@as(i64, 4648941633808047591))), @as(f64, @bitCast(@as(i64, 4644588504545961496))), @as(f64, @bitCast(@as(i64, 4648941633808047591))), @as(f64, @bitCast(@as(i64, 4644312022935337687))), @as(f64, @bitCast(@as(i64, 4648939957272717558))), @as(f64, @bitCast(@as(i64, 4644311751839750742))), @as(f64, @bitCast(@as(i64, 4649980340683588973))), @as(f64, @bitCast(@as(i64, 4644811788617440014))), @as(f64, @bitCast(@as(i64, 4649985846158211573))), @as(f64, @bitCast(@as(i64, 4644812649051259446))), @as(f64, @bitCast(@as(i64, 4649985846158211573))), @as(f64, @bitCast(@as(i64, 4644433434703635782))), @as(f64, @bitCast(@as(i64, 4649980340683588973))), @as(f64, @bitCast(@as(i64, 4644432968510705605))), @as(f64, @bitCast(@as(i64, 4652373945391517794))), @as(f64, @bitCast(@as(i64, 4645098009965945453))), @as(f64, @bitCast(@as(i64, 4652379965877386845))), @as(f64, @bitCast(@as(i64, 4645098928629900693))), @as(f64, @bitCast(@as(i64, 4652379965877386845))), @as(f64, @bitCast(@as(i64, 4644588502786742891))), @as(f64, @bitCast(@as(i64, 4652373945391517794))), @as(f64, @bitCast(@as(i64, 4644588004927877834))), @as(f64, @bitCast(@as(i64, 4654318771234430308))), @as(f64, @bitCast(@as(i64, 4645254596958395637))), @as(f64, @bitCast(@as(i64, 4654324818548383076))), @as(f64, @bitCast(@as(i64, 4645254818092174216))), @as(f64, @bitCast(@as(i64, 4654324818548383076))), @as(f64, @bitCast(@as(i64, 4644672942992771902))), @as(f64, @bitCast(@as(i64, 4654318771234430308))), @as(f64, @bitCast(@as(i64, 4644672822662219359))), @as(f64, @bitCast(@as(i64, 4656842911062320323))), @as(f64, @bitCast(@as(i64, 4645254707613245857))), @as(f64, @bitCast(@as(i64, 4656845555827589775))), @as(f64, @bitCast(@as(i64, 4645254707613245857))), @as(f64, @bitCast(@as(i64, 4656845555827589775))), @as(f64, @bitCast(@as(i64, 4644672882827495630))), @as(f64, @bitCast(@as(i64, 4656842911062320323))), @as(f64, @bitCast(@as(i64, 4644672882827495630))), @as(f64, @bitCast(@as(i64, 4644739938611197410))), @as(f64, @bitCast(@as(i64, 4644437508526158087))), @as(f64, @bitCast(@as(i64, 4643052757721623508))), @as(f64, @bitCast(@as(i64, 4644738999012540778))), @as(f64, @bitCast(@as(i64, 4643052757721623508))), @as(f64, @bitCast(@as(i64, 4644638502242387168))), @as(f64, @bitCast(@as(i64, 4644739938611197410))), @as(f64, @bitCast(@as(i64, 4644377210077037829))), @as(f64, @bitCast(@as(i64, 4643052757721623508))), @as(f64, @bitCast(@as(i64, 4644738999012540778))), @as(f64, @bitCast(@as(i64, 4644739938611197410))), @as(f64, @bitCast(@as(i64, 4644437508526158087))), @as(f64, @bitCast(@as(i64, 4644739938611197410))), @as(f64, @bitCast(@as(i64, 4644377210077037829))), @as(f64, @bitCast(@as(i64, 4643052757721623508))), @as(f64, @bitCast(@as(i64, 4644638502242387168))), @as(f64, @bitCast(@as(i64, 4644739938611197410))), @as(f64, @bitCast(@as(i64, 4644437508526158087))), (-@as(f64, @bitCast(@as(i64, 4630000635332279707)))), @as(f64, @bitCast(@as(i64, 4645492726547911457))), (-@as(f64, @bitCast(@as(i64, 4630000635332279707)))), @as(f64, @bitCast(@as(i64, 4645291732303916795))), @as(f64, @bitCast(@as(i64, 4644739938611197410))), @as(f64, @bitCast(@as(i64, 4644377210077037829))), @as(f64, @bitCast(@as(i64, 4644741143851863313))), @as(f64, @bitCast(@as(i64, 4644708488532440226))), @as(f64, @bitCast(@as(i64, 4644738731611312903))), @as(f64, @bitCast(@as(i64, 4644709212450895954))), @as(f64, @bitCast(@as(i64, 4644738731611312903))), @as(f64, @bitCast(@as(i64, 4644377406229912224))), @as(f64, @bitCast(@as(i64, 4644741143851863313))), @as(f64, @bitCast(@as(i64, 4644377014276007154))), @as(f64, @bitCast(@as(i64, 4643052757721623508))), @as(f64, @bitCast(@as(i64, 4645191235709685046))), @as(f64, @bitCast(@as(i64, 4643052757721623508))), @as(f64, @bitCast(@as(i64, 4645191235709685046))), @as(f64, @bitCast(@as(i64, 4643052757721623508))), @as(f64, @bitCast(@as(i64, 4644638502242387168))), @as(f64, @bitCast(@as(i64, 4643052757721623508))), @as(f64, @bitCast(@as(i64, 4644638502242387168))), @as(f64, @bitCast(@as(i64, 4644741640479275347))), @as(f64, @bitCast(@as(i64, 4644708489763893249))), @as(f64, @bitCast(@as(i64, 4644738234456135287))), @as(f64, @bitCast(@as(i64, 4644709210691677349))), @as(f64, @bitCast(@as(i64, 4644738234456135287))), @as(f64, @bitCast(@as(i64, 4644377405702146642))), @as(f64, @bitCast(@as(i64, 4644741640479275347))), @as(f64, @bitCast(@as(i64, 4644377014803772735))), (-@as(f64, @bitCast(@as(i64, 4629874586615584024)))), @as(f64, @bitCast(@as(i64, 4646393188396016284))), (-@as(f64, @bitCast(@as(i64, 4630127104854065571)))), @as(f64, @bitCast(@as(i64, 4646401223275148351))), (-@as(f64, @bitCast(@as(i64, 4630127104854065571)))), @as(f64, @bitCast(@as(i64, 4645293911975767698))), (-@as(f64, @bitCast(@as(i64, 4629874586615584024)))), @as(f64, @bitCast(@as(i64, 4645289560196705891))), @as(f64, @bitCast(@as(i64, 4662915729726610866))), @as(f64, @bitCast(@as(i64, 4654687183715939910))), @as(f64, @bitCast(@as(i64, 4650649243359782780))), @as(f64, @bitCast(@as(i64, 4645492726547911457))), @as(f64, @bitCast(@as(i64, 4650649243359782780))), @as(f64, @bitCast(@as(i64, 4645291732303916795))), @as(f64, @bitCast(@as(i64, 4662915729726610866))), @as(f64, @bitCast(@as(i64, 4653933456620373882))), @as(f64, @bitCast(@as(i64, 4650649243359782780))), @as(f64, @bitCast(@as(i64, 4645492726547911457))), @as(f64, @bitCast(@as(i64, 4648156918516568975))), @as(f64, @bitCast(@as(i64, 4644286763370927673))), @as(f64, @bitCast(@as(i64, 4648156918516568975))), @as(f64, @bitCast(@as(i64, 4644246563818441298))), @as(f64, @bitCast(@as(i64, 4650649243359782780))), @as(f64, @bitCast(@as(i64, 4645291732303916795))), @as(f64, @bitCast(@as(i64, 4650654408601527281))), @as(f64, @bitCast(@as(i64, 4646401224858445095))), @as(f64, @bitCast(@as(i64, 4650644095358380603))), @as(f64, @bitCast(@as(i64, 4646393186636797680))), @as(f64, @bitCast(@as(i64, 4650644095358380603))), @as(f64, @bitCast(@as(i64, 4645289559141174728))), @as(f64, @bitCast(@as(i64, 4650654408601527281))), @as(f64, @bitCast(@as(i64, 4645293913031298861))), @as(f64, @bitCast(@as(i64, 4648157126104364299))), @as(f64, @bitCast(@as(i64, 4644467818103494012))), @as(f64, @bitCast(@as(i64, 4648156711192656442))), @as(f64, @bitCast(@as(i64, 4644467497046098701))), @as(f64, @bitCast(@as(i64, 4648156711192656442))), @as(f64, @bitCast(@as(i64, 4644246476913042239))), @as(f64, @bitCast(@as(i64, 4648157126104364299))), @as(f64, @bitCast(@as(i64, 4644246651427527800))) });
}

fn path_corner() *CxList(RiderPt) {
    return cx_ll_of(RiderPt, &[_]RiderPt{ cx_new(RiderPtS{ .right = @as(f64, @bitCast(@as(i64, 4618441417868443648))), .forward = @as(f64, @bitCast(@as(i64, 4631389266797133824))) }), cx_new(RiderPtS{ .right = @as(f64, @bitCast(@as(i64, 4618441417868443648))), .forward = @as(f64, @bitCast(@as(i64, 4629981891913580544))) }), cx_new(RiderPtS{ .right = @as(f64, @bitCast(@as(i64, 4618441417868443648))), .forward = @as(f64, @bitCast(@as(i64, 4627448617123184640))) }), cx_new(RiderPtS{ .right = @as(f64, @bitCast(@as(i64, 4620017677738023322))), .forward = @as(f64, @bitCast(@as(i64, 4625619029774565376))) }), cx_new(RiderPtS{ .right = @as(f64, @bitCast(@as(i64, 4622382067542392832))), .forward = @as(f64, @bitCast(@as(i64, 4623507967449235456))) }), cx_new(RiderPtS{ .right = @as(f64, @bitCast(@as(i64, 4625478292286210048))), .forward = @as(f64, @bitCast(@as(i64, 4622607247523761357))) }), cx_new(RiderPtS{ .right = @as(f64, @bitCast(@as(i64, 4628293042053316608))), .forward = @as(f64, @bitCast(@as(i64, 4622607247523761357))) }) });
}

fn path_dupe() *CxList(RiderPt) {
    return cx_ll_of(RiderPt, &[_]RiderPt{ cx_new(RiderPtS{ .right = (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4616189618054758400)))), .forward = @as(f64, @bitCast(@as(i64, 4626322717216342016))) }), cx_new(RiderPtS{ .right = (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4616189618054758400)))), .forward = @as(f64, @bitCast(@as(i64, 4622945017495814144))) }), cx_new(RiderPtS{ .right = (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4616189618054758400)))), .forward = @as(f64, @bitCast(@as(i64, 4626322717216342016))) }), cx_new(RiderPtS{ .right = (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4616752568008179712)))), .forward = @as(f64, @bitCast(@as(i64, 4618441417868443648))) }) });
}

fn path_near() *CxList(RiderPt) {
    return cx_ll_of(RiderPt, &[_]RiderPt{ cx_new(RiderPtS{ .right = @as(f64, @bitCast(@as(i64, 4613937818241073152))), .forward = (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4622945017495814144)))) }), cx_new(RiderPtS{ .right = @as(f64, @bitCast(@as(i64, 4613937818241073152))), .forward = (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4616189618054758400)))) }), cx_new(RiderPtS{ .right = @as(f64, @bitCast(@as(i64, 4613937818241073152))), .forward = @as(f64, @bitCast(@as(i64, 4596373779694328218))) }), cx_new(RiderPtS{ .right = @as(f64, @bitCast(@as(i64, 4614388178203810202))), .forward = @as(f64, @bitCast(@as(i64, 4618441417868443648))) }), cx_new(RiderPtS{ .right = @as(f64, @bitCast(@as(i64, 4615288898129284301))), .forward = @as(f64, @bitCast(@as(i64, 4629137466983448576))) }) });
}

fn path_single() *CxList(RiderPt) {
    return cx_ll_of(RiderPt, &[_]RiderPt{ cx_new(RiderPtS{ .right = @as(f64, @bitCast(@as(i64, 4611686018427387904))), .forward = @as(f64, @bitCast(@as(i64, 4621256167635550208))) }) });
}

fn store_corner() *CxList(RailPoly) {
    return rail_emit(path_corner());
}

fn store_dupe() *CxList(RailPoly) {
    return rail_emit(path_dupe());
}

fn store_near() *CxList(RailPoly) {
    return rail_emit(path_near());
}

fn store_single() *CxList(RailPoly) {
    return rail_emit(path_single());
}

fn all_polys() *CxList(RailPoly) {
    return cx_ll_concat(cx_ll_concat(cx_ll_concat(store_corner(), store_dupe()), store_near()), store_single());
}

fn poly_counts() *CxList(i64) {
    return cx_ll_of(i64, &[_]i64{ cx_list_len(store_corner()), cx_list_len(store_dupe()), cx_list_len(store_near()), cx_list_len(store_single()) });
}

fn poly_colors(ps: *CxList(RailPoly), i_: i64) *CxList(i64) {
    return (if ((i_ >= cx_list_len(ps))) cx_ll_empty(i64) else cx_ll_concat(cx_ll_of(i64, &[_]i64{ cx_list_at(ps, i_).color }), poly_colors(ps, (i_ +% 1))));
}

fn poly_fwds(ps: *CxList(RailPoly), i_: i64) *CxList(f64) {
    return (if ((i_ >= cx_list_len(ps))) cx_ll_empty(f64) else cx_ll_concat(cx_ll_of(f64, &[_]f64{ cx_list_at(ps, i_).fwd }), poly_fwds(ps, (i_ +% 1))));
}

fn flatten_vec3(vs_: *CxList(Vec3), i_: i64) *CxList(f64) {
    return (if ((i_ >= cx_list_len(vs_))) cx_ll_empty(f64) else b1: { const v_ = cx_list_at(vs_, i_); break :b1 cx_ll_concat(cx_ll_of(f64, &[_]f64{ v_.right, v_.forward, v_.height }), flatten_vec3(vs_, (i_ +% 1))); });
}

fn poly_verts(ps: *CxList(RailPoly), i_: i64) *CxList(f64) {
    return (if ((i_ >= cx_list_len(ps))) cx_ll_empty(f64) else cx_ll_concat(flatten_vec3(cx_list_at(ps, i_).v_, 0), poly_verts(ps, (i_ +% 1))));
}

fn wire() *CxList(DrawCmd) {
    return cx_ll_concat(cx_ll_concat(cx_ll_concat(rail_draw_all(store_corner(), focal(), camera_w(), 0), rail_draw_all(store_dupe(), focal(), camera_w(), 0)), rail_draw_all(store_near(), focal(), camera_w(), 0)), rail_draw_all(store_single(), focal(), camera_w(), 0));
}

fn cmd_tags(cs: *CxList(DrawCmd), i_: i64) *CxList(i64) {
    return (if ((i_ >= cx_list_len(cs))) cx_ll_empty(i64) else cx_ll_concat(cx_ll_of(i64, &[_]i64{ cx_list_at(cs, i_).tag }), cmd_tags(cs, (i_ +% 1))));
}

fn cmd_counts(cs: *CxList(DrawCmd), i_: i64) *CxList(i64) {
    return (if ((i_ >= cx_list_len(cs))) cx_ll_empty(i64) else cx_ll_concat(cx_ll_of(i64, &[_]i64{ @divTrunc(cx_list_len(cx_list_at(cs, i_).pts), 2) }), cmd_counts(cs, (i_ +% 1))));
}

fn cmd_coords(cs: *CxList(DrawCmd), i_: i64) *CxList(f64) {
    return (if ((i_ >= cx_list_len(cs))) cx_ll_empty(f64) else cx_ll_concat(cx_list_at(cs, i_).pts, cmd_coords(cs, (i_ +% 1))));
}

fn opening() void {
    return b0: { _ = cx_print_line(grade_ints("\x15\x0f\x11\x17\x49\x1f\x10\x17\x1e\x13\x02\x02", poly_counts(), g_rail_polys())); _ = cx_print_line(grade_ints("\x15\x0f\x11\x17\x49\x18\x10\x17\x10\x15\x13\x02", poly_colors(all_polys(), 0), g_rail_colors())); _ = cx_print_line(grade_rel("\x15\x0f\x11\x17\x49\x1c\x1b\x16\x02\x02\x02\x02", poly_fwds(all_polys(), 0), g_rail_fwd(), @as(f64, @bitCast(@as(i64, 4517329193108106637))))); _ = cx_print_line(grade_rel("\x15\x0f\x11\x17\x49\x21\x0d\x15\x0e\x13\x02\x02", poly_verts(all_polys(), 0), g_rail_verts(), @as(f64, @bitCast(@as(i64, 4517329193108106637))))); _ = cx_print_line(grade_ints("\x15\x0f\x11\x17\x49\x0e\x0f\x1d\x13\x02\x02\x02", cmd_tags(wire(), 0), g_rail_tags())); _ = cx_print_line(grade_ints("\x15\x0f\x11\x17\x49\x18\x10\x19\x12\x0e\x13\x02", cmd_counts(wire(), 0), g_rail_counts())); _ = cx_print_line(grade_px("\x15\x0f\x11\x17\x49\x18\x10\x10\x15\x16\x13\x02", cmd_coords(wire(), 0), g_rail_coords(), @as(f64, @bitCast(@as(i64, 4562254508917369340))), @as(f64, @bitCast(@as(i64, 4517329193108106637))))); break :b0; };
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
// mov-rr on bare metal (emit-real-to-bits-builtin), which is to say NOTHING:
// bare metal holds a Real f64 as its own bits in a general register, so the
// value and its bit pattern are the same sixty-four bits and the conversion
// is a register move. Zig separates the two types, so the same identity is
// spelled @bitCast. It is total -- every f64 has a bit pattern -- so unlike
// cx_real_to_int there is nothing to guard: no range to fall out of, and NaN
// payloads and both signed zeroes come through exactly as they went in.
fn cx_real_to_bits(v: f64) i64 {
    return @bitCast(v);
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


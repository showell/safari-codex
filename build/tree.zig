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

const MetricsS = struct {
    bx: f64,
    by: f64,
    ht: f64,
    apex_y: f64,
    foliage: f64,
    w: f64,
};
const Metrics = *MetricsS;

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

fn push_round_poly(color: i64, strength: f64, ps: *CxList(ScreenPt)) *CxList(DrawCmd) {
    return (if ((cx_list_len(ps) < 3)) cx_ll_empty(DrawCmd) else cx_ll_of(DrawCmd, &[_]DrawCmd{ cx_new(DrawCmdS{ .tag = 1, .color = color, .strength = strength, .pts = flatten_screen(ps, 0) }) }));
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
        if ((_tl_i >= cx_list_len(xs))) { return cx_ll_concat(xs, cx_ll_of(ScreenPt, &[_]ScreenPt{ p_ })); } else { if (less_xy(p_, cx_list_at(xs, _tl_i))) { return cx_ll_concat(cx_ll_concat(list_take(ScreenPt, xs, _tl_i), cx_ll_of(ScreenPt, &[_]ScreenPt{ p_ })), list_tail_loop(ScreenPt, xs, (if ((_tl_i > cx_list_len(xs))) cx_list_len(xs) else _tl_i), cx_list_len(xs), cx_ll_empty(ScreenPt))); } else { { const _tj2_2 = (_tl_i +% 1); _tl_i = _tj2_2; continue; } } }
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

fn g_tree_tags() *CxList(i64) {
    @setEvalBranchQuota(1000000);
    return cx_ll_of(i64, &[_]i64{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 });
}

fn g_tree_colors() *CxList(i64) {
    @setEvalBranchQuota(1000000);
    return cx_ll_of(i64, &[_]i64{ 5914146, 3108154, 3108154, 3108154, 3108154, 3108154, 3108154, 3108154, 3108154, 5914146, 3108154, 3108154, 3108154, 3108154, 3108154, 3108154, 3108154, 3108154, 5914146, 3504447, 3504447, 3504447, 3504447, 3504447, 3504447, 3504447, 3504447, 5914146, 3108154, 3108154, 3108154, 3108154, 3108154, 3108154, 3108154, 3108154, 5914146, 3108154, 3108154, 3108154, 3108154, 3108154, 3108154, 3108154, 3108154 });
}

fn g_tree_counts() *CxList(i64) {
    @setEvalBranchQuota(1000000);
    return cx_ll_of(i64, &[_]i64{ 4, 3, 3, 3, 3, 3, 3, 3, 3, 4, 11, 11, 11, 11, 11, 11, 11, 11, 4, 11, 12, 12, 12, 12, 12, 12, 12, 4, 16, 16, 16, 3, 3, 3, 3, 3, 4, 3, 3, 3, 3, 3, 3, 3, 3 });
}

fn g_tree_strengths() *CxList(f64) {
    @setEvalBranchQuota(1000000);
    return cx_ll_of(f64, &[_]f64{ @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4601778099247172813))), @as(f64, @bitCast(@as(i64, 4601778099247172813))), @as(f64, @bitCast(@as(i64, 4601778099247172813))), @as(f64, @bitCast(@as(i64, 4601778099247172813))), @as(f64, @bitCast(@as(i64, 4601778099247172813))), @as(f64, @bitCast(@as(i64, 4601778099247172813))), @as(f64, @bitCast(@as(i64, 4601778099247172813))), @as(f64, @bitCast(@as(i64, 4601778099247172813))), @as(f64, @bitCast(@as(i64, 4607182418800017408))), @as(f64, @bitCast(@as(i64, 4607182418800017408))), @as(f64, @bitCast(@as(i64, 4607182418800017408))), @as(f64, @bitCast(@as(i64, 4607182418800017408))), @as(f64, @bitCast(@as(i64, 4607182418800017408))), @as(f64, @bitCast(@as(i64, 4607182418800017408))), @as(f64, @bitCast(@as(i64, 4607182418800017408))), @as(f64, @bitCast(@as(i64, 4607182418800017408))), @as(f64, @bitCast(@as(i64, 4607182418800017408))), @as(f64, @bitCast(@as(i64, 4607182418800017408))), @as(f64, @bitCast(@as(i64, 4607182418800017408))), @as(f64, @bitCast(@as(i64, 4607182418800017408))), @as(f64, @bitCast(@as(i64, 4607182418800017408))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))) });
}

fn g_tree_coords() *CxList(f64) {
    @setEvalBranchQuota(1000000);
    return cx_ll_of(f64, &[_]f64{ @as(f64, @bitCast(@as(i64, 4646352483595946715))), @as(f64, @bitCast(@as(i64, 4643793179055235772))), @as(f64, @bitCast(@as(i64, 4646400721897846085))), @as(f64, @bitCast(@as(i64, 4643793179055235772))), @as(f64, @bitCast(@as(i64, 4646400721897846085))), @as(f64, @bitCast(@as(i64, 4644088640171695460))), @as(f64, @bitCast(@as(i64, 4646352483595946715))), @as(f64, @bitCast(@as(i64, 4644088640171695460))), @as(f64, @bitCast(@as(i64, 4646376603010779190))), @as(f64, @bitCast(@as(i64, 4643432595888164307))), @as(f64, @bitCast(@as(i64, 4646437383485797066))), @as(f64, @bitCast(@as(i64, 4643549816142215460))), @as(f64, @bitCast(@as(i64, 4646315822183917594))), @as(f64, @bitCast(@as(i64, 4643549816142215460))), @as(f64, @bitCast(@as(i64, 4646376603010779190))), @as(f64, @bitCast(@as(i64, 4643471669540743838))), @as(f64, @bitCast(@as(i64, 4646453012383878926))), @as(f64, @bitCast(@as(i64, 4643588888915185689))), @as(f64, @bitCast(@as(i64, 4646300193285835734))), @as(f64, @bitCast(@as(i64, 4643588888915185689))), @as(f64, @bitCast(@as(i64, 4646376603010779190))), @as(f64, @bitCast(@as(i64, 4643510742489635928))), @as(f64, @bitCast(@as(i64, 4646468641985648226))), @as(f64, @bitCast(@as(i64, 4643627962391843360))), @as(f64, @bitCast(@as(i64, 4646284564035910154))), @as(f64, @bitCast(@as(i64, 4643627962391843360))), @as(f64, @bitCast(@as(i64, 4646376603010779190))), @as(f64, @bitCast(@as(i64, 4643549816142215460))), @as(f64, @bitCast(@as(i64, 4646486008288023832))), @as(f64, @bitCast(@as(i64, 4643667035340735450))), @as(f64, @bitCast(@as(i64, 4646267197733534549))), @as(f64, @bitCast(@as(i64, 4643667035340735450))), @as(f64, @bitCast(@as(i64, 4646376603010779190))), @as(f64, @bitCast(@as(i64, 4643588888915185689))), @as(f64, @bitCast(@as(i64, 4646501637537949412))), @as(f64, @bitCast(@as(i64, 4643706108641471260))), @as(f64, @bitCast(@as(i64, 4646251568483608969))), @as(f64, @bitCast(@as(i64, 4643706108641471260))), @as(f64, @bitCast(@as(i64, 4646376603010779190))), @as(f64, @bitCast(@as(i64, 4643627962391843360))), @as(f64, @bitCast(@as(i64, 4646517266436031271))), @as(f64, @bitCast(@as(i64, 4643745181766285210))), @as(f64, @bitCast(@as(i64, 4646235939585527109))), @as(f64, @bitCast(@as(i64, 4643745181766285210))), @as(f64, @bitCast(@as(i64, 4646376603010779190))), @as(f64, @bitCast(@as(i64, 4643667035340735450))), @as(f64, @bitCast(@as(i64, 4646534632562485017))), @as(f64, @bitCast(@as(i64, 4643784255242942881))), @as(f64, @bitCast(@as(i64, 4646218573634995225))), @as(f64, @bitCast(@as(i64, 4643784255242942881))), @as(f64, @bitCast(@as(i64, 4646376603010779190))), @as(f64, @bitCast(@as(i64, 4643706108641471260))), @as(f64, @bitCast(@as(i64, 4646550261988332457))), @as(f64, @bitCast(@as(i64, 4643823328191834971))), @as(f64, @bitCast(@as(i64, 4646202944033225924))), @as(f64, @bitCast(@as(i64, 4643823328191834971))), @as(f64, @bitCast(@as(i64, 4648961768064975425))), @as(f64, @bitCast(@as(i64, 4643204684192146805))), @as(f64, @bitCast(@as(i64, 4649050904593029923))), @as(f64, @bitCast(@as(i64, 4643204684192146805))), @as(f64, @bitCast(@as(i64, 4649050904593029923))), @as(f64, @bitCast(@as(i64, 4644299871308749367))), @as(f64, @bitCast(@as(i64, 4648961768064975425))), @as(f64, @bitCast(@as(i64, 4644299871308749367))), @as(f64, @bitCast(@as(i64, 4648892175488046040))), @as(f64, @bitCast(@as(i64, 4641429644231108020))), @as(f64, @bitCast(@as(i64, 4648894024514760239))), @as(f64, @bitCast(@as(i64, 4641405909909228057))), @as(f64, @bitCast(@as(i64, 4649006336109100348))), @as(f64, @bitCast(@as(i64, 4640539503894477312))), @as(f64, @bitCast(@as(i64, 4649122136673737717))), @as(f64, @bitCast(@as(i64, 4641381835706313715))), @as(f64, @bitCast(@as(i64, 4649118648143245109))), @as(f64, @bitCast(@as(i64, 4641405909909228057))), @as(f64, @bitCast(@as(i64, 4649098231971535913))), @as(f64, @bitCast(@as(i64, 4641429644231108020))), @as(f64, @bitCast(@as(i64, 4649064272455400423))), @as(f64, @bitCast(@as(i64, 4641449502994402399))), @as(f64, @bitCast(@as(i64, 4649021978553165462))), @as(f64, @bitCast(@as(i64, 4641462640487096648))), @as(f64, @bitCast(@as(i64, 4648977573412683309))), @as(f64, @bitCast(@as(i64, 4641467229232904473))), @as(f64, @bitCast(@as(i64, 4648937472904204365))), @as(f64, @bitCast(@as(i64, 4641462640487096648))), @as(f64, @bitCast(@as(i64, 4648907504087512121))), @as(f64, @bitCast(@as(i64, 4641449502994402399))), @as(f64, @bitCast(@as(i64, 4648863080299312762))), @as(f64, @bitCast(@as(i64, 4641721930661674132))), @as(f64, @bitCast(@as(i64, 4648865143862735772))), @as(f64, @bitCast(@as(i64, 4641694712383269933))), @as(f64, @bitCast(@as(i64, 4649006336109100348))), @as(f64, @bitCast(@as(i64, 4640828305664831746))), @as(f64, @bitCast(@as(i64, 4649152183247892277))), @as(f64, @bitCast(@as(i64, 4641667003282875094))), @as(f64, @bitCast(@as(i64, 4649147528355464924))), @as(f64, @bitCast(@as(i64, 4641694712383269933))), @as(f64, @bitCast(@as(i64, 4649121652360855914))), @as(f64, @bitCast(@as(i64, 4641721930661674132))), @as(f64, @bitCast(@as(i64, 4649078927625984724))), @as(f64, @bitCast(@as(i64, 4641744628451952359))), @as(f64, @bitCast(@as(i64, 4649025915332558481))), @as(f64, @bitCast(@as(i64, 4641759606087306854))), @as(f64, @bitCast(@as(i64, 4648970346014890682))), @as(f64, @bitCast(@as(i64, 4641764830966562045))), @as(f64, @bitCast(@as(i64, 4648920140026982244))), @as(f64, @bitCast(@as(i64, 4641759606087306854))), @as(f64, @bitCast(@as(i64, 4648882504271729053))), @as(f64, @bitCast(@as(i64, 4641744628451952359))), @as(f64, @bitCast(@as(i64, 4648834091015539471))), @as(f64, @bitCast(@as(i64, 4642013156283421766))), @as(f64, @bitCast(@as(i64, 4648836264178281538))), @as(f64, @bitCast(@as(i64, 4641983514505468088))), @as(f64, @bitCast(@as(i64, 4649006336109100348))), @as(f64, @bitCast(@as(i64, 4641117107787029901))), @as(f64, @bitCast(@as(i64, 4649182340652818917))), @as(f64, @bitCast(@as(i64, 4641953226390599138))), @as(f64, @bitCast(@as(i64, 4649176408919528461))), @as(f64, @bitCast(@as(i64, 4641983514505468088))), @as(f64, @bitCast(@as(i64, 4649144988043800111))), @as(f64, @bitCast(@as(i64, 4642013156283421766))), @as(f64, @bitCast(@as(i64, 4649093486039545781))), @as(f64, @bitCast(@as(i64, 4642037793084445808))), @as(f64, @bitCast(@as(i64, 4649029819038641737))), @as(f64, @bitCast(@as(i64, 4642054010265228993))), @as(f64, @bitCast(@as(i64, 4648963186874779907))), @as(f64, @bitCast(@as(i64, 4642059659468011576))), @as(f64, @bitCast(@as(i64, 4648902956947224291))), @as(f64, @bitCast(@as(i64, 4642054010265228993))), @as(f64, @bitCast(@as(i64, 4648857670262299453))), @as(f64, @bitCast(@as(i64, 4642037793084445808))), @as(f64, @bitCast(@as(i64, 4648802003220038177))), @as(f64, @bitCast(@as(i64, 4642303821418122025))), @as(f64, @bitCast(@as(i64, 4648804174623561640))), @as(f64, @bitCast(@as(i64, 4642272316627666243))), @as(f64, @bitCast(@as(i64, 4649006336109100348))), @as(f64, @bitCast(@as(i64, 4641405909909228057))), @as(f64, @bitCast(@as(i64, 4649215980430973049))), @as(f64, @bitCast(@as(i64, 4642239993448715675))), @as(f64, @bitCast(@as(i64, 4649208497594639057))), @as(f64, @bitCast(@as(i64, 4642272316627666243))), @as(f64, @bitCast(@as(i64, 4649170816891350522))), @as(f64, @bitCast(@as(i64, 4642303821418122025))), @as(f64, @bitCast(@as(i64, 4649109548057248053))), @as(f64, @bitCast(@as(i64, 4642329910981869615))), @as(f64, @bitCast(@as(i64, 4649034116809692388))), @as(f64, @bitCast(@as(i64, 4642347037326827575))), @as(f64, @bitCast(@as(i64, 4648955309357752008))), @as(f64, @bitCast(@as(i64, 4642352994392865935))), @as(f64, @bitCast(@as(i64, 4648884037870547475))), @as(f64, @bitCast(@as(i64, 4642347037326827575))), @as(f64, @bitCast(@as(i64, 4648830269464965043))), @as(f64, @bitCast(@as(i64, 4642329910981869615))), @as(f64, @bitCast(@as(i64, 4648773234982082534))), @as(f64, @bitCast(@as(i64, 4642592885663892242))), @as(f64, @bitCast(@as(i64, 4648775294939107405))), @as(f64, @bitCast(@as(i64, 4642561118749864399))), @as(f64, @bitCast(@as(i64, 4649006336109100348))), @as(f64, @bitCast(@as(i64, 4641694712383269933))), @as(f64, @bitCast(@as(i64, 4649246375330411289))), @as(f64, @bitCast(@as(i64, 4642528406079914807))), @as(f64, @bitCast(@as(i64, 4649237378158702593))), @as(f64, @bitCast(@as(i64, 4642561118749864399))), @as(f64, @bitCast(@as(i64, 4649193974805254740))), @as(f64, @bitCast(@as(i64, 4642592885663892242))), @as(f64, @bitCast(@as(i64, 4649123903456982157))), @as(f64, @bitCast(@as(i64, 4642619105761660282))), @as(f64, @bitCast(@as(i64, 4649037949267422164))), @as(f64, @bitCast(@as(i64, 4642636274327864748))), @as(f64, @bitCast(@as(i64, 4648948288932028193))), @as(f64, @bitCast(@as(i64, 4642642238430777526))), @as(f64, @bitCast(@as(i64, 4648867163797537392))), @as(f64, @bitCast(@as(i64, 4642636274327864748))), @as(f64, @bitCast(@as(i64, 4648805780790147495))), @as(f64, @bitCast(@as(i64, 4642619105761660282))), @as(f64, @bitCast(@as(i64, 4648744569658415251))), @as(f64, @bitCast(@as(i64, 4642880907044873747))), @as(f64, @bitCast(@as(i64, 4648746414550965729))), @as(f64, @bitCast(@as(i64, 4642849920872062554))), @as(f64, @bitCast(@as(i64, 4649006336109100348))), @as(f64, @bitCast(@as(i64, 4641983514505468088))), @as(f64, @bitCast(@as(i64, 4649276884579058817))), @as(f64, @bitCast(@as(i64, 4642817895001056136))), @as(f64, @bitCast(@as(i64, 4649266258019078688))), @as(f64, @bitCast(@as(i64, 4642849920872062554))), @as(f64, @bitCast(@as(i64, 4649217049156275248))), @as(f64, @bitCast(@as(i64, 4642880907044873747))), @as(f64, @bitCast(@as(i64, 4649138164914442784))), @as(f64, @bitCast(@as(i64, 4642906399529826989))), @as(f64, @bitCast(@as(i64, 4649041750059217060))), @as(f64, @bitCast(@as(i64, 4642923050182074308))), @as(f64, @bitCast(@as(i64, 4648941332453900650))), @as(f64, @bitCast(@as(i64, 4642928826400440131))), @as(f64, @bitCast(@as(i64, 4648850433276765431))), @as(f64, @bitCast(@as(i64, 4642923050182074308))), @as(f64, @bitCast(@as(i64, 4648781452819949462))), @as(f64, @bitCast(@as(i64, 4642906399529826989))), @as(f64, @bitCast(@as(i64, 4648712841271274845))), @as(f64, @bitCast(@as(i64, 4643168210312820918))), @as(f64, @bitCast(@as(i64, 4648714325172167691))), @as(f64, @bitCast(@as(i64, 4643138723346104430))), @as(f64, @bitCast(@as(i64, 4649006336109100348))), @as(f64, @bitCast(@as(i64, 4642272316627666243))), @as(f64, @bitCast(@as(i64, 4649310915519469647))), @as(f64, @bitCast(@as(i64, 4643108121738480168))), @as(f64, @bitCast(@as(i64, 4649298347309915796))), @as(f64, @bitCast(@as(i64, 4643138723346104430))), @as(f64, @bitCast(@as(i64, 4649242589491974531))), @as(f64, @bitCast(@as(i64, 4643168210312820918))), @as(f64, @bitCast(@as(i64, 4649153901124859514))), @as(f64, @bitCast(@as(i64, 4643192380920914782))), @as(f64, @bitCast(@as(i64, 4649045934360667724))), @as(f64, @bitCast(@as(i64, 4643208126279268256))), @as(f64, @bitCast(@as(i64, 4648933678269674585))), @as(f64, @bitCast(@as(i64, 4643212398013883561))), @as(f64, @bitCast(@as(i64, 4648832009859930417))), @as(f64, @bitCast(@as(i64, 4643208126279268256))), @as(f64, @bitCast(@as(i64, 4648754608639381497))), @as(f64, @bitCast(@as(i64, 4643192380920914782))), @as(f64, @bitCast(@as(i64, 4648684393826831722))), @as(f64, @bitCast(@as(i64, 4643332660836511095))), @as(f64, @bitCast(@as(i64, 4648685445311791597))), @as(f64, @bitCast(@as(i64, 4643319370819563841))), @as(f64, @bitCast(@as(i64, 4649006336109100348))), @as(f64, @bitCast(@as(i64, 4642561118749864399))), @as(f64, @bitCast(@as(i64, 4649341665165339473))), @as(f64, @bitCast(@as(i64, 4643305526824678048))), @as(f64, @bitCast(@as(i64, 4649327227786018402))), @as(f64, @bitCast(@as(i64, 4643319370819563841))), @as(f64, @bitCast(@as(i64, 4649265488712782966))), @as(f64, @bitCast(@as(i64, 4643332660836511095))), @as(f64, @bitCast(@as(i64, 4649167966077602025))), @as(f64, @bitCast(@as(i64, 4643343519613347011))), @as(f64, @bitCast(@as(i64, 4649049667158663559))), @as(f64, @bitCast(@as(i64, 4643350576191013147))), @as(f64, @bitCast(@as(i64, 4648926855228278188))), @as(f64, @bitCast(@as(i64, 4643353017634592391))), @as(f64, @bitCast(@as(i64, 4648815576998946328))), @as(f64, @bitCast(@as(i64, 4643350576191013147))), @as(f64, @bitCast(@as(i64, 4648730614920718309))), @as(f64, @bitCast(@as(i64, 4643343519613347011))), @as(f64, @bitCast(@as(i64, 4638261811901371892))), @as(f64, @bitCast(@as(i64, 4640675496770256461))), @as(f64, @bitCast(@as(i64, 4639581044655186835))), @as(f64, @bitCast(@as(i64, 4640675496770256461))), @as(f64, @bitCast(@as(i64, 4639581044655186835))), @as(f64, @bitCast(@as(i64, 4645300868805738963))), @as(f64, @bitCast(@as(i64, 4638261811901371892))), @as(f64, @bitCast(@as(i64, 4645300868805738963))), @as(f64, @bitCast(@as(i64, 4636208020585865848))), @as(f64, @bitCast(@as(i64, 4626493528054159064))), @as(f64, @bitCast(@as(i64, 4636304118253977191))), @as(f64, @bitCast(@as(i64, 4624744454370828069))), @as(f64, @bitCast(@as(i64, 4639032879526760971))), (-@as(f64, @bitCast(@as(i64, 4632091184746469372)))), @as(f64, @bitCast(@as(i64, 4640540379633498603))), @as(f64, @bitCast(@as(i64, 4629783636421109277))), @as(f64, @bitCast(@as(i64, 4640441023188844392))), @as(f64, @bitCast(@as(i64, 4630455686919928569))), @as(f64, @bitCast(@as(i64, 4640140988455856877))), @as(f64, @bitCast(@as(i64, 4630891518692480187))), @as(f64, @bitCast(@as(i64, 4639686152689146407))), @as(f64, @bitCast(@as(i64, 4631042134685880664))), @as(f64, @bitCast(@as(i64, 4639136859549751375))), @as(f64, @bitCast(@as(i64, 4630891518692480187))), @as(f64, @bitCast(@as(i64, 4638419383000709401))), @as(f64, @bitCast(@as(i64, 4630455686919928569))), @as(f64, @bitCast(@as(i64, 4637377728976608742))), @as(f64, @bitCast(@as(i64, 4629783636421109277))), @as(f64, @bitCast(@as(i64, 4636595389967252261))), @as(f64, @bitCast(@as(i64, 4628217158651395229))), @as(f64, @bitCast(@as(i64, 4635375037261693447))), @as(f64, @bitCast(@as(i64, 4631521841511164543))), @as(f64, @bitCast(@as(i64, 4635476671190752968))), @as(f64, @bitCast(@as(i64, 4630638381912737318))), @as(f64, @bitCast(@as(i64, 4639032879526760971))), (-@as(f64, @bitCast(@as(i64, 4627377724272600341)))), @as(f64, @bitCast(@as(i64, 4640769466839387592))), @as(f64, @bitCast(@as(i64, 4632510899543329514))), @as(f64, @bitCast(@as(i64, 4640917627174722501))), @as(f64, @bitCast(@as(i64, 4633446912630970944))), @as(f64, @bitCast(@as(i64, 4640785574948617302))), @as(f64, @bitCast(@as(i64, 4634201982907533650))), @as(f64, @bitCast(@as(i64, 4640408159226094818))), @as(f64, @bitCast(@as(i64, 4634446045637714809))), @as(f64, @bitCast(@as(i64, 4639842855438180764))), @as(f64, @bitCast(@as(i64, 4634529712667167168))), @as(f64, @bitCast(@as(i64, 4639161930174083273))), @as(f64, @bitCast(@as(i64, 4634446045637714809))), @as(f64, @bitCast(@as(i64, 4638189675494340485))), @as(f64, @bitCast(@as(i64, 4634201982907533650))), @as(f64, @bitCast(@as(i64, 4636882130637089732))), @as(f64, @bitCast(@as(i64, 4633446912630970944))), @as(f64, @bitCast(@as(i64, 4635884970347720144))), @as(f64, @bitCast(@as(i64, 4632510899543329514))), @as(f64, @bitCast(@as(i64, 4634532343050824529))), @as(f64, @bitCast(@as(i64, 4634595330113737956))), @as(f64, @bitCast(@as(i64, 4634630867736922560))), @as(f64, @bitCast(@as(i64, 4634014522543369190))), @as(f64, @bitCast(@as(i64, 4639032879526760971))), @as(f64, @bitCast(@as(i64, 4609394361306640464))), @as(f64, @bitCast(@as(i64, 4641124677704684814))), @as(f64, @bitCast(@as(i64, 4635133513083958497))), @as(f64, @bitCast(@as(i64, 4641290759903630611))), @as(f64, @bitCast(@as(i64, 4635637121779102227))), @as(f64, @bitCast(@as(i64, 4641123365679449621))), @as(f64, @bitCast(@as(i64, 4636039390334693377))), @as(f64, @bitCast(@as(i64, 4640668597466733562))), @as(f64, @bitCast(@as(i64, 4636296498726357634))), @as(f64, @bitCast(@as(i64, 4639995309674285394))), @as(f64, @bitCast(@as(i64, 4636384672170187130))), @as(f64, @bitCast(@as(i64, 4639186368535248733))), @as(f64, @bitCast(@as(i64, 4636296498726357634))), @as(f64, @bitCast(@as(i64, 4637964483550285450))), @as(f64, @bitCast(@as(i64, 4636039390334693377))), @as(f64, @bitCast(@as(i64, 4636391946187272775))), @as(f64, @bitCast(@as(i64, 4635637121779102227))), @as(f64, @bitCast(@as(i64, 4635174545802375935))), @as(f64, @bitCast(@as(i64, 4635133513083958497))), @as(f64, @bitCast(@as(i64, 4632964815379447350))), @as(f64, @bitCast(@as(i64, 4636338615123435407))), @as(f64, @bitCast(@as(i64, 4633133577501646409))), @as(f64, @bitCast(@as(i64, 4635816526610908204))), @as(f64, @bitCast(@as(i64, 4639032879526760971))), @as(f64, @bitCast(@as(i64, 4628217158651395229))), @as(f64, @bitCast(@as(i64, 4641519356287528961))), @as(f64, @bitCast(@as(i64, 4636909570225194370))), @as(f64, @bitCast(@as(i64, 4641700607172969696))), @as(f64, @bitCast(@as(i64, 4637437183106351985))), @as(f64, @bitCast(@as(i64, 4641490998739156525))), @as(f64, @bitCast(@as(i64, 4637854083786763718))), @as(f64, @bitCast(@as(i64, 4640950384880668367))), @as(f64, @bitCast(@as(i64, 4638118455992045713))), @as(f64, @bitCast(@as(i64, 4640159929258883458))), @as(f64, @bitCast(@as(i64, 4638208751475724632))), @as(f64, @bitCast(@as(i64, 4639212809590873491))), @as(f64, @bitCast(@as(i64, 4638118455992045713))), @as(f64, @bitCast(@as(i64, 4637719395547501623))), @as(f64, @bitCast(@as(i64, 4637854083786763718))), @as(f64, @bitCast(@as(i64, 4635853524667009472))), @as(f64, @bitCast(@as(i64, 4637437183106351985))), @as(f64, @bitCast(@as(i64, 4634385188988531360))), @as(f64, @bitCast(@as(i64, 4636909570225194370))), @as(f64, @bitCast(@as(i64, 4631237298034995276))), @as(f64, @bitCast(@as(i64, 4638113112189612862))), @as(f64, @bitCast(@as(i64, 4631360310058904715))), @as(f64, @bitCast(@as(i64, 4637583650017858258))), @as(f64, @bitCast(@as(i64, 4639032879526760971))), @as(f64, @bitCast(@as(i64, 4632510899543329514))), @as(f64, @bitCast(@as(i64, 4641874568560201066))), @as(f64, @bitCast(@as(i64, 4638685624903524197))), @as(f64, @bitCast(@as(i64, 4642065267856922536))), @as(f64, @bitCast(@as(i64, 4638958177123473126))), @as(f64, @bitCast(@as(i64, 4641815153766585818))), @as(f64, @bitCast(@as(i64, 4639162861856256185))), @as(f64, @bitCast(@as(i64, 4641197424912415683))), @as(f64, @bitCast(@as(i64, 4639291763321840830))), @as(f64, @bitCast(@as(i64, 4640303966337653277))), @as(f64, @bitCast(@as(i64, 4639335630141430023))), @as(f64, @bitCast(@as(i64, 4639235992573642822))), @as(f64, @bitCast(@as(i64, 4639291763321840830))), @as(f64, @bitCast(@as(i64, 4637503292430444575))), @as(f64, @bitCast(@as(i64, 4639162861856256185))), @as(f64, @bitCast(@as(i64, 4635374464108272120))), @as(f64, @bitCast(@as(i64, 4638958177123473126))), @as(f64, @bitCast(@as(i64, 4633145513025821359))), @as(f64, @bitCast(@as(i64, 4638685624903524197))), @as(f64, @bitCast(@as(i64, 4629278092726238150))), @as(f64, @bitCast(@as(i64, 4639308148332078878))), @as(f64, @bitCast(@as(i64, 4629392192830172465))), @as(f64, @bitCast(@as(i64, 4639049501327823177))), @as(f64, @bitCast(@as(i64, 4639032879526760971))), @as(f64, @bitCast(@as(i64, 4635133513083958497))), @as(f64, @bitCast(@as(i64, 4642229779777342008))), @as(f64, @bitCast(@as(i64, 4639584648590419894))), @as(f64, @bitCast(@as(i64, 4642426020260823748))), @as(f64, @bitCast(@as(i64, 4639834452354594788))), @as(f64, @bitCast(@as(i64, 4642133135695932125))), @as(f64, @bitCast(@as(i64, 4640028079342917769))), @as(f64, @bitCast(@as(i64, 4641438475508502317))), @as(f64, @bitCast(@as(i64, 4640149188173772179))), @as(f64, @bitCast(@as(i64, 4640444256984483077))), @as(f64, @bitCast(@as(i64, 4640190257483936589))), @as(f64, @bitCast(@as(i64, 4639258612254615011))), @as(f64, @bitCast(@as(i64, 4640149188173772179))), @as(f64, @bitCast(@as(i64, 4637291307995984246))), @as(f64, @bitCast(@as(i64, 4640028079342917769))), @as(f64, @bitCast(@as(i64, 4634900544267771923))), @as(f64, @bitCast(@as(i64, 4639834452354594788))), @as(f64, @bitCast(@as(i64, 4631724669564632475))), @as(f64, @bitCast(@as(i64, 4639584648590419894))), @as(f64, @bitCast(@as(i64, 4625262014795404928))), @as(f64, @bitCast(@as(i64, 4639968194837935135))), @as(f64, @bitCast(@as(i64, 4639032879526760971))), @as(f64, @bitCast(@as(i64, 4636909570225194370))), @as(f64, @bitCast(@as(i64, 4642624458360186156))), @as(f64, @bitCast(@as(i64, 4640472676105506668))), @as(f64, @bitCast(@as(i64, 4642822341602000723))), @as(f64, @bitCast(@as(i64, 4640703781135134952))), @as(f64, @bitCast(@as(i64, 4642479421693405293))), @as(f64, @bitCast(@as(i64, 4640881038242499883))), @as(f64, @bitCast(@as(i64, 4641699545308620055))), @as(f64, @bitCast(@as(i64, 4640991087217831890))), @as(f64, @bitCast(@as(i64, 4640595917812997103))), @as(f64, @bitCast(@as(i64, 4641028264432755834))), @as(f64, @bitCast(@as(i64, 4639283108669994419))), @as(f64, @bitCast(@as(i64, 4640991087217831890))), @as(f64, @bitCast(@as(i64, 4637060449256960583))), @as(f64, @bitCast(@as(i64, 4640881038242499883))), @as(f64, @bitCast(@as(i64, 4634379893388688270))), @as(f64, @bitCast(@as(i64, 4640703780431447510))), @as(f64, @bitCast(@as(i64, 4630145955233255884))), @as(f64, @bitCast(@as(i64, 4640472676105506668))), @as(f64, @bitCast(@as(i64, 4625344555643475467))), @as(f64, @bitCast(@as(i64, 4640213638906564502))), @as(f64, @bitCast(@as(i64, 4613256052070482738))), @as(f64, @bitCast(@as(i64, 4640915998138294788))), @as(f64, @bitCast(@as(i64, 4639032879526760971))), @as(f64, @bitCast(@as(i64, 4638685624903524197))), @as(f64, @bitCast(@as(i64, 4642979669225483377))), @as(f64, @bitCast(@as(i64, 4641360703268749721))), @as(f64, @bitCast(@as(i64, 4643175037840224755))), @as(f64, @bitCast(@as(i64, 4641560986788428188))), @as(f64, @bitCast(@as(i64, 4642784937096033086))), @as(f64, @bitCast(@as(i64, 4641713169753024013))), @as(f64, @bitCast(@as(i64, 4641928647291945322))), @as(f64, @bitCast(@as(i64, 4641807032157976553))), @as(f64, @bitCast(@as(i64, 4640728765557755232))), @as(f64, @bitCast(@as(i64, 4641838635464674184))), @as(f64, @bitCast(@as(i64, 4639304607025028137))), @as(f64, @bitCast(@as(i64, 4641807032157976553))), @as(f64, @bitCast(@as(i64, 4636856771149062985))), @as(f64, @bitCast(@as(i64, 4641713169753024013))), @as(f64, @bitCast(@as(i64, 4633629083658110546))), @as(f64, @bitCast(@as(i64, 4641560986436584467))), @as(f64, @bitCast(@as(i64, 4627749797318589879))), @as(f64, @bitCast(@as(i64, 4641360703268749721))), @as(f64, @bitCast(@as(i64, 4615712223884178171))), @as(f64, @bitCast(@as(i64, 4641133660626722813))), @as(f64, @bitCast(@as(i64, 4650870336412450397))), (-@as(f64, @bitCast(@as(i64, 4650250245807303798)))), @as(f64, @bitCast(@as(i64, 4652629742813478021))), (-@as(f64, @bitCast(@as(i64, 4650250245807303798)))), @as(f64, @bitCast(@as(i64, 4652629742813478021))), @as(f64, @bitCast(@as(i64, 4649467934839891873))), @as(f64, @bitCast(@as(i64, 4650870336412450397))), @as(f64, @bitCast(@as(i64, 4649467934839891873))), @as(f64, @bitCast(@as(i64, 4649133632287708440))), (-@as(f64, @bitCast(@as(i64, 4655184373638122544)))), @as(f64, @bitCast(@as(i64, 4649220579028405060))), (-@as(f64, @bitCast(@as(i64, 4656710009353531503)))), @as(f64, @bitCast(@as(i64, 4649847911456936842))), (-@as(f64, @bitCast(@as(i64, 4657799283208638956)))), @as(f64, @bitCast(@as(i64, 4651243887571503573))), (-@as(f64, @bitCast(@as(i64, 4659151282288570925)))), @as(f64, @bitCast(@as(i64, 4652817363917446368))), (-@as(f64, @bitCast(@as(i64, 4660436403353841094)))), @as(f64, @bitCast(@as(i64, 4653964203803337661))), (-@as(f64, @bitCast(@as(i64, 4660997403433341708)))), @as(f64, @bitCast(@as(i64, 4654619111631650344))), (-@as(f64, @bitCast(@as(i64, 4660436401154817838)))), @as(f64, @bitCast(@as(i64, 4654578419146111005))), (-@as(f64, @bitCast(@as(i64, 4659151280089547670)))), @as(f64, @bitCast(@as(i64, 4654090859626373736))), (-@as(f64, @bitCast(@as(i64, 4657799283208638956)))), @as(f64, @bitCast(@as(i64, 4653454621505500689))), (-@as(f64, @bitCast(@as(i64, 4656710009353531503)))), @as(f64, @bitCast(@as(i64, 4652829191583928680))), (-@as(f64, @bitCast(@as(i64, 4655184373638122544)))), @as(f64, @bitCast(@as(i64, 4652270102675539467))), (-@as(f64, @bitCast(@as(i64, 4654205098444695011)))), @as(f64, @bitCast(@as(i64, 4651357772347080704))), (-@as(f64, @bitCast(@as(i64, 4653663961042750171)))), @as(f64, @bitCast(@as(i64, 4650544488049153399))), (-@as(f64, @bitCast(@as(i64, 4653491306491059110)))), @as(f64, @bitCast(@as(i64, 4649882600872871314))), (-@as(f64, @bitCast(@as(i64, 4653663961042750171)))), @as(f64, @bitCast(@as(i64, 4649393098560068230))), (-@as(f64, @bitCast(@as(i64, 4654205098444695011)))), @as(f64, @bitCast(@as(i64, 4648517261022535352))), (-@as(f64, @bitCast(@as(i64, 4655830861406389718)))), @as(f64, @bitCast(@as(i64, 4649154615719456638))), (-@as(f64, @bitCast(@as(i64, 4657593318292477444)))), @as(f64, @bitCast(@as(i64, 4650937177043716853))), (-@as(f64, @bitCast(@as(i64, 4659464023197831345)))), @as(f64, @bitCast(@as(i64, 4653214248472459556))), (-@as(f64, @bitCast(@as(i64, 4661377431595491787)))), @as(f64, @bitCast(@as(i64, 4655087376481538749))), (-@as(f64, @bitCast(@as(i64, 4661880956573820178)))), @as(f64, @bitCast(@as(i64, 4655995157470686426))), (-@as(f64, @bitCast(@as(i64, 4661377430166126671)))), @as(f64, @bitCast(@as(i64, 4655651907092876152))), (-@as(f64, @bitCast(@as(i64, 4659464021218710415)))), @as(f64, @bitCast(@as(i64, 4654749950876527781))), (-@as(f64, @bitCast(@as(i64, 4657593318292477444)))), @as(f64, @bitCast(@as(i64, 4653806281388044845))), (-@as(f64, @bitCast(@as(i64, 4655830860526780416)))), @as(f64, @bitCast(@as(i64, 4652985841644365834))), (-@as(f64, @bitCast(@as(i64, 4654140675859400360)))), @as(f64, @bitCast(@as(i64, 4652303645696670355))), (-@as(f64, @bitCast(@as(i64, 4653119547096154558)))), @as(f64, @bitCast(@as(i64, 4651257071595529909))), (-@as(f64, @bitCast(@as(i64, 4652575159537838011)))), @as(f64, @bitCast(@as(i64, 4650313386625923254))), (-@as(f64, @bitCast(@as(i64, 4652404329295839756)))), @as(f64, @bitCast(@as(i64, 4649533457816423603))), (-@as(f64, @bitCast(@as(i64, 4652575159537838011)))), @as(f64, @bitCast(@as(i64, 4648923496264235798))), (-@as(f64, @bitCast(@as(i64, 4653119547096154558)))), @as(f64, @bitCast(@as(i64, 4648537947674104981))), (-@as(f64, @bitCast(@as(i64, 4654140676739009662)))), @as(f64, @bitCast(@as(i64, 4647813943280548436))), (-@as(f64, @bitCast(@as(i64, 4654951713459247933)))), @as(f64, @bitCast(@as(i64, 4648377357403798530))), (-@as(f64, @bitCast(@as(i64, 4657362410515235183)))), @as(f64, @bitCast(@as(i64, 4650532094442046038))), (-@as(f64, @bitCast(@as(i64, 4659877072992698420)))), @as(f64, @bitCast(@as(i64, 4653845222131658811))), (-@as(f64, @bitCast(@as(i64, 4662246143637969699)))), @as(f64, @bitCast(@as(i64, 4656884672712966511))), (-@as(f64, @bitCast(@as(i64, 4663223654555039302)))), @as(f64, @bitCast(@as(i64, 4657452415877377950))), (-@as(f64, @bitCast(@as(i64, 4662246140999141792)))), @as(f64, @bitCast(@as(i64, 4656895855625830295))), (-@as(f64, @bitCast(@as(i64, 4659877068594651909)))), @as(f64, @bitCast(@as(i64, 4655488861393202551))), (-@as(f64, @bitCast(@as(i64, 4657362410515235183)))), @as(f64, @bitCast(@as(i64, 4654157939511370396))), (-@as(f64, @bitCast(@as(i64, 4654951712579638631)))), @as(f64, @bitCast(@as(i64, 4653131417863492678))), (-@as(f64, @bitCast(@as(i64, 4653170758389534504)))), @as(f64, @bitCast(@as(i64, 4652333464452015640))), (-@as(f64, @bitCast(@as(i64, 4652090628952732939)))), @as(f64, @bitCast(@as(i64, 4651169647226982184))), (-@as(f64, @bitCast(@as(i64, 4651041421301341644)))), @as(f64, @bitCast(@as(i64, 4650114244487275348))), (-@as(f64, @bitCast(@as(i64, 4650716929031705880)))), @as(f64, @bitCast(@as(i64, 4649230348848924826))), (-@as(f64, @bitCast(@as(i64, 4651041421301341644)))), @as(f64, @bitCast(@as(i64, 4648506032809792504))), (-@as(f64, @bitCast(@as(i64, 4652090628952732939)))), @as(f64, @bitCast(@as(i64, 4647984372596626738))), (-@as(f64, @bitCast(@as(i64, 4653170759269143806)))), @as(f64, @bitCast(@as(i64, 4651955703922646686))), (-@as(f64, @bitCast(@as(i64, 4656710008034117550)))), @as(f64, @bitCast(@as(i64, 4654548672078923851))), (-@as(f64, @bitCast(@as(i64, 4654072565951910799)))), @as(f64, @bitCast(@as(i64, 4646350140316765599))), (-@as(f64, @bitCast(@as(i64, 4654072565951910799)))), @as(f64, @bitCast(@as(i64, 4651955703922646686))), (-@as(f64, @bitCast(@as(i64, 4655830860526780416)))), @as(f64, @bitCast(@as(i64, 4654900331081858705))), (-@as(f64, @bitCast(@as(i64, 4653193418884378316)))), @as(f64, @bitCast(@as(i64, 4644943503953182463))), (-@as(f64, @bitCast(@as(i64, 4653193418884378316)))), @as(f64, @bitCast(@as(i64, 4651955703922646686))), (-@as(f64, @bitCast(@as(i64, 4654951713459247933)))), @as(f64, @bitCast(@as(i64, 4655251990084793559))), (-@as(f64, @bitCast(@as(i64, 4652314270497431880)))), @as(f64, @bitCast(@as(i64, 4643536868821052351))), (-@as(f64, @bitCast(@as(i64, 4652314270497431880)))), @as(f64, @bitCast(@as(i64, 4651955703922646686))), (-@as(f64, @bitCast(@as(i64, 4654072565951910799)))), @as(f64, @bitCast(@as(i64, 4655642722652347014))), (-@as(f64, @bitCast(@as(i64, 4650651832225881077)))), @as(f64, @bitCast(@as(i64, 4640736661986383128))), (-@as(f64, @bitCast(@as(i64, 4650651832225881077)))), @as(f64, @bitCast(@as(i64, 4651955703922646686))), (-@as(f64, @bitCast(@as(i64, 4653193418884378316)))), @as(f64, @bitCast(@as(i64, 4655994381655281867))), (-@as(f64, @bitCast(@as(i64, 4648893536771402157)))), @as(f64, @bitCast(@as(i64, 4637139167252634927))), (-@as(f64, @bitCast(@as(i64, 4648893536771402157)))), @as(f64, @bitCast(@as(i64, 4647263665594461428))), @as(f64, @bitCast(@as(i64, 4643980026015057235))), @as(f64, @bitCast(@as(i64, 4647281257780505844))), @as(f64, @bitCast(@as(i64, 4643980026015057235))), @as(f64, @bitCast(@as(i64, 4647281257780505844))), @as(f64, @bitCast(@as(i64, 4643988890013917575))), @as(f64, @bitCast(@as(i64, 4647263665594461428))), @as(f64, @bitCast(@as(i64, 4643988890013917575))), @as(f64, @bitCast(@as(i64, 4647272461687483636))), @as(f64, @bitCast(@as(i64, 4643969208579858524))), @as(f64, @bitCast(@as(i64, 4647274284941645279))), @as(f64, @bitCast(@as(i64, 4643972725257848803))), @as(f64, @bitCast(@as(i64, 4647270638433321993))), @as(f64, @bitCast(@as(i64, 4643972725257848803))), @as(f64, @bitCast(@as(i64, 4647272461687483636))), @as(f64, @bitCast(@as(i64, 4643970380747214663))), @as(f64, @bitCast(@as(i64, 4647274753949325224))), @as(f64, @bitCast(@as(i64, 4643973897249283082))), @as(f64, @bitCast(@as(i64, 4647270169425642049))), @as(f64, @bitCast(@as(i64, 4643973897249283082))), @as(f64, @bitCast(@as(i64, 4647272461687483636))), @as(f64, @bitCast(@as(i64, 4643971553266414524))), @as(f64, @bitCast(@as(i64, 4647275222781083307))), @as(f64, @bitCast(@as(i64, 4643975069768482942))), @as(f64, @bitCast(@as(i64, 4647269700593883965))), @as(f64, @bitCast(@as(i64, 4643975069768482942))), @as(f64, @bitCast(@as(i64, 4647272461687483636))), @as(f64, @bitCast(@as(i64, 4643972725257848803))), @as(f64, @bitCast(@as(i64, 4647275743685712082))), @as(f64, @bitCast(@as(i64, 4643976241935839081))), @as(f64, @bitCast(@as(i64, 4647269179865177050))), @as(f64, @bitCast(@as(i64, 4643976241935839081))), @as(f64, @bitCast(@as(i64, 4647272461687483636))), @as(f64, @bitCast(@as(i64, 4643973897249283082))), @as(f64, @bitCast(@as(i64, 4647276212869313887))), @as(f64, @bitCast(@as(i64, 4643977414279117081))), @as(f64, @bitCast(@as(i64, 4647268710681575246))), @as(f64, @bitCast(@as(i64, 4643977414279117081))), @as(f64, @bitCast(@as(i64, 4647272461687483636))), @as(f64, @bitCast(@as(i64, 4643975069768482942))), @as(f64, @bitCast(@as(i64, 4647276681525150110))), @as(f64, @bitCast(@as(i64, 4643978586270551360))), @as(f64, @bitCast(@as(i64, 4647268241849817162))), @as(f64, @bitCast(@as(i64, 4643978586270551360))), @as(f64, @bitCast(@as(i64, 4647272461687483636))), @as(f64, @bitCast(@as(i64, 4643976241935839081))), @as(f64, @bitCast(@as(i64, 4647277202781622606))), @as(f64, @bitCast(@as(i64, 4643979758261985639))), @as(f64, @bitCast(@as(i64, 4647267720593344666))), @as(f64, @bitCast(@as(i64, 4643979758261985639))), @as(f64, @bitCast(@as(i64, 4647272461687483636))), @as(f64, @bitCast(@as(i64, 4643977414279117081))), @as(f64, @bitCast(@as(i64, 4647277671613380690))), @as(f64, @bitCast(@as(i64, 4643980930781185499))), @as(f64, @bitCast(@as(i64, 4647267251937508443))), @as(f64, @bitCast(@as(i64, 4643980930781185499))) });
}

fn case_far() *CxList(DrawCmd) {
    return tree_draw((@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4621256167635550208)))), @as(f64, @bitCast(@as(i64, 4639129828656676864))), @as(f64, @bitCast(@as(i64, 4619567317775286272))), 3108154, focal(), camera_w(), false, false, @as(f64, @bitCast(@as(i64, 0))));
}

fn case_mid() *CxList(DrawCmd) {
    return tree_draw(@as(f64, @bitCast(@as(i64, 4622945017495814144))), @as(f64, @bitCast(@as(i64, 4631670741773844480))), @as(f64, @bitCast(@as(i64, 4620974692658839552))), 3108154, focal(), camera_w(), false, true, @as(f64, @bitCast(@as(i64, 4601778099247172813))));
}

fn case_near() *CxList(DrawCmd) {
    return tree_draw((@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4617878467915022336)))), @as(f64, @bitCast(@as(i64, 4622382067542392832))), @as(f64, @bitCast(@as(i64, 4618722892845154304))), 3504447, focal(), camera_w(), true, true, @as(f64, @bitCast(@as(i64, 4607182418800017408))));
}

fn case_close() *CxList(DrawCmd) {
    return tree_draw(@as(f64, @bitCast(@as(i64, 4609434218613702656))), @as(f64, @bitCast(@as(i64, 4611686018427387904))), @as(f64, @bitCast(@as(i64, 4621256167635550208))), 3108154, focal(), camera_w(), true, true, @as(f64, @bitCast(@as(i64, 4607182418800017408))));
}

fn case_tiny() *CxList(DrawCmd) {
    return tree_draw(@as(f64, @bitCast(@as(i64, 4630826316843712512))), @as(f64, @bitCast(@as(i64, 4661014508095930368))), @as(f64, @bitCast(@as(i64, 4618441417868443648))), 3108154, focal(), camera_w(), false, false, @as(f64, @bitCast(@as(i64, 0))));
}

fn all_cmds() *CxList(DrawCmd) {
    return cx_ll_concat(cx_ll_concat(cx_ll_concat(cx_ll_concat(case_far(), case_mid()), case_near()), case_close()), case_tiny());
}

fn cmd_tags(cs: *CxList(DrawCmd), i_: i64) *CxList(i64) {
    return (if ((i_ >= cx_list_len(cs))) cx_ll_empty(i64) else cx_ll_concat(cx_ll_of(i64, &[_]i64{ cx_list_at(cs, i_).tag }), cmd_tags(cs, (i_ +% 1))));
}

fn cmd_colors(cs: *CxList(DrawCmd), i_: i64) *CxList(i64) {
    return (if ((i_ >= cx_list_len(cs))) cx_ll_empty(i64) else cx_ll_concat(cx_ll_of(i64, &[_]i64{ cx_list_at(cs, i_).color }), cmd_colors(cs, (i_ +% 1))));
}

fn cmd_counts(cs: *CxList(DrawCmd), i_: i64) *CxList(i64) {
    return (if ((i_ >= cx_list_len(cs))) cx_ll_empty(i64) else cx_ll_concat(cx_ll_of(i64, &[_]i64{ @divTrunc(cx_list_len(cx_list_at(cs, i_).pts), 2) }), cmd_counts(cs, (i_ +% 1))));
}

fn cmd_strengths(cs: *CxList(DrawCmd), i_: i64) *CxList(f64) {
    return (if ((i_ >= cx_list_len(cs))) cx_ll_empty(f64) else cx_ll_concat(cx_ll_of(f64, &[_]f64{ cx_list_at(cs, i_).strength }), cmd_strengths(cs, (i_ +% 1))));
}

fn cmd_coords(cs: *CxList(DrawCmd), i_: i64) *CxList(f64) {
    return (if ((i_ >= cx_list_len(cs))) cx_ll_empty(f64) else cx_ll_concat(cx_list_at(cs, i_).pts, cmd_coords(cs, (i_ +% 1))));
}

fn opening() void {
    return b0: { _ = cx_print_line(grade_ints("\x0e\x15\x0d\x0d\x49\x0e\x0f\x1d\x13\x02\x02\x02\x02\x02", cmd_tags(all_cmds(), 0), g_tree_tags())); _ = cx_print_line(grade_ints("\x0e\x15\x0d\x0d\x49\x18\x10\x17\x10\x15\x13\x02\x02\x02", cmd_colors(all_cmds(), 0), g_tree_colors())); _ = cx_print_line(grade_ints("\x0e\x15\x0d\x0d\x49\x18\x10\x19\x12\x0e\x13\x02\x02\x02", cmd_counts(all_cmds(), 0), g_tree_counts())); _ = cx_print_line(grade_rel("\x0e\x15\x0d\x0d\x49\x13\x0e\x15\x0d\x12\x1d\x0e\x14\x13", cmd_strengths(all_cmds(), 0), g_tree_strengths(), @as(f64, @bitCast(@as(i64, 4517329193108106637))))); _ = cx_print_line(grade_px("\x0e\x15\x0d\x0d\x49\x18\x10\x10\x15\x16\x13\x02\x02\x02", cmd_coords(all_cmds(), 0), g_tree_coords(), @as(f64, @bitCast(@as(i64, 4562254508917369340))), @as(f64, @bitCast(@as(i64, 4517329193108106637))))); break :b0; };
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


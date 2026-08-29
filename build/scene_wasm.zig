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

fn ridge(far: f64, i_: i64, x: f64, hs: *CxList(f64)) *CxList(Vec3) {
    return (if ((i_ >= cx_list_len(hs))) cx_ll_empty(Vec3) else b1: { const h_: f64 = cx_list_at(hs, i_); break :b1 cx_ll_concat(cx_ll_of(Vec3, &[_]Vec3{ cx_new(Vec3S{ .right = x, .forward = far, .height = h_ }) }), ridge(far, (i_ +% 1), (x + @as(f64, @bitCast(@as(i64, 4643281584563159040)))), hs)); });
}

fn ridge_poly(far: f64, color: i64, hs: *CxList(f64)) *CxList(DrawCmd) {
    return b0: { const top_ = ridge(far, 0, (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4655631299166339072)))), hs); break :b0 b1: { const base_ = cx_ll_of(Vec3, &[_]Vec3{ cx_new(Vec3S{ .right = @as(f64, @bitCast(@as(i64, 4655631299166339072))), .forward = far, .height = @as(f64, @bitCast(@as(i64, 0))) }), cx_new(Vec3S{ .right = (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4655631299166339072)))), .forward = far, .height = @as(f64, @bitCast(@as(i64, 0))) }) }); break :b1 solid(color, cx_ll_concat(top_, base_)); }; };
}

fn mountains_far() *CxList(DrawCmd) {
    return ridge_poly(@as(f64, @bitCast(@as(i64, 4662439475165528064))), 7042462, cx_ll_of(f64, &[_]f64{ @as(f64, @bitCast(@as(i64, 4633641066610819072))), @as(f64, @bitCast(@as(i64, 4642648265865560064))), @as(f64, @bitCast(@as(i64, 4638144666238189568))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4639481672377565184))), @as(f64, @bitCast(@as(i64, 4645392646888488960))), @as(f64, @bitCast(@as(i64, 4637440978796412928))), @as(f64, @bitCast(@as(i64, 4643281584563159040))), @as(f64, @bitCast(@as(i64, 4635329916471083008))), @as(f64, @bitCast(@as(i64, 4641240890982006784))), @as(f64, @bitCast(@as(i64, 4636033603912859648))), @as(f64, @bitCast(@as(i64, 4640185359819341824))), @as(f64, @bitCast(@as(i64, 4633641066610819072))), @as(f64, @bitCast(@as(i64, 4641592734702895104))), @as(f64, @bitCast(@as(i64, 4634626229029306368))) }));
}

fn mountains_near() *CxList(DrawCmd) {
    return ridge_poly(@as(f64, @bitCast(@as(i64, 4659695094142599168))), 5466506, cx_ll_of(f64, &[_]f64{ @as(f64, @bitCast(@as(i64, 4630826316843712512))), @as(f64, @bitCast(@as(i64, 4638777984935788544))), @as(f64, @bitCast(@as(i64, 4641240890982006784))), @as(f64, @bitCast(@as(i64, 4636033603912859648))), @as(f64, @bitCast(@as(i64, 4640185359819341824))), @as(f64, @bitCast(@as(i64, 4633641066610819072))), @as(f64, @bitCast(@as(i64, 4641944578423783424))), @as(f64, @bitCast(@as(i64, 4636737291354636288))), @as(f64, @bitCast(@as(i64, 4633641066610819072))), @as(f64, @bitCast(@as(i64, 4640889047261118464))), @as(f64, @bitCast(@as(i64, 4635329916471083008))), @as(f64, @bitCast(@as(i64, 4639129828656676864))), @as(f64, @bitCast(@as(i64, 4632233691727265792))), @as(f64, @bitCast(@as(i64, 4639833516098453504))), @as(f64, @bitCast(@as(i64, 4630826316843712512))) }));
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

fn frame() *CxList(DrawCmd) {
    return b0: { const ground = cx_ll_concat(cx_ll_concat(cx_ll_concat(mountains_far(), mountains_near()), road()), dashes(@as(f64, @bitCast(@as(i64, 4622945017495814144))), 24)); break :b0 b1: { const water = cx_ll_concat(bank_poly(), pond_poly()); break :b1 b2: { const far_trees = cx_ll_concat(cx_ll_concat(cx_ll_concat(conifer((@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4628011567076605952)))), @as(f64, @bitCast(@as(i64, 4640009437958897664))), @as(f64, @bitCast(@as(i64, 4622382067542392832))), false), conifer(@as(f64, @bitCast(@as(i64, 4626604192193052672))), @as(f64, @bitCast(@as(i64, 4638848353679966208))), @as(f64, @bitCast(@as(i64, 4621537642612260864))), false)), conifer((@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4625478292286210048)))), @as(f64, @bitCast(@as(i64, 4637018766331346944))), @as(f64, @bitCast(@as(i64, 4622100592565682176))), false)), conifer(@as(f64, @bitCast(@as(i64, 4624633867356078080))), @as(f64, @bitCast(@as(i64, 4635189178982727680))), @as(f64, @bitCast(@as(i64, 4620693217682128896))), false)); break :b2 b3: { const mid_trees = cx_ll_concat(cx_ll_concat(conifer((@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4623507967449235456)))), @as(f64, @bitCast(@as(i64, 4633218854145753088))), @as(f64, @bitCast(@as(i64, 4621256167635550208))), false), conifer(@as(f64, @bitCast(@as(i64, 4623226492472524800))), @as(f64, @bitCast(@as(i64, 4631389266797133824))), @as(f64, @bitCast(@as(i64, 4620130267728707584))), false)), conifer((@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4622100592565682176)))), @as(f64, @bitCast(@as(i64, 4629841154425225216))), @as(f64, @bitCast(@as(i64, 4620974692658839552))), false)); break :b3 b4: { const near_trees = cx_ll_concat(cx_ll_concat(conifer(@as(f64, @bitCast(@as(i64, 4621537642612260864))), @as(f64, @bitCast(@as(i64, 4627167142146473984))), @as(f64, @bitCast(@as(i64, 4619567317775286272))), true), conifer((@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4620693217682128896)))), @as(f64, @bitCast(@as(i64, 4624915342332788736))), @as(f64, @bitCast(@as(i64, 4619004367821864960))), true)), conifer(@as(f64, @bitCast(@as(i64, 4620693217682128896))), @as(f64, @bitCast(@as(i64, 4621537642612260864))), @as(f64, @bitCast(@as(i64, 4618441417868443648))), true)); break :b4 cx_ll_concat(cx_ll_concat(cx_ll_concat(cx_ll_concat(ground, water), far_trees), mid_trees), near_trees); }; }; }; }; };
}

fn opening() void {
    return b0: { _ = cx_print_line(cx_concat("\x18\x1a\x16\x13\x02", cx_show_int(cx_list_len(frame())))); break :b0; };
}

fn cx_entry() void {
    opening();
}

// The hosted entry spawned a thread for its 512 MB stack; freestanding is
// single-threaded and the browser calls renderFrame directly, so cx_entry is
// simply unused here.
comptime {
    _ = cx_entry;
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
const cx_heap_reserve: usize = 32 * 1024 * 1024;
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
var cx_heap_static: [cx_heap_reserve]u8 align(4096) = undefined;
fn cx_heap_base() [*]u8 {
    return &cx_heap_static;
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
// There is no stdout in a freestanding module. The Codex program's own
// print-line calls become no-ops; the frame leaves through linear memory.
fn cx_print_line(s: []const u8) void {
    _ = s;
}
fn cx_print(s: []const u8) void {
    _ = s;
}


// ========================================================================
// THE WASM SHIM. Appended to the transpiled program by harness/wasmify.py.
//
// The Codex side is pure: `frame()` returns a list of draw commands holding
// f64 screen coordinates. The browser wants wasm/paint.zig's wire --
// [tag u32][color u32][nPoints u32][x f32][y f32]... in linear memory -- so
// this walks the one and writes the other.
//
// THE NARROWING TO f32 HAPPENS HERE, and only here. Codex Real is f64 in every
// plug while the game computes in f32, and the buffer is the only place the
// game's width is actually load-bearing (blitter.js reads these words back
// through a Float32Array). Putting @floatCast at the seam is what the
// hand-written zig already does with its @bitCast, so the two agree about
// where the precision is allowed to change.
//
// The buffer is fixed and pre-sized, exactly as paint.zig's is: a wasm module
// that grows memory mid-frame invalidates the views the blitter is holding.

const CAP_WORDS: usize = (1 << 20) / 4;
var cx_paint: [CAP_WORDS]u32 = undefined;
var cx_paint_high: usize = 0;

pub export fn renderFrame() u32 {
    var w: usize = 0;
    const cmds = frame();
    for (cmds.items.items) |cmd| {
        const pts = cmd.pts.items.items;
        const n = pts.len / 2;
        // tag 1 carries a strength word between the colour and the count; tag 0
        // does not. Same split paint.pushPoly / pushRoundPoly makes.
        const head: usize = if (cmd.tag == 1) 4 else 3;
        if (w + head + pts.len > CAP_WORDS) break; // bounded, like paint.push
        cx_paint[w] = @intCast(cmd.tag);
        cx_paint[w + 1] = @intCast(cmd.color);
        if (cmd.tag == 1) {
            cx_paint[w + 2] = @bitCast(@as(f32, @floatCast(cmd.strength)));
            cx_paint[w + 3] = @intCast(n);
        } else {
            cx_paint[w + 2] = @intCast(n);
        }
        w += head;
        for (pts) |v| {
            cx_paint[w] = @bitCast(@as(f32, @floatCast(v)));
            w += 1;
        }
    }
    if (w > cx_paint_high) cx_paint_high = w;
    return @intCast(w * 4);
}

pub export fn bufPtr() u32 {
    return @intCast(@intFromPtr(&cx_paint));
}
pub export fn bufHighWater() u32 {
    return @intCast(cx_paint_high * 4);
}
pub export fn bufCap() u32 {
    return @intCast(CAP_WORDS * 4);
}

// The pose exports. This frame is static -- one frame is the whole point of the
// proof -- so the rider does not move and the camera does not bank. They exist
// because blitter.js destructures them, and a missing export is a TypeError
// before the first pixel.
pub export fn advance() void {}
pub export fn back() void {}
pub export fn riderTilt() f32 {
    return 0.0;
}
pub export fn riderSeg() u32 {
    return 0;
}
pub export fn clock() u32 {
    return 0;
}

// Sky, horizon and sun come from the blitter's own drawBackground/drawSun, so
// the Codex frame never draws them. Late afternoon, sun low and left of centre.
pub export fn skyTop() u32 {
    return 0x3f6fa8;
}
pub export fn skyHorizon() u32 {
    return 0xe8a163;
}
pub export fn sunVisible() u32 {
    return 1;
}
pub export fn sunX() f32 {
    return 360.0;
}
pub export fn sunY() f32 {
    return 236.0;
}
pub export fn sunScale() f32 {
    return 1.0;
}

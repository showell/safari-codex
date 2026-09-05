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

fn camera_h() f64 {
    return @as(f64, @bitCast(@as(i64, 4648488871632306176)));
}

fn eye_h() f64 {
    return @as(f64, @bitCast(@as(i64, 4608083138725491507)));
}

fn project(_arg_p: Vec3, cf: f64, view_w: f64) ScreenPt {
    return cx_new(ScreenPtS{ .x = ((view_w / @as(f64, @bitCast(@as(i64, 4611686018427387904)))) + ((_arg_p.right / _arg_p.forward) * cf)), .y = ((camera_h() / @as(f64, @bitCast(@as(i64, 4611686018427387904)))) - (((_arg_p.height - eye_h()) / _arg_p.forward) * cf)) });
}

fn flatten_screen(ps: *CxList(ScreenPt), i_: i64) *CxList(f64) {
    return (if ((i_ >= cx_list_len(ps))) cx_ll_empty(f64) else b1: { const _v1_p = cx_list_at(ps, i_); break :b1 cx_ll_concat(cx_ll_of(f64, &[_]f64{ _v1_p.x, _v1_p.y }), flatten_screen(ps, (i_ +% 1))); });
}

fn push_poly(color: i64, ps: *CxList(ScreenPt)) *CxList(DrawCmd) {
    return (if ((cx_list_len(ps) < 3)) cx_ll_empty(DrawCmd) else cx_ll_of(DrawCmd, &[_]DrawCmd{ cx_new(DrawCmdS{ .tag = 0, .color = color, .color2 = 0, .strength = @as(f64, @bitCast(@as(i64, 0))), .geom = cx_ll_empty(f64), .pts = flatten_screen(ps, 0) }) }));
}

fn push_round_poly(color: i64, strength: f64, ps: *CxList(ScreenPt)) *CxList(DrawCmd) {
    return (if ((cx_list_len(ps) < 3)) cx_ll_empty(DrawCmd) else cx_ll_of(DrawCmd, &[_]DrawCmd{ cx_new(DrawCmdS{ .tag = 1, .color = color, .color2 = 0, .strength = strength, .geom = cx_ll_empty(f64), .pts = flatten_screen(ps, 0) }) }));
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

fn draw_trunk(_arg_m: Metrics, round_trunk: bool) *CxList(DrawCmd) {
    return b0: { const trunk_w: f64 = @as(f64, (if (((_arg_m.ht * @as(f64, @bitCast(@as(i64, 4590429028186199163)))) > @as(f64, @bitCast(@as(i64, 4607182418800017408))))) (_arg_m.ht * @as(f64, @bitCast(@as(i64, 4590429028186199163)))) else @as(f64, @bitCast(@as(i64, 4607182418800017408))))); break :b0 b1: { const trunk_h: f64 = ((_arg_m.ht * visible_trunk()) + (_arg_m.ht * @as(f64, @bitCast(@as(i64, 4587366580439587226))))); break :b1 b2: { const tx: f64 = (_arg_m.bx - (trunk_w / @as(f64, @bitCast(@as(i64, 4611686018427387904))))); break :b2 b3: { const pts = cx_ll_of(ScreenPt, &[_]ScreenPt{ cx_new(ScreenPtS{ .x = tx, .y = (_arg_m.by - trunk_h) }), cx_new(ScreenPtS{ .x = (tx + trunk_w), .y = (_arg_m.by - trunk_h) }), cx_new(ScreenPtS{ .x = (tx + trunk_w), .y = _arg_m.by }), cx_new(ScreenPtS{ .x = tx, .y = _arg_m.by }) }); break :b3 (if (round_trunk) push_round_poly(trunk_color(), @as(f64, @bitCast(@as(i64, 4607182418800017408))), pts) else push_poly(trunk_color(), pts)); }; }; }; };
}

fn tier_triangle(_arg_m: Metrics, k_: i64, color: i64) *CxList(DrawCmd) {
    return b0: { const tri = cx_ll_of(ScreenPt, &[_]ScreenPt{ cx_new(ScreenPtS{ .x = _arg_m.bx, .y = (_arg_m.apex_y + (_arg_m.foliage * cx_list_at(tier_top(), k_))) }), cx_new(ScreenPtS{ .x = (_arg_m.bx + (_arg_m.w * cx_list_at(tier_wide(), k_))), .y = (_arg_m.apex_y + (_arg_m.foliage * cx_list_at(tier_bot(), k_))) }), cx_new(ScreenPtS{ .x = (_arg_m.bx - (_arg_m.w * cx_list_at(tier_wide(), k_))), .y = (_arg_m.apex_y + (_arg_m.foliage * cx_list_at(tier_bot(), k_))) }) }); break :b0 push_poly(color, tri); };
}

fn less_xy(a_: ScreenPt, b_: ScreenPt) bool {
    return (if ((a_.x < b_.x)) true else (if ((a_.x == b_.x)) (a_.y < b_.y) else false));
}

fn hull_insert(_arg_p: ScreenPt, xs: *CxList(ScreenPt), i_: i64) *CxList(ScreenPt) {
    var _tl_i = i_;
    while (true) {
        if ((_tl_i >= cx_list_len(xs))) { return cx_ll_concat(xs, cx_ll_of(ScreenPt, &[_]ScreenPt{ _arg_p })); } else { if (less_xy(_arg_p, cx_list_at(xs, _tl_i))) { return cx_ll_concat(cx_ll_concat(list_take(ScreenPt, xs, _tl_i), cx_ll_of(ScreenPt, &[_]ScreenPt{ _arg_p })), list_tail_loop(ScreenPt, xs, (if ((_tl_i > cx_list_len(xs))) cx_list_len(xs) else _tl_i), cx_list_len(xs), cx_ll_empty(ScreenPt))); } else { { const _tj2_2 = (_tl_i +% 1); _tl_i = _tj2_2; continue; } } }
    }
}

fn sort_pts(src: *CxList(ScreenPt), i_: i64, acc_: *CxList(ScreenPt)) *CxList(ScreenPt) {
    var _tl_i = i_;
    var _tl_acc = acc_;
    while (true) {
        if ((_tl_i >= cx_list_len(src))) { return _tl_acc; } else { { const _tj1_1 = (_tl_i +% 1); const _tj1_2 = hull_insert(cx_list_at(src, _tl_i), _tl_acc, 0); _tl_i = _tj1_1; _tl_acc = _tj1_2; continue; } }
    }
}

fn hull_trim(hull: *CxList(ScreenPt), _arg_p: ScreenPt) *CxList(ScreenPt) {
    var _tl_hull = hull;
    while (true) {
        const n_: i64 = cx_list_len(_tl_hull); if ((n_ < 2)) { return _tl_hull; } else { const a_ = cx_list_at(_tl_hull, (n_ -% 2)); const b_ = cx_list_at(_tl_hull, (n_ -% 1)); const cr: f64 = (((b_.x - a_.x) * (_arg_p.y - a_.y)) - ((b_.y - a_.y) * (_arg_p.x - a_.x))); if ((cr <= @as(f64, @bitCast(@as(i64, 0))))) { { const _tj6_0 = list_take(ScreenPt, _tl_hull, (n_ -% 1)); _tl_hull = _tj6_0; continue; } } else { return _tl_hull; } }
    }
}

fn lower_chain(ps: *CxList(ScreenPt), i_: i64, hull: *CxList(ScreenPt)) *CxList(ScreenPt) {
    var _tl_i = i_;
    var _tl_hull = hull;
    while (true) {
        if ((_tl_i >= cx_list_len(ps))) { return _tl_hull; } else { const _v1_p = cx_list_at(ps, _tl_i); { const _tj2_1 = (_tl_i +% 1); const _tj2_2 = cx_ll_concat(hull_trim(_tl_hull, _v1_p), cx_ll_of(ScreenPt, &[_]ScreenPt{ _v1_p })); _tl_i = _tj2_1; _tl_hull = _tj2_2; continue; } }
    }
}

fn upper_chain(ps: *CxList(ScreenPt), i_: i64, hull: *CxList(ScreenPt)) *CxList(ScreenPt) {
    var _tl_i = i_;
    var _tl_hull = hull;
    while (true) {
        if ((_tl_i < 0)) { return _tl_hull; } else { const _v1_p = cx_list_at(ps, _tl_i); { const _tj2_1 = (_tl_i -% 1); const _tj2_2 = cx_ll_concat(hull_trim(_tl_hull, _v1_p), cx_ll_of(ScreenPt, &[_]ScreenPt{ _v1_p })); _tl_i = _tj2_1; _tl_hull = _tj2_2; continue; } }
    }
}

fn convex_hull_pts(ps: *CxList(ScreenPt)) *CxList(ScreenPt) {
    return b0: { const n_: i64 = cx_list_len(ps); break :b0 (if ((n_ < 3)) ps else b2: { const sorted = sort_pts(ps, 0, cx_ll_empty(ScreenPt)); break :b2 b3: { const lo = lower_chain(sorted, 0, cx_ll_empty(ScreenPt)); break :b3 b4: { const up = upper_chain(sorted, (n_ -% 1), cx_ll_empty(ScreenPt)); break :b4 cx_ll_concat(list_take(ScreenPt, lo, (cx_list_len(lo) -% 1)), list_take(ScreenPt, up, (cx_list_len(up) -% 1))); }; }; }); };
}

fn g_abs(x: f64) f64 {
    return (if ((x < @as(f64, @bitCast(@as(i64, 0))))) (@as(f64, @bitCast(@as(i64, 0))) - x) else x);
}

fn g_finite(x: f64) bool {
    return ((cx_real_to_bits(x) & 9223372036854775807) < 9218868437227405312);
}

fn first_real_diff(got: *CxList(f64), want: *CxList(f64), tol: f64, i_: i64) i64 {
    var _tl_i = i_;
    while (true) {
        if ((_tl_i >= cx_list_len(got))) { return (0 -% 1); } else { if (g_finite(cx_list_at(got, _tl_i))) { if ((g_abs((cx_list_at(got, _tl_i) - cx_list_at(want, _tl_i))) > tol)) { return _tl_i; } else { { const _tj3_3 = (_tl_i +% 1); _tl_i = _tj3_3; continue; } } } else { return _tl_i; } }
    }
}

fn grade_reals(name: []const u8, got: *CxList(f64), want: *CxList(f64), tol: f64) []const u8 {
    return (if ((cx_list_len(got) != cx_list_len(want))) cx_concat(cx_concat(cx_concat(cx_concat(name, "\x02\x3a\x29\x30\x02\x17\x0d\x12\x1d\x0e\x14\x02"), cx_show_int(cx_list_len(got))), "\x02\x1b\x0f\x12\x0e\x02"), cx_show_int(cx_list_len(want))) else b1: { const i_: i64 = first_real_diff(got, want, tol, 0); break :b1 (if ((i_ < 0)) cx_concat(cx_concat(name, "\x02\x10\x22\x02"), cx_show_int(cx_list_len(got))) else cx_concat(cx_concat(name, "\x02\x3a\x29\x30\x02\x0f\x0e\x02"), cx_show_int(i_))); });
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

fn table_got() *CxList(f64) {
    return cx_ll_concat(cx_ll_concat(tier_top(), tier_bot()), tier_wide());
}

fn table_want() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4591870180066957722))), @as(f64, @bitCast(@as(i64, 4596373779694328218))), @as(f64, @bitCast(@as(i64, 4599075939470750515))), @as(f64, @bitCast(@as(i64, 4600877379321698714))), @as(f64, @bitCast(@as(i64, 4602678819172646912))), @as(f64, @bitCast(@as(i64, 4603579539098121011))), @as(f64, @bitCast(@as(i64, 4604480259023595110))), @as(f64, @bitCast(@as(i64, 4599075939470750515))), @as(f64, @bitCast(@as(i64, 4600877379321698714))), @as(f64, @bitCast(@as(i64, 4602678819172646912))), @as(f64, @bitCast(@as(i64, 4603579539098121011))), @as(f64, @bitCast(@as(i64, 4604480259023595110))), @as(f64, @bitCast(@as(i64, 4605380978949069210))), @as(f64, @bitCast(@as(i64, 4606281698874543309))), @as(f64, @bitCast(@as(i64, 4607182418800017408))), @as(f64, @bitCast(@as(i64, 4599976659396224614))), @as(f64, @bitCast(@as(i64, 4601597955262077993))), @as(f64, @bitCast(@as(i64, 4602949035150289142))), @as(f64, @bitCast(@as(i64, 4603849755075763241))), @as(f64, @bitCast(@as(i64, 4604660403008689930))), @as(f64, @bitCast(@as(i64, 4605471050941616620))), @as(f64, @bitCast(@as(i64, 4606371770867090719))), @as(f64, @bitCast(@as(i64, 4607182418800017408))) });
}

fn size_got() *CxList(i64) {
    return cx_ll_of(i64, &[_]i64{ cx_list_len(tier_top()), cx_list_len(tier_bot()), cx_list_len(tier_wide()), ring_n(), trunk_color() });
}

fn size_want() *CxList(i64) {
    return cx_ll_of(i64, &[_]i64{ 8, 8, 8, 16, 5914146 });
}

fn frac_got() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ visible_trunk(), crown_h(), crown_w(), min_cone_forward() });
}

fn frac_want() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ @as(f64, @bitCast(@as(i64, 4601597955262077993))), @as(f64, @bitCast(@as(i64, 4604011884662348579))), @as(f64, @bitCast(@as(i64, 4598859766688636731))), @as(f64, @bitCast(@as(i64, 4600877379321698714))) });
}

fn m_() Metrics {
    return metrics(@as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4611686018427387904))), @as(f64, @bitCast(@as(i64, 4616189618054758400))), @as(f64, @bitCast(@as(i64, 4647503709213818880))), @as(f64, @bitCast(@as(i64, 4651655465120301056))));
}

fn metric_got() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ m_().bx, m_().by, m_().ht, m_().foliage, m_().apex_y, m_().w });
}

fn metric_want() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ @as(f64, @bitCast(@as(i64, 4647151865492930560))), @as(f64, @bitCast(@as(i64, 4648488871632306176))), @as(f64, @bitCast(@as(i64, 4652007308841189376))), @as(f64, @bitCast(@as(i64, 4648911084097372160))), (-@as(f64, @bitCast(@as(i64, 4647292602981285888)))), @as(f64, @bitCast(@as(i64, 4643774165772402688))) });
}

fn trunk() *CxList(DrawCmd) {
    return draw_trunk(m_(), false);
}

fn trunk_got() *CxList(f64) {
    return cx_list_at(trunk(), 0).pts;
}

fn trunk_want() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ @as(f64, @bitCast(@as(i64, 4646448178051153920))), @as(f64, @bitCast(@as(i64, 4637440978796412928))), @as(f64, @bitCast(@as(i64, 4647785184190529536))), @as(f64, @bitCast(@as(i64, 4637440978796412928))), @as(f64, @bitCast(@as(i64, 4647785184190529536))), @as(f64, @bitCast(@as(i64, 4648488871632306176))), @as(f64, @bitCast(@as(i64, 4646448178051153920))), @as(f64, @bitCast(@as(i64, 4648488871632306176))) });
}

fn trunk_tag_got() *CxList(i64) {
    return b0: { const r_ = draw_trunk(m_(), true); break :b0 cx_ll_of(i64, &[_]i64{ cx_list_at(trunk(), 0).tag, cx_list_at(r_, 0).tag, cx_list_at(trunk(), 0).color, cx_list_at(r_, 0).color, cx_list_len(cx_list_at(r_, 0).pts) }); };
}

fn trunk_tag_want() *CxList(i64) {
    return cx_ll_of(i64, &[_]i64{ 0, 1, 5914146, 5914146, 8 });
}

fn trunk_strength_got() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ cx_list_at(trunk(), 0).strength, cx_list_at(draw_trunk(m_(), true), 0).strength });
}

fn trunk_strength_want() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4607182418800017408))) });
}

fn tri_got() *CxList(f64) {
    return cx_ll_concat(cx_list_at(tier_triangle(m_(), 0, 7), 0).pts, cx_list_at(tier_triangle(m_(), 7, 7), 0).pts);
}

fn tri_want() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ @as(f64, @bitCast(@as(i64, 4647151865492930560))), (-@as(f64, @bitCast(@as(i64, 4647292602981285888)))), @as(f64, @bitCast(@as(i64, 4648319986646279782))), (-@as(f64, @bitCast(@as(i64, 4643872682014251418)))), @as(f64, @bitCast(@as(i64, 4645378573139653427))), (-@as(f64, @bitCast(@as(i64, 4643872682014251418)))), @as(f64, @bitCast(@as(i64, 4647151865492930560))), (-@as(f64, @bitCast(@as(i64, 4630038186908922675)))), @as(f64, @bitCast(@as(i64, 4649966615260037120))), @as(f64, @bitCast(@as(i64, 4639833516098453504))), @as(f64, @bitCast(@as(i64, 4640959416005296128))), @as(f64, @bitCast(@as(i64, 4639833516098453504))) });
}

fn p_(x: f64, y: f64) ScreenPt {
    return cx_new(ScreenPtS{ .x = x, .y = y });
}

fn xy(ps: *CxList(ScreenPt)) *CxList(f64) {
    return flatten_screen(ps, 0);
}

fn square() *CxList(ScreenPt) {
    return cx_ll_of(ScreenPt, &[_]ScreenPt{ p_(@as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0)))), p_(@as(f64, @bitCast(@as(i64, 4616189618054758400))), @as(f64, @bitCast(@as(i64, 0)))), p_(@as(f64, @bitCast(@as(i64, 4616189618054758400))), @as(f64, @bitCast(@as(i64, 4616189618054758400)))), p_(@as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4616189618054758400)))), p_(@as(f64, @bitCast(@as(i64, 4611686018427387904))), @as(f64, @bitCast(@as(i64, 4611686018427387904)))), p_(@as(f64, @bitCast(@as(i64, 4611686018427387904))), @as(f64, @bitCast(@as(i64, 0)))) });
}

fn square_got() *CxList(f64) {
    return xy(convex_hull_pts(square()));
}

fn square_want() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4616189618054758400))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4616189618054758400))), @as(f64, @bitCast(@as(i64, 4616189618054758400))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4616189618054758400))) });
}

fn tri3_got() *CxList(f64) {
    return xy(convex_hull_pts(cx_ll_of(ScreenPt, &[_]ScreenPt{ p_(@as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0)))), p_(@as(f64, @bitCast(@as(i64, 4616189618054758400))), @as(f64, @bitCast(@as(i64, 0)))), p_(@as(f64, @bitCast(@as(i64, 4611686018427387904))), @as(f64, @bitCast(@as(i64, 4613937818241073152)))) })));
}

fn tri3_want() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4616189618054758400))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4611686018427387904))), @as(f64, @bitCast(@as(i64, 4613937818241073152))) });
}

fn line_got() *CxList(f64) {
    return xy(convex_hull_pts(cx_ll_of(ScreenPt, &[_]ScreenPt{ p_(@as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0)))), p_(@as(f64, @bitCast(@as(i64, 4607182418800017408))), @as(f64, @bitCast(@as(i64, 4607182418800017408)))), p_(@as(f64, @bitCast(@as(i64, 4611686018427387904))), @as(f64, @bitCast(@as(i64, 4611686018427387904)))), p_(@as(f64, @bitCast(@as(i64, 4613937818241073152))), @as(f64, @bitCast(@as(i64, 4613937818241073152)))) })));
}

fn line_want() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4613937818241073152))), @as(f64, @bitCast(@as(i64, 4613937818241073152))) });
}

fn short_got() *CxList(f64) {
    return cx_ll_concat(cx_ll_concat(xy(convex_hull_pts(cx_ll_of(ScreenPt, &[_]ScreenPt{ p_(@as(f64, @bitCast(@as(i64, 4607182418800017408))), @as(f64, @bitCast(@as(i64, 4611686018427387904)))), p_(@as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0)))) }))), xy(convex_hull_pts(cx_ll_of(ScreenPt, &[_]ScreenPt{ p_(@as(f64, @bitCast(@as(i64, 4621256167635550208))), @as(f64, @bitCast(@as(i64, 4621256167635550208)))) })))), xy(convex_hull_pts(cx_ll_empty(ScreenPt))));
}

fn short_want() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ @as(f64, @bitCast(@as(i64, 4607182418800017408))), @as(f64, @bitCast(@as(i64, 4611686018427387904))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4621256167635550208))), @as(f64, @bitCast(@as(i64, 4621256167635550208))) });
}

fn dup_got() *CxList(f64) {
    return xy(convex_hull_pts(cx_ll_of(ScreenPt, &[_]ScreenPt{ p_(@as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0)))), p_(@as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0)))), p_(@as(f64, @bitCast(@as(i64, 4616189618054758400))), @as(f64, @bitCast(@as(i64, 0)))), p_(@as(f64, @bitCast(@as(i64, 4616189618054758400))), @as(f64, @bitCast(@as(i64, 4616189618054758400)))) })));
}

fn dup_want() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4616189618054758400))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4616189618054758400))), @as(f64, @bitCast(@as(i64, 4616189618054758400))) });
}

fn count_got() *CxList(i64) {
    return cx_ll_of(i64, &[_]i64{ cx_list_len(convex_hull_pts(square())), cx_list_len(convex_hull_pts(cx_ll_of(ScreenPt, &[_]ScreenPt{ p_(@as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0)))), p_(@as(f64, @bitCast(@as(i64, 4616189618054758400))), @as(f64, @bitCast(@as(i64, 0)))), p_(@as(f64, @bitCast(@as(i64, 4611686018427387904))), @as(f64, @bitCast(@as(i64, 4613937818241073152)))) }))), cx_list_len(convex_hull_pts(cx_ll_of(ScreenPt, &[_]ScreenPt{ p_(@as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0)))), p_(@as(f64, @bitCast(@as(i64, 4607182418800017408))), @as(f64, @bitCast(@as(i64, 4607182418800017408)))), p_(@as(f64, @bitCast(@as(i64, 4611686018427387904))), @as(f64, @bitCast(@as(i64, 4611686018427387904)))), p_(@as(f64, @bitCast(@as(i64, 4613937818241073152))), @as(f64, @bitCast(@as(i64, 4613937818241073152)))) }))), cx_list_len(convex_hull_pts(cx_ll_of(ScreenPt, &[_]ScreenPt{ p_(@as(f64, @bitCast(@as(i64, 4607182418800017408))), @as(f64, @bitCast(@as(i64, 4611686018427387904)))), p_(@as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0)))) }))), cx_list_len(convex_hull_pts(cx_ll_of(ScreenPt, &[_]ScreenPt{ p_(@as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0)))), p_(@as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0)))), p_(@as(f64, @bitCast(@as(i64, 4616189618054758400))), @as(f64, @bitCast(@as(i64, 0)))), p_(@as(f64, @bitCast(@as(i64, 4616189618054758400))), @as(f64, @bitCast(@as(i64, 4616189618054758400)))) }))) });
}

fn count_want() *CxList(i64) {
    return cx_ll_of(i64, &[_]i64{ 4, 3, 2, 2, 3 });
}

fn sorted_got() *CxList(f64) {
    return xy(sort_pts(square(), 0, cx_ll_empty(ScreenPt)));
}

fn sorted_want() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4616189618054758400))), @as(f64, @bitCast(@as(i64, 4611686018427387904))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4611686018427387904))), @as(f64, @bitCast(@as(i64, 4611686018427387904))), @as(f64, @bitCast(@as(i64, 4616189618054758400))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4616189618054758400))), @as(f64, @bitCast(@as(i64, 4616189618054758400))) });
}

fn opening() void {
    return b0: { _ = cx_print_line(grade_reals("\x0e\x15\x49\x0e\x0f\x20\x17\x0d\x02", table_got(), table_want(), @as(f64, @bitCast(@as(i64, 0))))); _ = cx_print_line(grade_ints("\x0e\x15\x49\x13\x11\x26\x0d\x02\x02", size_got(), size_want())); _ = cx_print_line(grade_reals("\x0e\x15\x49\x1c\x15\x0f\x18\x02\x02", frac_got(), frac_want(), @as(f64, @bitCast(@as(i64, 0))))); _ = cx_print_line(grade_reals("\x0e\x15\x49\x1a\x0d\x0e\x15\x11\x18", metric_got(), metric_want(), @as(f64, @bitCast(@as(i64, 0))))); _ = cx_print_line(grade_reals("\x0e\x15\x49\x0e\x15\x19\x12\x22\x02", trunk_got(), trunk_want(), @as(f64, @bitCast(@as(i64, 0))))); _ = cx_print_line(grade_ints("\x0e\x15\x49\x0e\x0e\x0f\x1d\x02\x02", trunk_tag_got(), trunk_tag_want())); _ = cx_print_line(grade_reals("\x0e\x15\x49\x0e\x13\x0e\x15\x02\x02", trunk_strength_got(), trunk_strength_want(), @as(f64, @bitCast(@as(i64, 0))))); _ = cx_print_line(grade_reals("\x0e\x15\x49\x0e\x15\x11\x02\x02\x02", tri_got(), tri_want(), @as(f64, @bitCast(@as(i64, 4472406533629990549))))); _ = cx_print_line(grade_reals("\x0e\x15\x49\x13\x25\x19\x0f\x15\x0d", square_got(), square_want(), @as(f64, @bitCast(@as(i64, 0))))); _ = cx_print_line(grade_reals("\x0e\x15\x49\x0e\x15\x11\x06\x02\x02", tri3_got(), tri3_want(), @as(f64, @bitCast(@as(i64, 0))))); _ = cx_print_line(grade_reals("\x0e\x15\x49\x17\x11\x12\x0d\x02\x02", line_got(), line_want(), @as(f64, @bitCast(@as(i64, 0))))); _ = cx_print_line(grade_reals("\x0e\x15\x49\x13\x14\x10\x15\x0e\x02", short_got(), short_want(), @as(f64, @bitCast(@as(i64, 0))))); _ = cx_print_line(grade_reals("\x0e\x15\x49\x16\x19\x1f\x02\x02\x02", dup_got(), dup_want(), @as(f64, @bitCast(@as(i64, 0))))); _ = cx_print_line(grade_ints("\x0e\x15\x49\x18\x10\x19\x12\x0e\x02", count_got(), count_want())); _ = cx_print_line(grade_reals("\x0e\x15\x49\x13\x10\x15\x0e\x0d\x16", sorted_got(), sorted_want(), @as(f64, @bitCast(@as(i64, 0))))); break :b0; };
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


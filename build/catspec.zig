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

const CatS = struct {
    along: f64,
    start_across: f64,
    mid_across: f64,
    end_across: f64,
    height: f64,
};
const Cat = *CatS;

const CatStateS = struct {
    pose_idx: i64,
    across: f64,
    lift: f64,
};
const CatState = *CatStateS;

fn real_min(a_: f64, b_: f64) f64 {
    return (if ((a_ < b_)) a_ else b_);
}

fn real_sqrt(x: f64) f64 {
    return @as(f64, (if ((x <= @as(f64, @bitCast(@as(i64, 0))))) @as(f64, @bitCast(@as(i64, 0))) else dm_sqrt_scaled(x, @as(f64, @bitCast(@as(i64, 4607182418800017408))), 700)));
}

fn dm_sqrt_scaled(x: f64, s_: f64, fuel: i64) f64 {
    var _tl_x = x;
    var _tl_s = s_;
    var _tl_fuel = fuel;
    while (true) {
        if ((_tl_fuel <= 0)) { return (_tl_s * dm_sqrt_core(_tl_x)); } else { if ((_tl_x >= @as(f64, @bitCast(@as(i64, 4616189618054758400))))) { { const _tj2_0 = (_tl_x / @as(f64, @bitCast(@as(i64, 4616189618054758400)))); const _tj2_1 = (_tl_s * @as(f64, @bitCast(@as(i64, 4611686018427387904)))); const _tj2_2 = (_tl_fuel - 1); _tl_x = _tj2_0; _tl_s = _tj2_1; _tl_fuel = _tj2_2; continue; } } else { if ((_tl_x < @as(f64, @bitCast(@as(i64, 4598175219545276416))))) { { const _tj3_0 = (_tl_x * @as(f64, @bitCast(@as(i64, 4616189618054758400)))); const _tj3_1 = (_tl_s * @as(f64, @bitCast(@as(i64, 4602678819172646912)))); const _tj3_2 = (_tl_fuel - 1); _tl_x = _tj3_0; _tl_s = _tj3_1; _tl_fuel = _tj3_2; continue; } } else { return (_tl_s * dm_sqrt_core(_tl_x)); } } }
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

fn two_pi() f64 {
    return dm_two_pi();
}

fn r_sin(x: f64) f64 {
    return real_sin(x);
}

fn round_real(x: f64) f64 {
    return b0: { const t: f64 = cx_real_from_int(cx_real_to_int(x)); break :b0 b1: { const f: f64 = (x - t); break :b1 (if ((f >= @as(f64, @bitCast(@as(i64, 4602678819172646912))))) (t + @as(f64, @bitCast(@as(i64, 4607182418800017408)))) else (if ((f <= (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4602678819172646912)))))) (t - @as(f64, @bitCast(@as(i64, 4607182418800017408)))) else t)); }; };
}

fn cat_height() f64 {
    return @as(f64, @bitCast(@as(i64, 4610334938539176755)));
}

fn cat_along() f64 {
    return @as(f64, @bitCast(@as(i64, 4637089135075524608)));
}

fn cat_road_gap() f64 {
    return @as(f64, @bitCast(@as(i64, 4609434218613702656)));
}

fn cat_beyond_tree() f64 {
    return @as(f64, @bitCast(@as(i64, 4611686018427387904)));
}

fn cat_head_x() f64 {
    return (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4602318531202457272))));
}

fn land_hind_reach() f64 {
    return (@as(f64, @bitCast(@as(i64, 4604480259023595110))) * cat_height());
}

fn grass_toehold() f64 {
    return @as(f64, @bitCast(@as(i64, 4599075939470750515)));
}

fn cat_make(lane_half: f64, tree_offset: f64, tree_along: f64) Cat {
    return b0: { const tree_x: f64 = (lane_half + tree_offset); break :b0 cx_new(CatS{ .along = (tree_along + cat_beyond_tree()), .start_across = (tree_x + cat_road_gap()), .mid_across = ((@as(f64, @bitCast(@as(i64, 0))) - cat_head_x()) * cat_height()), .end_across = ((@as(f64, @bitCast(@as(i64, 0))) - (lane_half + grass_toehold())) - land_hind_reach()), .height = cat_height() }); };
}

fn enters_road_steps() f64 {
    return @as(f64, @bitCast(@as(i64, 4621819117588971520)));
}

fn frozen_steps() f64 {
    return @as(f64, @bitCast(@as(i64, 4627448617123184640)));
}

fn escapes_steps() f64 {
    return @as(f64, @bitCast(@as(i64, 4616189618054758400)));
}

fn cross_frames() f64 {
    return ((enters_road_steps() + frozen_steps()) + escapes_steps());
}

fn road_buffer() f64 {
    return @as(f64, @bitCast(@as(i64, 4613937818241073152)));
}

fn cat_in_danger(gap_along: f64, v_: f64) bool {
    return b0: { const e_: f64 = (gap_along - road_buffer()); break :b0 (if ((e_ > @as(f64, @bitCast(@as(i64, 0))))) (e_ <= (cross_frames() * v_)) else false); };
}

fn clamp01(x: f64) f64 {
    return @as(f64, (if ((x < @as(f64, @bitCast(@as(i64, 0))))) @as(f64, @bitCast(@as(i64, 0))) else @as(f64, (if ((x > @as(f64, @bitCast(@as(i64, 4607182418800017408))))) @as(f64, @bitCast(@as(i64, 4607182418800017408))) else x))));
}

fn lerp(a_: f64, b_: f64, t: f64) f64 {
    return (a_ + ((b_ - a_) * t));
}

fn cross_t(gap: f64, v_: f64) f64 {
    return b0: { const e_: f64 = (gap - road_buffer()); break :b0 @as(f64, (if ((e_ <= @as(f64, @bitCast(@as(i64, 0))))) @as(f64, @bitCast(@as(i64, 4607182418800017408))) else @as(f64, (if ((v_ <= @as(f64, @bitCast(@as(i64, 4517329193108106637))))) @as(f64, @bitCast(@as(i64, 0))) else clamp01((@as(f64, @bitCast(@as(i64, 4607182418800017408))) - (e_ / (cross_frames() * v_)))))))); };
}

fn focus_peak() f64 {
    return @as(f64, @bitCast(@as(i64, 4610785298501913805)));
}

fn focus_ramp_down() f64 {
    return @as(f64, @bitCast(@as(i64, 4635541022703616000)));
}

fn cat_smoothstep(t: f64) f64 {
    return ((t * t) * (@as(f64, @bitCast(@as(i64, 4613937818241073152))) - (@as(f64, @bitCast(@as(i64, 4611686018427387904))) * t)));
}

fn cat_focus(gap_along: f64, v_: f64) f64 {
    return @as(f64, (if ((v_ <= @as(f64, @bitCast(@as(i64, 4517329193108106637))))) @as(f64, @bitCast(@as(i64, 0))) else (if (((gap_along - road_buffer()) > @as(f64, @bitCast(@as(i64, 0))))) (cat_smoothstep(cross_t(gap_along, v_)) * focus_peak()) else cat_focus_past((gap_along - road_buffer()), v_))));
}

fn cat_focus_past(e_: f64, v_: f64) f64 {
    return ((@as(f64, @bitCast(@as(i64, 4607182418800017408))) - cat_smoothstep(real_min((((@as(f64, @bitCast(@as(i64, 0))) - e_) / v_) / focus_ramp_down()), @as(f64, @bitCast(@as(i64, 4607182418800017408)))))) * focus_peak());
}

fn stride_steps() f64 {
    return @as(f64, @bitCast(@as(i64, 4617315517961601024)));
}

fn gait(p_: f64, phase_len: f64) f64 {
    return b0: { const c_: f64 = round_real((phase_len / stride_steps())); break :b0 ((p_ * @as(f64, (if ((c_ < @as(f64, @bitCast(@as(i64, 4607182418800017408))))) @as(f64, @bitCast(@as(i64, 4607182418800017408))) else c_))) * two_pi()); };
}

fn pose_rest() i64 {
    return 0;
}

fn pose_stride() i64 {
    return 1;
}

fn pose_frozen() i64 {
    return 2;
}

fn pose_coil() i64 {
    return 3;
}

fn pose_flight() i64 {
    return 4;
}

fn pose_land() i64 {
    return 5;
}

fn pose_collapse() i64 {
    return 6;
}

fn leap_pose_for(t: f64) i64 {
    return (if ((t < @as(f64, @bitCast(@as(i64, 4596373779694328218))))) pose_coil() else (if ((t < @as(f64, @bitCast(@as(i64, 4604480259023595110))))) pose_flight() else (if ((t < @as(f64, @bitCast(@as(i64, 4606732058837280358))))) pose_land() else pose_collapse())));
}

fn leap_height() f64 {
    return @as(f64, @bitCast(@as(i64, 4595653203753948938)));
}

fn pow075(b_: f64) f64 {
    return real_sqrt((b_ * real_sqrt(b_)));
}

fn cat_state(c_: Cat, gap_along: f64, v_: f64) CatState {
    return b0: { const step: f64 = (cross_t(gap_along, v_) * cross_frames()); break :b0 b1: { const escape_at: f64 = (enters_road_steps() + frozen_steps()); break :b1 (if ((step <= enters_road_steps())) cat_entering(c_, step) else (if ((step <= escape_at)) cx_new(CatStateS{ .pose_idx = pose_frozen(), .across = c_.mid_across, .lift = @as(f64, @bitCast(@as(i64, 0))) }) else cat_escaping(c_, (step - escape_at)))); }; };
}

fn cat_entering(c_: Cat, step: f64) CatState {
    return b0: { const p_: f64 = @as(f64, (if ((enters_road_steps() > @as(f64, @bitCast(@as(i64, 0))))) (step / enters_road_steps()) else @as(f64, @bitCast(@as(i64, 4607182418800017408))))); break :b0 cx_new(CatStateS{ .pose_idx = (if ((r_sin(gait(p_, enters_road_steps())) > @as(f64, @bitCast(@as(i64, 0))))) pose_stride() else pose_rest()), .across = lerp(c_.start_across, c_.mid_across, p_), .lift = @as(f64, @bitCast(@as(i64, 0))) }); };
}

fn cat_escaping(c_: Cat, raw_k: f64) CatState {
    return b0: { const k_: f64 = (if ((raw_k > escapes_steps())) escapes_steps() else raw_k); break :b0 b1: { const pose: i64 = leap_pose_for((k_ / escapes_steps())); break :b1 (if ((k_ < @as(f64, @bitCast(@as(i64, 4607182418800017408))))) cx_new(CatStateS{ .pose_idx = pose, .across = c_.mid_across, .lift = @as(f64, @bitCast(@as(i64, 0))) }) else (if ((k_ < @as(f64, @bitCast(@as(i64, 4613937818241073152))))) cat_airborne(c_, pose, ((k_ - @as(f64, @bitCast(@as(i64, 4607182418800017408)))) / @as(f64, @bitCast(@as(i64, 4611686018427387904))))) else cx_new(CatStateS{ .pose_idx = pose, .across = c_.end_across, .lift = @as(f64, @bitCast(@as(i64, 0))) }))); }; };
}

fn cat_airborne(c_: Cat, pose: i64, b_: f64) CatState {
    return cx_new(CatStateS{ .pose_idx = pose, .across = lerp(c_.mid_across, c_.end_across, pow075(b_)), .lift = (((leap_height() * @as(f64, @bitCast(@as(i64, 4616189618054758400)))) * b_) * (@as(f64, @bitCast(@as(i64, 4607182418800017408))) - b_)) });
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
        if ((_tl_i >= cx_list_len(got))) { return (0 - 1); } else { if (g_finite(cx_list_at(got, _tl_i))) { if ((g_abs((cx_list_at(got, _tl_i) - cx_list_at(want, _tl_i))) > tol)) { return _tl_i; } else { { const _tj3_3 = (_tl_i + 1); _tl_i = _tj3_3; continue; } } } else { return _tl_i; } }
    }
}

fn grade_reals(name: []const u8, got: *CxList(f64), want: *CxList(f64), tol: f64) []const u8 {
    return (if ((cx_list_len(got) != cx_list_len(want))) cx_concat(cx_concat(cx_concat(cx_concat(name, "\x02\x3a\x29\x30\x02\x17\x0d\x12\x1d\x0e\x14\x02"), cx_show_int(cx_list_len(got))), "\x02\x1b\x0f\x12\x0e\x02"), cx_show_int(cx_list_len(want))) else b1: { const i_: i64 = first_real_diff(got, want, tol, 0); break :b1 (if ((i_ < 0)) cx_concat(cx_concat(name, "\x02\x10\x22\x02"), cx_show_int(cx_list_len(got))) else cx_concat(cx_concat(name, "\x02\x3a\x29\x30\x02\x0f\x0e\x02"), cx_show_int(i_))); });
}

fn first_int_diff(got: *CxList(i64), want: *CxList(i64), i_: i64) i64 {
    var _tl_i = i_;
    while (true) {
        if ((_tl_i >= cx_list_len(got))) { return (0 - 1); } else { if ((cx_list_at(got, _tl_i) != cx_list_at(want, _tl_i))) { return _tl_i; } else { { const _tj2_2 = (_tl_i + 1); _tl_i = _tj2_2; continue; } } }
    }
}

fn grade_ints(name: []const u8, got: *CxList(i64), want: *CxList(i64)) []const u8 {
    return (if ((cx_list_len(got) != cx_list_len(want))) cx_concat(cx_concat(cx_concat(cx_concat(name, "\x02\x3a\x29\x30\x02\x17\x0d\x12\x1d\x0e\x14\x02"), cx_show_int(cx_list_len(got))), "\x02\x1b\x0f\x12\x0e\x02"), cx_show_int(cx_list_len(want))) else b1: { const i_: i64 = first_int_diff(got, want, 0); break :b1 (if ((i_ < 0)) cx_concat(cx_concat(name, "\x02\x10\x22\x02"), cx_show_int(cx_list_len(got))) else cx_concat(cx_concat(cx_concat(cx_concat(cx_concat(cx_concat(name, "\x02\x3a\x29\x30\x02\x0f\x0e\x02"), cx_show_int(i_)), "\x02\x1d\x10\x0e\x02"), cx_show_int(cx_list_at(got, i_))), "\x02\x1b\x0f\x12\x0e\x02"), cx_show_int(cx_list_at(want, i_)))); });
}

fn bool_eq(a_: bool, b_: bool) bool {
    return (if (a_) b_ else (if (b_) false else true));
}

fn first_bool_diff(got: *CxList(bool), want: *CxList(bool), i_: i64) i64 {
    var _tl_i = i_;
    while (true) {
        if ((_tl_i >= cx_list_len(got))) { return (0 - 1); } else { if (bool_eq(cx_list_at(got, _tl_i), cx_list_at(want, _tl_i))) { { const _tj2_2 = (_tl_i + 1); _tl_i = _tj2_2; continue; } } else { return _tl_i; } }
    }
}

fn grade_bools(name: []const u8, got: *CxList(bool), want: *CxList(bool)) []const u8 {
    return (if ((cx_list_len(got) != cx_list_len(want))) cx_concat(cx_concat(cx_concat(cx_concat(name, "\x02\x3a\x29\x30\x02\x17\x0d\x12\x1d\x0e\x14\x02"), cx_show_int(cx_list_len(got))), "\x02\x1b\x0f\x12\x0e\x02"), cx_show_int(cx_list_len(want))) else b1: { const i_: i64 = first_bool_diff(got, want, 0); break :b1 (if ((i_ < 0)) cx_concat(cx_concat(name, "\x02\x10\x22\x02"), cx_show_int(cx_list_len(got))) else cx_concat(cx_concat(name, "\x02\x3a\x29\x30\x02\x0f\x0e\x02"), cx_show_int(i_))); });
}

fn the_cat() Cat {
    return cat_make(@as(f64, @bitCast(@as(i64, 4611686018427387904))), @as(f64, @bitCast(@as(i64, 4607182418800017408))), @as(f64, @bitCast(@as(i64, 4636737291354636288))));
}

fn make_got() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ the_cat().along, the_cat().start_across, the_cat().mid_across, the_cat().height });
}

fn make_want() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ @as(f64, @bitCast(@as(i64, 4636878028842991616))), @as(f64, @bitCast(@as(i64, 4616752568008179712))), @as(f64, @bitCast(@as(i64, 4605525094137145065))), @as(f64, @bitCast(@as(i64, 4610334938539176755))) });
}

fn make_wide_got() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ the_cat().end_across, (the_cat().mid_across - the_cat().end_across) });
}

fn make_wide_want() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ (-@as(f64, @bitCast(@as(i64, 4615041200149778924)))), @as(f64, @bitCast(@as(i64, 4616534143426252243))) });
}

fn dims_got() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ cat_height(), cat_along(), cat_road_gap(), cat_beyond_tree(), cat_head_x(), land_hind_reach(), grass_toehold() });
}

fn dims_want() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ @as(f64, @bitCast(@as(i64, 4610334938539176755))), @as(f64, @bitCast(@as(i64, 4637089135075524608))), @as(f64, @bitCast(@as(i64, 4609434218613702656))), @as(f64, @bitCast(@as(i64, 4611686018427387904))), (-@as(f64, @bitCast(@as(i64, 4602318531202457272)))), @as(f64, @bitCast(@as(i64, 4608038102729217802))), @as(f64, @bitCast(@as(i64, 4599075939470750515))) });
}

fn window_got() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ enters_road_steps(), frozen_steps(), escapes_steps(), cross_frames(), road_buffer() });
}

fn window_want() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ @as(f64, @bitCast(@as(i64, 4621819117588971520))), @as(f64, @bitCast(@as(i64, 4627448617123184640))), @as(f64, @bitCast(@as(i64, 4616189618054758400))), @as(f64, @bitCast(@as(i64, 4630544841867001856))), @as(f64, @bitCast(@as(i64, 4613937818241073152))) });
}

fn danger_got() *CxList(bool) {
    return cx_ll_of(bool, &[_]bool{ cat_in_danger(@as(f64, @bitCast(@as(i64, 4630967054332067840))), @as(f64, @bitCast(@as(i64, 4607182418800017408)))), cat_in_danger(@as(f64, @bitCast(@as(i64, 4631107791820423168))), @as(f64, @bitCast(@as(i64, 4607182418800017408)))), cat_in_danger(@as(f64, @bitCast(@as(i64, 4613937818241073152))), @as(f64, @bitCast(@as(i64, 4607182418800017408)))), cat_in_danger(@as(f64, @bitCast(@as(i64, 4611686018427387904))), @as(f64, @bitCast(@as(i64, 4607182418800017408)))), cat_in_danger(@as(f64, @bitCast(@as(i64, 4630967054332067840))), @as(f64, @bitCast(@as(i64, 0)))), cat_in_danger(@as(f64, @bitCast(@as(i64, 4626885667169763328))), @as(f64, @bitCast(@as(i64, 4607182418800017408)))) });
}

fn danger_want() *CxList(bool) {
    return cx_ll_of(bool, &[_]bool{ true, false, false, false, false, true });
}

fn t_got() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ cross_t(@as(f64, @bitCast(@as(i64, 4630967054332067840))), @as(f64, @bitCast(@as(i64, 4607182418800017408)))), cross_t(@as(f64, @bitCast(@as(i64, 4626885667169763328))), @as(f64, @bitCast(@as(i64, 4607182418800017408)))), cross_t(@as(f64, @bitCast(@as(i64, 4613937818241073152))), @as(f64, @bitCast(@as(i64, 4607182418800017408)))), cross_t(@as(f64, @bitCast(@as(i64, 4611686018427387904))), @as(f64, @bitCast(@as(i64, 4607182418800017408)))), cross_t(@as(f64, @bitCast(@as(i64, 4636737291354636288))), @as(f64, @bitCast(@as(i64, 4607182418800017408)))), cross_t(@as(f64, @bitCast(@as(i64, 4630967054332067840))), @as(f64, @bitCast(@as(i64, 0)))), clamp01((@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4602678819172646912))))), clamp01(@as(f64, @bitCast(@as(i64, 4598175219545276416)))), clamp01(@as(f64, @bitCast(@as(i64, 4609434218613702656)))), lerp(@as(f64, @bitCast(@as(i64, 4611686018427387904))), @as(f64, @bitCast(@as(i64, 4618441417868443648))), @as(f64, @bitCast(@as(i64, 4598175219545276416)))), lerp(@as(f64, @bitCast(@as(i64, 4611686018427387904))), @as(f64, @bitCast(@as(i64, 4618441417868443648))), @as(f64, @bitCast(@as(i64, 0)))), lerp(@as(f64, @bitCast(@as(i64, 4611686018427387904))), @as(f64, @bitCast(@as(i64, 4618441417868443648))), @as(f64, @bitCast(@as(i64, 4607182418800017408)))) });
}

fn t_want() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4602678819172646912))), @as(f64, @bitCast(@as(i64, 4607182418800017408))), @as(f64, @bitCast(@as(i64, 4607182418800017408))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4598175219545276416))), @as(f64, @bitCast(@as(i64, 4607182418800017408))), @as(f64, @bitCast(@as(i64, 4613937818241073152))), @as(f64, @bitCast(@as(i64, 4611686018427387904))), @as(f64, @bitCast(@as(i64, 4618441417868443648))) });
}

fn focus_got() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ cat_smoothstep(@as(f64, @bitCast(@as(i64, 0)))), cat_smoothstep(@as(f64, @bitCast(@as(i64, 4602678819172646912)))), cat_smoothstep(@as(f64, @bitCast(@as(i64, 4607182418800017408)))), cat_focus(@as(f64, @bitCast(@as(i64, 4630967054332067840))), @as(f64, @bitCast(@as(i64, 4607182418800017408)))), cat_focus(@as(f64, @bitCast(@as(i64, 4626885667169763328))), @as(f64, @bitCast(@as(i64, 4607182418800017408)))), cat_focus(@as(f64, @bitCast(@as(i64, 4613937818241073152))), @as(f64, @bitCast(@as(i64, 4607182418800017408)))), cat_focus((@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4630615210611179520)))), @as(f64, @bitCast(@as(i64, 4607182418800017408)))), cat_focus((@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4635329916471083008)))), @as(f64, @bitCast(@as(i64, 4607182418800017408)))), cat_focus(@as(f64, @bitCast(@as(i64, 4626885667169763328))), @as(f64, @bitCast(@as(i64, 0)))), focus_peak(), focus_ramp_down() });
}

fn focus_want() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4602678819172646912))), @as(f64, @bitCast(@as(i64, 4607182418800017408))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4606281698874543309))), @as(f64, @bitCast(@as(i64, 4610785298501913805))), @as(f64, @bitCast(@as(i64, 4606281698874543309))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4610785298501913805))), @as(f64, @bitCast(@as(i64, 4635541022703616000))) });
}

fn cycles_got() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ gait(@as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4621819117588971520)))), (gait(@as(f64, @bitCast(@as(i64, 4607182418800017408))), @as(f64, @bitCast(@as(i64, 4621819117588971520)))) / two_pi()), (gait(@as(f64, @bitCast(@as(i64, 4602678819172646912))), @as(f64, @bitCast(@as(i64, 4621819117588971520)))) / two_pi()), (gait(@as(f64, @bitCast(@as(i64, 4607182418800017408))), @as(f64, @bitCast(@as(i64, 4626322717216342016)))) / two_pi()), (gait(@as(f64, @bitCast(@as(i64, 4607182418800017408))), @as(f64, @bitCast(@as(i64, 4613937818241073152)))) / two_pi()), (gait(@as(f64, @bitCast(@as(i64, 4607182418800017408))), @as(f64, @bitCast(@as(i64, 0)))) / two_pi()), stride_steps() });
}

fn cycles_want() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4611686018427387904))), @as(f64, @bitCast(@as(i64, 4607182418800017408))), @as(f64, @bitCast(@as(i64, 4616189618054758400))), @as(f64, @bitCast(@as(i64, 4607182418800017408))), @as(f64, @bitCast(@as(i64, 4607182418800017408))), @as(f64, @bitCast(@as(i64, 4617315517961601024))) });
}

fn pose_got() *CxList(i64) {
    return cx_ll_of(i64, &[_]i64{ pose_rest(), pose_stride(), pose_frozen(), pose_coil(), pose_flight(), pose_land(), pose_collapse(), leap_pose_for(@as(f64, @bitCast(@as(i64, 0)))), leap_pose_for(@as(f64, @bitCast(@as(i64, 4596013491724138578)))), leap_pose_for(@as(f64, @bitCast(@as(i64, 4596373779694328218)))), leap_pose_for(@as(f64, @bitCast(@as(i64, 4604390187031047700)))), leap_pose_for(@as(f64, @bitCast(@as(i64, 4604480259023595110)))), leap_pose_for(@as(f64, @bitCast(@as(i64, 4606641986844732948)))), leap_pose_for(@as(f64, @bitCast(@as(i64, 4606732058837280358)))), leap_pose_for(@as(f64, @bitCast(@as(i64, 4607182418800017408)))) });
}

fn pose_want() *CxList(i64) {
    return cx_ll_of(i64, &[_]i64{ 0, 1, 2, 3, 4, 5, 6, 3, 3, 4, 4, 5, 5, 6, 6 });
}

fn phase_of(gap: f64) CatState {
    return cat_state(the_cat(), gap, @as(f64, @bitCast(@as(i64, 4607182418800017408))));
}

fn which_got() *CxList(i64) {
    return cx_ll_of(i64, &[_]i64{ phase_of(@as(f64, @bitCast(@as(i64, 4630967054332067840)))).pose_idx, phase_of(@as(f64, @bitCast(@as(i64, 4629559679448514560)))).pose_idx, phase_of(@as(f64, @bitCast(@as(i64, 4629137466983448576)))).pose_idx, phase_of(@as(f64, @bitCast(@as(i64, 4619567317775286272)))).pose_idx, phase_of(@as(f64, @bitCast(@as(i64, 4619004367821864960)))).pose_idx, phase_of(@as(f64, @bitCast(@as(i64, 4618441417868443648)))).pose_idx, phase_of(@as(f64, @bitCast(@as(i64, 4616189618054758400)))).pose_idx, phase_of(@as(f64, @bitCast(@as(i64, 4613937818241073152)))).pose_idx });
}

fn which_want() *CxList(i64) {
    return cx_ll_of(i64, &[_]i64{ 0, 0, 2, 2, 3, 4, 5, 6 });
}

fn walking(step: f64) CatState {
    return cat_entering(the_cat(), step);
}

fn entering_got() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ walking(@as(f64, @bitCast(@as(i64, 0)))).across, walking(@as(f64, @bitCast(@as(i64, 4608308318706860032)))).across, walking(@as(f64, @bitCast(@as(i64, 4615626668101337088)))).across, walking(@as(f64, @bitCast(@as(i64, 4618722892845154304)))).across, walking(@as(f64, @bitCast(@as(i64, 4621115430147194880)))).across, walking(@as(f64, @bitCast(@as(i64, 0)))).lift, walking(@as(f64, @bitCast(@as(i64, 4621115430147194880)))).lift });
}

fn entering_want() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ @as(f64, @bitCast(@as(i64, 4616752568008179712))), @as(f64, @bitCast(@as(i64, 4616234091101078684))), @as(f64, @bitCast(@as(i64, 4614204656518994854))), @as(f64, @bitCast(@as(i64, 4612130748890590740))), @as(f64, @bitCast(@as(i64, 4608427664096985350))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))) });
}

fn stride_got() *CxList(i64) {
    return cx_ll_of(i64, &[_]i64{ walking(@as(f64, @bitCast(@as(i64, 0)))).pose_idx, walking(@as(f64, @bitCast(@as(i64, 4608308318706860032)))).pose_idx, walking(@as(f64, @bitCast(@as(i64, 4615626668101337088)))).pose_idx, walking(@as(f64, @bitCast(@as(i64, 4618722892845154304)))).pose_idx, walking(@as(f64, @bitCast(@as(i64, 4621115430147194880)))).pose_idx });
}

fn stride_want() *CxList(i64) {
    return cx_ll_of(i64, &[_]i64{ 0, 1, 0, 1, 0 });
}

fn frozen_got() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ phase_of(@as(f64, @bitCast(@as(i64, 4629137466983448576)))).across, phase_of(@as(f64, @bitCast(@as(i64, 4619567317775286272)))).across, phase_of(@as(f64, @bitCast(@as(i64, 4629137466983448576)))).lift });
}

fn frozen_want() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ @as(f64, @bitCast(@as(i64, 4605525094137145065))), @as(f64, @bitCast(@as(i64, 4605525094137145065))), @as(f64, @bitCast(@as(i64, 0))) });
}

fn leap_got() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ phase_of(@as(f64, @bitCast(@as(i64, 4619004367821864960)))).across, phase_of(@as(f64, @bitCast(@as(i64, 4619004367821864960)))).lift, phase_of(@as(f64, @bitCast(@as(i64, 4618441417868443648)))).across, phase_of(@as(f64, @bitCast(@as(i64, 4618441417868443648)))).lift, pow075(@as(f64, @bitCast(@as(i64, 0)))), pow075(@as(f64, @bitCast(@as(i64, 4607182418800017408)))), pow075(@as(f64, @bitCast(@as(i64, 4589168020290535424)))), leap_height() });
}

fn leap_want() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ @as(f64, @bitCast(@as(i64, 4605525094137145065))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4605525094137145065))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4607182418800017408))), @as(f64, @bitCast(@as(i64, 4593671619917905920))), @as(f64, @bitCast(@as(i64, 4595653203753948938))) });
}

fn flight_got() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ phase_of(@as(f64, @bitCast(@as(i64, 4618300680380088320)))).across, phase_of(@as(f64, @bitCast(@as(i64, 4618300680380088320)))).lift, phase_of(@as(f64, @bitCast(@as(i64, 4616189618054758400)))).across });
}

fn flight_want() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ @as(f64, @bitCast(@as(i64, 4598675119103914541))), @as(f64, @bitCast(@as(i64, 4586240680532744602))), (-@as(f64, @bitCast(@as(i64, 4615041200149778924)))) });
}

fn opening() void {
    return b0: { _ = cx_print_line(grade_reals("\x18\x0e\x49\x1a\x0f\x22\x0d\x02\x02", make_got(), make_want(), @as(f64, @bitCast(@as(i64, 0))))); _ = cx_print_line(grade_reals("\x18\x0e\x49\x16\x11\x1a\x13\x02\x02", dims_got(), dims_want(), @as(f64, @bitCast(@as(i64, 0))))); _ = cx_print_line(grade_reals("\x18\x0e\x49\x1b\x11\x12\x16\x10\x1b", window_got(), window_want(), @as(f64, @bitCast(@as(i64, 0))))); _ = cx_print_line(grade_bools("\x18\x0e\x49\x16\x0f\x12\x1d\x0d\x15", danger_got(), danger_want())); _ = cx_print_line(grade_reals("\x18\x0e\x49\x18\x17\x10\x18\x22\x02", t_got(), t_want(), @as(f64, @bitCast(@as(i64, 0))))); _ = cx_print_line(grade_reals("\x18\x0e\x49\x1c\x10\x18\x19\x13\x02", focus_got(), focus_want(), @as(f64, @bitCast(@as(i64, 0))))); _ = cx_print_line(grade_reals("\x18\x0e\x49\x1d\x0f\x11\x0e\x02\x02", cycles_got(), cycles_want(), @as(f64, @bitCast(@as(i64, 0))))); _ = cx_print_line(grade_ints("\x18\x0e\x49\x1f\x10\x13\x0d\x02\x02", pose_got(), pose_want())); _ = cx_print_line(grade_ints("\x18\x0e\x49\x1b\x14\x11\x18\x14\x02", which_got(), which_want())); _ = cx_print_line(grade_reals("\x18\x0e\x49\x0d\x12\x0e\x0d\x15\x02", entering_got(), entering_want(), @as(f64, @bitCast(@as(i64, 0))))); _ = cx_print_line(grade_ints("\x18\x0e\x49\x13\x0e\x15\x11\x16\x0d", stride_got(), stride_want())); _ = cx_print_line(grade_reals("\x18\x0e\x49\x1c\x15\x10\x26\x0d\x12", frozen_got(), frozen_want(), @as(f64, @bitCast(@as(i64, 0))))); _ = cx_print_line(grade_reals("\x18\x0e\x49\x17\x0d\x0f\x1f\x02\x02", leap_got(), leap_want(), @as(f64, @bitCast(@as(i64, 0))))); _ = cx_print_line(grade_reals("\x18\x0e\x49\x1b\x11\x16\x0d\x02\x02", make_wide_got(), make_wide_want(), @as(f64, @bitCast(@as(i64, 4427486594234968593))))); _ = cx_print_line(grade_reals("\x18\x0e\x49\x1c\x17\x11\x1d\x14\x0e", flight_got(), flight_want(), @as(f64, @bitCast(@as(i64, 4427486594234968593))))); break :b0; };
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
// mov-rr on bare metal (emit-real-to-bits-builtin): a Real f64 and its bit
// pattern are the same sixty-four bits in a general register, so there the
// conversion is a register move. Zig separates the two types and spells the
// same identity @bitCast. Total, since every f64 has a bit pattern: NaN
// payloads and both signed zeroes come through exactly as they went in.
fn cx_real_to_bits(v: f64) i64 {
    return @bitCast(v);
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


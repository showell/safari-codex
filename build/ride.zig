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

const Scheme = enum {
    AllGreen,
    YellowGreen,
    RedGreen,
};

const Creature = enum {
    NoCreature,
    Elephant,
    Giraffe,
    Zebra,
    Rhino,
    DuckPond,
};

const TreeS = struct {
    along: f64,
    across: f64,
    color: i64,
    height: f64,
};
const Tree = *TreeS;

const CritterS = struct {
    along: f64,
    across: f64,
    codepoint: i64,
    height: f64,
    face_right: bool,
};
const Critter = *CritterS;

const CfgS = struct {
    length: f64,
    scheme: Scheme,
    turn_deg: f64,
    cat: bool,
    pigs: bool,
    bull: bool,
    terminates: bool,
    creature: Creature,
};
const Cfg = *CfgS;

const SegmentS = struct {
    length: f64,
    width: f64,
    trees: *CxList(Tree),
    cows: *CxList(Critter),
    pigs: *CxList(Critter),
    pigs_distract: bool,
    exit_angle: f64,
    exit_right: bool,
    exit_to: i64,
    commit_along: f64,
    north_heading: f64,
    has_mid_tower: bool,
    has_cat: bool,
    cat: Cat,
    terminates: bool,
    exit_creature: Creature,
};
const Segment = *SegmentS;

const RiderStateS = struct {
    segment: i64,
    along: f64,
    across: f64,
    yaw: f64,
    v_: f64,
    tilt: f64,
    heading: f64,
    gaze_yaw: f64,
    focus: f64,
};
const RiderState = *RiderStateS;

const PigLookS = struct {
    looking: bool,
    dist: f64,
};
const PigLook = *PigLookS;

const GazeBrakeS = struct {
    engaged: bool,
    accel: f64,
};
const GazeBrake = *GazeBrakeS;

const Side = enum {
    SideLeft,
    SideNone,
    SideRight,
};

const PathSimS = struct {
    side: Side,
    forward: f64,
    crossed: bool,
    end_across: f64,
    frames: f64,
};
const PathSim = *PathSimS;

const DecisionS = struct {
    tilt_step: f64,
    accel: f64,
};
const Decision = *DecisionS;

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

const RideCkS = struct {
    frame: i64,
    bad_v: i64,
    bad_yaw: i64,
    bad_floor: i64,
    bad_ceil: i64,
    bad_across: i64,
    bad_gaze: i64,
    bad_focus: i64,
    bad_dusk: i64,
    segs: *CxList(i64),
    enters: *CxList(i64),
    sample: *CxList(f64),
    dusk: f64,
    finished: bool,
};
const RideCk = *RideCkS;

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

fn half_pi() f64 {
    return dm_half_pi();
}

fn deg() f64 {
    return @as(f64, @bitCast(@as(i64, 4580687790476533049)));
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

fn r_atan2(y: f64, x: f64) f64 {
    return (if ((x > @as(f64, @bitCast(@as(i64, 0))))) r_atan((y / x)) else (if ((x < @as(f64, @bitCast(@as(i64, 0))))) (if ((y >= @as(f64, @bitCast(@as(i64, 0))))) (r_atan((y / x)) + pi()) else (r_atan((y / x)) - pi())) else (if ((y > @as(f64, @bitCast(@as(i64, 0))))) half_pi() else @as(f64, (if ((y < @as(f64, @bitCast(@as(i64, 0))))) (@as(f64, @bitCast(@as(i64, 0))) - half_pi()) else @as(f64, @bitCast(@as(i64, 0))))))));
}

fn r_sign(x: f64) f64 {
    return @as(f64, (if ((x > @as(f64, @bitCast(@as(i64, 0))))) @as(f64, @bitCast(@as(i64, 4607182418800017408))) else @as(f64, (if ((x < @as(f64, @bitCast(@as(i64, 0))))) (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4607182418800017408)))) else @as(f64, @bitCast(@as(i64, 0)))))));
}

fn round_real(x: f64) f64 {
    return b0: { const t: f64 = cx_real_from_int(cx_real_to_int(x)); break :b0 b1: { const f: f64 = (x - t); break :b1 (if ((f >= @as(f64, @bitCast(@as(i64, 4602678819172646912))))) (t + @as(f64, @bitCast(@as(i64, 4607182418800017408)))) else (if ((f <= (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4602678819172646912)))))) (t - @as(f64, @bitCast(@as(i64, 4607182418800017408)))) else t)); }; };
}

fn ln2() f64 {
    return @as(f64, @bitCast(@as(i64, 4604418534313441775)));
}

fn exp_poly(r_: f64) f64 {
    return b0: { const t1: f64 = r_; break :b0 b1: { const t2: f64 = ((t1 * r_) / @as(f64, @bitCast(@as(i64, 4611686018427387904)))); break :b1 b2: { const t3: f64 = ((t2 * r_) / @as(f64, @bitCast(@as(i64, 4613937818241073152)))); break :b2 b3: { const t4: f64 = ((t3 * r_) / @as(f64, @bitCast(@as(i64, 4616189618054758400)))); break :b3 b4: { const t5: f64 = ((t4 * r_) / @as(f64, @bitCast(@as(i64, 4617315517961601024)))); break :b4 b5: { const t6: f64 = ((t5 * r_) / @as(f64, @bitCast(@as(i64, 4618441417868443648)))); break :b5 b6: { const t7: f64 = ((t6 * r_) / @as(f64, @bitCast(@as(i64, 4619567317775286272)))); break :b6 b7: { const t8: f64 = ((t7 * r_) / @as(f64, @bitCast(@as(i64, 4620693217682128896)))); break :b7 b8: { const t9: f64 = ((t8 * r_) / @as(f64, @bitCast(@as(i64, 4621256167635550208)))); break :b8 b9: { const t10: f64 = ((t9 * r_) / @as(f64, @bitCast(@as(i64, 4621819117588971520)))); break :b9 b10: { const t11: f64 = ((t10 * r_) / @as(f64, @bitCast(@as(i64, 4622382067542392832)))); break :b10 b11: { const t12: f64 = ((t11 * r_) / @as(f64, @bitCast(@as(i64, 4622945017495814144)))); break :b11 ((((((((((((@as(f64, @bitCast(@as(i64, 4607182418800017408))) + t1) + t2) + t3) + t4) + t5) + t6) + t7) + t8) + t9) + t10) + t11) + t12); }; }; }; }; }; }; }; }; }; }; }; };
}

fn pow2_up(k_: i64, acc_: f64) f64 {
    var _tl_k = k_;
    var _tl_acc = acc_;
    while (true) {
        if ((_tl_k <= 0)) { return _tl_acc; } else { { const _tj1_0 = (_tl_k -% 1); const _tj1_1 = (_tl_acc * @as(f64, @bitCast(@as(i64, 4611686018427387904)))); _tl_k = _tj1_0; _tl_acc = _tj1_1; continue; } }
    }
}

fn pow2_down(k_: i64, acc_: f64) f64 {
    var _tl_k = k_;
    var _tl_acc = acc_;
    while (true) {
        if ((_tl_k >= 0)) { return _tl_acc; } else { { const _tj1_0 = (_tl_k +% 1); const _tj1_1 = (_tl_acc * @as(f64, @bitCast(@as(i64, 4602678819172646912)))); _tl_k = _tj1_0; _tl_acc = _tj1_1; continue; } }
    }
}

fn exp_real(x: f64) f64 {
    return b0: { const k_: i64 = cx_real_to_int(round_real((x / ln2()))); break :b0 (exp_poly((x - (cx_real_from_int(k_) * ln2()))) * (if ((k_ >= 0)) pow2_up(k_, @as(f64, @bitCast(@as(i64, 4607182418800017408)))) else pow2_down(k_, @as(f64, @bitCast(@as(i64, 4607182418800017408)))))); };
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

fn conifer_green() i64 {
    return 1858082;
}

fn conifer_gold() i64 {
    return 13605400;
}

fn conifer_red() i64 {
    return 11680298;
}

fn small_height() f64 {
    return @as(f64, @bitCast(@as(i64, 4616752568008179712)));
}

fn big_scale() f64 {
    return @as(f64, @bitCast(@as(i64, 4608533498688228557)));
}

fn tree_spacing() f64 {
    return @as(f64, @bitCast(@as(i64, 4629137466983448576)));
}

fn tree_road_offset() f64 {
    return @as(f64, @bitCast(@as(i64, 4609434218613702656)));
}

fn tree_start_inset() f64 {
    return @as(f64, @bitCast(@as(i64, 4618441417868443648)));
}

fn tree_end_inset() f64 {
    return @as(f64, @bitCast(@as(i64, 4635681760191971328)));
}

fn lane_width() f64 {
    return @as(f64, @bitCast(@as(i64, 4616189618054758400)));
}

fn mid_tower_min_length() f64 {
    return @as(f64, @bitCast(@as(i64, 4652007308841189376)));
}

fn max_trees() i64 {
    return 96;
}

fn accent_color(s_: Scheme) i64 {
    return switch (s_) { .YellowGreen => conifer_gold(), .RedGreen => conifer_red(), .AllGreen => conifer_green(),  };
}

fn tree_height_for(color: i64, even: bool) f64 {
    return b0: { const base_: f64 = (if (even) (small_height() * big_scale()) else small_height()); break :b0 (if ((color == conifer_red())) (base_ * @as(f64, @bitCast(@as(i64, 4611686018427387904)))) else (if ((color == conifer_gold())) (base_ * @as(f64, @bitCast(@as(i64, 4613937818241073152)))) else base_)); };
}

fn fill_trees(scheme: Scheme, length: f64, along: f64, k_: i64, n_: i64) *CxList(Tree) {
    return (if ((along > (length - tree_end_inset()))) cx_ll_empty(Tree) else (if (((n_ +% 2) > max_trees())) cx_ll_empty(Tree) else fill_trees_pair(scheme, length, along, k_, n_)));
}

fn fill_trees_pair(scheme: Scheme, length: f64, along: f64, k_: i64, n_: i64) *CxList(Tree) {
    return b0: { const even: bool = ((k_ -% (@divTrunc(k_, 2) *% 2)) == 0); break :b0 b1: { const color: i64 = (if (even) conifer_green() else accent_color(scheme)); break :b1 b2: { const height: f64 = tree_height_for(color, even); break :b2 b3: { const x: f64 = (if ((color == conifer_gold())) ((lane_width() / @as(f64, @bitCast(@as(i64, 4611686018427387904)))) + (@as(f64, @bitCast(@as(i64, 4616189618054758400))) * tree_road_offset())) else ((lane_width() / @as(f64, @bitCast(@as(i64, 4611686018427387904)))) + tree_road_offset())); break :b3 cx_ll_concat(cx_ll_of(Tree, &[_]Tree{ cx_new(TreeS{ .along = along, .across = (@as(f64, @bitCast(@as(i64, 0))) - x), .color = color, .height = height }), cx_new(TreeS{ .along = along, .across = x, .color = color, .height = height }) }), fill_trees(scheme, length, (along + tree_spacing()), (k_ +% 1), (n_ +% 2))); }; }; }; };
}

fn bull_cp() i64 {
    return 128002;
}

fn cow_cp() i64 {
    return 128004;
}

fn cow_height() f64 {
    return @as(f64, @bitCast(@as(i64, 4608983858650965606)));
}

fn calf_height() f64 {
    return (cow_height() / @as(f64, @bitCast(@as(i64, 4611686018427387904))));
}

fn bull_height() f64 {
    return (cow_height() * @as(f64, @bitCast(@as(i64, 4607857958744122982))));
}

fn herd_road_offset() f64 {
    return @as(f64, @bitCast(@as(i64, 4621819117588971520)));
}

fn bull_dist() f64 {
    return @as(f64, @bitCast(@as(i64, 4627448617123184640)));
}

fn bull_tree_gap() f64 {
    return @as(f64, @bitCast(@as(i64, 4602678819172646912)));
}

fn herd_gap_behind_bull() f64 {
    return @as(f64, @bitCast(@as(i64, 4618441417868443648)));
}

fn herd_col_spacing() f64 {
    return @as(f64, @bitCast(@as(i64, 4618441417868443648)));
}

fn herd_row_stagger() f64 {
    return @as(f64, @bitCast(@as(i64, 4611686018427387904)));
}

fn herd_row_depth() f64 {
    return @as(f64, @bitCast(@as(i64, 4617315517961601024)));
}

fn herd_jitter_along() f64 {
    return @as(f64, @bitCast(@as(i64, 4609434218613702656)));
}

fn herd_jitter_across() f64 {
    return @as(f64, @bitCast(@as(i64, 4608083138725491507)));
}

fn cows_from(i_: i64) *CxList(Critter) {
    return (if ((i_ >= 14)) cx_ll_empty(Critter) else cx_ll_concat(cx_ll_of(Critter, &[_]Critter{ cow_at(i_) }), cows_from((i_ +% 1))));
}

fn cow_at(i_: i64) Critter {
    return b0: { const fi: f64 = cx_real_from_int(i_); break :b0 b1: { const col: f64 = cx_real_from_int(@divTrunc(i_, 3)); break :b1 b2: { const row: f64 = cx_real_from_int((i_ -% (@divTrunc(i_, 3) *% 3))); break :b2 b3: { const along: f64 = ((((bull_dist() + herd_gap_behind_bull()) + (col * herd_col_spacing())) + ((row - @as(f64, @bitCast(@as(i64, 4607182418800017408)))) * herd_row_stagger())) + (herd_jitter_along() * r_sin((fi * @as(f64, @bitCast(@as(i64, 4613262278296967578))))))); break :b3 b4: { const across: f64 = (@as(f64, @bitCast(@as(i64, 0))) - ((((lane_width() / @as(f64, @bitCast(@as(i64, 4611686018427387904)))) + herd_road_offset()) + (row * herd_row_depth())) + (herd_jitter_across() * r_cos((fi * @as(f64, @bitCast(@as(i64, 4611235658464650854)))))))); break :b4 cx_new(CritterS{ .along = along, .across = across, .codepoint = cow_cp(), .height = (if (((i_ -% (@divTrunc(i_, 4) *% 4)) == 1)) calf_height() else cow_height()), .face_right = true }); }; }; }; }; };
}

fn fill_cows(bull: bool) *CxList(Critter) {
    return cx_ll_concat((if (bull) cx_ll_of(Critter, &[_]Critter{ cx_new(CritterS{ .along = bull_dist(), .across = (@as(f64, @bitCast(@as(i64, 0))) - ((((lane_width() / @as(f64, @bitCast(@as(i64, 4611686018427387904)))) + tree_road_offset()) + (bull_height() / @as(f64, @bitCast(@as(i64, 4611686018427387904))))) + bull_tree_gap())), .codepoint = bull_cp(), .height = bull_height(), .face_right = false }) }) else cx_ll_empty(Critter)), cows_from(0));
}

fn pig_cp() i64 {
    return 128022;
}

fn pig_height() f64 {
    return @as(f64, @bitCast(@as(i64, 4607632778762754458)));
}

fn pig_novelty_count() i64 {
    return 2;
}

fn pig_dist_before_end() f64 {
    return @as(f64, @bitCast(@as(i64, 4633641066610819072)));
}

fn gaze_pig_along_offset() f64 {
    return @as(f64, @bitCast(@as(i64, 4611686018427387904)));
}

fn big_herd_cols() i64 {
    return 7;
}

fn big_herd_rows() i64 {
    return 7;
}

fn pig_col_spacing() f64 {
    return @as(f64, @bitCast(@as(i64, 4616189618054758400)));
}

fn pig_row_depth() f64 {
    return @as(f64, @bitCast(@as(i64, 4618441417868443648)));
}

fn pig_jitter_along() f64 {
    return @as(f64, @bitCast(@as(i64, 4608083138725491507)));
}

fn pig_jitter_across() f64 {
    return @as(f64, @bitCast(@as(i64, 4607182418800017408)));
}

fn pig_herd_first_col() f64 {
    return (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4618441417868443648))));
}

fn pig_back_row_offset() f64 {
    return @as(f64, @bitCast(@as(i64, 4618441417868443648)));
}

fn gaze_pig(length: f64, lane_half: f64) Critter {
    return cx_new(CritterS{ .along = ((length - pig_dist_before_end()) + gaze_pig_along_offset()), .across = (lane_half + herd_road_offset()), .codepoint = pig_cp(), .height = pig_height(), .face_right = false });
}

fn herd_pig_at(base_: f64, r_: i64, c_: i64) Critter {
    return b0: { const i_: f64 = cx_real_from_int(((r_ *% big_herd_cols()) +% c_)); break :b0 b1: { const fr: f64 = cx_real_from_int(r_); break :b1 b2: { const fc: f64 = cx_real_from_int(c_); break :b2 b3: { const along: f64 = ((((base_ + pig_herd_first_col()) + (fc * pig_col_spacing())) + (fr * pig_row_depth())) + (pig_jitter_along() * r_sin((i_ * @as(f64, @bitCast(@as(i64, 4612361558371493478))))))); break :b3 b4: { const across: f64 = ((((lane_width() / @as(f64, @bitCast(@as(i64, 4611686018427387904)))) + herd_road_offset()) + (fr * pig_row_depth())) + (pig_jitter_across() * r_cos((i_ * @as(f64, @bitCast(@as(i64, 4610334938539176755))))))); break :b4 cx_new(CritterS{ .along = along, .across = across, .codepoint = pig_cp(), .height = pig_height(), .face_right = false }); }; }; }; }; };
}

fn herd_cols_from(base_: f64, r_: i64, c_: i64) *CxList(Critter) {
    return (if ((c_ >= big_herd_cols())) cx_ll_empty(Critter) else cx_ll_concat(cx_ll_of(Critter, &[_]Critter{ herd_pig_at(base_, r_, c_) }), herd_cols_from(base_, r_, (c_ +% 1))));
}

fn herd_rows_from(base_: f64, r_: i64) *CxList(Critter) {
    return (if ((r_ >= big_herd_rows())) cx_ll_empty(Critter) else cx_ll_concat(herd_cols_from(base_, r_, 0), herd_rows_from(base_, (r_ +% 1))));
}

fn fill_pig_herd(length: f64) *CxList(Critter) {
    return herd_rows_from((length - pig_dist_before_end()), 0);
}

fn pig_row_front() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4618441417868443648)))), (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4611686018427387904)))), @as(f64, @bitCast(@as(i64, 4611686018427387904))), @as(f64, @bitCast(@as(i64, 4618441417868443648))) });
}

fn pig_row_back() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4621819117588971520)))), (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4618441417868443648)))), (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4611686018427387904)))), @as(f64, @bitCast(@as(i64, 4611686018427387904))), @as(f64, @bitCast(@as(i64, 4618441417868443648))), @as(f64, @bitCast(@as(i64, 4621819117588971520))) });
}

fn row_pigs_at(base_: f64, across: f64, ds: *CxList(f64), i_: i64) *CxList(Critter) {
    return (if ((i_ >= cx_list_len(ds))) cx_ll_empty(Critter) else cx_ll_concat(cx_ll_of(Critter, &[_]Critter{ cx_new(CritterS{ .along = (base_ + cx_list_at(ds, i_)), .across = across, .codepoint = pig_cp(), .height = pig_height(), .face_right = false }) }), row_pigs_at(base_, across, ds, (i_ +% 1))));
}

fn fill_pig_row(length: f64) *CxList(Critter) {
    return b0: { const base_: f64 = (length - pig_dist_before_end()); break :b0 b1: { const edge: f64 = ((lane_width() / @as(f64, @bitCast(@as(i64, 4611686018427387904)))) + herd_road_offset()); break :b1 cx_ll_concat(row_pigs_at(base_, edge, pig_row_front(), 0), row_pigs_at(base_, (edge + pig_back_row_offset()), pig_row_back(), 0)); }; };
}

fn cfg(len_: f64, sch: Scheme, turn: f64, c_: bool, p_: bool, b_: bool, t: bool, cr: Creature) Cfg {
    return cx_new(CfgS{ .length = len_, .scheme = sch, .turn_deg = turn, .cat = c_, .pigs = p_, .bull = b_, .terminates = t, .creature = cr });
}

fn route() *CxList(Cfg) {
    return cx_ll_of(Cfg, &[_]Cfg{ cfg(@as(f64, @bitCast(@as(i64, 4647503709213818880))), Scheme.AllGreen, @as(f64, @bitCast(@as(i64, 4632233691727265792))), false, false, false, false, Creature.Elephant), cfg(@as(f64, @bitCast(@as(i64, 4644337115725824000))), Scheme.AllGreen, (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4634626229029306368)))), true, false, false, false, Creature.Elephant), cfg(@as(f64, @bitCast(@as(i64, 4645744490609377280))), Scheme.AllGreen, @as(f64, @bitCast(@as(i64, 4626322717216342016))), false, true, false, false, Creature.Elephant), cfg(@as(f64, @bitCast(@as(i64, 4643985272004935680))), Scheme.YellowGreen, @as(f64, @bitCast(@as(i64, 4626322717216342016))), false, false, false, false, Creature.Elephant), cfg(@as(f64, @bitCast(@as(i64, 4643985272004935680))), Scheme.AllGreen, (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4634626229029306368)))), false, false, true, false, Creature.Giraffe), cfg(@as(f64, @bitCast(@as(i64, 4643985272004935680))), Scheme.AllGreen, (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4634626229029306368)))), false, false, true, false, Creature.Elephant), cfg(@as(f64, @bitCast(@as(i64, 4652992471259676672))), Scheme.RedGreen, @as(f64, @bitCast(@as(i64, 4635329916471083008))), false, false, true, false, Creature.Rhino), cfg(@as(f64, @bitCast(@as(i64, 4643985272004935680))), Scheme.AllGreen, @as(f64, @bitCast(@as(i64, 4624633867356078080))), false, false, true, false, Creature.Elephant), cfg(@as(f64, @bitCast(@as(i64, 4643985272004935680))), Scheme.AllGreen, (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4634626229029306368)))), false, false, true, false, Creature.Elephant), cfg(@as(f64, @bitCast(@as(i64, 4650248090236747776))), Scheme.AllGreen, @as(f64, @bitCast(@as(i64, 4624633867356078080))), false, false, true, false, Creature.Elephant), cfg(@as(f64, @bitCast(@as(i64, 4643985272004935680))), Scheme.AllGreen, @as(f64, @bitCast(@as(i64, 4624633867356078080))), false, true, true, false, Creature.Elephant), cfg(@as(f64, @bitCast(@as(i64, 4643985272004935680))), Scheme.AllGreen, @as(f64, @bitCast(@as(i64, 4624633867356078080))), false, true, true, false, Creature.Elephant), cfg(@as(f64, @bitCast(@as(i64, 4643985272004935680))), Scheme.RedGreen, @as(f64, @bitCast(@as(i64, 4624633867356078080))), true, true, true, false, Creature.DuckPond), cfg(@as(f64, @bitCast(@as(i64, 4645744490609377280))), Scheme.AllGreen, (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4632233691727265792)))), false, true, true, false, Creature.Elephant), cfg(@as(f64, @bitCast(@as(i64, 4643985272004935680))), Scheme.AllGreen, @as(f64, @bitCast(@as(i64, 4632233691727265792))), false, true, true, false, Creature.Elephant), cfg(@as(f64, @bitCast(@as(i64, 4643985272004935680))), Scheme.RedGreen, (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4632233691727265792)))), false, false, true, false, Creature.Zebra), cfg(@as(f64, @bitCast(@as(i64, 4643985272004935680))), Scheme.AllGreen, @as(f64, @bitCast(@as(i64, 4632233691727265792))), false, true, true, false, Creature.Elephant), cfg(@as(f64, @bitCast(@as(i64, 4643985272004935680))), Scheme.AllGreen, (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4632233691727265792)))), false, true, true, false, Creature.Elephant), cfg(@as(f64, @bitCast(@as(i64, 4643985272004935680))), Scheme.RedGreen, @as(f64, @bitCast(@as(i64, 0))), true, true, true, true, Creature.NoCreature) });
}

fn next_tree_loop(ts: *CxList(Tree), desired: f64, i_: i64, found: bool, best: f64) f64 {
    return (if ((i_ >= cx_list_len(ts))) (if (found) best else desired) else next_tree_step(ts, desired, i_, found, best));
}

fn next_tree_step(ts: *CxList(Tree), desired: f64, i_: i64, found: bool, best: f64) f64 {
    return b0: { const t = cx_list_at(ts, i_); break :b0 b1: { const take: bool = (if ((t.across > @as(f64, @bitCast(@as(i64, 0))))) (if ((t.along >= desired)) (if (found) (t.along < best) else true) else false) else false); break :b1 (if (take) next_tree_loop(ts, desired, (i_ +% 1), true, t.along) else next_tree_loop(ts, desired, (i_ +% 1), found, best)); }; };
}

fn heading_step(i_: i64) f64 {
    return b0: { const c_ = cx_list_at(route(), i_); break :b0 (@as(f64, (if ((c_.turn_deg >= @as(f64, @bitCast(@as(i64, 0))))) @as(f64, @bitCast(@as(i64, 4607182418800017408))) else (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4607182418800017408)))))) * (real_abs(c_.turn_deg) * deg())); };
}

fn heading_at(i_: i64) f64 {
    return @as(f64, (if ((i_ <= 0)) @as(f64, @bitCast(@as(i64, 0))) else (heading_at((i_ -% 1)) + heading_step((i_ -% 1)))));
}

fn pig_count_to(i_: i64, acc_: i64) i64 {
    var _tl_i = i_;
    var _tl_acc = acc_;
    while (true) {
        if ((_tl_i <= 0)) { return _tl_acc; } else { { const _tj1_0 = (_tl_i -% 1); const _tj1_1 = (if (cx_list_at(route(), (_tl_i -% 1)).pigs) (_tl_acc +% 1) else _tl_acc); _tl_i = _tj1_0; _tl_acc = _tj1_1; continue; } }
    }
}

fn segment_at(i_: i64) Segment {
    return b0: { const c_ = cx_list_at(route(), i_); break :b0 b1: { const angle: f64 = (real_abs(c_.turn_deg) * deg()); break :b1 b2: { const trees = fill_trees(c_.scheme, c_.length, tree_start_inset(), 0, 0); break :b2 b3: { const distract: bool = (if (c_.pigs) (pig_count_to((i_ +% 1), 0) <= pig_novelty_count()) else false); break :b3 cx_new(SegmentS{ .length = c_.length, .width = lane_width(), .trees = trees, .cows = fill_cows(c_.bull), .pigs = (if (c_.pigs) (if (distract) fill_pig_herd(c_.length) else fill_pig_row(c_.length)) else cx_ll_empty(Critter)), .pigs_distract = distract, .exit_angle = angle, .exit_right = (c_.turn_deg >= @as(f64, @bitCast(@as(i64, 0)))), .exit_to = (if (c_.terminates) i_ else (i_ +% 1)), .commit_along = (if (c_.terminates) c_.length else (c_.length - ((lane_width() / @as(f64, @bitCast(@as(i64, 4611686018427387904)))) / r_tan(angle)))), .north_heading = heading_at(i_), .has_mid_tower = (c_.length > mid_tower_min_length()), .has_cat = c_.cat, .cat = cat_make((lane_width() / @as(f64, @bitCast(@as(i64, 4611686018427387904)))), tree_road_offset(), next_tree_loop(trees, cat_along(), 0, false, @as(f64, @bitCast(@as(i64, 0))))), .terminates = c_.terminates, .exit_creature = (if (c_.terminates) Creature.NoCreature else c_.creature) }); }; }; }; };
}

fn segments_from(i_: i64) *CxList(Segment) {
    return (if ((i_ >= cx_list_len(route()))) cx_ll_empty(Segment) else cx_ll_concat(cx_ll_of(Segment, &[_]Segment{ segment_at(i_) }), segments_from((i_ +% 1))));
}

fn build_world() *CxList(Segment) {
    return segments_from(0);
}

fn route_distance_from(ss: *CxList(Segment), seg: i64, i_: i64) f64 {
    return @as(f64, (if ((i_ >= seg)) @as(f64, @bitCast(@as(i64, 0))) else (cx_list_at(ss, i_).length + route_distance_from(ss, seg, (i_ +% 1)))));
}

fn route_distance(ss: *CxList(Segment), seg: i64, along: f64) f64 {
    return (route_distance_from(ss, seg, 0) + along);
}

fn v_base() f64 {
    return @as(f64, @bitCast(@as(i64, 4599075939470750515)));
}

fn initial_rider_state() RiderState {
    return cx_new(RiderStateS{ .segment = 0, .along = @as(f64, @bitCast(@as(i64, 0))), .across = @as(f64, @bitCast(@as(i64, 0))), .yaw = @as(f64, @bitCast(@as(i64, 0))), .v_ = v_base(), .tilt = @as(f64, @bitCast(@as(i64, 0))), .heading = @as(f64, @bitCast(@as(i64, 0))), .gaze_yaw = @as(f64, @bitCast(@as(i64, 0))), .focus = @as(f64, @bitCast(@as(i64, 0))) });
}

fn gaze_look_dist() f64 {
    return @as(f64, @bitCast(@as(i64, 4639481672377565184)));
}

fn gaze_release_angle() f64 {
    return (@as(f64, @bitCast(@as(i64, 4630122629401935872))) * deg());
}

fn gaze_swivel_rate() f64 {
    return (@as(f64, @bitCast(@as(i64, 4616189618054758400))) * deg());
}

fn gaze_return_rate() f64 {
    return (@as(f64, @bitCast(@as(i64, 4596373779694328218))) * deg());
}

fn gaze_return_ease() f64 {
    return @as(f64, @bitCast(@as(i64, 4587366580439587226)));
}

fn gaze_return_snap() f64 {
    return (@as(f64, @bitCast(@as(i64, 4581421828931458171))) * deg());
}

fn focus_decay() f64 {
    return @as(f64, @bitCast(@as(i64, 4563176846121054817)));
}

fn pig_gaze_speed() f64 {
    return @as(f64, @bitCast(@as(i64, 4596373779694328218)));
}

fn pig_gaze_settle_dist() f64 {
    return @as(f64, @bitCast(@as(i64, 4627730092099895296)));
}

fn eyes_on_road_yaw() f64 {
    return (@as(f64, @bitCast(@as(i64, 4618441417868443648))) * deg());
}

fn no_look() PigLook {
    return cx_new(PigLookS{ .looking = false, .dist = @as(f64, @bitCast(@as(i64, 0))) });
}

fn pig_ahead_near(state: RiderState, seg: Segment) PigLook {
    return b0: { const pig = gaze_pig(seg.length, (seg.width / @as(f64, @bitCast(@as(i64, 4611686018427387904))))); break :b0 b1: { const dist: f64 = (pig.along - state.along); break :b1 (if ((dist > gaze_look_dist())) no_look() else pig_ahead_bearing(state, pig, dist)); }; };
}

fn pig_ahead_bearing(state: RiderState, pig: Critter, dist: f64) PigLook {
    return b0: { const bearing: f64 = (r_atan2((pig.across - state.across), dist) - state.yaw); break :b0 (if ((real_abs(bearing) >= gaze_release_angle())) no_look() else cx_new(PigLookS{ .looking = true, .dist = dist })); };
}

fn desired_gaze(state: RiderState, seg: Segment) f64 {
    return @as(f64, (if (((if ((seg.pigs_distract == false)) no_look() else (if ((real_abs(state.yaw) > eyes_on_road_yaw())) no_look() else pig_ahead_near(state, seg))).looking == false)) @as(f64, @bitCast(@as(i64, 0))) else desired_gaze_at(state, gaze_pig(seg.length, (seg.width / @as(f64, @bitCast(@as(i64, 4611686018427387904))))))));
}

fn desired_gaze_at(state: RiderState, pig: Critter) f64 {
    return (r_atan2((pig.across - state.across), (pig.along - state.along)) - state.yaw);
}

fn next_rider_gaze(state: RiderState, segs: *CxList(Segment)) RiderState {
    return b0: { const want: f64 = desired_gaze(state, cx_list_at(segs, state.segment)); break :b0 b1: { const gy: f64 = (if (((want == @as(f64, @bitCast(@as(i64, 0)))) == false)) (state.gaze_yaw + real_max((@as(f64, @bitCast(@as(i64, 0))) - gaze_swivel_rate()), real_min(gaze_swivel_rate(), (want - state.gaze_yaw)))) else @as(f64, (if ((real_abs(state.gaze_yaw) <= gaze_return_snap())) @as(f64, @bitCast(@as(i64, 0))) else (state.gaze_yaw - (r_sign(state.gaze_yaw) * real_min(gaze_return_rate(), (real_abs(state.gaze_yaw) * gaze_return_ease()))))))); break :b1 cx_new(RiderStateS{ .segment = state.segment, .along = state.along, .across = state.across, .yaw = state.yaw, .v_ = state.v_, .tilt = state.tilt, .heading = state.heading, .gaze_yaw = gy, .focus = (if ((gy == @as(f64, @bitCast(@as(i64, 0))))) real_max(@as(f64, @bitCast(@as(i64, 0))), (state.focus - focus_decay())) else real_max(state.focus, real_min((real_abs(gy) / gaze_release_angle()), @as(f64, @bitCast(@as(i64, 4607182418800017408)))))) }); }; };
}

fn gawk_engaged(state: RiderState, seg: Segment) bool {
    return (if ((seg.pigs_distract == false)) false else (state.along >= (gaze_pig(seg.length, (seg.width / @as(f64, @bitCast(@as(i64, 4611686018427387904))))).along - gaze_look_dist())));
}

fn pig_gaze_brake_easing(state: RiderState, seg: Segment) GazeBrake {
    return b0: { const d_: f64 = ((gaze_pig(seg.length, (seg.width / @as(f64, @bitCast(@as(i64, 4611686018427387904))))).along - state.along) - pig_gaze_settle_dist()); break :b0 cx_new(GazeBrakeS{ .engaged = true, .accel = (((pig_gaze_speed() * pig_gaze_speed()) - (state.v_ * state.v_)) / (@as(f64, @bitCast(@as(i64, 4611686018427387904))) * real_max(d_, @as(f64, @bitCast(@as(i64, 4607182418800017408)))))) }); };
}

fn yaw_per_tilt() f64 {
    return @as(f64, @bitCast(@as(i64, 4591870180066957722)));
}

fn a_accel() f64 {
    return @as(f64, @bitCast(@as(i64, 4576918229304087675)));
}

fn v_max() f64 {
    return @as(f64, @bitCast(@as(i64, 4612811918334230528)));
}

fn approach_intersection_dist() f64 {
    return @as(f64, @bitCast(@as(i64, 4633641066610819072)));
}

fn straighten_margin() f64 {
    return @as(f64, @bitCast(@as(i64, 4587366580439587226)));
}

fn turn_danger_steps() i64 {
    return 2000;
}

fn min_forward_progress() f64 {
    return @as(f64, @bitCast(@as(i64, 4627730092099895296)));
}

fn tilt_hold() f64 {
    return (@as(f64, @bitCast(@as(i64, 4611686018427387904))) * deg());
}

fn brake_decay() f64 {
    return @as(f64, @bitCast(@as(i64, 4626322717216342016)));
}

fn asymptote_tuning() f64 {
    return @as(f64, @bitCast(@as(i64, 4599075939470750515)));
}

fn center_lane_epsilon() f64 {
    return @as(f64, @bitCast(@as(i64, 4585925428558828667)));
}

fn max_tilt_correction() f64 {
    return (@as(f64, @bitCast(@as(i64, 4607182418800017408))) * deg());
}

fn lean_search_iters() i64 {
    return 12;
}

fn simulate_rider_step(s_: RiderState, tilt_step: f64, accel: f64) RiderState {
    return b0: { const tilt: f64 = (s_.tilt + tilt_step); break :b0 b1: { const v_: f64 = (s_.v_ + accel); break :b1 b2: { const heading_change: f64 = (yaw_per_tilt() * tilt); break :b2 b3: { const mid: f64 = (s_.yaw + (heading_change / @as(f64, @bitCast(@as(i64, 4611686018427387904))))); break :b3 cx_new(RiderStateS{ .segment = s_.segment, .along = (s_.along + (v_ * r_cos(mid))), .across = (s_.across + (v_ * r_sin(mid))), .yaw = (s_.yaw + heading_change), .v_ = v_, .tilt = tilt, .heading = (s_.heading + heading_change), .gaze_yaw = s_.gaze_yaw, .focus = s_.focus }); }; }; }; };
}

fn no_frames() f64 {
    return @as(f64, @bitCast(@as(i64, 4741671816366391296)));
}

fn sim_loop(start_: RiderState, left_bound: f64, right_bound: f64, start_side: f64, start_along: f64, crossed: bool, i_: i64, phys: RiderState) PathSim {
    return (if ((i_ >= turn_danger_steps())) cx_new(PathSimS{ .side = Side.SideNone, .forward = (phys.along - start_along), .crossed = crossed, .end_across = phys.across, .frames = no_frames() }) else sim_step(start_, left_bound, right_bound, start_side, start_along, crossed, i_, simulate_rider_step(phys, @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))))));
}

fn sim_step(start_: RiderState, left_bound: f64, right_bound: f64, start_side: f64, start_along: f64, crossed0: bool, i_: i64, phys: RiderState) PathSim {
    return b0: { const across: f64 = phys.across; break :b0 b1: { const forward: f64 = (phys.along - start_along); break :b1 b2: { const crossed: bool = (if (((across * start_side) < @as(f64, @bitCast(@as(i64, 0))))) true else crossed0); break :b2 (if ((across < left_bound)) cx_new(PathSimS{ .side = Side.SideLeft, .forward = real_min(forward, min_forward_progress()), .crossed = crossed, .end_across = across, .frames = cx_real_from_int(i_) }) else (if ((across > right_bound)) cx_new(PathSimS{ .side = Side.SideRight, .forward = real_min(forward, min_forward_progress()), .crossed = crossed, .end_across = across, .frames = cx_real_from_int(i_) }) else (if ((forward < @as(f64, @bitCast(@as(i64, 0))))) cx_new(PathSimS{ .side = Side.SideNone, .forward = forward, .crossed = crossed, .end_across = across, .frames = no_frames() }) else (if ((forward >= min_forward_progress())) cx_new(PathSimS{ .side = Side.SideNone, .forward = min_forward_progress(), .crossed = crossed, .end_across = across, .frames = no_frames() }) else sim_loop(start_, left_bound, right_bound, start_side, start_along, crossed, (i_ +% 1), phys))))); }; }; };
}

fn simulate_rider_path(state: RiderState, seg: Segment) PathSim {
    return b0: { const inset_hw: f64 = ((seg.width / @as(f64, @bitCast(@as(i64, 4611686018427387904)))) - straighten_margin()); break :b0 b1: { const right_bound: f64 = real_max(inset_hw, state.across); break :b1 b2: { const left_bound: f64 = real_min((@as(f64, @bitCast(@as(i64, 0))) - inset_hw), state.across); break :b2 sim_loop(state, left_bound, right_bound, r_sign(state.across), state.along, false, 0, state); }; }; };
}

fn want_more_right(sim: PathSim, target: f64) bool {
    return switch (sim.side) { .SideLeft => true, .SideRight => false, .SideNone => (sim.end_across < target),  };
}

fn lean_target(across: f64) f64 {
    return (if ((real_abs(across) < center_lane_epsilon())) (if ((across >= @as(f64, @bitCast(@as(i64, 0))))) center_lane_epsilon() else (@as(f64, @bitCast(@as(i64, 0))) - center_lane_epsilon())) else (across * asymptote_tuning()));
}

fn with_tilt(s_: RiderState, t: f64) RiderState {
    return cx_new(RiderStateS{ .segment = s_.segment, .along = s_.along, .across = s_.across, .yaw = s_.yaw, .v_ = s_.v_, .tilt = t, .heading = s_.heading, .gaze_yaw = s_.gaze_yaw, .focus = s_.focus });
}

fn search_lean(state: RiderState, seg: Segment, target: f64, lo: f64, hi: f64, i_: i64) f64 {
    return (if ((i_ >= lean_search_iters())) ((lo + hi) / @as(f64, @bitCast(@as(i64, 4611686018427387904)))) else search_step(state, seg, target, lo, hi, i_, ((lo + hi) / @as(f64, @bitCast(@as(i64, 4611686018427387904))))));
}

fn search_step(state: RiderState, seg: Segment, target: f64, lo: f64, hi: f64, i_: i64, mid: f64) f64 {
    return (if (want_more_right(simulate_rider_path(with_tilt(state, mid), seg), target)) search_lean(state, seg, target, mid, hi, (i_ +% 1)) else search_lean(state, seg, target, lo, mid, (i_ +% 1)));
}

fn turn_speed(angle_rad: f64) f64 {
    return b0: { const d_: f64 = round_real(((angle_rad * @as(f64, @bitCast(@as(i64, 4640537203540230144)))) / pi())); break :b0 @as(f64, (if ((d_ == @as(f64, @bitCast(@as(i64, 4624633867356078080))))) @as(f64, @bitCast(@as(i64, 4608519987889346445))) else @as(f64, (if ((d_ == @as(f64, @bitCast(@as(i64, 4626322717216342016))))) @as(f64, @bitCast(@as(i64, 4605741266919258849))) else @as(f64, (if ((d_ == @as(f64, @bitCast(@as(i64, 4629137466983448576))))) @as(f64, @bitCast(@as(i64, 4601976257630777115))) else @as(f64, (if ((d_ == @as(f64, @bitCast(@as(i64, 4632233691727265792))))) @as(f64, @bitCast(@as(i64, 4597166413228745425))) else @as(f64, (if ((d_ == @as(f64, @bitCast(@as(i64, 4634626229029306368))))) @as(f64, @bitCast(@as(i64, 4594176023076171416))) else @as(f64, (if ((d_ == @as(f64, @bitCast(@as(i64, 4635329916471083008))))) @as(f64, @bitCast(@as(i64, 4593095159165602497))) else @as(f64, @bitCast(@as(i64, 4597166413228745425))))))))))))))); };
}

fn corner_brake(state: RiderState, seg: Segment, v_end: f64, a_: f64) f64 {
    return b0: { const d_: f64 = (seg.commit_along - state.along); break :b0 b1: { const corner_a: f64 = @as(f64, (if ((d_ <= @as(f64, @bitCast(@as(i64, 4517329193108106637))))) @as(f64, @bitCast(@as(i64, 0))) else (((v_end * v_end) - (state.v_ * state.v_)) / (@as(f64, @bitCast(@as(i64, 4611686018427387904))) * d_)))); break :b1 (if ((corner_a < a_)) corner_a else a_); }; };
}

fn pig_gate(state: RiderState, seg: Segment, a_: f64) f64 {
    return b0: { const b_ = (if ((gawk_engaged(state, seg) == false)) cx_new(GazeBrakeS{ .engaged = false, .accel = @as(f64, @bitCast(@as(i64, 0))) }) else (if ((state.v_ <= pig_gaze_speed())) cx_new(GazeBrakeS{ .engaged = true, .accel = @as(f64, @bitCast(@as(i64, 0))) }) else pig_gaze_brake_easing(state, seg))); break :b0 (if (b_.engaged) (if ((b_.accel < a_)) b_.accel else a_) else a_); };
}

fn shoulder_brake(state: RiderState, seg: Segment, a_: f64) f64 {
    return b0: { const sim = simulate_rider_path(state, seg); break :b0 (if (side_none(sim)) a_ else shoulder_brake_at(state, sim, a_)); };
}

fn side_none(sim: PathSim) bool {
    return switch (sim.side) { .SideNone => true, .SideLeft => false, .SideRight => false,  };
}

fn shoulder_brake_at(state: RiderState, sim: PathSim, a_: f64) f64 {
    return b0: { const n_: f64 = sim.frames; break :b0 b1: { const sa: f64 = (((@as(f64, @bitCast(@as(i64, 0))) - state.v_) / (@as(f64, @bitCast(@as(i64, 4611686018427387904))) * real_max(n_, @as(f64, @bitCast(@as(i64, 4607182418800017408)))))) * exp_real(((@as(f64, @bitCast(@as(i64, 0))) - n_) / brake_decay()))); break :b1 (if ((sa < a_)) sa else a_); }; };
}

fn clamp_v(state: RiderState, seg: Segment, v_end: f64, v0: f64, _arg_near: bool) f64 {
    return b0: { const v1: f64 = (if ((v0 > v_max())) v_max() else v0); break :b0 b1: { const v2: f64 = @as(f64, (if ((v1 < @as(f64, @bitCast(@as(i64, 0))))) @as(f64, @bitCast(@as(i64, 0))) else v1)); break :b1 (if (_arg_near) (if ((v2 < v_end)) (if (gawk_engaged(state, seg)) v2 else v_end) else v2) else v2); }; };
}

fn get_forward_accel_decel(state: RiderState, seg: Segment) f64 {
    return b0: { const a0: f64 = @as(f64, (if ((real_abs(state.tilt) >= tilt_hold())) @as(f64, @bitCast(@as(i64, 0))) else a_accel())); break :b0 b1: { const v_end: f64 = @as(f64, (if (seg.terminates) @as(f64, @bitCast(@as(i64, 0))) else turn_speed(seg.exit_angle))); break :b1 b2: { const _v2_near: bool = ((seg.length - state.along) <= approach_intersection_dist()); break :b2 b3: { const a1: f64 = (if (_v2_near) corner_brake(state, seg, v_end, a0) else a0); break :b3 b4: { const a3: f64 = pig_gate(state, seg, (if (seg.has_cat) (if ((a1 > @as(f64, @bitCast(@as(i64, 0))))) @as(f64, (if (cat_in_danger((seg.cat.along - state.along), state.v_)) @as(f64, @bitCast(@as(i64, 0))) else a1)) else a1) else a1)); break :b4 b5: { const a4: f64 = shoulder_brake(state, seg, a3); break :b5 (clamp_v(state, seg, v_end, (state.v_ + a4), _v2_near) - state.v_); }; }; }; }; }; };
}

fn decide(state: RiderState, seg: Segment) Decision {
    return b0: { const tilt_step: f64 = (search_lean(state, seg, lean_target(state.across), (state.tilt - max_tilt_correction()), (state.tilt + max_tilt_correction()), 0) - state.tilt); break :b0 cx_new(DecisionS{ .tilt_step = tilt_step, .accel = get_forward_accel_decel(with_tilt(state, (state.tilt + tilt_step)), seg) }); };
}

fn rider_state_for_next_segment(rs: RiderState, segs: *CxList(Segment)) RiderState {
    return b0: { const seg = cx_list_at(segs, rs.segment); break :b0 b1: { const hw: f64 = (seg.width / @as(f64, @bitCast(@as(i64, 4611686018427387904)))); break :b1 b2: { const theta: f64 = seg.exit_angle; break :b2 b3: { const sgn: f64 = @as(f64, (if (seg.exit_right) @as(f64, @bitCast(@as(i64, 4607182418800017408))) else (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4607182418800017408)))))); break :b3 b4: { const c_: f64 = r_cos(theta); break :b4 b5: { const s_: f64 = r_sin(theta); break :b5 b6: { const da: f64 = (rs.along - (seg.length + (hw * s_))); break :b6 b7: { const dx: f64 = (rs.across - ((sgn * hw) * (@as(f64, @bitCast(@as(i64, 4607182418800017408))) - c_))); break :b7 cx_new(RiderStateS{ .segment = seg.exit_to, .along = ((c_ * da) + ((sgn * s_) * dx)), .across = ((((@as(f64, @bitCast(@as(i64, 0))) - sgn) * s_) * da) + (c_ * dx)), .yaw = (rs.yaw - (sgn * theta)), .v_ = rs.v_, .tilt = rs.tilt, .heading = rs.heading, .gaze_yaw = @as(f64, @bitCast(@as(i64, 0))), .focus = rs.focus }); }; }; }; }; }; }; }; };
}

fn finish_clamp(moved: RiderState, seg: Segment) RiderState {
    return b0: { const in_zone: bool = ((seg.length - moved.along) < approach_intersection_dist()); break :b0 (if ((moved.along >= seg.length)) stopped_at(moved, seg.length) else (if (in_zone) (if ((moved.v_ < @as(f64, @bitCast(@as(i64, 4591870180066957722))))) stopped_at(moved, seg.length) else moved) else moved)); };
}

fn stopped_at(s_: RiderState, at: f64) RiderState {
    return cx_new(RiderStateS{ .segment = s_.segment, .along = at, .across = s_.across, .yaw = s_.yaw, .v_ = @as(f64, @bitCast(@as(i64, 0))), .tilt = s_.tilt, .heading = s_.heading, .gaze_yaw = s_.gaze_yaw, .focus = s_.focus });
}

fn resolve_cross(moved: RiderState, seg: Segment, segs: *CxList(Segment)) RiderState {
    return b0: { const on_next = rider_state_for_next_segment(moved, segs); break :b0 (if ((real_abs(on_next.across) < (cx_list_at(segs, seg.exit_to).width / @as(f64, @bitCast(@as(i64, 4611686018427387904)))))) on_next else moved); };
}

fn get_next_rider_state(state: RiderState, segs: *CxList(Segment)) RiderState {
    return b0: { const seg = cx_list_at(segs, state.segment); break :b0 b1: { const dec = decide(state, seg); break :b1 b2: { const moved = simulate_rider_step(state, dec.tilt_step, dec.accel); break :b2 b3: { const resolved = (if (seg.terminates) finish_clamp(moved, seg) else resolve_cross(moved, seg, segs)); break :b3 next_rider_gaze(resolved, segs); }; }; }; };
}

fn is_finished(s_: RiderState, segs: *CxList(Segment)) bool {
    return b0: { const seg = cx_list_at(segs, s_.segment); break :b0 (if (seg.terminates) (s_.along >= seg.length) else false); };
}

fn near() f64 {
    return @as(f64, @bitCast(@as(i64, 4600877379321698714)));
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

fn g_abs(x: f64) f64 {
    return (if ((x < @as(f64, @bitCast(@as(i64, 0))))) (@as(f64, @bitCast(@as(i64, 0))) - x) else x);
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

fn bool_eq(a_: bool, b_: bool) bool {
    return (if (a_) b_ else (if (b_) false else true));
}

fn first_bool_diff(got: *CxList(bool), want: *CxList(bool), i_: i64) i64 {
    var _tl_i = i_;
    while (true) {
        if ((_tl_i >= cx_list_len(got))) { return (0 -% 1); } else { if (bool_eq(cx_list_at(got, _tl_i), cx_list_at(want, _tl_i))) { { const _tj2_2 = (_tl_i +% 1); _tl_i = _tj2_2; continue; } } else { return _tl_i; } }
    }
}

fn grade_bools(name: []const u8, got: *CxList(bool), want: *CxList(bool)) []const u8 {
    return (if ((cx_list_len(got) != cx_list_len(want))) cx_concat(cx_concat(cx_concat(cx_concat(name, "\x02\x3a\x29\x30\x02\x17\x0d\x12\x1d\x0e\x14\x02"), cx_show_int(cx_list_len(got))), "\x02\x1b\x0f\x12\x0e\x02"), cx_show_int(cx_list_len(want))) else b1: { const i_: i64 = first_bool_diff(got, want, 0); break :b1 (if ((i_ < 0)) cx_concat(cx_concat(name, "\x02\x10\x22\x02"), cx_show_int(cx_list_len(got))) else cx_concat(cx_concat(name, "\x02\x3a\x29\x30\x02\x0f\x0e\x02"), cx_show_int(i_))); });
}

fn g_rd_firstbad() *CxList(i64) {
    return cx_ll_of(i64, &[_]i64{ -1, -1, -1, -1, -1, -1, -1, -1 });
}

fn g_rd_segs() *CxList(i64) {
    return cx_ll_of(i64, &[_]i64{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18 });
}

fn g_rd_sample() *CxList(f64) {
    @setEvalBranchQuota(1000000);
    return cx_ll_of(f64, &[_]f64{ @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4635365096621047189))), @as(f64, @bitCast(@as(i64, 4643299173582609968))), @as(f64, @bitCast(@as(i64, 4647302586546866094))), @as(f64, @bitCast(@as(i64, 4647719317638604359))), @as(f64, @bitCast(@as(i64, 4648499174144219367))), @as(f64, @bitCast(@as(i64, 4649856361511659556))), @as(f64, @bitCast(@as(i64, 4650436367969060232))), @as(f64, @bitCast(@as(i64, 4650805733507248790))), @as(f64, @bitCast(@as(i64, 4652038656709345642))), @as(f64, @bitCast(@as(i64, 4652681566754736964))), @as(f64, @bitCast(@as(i64, 4652784497315868888))), @as(f64, @bitCast(@as(i64, 4652872463523746782))), @as(f64, @bitCast(@as(i64, 4652960429731624675))), @as(f64, @bitCast(@as(i64, 4653048395939502568))), @as(f64, @bitCast(@as(i64, 4653169880979255538))), @as(f64, @bitCast(@as(i64, 4653638146708753246))), @as(f64, @bitCast(@as(i64, 4654383511798487712))), @as(f64, @bitCast(@as(i64, 4654700855923128979))), @as(f64, @bitCast(@as(i64, 4655417373346187811))), @as(f64, @bitCast(@as(i64, 4655725727863760382))), @as(f64, @bitCast(@as(i64, 4655906685047655105))), @as(f64, @bitCast(@as(i64, 4656519882242661129))), @as(f64, @bitCast(@as(i64, 4656877928528544059))), @as(f64, @bitCast(@as(i64, 4656925631500222097))), @as(f64, @bitCast(@as(i64, 4657168024556025781))), @as(f64, @bitCast(@as(i64, 4657629200414645263))), @as(f64, @bitCast(@as(i64, 4658178956228533263))), @as(f64, @bitCast(@as(i64, 4658728712042421263))), @as(f64, @bitCast(@as(i64, 4659278467856309263))), @as(f64, @bitCast(@as(i64, 4659518107954899321))), @as(f64, @bitCast(@as(i64, 4659580163071757045))), @as(f64, @bitCast(@as(i64, 4659847907567162360))), @as(f64, @bitCast(@as(i64, 4660217230664202086))), @as(f64, @bitCast(@as(i64, 4660432423561553196))), @as(f64, @bitCast(@as(i64, 4660812469095986994))), @as(f64, @bitCast(@as(i64, 4660848651384829195))), @as(f64, @bitCast(@as(i64, 4661000117247941385))), @as(f64, @bitCast(@as(i64, 4661298613104454664))), @as(f64, @bitCast(@as(i64, 4661568186307599296))), @as(f64, @bitCast(@as(i64, 4661843064214543296))), @as(f64, @bitCast(@as(i64, 4661998315916092244))), @as(f64, @bitCast(@as(i64, 4662126993191255985))), @as(f64, @bitCast(@as(i64, 4662161626378165813))), @as(f64, @bitCast(@as(i64, 4662183615951014357))), @as(f64, @bitCast(@as(i64, 4662205607173130342))), @as(f64, @bitCast(@as(i64, 4662227598505197489))), @as(f64, @bitCast(@as(i64, 4662263596186037387))), @as(f64, @bitCast(@as(i64, 4662392779236549906))), @as(f64, @bitCast(@as(i64, 4662582726137464488))), @as(f64, @bitCast(@as(i64, 4662673494120872280))), @as(f64, @bitCast(@as(i64, 4662834190713953137))), @as(f64, @bitCast(@as(i64, 4662938292145017481))), @as(f64, @bitCast(@as(i64, 4663060209622693655))), @as(f64, @bitCast(@as(i64, 4663290535318480172))), @as(f64, @bitCast(@as(i64, 4663348603056419766))), @as(f64, @bitCast(@as(i64, 4663429526342565940))), @as(f64, @bitCast(@as(i64, 4663619262467101478))), @as(f64, @bitCast(@as(i64, 4663677052468403896))), @as(f64, @bitCast(@as(i64, 4663747481685721088))), @as(f64, @bitCast(@as(i64, 4663927895051164713))), @as(f64, @bitCast(@as(i64, 4664005720683201954))), @as(f64, @bitCast(@as(i64, 4664068022640420114))), @as(f64, @bitCast(@as(i64, 4664240195935871697))), @as(f64, @bitCast(@as(i64, 4664334607700813939))), @as(f64, @bitCast(@as(i64, 4664387912904137821))), @as(f64, @bitCast(@as(i64, 4664550402250927768))), @as(f64, @bitCast(@as(i64, 4664662885588984136))), @as(f64, @bitCast(@as(i64, 4664713590667210654))), @as(f64, @bitCast(@as(i64, 4664849819388233961))), @as(f64, @bitCast(@as(i64, 4664990342141968384))) });
}

fn g_rd_enters() *CxList(i64) {
    return cx_ll_of(i64, &[_]i64{ 0, 317, 658, 1409, 1698, 1957, 2282, 2968, 3277, 3523, 4029, 4626, 4884, 5134, 5439, 5744, 6054, 6361, 6670 });
}

fn g_rd_frames() *CxList(i64) {
    return cx_ll_of(i64, &[_]i64{ 7000 });
}

fn g_rd_finished() *CxList(bool) {
    return cx_ll_of(bool, &[_]bool{ true });
}

fn ride_cap() i64 {
    return 20000;
}

fn yaw_slack() f64 {
    return @as(f64, @bitCast(@as(i64, 4517329193108106637)));
}

fn gaze_slack() f64 {
    return @as(f64, @bitCast(@as(i64, 4562254508917369340)));
}

fn along_slack() f64 {
    return @as(f64, @bitCast(@as(i64, 4517329193108106637)));
}

fn v_floor() f64 {
    return (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4472406533629990549))));
}

fn v_ceiling() f64 {
    return @as(f64, @bitCast(@as(i64, 4620693217682128896)));
}

fn across_slack() f64 {
    return @as(f64, @bitCast(@as(i64, 4607182418800017408)));
}

fn sample_every() i64 {
    return 100;
}

fn part_metres() f64 {
    return @as(f64, @bitCast(@as(i64, 4576918229304087675)));
}

fn entry_floor(w: *CxList(Segment), i_: i64) f64 {
    return @as(f64, (if ((i_ <= 0)) @as(f64, @bitCast(@as(i64, 0))) else b1: { const a_: f64 = cx_list_at(w, (i_ -% 1)).exit_angle; break :b1 @as(f64, (if ((a_ > @as(f64, @bitCast(@as(i64, 0))))) (@as(f64, @bitCast(@as(i64, 0))) - (cx_list_at(w, i_).width / r_sin(a_))) else @as(f64, @bitCast(@as(i64, 0))))); }));
}

fn keep(cur: i64, ok: bool, frame: i64) i64 {
    return (if (ok) cur else (if ((cur >= 0)) cur else frame));
}

fn seen_segs(segs: *CxList(i64), i_: i64) *CxList(i64) {
    return (if ((cx_list_len(segs) <= 0)) cx_ll_of(i64, &[_]i64{ i_ }) else (if ((cx_list_at(segs, (cx_list_len(segs) -% 1)) == i_)) segs else cx_ll_concat(segs, cx_ll_of(i64, &[_]i64{ i_ }))));
}

fn ride_fold(w: *CxList(Segment), s_: RiderState, c_: RideCk) RideCk {
    var _tl_s = s_;
    var _tl_c = c_;
    while (true) {
        const seg = cx_list_at(w, _tl_s.segment); const d_: f64 = sun_set_fraction(cx_real_from_int(_tl_c.frame)); const c2 = cx_new(RideCkS{ .frame = _tl_c.frame, .bad_v = keep(_tl_c.bad_v, ((_tl_s.v_ >= v_floor()) and (_tl_s.v_ <= v_ceiling())), _tl_c.frame), .bad_yaw = keep(_tl_c.bad_yaw, (g_abs(_tl_s.yaw) <= (half_pi() + yaw_slack())), _tl_c.frame), .bad_floor = keep(_tl_c.bad_floor, (_tl_s.along >= (entry_floor(w, _tl_s.segment) - along_slack())), _tl_c.frame), .bad_ceil = keep(_tl_c.bad_ceil, (_tl_s.along <= (seg.length + along_slack())), _tl_c.frame), .bad_across = keep(_tl_c.bad_across, (g_abs(_tl_s.across) <= ((seg.width / @as(f64, @bitCast(@as(i64, 4611686018427387904)))) + across_slack())), _tl_c.frame), .bad_gaze = keep(_tl_c.bad_gaze, (g_abs(_tl_s.gaze_yaw) <= (half_pi() + gaze_slack())), _tl_c.frame), .bad_focus = keep(_tl_c.bad_focus, ((_tl_s.focus >= @as(f64, @bitCast(@as(i64, 0)))) and (_tl_s.focus <= @as(f64, @bitCast(@as(i64, 4607182418800017408))))), _tl_c.frame), .bad_dusk = keep(_tl_c.bad_dusk, (d_ >= _tl_c.dusk), _tl_c.frame), .segs = seen_segs(_tl_c.segs, _tl_s.segment), .enters = (if (((cx_list_len(_tl_c.segs) > 0) and (cx_list_at(_tl_c.segs, (cx_list_len(_tl_c.segs) -% 1)) == _tl_s.segment))) _tl_c.enters else cx_ll_concat(_tl_c.enters, cx_ll_of(i64, &[_]i64{ _tl_c.frame }))), .sample = (if (((_tl_c.frame -% (@divTrunc(_tl_c.frame, sample_every()) *% sample_every())) == 0)) cx_ll_concat(_tl_c.sample, cx_ll_of(f64, &[_]f64{ route_distance(w, _tl_s.segment, _tl_s.along) })) else _tl_c.sample), .dusk = d_, .finished = _tl_c.finished }); if (is_finished(_tl_s, w)) { return cx_new(RideCkS{ .frame = c2.frame, .bad_v = c2.bad_v, .bad_yaw = c2.bad_yaw, .bad_floor = c2.bad_floor, .bad_ceil = c2.bad_ceil, .bad_across = c2.bad_across, .bad_gaze = c2.bad_gaze, .bad_focus = c2.bad_focus, .bad_dusk = c2.bad_dusk, .segs = c2.segs, .enters = c2.enters, .sample = c2.sample, .dusk = c2.dusk, .finished = true }); } else { if ((c2.frame >= ride_cap())) { return c2; } else { { const _tj5_1 = get_next_rider_state(_tl_s, w); const _tj5_2 = cx_new(RideCkS{ .frame = (c2.frame +% 1), .bad_v = c2.bad_v, .bad_yaw = c2.bad_yaw, .bad_floor = c2.bad_floor, .bad_ceil = c2.bad_ceil, .bad_across = c2.bad_across, .bad_gaze = c2.bad_gaze, .bad_focus = c2.bad_focus, .bad_dusk = c2.bad_dusk, .segs = c2.segs, .enters = c2.enters, .sample = c2.sample, .dusk = c2.dusk, .finished = c2.finished }); _tl_s = _tj5_1; _tl_c = _tj5_2; continue; } } }
    }
}

fn ride_start() RideCk {
    return cx_new(RideCkS{ .frame = 0, .bad_v = (0 -% 1), .bad_yaw = (0 -% 1), .bad_floor = (0 -% 1), .bad_ceil = (0 -% 1), .bad_across = (0 -% 1), .bad_gaze = (0 -% 1), .bad_focus = (0 -% 1), .bad_dusk = (0 -% 1), .segs = cx_ll_empty(i64), .enters = cx_ll_empty(i64), .sample = cx_ll_empty(f64), .dusk = (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4607182418800017408)))), .finished = false });
}

fn ride_result() RideCk {
    return ride_fold(build_world(), initial_rider_state(), ride_start());
}

fn part_at(r_: RideCk, n_: i64, i_: i64) i64 {
    var _tl_i = i_;
    while (true) {
        if ((_tl_i >= n_)) { return (0 -% 1); } else { if ((g_abs((cx_list_at(r_.sample, _tl_i) - cx_list_at(g_rd_sample(), _tl_i))) > part_metres())) { return _tl_i; } else { { const _tj2_2 = (_tl_i +% 1); _tl_i = _tj2_2; continue; } } }
    }
}

fn seg_span(es: *CxList(i64), i_: i64) i64 {
    return (cx_list_at(es, (i_ +% 1)) -% cx_list_at(es, i_));
}

fn worst_seg(es: *CxList(i64), n_: i64, i_: i64, best: i64, bestd: i64) i64 {
    var _tl_i = i_;
    var _tl_best = best;
    var _tl_bestd = bestd;
    while (true) {
        if (((_tl_i +% 1) >= n_)) { return _tl_best; } else { const d_: i64 = (seg_span(es, _tl_i) -% seg_span(g_rd_enters(), _tl_i)); const a_: i64 = (if ((d_ < 0)) (0 -% d_) else d_); if ((a_ > _tl_bestd)) { { const _tj4_2 = (_tl_i +% 1); const _tj4_3 = _tl_i; const _tj4_4 = a_; _tl_i = _tj4_2; _tl_best = _tj4_3; _tl_bestd = _tj4_4; continue; } } else { { const _tj4_2 = (_tl_i +% 1); const _tj4_3 = _tl_best; const _tj4_4 = _tl_bestd; _tl_i = _tj4_2; _tl_best = _tj4_3; _tl_bestd = _tj4_4; continue; } } }
    }
}

fn seg_overlap(r_: RideCk) i64 {
    return (if ((cx_list_len(r_.enters) < cx_list_len(g_rd_enters()))) cx_list_len(r_.enters) else cx_list_len(g_rd_enters()));
}

fn opening() void {
    return b0: { const r_ = ride_result(); break :b0 b1: { const n_: i64 = (if ((cx_list_len(r_.sample) < cx_list_len(g_rd_sample()))) cx_list_len(r_.sample) else cx_list_len(g_rd_sample())); break :b1 b2: { const p_: i64 = part_at(r_, n_, 0); break :b2 b3: { _ = cx_print_line(grade_ints("\x15\x16\x49\x1c\x11\x15\x13\x0e\x20\x0f\x16\x02", cx_ll_of(i64, &[_]i64{ r_.bad_v, r_.bad_yaw, r_.bad_floor, r_.bad_ceil, r_.bad_across, r_.bad_gaze, r_.bad_focus, r_.bad_dusk }), g_rd_firstbad())); _ = cx_print_line(grade_ints("\x15\x16\x49\x13\x0d\x1d\x13\x02\x02\x02\x02\x02", r_.segs, g_rd_segs())); _ = cx_print_line(grade_bools("\x15\x16\x49\x1c\x11\x12\x11\x13\x14\x0d\x16\x02", cx_ll_of(bool, &[_]bool{ r_.finished }), g_rd_finished())); _ = cx_print_line(cx_concat(cx_concat(cx_concat(cx_concat("\x15\x16\x49\x1c\x15\x0f\x1a\x0d\x13\x02\x02\x02\x1f\x10\x15\x0e\x02", cx_show_int(r_.frame)), "\x02\x26\x11\x1d\x02"), cx_show_int(cx_list_at(g_rd_frames(), 0))), "\x02\x4a\x15\x0d\x1f\x10\x15\x0e\x0d\x16\x42\x02\x12\x10\x0e\x02\x1d\x15\x0f\x16\x0d\x16\x45\x02\x0f\x02\x1c\x17\x11\x1f\x1f\x0d\x16\x02\x17\x0d\x0f\x12\x02\x1a\x10\x21\x0d\x13\x02\x11\x0e\x4b")); _ = cx_print_line(cx_concat(cx_concat(cx_concat(cx_concat(cx_concat(cx_concat("\x15\x16\x49\x1b\x10\x15\x13\x0e\x02\x02\x02\x02\x13\x0d\x1d\x1a\x0d\x12\x0e\x02", cx_show_int(worst_seg(r_.enters, seg_overlap(r_), 0, 0, 0))), "\x02\x11\x13\x02\x1b\x14\x0d\x15\x0d\x02\x0e\x14\x0d\x1e\x02\x16\x11\x1c\x1c\x0d\x15\x02\x1a\x10\x13\x0e\x45\x02"), cx_show_int(seg_span(r_.enters, worst_seg(r_.enters, seg_overlap(r_), 0, 0, 0)))), "\x02\x1c\x15\x0f\x1a\x0d\x13\x02\x0f\x1d\x0f\x11\x12\x13\x0e\x02"), cx_show_int(seg_span(g_rd_enters(), worst_seg(r_.enters, seg_overlap(r_), 0, 0, 0)))), "\x02\x4a\x15\x0d\x1f\x10\x15\x0e\x0d\x16\x42\x02\x12\x10\x0e\x02\x1d\x15\x0f\x16\x0d\x16\x4b")); _ = cx_print_line(cx_concat(cx_concat(cx_concat(cx_concat(cx_concat(cx_concat(cx_concat(cx_concat("\x15\x16\x49\x1f\x0f\x15\x0e\x02\x02\x02\x02\x02\x0e\x14\x0d\x02\x15\x11\x16\x0d\x13\x02\x15\x0d\x0f\x18\x14\x02\x04\x03\x02\x1a\x1a\x02\x0f\x1f\x0f\x15\x0e\x02\x0f\x0e\x02\x13\x0f\x1a\x1f\x17\x0d\x02", cx_show_int(p_)), "\x02\x10\x1c\x02"), cx_show_int(n_)), "\x42\x02\x1c\x15\x0f\x1a\x0d\x02"), cx_show_int((p_ *% sample_every()))), "\x46\x02"), cx_show_int(cx_real_to_int((g_abs((cx_list_at(r_.sample, (n_ -% 1)) - cx_list_at(g_rd_sample(), (n_ -% 1)))) * @as(f64, @bitCast(@as(i64, 4652007308841189376))))))), "\x02\x1a\x1a\x02\x0f\x1f\x0f\x15\x0e\x02\x0f\x0e\x02\x0e\x14\x0d\x02\x17\x0f\x13\x0e\x02\x13\x14\x0f\x15\x0d\x16\x02\x13\x0f\x1a\x1f\x17\x0d")); break :b3; }; }; }; };
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


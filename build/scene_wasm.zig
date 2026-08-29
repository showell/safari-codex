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

const RailPolyS = struct {
    v_: *CxList(Vec3),
    color: i64,
    fwd: f64,
};
const RailPoly = *RailPolyS;

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

const SpeciesS = struct {
    present: bool,
    cp_: i64,
    adult_h: f64,
};
const Species = *SpeciesS;

const PoseS = struct {
    along: f64,
    across: f64,
    yaw: f64,
    hw: f64,
};
const Pose = *PoseS;

const MapperS = struct {
    is_chain: bool,
    d_: i64,
    prev_len: f64,
    prev_angle: f64,
    prev_right: bool,
    prev_w: f64,
};
const Mapper = *MapperS;

const TreeItemS = struct {
    right: f64,
    fwd: f64,
    height: f64,
    color: i64,
};
const TreeItem = *TreeItemS;

const TowerItemS = struct {
    map: Mapper,
    a0: f64,
    x0: f64,
    yaw: f64,
    fwd: f64,
    off_: f64,
};
const TowerItem = *TowerItemS;

const BillboardS = struct {
    right: f64,
    fwd: f64,
    height: f64,
    cp_: i64,
    face_right: bool,
};
const Billboard = *BillboardS;

const PlacedS = struct {
    b_: Billboard,
    kept: bool,
    size_culled: bool,
};
const Placed = *PlacedS;

const CatItemS = struct {
    right: f64,
    fwd: f64,
    height: f64,
    pose_idx: i64,
    lift: f64,
};
const CatItem = *CatItemS;

const TruckAtS = struct {
    present: bool,
    d_: i64,
    along: f64,
    fwd: f64,
};
const TruckAt = *TruckAtS;

const Kind = enum {
    KTree,
    KTower,
    KCow,
    KCat,
    KTruck,
    KRail,
};

const ItemS = struct {
    fwd: f64,
    kind: Kind,
    i_: i64,
};
const Item = *ItemS;

const CollectedS = struct {
    trees: *CxList(TreeItem),
    towers: *CxList(TowerItem),
    cows: *CxList(Billboard),
    cats: *CxList(CatItem),
    rails: *CxList(RailPoly),
    truck: TruckAt,
    order: *CxList(Item),
    cull_seg: i64,
    cull_size: i64,
};
const Collected = *CollectedS;

const RoutePosS = struct {
    seg: i64,
    along: f64,
};
const RoutePos = *RoutePosS;

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

fn v_base() f64 {
    return @as(f64, @bitCast(@as(i64, 4599075939470750515)));
}

fn initial_rider_state() RiderState {
    return cx_new(RiderStateS{ .segment = 0, .along = @as(f64, @bitCast(@as(i64, 0))), .across = @as(f64, @bitCast(@as(i64, 0))), .yaw = @as(f64, @bitCast(@as(i64, 0))), .v_ = v_base(), .tilt = @as(f64, @bitCast(@as(i64, 0))), .heading = @as(f64, @bitCast(@as(i64, 0))), .gaze_yaw = @as(f64, @bitCast(@as(i64, 0))), .focus = @as(f64, @bitCast(@as(i64, 0))) });
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

fn round_real(x: f64) f64 {
    return (if ((x < @as(f64, @bitCast(@as(i64, 0))))) (@as(f64, @bitCast(@as(i64, 0))) - cx_real_from_int(cx_real_to_int((@as(f64, @bitCast(@as(i64, 4602678819172646912))) - x)))) else cx_real_from_int(cx_real_to_int((x + @as(f64, @bitCast(@as(i64, 4602678819172646912)))))));
}

fn floor_real(x: f64) f64 {
    return b0: { const t: f64 = cx_real_from_int(cx_real_to_int(x)); break :b0 (if ((t > x)) (t - @as(f64, @bitCast(@as(i64, 4607182418800017408)))) else t); };
}

fn mod_real(x: f64, m_: f64) f64 {
    return (x - (m_ * floor_real((x / m_))));
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
    return cx_new(CatStateS{ .pose_idx = pose, .across = lerp(c_.mid_across, c_.end_across, real_sqrt((b_ * real_sqrt(b_)))), .lift = (((leap_height() * @as(f64, @bitCast(@as(i64, 4616189618054758400)))) * b_) * (@as(f64, @bitCast(@as(i64, 4607182418800017408))) - b_)) });
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

fn course_length_from(ss: *CxList(Segment), i_: i64) f64 {
    return @as(f64, (if ((i_ >= cx_list_len(ss))) @as(f64, @bitCast(@as(i64, 0))) else (cx_list_at(ss, i_).length + course_length_from(ss, (i_ +% 1)))));
}

fn course_length(ss: *CxList(Segment)) f64 {
    return course_length_from(ss, 0);
}

fn route_distance_from(ss: *CxList(Segment), seg: i64, i_: i64) f64 {
    return @as(f64, (if ((i_ >= seg)) @as(f64, @bitCast(@as(i64, 0))) else (cx_list_at(ss, i_).length + route_distance_from(ss, seg, (i_ +% 1)))));
}

fn route_distance(ss: *CxList(Segment), seg: i64, along: f64) f64 {
    return (route_distance_from(ss, seg, 0) + along);
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

fn stopped_at(s_: RiderState, _arg_at: f64) RiderState {
    return cx_new(RiderStateS{ .segment = s_.segment, .along = _arg_at, .across = s_.across, .yaw = s_.yaw, .v_ = @as(f64, @bitCast(@as(i64, 0))), .tilt = s_.tilt, .heading = s_.heading, .gaze_yaw = s_.gaze_yaw, .focus = s_.focus });
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

fn ground_radius() f64 {
    return @as(f64, @bitCast(@as(i64, 4681608360884174848)));
}

fn ground_drop(right: f64, forward: f64) f64 {
    return (((right * right) + (forward * forward)) / (@as(f64, @bitCast(@as(i64, 4611686018427387904))) * ground_radius()));
}

fn to_rider(a_: f64, x: f64, cam_along: f64, cam_across: f64, yaw: f64, hw: f64) RiderPt {
    return b0: { const d_a: f64 = (a_ - cam_along); break :b0 b1: { const d_x: f64 = (x - (cam_across + hw)); break :b1 b2: { const c_: f64 = r_cos(yaw); break :b2 b3: { const s_: f64 = r_sin(yaw); break :b3 cx_new(RiderPtS{ .forward = ((d_a * c_) + (d_x * s_)), .right = (((@as(f64, @bitCast(@as(i64, 0))) - d_a) * s_) + (d_x * c_)) }); }; }; }; };
}

fn next_to_cur(a_b: f64, x_b: f64, seg_len: f64, theta: f64, turns_right: bool, width: f64) AX {
    return b0: { const c_: f64 = r_cos(theta); break :b0 b1: { const s_: f64 = r_sin(theta); break :b1 (if (turns_right) cx_new(AXS{ .a_ = ((((a_b * c_) - (x_b * s_)) + (width * s_)) + seg_len), .x = (((x_b * c_) + (a_b * s_)) + (width * (@as(f64, @bitCast(@as(i64, 4607182418800017408))) - c_))) }) else cx_new(AXS{ .a_ = (((a_b * c_) + (x_b * s_)) + seg_len), .x = ((x_b * c_) - (a_b * s_)) })); }; };
}

fn cur_to_next(a_: f64, x: f64, seg_len: f64, theta: f64, turns_right: bool, width: f64) AX {
    return b0: { const c_: f64 = r_cos(theta); break :b0 b1: { const s_: f64 = r_sin(theta); break :b1 (if (turns_right) b3: { const a0: f64 = ((a_ - seg_len) - (width * s_)); break :b3 b4: { const x0: f64 = (x - (width * (@as(f64, @bitCast(@as(i64, 4607182418800017408))) - c_))); break :b4 cx_new(AXS{ .a_ = ((a0 * c_) + (x0 * s_)), .x = (((@as(f64, @bitCast(@as(i64, 0))) - a0) * s_) + (x0 * c_)) }); }; } else b3: { const a0: f64 = (a_ - seg_len); break :b3 cx_new(AXS{ .a_ = ((a0 * c_) - (x * s_)), .x = ((a0 * s_) + (x * c_)) }); }); }; };
}

fn line_meet(a0: RiderPt, a1: RiderPt, b0_: RiderPt, b1: RiderPt) RiderPt {
    return b0: { const dax: f64 = (a1.right - a0.right); break :b0 b1: { const daf: f64 = (a1.forward - a0.forward); break :b1 b2: { const dbx: f64 = (b1.right - b0_.right); break :b2 b3: { const dbf: f64 = (b1.forward - b0_.forward); break :b3 b4: { const t: f64 = ((((b0_.right - a0.right) * dbf) - ((b0_.forward - a0.forward) * dbx)) / ((dax * dbf) - (daf * dbx))); break :b4 cx_new(RiderPtS{ .right = (a0.right + (t * dax)), .forward = (a0.forward + (t * daf)) }); }; }; }; }; };
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
    return (if ((cx_list_len(ps) < 3)) cx_ll_empty(DrawCmd) else cx_ll_of(DrawCmd, &[_]DrawCmd{ cx_new(DrawCmdS{ .tag = 0, .color = color, .strength = @as(f64, @bitCast(@as(i64, 0))), .pts = flatten_screen(ps, 0) }) }));
}

fn push_round_poly(color: i64, strength: f64, ps: *CxList(ScreenPt)) *CxList(DrawCmd) {
    return (if ((cx_list_len(ps) < 3)) cx_ll_empty(DrawCmd) else cx_ll_of(DrawCmd, &[_]DrawCmd{ cx_new(DrawCmdS{ .tag = 1, .color = color, .strength = strength, .pts = flatten_screen(ps, 0) }) }));
}

fn push_beacon(color: i64, x: f64, y: f64, r_: f64, alpha: f64) *CxList(DrawCmd) {
    return cx_ll_of(DrawCmd, &[_]DrawCmd{ cx_new(DrawCmdS{ .tag = 3, .color = color, .strength = alpha, .pts = cx_ll_of(f64, &[_]f64{ x, y, r_ }) }) });
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
    return b0: { const dx: f64 = (b_.x - a_.x); break :b0 b1: { const dy: f64 = (b_.y - a_.y); break :b1 b2: { const raw_: f64 = real_sqrt(((dx * dx) + (dy * dy))); break :b2 b3: { const len_: f64 = @as(f64, (if ((raw_ < @as(f64, @bitCast(@as(i64, 4547007122018943789))))) @as(f64, @bitCast(@as(i64, 4607182418800017408))) else raw_)); break :b3 tower_bar_quad(a_, b_, ((((@as(f64, @bitCast(@as(i64, 0))) - dy) / len_) * wpx) / @as(f64, @bitCast(@as(i64, 4611686018427387904)))), (((dx / len_) * wpx) / @as(f64, @bitCast(@as(i64, 4611686018427387904))))); }; }; }; };
}

fn tower_bar_quad(a_: ScreenPt, b_: ScreenPt, ox: f64, oy: f64) *CxList(DrawCmd) {
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

fn rail_runout() i64 {
    return 10;
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

fn guardrail_bar_quad(p_: RiderPt, q: RiderPt) RailPoly {
    return b0: { const p_bot = cx_new(Vec3S{ .right = p_.right, .forward = p_.forward, .height = bar_bot() }); break :b0 b1: { const q_bot = cx_new(Vec3S{ .right = q.right, .forward = q.forward, .height = bar_bot() }); break :b1 b2: { const q_top = cx_new(Vec3S{ .right = q.right, .forward = q.forward, .height = bar_top() }); break :b2 b3: { const p_top = cx_new(Vec3S{ .right = p_.right, .forward = p_.forward, .height = bar_top() }); break :b3 rail_poly(p_bot, q_bot, q_top, p_top, rail_metal()); }; }; }; };
}

fn bars(path_: *CxList(RiderPt), i_: i64) *CxList(RailPoly) {
    return (if (((i_ +% 1) >= cx_list_len(path_))) cx_ll_empty(RailPoly) else cx_ll_concat(cx_ll_of(RailPoly, &[_]RailPoly{ guardrail_bar_quad(cx_list_at(path_, i_), cx_list_at(path_, (i_ +% 1))) }), bars(path_, (i_ +% 1))));
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

fn duck_codepoint() i64 {
    return 129414;
}

fn duck_height() f64 {
    return @as(f64, @bitCast(@as(i64, 4606281698874543309)));
}

fn ducks() *CxList(Duck) {
    return cx_ll_of(Duck, &[_]Duck{ cx_new(DuckS{ .p_ = cx_new(PondPtS{ .cu = (-@as(f64, @bitCast(@as(i64, 4620693217682128896)))), .cv = @as(f64, @bitCast(@as(i64, 4622382067542392832))) }), .face_right = true }), cx_new(DuckS{ .p_ = cx_new(PondPtS{ .cu = (-@as(f64, @bitCast(@as(i64, 4625196817309499392)))), .cv = @as(f64, @bitCast(@as(i64, 4625478292286210048))) }), .face_right = false }), cx_new(DuckS{ .p_ = cx_new(PondPtS{ .cu = (-@as(f64, @bitCast(@as(i64, 4621256167635550208)))), .cv = @as(f64, @bitCast(@as(i64, 4626604192193052672))) }), .face_right = true }), cx_new(DuckS{ .p_ = cx_new(PondPtS{ .cu = (-@as(f64, @bitCast(@as(i64, 4616189618054758400)))), .cv = @as(f64, @bitCast(@as(i64, 4618441417868443648))) }), .face_right = true }), cx_new(DuckS{ .p_ = cx_new(PondPtS{ .cu = (-@as(f64, @bitCast(@as(i64, 4622945017495814144)))), .cv = @as(f64, @bitCast(@as(i64, 4619567317775286272))) }), .face_right = false }), cx_new(DuckS{ .p_ = cx_new(PondPtS{ .cu = (-@as(f64, @bitCast(@as(i64, 4626322717216342016)))), .cv = @as(f64, @bitCast(@as(i64, 4620693217682128896))) }), .face_right = true }) });
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

fn no_species() Species {
    return cx_new(SpeciesS{ .present = false, .cp_ = 0, .adult_h = @as(f64, @bitCast(@as(i64, 0))) });
}

fn adult_rail_buffer() f64 {
    return @as(f64, @bitCast(@as(i64, 4609434218613702656)));
}

fn baby_ratio() f64 {
    return @as(f64, @bitCast(@as(i64, 4602678819172646912)));
}

fn baby_beyond() f64 {
    return @as(f64, @bitCast(@as(i64, 4624070917402656768)));
}

fn species_of(c_: Creature) Species {
    return switch (c_) { .Elephant => cx_new(SpeciesS{ .present = true, .cp_ = 128024, .adult_h = @as(f64, @bitCast(@as(i64, 4613487458278336102))) }), .Giraffe => cx_new(SpeciesS{ .present = true, .cp_ = 129426, .adult_h = @as(f64, @bitCast(@as(i64, 4616752568008179712))) }), .Zebra => cx_new(SpeciesS{ .present = true, .cp_ = 129427, .adult_h = @as(f64, @bitCast(@as(i64, 4609884578576439706))) }), .Rhino => cx_new(SpeciesS{ .present = true, .cp_ = 129423, .adult_h = @as(f64, @bitCast(@as(i64, 4612136378390124954))) }), .DuckPond => no_species(), .NoCreature => no_species(),  };
}

fn corner_critters(c_: Creature, along: f64, turn_right: bool, hw: f64) *CxList(Critter) {
    return b0: { const sp = species_of(c_); break :b0 b1: { const turn_sign: f64 = @as(f64, (if (turn_right) @as(f64, @bitCast(@as(i64, 4607182418800017408))) else (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4607182418800017408)))))); break :b1 b2: { const adult_h: f64 = sp.adult_h; break :b2 (if (sp.present) cx_ll_of(Critter, &[_]Critter{ cx_new(CritterS{ .along = along, .across = ((@as(f64, @bitCast(@as(i64, 0))) - turn_sign) * ((hw + adult_rail_buffer()) + (adult_h / @as(f64, @bitCast(@as(i64, 4611686018427387904)))))), .codepoint = sp.cp_, .height = adult_h, .face_right = turn_right }), cx_new(CritterS{ .along = (along + baby_beyond()), .across = @as(f64, @bitCast(@as(i64, 0))), .codepoint = sp.cp_, .height = (adult_h * baby_ratio()), .face_right = turn_right }) }) else cx_ll_empty(Critter)); }; }; };
}

fn look_ahead() i64 {
    return 7;
}

fn max_chain() i64 {
    return 8;
}

fn build_chain(segs: *CxList(Segment), start_: i64) *CxList(i64) {
    return chain_from(segs, start_, 0);
}

fn chain_from(segs: *CxList(Segment), s_: i64, n_: i64) *CxList(i64) {
    return (if ((n_ >= look_ahead())) cx_ll_empty(i64) else (if ((n_ >= max_chain())) cx_ll_empty(i64) else (if (cx_list_at(segs, s_).terminates) cx_ll_of(i64, &[_]i64{ s_ }) else cx_ll_concat(cx_ll_of(i64, &[_]i64{ s_ }), chain_from(segs, cx_list_at(segs, s_).exit_to, (n_ +% 1))))));
}

fn compose_down(segs: *CxList(Segment), ch: *CxList(i64), k_: i64, a_: f64, x: f64) AX {
    var _tl_k = k_;
    var _tl_a = a_;
    var _tl_x = x;
    while (true) {
        if ((_tl_k <= 0)) { return cx_new(AXS{ .a_ = _tl_a, .x = _tl_x }); } else { const seg = cx_list_at(segs, cx_list_at(ch, (_tl_k -% 1))); const p_ = next_to_cur(_tl_a, _tl_x, seg.length, seg.exit_angle, seg.exit_right, seg.width); { const _tj3_2 = (_tl_k -% 1); const _tj3_3 = p_.a_; const _tj3_4 = p_.x; _tl_k = _tj3_2; _tl_a = _tj3_3; _tl_x = _tj3_4; continue; } }
    }
}

fn at(segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, d_: i64, a_: f64, x: f64) RiderPt {
    return b0: { const p_ = compose_down(segs, ch, d_, a_, x); break :b0 to_rider(p_.a_, p_.x, pose.along, pose.across, pose.yaw, pose.hw); };
}

fn chain_map(d_: i64) Mapper {
    return cx_new(MapperS{ .is_chain = true, .d_ = d_, .prev_len = @as(f64, @bitCast(@as(i64, 0))), .prev_angle = @as(f64, @bitCast(@as(i64, 0))), .prev_right = false, .prev_w = @as(f64, @bitCast(@as(i64, 0))) });
}

fn prev_map(s_: Segment) Mapper {
    return cx_new(MapperS{ .is_chain = false, .d_ = 0, .prev_len = s_.length, .prev_angle = s_.exit_angle, .prev_right = s_.exit_right, .prev_w = s_.width });
}

fn map_pt(segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, m_: Mapper, a_: f64, x: f64) RiderPt {
    return (if (m_.is_chain) at(segs, ch, pose, m_.d_, a_, x) else b1: { const p_ = cur_to_next(a_, x, m_.prev_len, m_.prev_angle, m_.prev_right, m_.prev_w); break :b1 to_rider(p_.a_, p_.x, pose.along, pose.across, pose.yaw, pose.hw); });
}

fn detail_dist() f64 {
    return @as(f64, @bitCast(@as(i64, 4641240890982006784)));
}

fn crown_shade_dist() f64 {
    return @as(f64, @bitCast(@as(i64, 4635329916471083008)));
}

fn min_scenery_px() f64 {
    return @as(f64, @bitCast(@as(i64, 4611686018427387904)));
}

fn min_critter_px() f64 {
    return @as(f64, @bitCast(@as(i64, 4611686018427387904)));
}

fn farm_seg_reach() i64 {
    return 3;
}

fn safari_seg_reach() i64 {
    return 5;
}

fn max_vis_trees() i64 {
    return 640;
}

fn max_vis_towers() i64 {
    return 16;
}

fn max_vis_critters() i64 {
    return 320;
}

fn max_vis_cats() i64 {
    return 8;
}

fn tower_beyond() f64 {
    return @as(f64, @bitCast(@as(i64, 4639833516098453504)));
}

fn tower_right() f64 {
    return @as(f64, @bitCast(@as(i64, 4626322717216342016)));
}

fn seg_tower_left() f64 {
    return @as(f64, @bitCast(@as(i64, 4636737291354636288)));
}

fn tower_yaw() f64 {
    return ((@as(f64, @bitCast(@as(i64, 4629137466983448576))) * @as(f64, @bitCast(@as(i64, 4614256656543962353)))) / @as(f64, @bitCast(@as(i64, 4640537203540230144))));
}

fn chain_gap(w: *CxList(Segment), ch: *CxList(i64), along: f64, d_: i64) f64 {
    return (if ((d_ <= 0)) (@as(f64, @bitCast(@as(i64, 0))) - along) else (chain_gap(w, ch, along, (d_ -% 1)) + cx_list_at(w, cx_list_at(ch, (d_ -% 1))).length));
}

fn cat_item(w: *CxList(Segment), ch: *CxList(i64), pose: Pose, d_: i64, cf: f64, gap: f64, sg: Segment, v_: f64) *CxList(CatItem) {
    return b0: { const st = cat_state(sg.cat, (gap + sg.cat.along), v_); break :b0 b1: { const rp = at(w, ch, pose, d_, sg.cat.along, (st.across + (sg.width / @as(f64, @bitCast(@as(i64, 4611686018427387904)))))); break :b1 (if ((rp.forward <= near())) cx_ll_empty(CatItem) else (if ((((sg.cat.height / rp.forward) * cf) < min_scenery_px())) cx_ll_empty(CatItem) else cx_ll_of(CatItem, &[_]CatItem{ cx_new(CatItemS{ .right = rp.right, .fwd = rp.forward, .height = sg.cat.height, .pose_idx = st.pose_idx, .lift = st.lift }) }))); }; };
}

fn seg_cat(w: *CxList(Segment), ch: *CxList(i64), pose: Pose, d_: i64, cf: f64, along: f64, v_: f64) *CxList(CatItem) {
    return b0: { const sg = cx_list_at(w, cx_list_at(ch, d_)); break :b0 (if (sg.has_cat) cat_item(w, ch, pose, d_, cf, chain_gap(w, ch, along, d_), sg, v_) else cx_ll_empty(CatItem)); };
}

fn walk_cats(w: *CxList(Segment), ch: *CxList(i64), pose: Pose, cf: f64, along: f64, v_: f64, d_: i64) *CxList(CatItem) {
    return (if ((d_ >= cx_list_len(ch))) cx_ll_empty(CatItem) else cx_ll_concat(seg_cat(w, ch, pose, d_, cf, along, v_), walk_cats(w, ch, pose, cf, along, v_, (d_ +% 1))));
}

fn no_billboard() Billboard {
    return cx_new(BillboardS{ .right = @as(f64, @bitCast(@as(i64, 0))), .fwd = @as(f64, @bitCast(@as(i64, 0))), .height = @as(f64, @bitCast(@as(i64, 0))), .cp_ = 0, .face_right = false });
}

fn verdict(rp: RiderPt, h_: f64, cp_: i64, fr: bool) Placed {
    return (if ((rp.forward <= near())) cx_new(PlacedS{ .b_ = no_billboard(), .kept = false, .size_culled = false }) else (if ((((h_ / rp.forward) * focal()) < min_critter_px())) cx_new(PlacedS{ .b_ = no_billboard(), .kept = false, .size_culled = true }) else cx_new(PlacedS{ .b_ = cx_new(BillboardS{ .right = rp.right, .fwd = rp.forward, .height = h_, .cp_ = cp_, .face_right = fr }), .kept = true, .size_culled = false })));
}

fn place_critter(segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, d_: i64, hw: f64, cr: Critter) Placed {
    return b0: { const rp = at(segs, ch, pose, d_, cr.along, (cr.across + hw)); break :b0 verdict(rp, cr.height, cr.codepoint, cr.face_right); };
}

fn place_critter_via(segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, m_: Mapper, hw: f64, cr: Critter) Placed {
    return b0: { const rp = map_pt(segs, ch, pose, m_, cr.along, (cr.across + hw)); break :b0 verdict(rp, cr.height, cr.codepoint, cr.face_right); };
}

fn place_duck(segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, m_: Mapper, from_len: f64, dk: Duck) Placed {
    return b0: { const rp = map_pt(segs, ch, pose, m_, (from_len + dk.p_.cv), dk.p_.cu); break :b0 verdict(rp, duck_height(), duck_codepoint(), dk.face_right); };
}

fn kept_of(ps: *CxList(Placed), i_: i64) *CxList(Billboard) {
    var _tl_i = i_;
    while (true) {
        if ((_tl_i >= cx_list_len(ps))) { return cx_ll_empty(Billboard); } else { if (cx_list_at(ps, _tl_i).kept) { return cx_ll_concat(cx_ll_of(Billboard, &[_]Billboard{ cx_list_at(ps, _tl_i).b_ }), kept_of(ps, (_tl_i +% 1))); } else { { const _tj2_1 = (_tl_i +% 1); _tl_i = _tj2_1; continue; } } }
    }
}

fn size_culled_of(ps: *CxList(Placed), i_: i64) i64 {
    var _tl_i = i_;
    while (true) {
        if ((_tl_i >= cx_list_len(ps))) { return 0; } else { if (cx_list_at(ps, _tl_i).size_culled) { return (1 +% size_culled_of(ps, (_tl_i +% 1))); } else { { const _tj2_1 = (_tl_i +% 1); _tl_i = _tj2_1; continue; } } }
    }
}

fn place_all(segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, d_: i64, hw: f64, crs: *CxList(Critter), i_: i64) *CxList(Placed) {
    return (if ((i_ >= cx_list_len(crs))) cx_ll_empty(Placed) else cx_ll_concat(cx_ll_of(Placed, &[_]Placed{ place_critter(segs, ch, pose, d_, hw, cx_list_at(crs, i_)) }), place_all(segs, ch, pose, d_, hw, crs, (i_ +% 1))));
}

fn place_all_via(segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, m_: Mapper, hw: f64, crs: *CxList(Critter), i_: i64) *CxList(Placed) {
    return (if ((i_ >= cx_list_len(crs))) cx_ll_empty(Placed) else cx_ll_concat(cx_ll_of(Placed, &[_]Placed{ place_critter_via(segs, ch, pose, m_, hw, cx_list_at(crs, i_)) }), place_all_via(segs, ch, pose, m_, hw, crs, (i_ +% 1))));
}

fn place_ducks(segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, m_: Mapper, from_len: f64, i_: i64) *CxList(Placed) {
    return (if ((i_ >= cx_list_len(ducks()))) cx_ll_empty(Placed) else cx_ll_concat(cx_ll_of(Placed, &[_]Placed{ place_duck(segs, ch, pose, m_, from_len, cx_list_at(ducks(), i_)) }), place_ducks(segs, ch, pose, m_, from_len, (i_ +% 1))));
}

fn place_tree(segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, d_: i64, cf: f64, hw: f64, tr: Tree) *CxList(TreeItem) {
    return b0: { const rp = at(segs, ch, pose, d_, tr.along, (tr.across + hw)); break :b0 (if ((rp.forward <= near())) cx_ll_empty(TreeItem) else (if ((((tr.height / rp.forward) * cf) < min_scenery_px())) cx_ll_empty(TreeItem) else cx_ll_of(TreeItem, &[_]TreeItem{ cx_new(TreeItemS{ .right = rp.right, .fwd = rp.forward, .height = tr.height, .color = tr.color }) }))); };
}

fn seg_trees(segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, d_: i64, cf: f64, hw: f64, trs: *CxList(Tree), i_: i64) *CxList(TreeItem) {
    return (if ((i_ >= cx_list_len(trs))) cx_ll_empty(TreeItem) else cx_ll_concat(place_tree(segs, ch, pose, d_, cf, hw, cx_list_at(trs, i_)), seg_trees(segs, ch, pose, d_, cf, hw, trs, (i_ +% 1))));
}

fn tower_if_ahead(segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, m_: Mapper, a0: f64, x0: f64, yw: f64, key: i64) *CxList(TowerItem) {
    return b0: { const c_ = map_pt(segs, ch, pose, m_, a0, x0); break :b0 (if ((c_.forward <= near())) cx_ll_empty(TowerItem) else cx_ll_of(TowerItem, &[_]TowerItem{ cx_new(TowerItemS{ .map = m_, .a0 = a0, .x0 = x0, .yaw = yw, .fwd = c_.forward, .off_ = cx_real_from_int(((key *% 37) -% (@divTrunc((key *% 37), 120) *% 120))) }) })); };
}

fn seg_towers(segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, d_: i64) *CxList(TowerItem) {
    return b0: { const sg = cx_list_at(segs, cx_list_at(ch, d_)); break :b0 cx_ll_concat(tower_if_ahead(segs, ch, pose, chain_map(d_), (sg.length + tower_beyond()), ((sg.width / @as(f64, @bitCast(@as(i64, 4611686018427387904)))) + tower_right()), tower_yaw(), cx_list_at(ch, d_)), seg_mid_tower(segs, ch, pose, d_)); };
}

fn seg_mid_tower(segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, d_: i64) *CxList(TowerItem) {
    return b0: { const sg = cx_list_at(segs, cx_list_at(ch, d_)); break :b0 (if (sg.has_mid_tower) tower_if_ahead(segs, ch, pose, chain_map(d_), (sg.length / @as(f64, @bitCast(@as(i64, 4611686018427387904)))), ((sg.width / @as(f64, @bitCast(@as(i64, 4611686018427387904)))) - seg_tower_left()), @as(f64, @bitCast(@as(i64, 0))), (cx_list_at(ch, d_) +% 60)) else cx_ll_empty(TowerItem)); };
}

fn is_pond(c_: Creature) bool {
    return switch (c_) { .DuckPond => true, .NoCreature => false, .Elephant => false, .Giraffe => false, .Zebra => false, .Rhino => false,  };
}

fn seg_farm(segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, d_: i64, hw: f64) *CxList(Placed) {
    return b0: { const sg = cx_list_at(segs, cx_list_at(ch, d_)); break :b0 (if ((d_ >= farm_seg_reach())) cx_ll_empty(Placed) else cx_ll_concat(place_all(segs, ch, pose, d_, hw, sg.cows, 0), place_all(segs, ch, pose, d_, hw, sg.pigs, 0))); };
}

fn seg_cull_count(segs: *CxList(Segment), ch: *CxList(i64), d_: i64) i64 {
    return b0: { const sg = cx_list_at(segs, cx_list_at(ch, d_)); break :b0 @as(i64, (if ((d_ >= farm_seg_reach())) (cx_list_len(sg.cows) +% cx_list_len(sg.pigs)) else 0)); };
}

fn seg_safari(segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, d_: i64, hw: f64) *CxList(Placed) {
    return b0: { const sg = cx_list_at(segs, cx_list_at(ch, d_)); break :b0 (if (sg.terminates) cx_ll_empty(Placed) else (if ((d_ >= safari_seg_reach())) cx_ll_empty(Placed) else place_all(segs, ch, pose, d_, hw, corner_critters(sg.exit_creature, sg.length, sg.exit_right, hw), 0))); };
}

fn seg_ducks(segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, d_: i64) *CxList(Placed) {
    return b0: { const sg = cx_list_at(segs, cx_list_at(ch, d_)); break :b0 (if ((d_ >= safari_seg_reach())) cx_ll_empty(Placed) else (if (is_pond(sg.exit_creature)) place_ducks(segs, ch, pose, chain_map(d_), sg.length, 0) else cx_ll_empty(Placed))); };
}

fn seg_billboards(segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, d_: i64) *CxList(Placed) {
    return b0: { const hw: f64 = (cx_list_at(segs, cx_list_at(ch, d_)).width / @as(f64, @bitCast(@as(i64, 4611686018427387904)))); break :b0 cx_ll_concat(cx_ll_concat(seg_farm(segs, ch, pose, d_, hw), seg_safari(segs, ch, pose, d_, hw)), seg_ducks(segs, ch, pose, d_)); };
}

fn walk_trees(segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, cf: f64, d_: i64) *CxList(TreeItem) {
    return (if ((d_ >= cx_list_len(ch))) cx_ll_empty(TreeItem) else cx_ll_concat(seg_trees(segs, ch, pose, d_, cf, (cx_list_at(segs, cx_list_at(ch, d_)).width / @as(f64, @bitCast(@as(i64, 4611686018427387904)))), cx_list_at(segs, cx_list_at(ch, d_)).trees, 0), walk_trees(segs, ch, pose, cf, (d_ +% 1))));
}

fn walk_towers(segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, d_: i64) *CxList(TowerItem) {
    return (if ((d_ >= cx_list_len(ch))) cx_ll_empty(TowerItem) else cx_ll_concat(seg_towers(segs, ch, pose, d_), walk_towers(segs, ch, pose, (d_ +% 1))));
}

fn walk_billboards(segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, d_: i64) *CxList(Placed) {
    return (if ((d_ >= cx_list_len(ch))) cx_ll_empty(Placed) else cx_ll_concat(seg_billboards(segs, ch, pose, d_), walk_billboards(segs, ch, pose, (d_ +% 1))));
}

fn walk_seg_cull(segs: *CxList(Segment), ch: *CxList(i64), d_: i64) i64 {
    return @as(i64, (if ((d_ >= cx_list_len(ch))) 0 else (seg_cull_count(segs, ch, d_) +% walk_seg_cull(segs, ch, (d_ +% 1)))));
}

fn behind_billboards(segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, prev_idx: i64) *CxList(Placed) {
    return b0: { const pv = cx_list_at(segs, prev_idx); break :b0 cx_ll_concat(place_all_via(segs, ch, pose, prev_map(pv), (pv.width / @as(f64, @bitCast(@as(i64, 4611686018427387904)))), corner_critters(pv.exit_creature, pv.length, pv.exit_right, (pv.width / @as(f64, @bitCast(@as(i64, 4611686018427387904))))), 0), (if (is_pond(pv.exit_creature)) place_ducks(segs, ch, pose, prev_map(pv), pv.length, 0) else cx_ll_empty(Placed))); };
}

fn behind_tower(segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, prev_idx: i64) *CxList(TowerItem) {
    return b0: { const pv = cx_list_at(segs, prev_idx); break :b0 tower_if_ahead(segs, ch, pose, prev_map(pv), (pv.length + tower_beyond()), ((pv.width / @as(f64, @bitCast(@as(i64, 4611686018427387904)))) + tower_right()), tower_yaw(), prev_idx); };
}

fn outer_cu(exit_right: bool, wd: f64) f64 {
    return @as(f64, (if (exit_right) @as(f64, @bitCast(@as(i64, 0))) else wd));
}

fn joint_apex(segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, from_map: Mapper, to_map: Mapper, from_len: f64, from_w: f64, to_w: f64, exit_right: bool) RiderPt {
    return b0: { const fcu: f64 = outer_cu(exit_right, from_w); break :b0 b1: { const tx: f64 = outer_cu(exit_right, to_w); break :b1 line_meet(map_pt(segs, ch, pose, from_map, from_len, fcu), map_pt(segs, ch, pose, from_map, (from_len + @as(f64, @bitCast(@as(i64, 4607182418800017408)))), fcu), map_pt(segs, ch, pose, to_map, @as(f64, @bitCast(@as(i64, 0))), tx), map_pt(segs, ch, pose, to_map, @as(f64, @bitCast(@as(i64, 4607182418800017408))), tx)); }; };
}

fn leg_steps(dist: f64) i64 {
    return b0: { const r_: f64 = round_real(dist); break :b0 cx_real_to_int(@as(f64, (if ((r_ < @as(f64, @bitCast(@as(i64, 4607182418800017408))))) @as(f64, @bitCast(@as(i64, 4607182418800017408))) else r_))); };
}

fn leg_points(from: RiderPt, dr: f64, df: f64, steps: i64, i_: i64) *CxList(RiderPt) {
    return (if ((i_ > steps)) cx_ll_empty(RiderPt) else b1: { const t: f64 = (cx_real_from_int(i_) / cx_real_from_int(steps)); break :b1 cx_ll_concat(cx_ll_of(RiderPt, &[_]RiderPt{ cx_new(RiderPtS{ .right = (from.right + (dr * t)), .forward = (from.forward + (df * t)) }) }), leg_points(from, dr, df, steps, (i_ +% 1))); });
}

fn push_leg(from: RiderPt, to: RiderPt) *CxList(RiderPt) {
    return b0: { const dr: f64 = (to.right - from.right); break :b0 b1: { const df: f64 = (to.forward - from.forward); break :b1 leg_points(from, dr, df, leg_steps(real_sqrt(((dr * dr) + (df * df)))), 1); }; };
}

fn rail_run_up(segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, m_: Mapper, from_len: f64, cu: f64, k_: i64) *CxList(RiderPt) {
    return (if ((k_ < 0)) cx_ll_empty(RiderPt) else cx_ll_concat(cx_ll_of(RiderPt, &[_]RiderPt{ map_pt(segs, ch, pose, m_, (from_len - cx_real_from_int(k_)), cu) }), rail_run_up(segs, ch, pose, m_, from_len, cu, (k_ -% 1))));
}

fn rail_run_out(segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, m_: Mapper, x: f64, k_: i64) *CxList(RiderPt) {
    return (if ((k_ > rail_runout())) cx_ll_empty(RiderPt) else cx_ll_concat(cx_ll_of(RiderPt, &[_]RiderPt{ map_pt(segs, ch, pose, m_, cx_real_from_int(k_), x) }), rail_run_out(segs, ch, pose, m_, x, (k_ +% 1))));
}

fn joint_rail_path(segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, from_map: Mapper, to_map: Mapper, from_len: f64, from_w: f64, to_w: f64, exit_right: bool) *CxList(RiderPt) {
    return b0: { const fcu: f64 = outer_cu(exit_right, from_w); break :b0 b1: { const tx: f64 = outer_cu(exit_right, to_w); break :b1 b2: { const of_pt = map_pt(segs, ch, pose, from_map, from_len, fcu); break :b2 b3: { const ot_pt = map_pt(segs, ch, pose, to_map, @as(f64, @bitCast(@as(i64, 0))), tx); break :b3 b4: { const q = joint_apex(segs, ch, pose, from_map, to_map, from_len, from_w, to_w, exit_right); break :b4 cx_ll_concat(cx_ll_concat(cx_ll_concat(rail_run_up(segs, ch, pose, from_map, from_len, fcu, rail_runout()), push_leg(of_pt, q)), push_leg(q, ot_pt)), rail_run_out(segs, ch, pose, to_map, tx, 1)); }; }; }; }; };
}

fn joint_rails(segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, from_map: Mapper, to_map: Mapper, from_len: f64, from_w: f64, to_w: f64, exit_right: bool) *CxList(RailPoly) {
    return rail_emit(joint_rail_path(segs, ch, pose, from_map, to_map, from_len, from_w, to_w, exit_right));
}

fn walk_rails(segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, d_: i64) *CxList(RailPoly) {
    return (if (((d_ +% 1) >= cx_list_len(ch))) cx_ll_empty(RailPoly) else cx_ll_concat(joint_rails(segs, ch, pose, chain_map(d_), chain_map((d_ +% 1)), cx_list_at(segs, cx_list_at(ch, d_)).length, cx_list_at(segs, cx_list_at(ch, d_)).width, cx_list_at(segs, cx_list_at(ch, (d_ +% 1))).width, cx_list_at(segs, cx_list_at(ch, d_)).exit_right), walk_rails(segs, ch, pose, (d_ +% 1))));
}

fn behind_rails(segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, prev_idx: i64) *CxList(RailPoly) {
    return b0: { const pv = cx_list_at(segs, prev_idx); break :b0 joint_rails(segs, ch, pose, prev_map(pv), chain_map(0), pv.length, pv.width, cx_list_at(segs, cx_list_at(ch, 0)).width, pv.exit_right); };
}

fn no_truck() TruckAt {
    return cx_new(TruckAtS{ .present = false, .d_ = 0, .along = @as(f64, @bitCast(@as(i64, 0))), .fwd = @as(f64, @bitCast(@as(i64, 0))) });
}

fn truck_step(segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, remaining: f64, d_: i64) TruckAt {
    var _tl_remaining = remaining;
    var _tl_d = d_;
    while (true) {
        if ((_tl_d >= cx_list_len(ch))) { return no_truck(); } else { if ((_tl_remaining > cx_list_at(segs, cx_list_at(ch, _tl_d)).length)) { { const _tj2_3 = (_tl_remaining - cx_list_at(segs, cx_list_at(ch, _tl_d)).length); const _tj2_4 = (_tl_d +% 1); _tl_remaining = _tj2_3; _tl_d = _tj2_4; continue; } } else { return truck_here(segs, ch, pose, _tl_remaining, _tl_d); } }
    }
}

fn truck_here(segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, remaining: f64, d_: i64) TruckAt {
    return b0: { const c_ = at(segs, ch, pose, d_, remaining, (cx_list_at(segs, cx_list_at(ch, d_)).width / @as(f64, @bitCast(@as(i64, 4611686018427387904))))); break :b0 (if ((c_.forward > near())) cx_new(TruckAtS{ .present = true, .d_ = d_, .along = remaining, .fwd = c_.forward }) else no_truck()); };
}

fn truck_at(segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, along: f64, lead: f64) TruckAt {
    return (if ((lead > @as(f64, @bitCast(@as(i64, 0))))) truck_step(segs, ch, pose, (along + lead), 0) else no_truck());
}

fn tree_items(ts: *CxList(TreeItem), i_: i64) *CxList(Item) {
    return (if ((i_ >= cx_list_len(ts))) cx_ll_empty(Item) else cx_ll_concat(cx_ll_of(Item, &[_]Item{ cx_new(ItemS{ .fwd = cx_list_at(ts, i_).fwd, .kind = Kind.KTree, .i_ = i_ }) }), tree_items(ts, (i_ +% 1))));
}

fn tower_items(ts: *CxList(TowerItem), i_: i64) *CxList(Item) {
    return (if ((i_ >= cx_list_len(ts))) cx_ll_empty(Item) else cx_ll_concat(cx_ll_of(Item, &[_]Item{ cx_new(ItemS{ .fwd = cx_list_at(ts, i_).fwd, .kind = Kind.KTower, .i_ = i_ }) }), tower_items(ts, (i_ +% 1))));
}

fn cow_items(bs: *CxList(Billboard), i_: i64) *CxList(Item) {
    return (if ((i_ >= cx_list_len(bs))) cx_ll_empty(Item) else cx_ll_concat(cx_ll_of(Item, &[_]Item{ cx_new(ItemS{ .fwd = cx_list_at(bs, i_).fwd, .kind = Kind.KCow, .i_ = i_ }) }), cow_items(bs, (i_ +% 1))));
}

fn cat_items(cs: *CxList(CatItem), i_: i64) *CxList(Item) {
    return (if ((i_ >= cx_list_len(cs))) cx_ll_empty(Item) else cx_ll_concat(cx_ll_of(Item, &[_]Item{ cx_new(ItemS{ .fwd = cx_list_at(cs, i_).fwd, .kind = Kind.KCat, .i_ = i_ }) }), cat_items(cs, (i_ +% 1))));
}

fn rail_items(rs: *CxList(RailPoly), i_: i64) *CxList(Item) {
    return (if ((i_ >= cx_list_len(rs))) cx_ll_empty(Item) else cx_ll_concat(cx_ll_of(Item, &[_]Item{ cx_new(ItemS{ .fwd = cx_list_at(rs, i_).fwd, .kind = Kind.KRail, .i_ = i_ }) }), rail_items(rs, (i_ +% 1))));
}

fn rest_from(ys: *CxList(Item), j: i64) *CxList(Item) {
    return (if ((j >= cx_list_len(ys))) cx_ll_empty(Item) else cx_ll_concat(cx_ll_of(Item, &[_]Item{ cx_list_at(ys, j) }), rest_from(ys, (j +% 1))));
}

fn merge_items(a_: *CxList(Item), b_: *CxList(Item), i_: i64, j: i64) *CxList(Item) {
    return (if ((i_ >= cx_list_len(a_))) rest_from(b_, j) else (if ((j >= cx_list_len(b_))) rest_from(a_, i_) else (if ((cx_list_at(b_, j).fwd > cx_list_at(a_, i_).fwd)) cx_ll_concat(cx_ll_of(Item, &[_]Item{ cx_list_at(b_, j) }), merge_items(a_, b_, i_, (j +% 1))) else cx_ll_concat(cx_ll_of(Item, &[_]Item{ cx_list_at(a_, i_) }), merge_items(a_, b_, (i_ +% 1), j)))));
}

fn sort_items(xs: *CxList(Item)) *CxList(Item) {
    return (if ((cx_list_len(xs) <= 1)) xs else merge_items(sort_items(list_take(Item, xs, @divTrunc(cx_list_len(xs), 2))), sort_items(list_drop(Item, xs, @divTrunc(cx_list_len(xs), 2))), 0, 0));
}

fn collect(segs: *CxList(Segment), seg_idx: i64, pose: Pose, cf: f64, along: f64, v_: f64, truck_pos: f64) Collected {
    return b0: { const ch = build_chain(segs, seg_idx); break :b0 b1: { const placed = (if ((seg_idx > 0)) cx_ll_concat(walk_billboards(segs, ch, pose, 0), behind_billboards(segs, ch, pose, (seg_idx -% 1))) else walk_billboards(segs, ch, pose, 0)); break :b1 b2: { const trees = list_take(TreeItem, walk_trees(segs, ch, pose, cf, 0), max_vis_trees()); break :b2 b3: { const towers = list_take(TowerItem, (if ((seg_idx > 0)) cx_ll_concat(walk_towers(segs, ch, pose, 0), behind_tower(segs, ch, pose, (seg_idx -% 1))) else walk_towers(segs, ch, pose, 0)), max_vis_towers()); break :b3 b4: { const cows = list_take(Billboard, kept_of(placed, 0), max_vis_critters()); break :b4 b5: { const cats = list_take(CatItem, walk_cats(segs, ch, pose, cf, along, v_, 0), max_vis_cats()); break :b5 b6: { const rails = (if ((seg_idx > 0)) cx_ll_concat(walk_rails(segs, ch, pose, 0), behind_rails(segs, ch, pose, (seg_idx -% 1))) else walk_rails(segs, ch, pose, 0)); break :b6 b7: { const tk = truck_at(segs, ch, pose, along, (truck_pos - route_distance(segs, seg_idx, along))); break :b7 cx_new(CollectedS{ .trees = trees, .towers = towers, .cows = cows, .cats = cats, .rails = rails, .truck = tk, .order = sort_items(cx_ll_concat(cx_ll_concat(cx_ll_concat(cx_ll_concat(cx_ll_concat(tree_items(trees, 0), tower_items(towers, 0)), cow_items(cows, 0)), cat_items(cats, 0)), (if (tk.present) cx_ll_of(Item, &[_]Item{ cx_new(ItemS{ .fwd = tk.fwd, .kind = Kind.KTruck, .i_ = 0 }) }) else cx_ll_empty(Item))), rail_items(rails, 0))), .cull_seg = walk_seg_cull(segs, ch, 0), .cull_size = size_culled_of(placed, 0) }); }; }; }; }; }; }; }; };
}

fn road_color() i64 {
    return 3421500;
}

fn road_chunk() f64 {
    return @as(f64, @bitCast(@as(i64, 4627730092099895296)));
}

fn entry_road_dist() f64 {
    return @as(f64, @bitCast(@as(i64, 4630826316843712512)));
}

fn ground_vert(p_: RiderPt) Vec3 {
    return cx_new(Vec3S{ .right = p_.right, .forward = p_.forward, .height = (@as(f64, @bitCast(@as(i64, 0))) - ground_drop(p_.right, p_.forward)) });
}

fn ground_verts(ps: *CxList(RiderPt), i_: i64) *CxList(Vec3) {
    return (if ((i_ >= cx_list_len(ps))) cx_ll_empty(Vec3) else cx_ll_concat(cx_ll_of(Vec3, &[_]Vec3{ ground_vert(cx_list_at(ps, i_)) }), ground_verts(ps, (i_ +% 1))));
}

fn emit_ground_color(ps: *CxList(RiderPt), color: i64, cf: f64, view_w: f64) *CxList(DrawCmd) {
    return (if ((cx_list_len(ps) > 8)) cx_ll_empty(DrawCmd) else ground_clip(clip_near(ground_verts(ps, 0), near()), color, cf, view_w));
}

fn ground_clip(vs_: *CxList(Vec3), color: i64, cf: f64, view_w: f64) *CxList(DrawCmd) {
    return (if ((cx_list_len(vs_) < 3)) cx_ll_empty(DrawCmd) else push_poly(color, project_all(vs_, cf, view_w, 0)));
}

fn emit_ground(ps: *CxList(RiderPt), cf: f64, view_w: f64) *CxList(DrawCmd) {
    return emit_ground_color(ps, road_color(), cf, view_w);
}

fn ceil_real(x: f64) f64 {
    return (@as(f64, @bitCast(@as(i64, 0))) - floor_real((@as(f64, @bitCast(@as(i64, 0))) - x)));
}

fn chunks_for(len_: f64) i64 {
    return b0: { const c_: f64 = ceil_real((len_ / road_chunk())); break :b0 cx_real_to_int(@as(f64, (if ((c_ < @as(f64, @bitCast(@as(i64, 4607182418800017408))))) @as(f64, @bitCast(@as(i64, 4607182418800017408))) else c_))); };
}

fn road_slice(segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, d_: i64, cf: f64, view_w: f64, ci: i64, n_: i64, len_: f64, wd: f64) *CxList(DrawCmd) {
    return (if ((ci >= n_)) cx_ll_empty(DrawCmd) else cx_ll_concat(emit_ground(slice_quad(segs, ch, pose, d_, ci, n_, len_, wd), cf, view_w), road_slice(segs, ch, pose, d_, cf, view_w, (ci +% 1), n_, len_, wd)));
}

fn slice_quad(segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, d_: i64, ci: i64, n_: i64, len_: f64, wd: f64) *CxList(RiderPt) {
    return b0: { const a0: f64 = ((len_ * cx_real_from_int(ci)) / cx_real_from_int(n_)); break :b0 b1: { const a1: f64 = ((len_ * cx_real_from_int((ci +% 1))) / cx_real_from_int(n_)); break :b1 cx_ll_of(RiderPt, &[_]RiderPt{ at(segs, ch, pose, d_, a0, @as(f64, @bitCast(@as(i64, 0)))), at(segs, ch, pose, d_, a0, wd), at(segs, ch, pose, d_, a1, wd), at(segs, ch, pose, d_, a1, @as(f64, @bitCast(@as(i64, 0)))) }); }; };
}

fn seg_road(segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, d_: i64, cf: f64, view_w: f64) *CxList(DrawCmd) {
    return b0: { const sg = cx_list_at(segs, cx_list_at(ch, d_)); break :b0 road_slice(segs, ch, pose, d_, cf, view_w, 0, chunks_for(sg.length), sg.length, sg.width); };
}

fn joint_approach(segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, from_map: Mapper, from_len: f64, from_w: f64) *CxList(RiderPt) {
    return cx_ll_of(RiderPt, &[_]RiderPt{ map_pt(segs, ch, pose, from_map, from_len, @as(f64, @bitCast(@as(i64, 0)))), map_pt(segs, ch, pose, from_map, from_len, from_w), map_pt(segs, ch, pose, from_map, (from_len - entry_road_dist()), from_w), map_pt(segs, ch, pose, from_map, (from_len - entry_road_dist()), @as(f64, @bitCast(@as(i64, 0)))) });
}

fn joint_pavement(segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, from_map: Mapper, to_map: Mapper, from_len: f64, from_w: f64, to_w: f64, exit_right: bool) *CxList(RiderPt) {
    return b0: { const inner = map_pt(segs, ch, pose, from_map, from_len, @as(f64, (if (exit_right) from_w else @as(f64, @bitCast(@as(i64, 0)))))); break :b0 b1: { const outer_from = map_pt(segs, ch, pose, from_map, from_len, outer_cu(exit_right, from_w)); break :b1 b2: { const outer_to = map_pt(segs, ch, pose, to_map, @as(f64, @bitCast(@as(i64, 0))), outer_cu(exit_right, to_w)); break :b2 b3: { const q = joint_apex(segs, ch, pose, from_map, to_map, from_len, from_w, to_w, exit_right); break :b3 cx_ll_of(RiderPt, &[_]RiderPt{ inner, outer_from, q, outer_to }); }; }; }; };
}

fn emit_joint_ground(segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, from_map: Mapper, to_map: Mapper, from_len: f64, from_w: f64, to_w: f64, exit_right: bool, cf: f64, view_w: f64) *CxList(DrawCmd) {
    return cx_ll_concat(emit_ground(joint_approach(segs, ch, pose, from_map, from_len, from_w), cf, view_w), emit_ground(joint_pavement(segs, ch, pose, from_map, to_map, from_len, from_w, to_w, exit_right), cf, view_w));
}

fn pond_shape(segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, m_: Mapper, from_len: f64, ps: *CxList(PondPt), i_: i64) *CxList(RiderPt) {
    return (if ((i_ >= cx_list_len(ps))) cx_ll_empty(RiderPt) else cx_ll_concat(cx_ll_of(RiderPt, &[_]RiderPt{ map_pt(segs, ch, pose, m_, (from_len + cx_list_at(ps, i_).cv), cx_list_at(ps, i_).cu) }), pond_shape(segs, ch, pose, m_, from_len, ps, (i_ +% 1))));
}

fn emit_pond_ground(segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, m_: Mapper, from_len: f64, cf: f64, view_w: f64) *CxList(DrawCmd) {
    return cx_ll_concat(emit_ground_color(pond_shape(segs, ch, pose, m_, from_len, water_outline(), 0), water_color(), cf, view_w), emit_ground_color(pond_shape(segs, ch, pose, m_, from_len, bank(), 0), bank_color(), cf, view_w));
}

fn seg_ground(segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, d_: i64, cf: f64, view_w: f64) *CxList(DrawCmd) {
    return cx_ll_concat(cx_ll_concat(seg_road(segs, ch, pose, d_, cf, view_w), seg_joint_ground(segs, ch, pose, d_, cf, view_w)), seg_pond_ground(segs, ch, pose, d_, cf, view_w));
}

fn seg_joint_ground(segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, d_: i64, cf: f64, view_w: f64) *CxList(DrawCmd) {
    return (if (((d_ +% 1) >= cx_list_len(ch))) cx_ll_empty(DrawCmd) else emit_joint_ground(segs, ch, pose, chain_map(d_), chain_map((d_ +% 1)), cx_list_at(segs, cx_list_at(ch, d_)).length, cx_list_at(segs, cx_list_at(ch, d_)).width, cx_list_at(segs, cx_list_at(ch, (d_ +% 1))).width, cx_list_at(segs, cx_list_at(ch, d_)).exit_right, cf, view_w));
}

fn seg_pond_ground(segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, d_: i64, cf: f64, view_w: f64) *CxList(DrawCmd) {
    return b0: { const sg = cx_list_at(segs, cx_list_at(ch, d_)); break :b0 (if (is_pond(sg.exit_creature)) emit_pond_ground(segs, ch, pose, chain_map(d_), sg.length, cf, view_w) else cx_ll_empty(DrawCmd)); };
}

fn walk_ground(segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, cf: f64, view_w: f64, d_: i64) *CxList(DrawCmd) {
    return (if ((d_ >= cx_list_len(ch))) cx_ll_empty(DrawCmd) else cx_ll_concat(seg_ground(segs, ch, pose, d_, cf, view_w), walk_ground(segs, ch, pose, cf, view_w, (d_ +% 1))));
}

fn behind_ground(segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, prev_idx: i64, cf: f64, view_w: f64) *CxList(DrawCmd) {
    return b0: { const pv = cx_list_at(segs, prev_idx); break :b0 cx_ll_concat(emit_joint_ground(segs, ch, pose, prev_map(pv), chain_map(0), pv.length, pv.width, cx_list_at(segs, cx_list_at(ch, 0)).width, pv.exit_right, cf, view_w), behind_pond_ground(segs, ch, pose, pv, cf, view_w)); };
}

fn behind_pond_ground(segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, pv: Segment, cf: f64, view_w: f64) *CxList(DrawCmd) {
    return (if (is_pond(pv.exit_creature)) emit_pond_ground(segs, ch, pose, prev_map(pv), pv.length, cf, view_w) else cx_ll_empty(DrawCmd));
}

fn frame_ground(segs: *CxList(Segment), seg_idx: i64, pose: Pose, cf: f64, view_w: f64) *CxList(DrawCmd) {
    return b0: { const ch = build_chain(segs, seg_idx); break :b0 (if ((seg_idx > 0)) cx_ll_concat(walk_ground(segs, ch, pose, cf, view_w, 0), behind_ground(segs, ch, pose, (seg_idx -% 1), cf, view_w)) else walk_ground(segs, ch, pose, cf, view_w, 0)); };
}

fn scene_step_at(u_: f64) f64 {
    return (@as(f64, @bitCast(@as(i64, 4660134898793709568))) + (@as(f64, @bitCast(@as(i64, 4653872080561897472))) * u_));
}

fn drive_speed() f64 {
    return (v_max() * @as(f64, @bitCast(@as(i64, 4605380978949069210))));
}

fn u_per_step() f64 {
    return (drive_speed() / (course_length(build_world()) * @as(f64, @bitCast(@as(i64, 4607137382803743703)))));
}

fn pos_from(w: *CxList(Segment), dist: f64, i_: i64) RoutePos {
    var _tl_dist = dist;
    var _tl_i = i_;
    while (true) {
        if (((_tl_i +% 1) >= cx_list_len(w))) { return cx_new(RoutePosS{ .seg = _tl_i, .along = _tl_dist }); } else { if ((_tl_dist < cx_list_at(w, _tl_i).length)) { return cx_new(RoutePosS{ .seg = _tl_i, .along = _tl_dist }); } else { { const _tj2_1 = (_tl_dist - cx_list_at(w, _tl_i).length); const _tj2_2 = (_tl_i +% 1); _tl_dist = _tj2_1; _tl_i = _tj2_2; continue; } } }
    }
}

fn drive_pos_at(w: *CxList(Segment), u_: f64) RoutePos {
    return pos_from(w, ((course_length(w) * u_) * @as(f64, @bitCast(@as(i64, 4607137382803743703)))), 0);
}

fn turn_blend_dist() f64 {
    return @as(f64, @bitCast(@as(i64, 4638144666238189568)));
}

fn heading_of(w: *CxList(Segment), p_: RoutePos) f64 {
    return b0: { const sg = cx_list_at(w, p_.seg); break :b0 (if (((p_.seg +% 1) >= cx_list_len(w))) sg.north_heading else blend_heading(sg, cx_list_at(w, (p_.seg +% 1)), p_.along)); };
}

fn blend_heading(sg: Segment, nx: Segment, along: f64) f64 {
    return b0: { const left: f64 = (sg.length - along); break :b0 (if ((left >= turn_blend_dist())) sg.north_heading else (sg.north_heading + (((nx.north_heading - sg.north_heading) * (turn_blend_dist() - left)) / turn_blend_dist()))); };
}

fn heading_in(w: *CxList(Segment), u_: f64) f64 {
    return heading_of(w, drive_pos_at(w, u_));
}

fn scene_sun_at(u_: f64) SunPos {
    return sun_pos(heading_in(build_world(), u_), scene_step_at(u_), focal(), camera_w());
}

fn pose_in(w: *CxList(Segment), u_: f64) Pose {
    return b0: { const p_ = drive_pos_at(w, u_); break :b0 cx_new(PoseS{ .along = p_.along, .across = @as(f64, @bitCast(@as(i64, 0))), .yaw = @as(f64, @bitCast(@as(i64, 0))), .hw = (cx_list_at(w, p_.seg).width / @as(f64, @bitCast(@as(i64, 4611686018427387904)))) }); };
}

fn closer_count(ts: *CxList(TreeItem), f: f64, i_: i64) i64 {
    var _tl_i = i_;
    while (true) {
        if ((_tl_i >= cx_list_len(ts))) { return 0; } else { if ((cx_list_at(ts, _tl_i).fwd < f)) { return (1 +% closer_count(ts, f, (_tl_i +% 1))); } else { { const _tj2_2 = (_tl_i +% 1); _tl_i = _tj2_2; continue; } } }
    }
}

fn crown_shade_of(fwd: f64) f64 {
    return b0: { const raw_: f64 = (@as(f64, @bitCast(@as(i64, 4607182418800017408))) - (fwd / crown_shade_dist())); break :b0 @as(f64, (if ((raw_ < @as(f64, @bitCast(@as(i64, 0))))) @as(f64, @bitCast(@as(i64, 0))) else @as(f64, (if ((raw_ > @as(f64, @bitCast(@as(i64, 4607182418800017408))))) @as(f64, @bitCast(@as(i64, 4607182418800017408))) else raw_)))); };
}

fn draw_one_tree(ts: *CxList(TreeItem), i_: i64, cf: f64) *CxList(DrawCmd) {
    return b0: { const t = cx_list_at(ts, i_); break :b0 tree_draw(t.right, t.fwd, t.height, t.color, cf, camera_w(), (closer_count(ts, t.fwd, 0) < 4), (t.fwd < detail_dist()), crown_shade_of(t.fwd)); };
}

fn tower_base(w: *CxList(Segment), ch: *CxList(i64), pose: Pose, tw: TowerItem, k_: i64) *CxList(RiderPt) {
    return (if ((k_ >= 4)) cx_ll_empty(RiderPt) else cx_ll_concat(cx_ll_of(RiderPt, &[_]RiderPt{ map_pt(w, ch, pose, tw.map, base_corner_ax(k_, tw.a0, tw.x0, tw.yaw).a_, base_corner_ax(k_, tw.a0, tw.x0, tw.yaw).x) }), tower_base(w, ch, pose, tw, (k_ +% 1))));
}

fn draw_one_tower(w: *CxList(Segment), ch: *CxList(i64), pose: Pose, tw: TowerItem, cf: f64, step: f64) *CxList(DrawCmd) {
    return draw_flat(tower_base(w, ch, pose, tw, 0), map_pt(w, ch, pose, tw.map, tw.a0, tw.x0), cf, camera_w(), (step + tw.off_));
}

fn draw_item(w: *CxList(Segment), ch: *CxList(i64), pose: Pose, c_: Collected, it: Item, cf: f64, step: f64) *CxList(DrawCmd) {
    return switch (it.kind) { .KTree => draw_one_tree(c_.trees, it.i_, cf), .KTower => draw_one_tower(w, ch, pose, cx_list_at(c_.towers, it.i_), cf, step), .KRail => rail_draw_poly(cx_list_at(c_.rails, it.i_), cf, camera_w()), .KCow => cx_ll_empty(DrawCmd), .KCat => cx_ll_empty(DrawCmd), .KTruck => cx_ll_empty(DrawCmd),  };
}

fn draw_order(w: *CxList(Segment), ch: *CxList(i64), pose: Pose, c_: Collected, cf: f64, step: f64, i_: i64) *CxList(DrawCmd) {
    return (if ((i_ >= cx_list_len(c_.order))) cx_ll_empty(DrawCmd) else cx_ll_concat(draw_item(w, ch, pose, c_, cx_list_at(c_.order, i_), cf, step), draw_order(w, ch, pose, c_, cf, step, (i_ +% 1))));
}

fn frame_at(u_: f64) *CxList(DrawCmd) {
    return frame_in(build_world(), u_);
}

fn frame_in(w: *CxList(Segment), u_: f64) *CxList(DrawCmd) {
    return b0: { const p_ = drive_pos_at(w, u_); break :b0 b1: { const pose = pose_in(w, u_); break :b1 b2: { const step: f64 = scene_step_at(u_); break :b2 b3: { const ch = build_chain(w, p_.seg); break :b3 cx_ll_concat(cx_ll_concat(draw(heading_in(w, u_), sun_set_fraction(step), focal(), camera_w()), frame_ground(w, p_.seg, pose, focal(), camera_w())), draw_order(w, ch, pose, collect(w, p_.seg, pose, focal(), p_.along, @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0)))), focal(), step, 0)); }; }; }; };
}

fn frame() *CxList(DrawCmd) {
    return frame_at(@as(f64, @bitCast(@as(i64, 0))));
}

fn head_yaw_frac() f64 {
    return @as(f64, @bitCast(@as(i64, 4594572339843380019)));
}

fn view_yaw_for(s_: RiderState) f64 {
    return (s_.gaze_yaw + (head_yaw_frac() * s_.tilt));
}

fn step_for(w: *CxList(Segment), s_: RiderState) f64 {
    return (@as(f64, @bitCast(@as(i64, 4660134898793709568))) + ((@as(f64, @bitCast(@as(i64, 4653872080561897472))) * route_distance(w, s_.segment, s_.along)) / course_length(w)));
}

fn heading_for(s_: RiderState) f64 {
    return (s_.heading + view_yaw_for(s_));
}

fn frame_for(w: *CxList(Segment), s_: RiderState) *CxList(DrawCmd) {
    return b0: { const pose = cx_new(PoseS{ .along = s_.along, .across = s_.across, .yaw = (s_.yaw + view_yaw_for(s_)), .hw = (cx_list_at(w, s_.segment).width / @as(f64, @bitCast(@as(i64, 4611686018427387904)))) }); break :b0 b1: { const step: f64 = step_for(w, s_); break :b1 b2: { const ch = build_chain(w, s_.segment); break :b2 cx_ll_concat(cx_ll_concat(draw(heading_for(s_), sun_set_fraction(step), focal(), camera_w()), frame_ground(w, s_.segment, pose, focal(), camera_w())), draw_order(w, ch, pose, collect(w, s_.segment, pose, focal(), s_.along, s_.v_, @as(f64, @bitCast(@as(i64, 0)))), focal(), step, 0)); }; }; };
}

fn report(u_: f64) []const u8 {
    return b0: { const sun = (if (scene_sun_at(u_).visible) "\x13\x19\x12\x02\x10\x12\x02" else "\x13\x19\x12\x02\x10\x1c\x1c"); break :b0 cx_concat(cx_concat(cx_concat(cx_concat(cx_concat(cx_concat(cx_concat(cx_concat(cx_concat(cx_concat(cx_concat("\x13\x0d\x1d\x02", cx_show_int(drive_pos_at(build_world(), u_).seg)), "\x02\x13\x22\x1e\x02"), cx_show_int(sky_color(scene_step_at(u_)))), "\x02\x14\x10\x15\x11\x26\x10\x12\x02"), cx_show_int(horizon_color(scene_step_at(u_)))), "\x02"), sun), "\x02\x24\x02"), cx_show_int(cx_real_to_int(scene_sun_at(u_).x))), "\x02\x18\x1a\x16\x13\x02"), cx_show_int(cx_list_len(frame_at(u_)))); };
}

fn opening() void {
    return b0: { _ = cx_print_line(cx_concat("\x18\x1a\x16\x13\x02\x02", cx_show_int(cx_list_len(frame())))); _ = cx_print_line(cx_concat(cx_concat(cx_concat(cx_concat(cx_concat(cx_concat(cx_concat(cx_concat(cx_concat(cx_concat(cx_concat("\x15\x11\x16\x0d\x15\x02", cx_show_int(cx_list_len(frame_for(build_world(), initial_rider_state())))), "\x02\x18\x1a\x16\x13\x02\x0f\x0e\x02\x0e\x14\x0d\x02\x13\x0e\x0f\x15\x0e\x02\x17\x11\x12\x0d\x42\x02\x0e\x11\x17\x0e\x02\x0d\x49\x06\x02"), cx_show_int(cx_real_to_int((initial_rider_state().tilt * @as(f64, @bitCast(@as(i64, 4652007308841189376))))))), "\x02\x13\x19\x12\x49\x24\x02"), cx_show_int(cx_real_to_int(sun_pos(heading_for(initial_rider_state()), step_for(build_world(), initial_rider_state()), focal(), camera_w()).x))), "\x02\x13\x0e\x0d\x1f\x02"), cx_show_int(cx_real_to_int(step_for(build_world(), initial_rider_state())))), "\x02\x1c\x11\x12\x11\x13\x14\x0d\x16\x02"), (if (is_finished(initial_rider_state(), build_world())) "\x1e\x0d\x13" else "\x12\x10")), "\x02\x12\x0d\x24\x0e\x49\x21\x02\x0d\x49\x06\x02"), cx_show_int(cx_real_to_int((get_next_rider_state(initial_rider_state(), build_world()).v_ * @as(f64, @bitCast(@as(i64, 4652007308841189376)))))))); _ = cx_print_line(cx_concat(cx_concat("\x1a\x51\x1c\x15\x0f\x1a\x0d\x02", cx_show_int(cx_real_to_int((u_per_step() * @as(f64, @bitCast(@as(i64, 4681608360884174848))))))), "\x02\x0d\x49\x08\x02\x10\x1c\x02\x0e\x14\x0d\x02\x18\x10\x19\x15\x13\x0d")); _ = cx_print_line(cx_concat("\x19\x4d\x03\x41\x03\x03\x02", report(@as(f64, @bitCast(@as(i64, 0)))))); _ = cx_print_line(cx_concat("\x19\x4d\x03\x41\x05\x08\x02", report(@as(f64, @bitCast(@as(i64, 4598175219545276416)))))); _ = cx_print_line(cx_concat("\x19\x4d\x03\x41\x08\x03\x02", report(@as(f64, @bitCast(@as(i64, 4602678819172646912)))))); _ = cx_print_line(cx_concat("\x19\x4d\x03\x41\x0a\x08\x02", report(@as(f64, @bitCast(@as(i64, 4604930618986332160)))))); _ = cx_print_line(cx_concat("\x19\x4d\x04\x41\x03\x03\x02", report(@as(f64, @bitCast(@as(i64, 4607182418800017408)))))); break :b0; };
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
// THE DRIVE SHIM. Appended to the transpiled program by harness/wasmify.py.
//
// Where poc/shim.zig answers every frame from a scrub `u`, this one RUNS THE
// PORTED PHYSICS. `Safari chapter Rider` is graded at 199 values one step from a
// shared state, so the page can just step it -- and stepping it is what fixes,
// as consequences rather than as separate patches, the speed (the game's, corner
// by corner, instead of one average), the acceleration and braking (which a
// constant cannot have at all), the lean (tilt is a field on the state and the
// old page simply never asked), and the heading (the rider's own, so the blended
// stand-in Drive used is gone).
//
// Measured before this existed: the real rider averages 1.18 m/frame over the
// first 4,000 frames and ranges 0.53..1.75 by segment. The scrub ran a flat 2.0.
//
// THE STATE LIVES OUT HERE, IN ZIG STATICS, AND IT HAS TO. Every Codex record is
// a pointer into the bump arena, and renderFrame rewinds that arena every call
// (PORTING_NOTES C8) -- so a RiderState returned by the transpiled program is
// dangling by the next frame. RiderStateS is flat scalars, so the shim keeps a
// VALUE and passes its address in. Two rules follow and both are load-bearing:
//
//   the world is built ONCE and BEFORE the reset base is captured, so the rewind
//     never reclaims it (it is ~20 segments of trees, herds and cat placements);
//   every returned record is copied out by value before the next rewind.

const CAP_WORDS: usize = (1 << 20) / 4;
var cx_paint: [CAP_WORDS]u32 = undefined;
var cx_paint_high: usize = 0;

var cx_world: ?*CxList(Segment) = null;
var cx_rider: RiderStateS = undefined;
var cx_hp_base: i64 = 0;

// A SHALLOW HISTORY, so the down arrow is not a dead key. The physics has no
// inverse -- you cannot un-integrate a lean search -- and the real game keeps an
// 8192-deep ring for exactly this. 2048 frames is about half the route at the
// speeds measured above, which is plenty for stepping back to look at something.
const HIST: usize = 2048;
var cx_hist: [HIST]RiderStateS = undefined;
var cx_hn: usize = 0;

fn ensure() void {
    if (cx_world != null) return;
    cx_world = build_world();
    cx_rider = initial_rider_state().*;
    // AFTER the world, never before: the rewind goes back to here.
    cx_hp_base = cx_hp;
}

fn restart() void {
    cx_rider = initial_rider_state().*;
    cx_hn = 0;
}

pub export fn renderFrame() u32 {
    ensure();
    cx_hp = cx_hp_base;
    var w: usize = 0;
    const cmds = frame_for(cx_world.?, &cx_rider);
    for (cmds.items.items) |cmd| {
        const pts = cmd.pts.items.items;
        const n = pts.len / 2;
        // tag 3 is a DISC -- [3][color][x][y][r][alpha], six words and no point
        // count, because the blitter draws a true arc for it.
        if (cmd.tag == 3) {
            if (w + 6 > CAP_WORDS) break;
            cx_paint[w] = 3;
            cx_paint[w + 1] = @intCast(cmd.color);
            cx_paint[w + 2] = @bitCast(@as(f32, @floatCast(pts[0])));
            cx_paint[w + 3] = @bitCast(@as(f32, @floatCast(pts[1])));
            cx_paint[w + 4] = @bitCast(@as(f32, @floatCast(pts[2])));
            cx_paint[w + 5] = @bitCast(@as(f32, @floatCast(cmd.strength)));
            w += 6;
            continue;
        }
        const head: usize = if (cmd.tag == 1) 4 else 3;
        if (w + head + pts.len > CAP_WORDS) break;
        cx_paint[w] = @intCast(cmd.tag);
        cx_paint[w + 1] = @intCast(cmd.color);
        if (cmd.tag == 1) {
            cx_paint[w + 2] = @bitCast(@as(f32, @floatCast(cmd.strength)));
            cx_paint[w + 3] = @intCast(n);
        } else {
            cx_paint[w + 2] = @intCast(n);
        }
        w += head;
        // THE f64 -> f32 NARROWING HAPPENS HERE AND ONLY HERE, the seam the
        // hand-written zig already narrows at.
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

// ONE STEP OF THE REAL RIDER. The screensaver replays rather than stopping, so
// the finish line restarts, which is what safari.zig does.
pub export fn advance() void {
    ensure();
    cx_hp = cx_hp_base;
    if (is_finished(&cx_rider, cx_world.?)) {
        restart();
        return;
    }
    if (cx_hn < HIST) {
        cx_hist[cx_hn] = cx_rider;
        cx_hn += 1;
    }
    cx_rider = get_next_rider_state(&cx_rider, cx_world.?).*;
}

pub export fn back() void {
    ensure();
    if (cx_hn == 0) return;
    cx_hn -= 1;
    cx_rider = cx_hist[cx_hn];
}

// THE LEAN, WHICH THE PAGE USED TO THROW AWAY. blitter.js rotates the whole
// canvas by this, so it is the bank you see going into a corner. The deadband is
// safari.zig's: below a thousandth of a radian it snaps to level rather than
// jittering the canvas about a value that is really zero.
pub export fn riderTilt() f32 {
    ensure();
    const t = cx_rider.tilt;
    return if (@abs(t) < 1.0e-3) 0.0 else @floatCast(t);
}

// J walks until this changes; now it really is the segment index.
pub export fn riderSeg() u32 {
    ensure();
    return @intCast(cx_rider.segment);
}

pub export fn clock() u32 {
    ensure();
    cx_hp = cx_hp_base;
    return @intFromFloat(step_for(cx_world.?, &cx_rider));
}

// Sky, horizon and sun are NOT polygons: blitter.js paints them itself and asks
// the module for the numbers, so they never reach the buffer above. They read the
// rider's own heading now, gaze and head-turn folded in, so the backdrop swings
// with the view exactly as the scene does.
//
// THE SUN GOES THROUGH sun_pos DIRECTLY, not through Drive's `sun-for` wrapper,
// and that is PORTING_NOTES B12 rather than a style choice: a Codex definition
// whose body is a single application is INLINED and never becomes a zig function,
// so `sun-for` does not exist to call from out here. B12's own advice is to write
// the shim against the real functions, and this is that.
fn sunHere() SunPos {
    cx_hp = cx_hp_base;
    return sun_pos(heading_for(&cx_rider), step_for(cx_world.?, &cx_rider), focal(), camera_w());
}
pub export fn skyTop() u32 {
    ensure();
    cx_hp = cx_hp_base;
    return @intCast(sky_color(step_for(cx_world.?, &cx_rider)));
}
pub export fn skyHorizon() u32 {
    ensure();
    cx_hp = cx_hp_base;
    return @intCast(horizon_color(step_for(cx_world.?, &cx_rider)));
}
pub export fn sunVisible() u32 {
    ensure();
    return @intFromBool(sunHere().visible);
}
pub export fn sunX() f32 {
    ensure();
    return @floatCast(sunHere().x);
}
pub export fn sunY() f32 {
    ensure();
    return @floatCast(sunHere().y);
}
pub export fn sunScale() f32 {
    ensure();
    return @floatCast(sunHere().scale);
}

// Extra readouts the blitter's HUD does not know about but a probe can use.
pub export fn riderV() f32 {
    ensure();
    return @floatCast(cx_rider.v_);
}

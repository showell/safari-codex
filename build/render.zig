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

const CatS = struct {
    along: f64,
    start_across: f64,
    mid_across: f64,
    end_across: f64,
    height: f64,
};
const Cat = *CatS;

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
    rails: *CxList(RailPoly),
    truck: TruckAt,
    order: *CxList(Item),
    cull_seg: i64,
    cull_size: i64,
};
const Collected = *CollectedS;

const StateS = struct {
    seg: i64,
    along: f64,
    across: f64,
    yaw: f64,
    cf: f64,
    vyaw: f64,
    tpos: f64,
};
const State = *StateS;

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

fn round_real(x: f64) f64 {
    return (if ((x < @as(f64, @bitCast(@as(i64, 0))))) (@as(f64, @bitCast(@as(i64, 0))) - cx_real_from_int(cx_real_to_int((@as(f64, @bitCast(@as(i64, 4602678819172646912))) - x)))) else cx_real_from_int(cx_real_to_int((x + @as(f64, @bitCast(@as(i64, 4602678819172646912)))))));
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

fn camera_w() f64 {
    return @as(f64, @bitCast(@as(i64, 4651655465120301056)));
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

fn duck_codepoint() i64 {
    return 129414;
}

fn duck_height() f64 {
    return @as(f64, @bitCast(@as(i64, 4606281698874543309)));
}

fn ducks() *CxList(Duck) {
    return cx_ll_of(Duck, &[_]Duck{ cx_new(DuckS{ .p_ = cx_new(PondPtS{ .cu = (-@as(f64, @bitCast(@as(i64, 4620693217682128896)))), .cv = @as(f64, @bitCast(@as(i64, 4622382067542392832))) }), .face_right = true }), cx_new(DuckS{ .p_ = cx_new(PondPtS{ .cu = (-@as(f64, @bitCast(@as(i64, 4625196817309499392)))), .cv = @as(f64, @bitCast(@as(i64, 4625478292286210048))) }), .face_right = false }), cx_new(DuckS{ .p_ = cx_new(PondPtS{ .cu = (-@as(f64, @bitCast(@as(i64, 4621256167635550208)))), .cv = @as(f64, @bitCast(@as(i64, 4626604192193052672))) }), .face_right = true }), cx_new(DuckS{ .p_ = cx_new(PondPtS{ .cu = (-@as(f64, @bitCast(@as(i64, 4616189618054758400)))), .cv = @as(f64, @bitCast(@as(i64, 4618441417868443648))) }), .face_right = true }), cx_new(DuckS{ .p_ = cx_new(PondPtS{ .cu = (-@as(f64, @bitCast(@as(i64, 4622945017495814144)))), .cv = @as(f64, @bitCast(@as(i64, 4619567317775286272))) }), .face_right = false }), cx_new(DuckS{ .p_ = cx_new(PondPtS{ .cu = (-@as(f64, @bitCast(@as(i64, 4626322717216342016)))), .cv = @as(f64, @bitCast(@as(i64, 4620693217682128896))) }), .face_right = true }) });
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

fn build_chain(_arg_segs: *CxList(Segment), start_: i64) *CxList(i64) {
    return chain_from(_arg_segs, start_, 0);
}

fn chain_from(_arg_segs: *CxList(Segment), s_: i64, n_: i64) *CxList(i64) {
    return (if ((n_ >= look_ahead())) cx_ll_empty(i64) else (if ((n_ >= max_chain())) cx_ll_empty(i64) else (if (cx_list_at(_arg_segs, s_).terminates) cx_ll_of(i64, &[_]i64{ s_ }) else cx_ll_concat(cx_ll_of(i64, &[_]i64{ s_ }), chain_from(_arg_segs, cx_list_at(_arg_segs, s_).exit_to, (n_ +% 1))))));
}

fn compose_down(_arg_segs: *CxList(Segment), ch: *CxList(i64), k_: i64, a_: f64, x: f64) AX {
    var _tl_k = k_;
    var _tl_a = a_;
    var _tl_x = x;
    while (true) {
        if ((_tl_k <= 0)) { return cx_new(AXS{ .a_ = _tl_a, .x = _tl_x }); } else { const seg = cx_list_at(_arg_segs, cx_list_at(ch, (_tl_k -% 1))); const p_ = next_to_cur(_tl_a, _tl_x, seg.length, seg.exit_angle, seg.exit_right, seg.width); { const _tj3_2 = (_tl_k -% 1); const _tj3_3 = p_.a_; const _tj3_4 = p_.x; _tl_k = _tj3_2; _tl_a = _tj3_3; _tl_x = _tj3_4; continue; } }
    }
}

fn at(_arg_segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, d_: i64, a_: f64, x: f64) RiderPt {
    return b0: { const p_ = compose_down(_arg_segs, ch, d_, a_, x); break :b0 to_rider(p_.a_, p_.x, pose.along, pose.across, pose.yaw, pose.hw); };
}

fn chain_map(d_: i64) Mapper {
    return cx_new(MapperS{ .is_chain = true, .d_ = d_, .prev_len = @as(f64, @bitCast(@as(i64, 0))), .prev_angle = @as(f64, @bitCast(@as(i64, 0))), .prev_right = false, .prev_w = @as(f64, @bitCast(@as(i64, 0))) });
}

fn prev_map(s_: Segment) Mapper {
    return cx_new(MapperS{ .is_chain = false, .d_ = 0, .prev_len = s_.length, .prev_angle = s_.exit_angle, .prev_right = s_.exit_right, .prev_w = s_.width });
}

fn map_pt(_arg_segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, m_: Mapper, a_: f64, x: f64) RiderPt {
    return (if (m_.is_chain) at(_arg_segs, ch, pose, m_.d_, a_, x) else b1: { const p_ = cur_to_next(a_, x, m_.prev_len, m_.prev_angle, m_.prev_right, m_.prev_w); break :b1 to_rider(p_.a_, p_.x, pose.along, pose.across, pose.yaw, pose.hw); });
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

fn render_tower_beyond() f64 {
    return @as(f64, @bitCast(@as(i64, 4639833516098453504)));
}

fn render_tower_right() f64 {
    return @as(f64, @bitCast(@as(i64, 4626322717216342016)));
}

fn seg_tower_left() f64 {
    return @as(f64, @bitCast(@as(i64, 4636737291354636288)));
}

fn tower_yaw() f64 {
    return ((@as(f64, @bitCast(@as(i64, 4629137466983448576))) * @as(f64, @bitCast(@as(i64, 4614256656543962353)))) / @as(f64, @bitCast(@as(i64, 4640537203540230144))));
}

fn no_billboard() Billboard {
    return cx_new(BillboardS{ .right = @as(f64, @bitCast(@as(i64, 0))), .fwd = @as(f64, @bitCast(@as(i64, 0))), .height = @as(f64, @bitCast(@as(i64, 0))), .cp_ = 0, .face_right = false });
}

fn verdict(rp: RiderPt, h_: f64, cp_: i64, fr: bool) Placed {
    return (if ((rp.forward <= near())) cx_new(PlacedS{ .b_ = no_billboard(), .kept = false, .size_culled = false }) else (if ((((h_ / rp.forward) * focal()) < min_critter_px())) cx_new(PlacedS{ .b_ = no_billboard(), .kept = false, .size_culled = true }) else cx_new(PlacedS{ .b_ = cx_new(BillboardS{ .right = rp.right, .fwd = rp.forward, .height = h_, .cp_ = cp_, .face_right = fr }), .kept = true, .size_culled = false })));
}

fn place_critter(_arg_segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, d_: i64, hw: f64, cr: Critter) Placed {
    return b0: { const rp = at(_arg_segs, ch, pose, d_, cr.along, (cr.across + hw)); break :b0 verdict(rp, cr.height, cr.codepoint, cr.face_right); };
}

fn place_critter_via(_arg_segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, m_: Mapper, hw: f64, cr: Critter) Placed {
    return b0: { const rp = map_pt(_arg_segs, ch, pose, m_, cr.along, (cr.across + hw)); break :b0 verdict(rp, cr.height, cr.codepoint, cr.face_right); };
}

fn place_duck(_arg_segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, m_: Mapper, from_len: f64, dk: Duck) Placed {
    return b0: { const rp = map_pt(_arg_segs, ch, pose, m_, (from_len + dk.p_.cv), dk.p_.cu); break :b0 verdict(rp, duck_height(), duck_codepoint(), dk.face_right); };
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

fn place_all(_arg_segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, d_: i64, hw: f64, crs: *CxList(Critter), i_: i64) *CxList(Placed) {
    return (if ((i_ >= cx_list_len(crs))) cx_ll_empty(Placed) else cx_ll_concat(cx_ll_of(Placed, &[_]Placed{ place_critter(_arg_segs, ch, pose, d_, hw, cx_list_at(crs, i_)) }), place_all(_arg_segs, ch, pose, d_, hw, crs, (i_ +% 1))));
}

fn place_all_via(_arg_segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, m_: Mapper, hw: f64, crs: *CxList(Critter), i_: i64) *CxList(Placed) {
    return (if ((i_ >= cx_list_len(crs))) cx_ll_empty(Placed) else cx_ll_concat(cx_ll_of(Placed, &[_]Placed{ place_critter_via(_arg_segs, ch, pose, m_, hw, cx_list_at(crs, i_)) }), place_all_via(_arg_segs, ch, pose, m_, hw, crs, (i_ +% 1))));
}

fn place_ducks(_arg_segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, m_: Mapper, from_len: f64, i_: i64) *CxList(Placed) {
    return (if ((i_ >= cx_list_len(ducks()))) cx_ll_empty(Placed) else cx_ll_concat(cx_ll_of(Placed, &[_]Placed{ place_duck(_arg_segs, ch, pose, m_, from_len, cx_list_at(ducks(), i_)) }), place_ducks(_arg_segs, ch, pose, m_, from_len, (i_ +% 1))));
}

fn place_tree(_arg_segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, d_: i64, cf: f64, hw: f64, tr: Tree) *CxList(TreeItem) {
    return b0: { const rp = at(_arg_segs, ch, pose, d_, tr.along, (tr.across + hw)); break :b0 (if ((rp.forward <= near())) cx_ll_empty(TreeItem) else (if ((((tr.height / rp.forward) * cf) < min_scenery_px())) cx_ll_empty(TreeItem) else cx_ll_of(TreeItem, &[_]TreeItem{ cx_new(TreeItemS{ .right = rp.right, .fwd = rp.forward, .height = tr.height, .color = tr.color }) }))); };
}

fn seg_trees(_arg_segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, d_: i64, cf: f64, hw: f64, trs: *CxList(Tree), i_: i64) *CxList(TreeItem) {
    return (if ((i_ >= cx_list_len(trs))) cx_ll_empty(TreeItem) else cx_ll_concat(place_tree(_arg_segs, ch, pose, d_, cf, hw, cx_list_at(trs, i_)), seg_trees(_arg_segs, ch, pose, d_, cf, hw, trs, (i_ +% 1))));
}

fn tower_if_ahead(_arg_segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, m_: Mapper, a0: f64, x0: f64, yw: f64, key: i64) *CxList(TowerItem) {
    return b0: { const c_ = map_pt(_arg_segs, ch, pose, m_, a0, x0); break :b0 (if ((c_.forward <= near())) cx_ll_empty(TowerItem) else cx_ll_of(TowerItem, &[_]TowerItem{ cx_new(TowerItemS{ .map = m_, .a0 = a0, .x0 = x0, .yaw = yw, .fwd = c_.forward, .off_ = cx_real_from_int(((key *% 37) -% (@divTrunc((key *% 37), 120) *% 120))) }) })); };
}

fn seg_towers(_arg_segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, d_: i64) *CxList(TowerItem) {
    return b0: { const sg = cx_list_at(_arg_segs, cx_list_at(ch, d_)); break :b0 cx_ll_concat(tower_if_ahead(_arg_segs, ch, pose, chain_map(d_), (sg.length + render_tower_beyond()), ((sg.width / @as(f64, @bitCast(@as(i64, 4611686018427387904)))) + render_tower_right()), tower_yaw(), cx_list_at(ch, d_)), seg_mid_tower(_arg_segs, ch, pose, d_)); };
}

fn seg_mid_tower(_arg_segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, d_: i64) *CxList(TowerItem) {
    return b0: { const sg = cx_list_at(_arg_segs, cx_list_at(ch, d_)); break :b0 (if (sg.has_mid_tower) tower_if_ahead(_arg_segs, ch, pose, chain_map(d_), (sg.length / @as(f64, @bitCast(@as(i64, 4611686018427387904)))), ((sg.width / @as(f64, @bitCast(@as(i64, 4611686018427387904)))) - seg_tower_left()), @as(f64, @bitCast(@as(i64, 0))), (cx_list_at(ch, d_) +% 60)) else cx_ll_empty(TowerItem)); };
}

fn is_pond(c_: Creature) bool {
    return switch (c_) { .DuckPond => true, .NoCreature => false, .Elephant => false, .Giraffe => false, .Zebra => false, .Rhino => false,  };
}

fn seg_farm(_arg_segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, d_: i64, hw: f64) *CxList(Placed) {
    return b0: { const sg = cx_list_at(_arg_segs, cx_list_at(ch, d_)); break :b0 (if ((d_ >= farm_seg_reach())) cx_ll_empty(Placed) else cx_ll_concat(place_all(_arg_segs, ch, pose, d_, hw, sg.cows, 0), place_all(_arg_segs, ch, pose, d_, hw, sg.pigs, 0))); };
}

fn seg_cull_count(_arg_segs: *CxList(Segment), ch: *CxList(i64), d_: i64) i64 {
    return b0: { const sg = cx_list_at(_arg_segs, cx_list_at(ch, d_)); break :b0 @as(i64, (if ((d_ >= farm_seg_reach())) (cx_list_len(sg.cows) +% cx_list_len(sg.pigs)) else 0)); };
}

fn seg_safari(_arg_segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, d_: i64, hw: f64) *CxList(Placed) {
    return b0: { const sg = cx_list_at(_arg_segs, cx_list_at(ch, d_)); break :b0 (if (sg.terminates) cx_ll_empty(Placed) else (if ((d_ >= safari_seg_reach())) cx_ll_empty(Placed) else place_all(_arg_segs, ch, pose, d_, hw, corner_critters(sg.exit_creature, sg.length, sg.exit_right, hw), 0))); };
}

fn seg_ducks(_arg_segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, d_: i64) *CxList(Placed) {
    return b0: { const sg = cx_list_at(_arg_segs, cx_list_at(ch, d_)); break :b0 (if ((d_ >= safari_seg_reach())) cx_ll_empty(Placed) else (if (is_pond(sg.exit_creature)) place_ducks(_arg_segs, ch, pose, chain_map(d_), sg.length, 0) else cx_ll_empty(Placed))); };
}

fn seg_billboards(_arg_segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, d_: i64) *CxList(Placed) {
    return b0: { const hw: f64 = (cx_list_at(_arg_segs, cx_list_at(ch, d_)).width / @as(f64, @bitCast(@as(i64, 4611686018427387904)))); break :b0 cx_ll_concat(cx_ll_concat(seg_farm(_arg_segs, ch, pose, d_, hw), seg_safari(_arg_segs, ch, pose, d_, hw)), seg_ducks(_arg_segs, ch, pose, d_)); };
}

fn walk_trees(_arg_segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, cf: f64, d_: i64) *CxList(TreeItem) {
    return (if ((d_ >= cx_list_len(ch))) cx_ll_empty(TreeItem) else cx_ll_concat(seg_trees(_arg_segs, ch, pose, d_, cf, (cx_list_at(_arg_segs, cx_list_at(ch, d_)).width / @as(f64, @bitCast(@as(i64, 4611686018427387904)))), cx_list_at(_arg_segs, cx_list_at(ch, d_)).trees, 0), walk_trees(_arg_segs, ch, pose, cf, (d_ +% 1))));
}

fn walk_towers(_arg_segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, d_: i64) *CxList(TowerItem) {
    return (if ((d_ >= cx_list_len(ch))) cx_ll_empty(TowerItem) else cx_ll_concat(seg_towers(_arg_segs, ch, pose, d_), walk_towers(_arg_segs, ch, pose, (d_ +% 1))));
}

fn walk_billboards(_arg_segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, d_: i64) *CxList(Placed) {
    return (if ((d_ >= cx_list_len(ch))) cx_ll_empty(Placed) else cx_ll_concat(seg_billboards(_arg_segs, ch, pose, d_), walk_billboards(_arg_segs, ch, pose, (d_ +% 1))));
}

fn walk_seg_cull(_arg_segs: *CxList(Segment), ch: *CxList(i64), d_: i64) i64 {
    return @as(i64, (if ((d_ >= cx_list_len(ch))) 0 else (seg_cull_count(_arg_segs, ch, d_) +% walk_seg_cull(_arg_segs, ch, (d_ +% 1)))));
}

fn behind_billboards(_arg_segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, prev_idx: i64) *CxList(Placed) {
    return b0: { const pv = cx_list_at(_arg_segs, prev_idx); break :b0 cx_ll_concat(place_all_via(_arg_segs, ch, pose, prev_map(pv), (pv.width / @as(f64, @bitCast(@as(i64, 4611686018427387904)))), corner_critters(pv.exit_creature, pv.length, pv.exit_right, (pv.width / @as(f64, @bitCast(@as(i64, 4611686018427387904))))), 0), (if (is_pond(pv.exit_creature)) place_ducks(_arg_segs, ch, pose, prev_map(pv), pv.length, 0) else cx_ll_empty(Placed))); };
}

fn behind_tower(_arg_segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, prev_idx: i64) *CxList(TowerItem) {
    return b0: { const pv = cx_list_at(_arg_segs, prev_idx); break :b0 tower_if_ahead(_arg_segs, ch, pose, prev_map(pv), (pv.length + render_tower_beyond()), ((pv.width / @as(f64, @bitCast(@as(i64, 4611686018427387904)))) + render_tower_right()), tower_yaw(), prev_idx); };
}

fn outer_cu(exit_right: bool, wd: f64) f64 {
    return @as(f64, (if (exit_right) @as(f64, @bitCast(@as(i64, 0))) else wd));
}

fn joint_apex(_arg_segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, from_map: Mapper, to_map: Mapper, from_len: f64, from_w: f64, to_w: f64, exit_right: bool) RiderPt {
    return b0: { const fcu: f64 = outer_cu(exit_right, from_w); break :b0 b1: { const tx: f64 = outer_cu(exit_right, to_w); break :b1 line_meet(map_pt(_arg_segs, ch, pose, from_map, from_len, fcu), map_pt(_arg_segs, ch, pose, from_map, (from_len + @as(f64, @bitCast(@as(i64, 4607182418800017408)))), fcu), map_pt(_arg_segs, ch, pose, to_map, @as(f64, @bitCast(@as(i64, 0))), tx), map_pt(_arg_segs, ch, pose, to_map, @as(f64, @bitCast(@as(i64, 4607182418800017408))), tx)); }; };
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

fn rail_run_up(_arg_segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, m_: Mapper, from_len: f64, cu: f64, k_: i64) *CxList(RiderPt) {
    return (if ((k_ < 0)) cx_ll_empty(RiderPt) else cx_ll_concat(cx_ll_of(RiderPt, &[_]RiderPt{ map_pt(_arg_segs, ch, pose, m_, (from_len - cx_real_from_int(k_)), cu) }), rail_run_up(_arg_segs, ch, pose, m_, from_len, cu, (k_ -% 1))));
}

fn rail_run_out(_arg_segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, m_: Mapper, x: f64, k_: i64) *CxList(RiderPt) {
    return (if ((k_ > rail_runout())) cx_ll_empty(RiderPt) else cx_ll_concat(cx_ll_of(RiderPt, &[_]RiderPt{ map_pt(_arg_segs, ch, pose, m_, cx_real_from_int(k_), x) }), rail_run_out(_arg_segs, ch, pose, m_, x, (k_ +% 1))));
}

fn joint_rail_path(_arg_segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, from_map: Mapper, to_map: Mapper, from_len: f64, from_w: f64, to_w: f64, exit_right: bool) *CxList(RiderPt) {
    return b0: { const fcu: f64 = outer_cu(exit_right, from_w); break :b0 b1: { const tx: f64 = outer_cu(exit_right, to_w); break :b1 b2: { const of_pt = map_pt(_arg_segs, ch, pose, from_map, from_len, fcu); break :b2 b3: { const ot_pt = map_pt(_arg_segs, ch, pose, to_map, @as(f64, @bitCast(@as(i64, 0))), tx); break :b3 b4: { const q = joint_apex(_arg_segs, ch, pose, from_map, to_map, from_len, from_w, to_w, exit_right); break :b4 cx_ll_concat(cx_ll_concat(cx_ll_concat(rail_run_up(_arg_segs, ch, pose, from_map, from_len, fcu, rail_runout()), push_leg(of_pt, q)), push_leg(q, ot_pt)), rail_run_out(_arg_segs, ch, pose, to_map, tx, 1)); }; }; }; }; };
}

fn joint_rails(_arg_segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, from_map: Mapper, to_map: Mapper, from_len: f64, from_w: f64, to_w: f64, exit_right: bool) *CxList(RailPoly) {
    return rail_emit(joint_rail_path(_arg_segs, ch, pose, from_map, to_map, from_len, from_w, to_w, exit_right));
}

fn walk_rails(_arg_segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, d_: i64) *CxList(RailPoly) {
    return (if (((d_ +% 1) >= cx_list_len(ch))) cx_ll_empty(RailPoly) else cx_ll_concat(joint_rails(_arg_segs, ch, pose, chain_map(d_), chain_map((d_ +% 1)), cx_list_at(_arg_segs, cx_list_at(ch, d_)).length, cx_list_at(_arg_segs, cx_list_at(ch, d_)).width, cx_list_at(_arg_segs, cx_list_at(ch, (d_ +% 1))).width, cx_list_at(_arg_segs, cx_list_at(ch, d_)).exit_right), walk_rails(_arg_segs, ch, pose, (d_ +% 1))));
}

fn behind_rails(_arg_segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, prev_idx: i64) *CxList(RailPoly) {
    return b0: { const pv = cx_list_at(_arg_segs, prev_idx); break :b0 joint_rails(_arg_segs, ch, pose, prev_map(pv), chain_map(0), pv.length, pv.width, cx_list_at(_arg_segs, cx_list_at(ch, 0)).width, pv.exit_right); };
}

fn no_truck() TruckAt {
    return cx_new(TruckAtS{ .present = false, .d_ = 0, .along = @as(f64, @bitCast(@as(i64, 0))), .fwd = @as(f64, @bitCast(@as(i64, 0))) });
}

fn truck_step(_arg_segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, remaining: f64, d_: i64) TruckAt {
    var _tl_remaining = remaining;
    var _tl_d = d_;
    while (true) {
        if ((_tl_d >= cx_list_len(ch))) { return no_truck(); } else { if ((_tl_remaining > cx_list_at(_arg_segs, cx_list_at(ch, _tl_d)).length)) { { const _tj2_3 = (_tl_remaining - cx_list_at(_arg_segs, cx_list_at(ch, _tl_d)).length); const _tj2_4 = (_tl_d +% 1); _tl_remaining = _tj2_3; _tl_d = _tj2_4; continue; } } else { return truck_here(_arg_segs, ch, pose, _tl_remaining, _tl_d); } }
    }
}

fn truck_here(_arg_segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, remaining: f64, d_: i64) TruckAt {
    return b0: { const c_ = at(_arg_segs, ch, pose, d_, remaining, (cx_list_at(_arg_segs, cx_list_at(ch, d_)).width / @as(f64, @bitCast(@as(i64, 4611686018427387904))))); break :b0 (if ((c_.forward > near())) cx_new(TruckAtS{ .present = true, .d_ = d_, .along = remaining, .fwd = c_.forward }) else no_truck()); };
}

fn truck_at(_arg_segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, along: f64, lead: f64) TruckAt {
    return (if ((lead > @as(f64, @bitCast(@as(i64, 0))))) truck_step(_arg_segs, ch, pose, (along + lead), 0) else no_truck());
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

fn rail_items(rs: *CxList(RailPoly), i_: i64) *CxList(Item) {
    return (if ((i_ >= cx_list_len(rs))) cx_ll_empty(Item) else cx_ll_concat(cx_ll_of(Item, &[_]Item{ cx_new(ItemS{ .fwd = cx_list_at(rs, i_).fwd, .kind = Kind.KRail, .i_ = i_ }) }), rail_items(rs, (i_ +% 1))));
}

fn truck_items(t: TruckAt) *CxList(Item) {
    return (if (t.present) cx_ll_of(Item, &[_]Item{ cx_new(ItemS{ .fwd = t.fwd, .kind = Kind.KTruck, .i_ = 0 }) }) else cx_ll_empty(Item));
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

fn collect(_arg_segs: *CxList(Segment), seg_idx: i64, pose: Pose, cf: f64, along: f64, truck_pos: f64) Collected {
    return b0: { const ch = build_chain(_arg_segs, seg_idx); break :b0 b1: { const placed = (if ((seg_idx > 0)) cx_ll_concat(walk_billboards(_arg_segs, ch, pose, 0), behind_billboards(_arg_segs, ch, pose, (seg_idx -% 1))) else walk_billboards(_arg_segs, ch, pose, 0)); break :b1 b2: { const trees = list_take(TreeItem, walk_trees(_arg_segs, ch, pose, cf, 0), max_vis_trees()); break :b2 b3: { const towers = list_take(TowerItem, (if ((seg_idx > 0)) cx_ll_concat(walk_towers(_arg_segs, ch, pose, 0), behind_tower(_arg_segs, ch, pose, (seg_idx -% 1))) else walk_towers(_arg_segs, ch, pose, 0)), max_vis_towers()); break :b3 b4: { const cows = list_take(Billboard, kept_of(placed, 0), max_vis_critters()); break :b4 b5: { const rails = (if ((seg_idx > 0)) cx_ll_concat(walk_rails(_arg_segs, ch, pose, 0), behind_rails(_arg_segs, ch, pose, (seg_idx -% 1))) else walk_rails(_arg_segs, ch, pose, 0)); break :b5 b6: { const tk = truck_at(_arg_segs, ch, pose, along, (truck_pos - (route_distance_from(_arg_segs, seg_idx, 0) + along))); break :b6 cx_new(CollectedS{ .trees = trees, .towers = towers, .cows = cows, .rails = rails, .truck = tk, .order = sort_items(cx_ll_concat(cx_ll_concat(cx_ll_concat(cx_ll_concat(tree_items(trees, 0), tower_items(towers, 0)), cow_items(cows, 0)), truck_items(tk)), rail_items(rails, 0))), .cull_seg = walk_seg_cull(_arg_segs, ch, 0), .cull_size = size_culled_of(placed, 0) }); }; }; }; }; }; }; };
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

fn g_r_chainlen() *CxList(i64) {
    return cx_ll_of(i64, &[_]i64{ 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 6, 5, 4, 3, 2, 1 });
}

fn g_r_chain() *CxList(i64) {
    @setEvalBranchQuota(1000000);
    return cx_ll_of(i64, &[_]i64{ 0, 1, 2, 3, 4, 5, 6, 1, 2, 3, 4, 5, 6, 7, 2, 3, 4, 5, 6, 7, 8, 3, 4, 5, 6, 7, 8, 9, 4, 5, 6, 7, 8, 9, 10, 5, 6, 7, 8, 9, 10, 11, 6, 7, 8, 9, 10, 11, 12, 7, 8, 9, 10, 11, 12, 13, 8, 9, 10, 11, 12, 13, 14, 9, 10, 11, 12, 13, 14, 15, 10, 11, 12, 13, 14, 15, 16, 11, 12, 13, 14, 15, 16, 17, 12, 13, 14, 15, 16, 17, 18, 13, 14, 15, 16, 17, 18, 14, 15, 16, 17, 18, 15, 16, 17, 18, 16, 17, 18, 17, 18, 18 });
}

fn g_r_at() *CxList(f64) {
    @setEvalBranchQuota(1000000);
    return cx_ll_of(f64, &[_]f64{ @as(f64, @bitCast(@as(i64, 4614840227016407515))), (-@as(f64, @bitCast(@as(i64, 4638143256752243689)))), @as(f64, @bitCast(@as(i64, 4617763908275041043))), (-@as(f64, @bitCast(@as(i64, 4638136223396263132)))), @as(f64, @bitCast(@as(i64, 4620012893789319147))), (-@as(f64, @bitCast(@as(i64, 4638129189336595133)))), @as(f64, @bitCast(@as(i64, 4627835154605277385))), (-@as(f64, @bitCast(@as(i64, 4638065883503270581)))), (-@as(f64, @bitCast(@as(i64, 4621309109138019808)))), @as(f64, @bitCast(@as(i64, 4638767697025389770))), (-@as(f64, @bitCast(@as(i64, 4619676014854452635)))), @as(f64, @bitCast(@as(i64, 4638771214055223769))), (-@as(f64, @bitCast(@as(i64, 4617427028777224578)))), @as(f64, @bitCast(@as(i64, 4638774731085057769))), @as(f64, @bitCast(@as(i64, 4623439548763696443))), @as(f64, @bitCast(@as(i64, 4638806383298032603))), (-@as(f64, @bitCast(@as(i64, 4626769934510964091)))), @as(f64, @bitCast(@as(i64, 4645382006606603716))), (-@as(f64, @bitCast(@as(i64, 4626207688244984556)))), @as(f64, @bitCast(@as(i64, 4645383764945598855))), (-@as(f64, @bitCast(@as(i64, 4625645441697530044)))), @as(f64, @bitCast(@as(i64, 4645385523812359576))), @as(f64, @bitCast(@as(i64, 4600583218605557680))), @as(f64, @bitCast(@as(i64, 4645401350094768853))), (-@as(f64, @bitCast(@as(i64, 4629020795605602009)))), @as(f64, @bitCast(@as(i64, 4647954026955309423))), (-@as(f64, @bitCast(@as(i64, 4628458549621097450)))), @as(f64, @bitCast(@as(i64, 4647954906300728853))), (-@as(f64, @bitCast(@as(i64, 4627896303073642938)))), @as(f64, @bitCast(@as(i64, 4647955785294304562))), (-@as(f64, @bitCast(@as(i64, 4620257488788681266)))), @as(f64, @bitCast(@as(i64, 4647963698611431062))), (-@as(f64, @bitCast(@as(i64, 4626411358471582806)))), @as(f64, @bitCast(@as(i64, 4645437100935248316))), (-@as(f64, @bitCast(@as(i64, 4626028399662343960)))), @as(f64, @bitCast(@as(i64, 4645411311670116504))), (-@as(f64, @bitCast(@as(i64, 4625645441697530044)))), @as(f64, @bitCast(@as(i64, 4645385523812359576))), (-@as(f64, @bitCast(@as(i64, 4617708418298132304)))), @as(f64, @bitCast(@as(i64, 4645153424120532341))), @as(f64, @bitCast(@as(i64, 4636523290151967827))), @as(f64, @bitCast(@as(i64, 4647351892166692779))), @as(f64, @bitCast(@as(i64, 4636619029643171306))), @as(f64, @bitCast(@as(i64, 4647326103781170269))), @as(f64, @bitCast(@as(i64, 4636714769838062227))), @as(f64, @bitCast(@as(i64, 4647300314516038458))), @as(f64, @bitCast(@as(i64, 4637576424555206096))), @as(f64, @bitCast(@as(i64, 4647068216759351687))), @as(f64, @bitCast(@as(i64, 4641741656779885736))), @as(f64, @bitCast(@as(i64, 4648490749598166417))), @as(f64, @bitCast(@as(i64, 4641789526877331196))), @as(f64, @bitCast(@as(i64, 4648477855053561442))), @as(f64, @bitCast(@as(i64, 4641837396271089215))), @as(f64, @bitCast(@as(i64, 4648464961212643908))), @as(f64, @bitCast(@as(i64, 4642268224685192312))), @as(f64, @bitCast(@as(i64, 4648348911718574011))), @as(f64, @bitCast(@as(i64, 4644539538455325468))), @as(f64, @bitCast(@as(i64, 4649448145037966789))), @as(f64, @bitCast(@as(i64, 4644563473855891919))), @as(f64, @bitCast(@as(i64, 4649435251197049255))), @as(f64, @bitCast(@as(i64, 4644587408200927208))), @as(f64, @bitCast(@as(i64, 4649422357004288000))), @as(f64, @bitCast(@as(i64, 4644802822232056896))), @as(f64, @bitCast(@as(i64, 4649306306982452522))), @as(f64, @bitCast(@as(i64, 4641741656779885736))), @as(f64, @bitCast(@as(i64, 4648490749598166417))), @as(f64, @bitCast(@as(i64, 4641806497003677082))), @as(f64, @bitCast(@as(i64, 4648497585569819557))), @as(f64, @bitCast(@as(i64, 4641871335116406102))), @as(f64, @bitCast(@as(i64, 4648504420485941533))), @as(f64, @bitCast(@as(i64, 4642454892556559843))), @as(f64, @bitCast(@as(i64, 4648565941240148158))), @as(f64, @bitCast(@as(i64, 4639007423633554701))), @as(f64, @bitCast(@as(i64, 4650111736281350065))), @as(f64, @bitCast(@as(i64, 4639072263153658605))), @as(f64, @bitCast(@as(i64, 4650118572165042274))), @as(f64, @bitCast(@as(i64, 4639137104432981114))), @as(f64, @bitCast(@as(i64, 4650125408488539134))), @as(f64, @bitCast(@as(i64, 4639720658706541366))), @as(f64, @bitCast(@as(i64, 4650186927747409946))), @as(f64, @bitCast(@as(i64, 4633473522149369263))), @as(f64, @bitCast(@as(i64, 4651732723844143016))), @as(f64, @bitCast(@as(i64, 4633732880651997344))), @as(f64, @bitCast(@as(i64, 4651739560167639876))), @as(f64, @bitCast(@as(i64, 4633992239013887937))), @as(f64, @bitCast(@as(i64, 4651746393852308829))), @as(f64, @bitCast(@as(i64, 4635265237743559550))), @as(f64, @bitCast(@as(i64, 4651807914958359175))), (-@as(f64, @bitCast(@as(i64, 4614747831841992326)))), @as(f64, @bitCast(@as(i64, 4652623964220167081))), (-@as(f64, @bitCast(@as(i64, 4609510274053129801)))), @as(f64, @bitCast(@as(i64, 4652627381942110860))), @as(f64, @bitCast(@as(i64, 4599544386430023040))), @as(f64, @bitCast(@as(i64, 4652630799224249988))), @as(f64, @bitCast(@as(i64, 4625453418061043151))), @as(f64, @bitCast(@as(i64, 4652661559601353300))), @as(f64, @bitCast(@as(i64, 4633429994718233239))), @as(f64, @bitCast(@as(i64, 4651744635073509038))), @as(f64, @bitCast(@as(i64, 4633711110251398635))), @as(f64, @bitCast(@as(i64, 4651745515562420562))), @as(f64, @bitCast(@as(i64, 4633992239013887937))), @as(f64, @bitCast(@as(i64, 4651746393852308829))), @as(f64, @bitCast(@as(i64, 4635363181183830673))), @as(f64, @bitCast(@as(i64, 4651754306817591607))), @as(f64, @bitCast(@as(i64, 4632374901108419575))), @as(f64, @bitCast(@as(i64, 4652640408076267448))), @as(f64, @bitCast(@as(i64, 4632656023819196878))), @as(f64, @bitCast(@as(i64, 4652640847441113907))), @as(f64, @bitCast(@as(i64, 4632937151174311296))), @as(f64, @bitCast(@as(i64, 4652641287245765018))), @as(f64, @bitCast(@as(i64, 4634835635504823749))), @as(f64, @bitCast(@as(i64, 4652645244608015709))), @as(f64, @bitCast(@as(i64, 4631319805387543587))), @as(f64, @bitCast(@as(i64, 4653299290419212216))), @as(f64, @bitCast(@as(i64, 4631600923876196239))), @as(f64, @bitCast(@as(i64, 4653299729344254024))), @as(f64, @bitCast(@as(i64, 4631882056297860238))), @as(f64, @bitCast(@as(i64, 4653300169148905134))), @as(f64, @bitCast(@as(i64, 4634308090529504266))), @as(f64, @bitCast(@as(i64, 4653304125631546524))), @as(f64, @bitCast(@as(i64, 4630194373573587233))), @as(f64, @bitCast(@as(i64, 4654002098691491286))), @as(f64, @bitCast(@as(i64, 4630475504728613837))), @as(f64, @bitCast(@as(i64, 4654002538496142397))), @as(f64, @bitCast(@as(i64, 4630756619417354303))), @as(f64, @bitCast(@as(i64, 4654002978300793507))), @as(f64, @bitCast(@as(i64, 4633286728599424631))), @as(f64, @bitCast(@as(i64, 4654006934343630245))), @as(f64, @bitCast(@as(i64, 4631344087248621997))), @as(f64, @bitCast(@as(i64, 4653305352686523122))), @as(f64, @bitCast(@as(i64, 4631613073743565954))), @as(f64, @bitCast(@as(i64, 4653302761357518779))), @as(f64, @bitCast(@as(i64, 4631882056297860238))), @as(f64, @bitCast(@as(i64, 4653300169148905134))), @as(f64, @bitCast(@as(i64, 4634253451662556356))), @as(f64, @bitCast(@as(i64, 4653276845868452099))), @as(f64, @bitCast(@as(i64, 4635883941556680267))), @as(f64, @bitCast(@as(i64, 4653935776589908489))), @as(f64, @bitCast(@as(i64, 4636018434522677269))), @as(f64, @bitCast(@as(i64, 4653933185260904147))), @as(f64, @bitCast(@as(i64, 4636152918622212505))), @as(f64, @bitCast(@as(i64, 4653930593931899804))), @as(f64, @bitCast(@as(i64, 4637363333220399852))), @as(f64, @bitCast(@as(i64, 4653907269771837466))), @as(f64, @bitCast(@as(i64, 4638850721236364066))), @as(f64, @bitCast(@as(i64, 4654566201372903159))), @as(f64, @bitCast(@as(i64, 4638917967015675125))), @as(f64, @bitCast(@as(i64, 4654563609604094165))), @as(f64, @bitCast(@as(i64, 4638985212794986184))), @as(f64, @bitCast(@as(i64, 4654561017835285171))), @as(f64, @bitCast(@as(i64, 4639590417068223858))), @as(f64, @bitCast(@as(i64, 4654537694115027485))), @as(f64, @bitCast(@as(i64, 4640509327665911604))), @as(f64, @bitCast(@as(i64, 4655238653888357938))), @as(f64, @bitCast(@as(i64, 4640576573445222663))), @as(f64, @bitCast(@as(i64, 4655236062119548944))), @as(f64, @bitCast(@as(i64, 4640643818169002560))), @as(f64, @bitCast(@as(i64, 4655233472109958555))), @as(f64, @bitCast(@as(i64, 4641249024201458838))), @as(f64, @bitCast(@as(i64, 4655210146630482264))), @as(f64, @bitCast(@as(i64, 4638850721236364066))), @as(f64, @bitCast(@as(i64, 4654566201372903159))), @as(f64, @bitCast(@as(i64, 4638893204254599005))), @as(f64, @bitCast(@as(i64, 4654573213618260463))), @as(f64, @bitCast(@as(i64, 4638935683402553014))), @as(f64, @bitCast(@as(i64, 4654580224984008465))), @as(f64, @bitCast(@as(i64, 4639318017900293516))), @as(f64, @bitCast(@as(i64, 4654643336951442807))), @as(f64, @bitCast(@as(i64, 4623218228930158529))), @as(f64, @bitCast(@as(i64, 4654964465595106879))), @as(f64, @bitCast(@as(i64, 4623897942022268815))), @as(f64, @bitCast(@as(i64, 4654971477840464183))), @as(f64, @bitCast(@as(i64, 4624577650610779474))), @as(f64, @bitCast(@as(i64, 4654978489206212185))), @as(f64, @bitCast(@as(i64, 4627945866876392011))), @as(f64, @bitCast(@as(i64, 4655041601613451179))), (-@as(f64, @bitCast(@as(i64, 4637236677221441916)))), @as(f64, @bitCast(@as(i64, 4655362728937701297))), (-@as(f64, @bitCast(@as(i64, 4637151709777597154)))), @as(f64, @bitCast(@as(i64, 4655369741183058602))), (-@as(f64, @bitCast(@as(i64, 4637066755000126344)))), @as(f64, @bitCast(@as(i64, 4655376753428415906))), (-@as(f64, @bitCast(@as(i64, 4636302083189895573)))), @as(f64, @bitCast(@as(i64, 4655439864956045597))), (-@as(f64, @bitCast(@as(i64, 4642460057270538763)))), @as(f64, @bitCast(@as(i64, 4655787544166692553))), (-@as(f64, @bitCast(@as(i64, 4642417574604147545)))), @as(f64, @bitCast(@as(i64, 4655794556412049857))), (-@as(f64, @bitCast(@as(i64, 4642375095808037256)))), @as(f64, @bitCast(@as(i64, 4655801568657407161))), (-@as(f64, @bitCast(@as(i64, 4641992763421359079)))), @as(f64, @bitCast(@as(i64, 4655864679305427550))), (-@as(f64, @bitCast(@as(i64, 4637236677221441916)))), @as(f64, @bitCast(@as(i64, 4655362728937701297))), (-@as(f64, @bitCast(@as(i64, 4637313049826872818)))), @as(f64, @bitCast(@as(i64, 4655370118095644603))), (-@as(f64, @bitCast(@as(i64, 4637389418210179070)))), @as(f64, @bitCast(@as(i64, 4655377505494369305))), (-@as(f64, @bitCast(@as(i64, 4638076764974026494)))), @as(f64, @bitCast(@as(i64, 4655443999999375337))), (-@as(f64, @bitCast(@as(i64, 4648586232947141090)))), @as(f64, @bitCast(@as(i64, 4653930746983918390))), (-@as(f64, @bitCast(@as(i64, 4648595779786702743)))), @as(f64, @bitCast(@as(i64, 4653938134822447743))), (-@as(f64, @bitCast(@as(i64, 4648605325746655094)))), @as(f64, @bitCast(@as(i64, 4653945523540586398))), (-@as(f64, @bitCast(@as(i64, 4648691245983296022)))), @as(f64, @bitCast(@as(i64, 4654012018045592430))), (-@as(f64, @bitCast(@as(i64, 4652618816746530485)))), @as(f64, @bitCast(@as(i64, 4652498764590330832))), (-@as(f64, @bitCast(@as(i64, 4652623590386213637)))), @as(f64, @bitCast(@as(i64, 4652506153748274138))), (-@as(f64, @bitCast(@as(i64, 4652628363146287487)))), @as(f64, @bitCast(@as(i64, 4652513541586803491))), (-@as(f64, @bitCast(@as(i64, 4652671323704412602)))), @as(f64, @bitCast(@as(i64, 4652580035652004872))), (-@as(f64, @bitCast(@as(i64, 4653209880772469378)))), @as(f64, @bitCast(@as(i64, 4652015390339614460))), (-@as(f64, @bitCast(@as(i64, 4653214654412152531)))), @as(f64, @bitCast(@as(i64, 4652030166632399676))), (-@as(f64, @bitCast(@as(i64, 4653219427612031032)))), @as(f64, @bitCast(@as(i64, 4652044942045575591))), (-@as(f64, @bitCast(@as(i64, 4653262387290546844)))), @as(f64, @bitCast(@as(i64, 4652177931055587656))), @as(f64, @bitCast(@as(i64, 4614840227016407515))), (-@as(f64, @bitCast(@as(i64, 4638143256752243689)))), @as(f64, @bitCast(@as(i64, 4617763908275041043))), (-@as(f64, @bitCast(@as(i64, 4638136223396263132)))), @as(f64, @bitCast(@as(i64, 4620012893789319147))), (-@as(f64, @bitCast(@as(i64, 4638129189336595133)))), @as(f64, @bitCast(@as(i64, 4627835154605277385))), (-@as(f64, @bitCast(@as(i64, 4638065883503270581)))), (-@as(f64, @bitCast(@as(i64, 4616297845858843591)))), @as(f64, @bitCast(@as(i64, 4629090337094823120))), (-@as(f64, @bitCast(@as(i64, 4611908102634372574)))), @as(f64, @bitCast(@as(i64, 4629118473052020141))), (-@as(f64, @bitCast(@as(i64, 4591951219207746913)))), @as(f64, @bitCast(@as(i64, 4629146608727742185))), @as(f64, @bitCast(@as(i64, 4625724971326299733))), @as(f64, @bitCast(@as(i64, 4629399830372190532))), (-@as(f64, @bitCast(@as(i64, 4622715896864771670)))), @as(f64, @bitCast(@as(i64, 4640524716958419538))), (-@as(f64, @bitCast(@as(i64, 4621591404332812599)))), @as(f64, @bitCast(@as(i64, 4640528233988253538))), (-@as(f64, @bitCast(@as(i64, 4620240605469218198)))), @as(f64, @bitCast(@as(i64, 4640531751018087538))), @as(f64, @bitCast(@as(i64, 4622032759911044675))), @as(f64, @bitCast(@as(i64, 4640563403231062372))), (-@as(f64, @bitCast(@as(i64, 4626207219026198379)))), @as(f64, @bitCast(@as(i64, 4644679198598207436))), (-@as(f64, @bitCast(@as(i64, 4625644973041693820)))), @as(f64, @bitCast(@as(i64, 4644680956761280715))), (-@as(f64, @bitCast(@as(i64, 4624968635116029271)))), @as(f64, @bitCast(@as(i64, 4644682715628041436))), @as(f64, @bitCast(@as(i64, 4612548091388199667))), @as(f64, @bitCast(@as(i64, 4644698541910450713))), (-@as(f64, @bitCast(@as(i64, 4622668393458852119)))), @as(f64, @bitCast(@as(i64, 4640561336501045874))), (-@as(f64, @bitCast(@as(i64, 4621567652629852824)))), @as(f64, @bitCast(@as(i64, 4640546543583644845))), (-@as(f64, @bitCast(@as(i64, 4620240605469218198)))), @as(f64, @bitCast(@as(i64, 4640531751018087538))), @as(f64, @bitCast(@as(i64, 4621818992614081860))), @as(f64, @bitCast(@as(i64, 4640398614057790839))), @as(f64, @bitCast(@as(i64, 4629288131249807559))), @as(f64, @bitCast(@as(i64, 4645326091602480144))), @as(f64, @bitCast(@as(i64, 4629769459089482315))), @as(f64, @bitCast(@as(i64, 4645318694616014048))), @as(f64, @bitCast(@as(i64, 4630044644648575859))), @as(f64, @bitCast(@as(i64, 4645311298861000976))), @as(f64, @bitCast(@as(i64, 4632521312287880460))), @as(f64, @bitCast(@as(i64, 4645244730380852627))), @as(f64, @bitCast(@as(i64, 4634807720927695911))), @as(f64, @bitCast(@as(i64, 4648240360893805547))), @as(f64, @bitCast(@as(i64, 4634945313988717660))), @as(f64, @bitCast(@as(i64, 4648236662576494359))), @as(f64, @bitCast(@as(i64, 4635082905290520805))), @as(f64, @bitCast(@as(i64, 4648232964611026893))), @as(f64, @bitCast(@as(i64, 4636321239673123058))), @as(f64, @bitCast(@as(i64, 4648199680195030858))), @as(f64, @bitCast(@as(i64, 4637174579619454895))), @as(f64, @bitCast(@as(i64, 4649616287105976526))), @as(f64, @bitCast(@as(i64, 4637312172750845388))), @as(f64, @bitCast(@as(i64, 4649612588612743479))), @as(f64, @bitCast(@as(i64, 4637449765741498393))), @as(f64, @bitCast(@as(i64, 4649608890471354152))), @as(f64, @bitCast(@as(i64, 4638688098716725763))), @as(f64, @bitCast(@as(i64, 4649575606055358117))), @as(f64, @bitCast(@as(i64, 4634807720927695911))), @as(f64, @bitCast(@as(i64, 4648240360893805547))), @as(f64, @bitCast(@as(i64, 4634918827193409187))), @as(f64, @bitCast(@as(i64, 4648251158977599609))), @as(f64, @bitCast(@as(i64, 4635029935218341068))), @as(f64, @bitCast(@as(i64, 4648261957061393672))), @as(f64, @bitCast(@as(i64, 4636029896183728927))), @as(f64, @bitCast(@as(i64, 4648359139815540235))), (-@as(f64, @bitCast(@as(i64, 4626179409298499366)))), @as(f64, @bitCast(@as(i64, 4649281987192621000))), (-@as(f64, @bitCast(@as(i64, 4625734983391221331)))), @as(f64, @bitCast(@as(i64, 4649292785276415063))), (-@as(f64, @bitCast(@as(i64, 4625290552417393714)))), @as(f64, @bitCast(@as(i64, 4649303583360209125))), (-@as(f64, @bitCast(@as(i64, 4611962339484684997)))), @as(f64, @bitCast(@as(i64, 4649400766114355688))), (-@as(f64, @bitCast(@as(i64, 4637550815258137518)))), @as(f64, @bitCast(@as(i64, 4650323613491436454))), (-@as(f64, @bitCast(@as(i64, 4637439709625742940)))), @as(f64, @bitCast(@as(i64, 4650334412102996098))), (-@as(f64, @bitCast(@as(i64, 4637328602023023524)))), @as(f64, @bitCast(@as(i64, 4650345209659024579))), (-@as(f64, @bitCast(@as(i64, 4636328641057635665)))), @as(f64, @bitCast(@as(i64, 4650442392940936723))), (-@as(f64, @bitCast(@as(i64, 4641584604298192817)))), @as(f64, @bitCast(@as(i64, 4651434682305834333))), (-@as(f64, @bitCast(@as(i64, 4641529051693101760)))), @as(f64, @bitCast(@as(i64, 4651445479861862814))), (-@as(f64, @bitCast(@as(i64, 4641473497680635819)))), @as(f64, @bitCast(@as(i64, 4651456277593813156))), (-@as(f64, @bitCast(@as(i64, 4640973517549785611)))), @as(f64, @bitCast(@as(i64, 4651553460699803440))), (-@as(f64, @bitCast(@as(i64, 4637603787441379580)))), @as(f64, @bitCast(@as(i64, 4650352606293646954))), (-@as(f64, @bitCast(@as(i64, 4637466195084045273)))), @as(f64, @bitCast(@as(i64, 4650348908416140417))), (-@as(f64, @bitCast(@as(i64, 4637328602023023524)))), @as(f64, @bitCast(@as(i64, 4650345209659024579))), (-@as(f64, @bitCast(@as(i64, 4636090269751483595)))), @as(f64, @bitCast(@as(i64, 4650311926122637846))), (-@as(f64, @bitCast(@as(i64, 4635384857149574696)))), @as(f64, @bitCast(@as(i64, 4651642536182972364))), (-@as(f64, @bitCast(@as(i64, 4635247264862609133)))), @as(f64, @bitCast(@as(i64, 4651638838745270478))), (-@as(f64, @bitCast(@as(i64, 4635109672857118546)))), @as(f64, @bitCast(@as(i64, 4651635140252037431))), (-@as(f64, @bitCast(@as(i64, 4633538661229217131)))), @as(f64, @bitCast(@as(i64, 4651601856451767907))), (-@as(f64, @bitCast(@as(i64, 4632127832647699612)))), @as(f64, @bitCast(@as(i64, 4652575441012814722))), (-@as(f64, @bitCast(@as(i64, 4631852649762618346)))), @as(f64, @bitCast(@as(i64, 4652573592513866105))), (-@as(f64, @bitCast(@as(i64, 4631577466877537080)))), @as(f64, @bitCast(@as(i64, 4652571743575112837))), (-@as(f64, @bitCast(@as(i64, 4628501170280596001)))), @as(f64, @bitCast(@as(i64, 4652555101367114819))), (-@as(f64, @bitCast(@as(i64, 4624978783414839597)))), @as(f64, @bitCast(@as(i64, 4653263404118900212))), (-@as(f64, @bitCast(@as(i64, 4623878049622714720)))), @as(f64, @bitCast(@as(i64, 4653261555180146944))), (-@as(f64, @bitCast(@as(i64, 4622777331030238584)))), @as(f64, @bitCast(@as(i64, 4653259706241393675))), @as(f64, @bitCast(@as(i64, 4618323954982962571))), @as(f64, @bitCast(@as(i64, 4653243063593591007))), (-@as(f64, @bitCast(@as(i64, 4632127832647699612)))), @as(f64, @bitCast(@as(i64, 4652575441012814722))), (-@as(f64, @bitCast(@as(i64, 4631905619553323105)))), @as(f64, @bitCast(@as(i64, 4652580840934321055))), (-@as(f64, @bitCast(@as(i64, 4631683403925671809)))), @as(f64, @bitCast(@as(i64, 4652586238656804133))), (-@as(f64, @bitCast(@as(i64, 4629666550993571969)))), @as(f64, @bitCast(@as(i64, 4652634830473682066))), (-@as(f64, @bitCast(@as(i64, 4639176197085121573)))), @as(f64, @bitCast(@as(i64, 4653096254162222449))), (-@as(f64, @bitCast(@as(i64, 4639120643424499354)))), @as(f64, @bitCast(@as(i64, 4653101653643924131))), (-@as(f64, @bitCast(@as(i64, 4639065090115720855)))), @as(f64, @bitCast(@as(i64, 4653107053125625813))), (-@as(f64, @bitCast(@as(i64, 4638422604481817855)))), @as(f64, @bitCast(@as(i64, 4653155644062894444))), (-@as(f64, @bitCast(@as(i64, 4642415623630715219)))), @as(f64, @bitCast(@as(i64, 4653617067751434827))), (-@as(f64, @bitCast(@as(i64, 4642360070321936720)))), @as(f64, @bitCast(@as(i64, 4653622466793331858))), (-@as(f64, @bitCast(@as(i64, 4642304517013158222)))), @as(f64, @bitCast(@as(i64, 4653627865835228889))), (-@as(f64, @bitCast(@as(i64, 4641804536882308013)))), @as(f64, @bitCast(@as(i64, 4653676457652106822))), (-@as(f64, @bitCast(@as(i64, 4644541112252289002)))), @as(f64, @bitCast(@as(i64, 4654172602158633766))), (-@as(f64, @bitCast(@as(i64, 4644513336653430915)))), @as(f64, @bitCast(@as(i64, 4654178001200530797))), (-@as(f64, @bitCast(@as(i64, 4644485559471276084)))), @as(f64, @bitCast(@as(i64, 4654183399802623178))), (-@as(f64, @bitCast(@as(i64, 4644235568702163538)))), @as(f64, @bitCast(@as(i64, 4654231990739891808))), (-@as(f64, @bitCast(@as(i64, 4642442106907586483)))), @as(f64, @bitCast(@as(i64, 4653631563272930774))), (-@as(f64, @bitCast(@as(i64, 4642373310552997469)))), @as(f64, @bitCast(@as(i64, 4653629715213786808))), (-@as(f64, @bitCast(@as(i64, 4642304517013158222)))), @as(f64, @bitCast(@as(i64, 4653627865835228889))), (-@as(f64, @bitCast(@as(i64, 4641685351229231978)))), @as(f64, @bitCast(@as(i64, 4653611223627230872))), (-@as(f64, @bitCast(@as(i64, 4641332640213571669)))), @as(f64, @bitCast(@as(i64, 4654276528877300456))), (-@as(f64, @bitCast(@as(i64, 4641263843858982654)))), @as(f64, @bitCast(@as(i64, 4654274679938547188))), (-@as(f64, @bitCast(@as(i64, 4641195048559924803)))), @as(f64, @bitCast(@as(i64, 4654272830999793920))), (-@as(f64, @bitCast(@as(i64, 4640575881720467397)))), @as(f64, @bitCast(@as(i64, 4654256189231600553))), (-@as(f64, @bitCast(@as(i64, 4640223173871400575)))), @as(f64, @bitCast(@as(i64, 4654921494481670137))), (-@as(f64, @bitCast(@as(i64, 4640154379276030166)))), @as(f64, @bitCast(@as(i64, 4654919645982721520))), (-@as(f64, @bitCast(@as(i64, 4640085583273284872)))), @as(f64, @bitCast(@as(i64, 4654917796604163601))), (-@as(f64, @bitCast(@as(i64, 4639466414674608862)))), @as(f64, @bitCast(@as(i64, 4654901155275774886))), (-@as(f64, @bitCast(@as(i64, 4639039746108817827)))), @as(f64, @bitCast(@as(i64, 4655609457587755627))), (-@as(f64, @bitCast(@as(i64, 4638970949754228813)))), @as(f64, @bitCast(@as(i64, 4655607609088807010))), (-@as(f64, @bitCast(@as(i64, 4638902155510702125)))), @as(f64, @bitCast(@as(i64, 4655605759710249091))), (-@as(f64, @bitCast(@as(i64, 4637858357632441348)))), @as(f64, @bitCast(@as(i64, 4655589117502251074))), (-@as(f64, @bitCast(@as(i64, 4640223173871400575)))), @as(f64, @bitCast(@as(i64, 4654921494481670137))), (-@as(f64, @bitCast(@as(i64, 4640167621618153239)))), @as(f64, @bitCast(@as(i64, 4654926893963371820))), (-@as(f64, @bitCast(@as(i64, 4640112066901999857)))), @as(f64, @bitCast(@as(i64, 4654932292565464200))), (-@as(f64, @bitCast(@as(i64, 4639612089585899416)))), @as(f64, @bitCast(@as(i64, 4654980883942537481))), (-@as(f64, @bitCast(@as(i64, 4643336909173518961)))), @as(f64, @bitCast(@as(i64, 4655442307631077864))), (-@as(f64, @bitCast(@as(i64, 4643309133926504595)))), @as(f64, @bitCast(@as(i64, 4655447707112779547))), (-@as(f64, @bitCast(@as(i64, 4643281355864740463)))), @as(f64, @bitCast(@as(i64, 4655453106154676578))), (-@as(f64, @bitCast(@as(i64, 4642851517187024224)))), @as(f64, @bitCast(@as(i64, 4655501698851163813))), (-@as(f64, @bitCast(@as(i64, 4644956622798159505)))), @as(f64, @bitCast(@as(i64, 4655963121220290242))), (-@as(f64, @bitCast(@as(i64, 4644928845791926535)))), @as(f64, @bitCast(@as(i64, 4655968520262187273))), (-@as(f64, @bitCast(@as(i64, 4644901067026474960)))), @as(f64, @bitCast(@as(i64, 4655973918424475002))), (-@as(f64, @bitCast(@as(i64, 4644651078896190321)))), @as(f64, @bitCast(@as(i64, 4656022511120962237))), (-@as(f64, @bitCast(@as(i64, 4646684314797834628)))), @as(f64, @bitCast(@as(i64, 4656518655187684531))), (-@as(f64, @bitCast(@as(i64, 4646656539198976541)))), @as(f64, @bitCast(@as(i64, 4656524054229581562))), (-@as(f64, @bitCast(@as(i64, 4646628761840899850)))), @as(f64, @bitCast(@as(i64, 4656529453711283244))), (-@as(f64, @bitCast(@as(i64, 4646378771599552886)))), @as(f64, @bitCast(@as(i64, 4656578045967965828))), @as(f64, @bitCast(@as(i64, 4614840227016407515))), (-@as(f64, @bitCast(@as(i64, 4638143256752243689)))), @as(f64, @bitCast(@as(i64, 4617763908275041043))), (-@as(f64, @bitCast(@as(i64, 4638136223396263132)))), @as(f64, @bitCast(@as(i64, 4620012893789319147))), (-@as(f64, @bitCast(@as(i64, 4638129189336595133)))), @as(f64, @bitCast(@as(i64, 4627835154605277385))), (-@as(f64, @bitCast(@as(i64, 4638065883503270581)))), (-@as(f64, @bitCast(@as(i64, 4616297845858843591)))), @as(f64, @bitCast(@as(i64, 4629090337094823120))), (-@as(f64, @bitCast(@as(i64, 4611908102634372574)))), @as(f64, @bitCast(@as(i64, 4629118473052020141))), (-@as(f64, @bitCast(@as(i64, 4591951219207746913)))), @as(f64, @bitCast(@as(i64, 4629146608727742185))), @as(f64, @bitCast(@as(i64, 4625724971326299733))), @as(f64, @bitCast(@as(i64, 4629399830372190532))), (-@as(f64, @bitCast(@as(i64, 4622715896864771670)))), @as(f64, @bitCast(@as(i64, 4640524716958419538))), (-@as(f64, @bitCast(@as(i64, 4621591404332812599)))), @as(f64, @bitCast(@as(i64, 4640528233988253538))), (-@as(f64, @bitCast(@as(i64, 4620240605469218198)))), @as(f64, @bitCast(@as(i64, 4640531751018087538))), @as(f64, @bitCast(@as(i64, 4622032759911044675))), @as(f64, @bitCast(@as(i64, 4640563403231062372))), (-@as(f64, @bitCast(@as(i64, 4626207219026198379)))), @as(f64, @bitCast(@as(i64, 4644679198598207436))), (-@as(f64, @bitCast(@as(i64, 4625644973041693820)))), @as(f64, @bitCast(@as(i64, 4644680956761280715))), (-@as(f64, @bitCast(@as(i64, 4624968635116029271)))), @as(f64, @bitCast(@as(i64, 4644682715628041436))), @as(f64, @bitCast(@as(i64, 4612548091388199667))), @as(f64, @bitCast(@as(i64, 4644698541910450713))), (-@as(f64, @bitCast(@as(i64, 4621998744786009099)))), @as(f64, @bitCast(@as(i64, 4640634905967552459))), (-@as(f64, @bitCast(@as(i64, 4621232828293431314)))), @as(f64, @bitCast(@as(i64, 4640583327789132557))), (-@as(f64, @bitCast(@as(i64, 4620240605469218198)))), @as(f64, @bitCast(@as(i64, 4640531751018087538))), @as(f64, @bitCast(@as(i64, 4616917927463827809))), @as(f64, @bitCast(@as(i64, 4640067553041807950))), @as(f64, @bitCast(@as(i64, 4636710908986544175))), @as(f64, @bitCast(@as(i64, 4643718178112550753))), @as(f64, @bitCast(@as(i64, 4636806648196272677))), @as(f64, @bitCast(@as(i64, 4643692389023340802))), @as(f64, @bitCast(@as(i64, 4636902387687476156))), @as(f64, @bitCast(@as(i64, 4643666600110052711))), @as(f64, @bitCast(@as(i64, 4637764044093469885))), @as(f64, @bitCast(@as(i64, 4643434501121912917))), @as(f64, @bitCast(@as(i64, 4641577578682774119))), @as(f64, @bitCast(@as(i64, 4645513294100381565))), @as(f64, @bitCast(@as(i64, 4641625447724688416))), @as(f64, @bitCast(@as(i64, 4645487506066702776))), @as(f64, @bitCast(@as(i64, 4641673317822133877))), @as(f64, @bitCast(@as(i64, 4645461717329336546))), @as(f64, @bitCast(@as(i64, 4642104145532549532))), @as(f64, @bitCast(@as(i64, 4645229618341196752))), @as(f64, @bitCast(@as(i64, 4644457499934535241))), @as(f64, @bitCast(@as(i64, 4647428086035513470))), @as(f64, @bitCast(@as(i64, 4644481434631414250))), @as(f64, @bitCast(@as(i64, 4647402298001834681))), @as(f64, @bitCast(@as(i64, 4644505369152371399))), @as(f64, @bitCast(@as(i64, 4647376508384859149))), @as(f64, @bitCast(@as(i64, 4644720783007579227))), @as(f64, @bitCast(@as(i64, 4647144410452250518))), @as(f64, @bitCast(@as(i64, 4641577578682774119))), @as(f64, @bitCast(@as(i64, 4645513294100381565))), @as(f64, @bitCast(@as(i64, 4641647859466021561))), @as(f64, @bitCast(@as(i64, 4645515052967142286))), @as(f64, @bitCast(@as(i64, 4641718140601112723))), @as(f64, @bitCast(@as(i64, 4645516811130215565))), @as(f64, @bitCast(@as(i64, 4642350667650339701))), @as(f64, @bitCast(@as(i64, 4645532637588546703))), @as(f64, @bitCast(@as(i64, 4641313806019192517))), @as(f64, @bitCast(@as(i64, 4647931820778670208))), @as(f64, @bitCast(@as(i64, 4641384086802439959))), @as(f64, @bitCast(@as(i64, 4647932699684284987))), @as(f64, @bitCast(@as(i64, 4641454366881999959))), @as(f64, @bitCast(@as(i64, 4647933578677860696))), @as(f64, @bitCast(@as(i64, 4642086894283070657))), @as(f64, @bitCast(@as(i64, 4647941492522752777))), @as(f64, @bitCast(@as(i64, 4641050034059298357))), @as(f64, @bitCast(@as(i64, 4649249585904364395))), @as(f64, @bitCast(@as(i64, 4641120314138858357))), @as(f64, @bitCast(@as(i64, 4649250464634057313))), @as(f64, @bitCast(@as(i64, 4641190594218418357))), @as(f64, @bitCast(@as(i64, 4649251343715593953))), @as(f64, @bitCast(@as(i64, 4641823122675020218))), @as(f64, @bitCast(@as(i64, 4649259257736407894))), @as(f64, @bitCast(@as(i64, 4640768675542859315))), @as(f64, @bitCast(@as(i64, 4650655201041547652))), @as(f64, @bitCast(@as(i64, 4640838955622419315))), @as(f64, @bitCast(@as(i64, 4650656079419396850))), @as(f64, @bitCast(@as(i64, 4640909235701979315))), @as(f64, @bitCast(@as(i64, 4650656959292581861))), @as(f64, @bitCast(@as(i64, 4641541764158581176))), @as(f64, @bitCast(@as(i64, 4650664872873591151))), (-@as(f64, @bitCast(@as(i64, 4639221799549785908)))), (-@as(f64, @bitCast(@as(i64, 4646770556619636448)))), (-@as(f64, @bitCast(@as(i64, 4639154573825566940)))), (-@as(f64, @bitCast(@as(i64, 4646780954305276139)))), (-@as(f64, @bitCast(@as(i64, 4639087347749504250)))), (-@as(f64, @bitCast(@as(i64, 4646791352342759552)))), (-@as(f64, @bitCast(@as(i64, 4638257014512237580)))), (-@as(f64, @bitCast(@as(i64, 4646884931161673056)))), (-@as(f64, @bitCast(@as(i64, 4634537136569677911)))), (-@as(f64, @bitCast(@as(i64, 4641926668874702767)))), (-@as(f64, @bitCast(@as(i64, 4634402685121239974)))), (-@as(f64, @bitCast(@as(i64, 4641947464597825871)))), (-@as(f64, @bitCast(@as(i64, 4634268233320958316)))), (-@as(f64, @bitCast(@as(i64, 4641968259969105254)))), (-@as(f64, @bitCast(@as(i64, 4631912319783668726)))), (-@as(f64, @bitCast(@as(i64, 4642155418310619704)))), @as(f64, @bitCast(@as(i64, 4617480051344487471))), @as(f64, @bitCast(@as(i64, 4626137828970514738))), @as(f64, @bitCast(@as(i64, 4619631277897194188))), @as(f64, @bitCast(@as(i64, 4625971466281754649))), @as(f64, @bitCast(@as(i64, 4621237861628964854))), @as(f64, @bitCast(@as(i64, 4625805102748569629))), @as(f64, @bitCast(@as(i64, 4628057599494297213))), @as(f64, @bitCast(@as(i64, 4623418853034558816))), @as(f64, @bitCast(@as(i64, 4632575594737139110))), @as(f64, @bitCast(@as(i64, 4640262659532977267))), @as(f64, @bitCast(@as(i64, 4632844498337702426))), @as(f64, @bitCast(@as(i64, 4640241863809854163))), @as(f64, @bitCast(@as(i64, 4633113401375315789))), @as(f64, @bitCast(@as(i64, 4640221068790418500))), @as(f64, @bitCast(@as(i64, 4634868774609363057))), @as(f64, @bitCast(@as(i64, 4640033910097060330))), @as(f64, @bitCast(@as(i64, 4620036473173298180))), @as(f64, @bitCast(@as(i64, 4626842942927473348))), @as(f64, @bitCast(@as(i64, 4620801350235081968))), @as(f64, @bitCast(@as(i64, 4626324019038109303))), @as(f64, @bitCast(@as(i64, 4621237861628964854))), @as(f64, @bitCast(@as(i64, 4625805102748569629))), @as(f64, @bitCast(@as(i64, 4625166433774613337))), @as(f64, @bitCast(@as(i64, 4609744570671224012))), @as(f64, @bitCast(@as(i64, 4639654167983855334))), @as(f64, @bitCast(@as(i64, 4635602928198931416))), @as(f64, @bitCast(@as(i64, 4639681449594129293))), @as(f64, @bitCast(@as(i64, 4635473197789540359))), @as(f64, @bitCast(@as(i64, 4639708730500715811))), @as(f64, @bitCast(@as(i64, 4635343465972774417))), @as(f64, @bitCast(@as(i64, 4639954267104243771))), @as(f64, @bitCast(@as(i64, 4634147782086018246))), @as(f64, @bitCast(@as(i64, 4644027291293146489))), @as(f64, @bitCast(@as(i64, 4639337811220655809))), @as(f64, @bitCast(@as(i64, 4644040931570517887))), @as(f64, @bitCast(@as(i64, 4639272945664116560))), @as(f64, @bitCast(@as(i64, 4644054572903420448))), @as(f64, @bitCast(@as(i64, 4639208079755733589))), @as(f64, @bitCast(@as(i64, 4644177341381106289))), @as(f64, @bitCast(@as(i64, 4638540976672211196))), @as(f64, @bitCast(@as(i64, 4646621891212640204))), @as(f64, @bitCast(@as(i64, 4641520349542353029))), @as(f64, @bitCast(@as(i64, 4646635532545542765))), @as(f64, @bitCast(@as(i64, 4641455485745032384))), @as(f64, @bitCast(@as(i64, 4646649172822914163))), @as(f64, @bitCast(@as(i64, 4641390621595868017))), @as(f64, @bitCast(@as(i64, 4646771940772834422))), @as(f64, @bitCast(@as(i64, 4640806835105451978))), @as(f64, @bitCast(@as(i64, 4644027291293146489))), @as(f64, @bitCast(@as(i64, 4639337811220655809))), @as(f64, @bitCast(@as(i64, 4644062433795832535))), @as(f64, @bitCast(@as(i64, 4639341263863088887))), @as(f64, @bitCast(@as(i64, 4644097574715221837))), @as(f64, @bitCast(@as(i64, 4639344712987084755))), @as(f64, @bitCast(@as(i64, 4644413853896880905))), @as(f64, @bitCast(@as(i64, 4639375774454452217))), @as(f64, @bitCast(@as(i64, 4643854724262580999))), @as(f64, @bitCast(@as(i64, 4644788715409911600))), @as(f64, @bitCast(@as(i64, 4643889866765267045))), @as(f64, @bitCast(@as(i64, 4644790442082971859))), @as(f64, @bitCast(@as(i64, 4643925009971640533))), @as(f64, @bitCast(@as(i64, 4644792168052344677))), @as(f64, @bitCast(@as(i64, 4644241287570002857))), @as(f64, @bitCast(@as(i64, 4644807697906419106))), @as(f64, @bitCast(@as(i64, 4643682159518999695))), @as(f64, @bitCast(@as(i64, 4648008867956474983))), @as(f64, @bitCast(@as(i64, 4643717302021685741))), @as(f64, @bitCast(@as(i64, 4648009730853200462))), @as(f64, @bitCast(@as(i64, 4643752442941075043))), @as(f64, @bitCast(@as(i64, 4648010591990707336))), @as(f64, @bitCast(@as(i64, 4644068721594968530))), @as(f64, @bitCast(@as(i64, 4648018358501041295))), @as(f64, @bitCast(@as(i64, 4643544106950078465))), @as(f64, @bitCast(@as(i64, 4649414548712512186))), @as(f64, @bitCast(@as(i64, 4643579248397233349))), @as(f64, @bitCast(@as(i64, 4649415410729628362))), @as(f64, @bitCast(@as(i64, 4643614390899919395))), @as(f64, @bitCast(@as(i64, 4649416273186549190))), @as(f64, @bitCast(@as(i64, 4643930669026047301))), @as(f64, @bitCast(@as(i64, 4649424040136687800))), @as(f64, @bitCast(@as(i64, 4643685217568699795))), @as(f64, @bitCast(@as(i64, 4648020989852268888))), @as(f64, @bitCast(@as(i64, 4643718829903043698))), @as(f64, @bitCast(@as(i64, 4648015791713136484))), @as(f64, @bitCast(@as(i64, 4643752442941075043))), @as(f64, @bitCast(@as(i64, 4648010591990707336))), @as(f64, @bitCast(@as(i64, 4644054958875982262))), @as(f64, @bitCast(@as(i64, 4647963802933094305))), @as(f64, @bitCast(@as(i64, 4644465043991676668))), @as(f64, @bitCast(@as(i64, 4649281474028554085))), @as(f64, @bitCast(@as(i64, 4644498657029708013))), @as(f64, @bitCast(@as(i64, 4649276275537577960))), @as(f64, @bitCast(@as(i64, 4644532271123270520))), @as(f64, @bitCast(@as(i64, 4649271076958640905))), @as(f64, @bitCast(@as(i64, 4644834787585943321))), @as(f64, @bitCast(@as(i64, 4649224288692676246))), @as(f64, @bitCast(@as(i64, 4645244870414653540))), @as(f64, @bitCast(@as(i64, 4650541958380761142))), @as(f64, @bitCast(@as(i64, 4645278482924919304))), @as(f64, @bitCast(@as(i64, 4650536759801824087))), @as(f64, @bitCast(@as(i64, 4645312096842559951))), @as(f64, @bitCast(@as(i64, 4650531560783082380))), @as(f64, @bitCast(@as(i64, 4645614612777467170))), @as(f64, @bitCast(@as(i64, 4650484771373625628))), @as(f64, @bitCast(@as(i64, 4646076686497281894))), @as(f64, @bitCast(@as(i64, 4651886476031734002))), @as(f64, @bitCast(@as(i64, 4646110300414922541))), @as(f64, @bitCast(@as(i64, 4651881277540757878))), @as(f64, @bitCast(@as(i64, 4646143913452953886))), @as(f64, @bitCast(@as(i64, 4651876079313664543))), @as(f64, @bitCast(@as(i64, 4646446428332329942))), @as(f64, @bitCast(@as(i64, 4651829289112559419))), @as(f64, @bitCast(@as(i64, 4645256037406588954))), @as(f64, @bitCast(@as(i64, 4650552828240674265))), @as(f64, @bitCast(@as(i64, 4645284067388457243))), @as(f64, @bitCast(@as(i64, 4650542194643819718))), @as(f64, @bitCast(@as(i64, 4645312096842559951))), @as(f64, @bitCast(@as(i64, 4650531560783082380))), @as(f64, @bitCast(@as(i64, 4645564364568312225))), @as(f64, @bitCast(@as(i64, 4650435860434492850))), @as(f64, @bitCast(@as(i64, 4646851057759288253))), @as(f64, @bitCast(@as(i64, 4651603937343494171))), @as(f64, @bitCast(@as(i64, 4646879088093000263))), @as(f64, @bitCast(@as(i64, 4651593303482756833))), @as(f64, @bitCast(@as(i64, 4646907116843415529))), @as(f64, @bitCast(@as(i64, 4651582671909003681))), @as(f64, @bitCast(@as(i64, 4647159382282183618))), @as(f64, @bitCast(@as(i64, 4651486969801195546))), @as(f64, @bitCast(@as(i64, 4648080447043052503))), @as(f64, @bitCast(@as(i64, 4652436731903510315))), @as(f64, @bitCast(@as(i64, 4648094461594181996))), @as(f64, @bitCast(@as(i64, 4652431414665278390))), @as(f64, @bitCast(@as(i64, 4648108476673077071))), @as(f64, @bitCast(@as(i64, 4652426098306655768))), @as(f64, @bitCast(@as(i64, 4648234609128578325))), @as(f64, @bitCast(@as(i64, 4652378247560614956))), @as(f64, @bitCast(@as(i64, 4648931123884260936))), @as(f64, @bitCast(@as(i64, 4652997322744783071))), @as(f64, @bitCast(@as(i64, 4648945139051116940))), @as(f64, @bitCast(@as(i64, 4652992006825965099))), @as(f64, @bitCast(@as(i64, 4648959154481855736))), @as(f64, @bitCast(@as(i64, 4652986690907147128))), @as(f64, @bitCast(@as(i64, 4649085286321630478))), @as(f64, @bitCast(@as(i64, 4652938839281497014))), @as(f64, @bitCast(@as(i64, 4648080447043052503))), @as(f64, @bitCast(@as(i64, 4652436731903510315))), @as(f64, @bitCast(@as(i64, 4648095232395813532))), @as(f64, @bitCast(@as(i64, 4652441497626709747))), @as(f64, @bitCast(@as(i64, 4648110016868965260))), @as(f64, @bitCast(@as(i64, 4652446263789713831))), @as(f64, @bitCast(@as(i64, 4648243087682642431))), @as(f64, @bitCast(@as(i64, 4652489161895578488))), @as(f64, @bitCast(@as(i64, 4647016167638111376))), @as(f64, @bitCast(@as(i64, 4652991189229118685))), @as(f64, @bitCast(@as(i64, 4647045738519555295))), @as(f64, @bitCast(@as(i64, 4652995955392122769))), @as(f64, @bitCast(@as(i64, 4647075308697311773))), @as(f64, @bitCast(@as(i64, 4653000721555126852))), @as(f64, @bitCast(@as(i64, 4647341448037681930))), @as(f64, @bitCast(@as(i64, 4653043620100796160))), @as(f64, @bitCast(@as(i64, 4645586254173563571))), @as(f64, @bitCast(@as(i64, 4653545646554727055))), @as(f64, @bitCast(@as(i64, 4645615827341991676))), @as(f64, @bitCast(@as(i64, 4653550412717731139))), @as(f64, @bitCast(@as(i64, 4645645396112373270))), @as(f64, @bitCast(@as(i64, 4653555179760344524))), @as(f64, @bitCast(@as(i64, 4645911537211962032))), @as(f64, @bitCast(@as(i64, 4653598076546795228))), @as(f64, @bitCast(@as(i64, 4644061017448934099))), @as(f64, @bitCast(@as(i64, 4654137068141847301))), @as(f64, @bitCast(@as(i64, 4644090588858143599))), @as(f64, @bitCast(@as(i64, 4654141834744656036))), @as(f64, @bitCast(@as(i64, 4644120159211821937))), @as(f64, @bitCast(@as(i64, 4654146601347464770))), @as(f64, @bitCast(@as(i64, 4644386296792973490))), @as(f64, @bitCast(@as(i64, 4654189498133915474))), @as(f64, @bitCast(@as(i64, 4645586254173563571))), @as(f64, @bitCast(@as(i64, 4653545646554727055))), @as(f64, @bitCast(@as(i64, 4645578453798271477))), @as(f64, @bitCast(@as(i64, 4653554224064837661))), @as(f64, @bitCast(@as(i64, 4645570652367448221))), @as(f64, @bitCast(@as(i64, 4653562800695338965))), @as(f64, @bitCast(@as(i64, 4645500436675289143))), @as(f64, @bitCast(@as(i64, 4653639994328092561))), (-@as(f64, @bitCast(@as(i64, 4641031825794898665)))), @as(f64, @bitCast(@as(i64, 4652960512414899084))), (-@as(f64, @bitCast(@as(i64, 4641047430767607504)))), @as(f64, @bitCast(@as(i64, 4652969089045400388))), (-@as(f64, @bitCast(@as(i64, 4641063032221879134)))), @as(f64, @bitCast(@as(i64, 4652977666555510994))), (-@as(f64, @bitCast(@as(i64, 4641203470994915428)))), @as(f64, @bitCast(@as(i64, 4653054859748459938))), (-@as(f64, @bitCast(@as(i64, 4650064441008583606)))), @as(f64, @bitCast(@as(i64, 4652375377395461810))), (-@as(f64, @bitCast(@as(i64, 4650068342955448258)))), @as(f64, @bitCast(@as(i64, 4652383955345377067))), (-@as(f64, @bitCast(@as(i64, 4650072243494938026)))), @as(f64, @bitCast(@as(i64, 4652392531975878371))), (-@as(f64, @bitCast(@as(i64, 4650107353628001750)))), @as(f64, @bitCast(@as(i64, 4652469726048436617))), (-@as(f64, @bitCast(@as(i64, 4651436779294410827)))), @as(f64, @bitCast(@as(i64, 4652219341742122258))), (-@as(f64, @bitCast(@as(i64, 4651440682120884781)))), @as(f64, @bitCast(@as(i64, 4652227918372623562))), (-@as(f64, @bitCast(@as(i64, 4651444582748335479)))), @as(f64, @bitCast(@as(i64, 4652236494563320214))), (-@as(f64, @bitCast(@as(i64, 4651479691913828971)))), @as(f64, @bitCast(@as(i64, 4652313689075683112))), (-@as(f64, @bitCast(@as(i64, 4639221799549785908)))), (-@as(f64, @bitCast(@as(i64, 4646770556619636448)))), (-@as(f64, @bitCast(@as(i64, 4639154573825566940)))), (-@as(f64, @bitCast(@as(i64, 4646780954305276139)))), (-@as(f64, @bitCast(@as(i64, 4639087347749504250)))), (-@as(f64, @bitCast(@as(i64, 4646791352342759552)))), (-@as(f64, @bitCast(@as(i64, 4638257014512237580)))), (-@as(f64, @bitCast(@as(i64, 4646884931161673056)))), (-@as(f64, @bitCast(@as(i64, 4636616675104991121)))), (-@as(f64, @bitCast(@as(i64, 4644249588091144194)))), (-@as(f64, @bitCast(@as(i64, 4636482224008396905)))), (-@as(f64, @bitCast(@as(i64, 4644259985600862025)))), (-@as(f64, @bitCast(@as(i64, 4636347772208115247)))), (-@as(f64, @bitCast(@as(i64, 4644270383814267298)))), (-@as(f64, @bitCast(@as(i64, 4635137707061111486)))), (-@as(f64, @bitCast(@as(i64, 4644363962457258941)))), (-@as(f64, @bitCast(@as(i64, 4632790718039802228)))), (-@as(f64, @bitCast(@as(i64, 4640246022954478784)))), (-@as(f64, @bitCast(@as(i64, 4632521814298501424)))), (-@as(f64, @bitCast(@as(i64, 4640266818677601888)))), (-@as(f64, @bitCast(@as(i64, 4632252911120150572)))), (-@as(f64, @bitCast(@as(i64, 4640287613697037550)))), (-@as(f64, @bitCast(@as(i64, 4629832780826143051)))), (-@as(f64, @bitCast(@as(i64, 4640474772390395720)))), (-@as(f64, @bitCast(@as(i64, 4619201032811832826)))), (-@as(f64, @bitCast(@as(i64, 4626004738875801662)))), (-@as(f64, @bitCast(@as(i64, 4617049806033946127)))), (-@as(f64, @bitCast(@as(i64, 4626171101564561751)))), (-@as(f64, @bitCast(@as(i64, 4613607540682540440)))), (-@as(f64, @bitCast(@as(i64, 4626337465097746771)))), @as(f64, @bitCast(@as(i64, 4624263857803142808))), (-@as(f64, @bitCast(@as(i64, 4627834732674287296)))), (-@as(f64, @bitCast(@as(i64, 4632729333976881168)))), (-@as(f64, @bitCast(@as(i64, 4640212641429615783)))), (-@as(f64, @bitCast(@as(i64, 4632491122407778382)))), (-@as(f64, @bitCast(@as(i64, 4640250127915170388)))), (-@as(f64, @bitCast(@as(i64, 4632252911120150572)))), (-@as(f64, @bitCast(@as(i64, 4640287613697037550)))), (-@as(f64, @bitCast(@as(i64, 4630109006013063076)))), (-@as(f64, @bitCast(@as(i64, 4640624989604122943)))), @as(f64, @bitCast(@as(i64, 4632658751311721204))), (-@as(f64, @bitCast(@as(i64, 4609505334505058501)))), @as(f64, @bitCast(@as(i64, 4632896963021561479))), (-@as(f64, @bitCast(@as(i64, 4612994789248899721)))), @as(f64, @bitCast(@as(i64, 4633135174731401754))), (-@as(f64, @bitCast(@as(i64, 4615393902256756220)))), @as(f64, @bitCast(@as(i64, 4634741547919889840))), (-@as(f64, @bitCast(@as(i64, 4623640496564319948)))), @as(f64, @bitCast(@as(i64, 4639818112732196734))), @as(f64, @bitCast(@as(i64, 4640105977542722443))), @as(f64, @bitCast(@as(i64, 4639877665096706850))), @as(f64, @bitCast(@as(i64, 4640068488946105513))), @as(f64, @bitCast(@as(i64, 4639937218516748127))), @as(f64, @bitCast(@as(i64, 4640031005275300676))), @as(f64, @bitCast(@as(i64, 4640473194723151257))), @as(f64, @bitCast(@as(i64, 4639693627257152959))), @as(f64, @bitCast(@as(i64, 4642817002373536243))), @as(f64, @bitCast(@as(i64, 4644040713075567215))), @as(f64, @bitCast(@as(i64, 4642876555089890079))), @as(f64, @bitCast(@as(i64, 4644021969832789913))), @as(f64, @bitCast(@as(i64, 4642936108158087636))), @as(f64, @bitCast(@as(i64, 4644003227117778192))), @as(f64, @bitCast(@as(i64, 4643341649563970490))), @as(f64, @bitCast(@as(i64, 4643834538988313636))), @as(f64, @bitCast(@as(i64, 4639818112732196734))), @as(f64, @bitCast(@as(i64, 4640105977542722443))), @as(f64, @bitCast(@as(i64, 4639885107646934800))), @as(f64, @bitCast(@as(i64, 4640127499471285461))), @as(f64, @bitCast(@as(i64, 4639952104320891470))), @as(f64, @bitCast(@as(i64, 4640149026677504292))), @as(f64, @bitCast(@as(i64, 4640555068053314528))), @as(f64, @bitCast(@as(i64, 4640342746552569587))), @as(f64, @bitCast(@as(i64, 4637699924515987663))), @as(f64, @bitCast(@as(i64, 4644170943982651237))), @as(f64, @bitCast(@as(i64, 4637833914626938772))), @as(f64, @bitCast(@as(i64, 4644181704946932746))), @as(f64, @bitCast(@as(i64, 4637967909100752019))), @as(f64, @bitCast(@as(i64, 4644192468198198440))), @as(f64, @bitCast(@as(i64, 4638940724971229623))), @as(f64, @bitCast(@as(i64, 4644289328311652948))), @as(f64, @bitCast(@as(i64, 4634471238703661575))), @as(f64, @bitCast(@as(i64, 4646683289349310099))), @as(f64, @bitCast(@as(i64, 4634605231699731195))), @as(f64, @bitCast(@as(i64, 4646694052600575794))), @as(f64, @bitCast(@as(i64, 4634739222232894768))), @as(f64, @bitCast(@as(i64, 4646704813564857302))), @as(f64, @bitCast(@as(i64, 4635945148994053441))), @as(f64, @bitCast(@as(i64, 4646801674733842973))), @as(f64, @bitCast(@as(i64, 4626000783589428924))), @as(f64, @bitCast(@as(i64, 4648538971539332766))), @as(f64, @bitCast(@as(i64, 4626536735307509080))), @as(f64, @bitCast(@as(i64, 4648544352109434451))), @as(f64, @bitCast(@as(i64, 4627072699973438164))), @as(f64, @bitCast(@as(i64, 4648549732679536135))), @as(f64, @bitCast(@as(i64, 4630798416762545975))), @as(f64, @bitCast(@as(i64, 4648598163967716413))), @as(f64, @bitCast(@as(i64, 4634501009960104540))), @as(f64, @bitCast(@as(i64, 4646742300050411907))), @as(f64, @bitCast(@as(i64, 4634620115674287189))), @as(f64, @bitCast(@as(i64, 4646723557335400186))), @as(f64, @bitCast(@as(i64, 4634739222232894768))), @as(f64, @bitCast(@as(i64, 4646704813564857302))), @as(f64, @bitCast(@as(i64, 4635811175067913493))), @as(f64, @bitCast(@as(i64, 4646536127722376932))), @as(f64, @bitCast(@as(i64, 4639415772048642802))), @as(f64, @bitCast(@as(i64, 4648345175138258177))), @as(f64, @bitCast(@as(i64, 4639475326172371521))), @as(f64, @bitCast(@as(i64, 4648335804396478828))), @as(f64, @bitCast(@as(i64, 4639534877481350474))), @as(f64, @bitCast(@as(i64, 4648326431543637154))), @as(f64, @bitCast(@as(i64, 4640070854391441046))), @as(f64, @bitCast(@as(i64, 4648242088446475108))), @as(f64, @bitCast(@as(i64, 4642227232428802777))), @as(f64, @bitCast(@as(i64, 4649461792879978186))), @as(f64, @bitCast(@as(i64, 4642286785848844055))), @as(f64, @bitCast(@as(i64, 4649452421786355116))), @as(f64, @bitCast(@as(i64, 4642346338917041612))), @as(f64, @bitCast(@as(i64, 4649443050692732047))), @as(f64, @bitCast(@as(i64, 4642882315827132183))), @as(f64, @bitCast(@as(i64, 4649358706715960698))), @as(f64, @bitCast(@as(i64, 4644218669648249272))), @as(f64, @bitCast(@as(i64, 4650652850373648397))), @as(f64, @bitCast(@as(i64, 4644248446182348051))), @as(f64, @bitCast(@as(i64, 4650643479895751839))), @as(f64, @bitCast(@as(i64, 4644278221484993806))), @as(f64, @bitCast(@as(i64, 4650634107658636676))), @as(f64, @bitCast(@as(i64, 4644546210291882813))), @as(f64, @bitCast(@as(i64, 4650549764561474630))), @as(f64, @bitCast(@as(i64, 4642227232428802777))), @as(f64, @bitCast(@as(i64, 4649461792879978186))), @as(f64, @bitCast(@as(i64, 4642294229454603168))), @as(f64, @bitCast(@as(i64, 4649467173977845452))), @as(f64, @bitCast(@as(i64, 4642361222961966350))), @as(f64, @bitCast(@as(i64, 4649472553668337834))), @as(f64, @bitCast(@as(i64, 4642964187046233128))), @as(f64, @bitCast(@as(i64, 4649520984956518112))), @as(f64, @bitCast(@as(i64, 4640612889346717872))), @as(f64, @bitCast(@as(i64, 4650717966091073198))), @as(f64, @bitCast(@as(i64, 4640679884613299659))), @as(f64, @bitCast(@as(i64, 4650723346661174883))), @as(f64, @bitCast(@as(i64, 4640746881287256329))), @as(f64, @bitCast(@as(i64, 4650728728990495172))), @as(f64, @bitCast(@as(i64, 4641349844667835666))), @as(f64, @bitCast(@as(i64, 4650777159838870798))), @as(f64, @bitCast(@as(i64, 4638998547672007851))), @as(f64, @bitCast(@as(i64, 4651974140533621234))), @as(f64, @bitCast(@as(i64, 4639065540475683592))), @as(f64, @bitCast(@as(i64, 4651979520224113616))), @as(f64, @bitCast(@as(i64, 4639132538205171425))), @as(f64, @bitCast(@as(i64, 4651984902025668324))), @as(f64, @bitCast(@as(i64, 4639735501585750761))), @as(f64, @bitCast(@as(i64, 4652033332610161160))), @as(f64, @bitCast(@as(i64, 4635845549777231817))), @as(f64, @bitCast(@as(i64, 4652766236626754784))), @as(f64, @bitCast(@as(i64, 4635979538903020507))), @as(f64, @bitCast(@as(i64, 4652768927351610278))), @as(f64, @bitCast(@as(i64, 4636113528732496639))), @as(f64, @bitCast(@as(i64, 4652771618076465771))), @as(f64, @bitCast(@as(i64, 4637319458308405078))), @as(f64, @bitCast(@as(i64, 4652795832840946608))), @as(f64, @bitCast(@as(i64, 4639013432772463753))), @as(f64, @bitCast(@as(i64, 4652003643509227022))), @as(f64, @bitCast(@as(i64, 4639072986544348751))), @as(f64, @bitCast(@as(i64, 4651994273031330464))), @as(f64, @bitCast(@as(i64, 4639132538205171425))), @as(f64, @bitCast(@as(i64, 4651984902025668324))), @as(f64, @bitCast(@as(i64, 4639668512652355950))), @as(f64, @bitCast(@as(i64, 4651900557960936046))), @as(f64, @bitCast(@as(i64, 4641824893856311170))), @as(f64, @bitCast(@as(i64, 4652669338426217490))), @as(f64, @bitCast(@as(i64, 4641884446572665006))), @as(f64, @bitCast(@as(i64, 4652664652307659909))), @as(f64, @bitCast(@as(i64, 4641943998585331400))), @as(f64, @bitCast(@as(i64, 4652659966628906979))), @as(f64, @bitCast(@as(i64, 4642479975143578251))), @as(f64, @bitCast(@as(i64, 4652617795080325956))), @as(f64, @bitCast(@as(i64, 4643923785203648121))), @as(f64, @bitCast(@as(i64, 4653227647121155634))), @as(f64, @bitCast(@as(i64, 4643953562089590620))), @as(f64, @bitCast(@as(i64, 4653222962322012006))), @as(f64, @bitCast(@as(i64, 4643983336864470794))), @as(f64, @bitCast(@as(i64, 4653218275763649774))), @as(f64, @bitCast(@as(i64, 4644251326902812824))), @as(f64, @bitCast(@as(i64, 4653176104215068751))), @as(f64, @bitCast(@as(i64, 4645423229672474154))), @as(f64, @bitCast(@as(i64, 4653823176923521902))), @as(f64, @bitCast(@as(i64, 4645453006206572933))), @as(f64, @bitCast(@as(i64, 4653818491244768972))), @as(f64, @bitCast(@as(i64, 4645482781157374967))), @as(f64, @bitCast(@as(i64, 4653813805566016042))), @as(f64, @bitCast(@as(i64, 4645750769788342113))), @as(f64, @bitCast(@as(i64, 4653771633137825717))), @as(f64, @bitCast(@as(i64, 4643923785203648121))), @as(f64, @bitCast(@as(i64, 4653227647121155634))), @as(f64, @bitCast(@as(i64, 4643957282836939014))), @as(f64, @bitCast(@as(i64, 4653230337846011127))), @as(f64, @bitCast(@as(i64, 4643990781349839210))), @as(f64, @bitCast(@as(i64, 4653233028570866621))), @as(f64, @bitCast(@as(i64, 4644292260225379111))), @as(f64, @bitCast(@as(i64, 4653257242455738155))), @as(f64, @bitCast(@as(i64, 4643022008339636473))), @as(f64, @bitCast(@as(i64, 4653855733902625001))), @as(f64, @bitCast(@as(i64, 4643089002902530818))), @as(f64, @bitCast(@as(i64, 4653858424627480494))), @as(f64, @bitCast(@as(i64, 4643156002391237255))), @as(f64, @bitCast(@as(i64, 4653861116231945290))), @as(f64, @bitCast(@as(i64, 4643485090971320844))), @as(f64, @bitCast(@as(i64, 4653885331876035428))), @as(f64, @bitCast(@as(i64, 4641407664553864127))), @as(f64, @bitCast(@as(i64, 4654483820684094367))), @as(f64, @bitCast(@as(i64, 4641474661931508239))), @as(f64, @bitCast(@as(i64, 4654486511408949861))), @as(f64, @bitCast(@as(i64, 4641541660012839793))), @as(f64, @bitCast(@as(i64, 4654489201254196052))), @as(f64, @bitCast(@as(i64, 4642144621282356804))), @as(f64, @bitCast(@as(i64, 4654513417338090842))), @as(f64, @bitCast(@as(i64, 4639685703736558554))), @as(f64, @bitCast(@as(i64, 4655153779946982002))), @as(f64, @bitCast(@as(i64, 4639752698651296620))), @as(f64, @bitCast(@as(i64, 4655156470671837495))), @as(f64, @bitCast(@as(i64, 4639819696028940732))), @as(f64, @bitCast(@as(i64, 4655159161396692989))), @as(f64, @bitCast(@as(i64, 4640422660816894951))), @as(f64, @bitCast(@as(i64, 4655183377040783127))), (-@as(f64, @bitCast(@as(i64, 4639221799549785908)))), (-@as(f64, @bitCast(@as(i64, 4646770556619636448)))), (-@as(f64, @bitCast(@as(i64, 4639154573825566940)))), (-@as(f64, @bitCast(@as(i64, 4646780954305276139)))), (-@as(f64, @bitCast(@as(i64, 4639087347749504250)))), (-@as(f64, @bitCast(@as(i64, 4646791352342759552)))), (-@as(f64, @bitCast(@as(i64, 4638257014512237580)))), (-@as(f64, @bitCast(@as(i64, 4646884931161673056)))), (-@as(f64, @bitCast(@as(i64, 4636616675104991121)))), (-@as(f64, @bitCast(@as(i64, 4644249588091144194)))), (-@as(f64, @bitCast(@as(i64, 4636482224008396905)))), (-@as(f64, @bitCast(@as(i64, 4644259985600862025)))), (-@as(f64, @bitCast(@as(i64, 4636347772208115247)))), (-@as(f64, @bitCast(@as(i64, 4644270383814267298)))), (-@as(f64, @bitCast(@as(i64, 4635137707061111486)))), (-@as(f64, @bitCast(@as(i64, 4644363962457258941)))), (-@as(f64, @bitCast(@as(i64, 4632790718039802228)))), (-@as(f64, @bitCast(@as(i64, 4640246022954478784)))), (-@as(f64, @bitCast(@as(i64, 4632521814298501424)))), (-@as(f64, @bitCast(@as(i64, 4640266818677601888)))), (-@as(f64, @bitCast(@as(i64, 4632252911120150572)))), (-@as(f64, @bitCast(@as(i64, 4640287613697037550)))), (-@as(f64, @bitCast(@as(i64, 4629832780826143051)))), (-@as(f64, @bitCast(@as(i64, 4640474772390395720)))), (-@as(f64, @bitCast(@as(i64, 4619201032811832826)))), (-@as(f64, @bitCast(@as(i64, 4626004738875801662)))), (-@as(f64, @bitCast(@as(i64, 4617049806033946127)))), (-@as(f64, @bitCast(@as(i64, 4626171101564561751)))), (-@as(f64, @bitCast(@as(i64, 4613607540682540440)))), (-@as(f64, @bitCast(@as(i64, 4626337465097746771)))), @as(f64, @bitCast(@as(i64, 4624263857803142808))), (-@as(f64, @bitCast(@as(i64, 4627834732674287296)))), (-@as(f64, @bitCast(@as(i64, 4632471165128242155)))), (-@as(f64, @bitCast(@as(i64, 4640157883991333934)))), (-@as(f64, @bitCast(@as(i64, 4632362038687146317)))), (-@as(f64, @bitCast(@as(i64, 4640222749547873184)))), (-@as(f64, @bitCast(@as(i64, 4632252911120150572)))), (-@as(f64, @bitCast(@as(i64, 4640287613697037550)))), (-@as(f64, @bitCast(@as(i64, 4631270768083738452)))), (-@as(f64, @bitCast(@as(i64, 4640871398076391264)))), @as(f64, @bitCast(@as(i64, 4635792991362205520))), (-@as(f64, @bitCast(@as(i64, 4637515889491183539)))), @as(f64, @bitCast(@as(i64, 4635847554582753439))), (-@as(f64, @bitCast(@as(i64, 4637645620956105760)))), @as(f64, @bitCast(@as(i64, 4635902118506988799))), (-@as(f64, @bitCast(@as(i64, 4637775349254434492)))), @as(f64, @bitCast(@as(i64, 4636393189321507418))), (-@as(f64, @bitCast(@as(i64, 4638825268157907563)))), @as(f64, @bitCast(@as(i64, 4642115177240574265))), (-@as(f64, @bitCast(@as(i64, 4632643243166404354)))), @as(f64, @bitCast(@as(i64, 4642142459202691945))), (-@as(f64, @bitCast(@as(i64, 4632902701029699214)))), @as(f64, @bitCast(@as(i64, 4642169741516653346))), (-@as(f64, @bitCast(@as(i64, 4633162159033731563)))), @as(f64, @bitCast(@as(i64, 4642415276712806423))), (-@as(f64, @bitCast(@as(i64, 4634850658879861959)))), @as(f64, @bitCast(@as(i64, 4645257796801115256))), @as(f64, @bitCast(@as(i64, 4621324530589043832))), @as(f64, @bitCast(@as(i64, 4645271438134017817))), @as(f64, @bitCast(@as(i64, 4619880214704367064))), @as(f64, @bitCast(@as(i64, 4645285078411389216))), @as(f64, @bitCast(@as(i64, 4617804525564540354))), @as(f64, @bitCast(@as(i64, 4645407846537231335))), (-@as(f64, @bitCast(@as(i64, 4622470900482092762)))), @as(f64, @bitCast(@as(i64, 4642115177240574265))), (-@as(f64, @bitCast(@as(i64, 4632643243166404354)))), @as(f64, @bitCast(@as(i64, 4642182402964793233))), (-@as(f64, @bitCast(@as(i64, 4632726424932996864)))), @as(f64, @bitCast(@as(i64, 4642249629392699644))), (-@as(f64, @bitCast(@as(i64, 4632809606418114397)))), @as(f64, @bitCast(@as(i64, 4642854661614357803))), (-@as(f64, @bitCast(@as(i64, 4633558239784172194)))), @as(f64, @bitCast(@as(i64, 4643443024536051437))), @as(f64, @bitCast(@as(i64, 4636061082203773584))), @as(f64, @bitCast(@as(i64, 4643476637222239061))), @as(f64, @bitCast(@as(i64, 4636019491179739841))), @as(f64, @bitCast(@as(i64, 4643510249556582964))), @as(f64, @bitCast(@as(i64, 4635977896496531400))), @as(f64, @bitCast(@as(i64, 4643812766195177625))), @as(f64, @bitCast(@as(i64, 4635603584035627152))), @as(f64, @bitCast(@as(i64, 4644222851310872030))), @as(f64, @bitCast(@as(i64, 4642426286254676739))), @as(f64, @bitCast(@as(i64, 4644256464348903375))), @as(f64, @bitCast(@as(i64, 4642405490531553635))), @as(f64, @bitCast(@as(i64, 4644290076683247278))), @as(f64, @bitCast(@as(i64, 4642384693401055647))), @as(f64, @bitCast(@as(i64, 4644592593849607520))), @as(f64, @bitCast(@as(i64, 4642197536818759803))), @as(f64, @bitCast(@as(i64, 4645054666162047361))), @as(f64, @bitCast(@as(i64, 4645507783172181291))), @as(f64, @bitCast(@as(i64, 4645088278672313124))), @as(f64, @bitCast(@as(i64, 4645497384958776018))), @as(f64, @bitCast(@as(i64, 4645121890830735167))), @as(f64, @bitCast(@as(i64, 4645486987976823768))), @as(f64, @bitCast(@as(i64, 4645424408173017270))), @as(f64, @bitCast(@as(i64, 4645393408630144683))) });
}

fn g_r_prev() *CxList(f64) {
    @setEvalBranchQuota(1000000);
    return cx_ll_of(f64, &[_]f64{ @as(f64, @bitCast(@as(i64, 4645807602576811622))), (-@as(f64, @bitCast(@as(i64, 4646181092778940155)))), @as(f64, @bitCast(@as(i64, 4645828842678554209))), (-@as(f64, @bitCast(@as(i64, 4646153042741979775)))), @as(f64, @bitCast(@as(i64, 4645850083483984236))), (-@as(f64, @bitCast(@as(i64, 4646124993760550558)))), @as(f64, @bitCast(@as(i64, 4646041250381010766))), (-@as(f64, @bitCast(@as(i64, 4645872548353719235)))), @as(f64, @bitCast(@as(i64, 4641391629276284642))), (-@as(f64, @bitCast(@as(i64, 4643526000368514111)))), @as(f64, @bitCast(@as(i64, 4641434110183457256))), (-@as(f64, @bitCast(@as(i64, 4643497950859319312)))), @as(f64, @bitCast(@as(i64, 4641476591794317311))), (-@as(f64, @bitCast(@as(i64, 4643469901174202654)))), @as(f64, @bitCast(@as(i64, 4641858925588370371))), (-@as(f64, @bitCast(@as(i64, 4643217456471058772)))), @as(f64, @bitCast(@as(i64, 4617294079138524880))), (-@as(f64, @bitCast(@as(i64, 4638353585410153518)))), @as(f64, @bitCast(@as(i64, 4618653486182447037))), (-@as(f64, @bitCast(@as(i64, 4638241386669686884)))), @as(f64, @bitCast(@as(i64, 4620012893789319147))), (-@as(f64, @bitCast(@as(i64, 4638129189336595133)))), @as(f64, @bitCast(@as(i64, 4625833602089961583))), (-@as(f64, @bitCast(@as(i64, 4637119409116644723)))), (-@as(f64, @bitCast(@as(i64, 4638325734516739161)))), (-@as(f64, @bitCast(@as(i64, 4628117746193220652)))), (-@as(f64, @bitCast(@as(i64, 4638240771646862771)))), (-@as(f64, @bitCast(@as(i64, 4627668954890528811)))), (-@as(f64, @bitCast(@as(i64, 4638155807721455218)))), (-@as(f64, @bitCast(@as(i64, 4627220165558161807)))), (-@as(f64, @bitCast(@as(i64, 4637391142244411423)))), (-@as(f64, @bitCast(@as(i64, 4621165273173120850)))), @as(f64, @bitCast(@as(i64, 4638735139870364811))), (-@as(f64, @bitCast(@as(i64, 4650968531596903816)))), @as(f64, @bitCast(@as(i64, 4638794281633252649))), (-@as(f64, @bitCast(@as(i64, 4650958999622739370)))), @as(f64, @bitCast(@as(i64, 4638853424803515371))), (-@as(f64, @bitCast(@as(i64, 4650949466417121901)))), @as(f64, @bitCast(@as(i64, 4639385704187943128))), (-@as(f64, @bitCast(@as(i64, 4650863671612767470)))), (-@as(f64, @bitCast(@as(i64, 4619213876402430142)))), (-@as(f64, @bitCast(@as(i64, 4649120340775425372)))), (-@as(f64, @bitCast(@as(i64, 4617321341904049149)))), (-@as(f64, @bitCast(@as(i64, 4649110807569807903)))), (-@as(f64, @bitCast(@as(i64, 4614667928301863575)))), (-@as(f64, @bitCast(@as(i64, 4649101274979916946)))), @as(f64, @bitCast(@as(i64, 4622834705763591378))), (-@as(f64, @bitCast(@as(i64, 4649015480263523445)))), (-@as(f64, @bitCast(@as(i64, 4639205631978967369)))), (-@as(f64, @bitCast(@as(i64, 4646829483406010823)))), (-@as(f64, @bitCast(@as(i64, 4639146489864235810)))), (-@as(f64, @bitCast(@as(i64, 4646810417698463327)))), (-@as(f64, @bitCast(@as(i64, 4639087347749504250)))), (-@as(f64, @bitCast(@as(i64, 4646791352342759552)))), (-@as(f64, @bitCast(@as(i64, 4638402521945916991)))), (-@as(f64, @bitCast(@as(i64, 4646619763085894411)))), (-@as(f64, @bitCast(@as(i64, 4642256108594819802)))), (-@as(f64, @bitCast(@as(i64, 4644463797937139142)))), (-@as(f64, @bitCast(@as(i64, 4642196966831931963)))), (-@as(f64, @bitCast(@as(i64, 4644444732405513506)))), (-@as(f64, @bitCast(@as(i64, 4642137824717200404)))), (-@as(f64, @bitCast(@as(i64, 4644425667753497172)))), (-@as(f64, @bitCast(@as(i64, 4641605545332772648)))), (-@as(f64, @bitCast(@as(i64, 4644254077968866450)))), (-@as(f64, @bitCast(@as(i64, 4643834947654795448)))), (-@as(f64, @bitCast(@as(i64, 4642800208520894522)))), (-@as(f64, @bitCast(@as(i64, 4643821276239254750)))), (-@as(f64, @bitCast(@as(i64, 4642865048040998426)))), (-@as(f64, @bitCast(@as(i64, 4643807605351479635)))), (-@as(f64, @bitCast(@as(i64, 4642929887912946051)))), (-@as(f64, @bitCast(@as(i64, 4643684565250441268)))), (-@as(f64, @bitCast(@as(i64, 4643362329178665701)))), (-@as(f64, @bitCast(@as(i64, 4639271521752578125)))), (-@as(f64, @bitCast(@as(i64, 4640612822496410904)))), (-@as(f64, @bitCast(@as(i64, 4639244179625184172)))), (-@as(f64, @bitCast(@as(i64, 4640677662368358528)))), (-@as(f64, @bitCast(@as(i64, 4639216836794102778)))), (-@as(f64, @bitCast(@as(i64, 4640742501536618712)))), (-@as(f64, @bitCast(@as(i64, 4638970755888338604)))), (-@as(f64, @bitCast(@as(i64, 4641326056865710127)))), @as(f64, @bitCast(@as(i64, 4614840227016407515))), (-@as(f64, @bitCast(@as(i64, 4638143256752243689)))), @as(f64, @bitCast(@as(i64, 4616389876804638917))), (-@as(f64, @bitCast(@as(i64, 4638272936496138939)))), @as(f64, @bitCast(@as(i64, 4617264831073694876))), (-@as(f64, @bitCast(@as(i64, 4638402615536346747)))), @as(f64, @bitCast(@as(i64, 4622916318307188726))), (-@as(f64, @bitCast(@as(i64, 4639138670841226508)))), @as(f64, @bitCast(@as(i64, 4639510827555652874))), (-@as(f64, @bitCast(@as(i64, 4633332954812637356)))), @as(f64, @bitCast(@as(i64, 4639538170034890547))), (-@as(f64, @bitCast(@as(i64, 4633592312893052973)))), @as(f64, @bitCast(@as(i64, 4639565512162284499))), (-@as(f64, @bitCast(@as(i64, 4633851670832731101)))), @as(f64, @bitCast(@as(i64, 4639811593419892395))), (-@as(f64, @bitCast(@as(i64, 4635194954145562341)))), (-@as(f64, @bitCast(@as(i64, 4646839231588141755)))), (-@as(f64, @bitCast(@as(i64, 4647046662988931929)))), (-@as(f64, @bitCast(@as(i64, 4646837506146534519)))), (-@as(f64, @bitCast(@as(i64, 4647081804612008673)))), (-@as(f64, @bitCast(@as(i64, 4646835780529005422)))), (-@as(f64, @bitCast(@as(i64, 4647116945883241696)))), (-@as(f64, @bitCast(@as(i64, 4646820249971243551)))), (-@as(f64, @bitCast(@as(i64, 4647433225064900765)))), (-@as(f64, @bitCast(@as(i64, 4644027870076067350)))), (-@as(f64, @bitCast(@as(i64, 4646908609540401398)))), (-@as(f64, @bitCast(@as(i64, 4644026144458538253)))), (-@as(f64, @bitCast(@as(i64, 4646943751163478142)))), (-@as(f64, @bitCast(@as(i64, 4644024418489165435)))), (-@as(f64, @bitCast(@as(i64, 4646978893842086049)))), (-@as(f64, @bitCast(@as(i64, 4644008887755481704)))), (-@as(f64, @bitCast(@as(i64, 4647295171968213954)))), (-@as(f64, @bitCast(@as(i64, 4639221799549785908)))), (-@as(f64, @bitCast(@as(i64, 4646770556619636448)))), (-@as(f64, @bitCast(@as(i64, 4639218348314727715)))), (-@as(f64, @bitCast(@as(i64, 4646805699122322494)))), (-@as(f64, @bitCast(@as(i64, 4639214897079669521)))), (-@as(f64, @bitCast(@as(i64, 4646840840569477378)))), (-@as(f64, @bitCast(@as(i64, 4639183835260458338)))), (-@as(f64, @bitCast(@as(i64, 4647157119399292725)))), @as(f64, @bitCast(@as(i64, 4625532750375854165))), (-@as(f64, @bitCast(@as(i64, 4646632503698871498)))), @as(f64, @bitCast(@as(i64, 4625560358285994877))), (-@as(f64, @bitCast(@as(i64, 4646667645849713823)))), @as(f64, @bitCast(@as(i64, 4625587968447935402))), (-@as(f64, @bitCast(@as(i64, 4646702788000556148)))), @as(f64, @bitCast(@as(i64, 4625836462438674917))), (-@as(f64, @bitCast(@as(i64, 4647019066126684054)))), @as(f64, @bitCast(@as(i64, 4636429086810449746))), (-@as(f64, @bitCast(@as(i64, 4645859580097854733)))), @as(f64, @bitCast(@as(i64, 4636563037937116580))), (-@as(f64, @bitCast(@as(i64, 4645848786412107182)))), @as(f64, @bitCast(@as(i64, 4636696989767470856))), (-@as(f64, @bitCast(@as(i64, 4645837992550437770)))), @as(f64, @bitCast(@as(i64, 4637902554129597014))), (-@as(f64, @bitCast(@as(i64, 4645740850786084690)))), @as(f64, @bitCast(@as(i64, 4632178013162122657))), (-@as(f64, @bitCast(@as(i64, 4643347988028602293)))), @as(f64, @bitCast(@as(i64, 4632445916822831209))), (-@as(f64, @bitCast(@as(i64, 4643337194166932881)))), @as(f64, @bitCast(@as(i64, 4632713820483539761))), (-@as(f64, @bitCast(@as(i64, 4643326400657107190)))), @as(f64, @bitCast(@as(i64, 4634664482182328788))), (-@as(f64, @bitCast(@as(i64, 4643229258892754110)))), @as(f64, @bitCast(@as(i64, 4615263268819344879))), (-@as(f64, @bitCast(@as(i64, 4638215538118888102)))), @as(f64, @bitCast(@as(i64, 4617869667881350454))), (-@as(f64, @bitCast(@as(i64, 4638172364079585338)))), @as(f64, @bitCast(@as(i64, 4620012893226369194))), (-@as(f64, @bitCast(@as(i64, 4638129189336595133)))), @as(f64, @bitCast(@as(i64, 4627597192845216430))), (-@as(f64, @bitCast(@as(i64, 4637740620871807932)))), (-@as(f64, @bitCast(@as(i64, 4631599649638976670)))), @as(f64, @bitCast(@as(i64, 4629497232254606464))), (-@as(f64, @bitCast(@as(i64, 4631331746963430536)))), @as(f64, @bitCast(@as(i64, 4629669928974767473))), (-@as(f64, @bitCast(@as(i64, 4631063843724934450)))), @as(f64, @bitCast(@as(i64, 4629771522301061604))), (-@as(f64, @bitCast(@as(i64, 4627605014190394289)))), @as(f64, @bitCast(@as(i64, 4630548657963998611))), (-@as(f64, @bitCast(@as(i64, 4639631103924263662)))), (-@as(f64, @bitCast(@as(i64, 4649888642821207339)))), (-@as(f64, @bitCast(@as(i64, 4639560786901112969)))), (-@as(f64, @bitCast(@as(i64, 4649889315194557956)))), (-@as(f64, @bitCast(@as(i64, 4639490469526118555)))), (-@as(f64, @bitCast(@as(i64, 4649889986072572760)))), (-@as(f64, @bitCast(@as(i64, 4638857612447481384)))), (-@as(f64, @bitCast(@as(i64, 4649896033386525528)))), (-@as(f64, @bitCast(@as(i64, 4639429543211878371)))), (-@as(f64, @bitCast(@as(i64, 4648570191512296489)))), (-@as(f64, @bitCast(@as(i64, 4639359226188727677)))), (-@as(f64, @bitCast(@as(i64, 4648570863093998735)))), (-@as(f64, @bitCast(@as(i64, 4639288908461889542)))), (-@as(f64, @bitCast(@as(i64, 4648571534675700980)))), (-@as(f64, @bitCast(@as(i64, 4638604486574893863)))), (-@as(f64, @bitCast(@as(i64, 4648577581461888167)))), (-@as(f64, @bitCast(@as(i64, 4639227983203180520)))), (-@as(f64, @bitCast(@as(i64, 4646788664784497546)))), (-@as(f64, @bitCast(@as(i64, 4639157665476342385)))), (-@as(f64, @bitCast(@as(i64, 4646790008299745758)))), (-@as(f64, @bitCast(@as(i64, 4639087347749504250)))), (-@as(f64, @bitCast(@as(i64, 4646791352342759552)))), (-@as(f64, @bitCast(@as(i64, 4638201366276023186)))), (-@as(f64, @bitCast(@as(i64, 4646803445211446483)))), (-@as(f64, @bitCast(@as(i64, 4639012984875407062)))), (-@as(f64, @bitCast(@as(i64, 4643975968553267951)))), (-@as(f64, @bitCast(@as(i64, 4638942667500412648)))), (-@as(f64, @bitCast(@as(i64, 4643977312420359884)))), (-@as(f64, @bitCast(@as(i64, 4638872349421730791)))), (-@as(f64, @bitCast(@as(i64, 4643978655583764375)))), (-@as(f64, @bitCast(@as(i64, 4637771371309326129)))), (-@as(f64, @bitCast(@as(i64, 4643990750211669911)))), (-@as(f64, @bitCast(@as(i64, 4641820996131571169)))), (-@as(f64, @bitCast(@as(i64, 4644408560408100140)))), (-@as(f64, @bitCast(@as(i64, 4641773126385969429)))), (-@as(f64, @bitCast(@as(i64, 4644434348969544510)))), (-@as(f64, @bitCast(@as(i64, 4641725256640367690)))), (-@as(f64, @bitCast(@as(i64, 4644460137882832601)))), (-@as(f64, @bitCast(@as(i64, 4641294428226264593)))), (-@as(f64, @bitCast(@as(i64, 4644692236870972395)))), (-@as(f64, @bitCast(@as(i64, 4637197742898975856)))), (-@as(f64, @bitCast(@as(i64, 4642015670910494955)))), (-@as(f64, @bitCast(@as(i64, 4637102002704084936)))), (-@as(f64, @bitCast(@as(i64, 4642067248033383695)))), (-@as(f64, @bitCast(@as(i64, 4637006263916568898)))), (-@as(f64, @bitCast(@as(i64, 4642118826211803597)))), (-@as(f64, @bitCast(@as(i64, 4636144607088362704)))), (-@as(f64, @bitCast(@as(i64, 4642583023484395743)))), @as(f64, @bitCast(@as(i64, 4614840227016407515))), (-@as(f64, @bitCast(@as(i64, 4638143256752243689)))), @as(f64, @bitCast(@as(i64, 4617046755520738528))), (-@as(f64, @bitCast(@as(i64, 4638246412405396052)))), @as(f64, @bitCast(@as(i64, 4618578588505894099))), (-@as(f64, @bitCast(@as(i64, 4638349568058548415)))), @as(f64, @bitCast(@as(i64, 4625862984981305432))), (-@as(f64, @bitCast(@as(i64, 4638992789749515514)))), @as(f64, @bitCast(@as(i64, 4638192131363512286))), (-@as(f64, @bitCast(@as(i64, 4622459012667926364)))), @as(f64, @bitCast(@as(i64, 4638287871206559486))), (-@as(f64, @bitCast(@as(i64, 4623284254515445547)))), @as(f64, @bitCast(@as(i64, 4638383611401450407))), (-@as(f64, @bitCast(@as(i64, 4624109494674114870)))), @as(f64, @bitCast(@as(i64, 4638976441331024438))), (-@as(f64, @bitCast(@as(i64, 4628366740927943736)))), (-@as(f64, @bitCast(@as(i64, 4646081381851737149)))), (-@as(f64, @bitCast(@as(i64, 4648265751695923452)))), (-@as(f64, @bitCast(@as(i64, 4646067741750287611)))), (-@as(f64, @bitCast(@as(i64, 4648281968173019195)))), (-@as(f64, @bitCast(@as(i64, 4646054099713697608)))), (-@as(f64, @bitCast(@as(i64, 4648298184210310287)))), (-@as(f64, @bitCast(@as(i64, 4645931332467464790)))), (-@as(f64, @bitCast(@as(i64, 4648444129865344064)))), (-@as(f64, @bitCast(@as(i64, 4643648944943982256)))), (-@as(f64, @bitCast(@as(i64, 4647754218424654155)))), (-@as(f64, @bitCast(@as(i64, 4643635304138845276)))), (-@as(f64, @bitCast(@as(i64, 4647770435253593619)))), (-@as(f64, @bitCast(@as(i64, 4643621663333708296)))), (-@as(f64, @bitCast(@as(i64, 4647786650939040989)))), (-@as(f64, @bitCast(@as(i64, 4643498895559709898)))), (-@as(f64, @bitCast(@as(i64, 4647932597913488720)))), (-@as(f64, @bitCast(@as(i64, 4639221799549785908)))), (-@as(f64, @bitCast(@as(i64, 4646770556619636448)))), (-@as(f64, @bitCast(@as(i64, 4639194517939511949)))), (-@as(f64, @bitCast(@as(i64, 4646802989046062352)))), (-@as(f64, @bitCast(@as(i64, 4639167236329237989)))), (-@as(f64, @bitCast(@as(i64, 4646835422000253837)))), (-@as(f64, @bitCast(@as(i64, 4638921700429397471)))), (-@as(f64, @bitCast(@as(i64, 4647127313838086973)))), @as(f64, @bitCast(@as(i64, 4617171327338231410))), (-@as(f64, @bitCast(@as(i64, 4645679287634709698)))), @as(f64, @bitCast(@as(i64, 4618044347874197367))), (-@as(f64, @bitCast(@as(i64, 4645711719533370021)))), @as(f64, @bitCast(@as(i64, 4618917368973113277))), (-@as(f64, @bitCast(@as(i64, 4645744151783874065)))), @as(f64, @bitCast(@as(i64, 4623733861251144919))), (-@as(f64, @bitCast(@as(i64, 4646036044853160224)))) });
}

fn g_sc_n() *CxList(i64) {
    return cx_ll_of(i64, &[_]i64{ 0, 0, 2, 2, 2, 2, 2, 2, 2, 2, 0, 0 });
}

fn g_sc_cp() *CxList(i64) {
    return cx_ll_of(i64, &[_]i64{ 128024, 128024, 128024, 128024, 129426, 129426, 129426, 129426, 129427, 129427, 129427, 129427, 129423, 129423, 129423, 129423 });
}

fn g_sc_face() *CxList(bool) {
    return cx_ll_of(bool, &[_]bool{ true, true, false, false, true, true, false, false, true, true, false, false, true, true, false, false });
}

fn g_f_cull() *CxList(i64) {
    return cx_ll_of(i64, &[_]i64{ 59, 85, 59, 56, 60, 23, 119, 25, 129, 37, 90, 31, 90, 19, 0, 16 });
}

fn g_f_railn() *CxList(i64) {
    return cx_ll_of(i64, &[_]i64{ 298, 298, 347, 347, 339, 331, 335, 147 });
}

fn g_f_railfwd() *CxList(f64) {
    @setEvalBranchQuota(1000000);
    return cx_ll_of(f64, &[_]f64{ @as(f64, @bitCast(@as(i64, 4647125477213863936))), @as(f64, @bitCast(@as(i64, 4647143069399908352))), @as(f64, @bitCast(@as(i64, 4647160661585952768))), @as(f64, @bitCast(@as(i64, 4647178253771997184))), @as(f64, @bitCast(@as(i64, 4647195845958041600))), @as(f64, @bitCast(@as(i64, 4647213438144086016))), @as(f64, @bitCast(@as(i64, 4647231030330130432))), @as(f64, @bitCast(@as(i64, 4647248622516174848))), @as(f64, @bitCast(@as(i64, 4647266214702219264))), @as(f64, @bitCast(@as(i64, 4647283806888263680))), @as(f64, @bitCast(@as(i64, 4647300806217638399))), @as(f64, @bitCast(@as(i64, 4647317213218109003))), @as(f64, @bitCast(@as(i64, 4647330689712228328))), @as(f64, @bitCast(@as(i64, 4647341236051840095))), @as(f64, @bitCast(@as(i64, 4647352162382670421))), @as(f64, @bitCast(@as(i64, 4647363470991703493))), @as(f64, @bitCast(@as(i64, 4647374778545205401))), @as(f64, @bitCast(@as(i64, 4647386086626472892))), @as(f64, @bitCast(@as(i64, 4647397394883662242))), @as(f64, @bitCast(@as(i64, 4647408702613086011))), @as(f64, @bitCast(@as(i64, 4647420010870275362))), @as(f64, @bitCast(@as(i64, 4647431318599699131))), @as(f64, @bitCast(@as(i64, 4647442627384654063))), @as(f64, @bitCast(@as(i64, 4647453934762234112))), @as(f64, @bitCast(@as(i64, 4647116681120841728))), @as(f64, @bitCast(@as(i64, 4647134273306886144))), @as(f64, @bitCast(@as(i64, 4647151865492930560))), @as(f64, @bitCast(@as(i64, 4647169457678974976))), @as(f64, @bitCast(@as(i64, 4647187049865019392))), @as(f64, @bitCast(@as(i64, 4647204642051063808))), @as(f64, @bitCast(@as(i64, 4647222234237108224))), @as(f64, @bitCast(@as(i64, 4647239826423152640))), @as(f64, @bitCast(@as(i64, 4647257418609197056))), @as(f64, @bitCast(@as(i64, 4647275010795241472))), @as(f64, @bitCast(@as(i64, 4647292602981285888))), @as(f64, @bitCast(@as(i64, 4647309009805834631))), @as(f64, @bitCast(@as(i64, 4647325416454461514))), @as(f64, @bitCast(@as(i64, 4647335962794073281))), @as(f64, @bitCast(@as(i64, 4647346508605919467))), @as(f64, @bitCast(@as(i64, 4647357816687186957))), @as(f64, @bitCast(@as(i64, 4647369124240688866))), @as(f64, @bitCast(@as(i64, 4647380432849721937))), @as(f64, @bitCast(@as(i64, 4647391740227301985))), @as(f64, @bitCast(@as(i64, 4647403049188178778))), @as(f64, @bitCast(@as(i64, 4647414356741680687))), @as(f64, @bitCast(@as(i64, 4647425664998870037))), @as(f64, @bitCast(@as(i64, 4647436972904215667))), @as(f64, @bitCast(@as(i64, 4647448280457717576))), @as(f64, @bitCast(@as(i64, 4647459589242672508))), @as(f64, @bitCast(@as(i64, 4649259282717312077))), @as(f64, @bitCast(@as(i64, 4649264936845906752))), @as(f64, @bitCast(@as(i64, 4649270590094892125))), @as(f64, @bitCast(@as(i64, 4649276244223486801))), @as(f64, @bitCast(@as(i64, 4649281898703925197))), @as(f64, @bitCast(@as(i64, 4649287552480676151))), @as(f64, @bitCast(@as(i64, 4649293206257427106))), @as(f64, @bitCast(@as(i64, 4649298860737865502))), @as(f64, @bitCast(@as(i64, 4649304514866460177))), @as(f64, @bitCast(@as(i64, 4649310168115445550))), @as(f64, @bitCast(@as(i64, 4649315634623376062))), @as(f64, @bitCast(@as(i64, 4649320913070837759))), @as(f64, @bitCast(@as(i64, 4649326191958104107))), @as(f64, @bitCast(@as(i64, 4649332689632019612))), @as(f64, @bitCast(@as(i64, 4649340406884232646))), @as(f64, @bitCast(@as(i64, 4649348123872562889))), @as(f64, @bitCast(@as(i64, 4649356114507347054))), @as(f64, @bitCast(@as(i64, 4649364380195960023))), @as(f64, @bitCast(@as(i64, 4649372645884572991))), @as(f64, @bitCast(@as(i64, 4649380911573185960))), @as(f64, @bitCast(@as(i64, 4649389177261798929))), @as(f64, @bitCast(@as(i64, 4649397442950411898))), @as(f64, @bitCast(@as(i64, 4649405708639024867))), @as(f64, @bitCast(@as(i64, 4649413974327637836))), @as(f64, @bitCast(@as(i64, 4649422240016250805))), @as(f64, @bitCast(@as(i64, 4649430505704863773))), @as(f64, @bitCast(@as(i64, 4649256455301171018))), @as(f64, @bitCast(@as(i64, 4649262109781609415))), @as(f64, @bitCast(@as(i64, 4649267763910204090))), @as(f64, @bitCast(@as(i64, 4649273417159189463))), @as(f64, @bitCast(@as(i64, 4649279071287784138))), @as(f64, @bitCast(@as(i64, 4649284725416378814))), @as(f64, @bitCast(@as(i64, 4649290379544973489))), @as(f64, @bitCast(@as(i64, 4649296033673568164))), @as(f64, @bitCast(@as(i64, 4649301687802162840))), @as(f64, @bitCast(@as(i64, 4649307341930757515))), @as(f64, @bitCast(@as(i64, 4649312995179742888))), @as(f64, @bitCast(@as(i64, 4649318273715165515))), @as(f64, @bitCast(@as(i64, 4649323552250588142))), @as(f64, @bitCast(@as(i64, 4649328831665620071))), @as(f64, @bitCast(@as(i64, 4649336548478028454))), @as(f64, @bitCast(@as(i64, 4649344264850632186))), @as(f64, @bitCast(@as(i64, 4649351981838962430))), @as(f64, @bitCast(@as(i64, 4649360247439614468))), @as(f64, @bitCast(@as(i64, 4649368513128227437))), @as(f64, @bitCast(@as(i64, 4649376778816840406))), @as(f64, @bitCast(@as(i64, 4649385044505453375))), @as(f64, @bitCast(@as(i64, 4649393310106105414))), @as(f64, @bitCast(@as(i64, 4649401575794718382))), @as(f64, @bitCast(@as(i64, 4649409841483331351))), @as(f64, @bitCast(@as(i64, 4649418107171944320))), @as(f64, @bitCast(@as(i64, 4649426372772596359))), @as(f64, @bitCast(@as(i64, 4649434638461209328))), @as(f64, @bitCast(@as(i64, 4652393044788101566))), @as(f64, @bitCast(@as(i64, 4652397177632408050))), @as(f64, @bitCast(@as(i64, 4652401310476714535))), @as(f64, @bitCast(@as(i64, 4652405443321021019))), @as(f64, @bitCast(@as(i64, 4652409576165327503))), @as(f64, @bitCast(@as(i64, 4652413709009633988))), @as(f64, @bitCast(@as(i64, 4652417841853940472))), @as(f64, @bitCast(@as(i64, 4652421974258442306))), @as(f64, @bitCast(@as(i64, 4652426107542553441))), @as(f64, @bitCast(@as(i64, 4652430240386859926))), @as(f64, @bitCast(@as(i64, 4652433763661919971))), @as(f64, @bitCast(@as(i64, 4652436771925733566))), @as(f64, @bitCast(@as(i64, 4652440521700188933))), @as(f64, @bitCast(@as(i64, 4652444920186504688))), @as(f64, @bitCast(@as(i64, 4652449318233015792))), @as(f64, @bitCast(@as(i64, 4652453715839722245))), @as(f64, @bitCast(@as(i64, 4652458113886233349))), @as(f64, @bitCast(@as(i64, 4652462511932744453))), @as(f64, @bitCast(@as(i64, 4652466909979255557))), @as(f64, @bitCast(@as(i64, 4652471308025766661))), @as(f64, @bitCast(@as(i64, 4652475706072277765))), @as(f64, @bitCast(@as(i64, 4652480104118788869))), @as(f64, @bitCast(@as(i64, 4652390978146045998))), @as(f64, @bitCast(@as(i64, 4652395110990352482))), @as(f64, @bitCast(@as(i64, 4652399243834658967))), @as(f64, @bitCast(@as(i64, 4652403376678965451))), @as(f64, @bitCast(@as(i64, 4652407509523271936))), @as(f64, @bitCast(@as(i64, 4652411642367578420))), @as(f64, @bitCast(@as(i64, 4652415775211884904))), @as(f64, @bitCast(@as(i64, 4652419908056191389))), @as(f64, @bitCast(@as(i64, 4652424040900497873))), @as(f64, @bitCast(@as(i64, 4652428173744804358))), @as(f64, @bitCast(@as(i64, 4652432306589110842))), @as(f64, @bitCast(@as(i64, 4652435220734729100))), @as(f64, @bitCast(@as(i64, 4652438322676933381))), @as(f64, @bitCast(@as(i64, 4652442721163249136))), @as(f64, @bitCast(@as(i64, 4652447119209760240))), @as(f64, @bitCast(@as(i64, 4652451517256271344))), @as(f64, @bitCast(@as(i64, 4652455914862977797))), @as(f64, @bitCast(@as(i64, 4652460312909488901))), @as(f64, @bitCast(@as(i64, 4652464710956000005))), @as(f64, @bitCast(@as(i64, 4652469109002511109))), @as(f64, @bitCast(@as(i64, 4652473507049022213))), @as(f64, @bitCast(@as(i64, 4652477905095533317))), @as(f64, @bitCast(@as(i64, 4652482303142044421))), @as(f64, @bitCast(@as(i64, 4653715955188409093))), @as(f64, @bitCast(@as(i64, 4653720353234920197))), @as(f64, @bitCast(@as(i64, 4653724751281431301))), @as(f64, @bitCast(@as(i64, 4653729149327942405))), @as(f64, @bitCast(@as(i64, 4653733547374453509))), @as(f64, @bitCast(@as(i64, 4653737945860769264))), @as(f64, @bitCast(@as(i64, 4653742343467475717))), @as(f64, @bitCast(@as(i64, 4653746741953791472))), @as(f64, @bitCast(@as(i64, 4653751139560497925))), @as(f64, @bitCast(@as(i64, 4653755538046813680))), @as(f64, @bitCast(@as(i64, 4653759288261073699))), @as(f64, @bitCast(@as(i64, 4653762296524887294))), @as(f64, @bitCast(@as(i64, 4653765819799947339))), @as(f64, @bitCast(@as(i64, 4653769953084058475))), @as(f64, @bitCast(@as(i64, 4653774086807974262))), @as(f64, @bitCast(@as(i64, 4653778218772671444))), @as(f64, @bitCast(@as(i64, 4653782351177173277))), @as(f64, @bitCast(@as(i64, 4653786484461284413))), @as(f64, @bitCast(@as(i64, 4653790617745395548))), @as(f64, @bitCast(@as(i64, 4653794750149897381))), @as(f64, @bitCast(@as(i64, 4653798882554399215))), @as(f64, @bitCast(@as(i64, 4653803015838510350))), @as(f64, @bitCast(@as(i64, 4653713756165153541))), @as(f64, @bitCast(@as(i64, 4653718154211664645))), @as(f64, @bitCast(@as(i64, 4653722552258175749))), @as(f64, @bitCast(@as(i64, 4653726950304686853))), @as(f64, @bitCast(@as(i64, 4653731348351197957))), @as(f64, @bitCast(@as(i64, 4653735746837513712))), @as(f64, @bitCast(@as(i64, 4653740144444220165))), @as(f64, @bitCast(@as(i64, 4653744542930535920))), @as(f64, @bitCast(@as(i64, 4653748940537242373))), @as(f64, @bitCast(@as(i64, 4653753339903167431))), @as(f64, @bitCast(@as(i64, 4653757736630264581))), @as(f64, @bitCast(@as(i64, 4653760839452078165))), @as(f64, @bitCast(@as(i64, 4653763754037501074))), @as(f64, @bitCast(@as(i64, 4653767886881807558))), @as(f64, @bitCast(@as(i64, 4653772019726114043))), @as(f64, @bitCast(@as(i64, 4653776152570420527))), @as(f64, @bitCast(@as(i64, 4653780285414727012))), @as(f64, @bitCast(@as(i64, 4653784418259033496))), @as(f64, @bitCast(@as(i64, 4653788551103339980))), @as(f64, @bitCast(@as(i64, 4653792683947646465))), @as(f64, @bitCast(@as(i64, 4653796816791952949))), @as(f64, @bitCast(@as(i64, 4653800949636259434))), @as(f64, @bitCast(@as(i64, 4653805082480565918))), @as(f64, @bitCast(@as(i64, 4654958318885302960))), @as(f64, @bitCast(@as(i64, 4654962452609218747))), @as(f64, @bitCast(@as(i64, 4654966585013720580))), @as(f64, @bitCast(@as(i64, 4654970716978417762))), @as(f64, @bitCast(@as(i64, 4654974850262528898))), @as(f64, @bitCast(@as(i64, 4654978983986444684))), @as(f64, @bitCast(@as(i64, 4654983115951141867))), @as(f64, @bitCast(@as(i64, 4654987248355643700))), @as(f64, @bitCast(@as(i64, 4654991381639754836))), @as(f64, @bitCast(@as(i64, 4654995515363670622))), @as(f64, @bitCast(@as(i64, 4654999510109316658))), @as(f64, @bitCast(@as(i64, 4655003367635911547))), @as(f64, @bitCast(@as(i64, 4655007226042115739))), @as(f64, @bitCast(@as(i64, 4655010474439268840))), @as(f64, @bitCast(@as(i64, 4655013114146784805))), @as(f64, @bitCast(@as(i64, 4655015754294105421))), @as(f64, @bitCast(@as(i64, 4655018487240207421))), @as(f64, @bitCast(@as(i64, 4655021315184114060))), @as(f64, @bitCast(@as(i64, 4655024141808606747))), @as(f64, @bitCast(@as(i64, 4655026968433099434))), @as(f64, @bitCast(@as(i64, 4655029795937201422))), @as(f64, @bitCast(@as(i64, 4655032623881108062))), @as(f64, @bitCast(@as(i64, 4655035450505600749))), @as(f64, @bitCast(@as(i64, 4655038277130093435))), @as(f64, @bitCast(@as(i64, 4655041102874976820))), @as(f64, @bitCast(@as(i64, 4655043930818883459))), @as(f64, @bitCast(@as(i64, 4654956252683052043))), @as(f64, @bitCast(@as(i64, 4654960385527358528))), @as(f64, @bitCast(@as(i64, 4654964518371665012))), @as(f64, @bitCast(@as(i64, 4654968651215971497))), @as(f64, @bitCast(@as(i64, 4654972784060277981))), @as(f64, @bitCast(@as(i64, 4654976916904584466))), @as(f64, @bitCast(@as(i64, 4654981049748890950))), @as(f64, @bitCast(@as(i64, 4654985182593197434))), @as(f64, @bitCast(@as(i64, 4654989315437503919))), @as(f64, @bitCast(@as(i64, 4654993448281810403))), @as(f64, @bitCast(@as(i64, 4654997581126116888))), @as(f64, @bitCast(@as(i64, 4655001439092516428))), @as(f64, @bitCast(@as(i64, 4655005297058915969))), @as(f64, @bitCast(@as(i64, 4655009155025315509))), @as(f64, @bitCast(@as(i64, 4655011795172636125))), @as(f64, @bitCast(@as(i64, 4655014433560738136))), @as(f64, @bitCast(@as(i64, 4655017073708058752))), @as(f64, @bitCast(@as(i64, 4655019900772356089))), @as(f64, @bitCast(@as(i64, 4655022728276458078))), @as(f64, @bitCast(@as(i64, 4655025555340755416))), @as(f64, @bitCast(@as(i64, 4655028382405052754))), @as(f64, @bitCast(@as(i64, 4655031209469350091))), @as(f64, @bitCast(@as(i64, 4655034036533647429))), @as(f64, @bitCast(@as(i64, 4655036864037749418))), @as(f64, @bitCast(@as(i64, 4655039689782632802))), @as(f64, @bitCast(@as(i64, 4655042517286734791))), @as(f64, @bitCast(@as(i64, 4655045344351032128))), @as(f64, @bitCast(@as(i64, 4655838320933077202))), @as(f64, @bitCast(@as(i64, 4655841147557569888))), @as(f64, @bitCast(@as(i64, 4655843974182062575))), @as(f64, @bitCast(@as(i64, 4655846801686164564))), @as(f64, @bitCast(@as(i64, 4655849628310657250))), @as(f64, @bitCast(@as(i64, 4655852455814759239))), @as(f64, @bitCast(@as(i64, 4655855282439251925))), @as(f64, @bitCast(@as(i64, 4655858109943353914))), @as(f64, @bitCast(@as(i64, 4655860937007651252))), @as(f64, @bitCast(@as(i64, 4655863764071948589))), @as(f64, @bitCast(@as(i64, 4655866497018050589))), @as(f64, @bitCast(@as(i64, 4655869136285761903))), @as(f64, @bitCast(@as(i64, 4655871775553473217))), @as(f64, @bitCast(@as(i64, 4655872068463370856))), @as(f64, @bitCast(@as(i64, 4655870015455259473))), @as(f64, @bitCast(@as(i64, 4655867962447148089))), @as(f64, @bitCast(@as(i64, 4655865836431464622))), @as(f64, @bitCast(@as(i64, 4655863637408209070))), @as(f64, @bitCast(@as(i64, 4655861438384953518))), @as(f64, @bitCast(@as(i64, 4655859239361697966))), @as(f64, @bitCast(@as(i64, 4655857040338442414))), @as(f64, @bitCast(@as(i64, 4655854841315186862))), @as(f64, @bitCast(@as(i64, 4655852642291931310))), @as(f64, @bitCast(@as(i64, 4655850443268675758))), @as(f64, @bitCast(@as(i64, 4655848244245420206))), @as(f64, @bitCast(@as(i64, 4655846045222164654))), @as(f64, @bitCast(@as(i64, 4655836907840733184))), @as(f64, @bitCast(@as(i64, 4655839734025421219))), @as(f64, @bitCast(@as(i64, 4655842561089718557))), @as(f64, @bitCast(@as(i64, 4655845388154015895))), @as(f64, @bitCast(@as(i64, 4655848215218313232))), @as(f64, @bitCast(@as(i64, 4655851041403001268))), @as(f64, @bitCast(@as(i64, 4655853868467298605))), @as(f64, @bitCast(@as(i64, 4655856695971400594))), @as(f64, @bitCast(@as(i64, 4655859523915307234))), @as(f64, @bitCast(@as(i64, 4655862350099995270))), @as(f64, @bitCast(@as(i64, 4655865177164292607))), @as(f64, @bitCast(@as(i64, 4655867816432003921))), @as(f64, @bitCast(@as(i64, 4655870455699715234))), @as(f64, @bitCast(@as(i64, 4655873094967426548))), @as(f64, @bitCast(@as(i64, 4655871041959315164))), @as(f64, @bitCast(@as(i64, 4655868988951203781))), @as(f64, @bitCast(@as(i64, 4655866935943092398))), @as(f64, @bitCast(@as(i64, 4655864736919836846))), @as(f64, @bitCast(@as(i64, 4655862537896581294))), @as(f64, @bitCast(@as(i64, 4655860338873325742))), @as(f64, @bitCast(@as(i64, 4655858139850070190))), @as(f64, @bitCast(@as(i64, 4655855940826814638))), @as(f64, @bitCast(@as(i64, 4655853741803559086))), @as(f64, @bitCast(@as(i64, 4655851542780303534))), @as(f64, @bitCast(@as(i64, 4655849343757047982))), @as(f64, @bitCast(@as(i64, 4655847144733792430))), @as(f64, @bitCast(@as(i64, 4655844945710536878))), @as(f64, @bitCast(@as(i64, 4629112009542129934))), @as(f64, @bitCast(@as(i64, 4629391460150808087))), @as(f64, @bitCast(@as(i64, 4629670910478011263))), @as(f64, @bitCast(@as(i64, 4629825388730304675))), @as(f64, @bitCast(@as(i64, 4629965114597593705))), @as(f64, @bitCast(@as(i64, 4630104839620457805))), @as(f64, @bitCast(@as(i64, 4630244565769221812))), @as(f64, @bitCast(@as(i64, 4630384290651348423))), @as(f64, @bitCast(@as(i64, 4630524015533475035))), @as(f64, @bitCast(@as(i64, 4630663741541501553))), @as(f64, @bitCast(@as(i64, 4630798759036117655))), @as(f64, @bitCast(@as(i64, 4630929068580273295))), @as(f64, @bitCast(@as(i64, 4631042122863931642))), @as(f64, @bitCast(@as(i64, 4631137922309305160))), @as(f64, @bitCast(@as(i64, 4631237181645092406))), @as(f64, @bitCast(@as(i64, 4631339901997193286))), @as(f64, @bitCast(@as(i64, 4631442622630769143))), @as(f64, @bitCast(@as(i64, 4631545341856970116))), @as(f64, @bitCast(@as(i64, 4631648060098008670))), @as(f64, @bitCast(@as(i64, 4631750780590847039))), @as(f64, @bitCast(@as(i64, 4631853501224422895))), @as(f64, @bitCast(@as(i64, 4631956221295048799))), @as(f64, @bitCast(@as(i64, 4632058941787887167))), @as(f64, @bitCast(@as(i64, 4632161662984412977))), @as(f64, @bitCast(@as(i64, 4628972284800740811))), @as(f64, @bitCast(@as(i64, 4629251734564994034))), @as(f64, @bitCast(@as(i64, 4629531185736622140))), @as(f64, @bitCast(@as(i64, 4629755526218872626))), @as(f64, @bitCast(@as(i64, 4629895251663949190))), @as(f64, @bitCast(@as(i64, 4630034977109025755))), @as(f64, @bitCast(@as(i64, 4630174702694839808))), @as(f64, @bitCast(@as(i64, 4630314428139916373))), @as(f64, @bitCast(@as(i64, 4630454153162780473))), @as(f64, @bitCast(@as(i64, 4630593878607857038))), @as(f64, @bitCast(@as(i64, 4630733604052933603))), @as(f64, @bitCast(@as(i64, 4630863913878564219))), @as(f64, @bitCast(@as(i64, 4630994223704194836))), @as(f64, @bitCast(@as(i64, 4631090022305143424))), @as(f64, @bitCast(@as(i64, 4631185821187566989))), @as(f64, @bitCast(@as(i64, 4631288541821142846))), @as(f64, @bitCast(@as(i64, 4631391262454718703))), @as(f64, @bitCast(@as(i64, 4631493982947557071))), @as(f64, @bitCast(@as(i64, 4631596699781220742))), @as(f64, @bitCast(@as(i64, 4631699420274059110))), @as(f64, @bitCast(@as(i64, 4631802140907634967))), @as(f64, @bitCast(@as(i64, 4631904860978260870))), @as(f64, @bitCast(@as(i64, 4632007581471099238))), @as(f64, @bitCast(@as(i64, 4632110302949100025))), @as(f64, @bitCast(@as(i64, 4632213023019725929))), @as(f64, @bitCast(@as(i64, 4643394961452325069))), @as(f64, @bitCast(@as(i64, 4643407801812997028))), @as(f64, @bitCast(@as(i64, 4643420641118137824))), @as(f64, @bitCast(@as(i64, 4643433481478809783))), @as(f64, @bitCast(@as(i64, 4643446321311716160))), @as(f64, @bitCast(@as(i64, 4643459161144622538))), @as(f64, @bitCast(@as(i64, 4643472001329372636))), @as(f64, @bitCast(@as(i64, 4643484841690044595))), @as(f64, @bitCast(@as(i64, 4643497681698872833))), @as(f64, @bitCast(@as(i64, 4643510521355857350))), @as(f64, @bitCast(@as(i64, 4643522934930095871))), @as(f64, @bitCast(@as(i64, 4643534922069744676))), @as(f64, @bitCast(@as(i64, 4643546909385315341))), @as(f64, @bitCast(@as(i64, 4643560228605291429))), @as(f64, @bitCast(@as(i64, 4643574878674141776))), @as(f64, @bitCast(@as(i64, 4643589528742992124))), @as(f64, @bitCast(@as(i64, 4643604700244236829))), @as(f64, @bitCast(@as(i64, 4643620391946422866))), @as(f64, @bitCast(@as(i64, 4643636084704140067))), @as(f64, @bitCast(@as(i64, 4643651776406326105))), @as(f64, @bitCast(@as(i64, 4643667469164043305))), @as(f64, @bitCast(@as(i64, 4643683160866229343))), @as(f64, @bitCast(@as(i64, 4643698853623946543))), @as(f64, @bitCast(@as(i64, 4643714545150210720))), @as(f64, @bitCast(@as(i64, 4643730238083849781))), @as(f64, @bitCast(@as(i64, 4643745929610113959))), @as(f64, @bitCast(@as(i64, 4643388541008106299))), @as(f64, @bitCast(@as(i64, 4643401382072465700))), @as(f64, @bitCast(@as(i64, 4643414221201684635))), @as(f64, @bitCast(@as(i64, 4643427061034591013))), @as(f64, @bitCast(@as(i64, 4643439901395262972))), @as(f64, @bitCast(@as(i64, 4643452741228169349))), @as(f64, @bitCast(@as(i64, 4643465581236997587))), @as(f64, @bitCast(@as(i64, 4643478421245825825))), @as(f64, @bitCast(@as(i64, 4643491261606497784))), @as(f64, @bitCast(@as(i64, 4643504101439404161))), @as(f64, @bitCast(@as(i64, 4643516940744544957))), @as(f64, @bitCast(@as(i64, 4643528928587881204))), @as(f64, @bitCast(@as(i64, 4643540915727530008))), @as(f64, @bitCast(@as(i64, 4643552903570866255))), @as(f64, @bitCast(@as(i64, 4643567553639716603))), @as(f64, @bitCast(@as(i64, 4643582203884488811))), @as(f64, @bitCast(@as(i64, 4643596854129261019))), @as(f64, @bitCast(@as(i64, 4643612546359212638))), @as(f64, @bitCast(@as(i64, 4643628238589164257))), @as(f64, @bitCast(@as(i64, 4643643930819115876))), @as(f64, @bitCast(@as(i64, 4643659622697223775))), @as(f64, @bitCast(@as(i64, 4643675314927175394))), @as(f64, @bitCast(@as(i64, 4643691007157127013))), @as(f64, @bitCast(@as(i64, 4643706699387078632))), @as(f64, @bitCast(@as(i64, 4643722391617030251))), @as(f64, @bitCast(@as(i64, 4643738083671060009))), @as(f64, @bitCast(@as(i64, 4643753775901011629))), @as(f64, @bitCast(@as(i64, 4648703806804131735))), @as(f64, @bitCast(@as(i64, 4648711652919107545))), @as(f64, @bitCast(@as(i64, 4648719498506317773))), @as(f64, @bitCast(@as(i64, 4648727344885176373))), @as(f64, @bitCast(@as(i64, 4648735191264034973))), @as(f64, @bitCast(@as(i64, 4648743037027167062))), @as(f64, @bitCast(@as(i64, 4648750883493986592))), @as(f64, @bitCast(@as(i64, 4648758729257118681))), @as(f64, @bitCast(@as(i64, 4648766574844328909))), @as(f64, @bitCast(@as(i64, 4648774421487070300))), @as(f64, @bitCast(@as(i64, 4648781110827852759))), @as(f64, @bitCast(@as(i64, 4648786956887197179))), @as(f64, @bitCast(@as(i64, 4648794403043823269))), @as(f64, @bitCast(@as(i64, 4648803136684585019))), @as(f64, @bitCast(@as(i64, 4648811869445737467))), @as(f64, @bitCast(@as(i64, 4648820601327280613))), @as(f64, @bitCast(@as(i64, 4648829333648628410))), @as(f64, @bitCast(@as(i64, 4648838066409780858))), @as(f64, @bitCast(@as(i64, 4648846799610737957))), @as(f64, @bitCast(@as(i64, 4648855532371890405))), @as(f64, @bitCast(@as(i64, 4648864265133042853))), @as(f64, @bitCast(@as(i64, 4648872997894195302))), @as(f64, @bitCast(@as(i64, 4648699883746643830))), @as(f64, @bitCast(@as(i64, 4648707729861619640))), @as(f64, @bitCast(@as(i64, 4648715575536790798))), @as(f64, @bitCast(@as(i64, 4648723422091571259))), @as(f64, @bitCast(@as(i64, 4648731267766742417))), @as(f64, @bitCast(@as(i64, 4648739114321522878))), @as(f64, @bitCast(@as(i64, 4648746960436498688))), @as(f64, @bitCast(@as(i64, 4648754806551474497))), @as(f64, @bitCast(@as(i64, 4648762652138684725))), @as(f64, @bitCast(@as(i64, 4648770497901816814))), @as(f64, @bitCast(@as(i64, 4648778344368636344))), @as(f64, @bitCast(@as(i64, 4648783877375030104))), @as(f64, @bitCast(@as(i64, 4648790036311403324))), @as(f64, @bitCast(@as(i64, 4648798770304008795))), @as(f64, @bitCast(@as(i64, 4648807503065161243))), @as(f64, @bitCast(@as(i64, 4648816235826313691))), @as(f64, @bitCast(@as(i64, 4648824967356013116))), @as(f64, @bitCast(@as(i64, 4648833700029204634))), @as(f64, @bitCast(@as(i64, 4648842433230161733))), @as(f64, @bitCast(@as(i64, 4648851165991314181))), @as(f64, @bitCast(@as(i64, 4648859898752466629))), @as(f64, @bitCast(@as(i64, 4648868631513619078))), @as(f64, @bitCast(@as(i64, 4648877364274771526))), @as(f64, @bitCast(@as(i64, 4651326924888656472))), @as(f64, @bitCast(@as(i64, 4651335658089613571))), @as(f64, @bitCast(@as(i64, 4651344391290570670))), @as(f64, @bitCast(@as(i64, 4651353123611918467))), @as(f64, @bitCast(@as(i64, 4651361856812875566))), @as(f64, @bitCast(@as(i64, 4651370590101793596))), @as(f64, @bitCast(@as(i64, 4651379322862946044))), @as(f64, @bitCast(@as(i64, 4651388055624098492))), @as(f64, @bitCast(@as(i64, 4651396788737094661))), @as(f64, @bitCast(@as(i64, 4651405521498247109))), @as(f64, @bitCast(@as(i64, 4651412967390990408))), @as(f64, @bitCast(@as(i64, 4651419068009266891))), @as(f64, @bitCast(@as(i64, 4651426372636756253))), @as(f64, @bitCast(@as(i64, 4651434939151750581))), @as(f64, @bitCast(@as(i64, 4651443505226940259))), @as(f64, @bitCast(@as(i64, 4651452071566012727))), @as(f64, @bitCast(@as(i64, 4651460637817124264))), @as(f64, @bitCast(@as(i64, 4651469204332118593))), @as(f64, @bitCast(@as(i64, 4651477770495269200))), @as(f64, @bitCast(@as(i64, 4651486336834341668))), @as(f64, @bitCast(@as(i64, 4651494903877101578))), @as(f64, @bitCast(@as(i64, 4651503469952291255))), @as(f64, @bitCast(@as(i64, 4651322558947884899))), @as(f64, @bitCast(@as(i64, 4651331291709037347))), @as(f64, @bitCast(@as(i64, 4651340024470189795))), @as(f64, @bitCast(@as(i64, 4651348757231342243))), @as(f64, @bitCast(@as(i64, 4651357489992494691))), @as(f64, @bitCast(@as(i64, 4651366224073061093))), @as(f64, @bitCast(@as(i64, 4651374955954604238))), @as(f64, @bitCast(@as(i64, 4651383689595365989))), @as(f64, @bitCast(@as(i64, 4651392421476909135))), @as(f64, @bitCast(@as(i64, 4651401156876889489))), @as(f64, @bitCast(@as(i64, 4651409887439018682))), @as(f64, @bitCast(@as(i64, 4651416047782766785))), @as(f64, @bitCast(@as(i64, 4651422088939454438))), @as(f64, @bitCast(@as(i64, 4651430655806292487))), @as(f64, @bitCast(@as(i64, 4651439221969443095))), @as(f64, @bitCast(@as(i64, 4651447788484437423))), @as(f64, @bitCast(@as(i64, 4651456354999431751))), @as(f64, @bitCast(@as(i64, 4651464921074621429))), @as(f64, @bitCast(@as(i64, 4651473487149811106))), @as(f64, @bitCast(@as(i64, 4651482053664805434))), @as(f64, @bitCast(@as(i64, 4651490620531643483))), @as(f64, @bitCast(@as(i64, 4651499186694794091))), @as(f64, @bitCast(@as(i64, 4651507753209788419))), @as(f64, @bitCast(@as(i64, 4653060517395491822))), @as(f64, @bitCast(@as(i64, 4653064800213184335))), @as(f64, @bitCast(@as(i64, 4653069083910486150))), @as(f64, @bitCast(@as(i64, 4653073367167983315))), @as(f64, @bitCast(@as(i64, 4653077649985675828))), @as(f64, @bitCast(@as(i64, 4653081933243172992))), @as(f64, @bitCast(@as(i64, 4653086216500670156))), @as(f64, @bitCast(@as(i64, 4653090499758167320))), @as(f64, @bitCast(@as(i64, 4653094783015664484))), @as(f64, @bitCast(@as(i64, 4653099065833356997))), @as(f64, @bitCast(@as(i64, 4653103206154342551))), @as(f64, @bitCast(@as(i64, 4653107204858230446))), @as(f64, @bitCast(@as(i64, 4653111203562118342))), @as(f64, @bitCast(@as(i64, 4653114324415922622))), @as(f64, @bitCast(@as(i64, 4653116568299252587))), @as(f64, @bitCast(@as(i64, 4653118812622387203))), @as(f64, @bitCast(@as(i64, 4653121136550163671))), @as(f64, @bitCast(@as(i64, 4653123539642777338))), @as(f64, @bitCast(@as(i64, 4653125943175195656))), @as(f64, @bitCast(@as(i64, 4653128346707613975))), @as(f64, @bitCast(@as(i64, 4653130751119641595))), @as(f64, @bitCast(@as(i64, 4653133153772450611))), @as(f64, @bitCast(@as(i64, 4653135557304868930))), @as(f64, @bitCast(@as(i64, 4653137959957677946))), @as(f64, @bitCast(@as(i64, 4653140363050291613))), @as(f64, @bitCast(@as(i64, 4653142767022514582))), @as(f64, @bitCast(@as(i64, 4653058375986645565))), @as(f64, @bitCast(@as(i64, 4653062658364533427))), @as(f64, @bitCast(@as(i64, 4653066941622030592))), @as(f64, @bitCast(@as(i64, 4653071225319332407))), @as(f64, @bitCast(@as(i64, 4653075508137024920))), @as(f64, @bitCast(@as(i64, 4653079791834326735))), @as(f64, @bitCast(@as(i64, 4653084074652019248))), @as(f64, @bitCast(@as(i64, 4653088357909516413))), @as(f64, @bitCast(@as(i64, 4653092641167013577))), @as(f64, @bitCast(@as(i64, 4653096923984706090))), @as(f64, @bitCast(@as(i64, 4653101207682007905))), @as(f64, @bitCast(@as(i64, 4653105205506286499))), @as(f64, @bitCast(@as(i64, 4653109204210174394))), @as(f64, @bitCast(@as(i64, 4653113202034452988))), @as(f64, @bitCast(@as(i64, 4653115446357587604))), @as(f64, @bitCast(@as(i64, 4653117690680722221))), @as(f64, @bitCast(@as(i64, 4653119934564052186))), @as(f64, @bitCast(@as(i64, 4653122338096470504))), @as(f64, @bitCast(@as(i64, 4653124741628888823))), @as(f64, @bitCast(@as(i64, 4653127144721502490))), @as(f64, @bitCast(@as(i64, 4653129548693725459))), @as(f64, @bitCast(@as(i64, 4653131952665948429))), @as(f64, @bitCast(@as(i64, 4653134356198366747))), @as(f64, @bitCast(@as(i64, 4653136759290980414))), @as(f64, @bitCast(@as(i64, 4653139161503984779))), @as(f64, @bitCast(@as(i64, 4653141565036403098))), @as(f64, @bitCast(@as(i64, 4653143968568821416))), @as(f64, @bitCast(@as(i64, 4653818111253550413))), @as(f64, @bitCast(@as(i64, 4653820513906359429))), @as(f64, @bitCast(@as(i64, 4653822916998973096))), @as(f64, @bitCast(@as(i64, 4653825320531391414))), @as(f64, @bitCast(@as(i64, 4653827724503614384))), @as(f64, @bitCast(@as(i64, 4653830126716618749))), @as(f64, @bitCast(@as(i64, 4653832529809232416))), @as(f64, @bitCast(@as(i64, 4653834934661064688))), @as(f64, @bitCast(@as(i64, 4653837337313873704))), @as(f64, @bitCast(@as(i64, 4653839740406487371))), @as(f64, @bitCast(@as(i64, 4653842063894459187))), @as(f64, @bitCast(@as(i64, 4653844307777789152))), @as(f64, @bitCast(@as(i64, 4653846551221314467))), @as(f64, @bitCast(@as(i64, 4653846440830347038))), @as(f64, @bitCast(@as(i64, 4653843977484496169))), @as(f64, @bitCast(@as(i64, 4653841513259035997))), @as(f64, @bitCast(@as(i64, 4653838961952254906))), @as(f64, @bitCast(@as(i64, 4653836323564152894))), @as(f64, @bitCast(@as(i64, 4653833684736246232))), @as(f64, @bitCast(@as(i64, 4653831045468534918))), @as(f64, @bitCast(@as(i64, 4653828405761018954))), @as(f64, @bitCast(@as(i64, 4653825766933112291))), @as(f64, @bitCast(@as(i64, 4653823127665400978))), @as(f64, @bitCast(@as(i64, 4653820488397689664))), @as(f64, @bitCast(@as(i64, 4653817849129978351))), @as(f64, @bitCast(@as(i64, 4653815209862267037))), @as(f64, @bitCast(@as(i64, 4653816909707243579))), @as(f64, @bitCast(@as(i64, 4653819311480443293))), @as(f64, @bitCast(@as(i64, 4653821715452666262))), @as(f64, @bitCast(@as(i64, 4653824118545279930))), @as(f64, @bitCast(@as(i64, 4653826522957307550))), @as(f64, @bitCast(@as(i64, 4653828925170311915))), @as(f64, @bitCast(@as(i64, 4653831328262925582))), @as(f64, @bitCast(@as(i64, 4653833731795343901))), @as(f64, @bitCast(@as(i64, 4653836136647176172))), @as(f64, @bitCast(@as(i64, 4653838538860180537))), @as(f64, @bitCast(@as(i64, 4653840942392598856))), @as(f64, @bitCast(@as(i64, 4653843186275928821))), @as(f64, @bitCast(@as(i64, 4653845429279649484))), @as(f64, @bitCast(@as(i64, 4653847672723174798))), @as(f64, @bitCast(@as(i64, 4653845208937519278))), @as(f64, @bitCast(@as(i64, 4653842745591668408))), @as(f64, @bitCast(@as(i64, 4653840281806012888))), @as(f64, @bitCast(@as(i64, 4653837642978106225))), @as(f64, @bitCast(@as(i64, 4653835003710394912))), @as(f64, @bitCast(@as(i64, 4653832364882488250))), @as(f64, @bitCast(@as(i64, 4653829725174972285))), @as(f64, @bitCast(@as(i64, 4653827085907260971))), @as(f64, @bitCast(@as(i64, 4653824447079354309))), @as(f64, @bitCast(@as(i64, 4653821807371838344))), @as(f64, @bitCast(@as(i64, 4653819168543931682))), @as(f64, @bitCast(@as(i64, 4653816529276220368))), @as(f64, @bitCast(@as(i64, 4653813890008509055))), @as(f64, @bitCast(@as(i64, 4642551021890606067))), @as(f64, @bitCast(@as(i64, 4642585698904049378))), @as(f64, @bitCast(@as(i64, 4642620376621180130))), @as(f64, @bitCast(@as(i64, 4642655053634623441))), @as(f64, @bitCast(@as(i64, 4642689730999910473))), @as(f64, @bitCast(@as(i64, 4642724408365197505))), @as(f64, @bitCast(@as(i64, 4642759084674953375))), @as(f64, @bitCast(@as(i64, 4642793762040240407))), @as(f64, @bitCast(@as(i64, 4642828439757371159))), @as(f64, @bitCast(@as(i64, 4642863116067127029))), @as(f64, @bitCast(@as(i64, 4642892683957899320))), @as(f64, @bitCast(@as(i64, 4642915686796683557))), @as(f64, @bitCast(@as(i64, 4642941735194715803))), @as(f64, @bitCast(@as(i64, 4642972285081313094))), @as(f64, @bitCast(@as(i64, 4643002835671597827))), @as(f64, @bitCast(@as(i64, 4643033385910038839))), @as(f64, @bitCast(@as(i64, 4643063935092948688))), @as(f64, @bitCast(@as(i64, 4643094484979545979))), @as(f64, @bitCast(@as(i64, 4643125035217986991))), @as(f64, @bitCast(@as(i64, 4643155585104584282))), @as(f64, @bitCast(@as(i64, 4643186135343025294))), @as(f64, @bitCast(@as(i64, 4643213950700223841))), @as(f64, @bitCast(@as(i64, 4642533683032040690))), @as(f64, @bitCast(@as(i64, 4642568360749171443))), @as(f64, @bitCast(@as(i64, 4642603037762614754))), @as(f64, @bitCast(@as(i64, 4642637714776058065))), @as(f64, @bitCast(@as(i64, 4642672392141345097))), @as(f64, @bitCast(@as(i64, 4642707069506632129))), @as(f64, @bitCast(@as(i64, 4642741746520075440))), @as(f64, @bitCast(@as(i64, 4642776423533518751))), @as(f64, @bitCast(@as(i64, 4642811100898805783))), @as(f64, @bitCast(@as(i64, 4642845777912249094))), @as(f64, @bitCast(@as(i64, 4642880454925692405))), @as(f64, @bitCast(@as(i64, 4642904912638262515))), @as(f64, @bitCast(@as(i64, 4642926459899573436))), @as(f64, @bitCast(@as(i64, 4642957010138014448))), @as(f64, @bitCast(@as(i64, 4642987560376455460))), @as(f64, @bitCast(@as(i64, 4643018110966740193))), @as(f64, @bitCast(@as(i64, 4643048660853337484))), @as(f64, @bitCast(@as(i64, 4643079210036247333))), @as(f64, @bitCast(@as(i64, 4643109760274688345))), @as(f64, @bitCast(@as(i64, 4643140310161285636))), @as(f64, @bitCast(@as(i64, 4643170860399726648))), @as(f64, @bitCast(@as(i64, 4643201410990011381))), @as(f64, @bitCast(@as(i64, 4643221588171873164))), @as(f64, @bitCast(@as(i64, 4647506223840892069))), @as(f64, @bitCast(@as(i64, 4647521498960112575))), @as(f64, @bitCast(@as(i64, 4647536774079333081))), @as(f64, @bitCast(@as(i64, 4647552049022631726))), @as(f64, @bitCast(@as(i64, 4647567324317774093))), @as(f64, @bitCast(@as(i64, 4647582599261072738))), @as(f64, @bitCast(@as(i64, 4647597874204371384))), @as(f64, @bitCast(@as(i64, 4647613148795826308))), @as(f64, @bitCast(@as(i64, 4647628424266890535))), @as(f64, @bitCast(@as(i64, 4647643699913876623))), @as(f64, @bitCast(@as(i64, 4647656721649986699))), @as(f64, @bitCast(@as(i64, 4647666116756943720))), @as(f64, @bitCast(@as(i64, 4647675813569891402))), @as(f64, @bitCast(@as(i64, 4647687182696044466))), @as(f64, @bitCast(@as(i64, 4647698552525884972))), @as(f64, @bitCast(@as(i64, 4647709920772428734))), @as(f64, @bitCast(@as(i64, 4647718052760427765))), @as(f64, @bitCast(@as(i64, 4647723737323504298))), @as(f64, @bitCast(@as(i64, 4647729421358815248))), @as(f64, @bitCast(@as(i64, 4647735105921891781))), @as(f64, @bitCast(@as(i64, 4647740790309046452))), @as(f64, @bitCast(@as(i64, 4647746474696201124))), @as(f64, @bitCast(@as(i64, 4647498586369242746))), @as(f64, @bitCast(@as(i64, 4647513861664385112))), @as(f64, @bitCast(@as(i64, 4647529136431761898))), @as(f64, @bitCast(@as(i64, 4647544411550982404))), @as(f64, @bitCast(@as(i64, 4647559686670202909))), @as(f64, @bitCast(@as(i64, 4647574961613501555))), @as(f64, @bitCast(@as(i64, 4647590236732722061))), @as(f64, @bitCast(@as(i64, 4647605511148255125))), @as(f64, @bitCast(@as(i64, 4647620786267475631))), @as(f64, @bitCast(@as(i64, 4647636061914461718))), @as(f64, @bitCast(@as(i64, 4647651337913291527))), @as(f64, @bitCast(@as(i64, 4647662105386681872))), @as(f64, @bitCast(@as(i64, 4647670127775361846))), @as(f64, @bitCast(@as(i64, 4647681498836655376))), @as(f64, @bitCast(@as(i64, 4647692867083199138))), @as(f64, @bitCast(@as(i64, 4647704236913039644))), @as(f64, @bitCast(@as(i64, 4647715210039084848))), @as(f64, @bitCast(@as(i64, 4647720894954005101))), @as(f64, @bitCast(@as(i64, 4647726579341159773))), @as(f64, @bitCast(@as(i64, 4647732263728314445))), @as(f64, @bitCast(@as(i64, 4647737948291390977))), @as(f64, @bitCast(@as(i64, 4647743632326701928))), @as(f64, @bitCast(@as(i64, 4647749317241622181))), @as(f64, @bitCast(@as(i64, 4649316971365632647))), @as(f64, @bitCast(@as(i64, 4649322655928709179))), @as(f64, @bitCast(@as(i64, 4649328339964020130))), @as(f64, @bitCast(@as(i64, 4649334023999331081))), @as(f64, @bitCast(@as(i64, 4649339708914251334))), @as(f64, @bitCast(@as(i64, 4649345393301406005))), @as(f64, @bitCast(@as(i64, 4649351078304287189))), @as(f64, @bitCast(@as(i64, 4649356763219207442))), @as(f64, @bitCast(@as(i64, 4649362447694323044))), @as(f64, @bitCast(@as(i64, 4649368131729633994))), @as(f64, @bitCast(@as(i64, 4649373627528554270))), @as(f64, @bitCast(@as(i64, 4649378933771669917))), @as(f64, @bitCast(@as(i64, 4649384240894394866))), @as(f64, @bitCast(@as(i64, 4649390746044989440))), @as(f64, @bitCast(@as(i64, 4649398450718789452))), @as(f64, @bitCast(@as(i64, 4649406155480550395))), @as(f64, @bitCast(@as(i64, 4649414133185077817))), @as(f64, @bitCast(@as(i64, 4649422385415668462))), @as(f64, @bitCast(@as(i64, 4649430636766649804))), @as(f64, @bitCast(@as(i64, 4649438889261123240))), @as(f64, @bitCast(@as(i64, 4649447140875987373))), @as(f64, @bitCast(@as(i64, 4649455392842695227))), @as(f64, @bitCast(@as(i64, 4649463644985324942))), @as(f64, @bitCast(@as(i64, 4649471896248345355))), @as(f64, @bitCast(@as(i64, 4649480147951170418))), @as(f64, @bitCast(@as(i64, 4649488400709526644))), @as(f64, @bitCast(@as(i64, 4649314128644289730))), @as(f64, @bitCast(@as(i64, 4649319813559209983))), @as(f64, @bitCast(@as(i64, 4649325497946364654))), @as(f64, @bitCast(@as(i64, 4649331181981675605))), @as(f64, @bitCast(@as(i64, 4649336866896595858))), @as(f64, @bitCast(@as(i64, 4649342550931906809))), @as(f64, @bitCast(@as(i64, 4649348235846827062))), @as(f64, @bitCast(@as(i64, 4649353919882138013))), @as(f64, @bitCast(@as(i64, 4649359605412784777))), @as(f64, @bitCast(@as(i64, 4649365289711978519))), @as(f64, @bitCast(@as(i64, 4649370973747289470))), @as(f64, @bitCast(@as(i64, 4649376280430209768))), @as(f64, @bitCast(@as(i64, 4649381587552934717))), @as(f64, @bitCast(@as(i64, 4649386894675659666))), @as(f64, @bitCast(@as(i64, 4649394598645772237))), @as(f64, @bitCast(@as(i64, 4649402302791806668))), @as(f64, @bitCast(@as(i64, 4649410006849880169))), @as(f64, @bitCast(@as(i64, 4649418259784158256))), @as(f64, @bitCast(@as(i64, 4649426511399022389))), @as(f64, @bitCast(@as(i64, 4649434763013886522))), @as(f64, @bitCast(@as(i64, 4649443015508359958))), @as(f64, @bitCast(@as(i64, 4649451266243614789))), @as(f64, @bitCast(@as(i64, 4649459519177892875))), @as(f64, @bitCast(@as(i64, 4649467770880717939))), @as(f64, @bitCast(@as(i64, 4649476021967816491))), @as(f64, @bitCast(@as(i64, 4649484274462289927))), @as(f64, @bitCast(@as(i64, 4649492526956763362))), @as(f64, @bitCast(@as(i64, 4651807185410403913))), @as(f64, @bitCast(@as(i64, 4651815437640994558))), @as(f64, @bitCast(@as(i64, 4651823688288288459))), @as(f64, @bitCast(@as(i64, 4651831939991113522))), @as(f64, @bitCast(@as(i64, 4651840192749469748))), @as(f64, @bitCast(@as(i64, 4651848444364333882))), @as(f64, @bitCast(@as(i64, 4651856695979198015))), @as(f64, @bitCast(@as(i64, 4651864948913476102))), @as(f64, @bitCast(@as(i64, 4651873200616301165))), @as(f64, @bitCast(@as(i64, 4651881452583009019))), @as(f64, @bitCast(@as(i64, 4651889429144044348))), @as(f64, @bitCast(@as(i64, 4651897132234547617))), @as(f64, @bitCast(@as(i64, 4651904835764855536))), @as(f64, @bitCast(@as(i64, 4651908669014233684))), @as(f64, @bitCast(@as(i64, 4651908632510447642))), @as(f64, @bitCast(@as(i64, 4651908596006661600))), @as(f64, @bitCast(@as(i64, 4651908558623266256))), @as(f64, @bitCast(@as(i64, 4651908519040847656))), @as(f64, @bitCast(@as(i64, 4651908479458429056))), @as(f64, @bitCast(@as(i64, 4651908438732518363))), @as(f64, @bitCast(@as(i64, 4651908398974177903))), @as(f64, @bitCast(@as(i64, 4651908359215837442))), @as(f64, @bitCast(@as(i64, 4651908319369536052))), @as(f64, @bitCast(@as(i64, 4651908279259351870))), @as(f64, @bitCast(@as(i64, 4651908238973245829))), @as(f64, @bitCast(@as(i64, 4651908200358397461))), @as(f64, @bitCast(@as(i64, 4651803059515010916))), @as(f64, @bitCast(@as(i64, 4651811311217835980))), @as(f64, @bitCast(@as(i64, 4651819563272504764))), @as(f64, @bitCast(@as(i64, 4651827813567954944))), @as(f64, @bitCast(@as(i64, 4651836066854076752))), @as(f64, @bitCast(@as(i64, 4651844318556901815))), @as(f64, @bitCast(@as(i64, 4651852569731961297))), @as(f64, @bitCast(@as(i64, 4651860822578278454))), @as(f64, @bitCast(@as(i64, 4651869074720908168))), @as(f64, @bitCast(@as(i64, 4651877326335772302))), @as(f64, @bitCast(@as(i64, 4651885577686753644))), @as(f64, @bitCast(@as(i64, 4651893280689295983))), @as(f64, @bitCast(@as(i64, 4651900984307564832))), @as(f64, @bitCast(@as(i64, 4651908686694380659))), @as(f64, @bitCast(@as(i64, 4651908650982242989))), @as(f64, @bitCast(@as(i64, 4651908614038652296))), @as(f64, @bitCast(@as(i64, 4651908577974670905))), @as(f64, @bitCast(@as(i64, 4651908538392252305))), @as(f64, @bitCast(@as(i64, 4651908498809833705))), @as(f64, @bitCast(@as(i64, 4651908459227415105))), @as(f64, @bitCast(@as(i64, 4651908418765387203))), @as(f64, @bitCast(@as(i64, 4651908378303359300))), @as(f64, @bitCast(@as(i64, 4651908339952393724))), @as(f64, @bitCast(@as(i64, 4651908300018131403))), @as(f64, @bitCast(@as(i64, 4651908259556103501))), @as(f64, @bitCast(@as(i64, 4651908219621841180))), @as(f64, @bitCast(@as(i64, 4651908180391266301))), @as(f64, @bitCast(@as(i64, 4651825927245806331))), @as(f64, @bitCast(@as(i64, 4651825887311544011))), @as(f64, @bitCast(@as(i64, 4651825847553203550))), @as(f64, @bitCast(@as(i64, 4651825807618941229))), @as(f64, @bitCast(@as(i64, 4651825768036522630))), @as(f64, @bitCast(@as(i64, 4651825728454104030))), @as(f64, @bitCast(@as(i64, 4651825687552271476))), @as(f64, @bitCast(@as(i64, 4651825647530048225))), @as(f64, @bitCast(@as(i64, 4651825607068020323))), @as(f64, @bitCast(@as(i64, 4651825568365211025))), @as(f64, @bitCast(@as(i64, 4651825526143964519))), @as(f64, @bitCast(@as(i64, 4651825481283890106))), @as(f64, @bitCast(@as(i64, 4651825437303424995))), @as(f64, @bitCast(@as(i64, 4651830256682791862))), @as(f64, @bitCast(@as(i64, 4651839940301600011))), @as(f64, @bitCast(@as(i64, 4651849624448173741))), @as(f64, @bitCast(@as(i64, 4651858792967774509))), @as(f64, @bitCast(@as(i64, 4651867447443699060))), @as(f64, @bitCast(@as(i64, 4651876103678842215))), @as(f64, @bitCast(@as(i64, 4651884759474180719))), @as(f64, @bitCast(@as(i64, 4651893414917675501))), @as(f64, @bitCast(@as(i64, 4651902070361170284))), @as(f64, @bitCast(@as(i64, 4651910725980586928))), @as(f64, @bitCast(@as(i64, 4651919381336120780))), @as(f64, @bitCast(@as(i64, 4651928037131459284))), @as(f64, @bitCast(@as(i64, 4651936692047188486))), @as(f64, @bitCast(@as(i64, 4651825947476820283))), @as(f64, @bitCast(@as(i64, 4651825906574987729))), @as(f64, @bitCast(@as(i64, 4651825867432373780))), @as(f64, @bitCast(@as(i64, 4651825826970345878))), @as(f64, @bitCast(@as(i64, 4651825787915692860))), @as(f64, @bitCast(@as(i64, 4651825747805508678))), @as(f64, @bitCast(@as(i64, 4651825708223090079))), @as(f64, @bitCast(@as(i64, 4651825667761062176))), @as(f64, @bitCast(@as(i64, 4651825626859229623))), @as(f64, @bitCast(@as(i64, 4651825587716615674))), @as(f64, @bitCast(@as(i64, 4651825549013806377))), @as(f64, @bitCast(@as(i64, 4651825504153731963))), @as(f64, @bitCast(@as(i64, 4651825460173266852))), @as(f64, @bitCast(@as(i64, 4651825415313192439))), @as(f64, @bitCast(@as(i64, 4651835098932000588))), @as(f64, @bitCast(@as(i64, 4651844782990613388))), @as(f64, @bitCast(@as(i64, 4651854466169616885))), @as(f64, @bitCast(@as(i64, 4651863120381658645))), @as(f64, @bitCast(@as(i64, 4651871775121465986))), @as(f64, @bitCast(@as(i64, 4651880432236218443))), @as(f64, @bitCast(@as(i64, 4651889087591752296))), @as(f64, @bitCast(@as(i64, 4651897742595442428))), @as(f64, @bitCast(@as(i64, 4651906398566702792))), @as(f64, @bitCast(@as(i64, 4651915053658353854))), @as(f64, @bitCast(@as(i64, 4651923709453692358))), @as(f64, @bitCast(@as(i64, 4651932364897187141))), @as(f64, @bitCast(@as(i64, 4651941019285150761))), @as(f64, @bitCast(@as(i64, 4653293644207101261))), @as(f64, @bitCast(@as(i64, 4653297971005258885))), @as(f64, @bitCast(@as(i64, 4653302299562635113))), @as(f64, @bitCast(@as(i64, 4653306626800597388))), @as(f64, @bitCast(@as(i64, 4653310954918168966))), @as(f64, @bitCast(@as(i64, 4653315283035740543))), @as(f64, @bitCast(@as(i64, 4653319610273702819))), @as(f64, @bitCast(@as(i64, 4653323937951469745))), @as(f64, @bitCast(@as(i64, 4653328266508845974))), @as(f64, @bitCast(@as(i64, 4653332594186612900))), @as(f64, @bitCast(@as(i64, 4653335895800128786))), @as(f64, @bitCast(@as(i64, 4653338189381384326))), @as(f64, @bitCast(@as(i64, 4653341536294779276))), @as(f64, @bitCast(@as(i64, 4653345918948127592))), @as(f64, @bitCast(@as(i64, 4653350302920889860))), @as(f64, @bitCast(@as(i64, 4653354685574238175))), @as(f64, @bitCast(@as(i64, 4653359068227586490))), @as(f64, @bitCast(@as(i64, 4653363451320739457))), @as(f64, @bitCast(@as(i64, 4653367834413892423))), @as(f64, @bitCast(@as(i64, 4653372217067240738))), @as(f64, @bitCast(@as(i64, 4653376600160393704))), @as(f64, @bitCast(@as(i64, 4653380983253546670))), @as(f64, @bitCast(@as(i64, 4653291480808022449))), @as(f64, @bitCast(@as(i64, 4653295807606180073))), @as(f64, @bitCast(@as(i64, 4653300135283946999))), @as(f64, @bitCast(@as(i64, 4653304462961713925))), @as(f64, @bitCast(@as(i64, 4653308790639480852))), @as(f64, @bitCast(@as(i64, 4653313119636661731))), @as(f64, @bitCast(@as(i64, 4653317445995014704))), @as(f64, @bitCast(@as(i64, 4653321774112586282))), @as(f64, @bitCast(@as(i64, 4653326102230157859))), @as(f64, @bitCast(@as(i64, 4653330430347729437))), @as(f64, @bitCast(@as(i64, 4653334757145887061))), @as(f64, @bitCast(@as(i64, 4653337034454370510))), @as(f64, @bitCast(@as(i64, 4653339344748202793))), @as(f64, @bitCast(@as(i64, 4653343728281160411))), @as(f64, @bitCast(@as(i64, 4653348110494704075))), @as(f64, @bitCast(@as(i64, 4653352494907270994))), @as(f64, @bitCast(@as(i64, 4653356876681010007))), @as(f64, @bitCast(@as(i64, 4653361259334358322))), @as(f64, @bitCast(@as(i64, 4653365643307120591))), @as(f64, @bitCast(@as(i64, 4653370025960468906))), @as(f64, @bitCast(@as(i64, 4653374408174012570))), @as(f64, @bitCast(@as(i64, 4653378791706970187))), @as(f64, @bitCast(@as(i64, 4653383174360318503))), (-@as(f64, @bitCast(@as(i64, 4639596471594972904)))), (-@as(f64, @bitCast(@as(i64, 4639590205258303883)))), (-@as(f64, @bitCast(@as(i64, 4639583938217947420)))), (-@as(f64, @bitCast(@as(i64, 4639577671177590958)))), (-@as(f64, @bitCast(@as(i64, 4639571404840921937)))), (-@as(f64, @bitCast(@as(i64, 4639565137448721753)))), (-@as(f64, @bitCast(@as(i64, 4639558871112052732)))), (-@as(f64, @bitCast(@as(i64, 4639552604775383711)))), (-@as(f64, @bitCast(@as(i64, 4639546338438714690)))), (-@as(f64, @bitCast(@as(i64, 4639540071398358227)))), (-@as(f64, @bitCast(@as(i64, 4639534013001328251)))), (-@as(f64, @bitCast(@as(i64, 4639528161136562437)))), (-@as(f64, @bitCast(@as(i64, 4639522310327327785)))), (-@as(f64, @bitCast(@as(i64, 4639503197120877969)))), (-@as(f64, @bitCast(@as(i64, 4639470822924587872)))), (-@as(f64, @bitCast(@as(i64, 4639438448376454054)))), (-@as(f64, @bitCast(@as(i64, 4639404922243821769)))), (-@as(f64, @bitCast(@as(i64, 4639370244878534737)))), (-@as(f64, @bitCast(@as(i64, 4639335568216935146)))), (-@as(f64, @bitCast(@as(i64, 4639300890851648115)))), (-@as(f64, @bitCast(@as(i64, 4639266213838204803)))), (-@as(f64, @bitCast(@as(i64, 4639231536824761492)))), (-@as(f64, @bitCast(@as(i64, 4639196859107630740)))), (-@as(f64, @bitCast(@as(i64, 4639162182094187429)))), (-@as(f64, @bitCast(@as(i64, 4639127505080744118)))), (-@as(f64, @bitCast(@as(i64, 4639092827363613365)))), (-@as(f64, @bitCast(@as(i64, 4639599605115151136)))), (-@as(f64, @bitCast(@as(i64, 4639593338426638394)))), (-@as(f64, @bitCast(@as(i64, 4639587072089969373)))), (-@as(f64, @bitCast(@as(i64, 4639580804345925468)))), (-@as(f64, @bitCast(@as(i64, 4639574538009256447)))), (-@as(f64, @bitCast(@as(i64, 4639568271320743705)))), (-@as(f64, @bitCast(@as(i64, 4639562004280387243)))), (-@as(f64, @bitCast(@as(i64, 4639555737943718222)))), (-@as(f64, @bitCast(@as(i64, 4639549471607049201)))), (-@as(f64, @bitCast(@as(i64, 4639543204918536459)))), (-@as(f64, @bitCast(@as(i64, 4639536938581867438)))), (-@as(f64, @bitCast(@as(i64, 4639531087068945344)))), (-@as(f64, @bitCast(@as(i64, 4639525235556023250)))), (-@as(f64, @bitCast(@as(i64, 4639519384394944878)))), (-@as(f64, @bitCast(@as(i64, 4639487009846811060)))), (-@as(f64, @bitCast(@as(i64, 4639454635650520963)))), (-@as(f64, @bitCast(@as(i64, 4639422261102387145)))), (-@as(f64, @bitCast(@as(i64, 4639387583737100113)))), (-@as(f64, @bitCast(@as(i64, 4639352906723656802)))), (-@as(f64, @bitCast(@as(i64, 4639318229710213491)))), (-@as(f64, @bitCast(@as(i64, 4639283552696770180)))), (-@as(f64, @bitCast(@as(i64, 4639248874979639427)))), (-@as(f64, @bitCast(@as(i64, 4639214197966196116)))), (-@as(f64, @bitCast(@as(i64, 4639179520952752805)))), (-@as(f64, @bitCast(@as(i64, 4639144843235622052)))), (-@as(f64, @bitCast(@as(i64, 4639110166222178741)))), (-@as(f64, @bitCast(@as(i64, 4639075489208735430)))), @as(f64, @bitCast(@as(i64, 4643017136007789612))), @as(f64, @bitCast(@as(i64, 4643052312639316584))), @as(f64, @bitCast(@as(i64, 4643087489622687277))), @as(f64, @bitCast(@as(i64, 4643122667309745413))), @as(f64, @bitCast(@as(i64, 4643157844996803548))), @as(f64, @bitCast(@as(i64, 4643193022332017962))), @as(f64, @bitCast(@as(i64, 4643219707567185016))), @as(f64, @bitCast(@as(i64, 4643237295882948502))), @as(f64, @bitCast(@as(i64, 4643254884902399430))), @as(f64, @bitCast(@as(i64, 4643272473921850358))), @as(f64, @bitCast(@as(i64, 4643289478177037169))), @as(f64, @bitCast(@as(i64, 4643305898371647306))), @as(f64, @bitCast(@as(i64, 4643322319269944885))), @as(f64, @bitCast(@as(i64, 4643333183148514754))), @as(f64, @bitCast(@as(i64, 4643338491766575517))), @as(f64, @bitCast(@as(i64, 4643343799329105117))), @as(f64, @bitCast(@as(i64, 4643349296359478416))), @as(f64, @bitCast(@as(i64, 4643354981274398669))), @as(f64, @bitCast(@as(i64, 4643360666717084503))), @as(f64, @bitCast(@as(i64, 4643366351632004756))), @as(f64, @bitCast(@as(i64, 4643372036546925009))), @as(f64, @bitCast(@as(i64, 4643377721461845262))), @as(f64, @bitCast(@as(i64, 4643383406904531097))), @as(f64, @bitCast(@as(i64, 4643389091819451350))), @as(f64, @bitCast(@as(i64, 4643394776734371603))), @as(f64, @bitCast(@as(i64, 4643400462001135577))), @as(f64, @bitCast(@as(i64, 4642999546988338684))), @as(f64, @bitCast(@as(i64, 4643034724323553098))), @as(f64, @bitCast(@as(i64, 4643069901658767512))), @as(f64, @bitCast(@as(i64, 4643105078642138205))), @as(f64, @bitCast(@as(i64, 4643140255977352620))), @as(f64, @bitCast(@as(i64, 4643175433312567034))), @as(f64, @bitCast(@as(i64, 4643210610295937727))), @as(f64, @bitCast(@as(i64, 4643228501900988619))), @as(f64, @bitCast(@as(i64, 4643246090568595826))), @as(f64, @bitCast(@as(i64, 4643263679236203033))), @as(f64, @bitCast(@as(i64, 4643281267903810241))), @as(f64, @bitCast(@as(i64, 4643297688450264098))), @as(f64, @bitCast(@as(i64, 4643314108996717956))), @as(f64, @bitCast(@as(i64, 4643330529543171814))), @as(f64, @bitCast(@as(i64, 4643335837457545135))), @as(f64, @bitCast(@as(i64, 4643341145547840317))), @as(f64, @bitCast(@as(i64, 4643346453638135499))), @as(f64, @bitCast(@as(i64, 4643352139080821333))), @as(f64, @bitCast(@as(i64, 4643357823819819726))), @as(f64, @bitCast(@as(i64, 4643363508910661839))), @as(f64, @bitCast(@as(i64, 4643369194353347673))), @as(f64, @bitCast(@as(i64, 4643374878740502345))), @as(f64, @bitCast(@as(i64, 4643380564183188180))), @as(f64, @bitCast(@as(i64, 4643386249625874014))), @as(f64, @bitCast(@as(i64, 4643391934540794267))), @as(f64, @bitCast(@as(i64, 4643397619103870799))), @as(f64, @bitCast(@as(i64, 4643403304546556633))), @as(f64, @bitCast(@as(i64, 4648881380131040815))), @as(f64, @bitCast(@as(i64, 4648884222324618151))), @as(f64, @bitCast(@as(i64, 4648887064606156417))), @as(f64, @bitCast(@as(i64, 4648889906623811892))), @as(f64, @bitCast(@as(i64, 4648892749960881321))), @as(f64, @bitCast(@as(i64, 4648895592418341447))), @as(f64, @bitCast(@as(i64, 4648898434875801574))), @as(f64, @bitCast(@as(i64, 4648901277597144491))), @as(f64, @bitCast(@as(i64, 4648904119790721827))), @as(f64, @bitCast(@as(i64, 4648906962512064744))), @as(f64, @bitCast(@as(i64, 4648909974030432757))), @as(f64, @bitCast(@as(i64, 4648913154697669588))), @as(f64, @bitCast(@as(i64, 4648916335804711069))), @as(f64, @bitCast(@as(i64, 4648922787914864719))), @as(f64, @bitCast(@as(i64, 4648932510500364956))), @as(f64, @bitCast(@as(i64, 4648942234581201007))), @as(f64, @bitCast(@as(i64, 4648951441715650143))), @as(f64, @bitCast(@as(i64, 4648960132871282596))), @as(f64, @bitCast(@as(i64, 4648968824290797840))), @as(f64, @bitCast(@as(i64, 4648977515446430293))), @as(f64, @bitCast(@as(i64, 4648986206865945537))), @as(f64, @bitCast(@as(i64, 4648994898197499850))), @as(f64, @bitCast(@as(i64, 4649003589089249513))), @as(f64, @bitCast(@as(i64, 4649012280508764756))), @as(f64, @bitCast(@as(i64, 4649020971928280000))), @as(f64, @bitCast(@as(i64, 4649029662732068732))), @as(f64, @bitCast(@as(i64, 4648879959122213077))), @as(f64, @bitCast(@as(i64, 4648882801139868552))), @as(f64, @bitCast(@as(i64, 4648885642893641237))), @as(f64, @bitCast(@as(i64, 4648888485614984154))), @as(f64, @bitCast(@as(i64, 4648891328072444281))), @as(f64, @bitCast(@as(i64, 4648894170969709058))), @as(f64, @bitCast(@as(i64, 4648897012987364534))), @as(f64, @bitCast(@as(i64, 4648899856764238614))), @as(f64, @bitCast(@as(i64, 4648902698781894089))), @as(f64, @bitCast(@as(i64, 4648905541679158867))), @as(f64, @bitCast(@as(i64, 4648908383696814342))), @as(f64, @bitCast(@as(i64, 4648911564364051173))), @as(f64, @bitCast(@as(i64, 4648914745031288003))), @as(f64, @bitCast(@as(i64, 4648917925962407624))), @as(f64, @bitCast(@as(i64, 4648927649251595303))), @as(f64, @bitCast(@as(i64, 4648937372540782982))), @as(f64, @bitCast(@as(i64, 4648947095829970661))), @as(f64, @bitCast(@as(i64, 4648955787161524974))), @as(f64, @bitCast(@as(i64, 4648964478141235567))), @as(f64, @bitCast(@as(i64, 4648973170000555462))), @as(f64, @bitCast(@as(i64, 4648981860980266054))), @as(f64, @bitCast(@as(i64, 4648990552839585949))), @as(f64, @bitCast(@as(i64, 4648999242939687240))), @as(f64, @bitCast(@as(i64, 4649007935238811786))), @as(f64, @bitCast(@as(i64, 4649016625778717727))), @as(f64, @bitCast(@as(i64, 4649025317198232971))), @as(f64, @bitCast(@as(i64, 4649034008177943563))), @as(f64, @bitCast(@as(i64, 4651471910889941526))), @as(f64, @bitCast(@as(i64, 4651480601957613049))), @as(f64, @bitCast(@as(i64, 4651489293728972014))), @as(f64, @bitCast(@as(i64, 4651497984796643536))), @as(f64, @bitCast(@as(i64, 4651506676216158780))), @as(f64, @bitCast(@as(i64, 4651515367547713094))), @as(f64, @bitCast(@as(i64, 4651524058527423686))), @as(f64, @bitCast(@as(i64, 4651532750386743581))), @as(f64, @bitCast(@as(i64, 4651541441366454174))), @as(f64, @bitCast(@as(i64, 4651550132785969417))), @as(f64, @bitCast(@as(i64, 4651556767678936069))), @as(f64, @bitCast(@as(i64, 4651561174521540195))), @as(f64, @bitCast(@as(i64, 4651567314194469696))), @as(f64, @bitCast(@as(i64, 4651575358573382226))), @as(f64, @bitCast(@as(i64, 4651583403655982198))), @as(f64, @bitCast(@as(i64, 4651591448034894728))), @as(f64, @bitCast(@as(i64, 4651599492941572840))), @as(f64, @bitCast(@as(i64, 4651607537848250951))), @as(f64, @bitCast(@as(i64, 4651615581875319760))), @as(f64, @bitCast(@as(i64, 4651623627045880663))), @as(f64, @bitCast(@as(i64, 4651631671688675983))), @as(f64, @bitCast(@as(i64, 4651639716595354095))), @as(f64, @bitCast(@as(i64, 4651467565619988555))), @as(f64, @bitCast(@as(i64, 4651476256511738218))), @as(f64, @bitCast(@as(i64, 4651484947931253461))), @as(f64, @bitCast(@as(i64, 4651493639350768705))), @as(f64, @bitCast(@as(i64, 4651502330418440228))), @as(f64, @bitCast(@as(i64, 4651511022189799193))), @as(f64, @bitCast(@as(i64, 4651519713257470715))), @as(f64, @bitCast(@as(i64, 4651528404676985959))), @as(f64, @bitCast(@as(i64, 4651537095832618412))), @as(f64, @bitCast(@as(i64, 4651545787252133656))), @as(f64, @bitCast(@as(i64, 4651554478671648900))), @as(f64, @bitCast(@as(i64, 4651559056422340447))), @as(f64, @bitCast(@as(i64, 4651563291741130641))), @as(f64, @bitCast(@as(i64, 4651571336383925961))), @as(f64, @bitCast(@as(i64, 4651579381554486863))), @as(f64, @bitCast(@as(i64, 4651587425845438463))), @as(f64, @bitCast(@as(i64, 4651595470488233784))), @as(f64, @bitCast(@as(i64, 4651603515394911896))), @as(f64, @bitCast(@as(i64, 4651611559773824426))), @as(f64, @bitCast(@as(i64, 4651619604856424398))), @as(f64, @bitCast(@as(i64, 4651627649235336928))), @as(f64, @bitCast(@as(i64, 4651635694142015039))), @as(f64, @bitCast(@as(i64, 4651643738169083848))), @as(f64, @bitCast(@as(i64, 4653052234114692809))), @as(f64, @bitCast(@as(i64, 4653056256128227213))), @as(f64, @bitCast(@as(i64, 4653060279021370920))), @as(f64, @bitCast(@as(i64, 4653064301474709976))), @as(f64, @bitCast(@as(i64, 4653068323488244380))), @as(f64, @bitCast(@as(i64, 4653072345941583436))), @as(f64, @bitCast(@as(i64, 4653076367955117841))), @as(f64, @bitCast(@as(i64, 4653080390848261548))), @as(f64, @bitCast(@as(i64, 4653084413301600603))), @as(f64, @bitCast(@as(i64, 4653088434875330357))), @as(f64, @bitCast(@as(i64, 4653092324067860126))), @as(f64, @bitCast(@as(i64, 4653096078680166656))), @as(f64, @bitCast(@as(i64, 4653099834611887138))), @as(f64, @bitCast(@as(i64, 4653103134466184420))), @as(f64, @bitCast(@as(i64, 4653105979562472453))), @as(f64, @bitCast(@as(i64, 4653108824218955835))), @as(f64, @bitCast(@as(i64, 4653111770470313624))), @as(f64, @bitCast(@as(i64, 4653114817876741168))), @as(f64, @bitCast(@as(i64, 4653117863963754758))), @as(f64, @bitCast(@as(i64, 4653120911370182302))), @as(f64, @bitCast(@as(i64, 4653123958336805195))), @as(f64, @bitCast(@as(i64, 4653127005743232739))), @as(f64, @bitCast(@as(i64, 4653130053149660283))), @as(f64, @bitCast(@as(i64, 4653133099676478525))), @as(f64, @bitCast(@as(i64, 4653136146643101417))), @as(f64, @bitCast(@as(i64, 4653139193609724310))), @as(f64, @bitCast(@as(i64, 4653050222888023281))), @as(f64, @bitCast(@as(i64, 4653054245341362337))), @as(f64, @bitCast(@as(i64, 4653058267354896741))), @as(f64, @bitCast(@as(i64, 4653062290248040448))), @as(f64, @bitCast(@as(i64, 4653066311821770201))), @as(f64, @bitCast(@as(i64, 4653070334714913908))), @as(f64, @bitCast(@as(i64, 4653074357168252964))), @as(f64, @bitCast(@as(i64, 4653078379621592020))), @as(f64, @bitCast(@as(i64, 4653082402074931075))), @as(f64, @bitCast(@as(i64, 4653086424088465480))), @as(f64, @bitCast(@as(i64, 4653090446101999885))), @as(f64, @bitCast(@as(i64, 4653094201154111065))), @as(f64, @bitCast(@as(i64, 4653097956646026897))), @as(f64, @bitCast(@as(i64, 4653101712137942729))), @as(f64, @bitCast(@as(i64, 4653104557234230762))), @as(f64, @bitCast(@as(i64, 4653107401890714144))), @as(f64, @bitCast(@as(i64, 4653110246547197526))), @as(f64, @bitCast(@as(i64, 4653113293953625070))), @as(f64, @bitCast(@as(i64, 4653116340920247963))), @as(f64, @bitCast(@as(i64, 4653119387447066205))), @as(f64, @bitCast(@as(i64, 4653122434853493749))), @as(f64, @bitCast(@as(i64, 4653125482259921292))), @as(f64, @bitCast(@as(i64, 4653128528786739534))), @as(f64, @bitCast(@as(i64, 4653131576632971729))), @as(f64, @bitCast(@as(i64, 4653134622719985320))), @as(f64, @bitCast(@as(i64, 4653137670126412864))), @as(f64, @bitCast(@as(i64, 4653140717093035757))), @as(f64, @bitCast(@as(i64, 4655506271500121407))), @as(f64, @bitCast(@as(i64, 4655509318906548951))), @as(f64, @bitCast(@as(i64, 4655512366312976495))), @as(f64, @bitCast(@as(i64, 4655515413279599388))), @as(f64, @bitCast(@as(i64, 4655518460246222281))), @as(f64, @bitCast(@as(i64, 4655521506773040523))), @as(f64, @bitCast(@as(i64, 4655524554179468067))), @as(f64, @bitCast(@as(i64, 4655527600266481657))), @as(f64, @bitCast(@as(i64, 4655530647672909201))), @as(f64, @bitCast(@as(i64, 4655533695519141396))), @as(f64, @bitCast(@as(i64, 4655536021645941119))), @as(f64, @bitCast(@as(i64, 4655537815609112999))), @as(f64, @bitCast(@as(i64, 4655540688413094052))), @as(f64, @bitCast(@as(i64, 4655544452701102906))), @as(f64, @bitCast(@as(i64, 4655548216109502457))), @as(f64, @bitCast(@as(i64, 4655551980837315962))), @as(f64, @bitCast(@as(i64, 4655555744245715514))), @as(f64, @bitCast(@as(i64, 4655559508093919717))), @as(f64, @bitCast(@as(i64, 4655563272381928571))), @as(f64, @bitCast(@as(i64, 4655567036669937425))), @as(f64, @bitCast(@as(i64, 4655570800078336976))), @as(f64, @bitCast(@as(i64, 4655574564806150482))), @as(f64, @bitCast(@as(i64, 4655504748456614612))), @as(f64, @bitCast(@as(i64, 4655507795423237505))), @as(f64, @bitCast(@as(i64, 4655510843269469700))), @as(f64, @bitCast(@as(i64, 4655513889796287942))), @as(f64, @bitCast(@as(i64, 4655516937202715486))), @as(f64, @bitCast(@as(i64, 4655519983289729076))), @as(f64, @bitCast(@as(i64, 4655523030696156620))), @as(f64, @bitCast(@as(i64, 4655526076783170211))), @as(f64, @bitCast(@as(i64, 4655529124189597755))), @as(f64, @bitCast(@as(i64, 4655532171156220648))), @as(f64, @bitCast(@as(i64, 4655535219442257494))), @as(f64, @bitCast(@as(i64, 4655536824289429396))), @as(f64, @bitCast(@as(i64, 4655538806049187299))), @as(f64, @bitCast(@as(i64, 4655542570337196153))), @as(f64, @bitCast(@as(i64, 4655546334625205007))), @as(f64, @bitCast(@as(i64, 4655550098473409210))), @as(f64, @bitCast(@as(i64, 4655553862761418064))), @as(f64, @bitCast(@as(i64, 4655557626169817616))), @as(f64, @bitCast(@as(i64, 4655561390457826469))), @as(f64, @bitCast(@as(i64, 4655565154306030672))), @as(f64, @bitCast(@as(i64, 4655568918594039526))), @as(f64, @bitCast(@as(i64, 4655572682442243729))), @as(f64, @bitCast(@as(i64, 4655576446730252583))), @as(f64, @bitCast(@as(i64, 4656632271242619834))), @as(f64, @bitCast(@as(i64, 4656636035970433339))), @as(f64, @bitCast(@as(i64, 4656639800258442192))), @as(f64, @bitCast(@as(i64, 4656643564106646395))), @as(f64, @bitCast(@as(i64, 4656647327954850598))), @as(f64, @bitCast(@as(i64, 4656651093122468754))), @as(f64, @bitCast(@as(i64, 4656654856530868306))), @as(f64, @bitCast(@as(i64, 4656658619499463207))), @as(f64, @bitCast(@as(i64, 4656662384667081363))), @as(f64, @bitCast(@as(i64, 4656666148075480914))), @as(f64, @bitCast(@as(i64, 4656669019120243363))), @as(f64, @bitCast(@as(i64, 4656671122705889624))), @as(f64, @bitCast(@as(i64, 4656674348233200868))), @as(f64, @bitCast(@as(i64, 4656678572556874783))), @as(f64, @bitCast(@as(i64, 4656682798639767303))), @as(f64, @bitCast(@as(i64, 4656687022963441218))), @as(f64, @bitCast(@as(i64, 4656691247726919785))), @as(f64, @bitCast(@as(i64, 4656695472490398351))), @as(f64, @bitCast(@as(i64, 4656699696814072267))), @as(f64, @bitCast(@as(i64, 4656703921577550833))), @as(f64, @bitCast(@as(i64, 4656708146341029400))), @as(f64, @bitCast(@as(i64, 4656712371104507966))), @as(f64, @bitCast(@as(i64, 4656630389758322383))), @as(f64, @bitCast(@as(i64, 4656634153166721935))), @as(f64, @bitCast(@as(i64, 4656637918774144742))), @as(f64, @bitCast(@as(i64, 4656641681742739643))), @as(f64, @bitCast(@as(i64, 4656645446030748497))), @as(f64, @bitCast(@as(i64, 4656649209439148048))), @as(f64, @bitCast(@as(i64, 4656652975046570856))), @as(f64, @bitCast(@as(i64, 4656656737575361105))), @as(f64, @bitCast(@as(i64, 4656660500983760657))), @as(f64, @bitCast(@as(i64, 4656664266591183464))), @as(f64, @bitCast(@as(i64, 4656668029119973714))), @as(f64, @bitCast(@as(i64, 4656670009120513013))), @as(f64, @bitCast(@as(i64, 4656672235851461584))), @as(f64, @bitCast(@as(i64, 4656676460175135500))), @as(f64, @bitCast(@as(i64, 4656680685378418717))), @as(f64, @bitCast(@as(i64, 4656684910581701935))), @as(f64, @bitCast(@as(i64, 4656689135784985153))), @as(f64, @bitCast(@as(i64, 4656693360108659068))), @as(f64, @bitCast(@as(i64, 4656697583992528332))), @as(f64, @bitCast(@as(i64, 4656701809195811550))), @as(f64, @bitCast(@as(i64, 4656706034399094768))), @as(f64, @bitCast(@as(i64, 4656710258722768683))), @as(f64, @bitCast(@as(i64, 4656714483046442598))), (-@as(f64, @bitCast(@as(i64, 4631839025810795596)))), (-@as(f64, @bitCast(@as(i64, 4631788255324821365)))), (-@as(f64, @bitCast(@as(i64, 4631737485542534576)))), (-@as(f64, @bitCast(@as(i64, 4631686714775085368)))), (-@as(f64, @bitCast(@as(i64, 4631635944429848625)))), (-@as(f64, @bitCast(@as(i64, 4631585173662399417)))), (-@as(f64, @bitCast(@as(i64, 4631534404443062581)))), (-@as(f64, @bitCast(@as(i64, 4631483633675613373)))), (-@as(f64, @bitCast(@as(i64, 4631432863330376631)))), (-@as(f64, @bitCast(@as(i64, 4631382093125877376)))), (-@as(f64, @bitCast(@as(i64, 4631333008393538665)))), (-@as(f64, @bitCast(@as(i64, 4631285608851885521)))), (-@as(f64, @bitCast(@as(i64, 4631238209591707353)))), (-@as(f64, @bitCast(@as(i64, 4631148825946215489)))), (-@as(f64, @bitCast(@as(i64, 4631017458056147417)))), (-@as(f64, @bitCast(@as(i64, 4630886089884604368)))), (-@as(f64, @bitCast(@as(i64, 4630750052183935178)))), (-@as(f64, @bitCast(@as(i64, 4630609342561602545)))), (-@as(f64, @bitCast(@as(i64, 4630468633080007399)))), (-@as(f64, @bitCast(@as(i64, 4630327923457674766)))), (-@as(f64, @bitCast(@as(i64, 4630187214398292085)))), (-@as(f64, @bitCast(@as(i64, 4630046505338909405)))), (-@as(f64, @bitCast(@as(i64, 4629905795857314260)))), (-@as(f64, @bitCast(@as(i64, 4629765086234981626)))), (-@as(f64, @bitCast(@as(i64, 4629548336569903074)))), (-@as(f64, @bitCast(@as(i64, 4629266917888187760)))), (-@as(f64, @bitCast(@as(i64, 4631864410631570247)))), (-@as(f64, @bitCast(@as(i64, 4631813640708545969)))), (-@as(f64, @bitCast(@as(i64, 4631762870363309226)))), (-@as(f64, @bitCast(@as(i64, 4631712100299547460)))), (-@as(f64, @bitCast(@as(i64, 4631661329954310717)))), (-@as(f64, @bitCast(@as(i64, 4631610559046124021)))), (-@as(f64, @bitCast(@as(i64, 4631559788560149790)))), (-@as(f64, @bitCast(@as(i64, 4631509018918600489)))), (-@as(f64, @bitCast(@as(i64, 4631458248291888770)))), (-@as(f64, @bitCast(@as(i64, 4631407478509601980)))), (-@as(f64, @bitCast(@as(i64, 4631356708305102726)))), (-@as(f64, @bitCast(@as(i64, 4631309308200499628)))), (-@as(f64, @bitCast(@as(i64, 4631261909221796437)))), (-@as(f64, @bitCast(@as(i64, 4631214508835718363)))), (-@as(f64, @bitCast(@as(i64, 4631083141930812709)))), (-@as(f64, @bitCast(@as(i64, 4630951773900007149)))), (-@as(f64, @bitCast(@as(i64, 4630820406432151542)))), (-@as(f64, @bitCast(@as(i64, 4630679697372768861)))), (-@as(f64, @bitCast(@as(i64, 4630538987891173716)))), (-@as(f64, @bitCast(@as(i64, 4630398278268841082)))), (-@as(f64, @bitCast(@as(i64, 4630257569209458402)))), (-@as(f64, @bitCast(@as(i64, 4630116859587125769)))), (-@as(f64, @bitCast(@as(i64, 4629976150668480577)))), (-@as(f64, @bitCast(@as(i64, 4629835441046147943)))), (-@as(f64, @bitCast(@as(i64, 4629689045910760731)))), (-@as(f64, @bitCast(@as(i64, 4629407627510520394)))), (-@as(f64, @bitCast(@as(i64, 4629126208828805080)))), @as(f64, @bitCast(@as(i64, 4648405308748595200))), @as(f64, @bitCast(@as(i64, 4648414104841617408))), @as(f64, @bitCast(@as(i64, 4648422900934639616))), @as(f64, @bitCast(@as(i64, 4648431697027661824))), @as(f64, @bitCast(@as(i64, 4648440493120684032))), @as(f64, @bitCast(@as(i64, 4648449289213706240))), @as(f64, @bitCast(@as(i64, 4648458085306728448))), @as(f64, @bitCast(@as(i64, 4648466881399750656))), @as(f64, @bitCast(@as(i64, 4648475677492772864))), @as(f64, @bitCast(@as(i64, 4648484473585795072))), @as(f64, @bitCast(@as(i64, 4648493791287133497))), @as(f64, @bitCast(@as(i64, 4648503632356006743))), @as(f64, @bitCast(@as(i64, 4648513473424879990))), @as(f64, @bitCast(@as(i64, 4648519247796066278))), @as(f64, @bitCast(@as(i64, 4648520957140823284))), @as(f64, @bitCast(@as(i64, 4648522666573541220))), @as(f64, @bitCast(@as(i64, 4648524285230579167))), @as(f64, @bitCast(@as(i64, 4648525812584171543))), @as(f64, @bitCast(@as(i64, 4648527340025724849))), @as(f64, @bitCast(@as(i64, 4648528867467278156))), @as(f64, @bitCast(@as(i64, 4648530394820870532))), @as(f64, @bitCast(@as(i64, 4648531922350384769))), @as(f64, @bitCast(@as(i64, 4648533449616016215))), @as(f64, @bitCast(@as(i64, 4648534977233491381))), @as(f64, @bitCast(@as(i64, 4648536504235240037))), @as(f64, @bitCast(@as(i64, 4648538031852715204))), @as(f64, @bitCast(@as(i64, 4648400910702084096))), @as(f64, @bitCast(@as(i64, 4648409706795106304))), @as(f64, @bitCast(@as(i64, 4648418502888128512))), @as(f64, @bitCast(@as(i64, 4648427298981150720))), @as(f64, @bitCast(@as(i64, 4648436095074172928))), @as(f64, @bitCast(@as(i64, 4648444891167195136))), @as(f64, @bitCast(@as(i64, 4648453687260217344))), @as(f64, @bitCast(@as(i64, 4648462483353239552))), @as(f64, @bitCast(@as(i64, 4648471279446261760))), @as(f64, @bitCast(@as(i64, 4648480075539283968))), @as(f64, @bitCast(@as(i64, 4648488871632306176))), @as(f64, @bitCast(@as(i64, 4648498711821570120))), @as(f64, @bitCast(@as(i64, 4648508552890443366))), @as(f64, @bitCast(@as(i64, 4648518393079707310))), @as(f64, @bitCast(@as(i64, 4648520102512425246))), @as(f64, @bitCast(@as(i64, 4648521812121065043))), @as(f64, @bitCast(@as(i64, 4648523521201939258))), @as(f64, @bitCast(@as(i64, 4648525049083297215))), @as(f64, @bitCast(@as(i64, 4648526576085045871))), @as(f64, @bitCast(@as(i64, 4648528103966403828))), @as(f64, @bitCast(@as(i64, 4648529630968152483))), @as(f64, @bitCast(@as(i64, 4648531158849510441))), @as(f64, @bitCast(@as(i64, 4648532685851259096))), @as(f64, @bitCast(@as(i64, 4648534213732617054))), @as(f64, @bitCast(@as(i64, 4648535740470482918))), @as(f64, @bitCast(@as(i64, 4648537268615723667))), @as(f64, @bitCast(@as(i64, 4648538795265628601))), @as(f64, @bitCast(@as(i64, 4648967238619108727))), @as(f64, @bitCast(@as(i64, 4648968766236583893))), @as(f64, @bitCast(@as(i64, 4648970293238332549))), @as(f64, @bitCast(@as(i64, 4648971820855807716))), @as(f64, @bitCast(@as(i64, 4648973348121439162))), @as(f64, @bitCast(@as(i64, 4648974875650953398))), @as(f64, @bitCast(@as(i64, 4648976403004545774))), @as(f64, @bitCast(@as(i64, 4648977930446099081))), @as(f64, @bitCast(@as(i64, 4648979458327457038))), @as(f64, @bitCast(@as(i64, 4648980985769010345))), @as(f64, @bitCast(@as(i64, 4648982151251335787))), @as(f64, @bitCast(@as(i64, 4648982351802256694))), @as(f64, @bitCast(@as(i64, 4648981766334305135))), @as(f64, @bitCast(@as(i64, 4648980999842759180))), @as(f64, @bitCast(@as(i64, 4648980232823447644))), @as(f64, @bitCast(@as(i64, 4648979466683745409))), @as(f64, @bitCast(@as(i64, 4648978699664433873))), @as(f64, @bitCast(@as(i64, 4648977933084926987))), @as(f64, @bitCast(@as(i64, 4648977166505420102))), @as(f64, @bitCast(@as(i64, 4648976399837952286))), @as(f64, @bitCast(@as(i64, 4648975633346406331))), @as(f64, @bitCast(@as(i64, 4648974866327094795))), @as(f64, @bitCast(@as(i64, 4648966475206195329))), @as(f64, @bitCast(@as(i64, 4648968001856100264))), @as(f64, @bitCast(@as(i64, 4648969530001341012))), @as(f64, @bitCast(@as(i64, 4648971056739206876))), @as(f64, @bitCast(@as(i64, 4648972584620564834))), @as(f64, @bitCast(@as(i64, 4648974111622313489))), @as(f64, @bitCast(@as(i64, 4648975639503671447))), @as(f64, @bitCast(@as(i64, 4648977166505420102))), @as(f64, @bitCast(@as(i64, 4648978694386778060))), @as(f64, @bitCast(@as(i64, 4648980222268136017))), @as(f64, @bitCast(@as(i64, 4648981749269884672))), @as(f64, @bitCast(@as(i64, 4648982553232786902))), @as(f64, @bitCast(@as(i64, 4648982149492117183))), @as(f64, @bitCast(@as(i64, 4648981383088532158))), @as(f64, @bitCast(@as(i64, 4648980616333103412))), @as(f64, @bitCast(@as(i64, 4648979849753596527))), @as(f64, @bitCast(@as(i64, 4648979083174089641))), @as(f64, @bitCast(@as(i64, 4648978316418660895))), @as(f64, @bitCast(@as(i64, 4648977550015075870))), @as(f64, @bitCast(@as(i64, 4648976782995764334))), @as(f64, @bitCast(@as(i64, 4648976016504218379))), @as(f64, @bitCast(@as(i64, 4648975249836750563))), @as(f64, @bitCast(@as(i64, 4648974483169282747))), @as(f64, @bitCast(@as(i64, 4648724393708006492))), @as(f64, @bitCast(@as(i64, 4648723627040538676))), @as(f64, @bitCast(@as(i64, 4648722860373070861))), @as(f64, @bitCast(@as(i64, 4648722093881524906))), @as(f64, @bitCast(@as(i64, 4648721326862213369))), @as(f64, @bitCast(@as(i64, 4648720560458628344))), @as(f64, @bitCast(@as(i64, 4648719793703199598))), @as(f64, @bitCast(@as(i64, 4648719027123692713))), @as(f64, @bitCast(@as(i64, 4648718260544185827))), @as(f64, @bitCast(@as(i64, 4648717493788757081))), @as(f64, @bitCast(@as(i64, 4648716752893841821))), @as(f64, @bitCast(@as(i64, 4648716036891869813))), @as(f64, @bitCast(@as(i64, 4648715321769507108))), @as(f64, @bitCast(@as(i64, 4648718684515869498))), @as(f64, @bitCast(@as(i64, 4648726127769784890))), @as(f64, @bitCast(@as(i64, 4648733570144090980))), @as(f64, @bitCast(@as(i64, 4648741277280797039))), @as(f64, @bitCast(@as(i64, 4648749249179903066))), @as(f64, @bitCast(@as(i64, 4648757221079009093))), @as(f64, @bitCast(@as(i64, 4648765192978115120))), @as(f64, @bitCast(@as(i64, 4648773165141103938))), @as(f64, @bitCast(@as(i64, 4648781137216131826))), @as(f64, @bitCast(@as(i64, 4648789109203198783))), @as(f64, @bitCast(@as(i64, 4648797081190265740))), @as(f64, @bitCast(@as(i64, 4648805053353254558))), @as(f64, @bitCast(@as(i64, 4648813025252360585))), @as(f64, @bitCast(@as(i64, 4648724777041740400))), @as(f64, @bitCast(@as(i64, 4648724010550194445))), @as(f64, @bitCast(@as(i64, 4648723243530882908))), @as(f64, @bitCast(@as(i64, 4648722477039336953))), @as(f64, @bitCast(@as(i64, 4648721710371869137))), @as(f64, @bitCast(@as(i64, 4648720943704401322))), @as(f64, @bitCast(@as(i64, 4648720177212855366))), @as(f64, @bitCast(@as(i64, 4648719410193543830))), @as(f64, @bitCast(@as(i64, 4648718644053841596))), @as(f64, @bitCast(@as(i64, 4648717877034530059))), @as(f64, @bitCast(@as(i64, 4648717110455023174))), @as(f64, @bitCast(@as(i64, 4648716394892855817))), @as(f64, @bitCast(@as(i64, 4648715679154766600))), @as(f64, @bitCast(@as(i64, 4648714963768521104))), @as(f64, @bitCast(@as(i64, 4648722406142827194))), @as(f64, @bitCast(@as(i64, 4648729848868977005))), @as(f64, @bitCast(@as(i64, 4648737291507165886))), @as(f64, @bitCast(@as(i64, 4648745262790545401))), @as(f64, @bitCast(@as(i64, 4648753235569260731))), @as(f64, @bitCast(@as(i64, 4648761206940601177))), @as(f64, @bitCast(@as(i64, 4648769179367472785))), @as(f64, @bitCast(@as(i64, 4648777150914735091))), @as(f64, @bitCast(@as(i64, 4648785123429567630))), @as(f64, @bitCast(@as(i64, 4648793095064790866))), @as(f64, @bitCast(@as(i64, 4648801067403701545))), @as(f64, @bitCast(@as(i64, 4648809038863002921))), @as(f64, @bitCast(@as(i64, 4648817011641718250))), @as(f64, @bitCast(@as(i64, 4653636208489655802))), @as(f64, @bitCast(@as(i64, 4653640193999404165))), @as(f64, @bitCast(@as(i64, 4653644179948957178))), @as(f64, @bitCast(@as(i64, 4653648166338314843))), @as(f64, @bitCast(@as(i64, 4653652152287867856))), @as(f64, @bitCast(@as(i64, 4653656138237420870))), @as(f64, @bitCast(@as(i64, 4653660123747169232))), @as(f64, @bitCast(@as(i64, 4653664109696722246))), @as(f64, @bitCast(@as(i64, 4653668095206470608))), @as(f64, @bitCast(@as(i64, 4653672082035632924))), @as(f64, @bitCast(@as(i64, 4653675124164404655))), @as(f64, @bitCast(@as(i64, 4653677060624283494))), @as(f64, @bitCast(@as(i64, 4653679632601883188))), @as(f64, @bitCast(@as(i64, 4653683001945315344))), @as(f64, @bitCast(@as(i64, 4653686370848942850))), @as(f64, @bitCast(@as(i64, 4653689739752570356))), @as(f64, @bitCast(@as(i64, 4653693109096002512))), @as(f64, @bitCast(@as(i64, 4653696478879239320))), @as(f64, @bitCast(@as(i64, 4653699846903257524))), @as(f64, @bitCast(@as(i64, 4653703216246689681))), @as(f64, @bitCast(@as(i64, 4653706585590121837))), @as(f64, @bitCast(@as(i64, 4653709954493749343))), @as(f64, @bitCast(@as(i64, 4653634214855172319))), @as(f64, @bitCast(@as(i64, 4653638201244529983))), @as(f64, @bitCast(@as(i64, 4653642187194082997))), @as(f64, @bitCast(@as(i64, 4653646172703831359))), @as(f64, @bitCast(@as(i64, 4653650159532993675))), @as(f64, @bitCast(@as(i64, 4653654144602937387))), @as(f64, @bitCast(@as(i64, 4653658130992295051))), @as(f64, @bitCast(@as(i64, 4653662116941848065))), @as(f64, @bitCast(@as(i64, 4653666102451596427))), @as(f64, @bitCast(@as(i64, 4653670088840954092))), @as(f64, @bitCast(@as(i64, 4653674075230311757))), @as(f64, @bitCast(@as(i64, 4653676173098497553))), @as(f64, @bitCast(@as(i64, 4653677948150069435))), @as(f64, @bitCast(@as(i64, 4653681317493501592))), @as(f64, @bitCast(@as(i64, 4653684686397129097))), @as(f64, @bitCast(@as(i64, 4653688055740561254))), @as(f64, @bitCast(@as(i64, 4653691424644188760))), @as(f64, @bitCast(@as(i64, 4653694793987620916))), @as(f64, @bitCast(@as(i64, 4653698162891248422))), @as(f64, @bitCast(@as(i64, 4653701531794875928))), @as(f64, @bitCast(@as(i64, 4653704901138308085))), @as(f64, @bitCast(@as(i64, 4653708270041935590))), @as(f64, @bitCast(@as(i64, 4653711639385367747))), @as(f64, @bitCast(@as(i64, 4654656672268269126))), @as(f64, @bitCast(@as(i64, 4654660040732091980))), @as(f64, @bitCast(@as(i64, 4654663410075524137))), @as(f64, @bitCast(@as(i64, 4654666778979151643))), @as(f64, @bitCast(@as(i64, 4654670147882779148))), @as(f64, @bitCast(@as(i64, 4654673517226211305))), @as(f64, @bitCast(@as(i64, 4654676885690034160))), @as(f64, @bitCast(@as(i64, 4654680255033466316))), @as(f64, @bitCast(@as(i64, 4654683624376898473))), @as(f64, @bitCast(@as(i64, 4654686993280525979))), @as(f64, @bitCast(@as(i64, 4654689564378516370))), @as(f64, @bitCast(@as(i64, 4654691115569520837))), @as(f64, @bitCast(@as(i64, 4654693041034283398))), @as(f64, @bitCast(@as(i64, 4654695564193566818))), @as(f64, @bitCast(@as(i64, 4654698087792654890))), @as(f64, @bitCast(@as(i64, 4654700610512133659))), @as(f64, @bitCast(@as(i64, 4654703133231612428))), @as(f64, @bitCast(@as(i64, 4654705654631677244))), @as(f64, @bitCast(@as(i64, 4654708177351156013))), @as(f64, @bitCast(@as(i64, 4654710700950244085))), @as(f64, @bitCast(@as(i64, 4654713223229918203))), @as(f64, @bitCast(@as(i64, 4654715745949396972))), @as(f64, @bitCast(@as(i64, 4654654987816455373))), @as(f64, @bitCast(@as(i64, 4654658355840473576))), @as(f64, @bitCast(@as(i64, 4654661725183905733))), @as(f64, @bitCast(@as(i64, 4654665094527337890))), @as(f64, @bitCast(@as(i64, 4654668462991160744))), @as(f64, @bitCast(@as(i64, 4654671832334592901))), @as(f64, @bitCast(@as(i64, 4654675201678025058))), @as(f64, @bitCast(@as(i64, 4654678570141847912))), @as(f64, @bitCast(@as(i64, 4654681939485280069))), @as(f64, @bitCast(@as(i64, 4654685308828712226))), @as(f64, @bitCast(@as(i64, 4654688677292535081))), @as(f64, @bitCast(@as(i64, 4654690451024693009))), @as(f64, @bitCast(@as(i64, 4654691780554153316))), @as(f64, @bitCast(@as(i64, 4654694302833827434))), @as(f64, @bitCast(@as(i64, 4654696825993110854))), @as(f64, @bitCast(@as(i64, 4654699349152394274))), @as(f64, @bitCast(@as(i64, 4654701871432068393))), @as(f64, @bitCast(@as(i64, 4654704393711742511))), @as(f64, @bitCast(@as(i64, 4654706915991416629))), @as(f64, @bitCast(@as(i64, 4654709439150700049))), @as(f64, @bitCast(@as(i64, 4654711961430374167))), @as(f64, @bitCast(@as(i64, 4654714484589657588))), @as(f64, @bitCast(@as(i64, 4654717006869331706))), @as(f64, @bitCast(@as(i64, 4655424600656019508))), @as(f64, @bitCast(@as(i64, 4655427122935693627))), @as(f64, @bitCast(@as(i64, 4655429645215367745))), @as(f64, @bitCast(@as(i64, 4655432168374651165))), @as(f64, @bitCast(@as(i64, 4655434691094129934))), @as(f64, @bitCast(@as(i64, 4655437213813608704))), @as(f64, @bitCast(@as(i64, 4655439736972892124))), @as(f64, @bitCast(@as(i64, 4655442258812761591))), @as(f64, @bitCast(@as(i64, 4655444780652631058))), @as(f64, @bitCast(@as(i64, 4655447303811914478))), @as(f64, @bitCast(@as(i64, 4655449230156286342))), @as(f64, @bitCast(@as(i64, 4655450290525300169))), @as(f64, @bitCast(@as(i64, 4655451438855244218))), @as(f64, @bitCast(@as(i64, 4655452942107541714))), @as(f64, @bitCast(@as(i64, 4655454446239448511))), @as(f64, @bitCast(@as(i64, 4655455950811159960))), @as(f64, @bitCast(@as(i64, 4655457454503262106))), @as(f64, @bitCast(@as(i64, 4655458959514778206))), @as(f64, @bitCast(@as(i64, 4655460463646685004))), @as(f64, @bitCast(@as(i64, 4655461967778591801))), @as(f64, @bitCast(@as(i64, 4655463471910498599))), @as(f64, @bitCast(@as(i64, 4655464976482210048))), @as(f64, @bitCast(@as(i64, 4655423338856475473))), @as(f64, @bitCast(@as(i64, 4655425862455563544))), @as(f64, @bitCast(@as(i64, 4655428383415823709))), @as(f64, @bitCast(@as(i64, 4655430906575107129))), @as(f64, @bitCast(@as(i64, 4655433430174195201))), @as(f64, @bitCast(@as(i64, 4655435952453869319))), @as(f64, @bitCast(@as(i64, 4655438475613152739))), @as(f64, @bitCast(@as(i64, 4655440997892826857))), @as(f64, @bitCast(@as(i64, 4655443520172500976))), @as(f64, @bitCast(@as(i64, 4655446042012370443))), @as(f64, @bitCast(@as(i64, 4655448565611458514))), @as(f64, @bitCast(@as(i64, 4655449894261309519))), @as(f64, @bitCast(@as(i64, 4655450685909681517))), @as(f64, @bitCast(@as(i64, 4655452190481392966))), @as(f64, @bitCast(@as(i64, 4655453693733690461))), @as(f64, @bitCast(@as(i64, 4655455199185011212))), @as(f64, @bitCast(@as(i64, 4655456702437308708))), @as(f64, @bitCast(@as(i64, 4655458206569215505))), @as(f64, @bitCast(@as(i64, 4655459712020536256))), @as(f64, @bitCast(@as(i64, 4655461216152443054))), @as(f64, @bitCast(@as(i64, 4655462719404740549))), @as(f64, @bitCast(@as(i64, 4655464223976451998))), @as(f64, @bitCast(@as(i64, 4655465728108358795))), (-@as(f64, @bitCast(@as(i64, 4648550514036479298)))), (-@as(f64, @bitCast(@as(i64, 4648547505948587563)))), (-@as(f64, @bitCast(@as(i64, 4648544497244969317)))), (-@as(f64, @bitCast(@as(i64, 4648541489245038513)))), (-@as(f64, @bitCast(@as(i64, 4648538480717342127)))), (-@as(f64, @bitCast(@as(i64, 4648535472013723881)))), (-@as(f64, @bitCast(@as(i64, 4648532463310105634)))), (-@as(f64, @bitCast(@as(i64, 4648529455310174830)))), (-@as(f64, @bitCast(@as(i64, 4648526446782478444)))), (-@as(f64, @bitCast(@as(i64, 4648523438518664849)))), (-@as(f64, @bitCast(@as(i64, 4648520529650702405)))), (-@as(f64, @bitCast(@as(i64, 4648517721058200414)))), (-@as(f64, @bitCast(@as(i64, 4648514912025893772)))), (-@as(f64, @bitCast(@as(i64, 4648509401713420009)))), (-@as(f64, @bitCast(@as(i64, 4648501189680974476)))), (-@as(f64, @bitCast(@as(i64, 4648492977648528943)))), (-@as(f64, @bitCast(@as(i64, 4648484473585795072)))), (-@as(f64, @bitCast(@as(i64, 4648475677492772864)))), (-@as(f64, @bitCast(@as(i64, 4648466881399750656)))), (-@as(f64, @bitCast(@as(i64, 4648458085306728448)))), (-@as(f64, @bitCast(@as(i64, 4648449289213706240)))), (-@as(f64, @bitCast(@as(i64, 4648440493120684032)))), (-@as(f64, @bitCast(@as(i64, 4648431697027661824)))), (-@as(f64, @bitCast(@as(i64, 4648422900934639616)))), (-@as(f64, @bitCast(@as(i64, 4648414104841617408)))), (-@as(f64, @bitCast(@as(i64, 4648405308748595200)))), (-@as(f64, @bitCast(@as(i64, 4648552018432268886)))), (-@as(f64, @bitCast(@as(i64, 4648549010520299012)))), (-@as(f64, @bitCast(@as(i64, 4648546001640758905)))), (-@as(f64, @bitCast(@as(i64, 4648542993113062520)))), (-@as(f64, @bitCast(@as(i64, 4648539984849248924)))), (-@as(f64, @bitCast(@as(i64, 4648536976585435329)))), (-@as(f64, @bitCast(@as(i64, 4648533967705895223)))), (-@as(f64, @bitCast(@as(i64, 4648530959618003488)))), (-@as(f64, @bitCast(@as(i64, 4648527950914385242)))), (-@as(f64, @bitCast(@as(i64, 4648524942386688856)))), (-@as(f64, @bitCast(@as(i64, 4648521934386758051)))), (-@as(f64, @bitCast(@as(i64, 4648519125354451409)))), (-@as(f64, @bitCast(@as(i64, 4648516316322144767)))), (-@as(f64, @bitCast(@as(i64, 4648513507729642776)))), (-@as(f64, @bitCast(@as(i64, 4648505295697197243)))), (-@as(f64, @bitCast(@as(i64, 4648497083664751709)))), (-@as(f64, @bitCast(@as(i64, 4648488871632306176)))), (-@as(f64, @bitCast(@as(i64, 4648480075539283968)))), (-@as(f64, @bitCast(@as(i64, 4648471279446261760)))), (-@as(f64, @bitCast(@as(i64, 4648462483353239552)))), (-@as(f64, @bitCast(@as(i64, 4648453687260217344)))), (-@as(f64, @bitCast(@as(i64, 4648444891167195136)))), (-@as(f64, @bitCast(@as(i64, 4648436095074172928)))), (-@as(f64, @bitCast(@as(i64, 4648427298981150720)))), (-@as(f64, @bitCast(@as(i64, 4648418502888128512)))), (-@as(f64, @bitCast(@as(i64, 4648409706795106304)))), (-@as(f64, @bitCast(@as(i64, 4648400910702084096)))), @as(f64, @bitCast(@as(i64, 4635648160524001377))), @as(f64, @bitCast(@as(i64, 4635714018631677253))), @as(f64, @bitCast(@as(i64, 4635779876739353128))), @as(f64, @bitCast(@as(i64, 4635845734495185283))), @as(f64, @bitCast(@as(i64, 4635911592251017438))), @as(f64, @bitCast(@as(i64, 4635977450358693314))), @as(f64, @bitCast(@as(i64, 4636043307762681748))), @as(f64, @bitCast(@as(i64, 4636109165166670182))), @as(f64, @bitCast(@as(i64, 4636175023978033499))), @as(f64, @bitCast(@as(i64, 4636240882085709375))), @as(f64, @bitCast(@as(i64, 4636291151124012596))), @as(f64, @bitCast(@as(i64, 4636326931097152148))), @as(f64, @bitCast(@as(i64, 4636380386009979269))), @as(f64, @bitCast(@as(i64, 4636450414873122555))), @as(f64, @bitCast(@as(i64, 4636520443736265840))), @as(f64, @bitCast(@as(i64, 4636590474358627731))), @as(f64, @bitCast(@as(i64, 4636660504980989621))), @as(f64, @bitCast(@as(i64, 4636730534547820349))), @as(f64, @bitCast(@as(i64, 4636800562707276193))), @as(f64, @bitCast(@as(i64, 4636870592977794362))), @as(f64, @bitCast(@as(i64, 4636940624233474950))), @as(f64, @bitCast(@as(i64, 4637010653166986980))), @as(f64, @bitCast(@as(i64, 4635615231470163439))), @as(f64, @bitCast(@as(i64, 4635681089577839315))), @as(f64, @bitCast(@as(i64, 4635746946981827749))), @as(f64, @bitCast(@as(i64, 4635812805793191066))), @as(f64, @bitCast(@as(i64, 4635878663900866942))), @as(f64, @bitCast(@as(i64, 4635944520953011655))), @as(f64, @bitCast(@as(i64, 4636010378708843810))), @as(f64, @bitCast(@as(i64, 4636076236816519686))), @as(f64, @bitCast(@as(i64, 4636142094924195561))), @as(f64, @bitCast(@as(i64, 4636207952750396460))), @as(f64, @bitCast(@as(i64, 4636273810435859871))), @as(f64, @bitCast(@as(i64, 4636308491671427833))), @as(f64, @bitCast(@as(i64, 4636345370522876463))), @as(f64, @bitCast(@as(i64, 4636415401497082074))), @as(f64, @bitCast(@as(i64, 4636485428601006756))), @as(f64, @bitCast(@as(i64, 4636555459223368646))), @as(f64, @bitCast(@as(i64, 4636625490197574257))), @as(f64, @bitCast(@as(i64, 4636695520468092427))), @as(f64, @bitCast(@as(i64, 4636765547220173387))), @as(f64, @bitCast(@as(i64, 4636835577912904022))), @as(f64, @bitCast(@as(i64, 4636905609168584610))), @as(f64, @bitCast(@as(i64, 4636975639439102779))), @as(f64, @bitCast(@as(i64, 4637045666894871181))), @as(f64, @bitCast(@as(i64, 4645454762786349468))), @as(f64, @bitCast(@as(i64, 4645472269650291568))), @as(f64, @bitCast(@as(i64, 4645489777569764831))), @as(f64, @bitCast(@as(i64, 4645507284961472513))), @as(f64, @bitCast(@as(i64, 4645524792880945777))), @as(f64, @bitCast(@as(i64, 4645542300800419040))), @as(f64, @bitCast(@as(i64, 4645559807840283001))), @as(f64, @bitCast(@as(i64, 4645577314880146962))), @as(f64, @bitCast(@as(i64, 4645594822799620225))), @as(f64, @bitCast(@as(i64, 4645612330191327907))), @as(f64, @bitCast(@as(i64, 4645625691808472362))), @as(f64, @bitCast(@as(i64, 4645634872290759640))), @as(f64, @bitCast(@as(i64, 4645648122373444574))), @as(f64, @bitCast(@as(i64, 4645665479351961576))), @as(f64, @bitCast(@as(i64, 4645682837034166020))), @as(f64, @bitCast(@as(i64, 4645700194540448603))), @as(f64, @bitCast(@as(i64, 4645717551694887466))), @as(f64, @bitCast(@as(i64, 4645734908497482607))), @as(f64, @bitCast(@as(i64, 4645752266355608912))), @as(f64, @bitCast(@as(i64, 4645769623685969635))), @as(f64, @bitCast(@as(i64, 4645786980664486637))), @as(f64, @bitCast(@as(i64, 4645804338874456662))), @as(f64, @bitCast(@as(i64, 4645446010321948650))), @as(f64, @bitCast(@as(i64, 4645463515954437727))), @as(f64, @bitCast(@as(i64, 4645481023346145409))), @as(f64, @bitCast(@as(i64, 4645498531265618672))), @as(f64, @bitCast(@as(i64, 4645516038481404494))), @as(f64, @bitCast(@as(i64, 4645533546576799618))), @as(f64, @bitCast(@as(i64, 4645551054496272881))), @as(f64, @bitCast(@as(i64, 4645568561712058702))), @as(f64, @bitCast(@as(i64, 4645586067696391501))), @as(f64, @bitCast(@as(i64, 4645603577551005229))), @as(f64, @bitCast(@as(i64, 4645621082831650585))), @as(f64, @bitCast(@as(i64, 4645630300785294138))), @as(f64, @bitCast(@as(i64, 4645639443268459561))), @as(f64, @bitCast(@as(i64, 4645656801302507726))), @as(f64, @bitCast(@as(i64, 4645674157753259147))), @as(f64, @bitCast(@as(i64, 4645691515963229172))), @as(f64, @bitCast(@as(i64, 4645708872413980593))), @as(f64, @bitCast(@as(i64, 4645726230623950618))), @as(f64, @bitCast(@as(i64, 4645743586371014597))), @as(f64, @bitCast(@as(i64, 4645760945636515785))), @as(f64, @bitCast(@as(i64, 4645778301735423485))), @as(f64, @bitCast(@as(i64, 4645795660297237231))), @as(f64, @bitCast(@as(i64, 4645813016747988652))), @as(f64, @bitCast(@as(i64, 4649198275654937949))), @as(f64, @bitCast(@as(i64, 4649206953880313659))), @as(f64, @bitCast(@as(i64, 4649215632721415881))), @as(f64, @bitCast(@as(i64, 4649224311210674382))), @as(f64, @bitCast(@as(i64, 4649232989787893814))), @as(f64, @bitCast(@as(i64, 4649241668541035105))), @as(f64, @bitCast(@as(i64, 4649250347646020118))), @as(f64, @bitCast(@as(i64, 4649259025871395829))), @as(f64, @bitCast(@as(i64, 4649267704976380841))), @as(f64, @bitCast(@as(i64, 4649276382849912831))), @as(f64, @bitCast(@as(i64, 4649283008946786460))), @as(f64, @bitCast(@as(i64, 4649287403826704076))), @as(f64, @bitCast(@as(i64, 4649293518870573115))), @as(f64, @bitCast(@as(i64, 4649301529472488440))), @as(f64, @bitCast(@as(i64, 4649309542185466090))), @as(f64, @bitCast(@as(i64, 4649317554194756298))), @as(f64, @bitCast(@as(i64, 4649325566555890228))), @as(f64, @bitCast(@as(i64, 4649333578917024157))), @as(f64, @bitCast(@as(i64, 4649341591278158086))), @as(f64, @bitCast(@as(i64, 4649349602759682713))), @as(f64, @bitCast(@as(i64, 4649357616000425945))), @as(f64, @bitCast(@as(i64, 4649365628009716153))), @as(f64, @bitCast(@as(i64, 4649193935662640792))), @as(f64, @bitCast(@as(i64, 4649202615207430455))), @as(f64, @bitCast(@as(i64, 4649211292641157794))), @as(f64, @bitCast(@as(i64, 4649219972097986527))), @as(f64, @bitCast(@as(i64, 4649228650323362238))), @as(f64, @bitCast(@as(i64, 4649237329428347250))), @as(f64, @bitCast(@as(i64, 4649246008885175984))), @as(f64, @bitCast(@as(i64, 4649254686758707973))), @as(f64, @bitCast(@as(i64, 4649263364984083684))), @as(f64, @bitCast(@as(i64, 4649272044089068696))), @as(f64, @bitCast(@as(i64, 4649280722314444407))), @as(f64, @bitCast(@as(i64, 4649285294963402002))), @as(f64, @bitCast(@as(i64, 4649289512602045220))), @as(f64, @bitCast(@as(i64, 4649297523731726126))), @as(f64, @bitCast(@as(i64, 4649305535213250753))), @as(f64, @bitCast(@as(i64, 4649313549333603287))), @as(f64, @bitCast(@as(i64, 4649321560815127914))), @as(f64, @bitCast(@as(i64, 4649329572824418122))), @as(f64, @bitCast(@as(i64, 4649337585537395773))), @as(f64, @bitCast(@as(i64, 4649345596139311097))), @as(f64, @bitCast(@as(i64, 4649353609380054329))), @as(f64, @bitCast(@as(i64, 4649361622620797560))), @as(f64, @bitCast(@as(i64, 4649369634102322187))), @as(f64, @bitCast(@as(i64, 4651617038068519587))), @as(f64, @bitCast(@as(i64, 4651625050341692586))), @as(f64, @bitCast(@as(i64, 4651633062350982794))), @as(f64, @bitCast(@as(i64, 4651641074272312073))), @as(f64, @bitCast(@as(i64, 4651649086193641351))), @as(f64, @bitCast(@as(i64, 4651657098290892489))), @as(f64, @bitCast(@as(i64, 4651665110564065488))), @as(f64, @bitCast(@as(i64, 4651673122837238487))), @as(f64, @bitCast(@as(i64, 4651681135022450556))), @as(f64, @bitCast(@as(i64, 4651689146767857974))), @as(f64, @bitCast(@as(i64, 4651695260404352129))), @as(f64, @bitCast(@as(i64, 4651699159712388874))), @as(f64, @bitCast(@as(i64, 4651704352573865465))), @as(f64, @bitCast(@as(i64, 4651711152569498143))), @as(f64, @bitCast(@as(i64, 4651717951685521519))), @as(f64, @bitCast(@as(i64, 4651724751505232337))), @as(f64, @bitCast(@as(i64, 4651731550973099434))), @as(f64, @bitCast(@as(i64, 4651738350704849322))), @as(f64, @bitCast(@as(i64, 4651745150436599210))), @as(f64, @bitCast(@as(i64, 4651751950344270958))), @as(f64, @bitCast(@as(i64, 4651758750603786427))), @as(f64, @bitCast(@as(i64, 4651765549455927012))), @as(f64, @bitCast(@as(i64, 4651613031360187041))), @as(f64, @bitCast(@as(i64, 4651621044249086552))), @as(f64, @bitCast(@as(i64, 4651629055378767458))), @as(f64, @bitCast(@as(i64, 4651637068707471620))), @as(f64, @bitCast(@as(i64, 4651645078693660433))), @as(f64, @bitCast(@as(i64, 4651653091934403664))), @as(f64, @bitCast(@as(i64, 4651661104295537594))), @as(f64, @bitCast(@as(i64, 4651669117184437104))), @as(f64, @bitCast(@as(i64, 4651677129017805452))), @as(f64, @bitCast(@as(i64, 4651685141378939381))), @as(f64, @bitCast(@as(i64, 4651693152420659357))), @as(f64, @bitCast(@as(i64, 4651697367948240250))), @as(f64, @bitCast(@as(i64, 4651700952004303079))), @as(f64, @bitCast(@as(i64, 4651707753143427851))), @as(f64, @bitCast(@as(i64, 4651714551115959134))), @as(f64, @bitCast(@as(i64, 4651721352255083905))), @as(f64, @bitCast(@as(i64, 4651728150491497979))), @as(f64, @bitCast(@as(i64, 4651734951014896239))), @as(f64, @bitCast(@as(i64, 4651741749954997754))), @as(f64, @bitCast(@as(i64, 4651748549774708572))), @as(f64, @bitCast(@as(i64, 4651755350474028692))), @as(f64, @bitCast(@as(i64, 4651762149941895789))), @as(f64, @bitCast(@as(i64, 4651768948794036375))), @as(f64, @bitCast(@as(i64, 4653276148338275438))), @as(f64, @bitCast(@as(i64, 4653279548468033172))), @as(f64, @bitCast(@as(i64, 4653282948597790907))), @as(f64, @bitCast(@as(i64, 4653286348727548641))), @as(f64, @bitCast(@as(i64, 4653289748417501725))), @as(f64, @bitCast(@as(i64, 4653293148107454808))), @as(f64, @bitCast(@as(i64, 4653296547357603240))), @as(f64, @bitCast(@as(i64, 4653299947927165626))), @as(f64, @bitCast(@as(i64, 4653303347177314058))), @as(f64, @bitCast(@as(i64, 4653306747307071793))), @as(f64, @bitCast(@as(i64, 4653310033087620239))), @as(f64, @bitCast(@as(i64, 4653313203199545442))), @as(f64, @bitCast(@as(i64, 4653316804759833385))), @as(f64, @bitCast(@as(i64, 4653320836009265463))), @as(f64, @bitCast(@as(i64, 4653325012834037059))), @as(f64, @bitCast(@as(i64, 4653329335234148172))), @as(f64, @bitCast(@as(i64, 4653333658074063936))), @as(f64, @bitCast(@as(i64, 4653337980034370398))), @as(f64, @bitCast(@as(i64, 4653342303314090813))), @as(f64, @bitCast(@as(i64, 4653346626154006577))), @as(f64, @bitCast(@as(i64, 4653350948554117690))), @as(f64, @bitCast(@as(i64, 4653355270954228803))), @as(f64, @bitCast(@as(i64, 4653359593354339916))), @as(f64, @bitCast(@as(i64, 4653363916194255680))), @as(f64, @bitCast(@as(i64, 4653274448933103547))), @as(f64, @bitCast(@as(i64, 4653277848183251979))), @as(f64, @bitCast(@as(i64, 4653281248752814365))), @as(f64, @bitCast(@as(i64, 4653284648882572100))), @as(f64, @bitCast(@as(i64, 4653288048132720532))), @as(f64, @bitCast(@as(i64, 4653291448702282917))), @as(f64, @bitCast(@as(i64, 4653294847512626699))), @as(f64, @bitCast(@as(i64, 4653298247642384433))), @as(f64, @bitCast(@as(i64, 4653301648211946819))), @as(f64, @bitCast(@as(i64, 4653305047022290600))), @as(f64, @bitCast(@as(i64, 4653308447591852986))), @as(f64, @bitCast(@as(i64, 4653311618583387492))), @as(f64, @bitCast(@as(i64, 4653314788695312695))), @as(f64, @bitCast(@as(i64, 4653318819944744773))), @as(f64, @bitCast(@as(i64, 4653322852073786153))), @as(f64, @bitCast(@as(i64, 4653327173594287964))), @as(f64, @bitCast(@as(i64, 4653331496434203728))), @as(f64, @bitCast(@as(i64, 4653335818834314841))), @as(f64, @bitCast(@as(i64, 4653340141234425954))), @as(f64, @bitCast(@as(i64, 4653344465393755672))), @as(f64, @bitCast(@as(i64, 4653348786914257483))), @as(f64, @bitCast(@as(i64, 4653353109314368596))), @as(f64, @bitCast(@as(i64, 4653357432154284360))), @as(f64, @bitCast(@as(i64, 4653361754554395473))), @as(f64, @bitCast(@as(i64, 4653366077394311237))), @as(f64, @bitCast(@as(i64, 4654575328199023002))), @as(f64, @bitCast(@as(i64, 4654579650599134115))), @as(f64, @bitCast(@as(i64, 4654583972559440577))), @as(f64, @bitCast(@as(i64, 4654588295399356341))), @as(f64, @bitCast(@as(i64, 4654592618679076756))), @as(f64, @bitCast(@as(i64, 4654596941518992520))), @as(f64, @bitCast(@as(i64, 4654601264358908284))), @as(f64, @bitCast(@as(i64, 4654605586759019397))), @as(f64, @bitCast(@as(i64, 4654609910038739812))), @as(f64, @bitCast(@as(i64, 4654614232438850925))), @as(f64, @bitCast(@as(i64, 4654618409703427172))), @as(f64, @bitCast(@as(i64, 4654622438314031343))), @as(f64, @bitCast(@as(i64, 4654626038554905333))), @as(f64, @bitCast(@as(i64, 4654629210426049141))), @as(f64, @bitCast(@as(i64, 4654632497086206889))), @as(f64, @bitCast(@as(i64, 4654635897655769275))), @as(f64, @bitCast(@as(i64, 4654639296905917707))), @as(f64, @bitCast(@as(i64, 4654642696156066139))), @as(f64, @bitCast(@as(i64, 4654646097165433176))), @as(f64, @bitCast(@as(i64, 4654649495975776957))), @as(f64, @bitCast(@as(i64, 4654652894786120738))), @as(f64, @bitCast(@as(i64, 4654656294915878473))), @as(f64, @bitCast(@as(i64, 4654659695045636207))), @as(f64, @bitCast(@as(i64, 4654663096494807895))), @as(f64, @bitCast(@as(i64, 4654573167878576747))), @as(f64, @bitCast(@as(i64, 4654577489399078558))), @as(f64, @bitCast(@as(i64, 4654581810919580369))), @as(f64, @bitCast(@as(i64, 4654586133759496133))), @as(f64, @bitCast(@as(i64, 4654590457479021199))), @as(f64, @bitCast(@as(i64, 4654594780318936963))), @as(f64, @bitCast(@as(i64, 4654599103158852728))), @as(f64, @bitCast(@as(i64, 4654603425998768492))), @as(f64, @bitCast(@as(i64, 4654607748398879605))), @as(f64, @bitCast(@as(i64, 4654612071238795369))), @as(f64, @bitCast(@as(i64, 4654616394518515784))), @as(f64, @bitCast(@as(i64, 4654620424008729258))), @as(f64, @bitCast(@as(i64, 4654624452619333429))), @as(f64, @bitCast(@as(i64, 4654627624490477237))), @as(f64, @bitCast(@as(i64, 4654630796361621045))), @as(f64, @bitCast(@as(i64, 4654634196931183431))), @as(f64, @bitCast(@as(i64, 4654637597060941165))), @as(f64, @bitCast(@as(i64, 4654640995431480295))), @as(f64, @bitCast(@as(i64, 4654644396001042681))), @as(f64, @bitCast(@as(i64, 4654647796570605067))), @as(f64, @bitCast(@as(i64, 4654651194941144197))), @as(f64, @bitCast(@as(i64, 4654654595070901931))), @as(f64, @bitCast(@as(i64, 4654657994760855015))), @as(f64, @bitCast(@as(i64, 4654661395770222051))), @as(f64, @bitCast(@as(i64, 4654664797219393739))), (-@as(f64, @bitCast(@as(i64, 4649056443932610658)))), (-@as(f64, @bitCast(@as(i64, 4649050716796443899)))), (-@as(f64, @bitCast(@as(i64, 4649044988780667837)))), (-@as(f64, @bitCast(@as(i64, 4649039261644501077)))), (-@as(f64, @bitCast(@as(i64, 4649033534508334318)))), (-@as(f64, @bitCast(@as(i64, 4649027807372167558)))), (-@as(f64, @bitCast(@as(i64, 4649022079356391496)))), (-@as(f64, @bitCast(@as(i64, 4649016352220224736)))), (-@as(f64, @bitCast(@as(i64, 4649010624204448675)))), (-@as(f64, @bitCast(@as(i64, 4649004897420125636)))), (-@as(f64, @bitCast(@as(i64, 4648999360807333737)))), (-@as(f64, @bitCast(@as(i64, 4648994012782776235)))), (-@as(f64, @bitCast(@as(i64, 4648988665198023383)))), (-@as(f64, @bitCast(@as(i64, 4648982148612507881)))), (-@as(f64, @bitCast(@as(i64, 4648974463466034378)))), (-@as(f64, @bitCast(@as(i64, 4648966778055678084)))), (-@as(f64, @bitCast(@as(i64, 4648958819614594381)))), (-@as(f64, @bitCast(@as(i64, 4648950587087252105)))), (-@as(f64, @bitCast(@as(i64, 4648942354647870761)))), (-@as(f64, @bitCast(@as(i64, 4648934122296450346)))), (-@as(f64, @bitCast(@as(i64, 4648925889681147141)))), (-@as(f64, @bitCast(@as(i64, 4648917658297296958)))), (-@as(f64, @bitCast(@as(i64, 4648909425681993753)))), (-@as(f64, @bitCast(@as(i64, 4648901193770377989)))), (-@as(f64, @bitCast(@as(i64, 4648892961506918505)))), (-@as(f64, @bitCast(@as(i64, 4648884729243459020)))), (-@as(f64, @bitCast(@as(i64, 4649059307940498689)))), (-@as(f64, @bitCast(@as(i64, 4649053580364527278)))), (-@as(f64, @bitCast(@as(i64, 4649047852524673077)))), (-@as(f64, @bitCast(@as(i64, 4649042125124623527)))), (-@as(f64, @bitCast(@as(i64, 4649036397636613046)))), (-@as(f64, @bitCast(@as(i64, 4649030671028211868)))), (-@as(f64, @bitCast(@as(i64, 4649024943364279527)))), (-@as(f64, @bitCast(@as(i64, 4649019215788308116)))), (-@as(f64, @bitCast(@as(i64, 4649013488212336706)))), (-@as(f64, @bitCast(@as(i64, 4649007760548404365)))), (-@as(f64, @bitCast(@as(i64, 4649002034291846907)))), (-@as(f64, @bitCast(@as(i64, 4648996686795054986)))), (-@as(f64, @bitCast(@as(i64, 4648991339298263065)))), (-@as(f64, @bitCast(@as(i64, 4648985991625549283)))), (-@as(f64, @bitCast(@as(i64, 4648978306479075780)))), (-@as(f64, @bitCast(@as(i64, 4648970620452992975)))), (-@as(f64, @bitCast(@as(i64, 4648962935306519472)))), (-@as(f64, @bitCast(@as(i64, 4648954703043059987)))), (-@as(f64, @bitCast(@as(i64, 4648946470779600503)))), (-@as(f64, @bitCast(@as(i64, 4648938238516141018)))), (-@as(f64, @bitCast(@as(i64, 4648930006252681534)))), (-@as(f64, @bitCast(@as(i64, 4648921774253104840)))), (-@as(f64, @bitCast(@as(i64, 4648913541725762565)))), (-@as(f64, @bitCast(@as(i64, 4648905309462303080)))), (-@as(f64, @bitCast(@as(i64, 4648897077638648247)))), (-@as(f64, @bitCast(@as(i64, 4648888845287227832)))), (-@as(f64, @bitCast(@as(i64, 4648880612671924627)))), @as(f64, @bitCast(@as(i64, 4622269131337487215))), @as(f64, @bitCast(@as(i64, 4622806938820088825))), @as(f64, @bitCast(@as(i64, 4623344744613840574))), @as(f64, @bitCast(@as(i64, 4623882552096442183))), @as(f64, @bitCast(@as(i64, 4624420357890193932))), @as(f64, @bitCast(@as(i64, 4624958165372795542))), @as(f64, @bitCast(@as(i64, 4625346394800973295))), @as(f64, @bitCast(@as(i64, 4625615297416374193))), @as(f64, @bitCast(@as(i64, 4625884201157674997))), @as(f64, @bitCast(@as(i64, 4626153104617500825))), @as(f64, @bitCast(@as(i64, 4626358361237067817))), @as(f64, @bitCast(@as(i64, 4626491887899469771))), @as(f64, @bitCast(@as(i64, 4626673712571650530))), @as(f64, @bitCast(@as(i64, 4626911924562965782))), @as(f64, @bitCast(@as(i64, 4627150136272806056))), @as(f64, @bitCast(@as(i64, 4627388348545596284))), @as(f64, @bitCast(@as(i64, 4627626560255436559))), @as(f64, @bitCast(@as(i64, 4627864772528226787))), @as(f64, @bitCast(@as(i64, 4628102984801017016))), @as(f64, @bitCast(@as(i64, 4628341196792332267))), @as(f64, @bitCast(@as(i64, 4628579409065122495))), @as(f64, @bitCast(@as(i64, 4628817616552838119))), @as(f64, @bitCast(@as(i64, 4622000228159136364))), @as(f64, @bitCast(@as(i64, 4622538035078788020))), @as(f64, @bitCast(@as(i64, 4623075841998439676))), @as(f64, @bitCast(@as(i64, 4623613648355141379))), @as(f64, @bitCast(@as(i64, 4624151455274793035))), @as(f64, @bitCast(@as(i64, 4624689261631494737))), @as(f64, @bitCast(@as(i64, 4625211943211797869))), @as(f64, @bitCast(@as(i64, 4625480846108673744))), @as(f64, @bitCast(@as(i64, 4625749749287024595))), @as(f64, @bitCast(@as(i64, 4626018652746850423))), @as(f64, @bitCast(@as(i64, 4626287555925201274))), @as(f64, @bitCast(@as(i64, 4626429166830409335))), @as(f64, @bitCast(@as(i64, 4626554608968530206))), @as(f64, @bitCast(@as(i64, 4626792816456245830))), @as(f64, @bitCast(@as(i64, 4627031032388210756))), @as(f64, @bitCast(@as(i64, 4627269240438876333))), @as(f64, @bitCast(@as(i64, 4627507456652316236))), @as(f64, @bitCast(@as(i64, 4627745664702981813))), @as(f64, @bitCast(@as(i64, 4627983880634946738))), @as(f64, @bitCast(@as(i64, 4628222088122662363))), @as(f64, @bitCast(@as(i64, 4628460304054627288))), @as(f64, @bitCast(@as(i64, 4628698512668242819))), @as(f64, @bitCast(@as(i64, 4628936720718908396))), @as(f64, @bitCast(@as(i64, 4644850320782533098))), @as(f64, @bitCast(@as(i64, 4644865209929191790))), @as(f64, @bitCast(@as(i64, 4644880098548084900))), @as(f64, @bitCast(@as(i64, 4644894985759603126))), @as(f64, @bitCast(@as(i64, 4644909874378496237))), @as(f64, @bitCast(@as(i64, 4644924761590014463))), @as(f64, @bitCast(@as(i64, 4644939650208907573))), @as(f64, @bitCast(@as(i64, 4644954538827800683))), @as(f64, @bitCast(@as(i64, 4644969427270771933))), @as(f64, @bitCast(@as(i64, 4644984315713743183))), @as(f64, @bitCast(@as(i64, 4644998702779412167))), @as(f64, @bitCast(@as(i64, 4645012588467778885))), @as(f64, @bitCast(@as(i64, 4645027341626839453))), @as(f64, @bitCast(@as(i64, 4645042960849218988))), @as(f64, @bitCast(@as(i64, 4645059144780770548))), @as(f64, @bitCast(@as(i64, 4645075894301103437))), @as(f64, @bitCast(@as(i64, 4645092642414061442))), @as(f64, @bitCast(@as(i64, 4645109391054785028))), @as(f64, @bitCast(@as(i64, 4645126139871430474))), @as(f64, @bitCast(@as(i64, 4645142889215841502))), @as(f64, @bitCast(@as(i64, 4645159637856565089))), @as(f64, @bitCast(@as(i64, 4645176387904663559))), @as(f64, @bitCast(@as(i64, 4645193137073152726))), @as(f64, @bitCast(@as(i64, 4645209885186110731))), @as(f64, @bitCast(@as(i64, 4644842876649008404))), @as(f64, @bitCast(@as(i64, 4644857765619745235))), @as(f64, @bitCast(@as(i64, 4644872654062716484))), @as(f64, @bitCast(@as(i64, 4644887542153844013))), @as(f64, @bitCast(@as(i64, 4644902430069049682))), @as(f64, @bitCast(@as(i64, 4644917318336099071))), @as(f64, @bitCast(@as(i64, 4644932205371695437))), @as(f64, @bitCast(@as(i64, 4644947094518354128))), @as(f64, @bitCast(@as(i64, 4644961983137247239))), @as(f64, @bitCast(@as(i64, 4644976871404296628))), @as(f64, @bitCast(@as(i64, 4644991759671346017))), @as(f64, @bitCast(@as(i64, 4645005645711556456))), @as(f64, @bitCast(@as(i64, 4645019532455454337))), @as(f64, @bitCast(@as(i64, 4645035150798224569))), @as(f64, @bitCast(@as(i64, 4645050770900213406))), @as(f64, @bitCast(@as(i64, 4645067519013171411))), @as(f64, @bitCast(@as(i64, 4645084268709426160))), @as(f64, @bitCast(@as(i64, 4645101016470540444))), @as(f64, @bitCast(@as(i64, 4645117765814951472))), @as(f64, @bitCast(@as(i64, 4645134514455675058))), @as(f64, @bitCast(@as(i64, 4645151263272320505))), @as(f64, @bitCast(@as(i64, 4645168012616731533))), @as(f64, @bitCast(@as(i64, 4645184763016673724))), @as(f64, @bitCast(@as(i64, 4645201510601866147))), @as(f64, @bitCast(@as(i64, 4645218260474042757))), @as(f64, @bitCast(@as(i64, 4648804820256789470))), @as(f64, @bitCast(@as(i64, 4648813194137346612))), @as(f64, @bitCast(@as(i64, 4648821568897513056))), @as(f64, @bitCast(@as(i64, 4648829943657679500))), @as(f64, @bitCast(@as(i64, 4648838317538236642))), @as(f64, @bitCast(@as(i64, 4648846691770637505))), @as(f64, @bitCast(@as(i64, 4648855067058569531))), @as(f64, @bitCast(@as(i64, 4648863440939126673))), @as(f64, @bitCast(@as(i64, 4648871815699293117))), @as(f64, @bitCast(@as(i64, 4648880190459459561))), @as(f64, @bitCast(@as(i64, 4648888281985430690))), @as(f64, @bitCast(@as(i64, 4648896092476229760))), @as(f64, @bitCast(@as(i64, 4648903469319642835))), @as(f64, @bitCast(@as(i64, 4648910410844412240))), @as(f64, @bitCast(@as(i64, 4648917603761520221))), @as(f64, @bitCast(@as(i64, 4648925047895044915))), @as(f64, @bitCast(@as(i64, 4648932493435944493))), @as(f64, @bitCast(@as(i64, 4648939937921312909))), @as(f64, @bitCast(@as(i64, 4648947380823384580))), @as(f64, @bitCast(@as(i64, 4648954824429143694))), @as(f64, @bitCast(@as(i64, 4648962268826551179))), @as(f64, @bitCast(@as(i64, 4648969713575802385))), @as(f64, @bitCast(@as(i64, 4648977157709327080))), @as(f64, @bitCast(@as(i64, 4648984601842851774))), @as(f64, @bitCast(@as(i64, 4648800632436901596))), @as(f64, @bitCast(@as(i64, 4648809007197068041))), @as(f64, @bitCast(@as(i64, 4648817381077625183))), @as(f64, @bitCast(@as(i64, 4648825756717400929))), @as(f64, @bitCast(@as(i64, 4648834130597958071))), @as(f64, @bitCast(@as(i64, 4648842504478515213))), @as(f64, @bitCast(@as(i64, 4648850879238681657))), @as(f64, @bitCast(@as(i64, 4648859253998848102))), @as(f64, @bitCast(@as(i64, 4648867628759014546))), @as(f64, @bitCast(@as(i64, 4648876002639571688))), @as(f64, @bitCast(@as(i64, 4648884377399738132))), @as(f64, @bitCast(@as(i64, 4648892187450732551))), @as(f64, @bitCast(@as(i64, 4648899997501726969))), @as(f64, @bitCast(@as(i64, 4648906940257949398))), @as(f64, @bitCast(@as(i64, 4648913882134562524))), @as(f64, @bitCast(@as(i64, 4648921326004204428))), @as(f64, @bitCast(@as(i64, 4648928770753455635))), @as(f64, @bitCast(@as(i64, 4648936215414745910))), @as(f64, @bitCast(@as(i64, 4648943659284387814))), @as(f64, @bitCast(@as(i64, 4648951102450342277))), @as(f64, @bitCast(@as(i64, 4648958546935710692))), @as(f64, @bitCast(@as(i64, 4648965991069235387))), @as(f64, @bitCast(@as(i64, 4648973435730525663))), @as(f64, @bitCast(@as(i64, 4648980879336284776))), @as(f64, @bitCast(@as(i64, 4648988323469809471))), @as(f64, @bitCast(@as(i64, 4651057656250232734))), @as(f64, @bitCast(@as(i64, 4651065099855991847))), @as(f64, @bitCast(@as(i64, 4651072543637672821))), @as(f64, @bitCast(@as(i64, 4651079987771197515))), @as(f64, @bitCast(@as(i64, 4651087431904722210))), @as(f64, @bitCast(@as(i64, 4651094876302129695))), @as(f64, @bitCast(@as(i64, 4651102319292162297))), @as(f64, @bitCast(@as(i64, 4651109764305296294))), @as(f64, @bitCast(@as(i64, 4651117208438820989))), @as(f64, @bitCast(@as(i64, 4651124652572345683))), @as(f64, @bitCast(@as(i64, 4651131846017219245))), @as(f64, @bitCast(@as(i64, 4651138786134613767))), @as(f64, @bitCast(@as(i64, 4651146161658612888))), @as(f64, @bitCast(@as(i64, 4651153972941060330))), @as(f64, @bitCast(@as(i64, 4651162066226250064))), @as(f64, @bitCast(@as(i64, 4651170441953986740))), @as(f64, @bitCast(@as(i64, 4651178816274348533))), @as(f64, @bitCast(@as(i64, 4651187190154905675))), @as(f64, @bitCast(@as(i64, 4651195564299345608))), @as(f64, @bitCast(@as(i64, 4651203939675238564))), @as(f64, @bitCast(@as(i64, 4651212313555795706))), @as(f64, @bitCast(@as(i64, 4651220687700235639))), @as(f64, @bitCast(@as(i64, 4651229063076128594))), @as(f64, @bitCast(@as(i64, 4651237437572412248))), @as(f64, @bitCast(@as(i64, 4651053933743665735))), @as(f64, @bitCast(@as(i64, 4651061378229034151))), @as(f64, @bitCast(@as(i64, 4651068821482949543))), @as(f64, @bitCast(@as(i64, 4651076265264630517))), @as(f64, @bitCast(@as(i64, 4651083709925920793))), @as(f64, @bitCast(@as(i64, 4651091154763132929))), @as(f64, @bitCast(@as(i64, 4651098597665204601))), @as(f64, @bitCast(@as(i64, 4651106041798729295))), @as(f64, @bitCast(@as(i64, 4651113486811863292))), @as(f64, @bitCast(@as(i64, 4651120930065778685))), @as(f64, @bitCast(@as(i64, 4651128375430756402))), @as(f64, @bitCast(@as(i64, 4651135315548150925))), @as(f64, @bitCast(@as(i64, 4651142256193311028))), @as(f64, @bitCast(@as(i64, 4651150067123914749))), @as(f64, @bitCast(@as(i64, 4651157878670244981))), @as(f64, @bitCast(@as(i64, 4651166254573903518))), @as(f64, @bitCast(@as(i64, 4651174629070187172))), @as(f64, @bitCast(@as(i64, 4651183003654431755))), @as(f64, @bitCast(@as(i64, 4651191376743340525))), @as(f64, @bitCast(@as(i64, 4651199751855350691))), @as(f64, @bitCast(@as(i64, 4651208126615517135))), @as(f64, @bitCast(@as(i64, 4651216500496074277))), @as(f64, @bitCast(@as(i64, 4651224875256240721))), @as(f64, @bitCast(@as(i64, 4651233250544172747))), @as(f64, @bitCast(@as(i64, 4651241624776573610))), @as(f64, @bitCast(@as(i64, 4652899160985483136))), @as(f64, @bitCast(@as(i64, 4652903347925761707))), @as(f64, @bitCast(@as(i64, 4652907535745649580))), @as(f64, @bitCast(@as(i64, 4652911723125732803))), @as(f64, @bitCast(@as(i64, 4652915910066011374))), @as(f64, @bitCast(@as(i64, 4652920097006289945))), @as(f64, @bitCast(@as(i64, 4652924284386373167))), @as(f64, @bitCast(@as(i64, 4652928471766456389))), @as(f64, @bitCast(@as(i64, 4652932659586344262))), @as(f64, @bitCast(@as(i64, 4652936846526622833))), @as(f64, @bitCast(@as(i64, 4652940892289608398))), @as(f64, @bitCast(@as(i64, 4652944796435496305))), @as(f64, @bitCast(@as(i64, 4652948484197495865))), @as(f64, @bitCast(@as(i64, 4652951955575607080))), @as(f64, @bitCast(@as(i64, 4652955552737848512))), @as(f64, @bitCast(@as(i64, 4652959275244415510))), @as(f64, @bitCast(@as(i64, 4652962998190787160))), @as(f64, @bitCast(@as(i64, 4652966719817744856))), @as(f64, @bitCast(@as(i64, 4652970441884507203))), @as(f64, @bitCast(@as(i64, 4652974163951269550))), @as(f64, @bitCast(@as(i64, 4652977885578227247))), @as(f64, @bitCast(@as(i64, 4652981607205184943))), @as(f64, @bitCast(@as(i64, 4652985329711751941))), @as(f64, @bitCast(@as(i64, 4652989051778514289))), @as(f64, @bitCast(@as(i64, 4652897068394953153))), @as(f64, @bitCast(@as(i64, 4652901254015817771))), @as(f64, @bitCast(@as(i64, 4652905441835705644))), @as(f64, @bitCast(@as(i64, 4652909629655593517))), @as(f64, @bitCast(@as(i64, 4652913817035676739))), @as(f64, @bitCast(@as(i64, 4652918003536150659))), @as(f64, @bitCast(@as(i64, 4652922190476429230))), @as(f64, @bitCast(@as(i64, 4652926378736121754))), @as(f64, @bitCast(@as(i64, 4652930565676400325))), @as(f64, @bitCast(@as(i64, 4652934752616678896))), @as(f64, @bitCast(@as(i64, 4652938940436566770))), @as(f64, @bitCast(@as(i64, 4652942844582454677))), @as(f64, @bitCast(@as(i64, 4652946748728342584))), @as(f64, @bitCast(@as(i64, 4652950220106453798))), @as(f64, @bitCast(@as(i64, 4652953691484565012))), @as(f64, @bitCast(@as(i64, 4652957414430936662))), @as(f64, @bitCast(@as(i64, 4652961136937503660))), @as(f64, @bitCast(@as(i64, 4652964859004266008))), @as(f64, @bitCast(@as(i64, 4652968580631223704))), @as(f64, @bitCast(@as(i64, 4652972303137790702))), @as(f64, @bitCast(@as(i64, 4652976024764748399))), @as(f64, @bitCast(@as(i64, 4652979745951901444))), @as(f64, @bitCast(@as(i64, 4652983468458468442))), @as(f64, @bitCast(@as(i64, 4652987190965035441))), @as(f64, @bitCast(@as(i64, 4652990912591993137))), @as(f64, @bitCast(@as(i64, 4654025578542400117))), @as(f64, @bitCast(@as(i64, 4654029301048967116))), @as(f64, @bitCast(@as(i64, 4654033022675924812))), @as(f64, @bitCast(@as(i64, 4654036744742687159))), @as(f64, @bitCast(@as(i64, 4654040466369644855))), @as(f64, @bitCast(@as(i64, 4654044188436407203))), @as(f64, @bitCast(@as(i64, 4654047910942974201))), @as(f64, @bitCast(@as(i64, 4654051633449541199))), @as(f64, @bitCast(@as(i64, 4654055355516303547))), @as(f64, @bitCast(@as(i64, 4654059077583065894))), @as(f64, @bitCast(@as(i64, 4654062673865698024))), @as(f64, @bitCast(@as(i64, 4654066144364199936))), @as(f64, @bitCast(@as(i64, 4654069832566004148))), @as(f64, @bitCast(@as(i64, 4654073738031306008))), @as(f64, @bitCast(@as(i64, 4654077784234096224))), @as(f64, @bitCast(@as(i64, 4654081972053984097))), @as(f64, @bitCast(@as(i64, 4654086158994262668))), @as(f64, @bitCast(@as(i64, 4654090346374345890))), @as(f64, @bitCast(@as(i64, 4654094533754429112))), @as(f64, @bitCast(@as(i64, 4654098720694707683))), @as(f64, @bitCast(@as(i64, 4654102908074790905))), @as(f64, @bitCast(@as(i64, 4654107094575264825))), @as(f64, @bitCast(@as(i64, 4654111282834957350))), @as(f64, @bitCast(@as(i64, 4654115469775235921))), @as(f64, @bitCast(@as(i64, 4654023717728921269))), @as(f64, @bitCast(@as(i64, 4654027440235488267))), @as(f64, @bitCast(@as(i64, 4654031161862445964))), @as(f64, @bitCast(@as(i64, 4654034883929208311))), @as(f64, @bitCast(@as(i64, 4654038605556166007))), @as(f64, @bitCast(@as(i64, 4654042327183123703))), @as(f64, @bitCast(@as(i64, 4654046050569300004))), @as(f64, @bitCast(@as(i64, 4654049772636062351))), @as(f64, @bitCast(@as(i64, 4654053494263020048))), @as(f64, @bitCast(@as(i64, 4654057217209391697))), @as(f64, @bitCast(@as(i64, 4654060937956740091))), @as(f64, @bitCast(@as(i64, 4654064409334851305))), @as(f64, @bitCast(@as(i64, 4654067880273157869))), @as(f64, @bitCast(@as(i64, 4654071785298655078))), @as(f64, @bitCast(@as(i64, 4654075690324152287))), @as(f64, @bitCast(@as(i64, 4654079878144040160))), @as(f64, @bitCast(@as(i64, 4654084065524123383))), @as(f64, @bitCast(@as(i64, 4654088252904206605))), @as(f64, @bitCast(@as(i64, 4654092440284289827))), @as(f64, @bitCast(@as(i64, 4654096626784763747))), @as(f64, @bitCast(@as(i64, 4654100815044456271))), @as(f64, @bitCast(@as(i64, 4654105001105125540))), @as(f64, @bitCast(@as(i64, 4654109188925013413))), @as(f64, @bitCast(@as(i64, 4654113376744901286))), @as(f64, @bitCast(@as(i64, 4654117563245375206))), (-@as(f64, @bitCast(@as(i64, 4643585018634255917)))), (-@as(f64, @bitCast(@as(i64, 4643567439994194756)))), (-@as(f64, @bitCast(@as(i64, 4643549860650446152)))), (-@as(f64, @bitCast(@as(i64, 4643532281306697548)))), (-@as(f64, @bitCast(@as(i64, 4643514701435183364)))), (-@as(f64, @bitCast(@as(i64, 4643497122267356620)))), (-@as(f64, @bitCast(@as(i64, 4643479542747686156)))), (-@as(f64, @bitCast(@as(i64, 4643461963579859413)))), (-@as(f64, @bitCast(@as(i64, 4643444384412032670)))), (-@as(f64, @bitCast(@as(i64, 4643426804892362206)))), (-@as(f64, @bitCast(@as(i64, 4643413386980222409)))), (-@as(f64, @bitCast(@as(i64, 4643404333161674650)))), (-@as(f64, @bitCast(@as(i64, 4643391504587767341)))), (-@as(f64, @bitCast(@as(i64, 4643374697892829809)))), (-@as(f64, @bitCast(@as(i64, 4643357891021970415)))), (-@as(f64, @bitCast(@as(i64, 4643341084854798464)))), (-@as(f64, @bitCast(@as(i64, 4643324278687626512)))), (-@as(f64, @bitCast(@as(i64, 4643307471992688979)))), (-@as(f64, @bitCast(@as(i64, 4643290665121829586)))), (-@as(f64, @bitCast(@as(i64, 4643273858954657635)))), (-@as(f64, @bitCast(@as(i64, 4643257052787485683)))), (-@as(f64, @bitCast(@as(i64, 4643240246444391871)))), (-@as(f64, @bitCast(@as(i64, 4643593808218169289)))), (-@as(f64, @bitCast(@as(i64, 4643576229578108127)))), (-@as(f64, @bitCast(@as(i64, 4643558650234359524)))), (-@as(f64, @bitCast(@as(i64, 4643541071066532780)))), (-@as(f64, @bitCast(@as(i64, 4643523491546862316)))), (-@as(f64, @bitCast(@as(i64, 4643505911851269992)))), (-@as(f64, @bitCast(@as(i64, 4643488333211208830)))), (-@as(f64, @bitCast(@as(i64, 4643470753339694645)))), (-@as(f64, @bitCast(@as(i64, 4643453173820024181)))), (-@as(f64, @bitCast(@as(i64, 4643435594652197438)))), (-@as(f64, @bitCast(@as(i64, 4643418015484370695)))), (-@as(f64, @bitCast(@as(i64, 4643408758476074123)))), (-@as(f64, @bitCast(@as(i64, 4643399907847275178)))), (-@as(f64, @bitCast(@as(i64, 4643383100976415784)))), (-@as(f64, @bitCast(@as(i64, 4643366294809243833)))), (-@as(f64, @bitCast(@as(i64, 4643349487938384440)))), (-@as(f64, @bitCast(@as(i64, 4643332681771212488)))), (-@as(f64, @bitCast(@as(i64, 4643315875252196816)))), (-@as(f64, @bitCast(@as(i64, 4643299068909103004)))), (-@as(f64, @bitCast(@as(i64, 4643282261862321750)))), (-@as(f64, @bitCast(@as(i64, 4643265456046993519)))), (-@as(f64, @bitCast(@as(i64, 4643248649703899707)))), (-@as(f64, @bitCast(@as(i64, 4643231843008962175)))), @as(f64, @bitCast(@as(i64, 4640906639447162880))), @as(f64, @bitCast(@as(i64, 4640941823819251712))), @as(f64, @bitCast(@as(i64, 4640977008191340544))), @as(f64, @bitCast(@as(i64, 4641012192563429376))), @as(f64, @bitCast(@as(i64, 4641047376935518208))), @as(f64, @bitCast(@as(i64, 4641082561307607040))), @as(f64, @bitCast(@as(i64, 4641117745679695872))), @as(f64, @bitCast(@as(i64, 4641152930051784704))), @as(f64, @bitCast(@as(i64, 4641188114423873536))), @as(f64, @bitCast(@as(i64, 4641223298795962368))), @as(f64, @bitCast(@as(i64, 4641257297806555527))), @as(f64, @bitCast(@as(i64, 4641290111455653014))), @as(f64, @bitCast(@as(i64, 4641317063388360501))), @as(f64, @bitCast(@as(i64, 4641338155715740314))), @as(f64, @bitCast(@as(i64, 4641360010840307013))), @as(f64, @bitCast(@as(i64, 4641382626650998272))), @as(f64, @bitCast(@as(i64, 4641405242109845811))), @as(f64, @bitCast(@as(i64, 4641427858272380791))), @as(f64, @bitCast(@as(i64, 4641450474083072050))), @as(f64, @bitCast(@as(i64, 4641473089893763310))), @as(f64, @bitCast(@as(i64, 4641495706759985732))), @as(f64, @bitCast(@as(i64, 4641518323274364433))), @as(f64, @bitCast(@as(i64, 4641540939085055693))), @as(f64, @bitCast(@as(i64, 4641563554543903231))), @as(f64, @bitCast(@as(i64, 4640889047261118464))), @as(f64, @bitCast(@as(i64, 4640924231633207296))), @as(f64, @bitCast(@as(i64, 4640959416005296128))), @as(f64, @bitCast(@as(i64, 4640994600377384960))), @as(f64, @bitCast(@as(i64, 4641029784749473792))), @as(f64, @bitCast(@as(i64, 4641064969121562624))), @as(f64, @bitCast(@as(i64, 4641100153493651456))), @as(f64, @bitCast(@as(i64, 4641135337865740288))), @as(f64, @bitCast(@as(i64, 4641170522237829120))), @as(f64, @bitCast(@as(i64, 4641205706609917952))), @as(f64, @bitCast(@as(i64, 4641240890982006784))), @as(f64, @bitCast(@as(i64, 4641273704631104270))), @as(f64, @bitCast(@as(i64, 4641306517576514315))), @as(f64, @bitCast(@as(i64, 4641327609552050407))), @as(f64, @bitCast(@as(i64, 4641348702231273941))), @as(f64, @bitCast(@as(i64, 4641371318393808922))), @as(f64, @bitCast(@as(i64, 4641393934556343902))), @as(f64, @bitCast(@as(i64, 4641416550718878882))), @as(f64, @bitCast(@as(i64, 4641439165825882700))), @as(f64, @bitCast(@as(i64, 4641461781988417680))), @as(f64, @bitCast(@as(i64, 4641484398502796381))), @as(f64, @bitCast(@as(i64, 4641507014665331362))), @as(f64, @bitCast(@as(i64, 4641529630827866342))), @as(f64, @bitCast(@as(i64, 4641552246990401322))), @as(f64, @bitCast(@as(i64, 4641574863504780024))), @as(f64, @bitCast(@as(i64, 4645511038782130671))), @as(f64, @bitCast(@as(i64, 4645522347391163742))), @as(f64, @bitCast(@as(i64, 4645533654944665651))), @as(f64, @bitCast(@as(i64, 4645544963025933141))), @as(f64, @bitCast(@as(i64, 4645556271107200631))), @as(f64, @bitCast(@as(i64, 4645567578836624401))), @as(f64, @bitCast(@as(i64, 4645578887445657472))), @as(f64, @bitCast(@as(i64, 4645590194823237521))), @as(f64, @bitCast(@as(i64, 4645601503608192453))), @as(f64, @bitCast(@as(i64, 4645612811337616222))), @as(f64, @bitCast(@as(i64, 4645623738723977711))), @as(f64, @bitCast(@as(i64, 4645634283832136455))), @as(f64, @bitCast(@as(i64, 4645647760502177640))), @as(f64, @bitCast(@as(i64, 4645664167150804523))), @as(f64, @bitCast(@as(i64, 4645681166656101102))), @as(f64, @bitCast(@as(i64, 4645698758842145518))), @as(f64, @bitCast(@as(i64, 4645716351028189934))), @as(f64, @bitCast(@as(i64, 4645733943741999932))), @as(f64, @bitCast(@as(i64, 4645751535400278766))), @as(f64, @bitCast(@as(i64, 4645769127586323182))), @as(f64, @bitCast(@as(i64, 4645786719772367598))), @as(f64, @bitCast(@as(i64, 4645804311958412014))), @as(f64, @bitCast(@as(i64, 4645821904144456430))), @as(f64, @bitCast(@as(i64, 4645839496330500846))), @as(f64, @bitCast(@as(i64, 4645505385005379716))), @as(f64, @bitCast(@as(i64, 4645516692910725346))), @as(f64, @bitCast(@as(i64, 4645528000640149115))), @as(f64, @bitCast(@as(i64, 4645539309425104047))), @as(f64, @bitCast(@as(i64, 4645550616802684096))), @as(f64, @bitCast(@as(i64, 4645561925587639028))), @as(f64, @bitCast(@as(i64, 4645573233141140936))), @as(f64, @bitCast(@as(i64, 4645584541222408427))), @as(f64, @bitCast(@as(i64, 4645595849303675917))), @as(f64, @bitCast(@as(i64, 4645607156857177826))), @as(f64, @bitCast(@as(i64, 4645618465466210897))), @as(f64, @bitCast(@as(i64, 4645629011278057083))), @as(f64, @bitCast(@as(i64, 4645639557089903268))), @as(f64, @bitCast(@as(i64, 4645655963738530151))), @as(f64, @bitCast(@as(i64, 4645672370563078894))), @as(f64, @bitCast(@as(i64, 4645689962749123310))), @as(f64, @bitCast(@as(i64, 4645707554935167726))), @as(f64, @bitCast(@as(i64, 4645725147648977724))), @as(f64, @bitCast(@as(i64, 4645742739307256558))), @as(f64, @bitCast(@as(i64, 4645760331493300974))), @as(f64, @bitCast(@as(i64, 4645777923679345390))), @as(f64, @bitCast(@as(i64, 4645795515865389806))), @as(f64, @bitCast(@as(i64, 4645813108051434222))), @as(f64, @bitCast(@as(i64, 4645830700237478638))), @as(f64, @bitCast(@as(i64, 4645848292423523054))), (-@as(f64, @bitCast(@as(i64, 4637382618759904159)))), (-@as(f64, @bitCast(@as(i64, 4637337387560734105)))), (-@as(f64, @bitCast(@as(i64, 4637292154954189168)))), (-@as(f64, @bitCast(@as(i64, 4637246922488381719)))), (-@as(f64, @bitCast(@as(i64, 4637201690585524223)))), (-@as(f64, @bitCast(@as(i64, 4637156458260454263)))), (-@as(f64, @bitCast(@as(i64, 4637111226216859279)))), (-@as(f64, @bitCast(@as(i64, 4637065993610314341)))), (-@as(f64, @bitCast(@as(i64, 4637020761988931823)))), (-@as(f64, @bitCast(@as(i64, 4636975529945336839)))), (-@as(f64, @bitCast(@as(i64, 4636931821525790789)))), (-@as(f64, @bitCast(@as(i64, 4636889636871031163)))), (-@as(f64, @bitCast(@as(i64, 4636835732020453771)))), (-@as(f64, @bitCast(@as(i64, 4636770105003733774)))), (-@as(f64, @bitCast(@as(i64, 4636702106982547456)))), (-@as(f64, @bitCast(@as(i64, 4636631738238369792)))), (-@as(f64, @bitCast(@as(i64, 4636561369494192128)))), (-@as(f64, @bitCast(@as(i64, 4636491000750014464)))), (-@as(f64, @bitCast(@as(i64, 4636420632005836800)))), (-@as(f64, @bitCast(@as(i64, 4636350263261659136)))), (-@as(f64, @bitCast(@as(i64, 4636279894517481472)))), (-@as(f64, @bitCast(@as(i64, 4636209525773303808)))), (-@as(f64, @bitCast(@as(i64, 4636139157029126144)))), (-@as(f64, @bitCast(@as(i64, 4636068788284948480)))), (-@as(f64, @bitCast(@as(i64, 4637405234992807884)))), (-@as(f64, @bitCast(@as(i64, 4637360003371425365)))), (-@as(f64, @bitCast(@as(i64, 4637314771046355404)))), (-@as(f64, @bitCast(@as(i64, 4637269538721285443)))), (-@as(f64, @bitCast(@as(i64, 4637224306818427948)))), (-@as(f64, @bitCast(@as(i64, 4637179074352620499)))), (-@as(f64, @bitCast(@as(i64, 4637133842449763003)))), (-@as(f64, @bitCast(@as(i64, 4637088610124693043)))), (-@as(f64, @bitCast(@as(i64, 4637043378503310524)))), (-@as(f64, @bitCast(@as(i64, 4636998145122709400)))), (-@as(f64, @bitCast(@as(i64, 4636952913853170602)))), (-@as(f64, @bitCast(@as(i64, 4636910729902098418)))), (-@as(f64, @bitCast(@as(i64, 4636868545247338792)))), (-@as(f64, @bitCast(@as(i64, 4636802918652831261)))), (-@as(f64, @bitCast(@as(i64, 4636737291354636288)))), (-@as(f64, @bitCast(@as(i64, 4636666922610458624)))), (-@as(f64, @bitCast(@as(i64, 4636596553866280960)))), (-@as(f64, @bitCast(@as(i64, 4636526185122103296)))), (-@as(f64, @bitCast(@as(i64, 4636455816377925632)))), (-@as(f64, @bitCast(@as(i64, 4636385447633747968)))), (-@as(f64, @bitCast(@as(i64, 4636315078889570304)))), (-@as(f64, @bitCast(@as(i64, 4636244710145392640)))), (-@as(f64, @bitCast(@as(i64, 4636174341401214976)))), (-@as(f64, @bitCast(@as(i64, 4636103972657037312)))), (-@as(f64, @bitCast(@as(i64, 4636033603912859648)))) });
}

fn g_sc_place() *CxList(f64) {
    @setEvalBranchQuota(1000000);
    return cx_ll_of(f64, &[_]f64{ @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4617202927970916762)))), @as(f64, @bitCast(@as(i64, 4613487458278336102))), @as(f64, @bitCast(@as(i64, 4644231562609557504))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4608983858650965606))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4617202927970916762))), @as(f64, @bitCast(@as(i64, 4613487458278336102))), @as(f64, @bitCast(@as(i64, 4644231562609557504))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4608983858650965606))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4618159942891732992)))), @as(f64, @bitCast(@as(i64, 4616752568008179712))), @as(f64, @bitCast(@as(i64, 4644231562609557504))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4612248968380809216))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4618159942891732992))), @as(f64, @bitCast(@as(i64, 4616752568008179712))), @as(f64, @bitCast(@as(i64, 4644231562609557504))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4612248968380809216))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4616527388026811187)))), @as(f64, @bitCast(@as(i64, 4609884578576439706))), @as(f64, @bitCast(@as(i64, 4644231562609557504))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4605380978949069210))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4616527388026811187))), @as(f64, @bitCast(@as(i64, 4609884578576439706))), @as(f64, @bitCast(@as(i64, 4644231562609557504))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4605380978949069210))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4616865157998863974)))), @as(f64, @bitCast(@as(i64, 4612136378390124954))), @as(f64, @bitCast(@as(i64, 4644231562609557504))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4607632778762754458))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4616865157998863974))), @as(f64, @bitCast(@as(i64, 4612136378390124954))), @as(f64, @bitCast(@as(i64, 4644231562609557504))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4607632778762754458))) });
}

fn segs() *CxList(Segment) {
    return build_world();
}

fn n_segs() i64 {
    return cx_list_len(segs());
}

fn chain_flat(i_: i64) *CxList(i64) {
    return (if ((i_ >= n_segs())) cx_ll_empty(i64) else cx_ll_concat(build_chain(segs(), i_), chain_flat((i_ +% 1))));
}

fn chain_lens(i_: i64) *CxList(i64) {
    return (if ((i_ >= n_segs())) cx_ll_empty(i64) else cx_ll_concat(cx_ll_of(i64, &[_]i64{ cx_list_len(build_chain(segs(), i_)) }), chain_lens((i_ +% 1))));
}

fn rendercheck_tower_beyond() f64 {
    return @as(f64, @bitCast(@as(i64, 4639833516098453504)));
}

fn rendercheck_tower_right() f64 {
    return @as(f64, @bitCast(@as(i64, 4626322717216342016)));
}

fn sample_as(s_: Segment) *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ @as(f64, @bitCast(@as(i64, 0))), (s_.length / @as(f64, @bitCast(@as(i64, 4611686018427387904)))), s_.length, (s_.length + rendercheck_tower_beyond()) });
}

fn sample_xs(s_: Segment) *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ @as(f64, @bitCast(@as(i64, 0))), (s_.width / @as(f64, @bitCast(@as(i64, 4611686018427387904)))), s_.width, ((s_.width / @as(f64, @bitCast(@as(i64, 4611686018427387904)))) + rendercheck_tower_right()) });
}

fn poses() *CxList(Pose) {
    return cx_ll_of(Pose, &[_]Pose{ cx_new(PoseS{ .along = @as(f64, @bitCast(@as(i64, 4638144666238189568))), .across = @as(f64, @bitCast(@as(i64, 4603579539098121011))), .yaw = @as(f64, @bitCast(@as(i64, 4587366580439587226))), .hw = @as(f64, @bitCast(@as(i64, 4611686018427387904))) }), cx_new(PoseS{ .along = @as(f64, @bitCast(@as(i64, 4647151865492930560))), .across = (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4608083138725491507)))), .yaw = (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4599075939470750515)))), .hw = @as(f64, @bitCast(@as(i64, 4611686018427387904))) }) });
}

fn sample_starts() *CxList(i64) {
    return cx_ll_of(i64, &[_]i64{ 0, 12, 16 });
}

fn prev_indices() *CxList(i64) {
    return cx_ll_of(i64, &[_]i64{ 0, 1, 12, 17 });
}

fn at_over_xs(ch: *CxList(i64), pose: Pose, d_: i64, xs: *CxList(f64), a_: f64, j: i64) *CxList(f64) {
    return (if ((j >= cx_list_len(xs))) cx_ll_empty(f64) else b1: { const p_ = at(segs(), ch, pose, d_, a_, cx_list_at(xs, j)); break :b1 cx_ll_concat(cx_ll_of(f64, &[_]f64{ p_.right, p_.forward }), at_over_xs(ch, pose, d_, xs, a_, (j +% 1))); });
}

fn at_over_as(ch: *CxList(i64), pose: Pose, d_: i64, as: *CxList(f64), xs: *CxList(f64), i_: i64) *CxList(f64) {
    return (if ((i_ >= cx_list_len(as))) cx_ll_empty(f64) else cx_ll_concat(at_over_xs(ch, pose, d_, xs, cx_list_at(as, i_), 0), at_over_as(ch, pose, d_, as, xs, (i_ +% 1))));
}

fn at_over_ds(ch: *CxList(i64), pose: Pose, d_: i64) *CxList(f64) {
    return (if ((d_ >= cx_list_len(ch))) cx_ll_empty(f64) else b1: { const sg = cx_list_at(segs(), cx_list_at(ch, d_)); break :b1 cx_ll_concat(at_over_as(ch, pose, d_, sample_as(sg), sample_xs(sg), 0), at_over_ds(ch, pose, (d_ +% 1))); });
}

fn at_over_chains(pose: Pose, i_: i64) *CxList(f64) {
    return (if ((i_ >= cx_list_len(sample_starts()))) cx_ll_empty(f64) else cx_ll_concat(at_over_ds(build_chain(segs(), cx_list_at(sample_starts(), i_)), pose, 0), at_over_chains(pose, (i_ +% 1))));
}

fn at_stream(i_: i64) *CxList(f64) {
    return (if ((i_ >= cx_list_len(poses()))) cx_ll_empty(f64) else cx_ll_concat(at_over_chains(cx_list_at(poses(), i_), 0), at_stream((i_ +% 1))));
}

fn prev_over_xs(pv: Segment, pose: Pose, xs: *CxList(f64), a_: f64, j: i64) *CxList(f64) {
    return (if ((j >= cx_list_len(xs))) cx_ll_empty(f64) else b1: { const p_ = map_pt(segs(), cx_ll_empty(i64), pose, prev_map(pv), a_, cx_list_at(xs, j)); break :b1 cx_ll_concat(cx_ll_of(f64, &[_]f64{ p_.right, p_.forward }), prev_over_xs(pv, pose, xs, a_, (j +% 1))); });
}

fn prev_over_as(pv: Segment, pose: Pose, as: *CxList(f64), xs: *CxList(f64), i_: i64) *CxList(f64) {
    return (if ((i_ >= cx_list_len(as))) cx_ll_empty(f64) else cx_ll_concat(prev_over_xs(pv, pose, xs, cx_list_at(as, i_), 0), prev_over_as(pv, pose, as, xs, (i_ +% 1))));
}

fn prev_over_poses(pv: Segment, i_: i64) *CxList(f64) {
    return (if ((i_ >= cx_list_len(poses()))) cx_ll_empty(f64) else cx_ll_concat(prev_over_as(pv, cx_list_at(poses(), i_), sample_as(pv), sample_xs(pv), 0), prev_over_poses(pv, (i_ +% 1))));
}

fn prev_stream(i_: i64) *CxList(f64) {
    return (if ((i_ >= cx_list_len(prev_indices()))) cx_ll_empty(f64) else cx_ll_concat(prev_over_poses(cx_list_at(segs(), cx_list_at(prev_indices(), i_)), 0), prev_stream((i_ +% 1))));
}

fn creatures() *CxList(Creature) {
    return cx_ll_of(Creature, &[_]Creature{ Creature.NoCreature, Creature.Elephant, Creature.Giraffe, Creature.Zebra, Creature.Rhino, Creature.DuckPond });
}

fn turns() *CxList(bool) {
    return cx_ll_of(bool, &[_]bool{ true, false });
}

fn sc_pair(c_: Creature, j: i64) *CxList(Critter) {
    return (if ((j >= cx_list_len(turns()))) cx_ll_empty(Critter) else cx_ll_concat(corner_critters(c_, @as(f64, @bitCast(@as(i64, 4643985272004935680))), cx_list_at(turns(), j), @as(f64, @bitCast(@as(i64, 4611686018427387904)))), sc_pair(c_, (j +% 1))));
}

fn sc_all(i_: i64) *CxList(Critter) {
    return (if ((i_ >= cx_list_len(creatures()))) cx_ll_empty(Critter) else cx_ll_concat(sc_pair(cx_list_at(creatures(), i_), 0), sc_all((i_ +% 1))));
}

fn sc_count_pair(c_: Creature, j: i64) *CxList(i64) {
    return (if ((j >= cx_list_len(turns()))) cx_ll_empty(i64) else cx_ll_concat(cx_ll_of(i64, &[_]i64{ cx_list_len(corner_critters(c_, @as(f64, @bitCast(@as(i64, 4643985272004935680))), cx_list_at(turns(), j), @as(f64, @bitCast(@as(i64, 4611686018427387904))))) }), sc_count_pair(c_, (j +% 1))));
}

fn sc_counts(i_: i64) *CxList(i64) {
    return (if ((i_ >= cx_list_len(creatures()))) cx_ll_empty(i64) else cx_ll_concat(sc_count_pair(cx_list_at(creatures(), i_), 0), sc_counts((i_ +% 1))));
}

fn cr_cps(cs: *CxList(Critter), i_: i64) *CxList(i64) {
    return (if ((i_ >= cx_list_len(cs))) cx_ll_empty(i64) else cx_ll_concat(cx_ll_of(i64, &[_]i64{ cx_list_at(cs, i_).codepoint }), cr_cps(cs, (i_ +% 1))));
}

fn cr_faces(cs: *CxList(Critter), i_: i64) *CxList(bool) {
    return (if ((i_ >= cx_list_len(cs))) cx_ll_empty(bool) else cx_ll_concat(cx_ll_of(bool, &[_]bool{ cx_list_at(cs, i_).face_right }), cr_faces(cs, (i_ +% 1))));
}

fn cr_place(cs: *CxList(Critter), i_: i64) *CxList(f64) {
    return (if ((i_ >= cx_list_len(cs))) cx_ll_empty(f64) else b1: { const c_ = cx_list_at(cs, i_); break :b1 cx_ll_concat(cx_ll_of(f64, &[_]f64{ c_.along, c_.across, c_.height }), cr_place(cs, (i_ +% 1))); });
}

fn states() *CxList(State) {
    return cx_ll_of(State, &[_]State{ cx_new(StateS{ .seg = 0, .along = @as(f64, @bitCast(@as(i64, 4622945017495814144))), .across = @as(f64, @bitCast(@as(i64, 0))), .yaw = @as(f64, @bitCast(@as(i64, 0))), .cf = focal(), .vyaw = @as(f64, @bitCast(@as(i64, 0))), .tpos = @as(f64, @bitCast(@as(i64, 0))) }), cx_new(StateS{ .seg = 0, .along = @as(f64, @bitCast(@as(i64, 4646800021772042240))), .across = @as(f64, @bitCast(@as(i64, 4607632778762754458))), .yaw = @as(f64, @bitCast(@as(i64, 4591149604126578442))), .cf = focal(), .vyaw = @as(f64, @bitCast(@as(i64, 4584304132692975288))), .tpos = @as(f64, @bitCast(@as(i64, 4649368480934526976))) }), cx_new(StateS{ .seg = 2, .along = @as(f64, @bitCast(@as(i64, 4639481672377565184))), .across = (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4605380978949069210)))), .yaw = (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4593311331947716280)))), .cf = (focal() * @as(f64, @bitCast(@as(i64, 4603579539098121011)))), .vyaw = (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4587366580439587226)))), .tpos = @as(f64, @bitCast(@as(i64, 0))) }), cx_new(StateS{ .seg = 5, .along = @as(f64, @bitCast(@as(i64, 4630826316843712512))), .across = @as(f64, @bitCast(@as(i64, 4599075939470750515))), .yaw = @as(f64, @bitCast(@as(i64, 4581421828931458171))), .cf = focal(), .vyaw = @as(f64, @bitCast(@as(i64, 0))), .tpos = @as(f64, @bitCast(@as(i64, 4657496070887047168))) }), cx_new(StateS{ .seg = 6, .along = @as(f64, @bitCast(@as(i64, 4648488871632306176))), .across = @as(f64, @bitCast(@as(i64, 0))), .yaw = @as(f64, @bitCast(@as(i64, 0))), .cf = focal(), .vyaw = @as(f64, @bitCast(@as(i64, 0))), .tpos = @as(f64, @bitCast(@as(i64, 0))) }), cx_new(StateS{ .seg = 9, .along = @as(f64, @bitCast(@as(i64, 4649368480934526976))), .across = (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4609434218613702656)))), .yaw = @as(f64, @bitCast(@as(i64, 4598175219545276416))), .cf = (focal() * @as(f64, @bitCast(@as(i64, 4599976659396224614)))), .vyaw = @as(f64, @bitCast(@as(i64, 4592590756007337001))), .tpos = @as(f64, @bitCast(@as(i64, 0))) }), cx_new(StateS{ .seg = 12, .along = @as(f64, @bitCast(@as(i64, 4643633428284047360))), .across = @as(f64, @bitCast(@as(i64, 4603579539098121011))), .yaw = (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4599075939470750515)))), .cf = focal(), .vyaw = @as(f64, @bitCast(@as(i64, 0))), .tpos = @as(f64, @bitCast(@as(i64, 0))) }), cx_new(StateS{ .seg = 16, .along = @as(f64, @bitCast(@as(i64, 4636737291354636288))), .across = @as(f64, @bitCast(@as(i64, 0))), .yaw = @as(f64, @bitCast(@as(i64, 0))), .cf = focal(), .vyaw = @as(f64, @bitCast(@as(i64, 0))), .tpos = @as(f64, @bitCast(@as(i64, 0))) }) });
}

fn collect_of(st: State) Collected {
    return collect(segs(), st.seg, cx_new(PoseS{ .along = st.along, .across = st.across, .yaw = (st.yaw + st.vyaw), .hw = (cx_list_at(segs(), st.seg).width / @as(f64, @bitCast(@as(i64, 4611686018427387904)))) }), st.cf, st.along, st.tpos);
}

fn cull_stream(i_: i64) *CxList(i64) {
    return (if ((i_ >= cx_list_len(states()))) cx_ll_empty(i64) else cx_ll_concat(cull_pair(collect_of(cx_list_at(states(), i_))), cull_stream((i_ +% 1))));
}

fn cull_pair(c_: Collected) *CxList(i64) {
    return cx_ll_of(i64, &[_]i64{ c_.cull_seg, c_.cull_size });
}

fn rail_count_stream(i_: i64) *CxList(i64) {
    return (if ((i_ >= cx_list_len(states()))) cx_ll_empty(i64) else cx_ll_concat(cx_ll_of(i64, &[_]i64{ cx_list_len(collect_of(cx_list_at(states(), i_)).rails) }), rail_count_stream((i_ +% 1))));
}

fn fwds_of(rs: *CxList(RailPoly), i_: i64) *CxList(f64) {
    return (if ((i_ >= cx_list_len(rs))) cx_ll_empty(f64) else cx_ll_concat(cx_ll_of(f64, &[_]f64{ cx_list_at(rs, i_).fwd }), fwds_of(rs, (i_ +% 1))));
}

fn rail_fwd_stream(i_: i64) *CxList(f64) {
    return (if ((i_ >= cx_list_len(states()))) cx_ll_empty(f64) else cx_ll_concat(fwds_of(collect_of(cx_list_at(states(), i_)).rails, 0), rail_fwd_stream((i_ +% 1))));
}

fn inversions(xs: *CxList(Item), i_: i64) i64 {
    var _tl_i = i_;
    while (true) {
        if (((_tl_i +% 1) >= cx_list_len(xs))) { return 0; } else { if ((cx_list_at(xs, _tl_i).fwd < cx_list_at(xs, (_tl_i +% 1)).fwd)) { return (1 +% inversions(xs, (_tl_i +% 1))); } else { { const _tj2_1 = (_tl_i +% 1); _tl_i = _tj2_1; continue; } } }
    }
}

fn order_defects(i_: i64) *CxList(i64) {
    return (if ((i_ >= cx_list_len(states()))) cx_ll_empty(i64) else cx_ll_concat(defect_pair(collect_of(cx_list_at(states(), i_))), order_defects((i_ +% 1))));
}

fn defect_pair(c_: Collected) *CxList(i64) {
    return cx_ll_of(i64, &[_]i64{ inversions(c_.order, 0), (cx_list_len(c_.order) -% ((((cx_list_len(c_.trees) +% cx_list_len(c_.towers)) +% cx_list_len(c_.cows)) +% cx_list_len(c_.rails)) +% cx_list_len(truck_items(c_.truck)))) });
}

fn no_defects() *CxList(i64) {
    return cx_ll_of(i64, &[_]i64{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 });
}

fn opening() void {
    return b0: { _ = cx_print_line(grade_ints("\x15\x49\x18\x14\x0f\x11\x12\x17\x0d\x12", chain_lens(0), g_r_chainlen())); _ = cx_print_line(grade_ints("\x15\x49\x18\x14\x0f\x11\x12\x02\x02\x02", chain_flat(0), g_r_chain())); _ = cx_print_line(grade_px("\x15\x49\x0f\x0e\x02\x02\x02\x02\x02\x02", at_stream(0), g_r_at(), @as(f64, @bitCast(@as(i64, 4553247309662628348))), @as(f64, @bitCast(@as(i64, 4517329193108106637))))); _ = cx_print_line(grade_px("\x15\x49\x1f\x15\x0d\x21\x02\x02\x02\x02", prev_stream(0), g_r_prev(), @as(f64, @bitCast(@as(i64, 4543979261917470057))), @as(f64, @bitCast(@as(i64, 4517329193108106637))))); _ = cx_print_line(grade_ints("\x13\x18\x49\x12\x02\x02\x02\x02\x02\x02", sc_counts(0), g_sc_n())); _ = cx_print_line(grade_ints("\x13\x18\x49\x18\x1f\x02\x02\x02\x02\x02", cr_cps(sc_all(0), 0), g_sc_cp())); _ = cx_print_line(grade_bools("\x13\x18\x49\x1c\x0f\x18\x0d\x02\x02\x02", cr_faces(sc_all(0), 0), g_sc_face())); _ = cx_print_line(grade_rel("\x13\x18\x49\x1f\x17\x0f\x18\x0d\x02\x02", cr_place(sc_all(0), 0), g_sc_place(), @as(f64, @bitCast(@as(i64, 4517329193108106637))))); _ = cx_print_line(grade_ints("\x1c\x49\x18\x19\x17\x17\x02\x02\x02\x02", cull_stream(0), g_f_cull())); _ = cx_print_line(grade_ints("\x1c\x49\x15\x0f\x11\x17\x12\x02\x02\x02", rail_count_stream(0), g_f_railn())); _ = cx_print_line(grade_px("\x1c\x49\x15\x0f\x11\x17\x1c\x1b\x16\x02", rail_fwd_stream(0), g_f_railfwd(), @as(f64, @bitCast(@as(i64, 4553247309662628348))), @as(f64, @bitCast(@as(i64, 4517329193108106637))))); _ = cx_print_line(grade_ints("\x1c\x49\x10\x15\x16\x0d\x15\x02\x02\x02", order_defects(0), no_defects())); break :b0; };
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


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

fn Maybe(comptime a_: type) type {
    return union(enum) {
    Just: a_,
    None: void,
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

const TruckBoxS = struct {
    a0: f64,
    a1: f64,
    a2: f64,
    a_roof: f64,
    xl: f64,
    xr: f64,
};
const TruckBox = *TruckBoxS;

const TruckFaceS = struct {
    color: i64,
    fwd: f64,
    v_: *CxList(Vec3),
};
const TruckFace = *TruckFaceS;

const TbCaseS = struct {
    start_: i64,
    along: f64,
    across: f64,
    yaw: f64,
    d_: i64,
    center: f64,
    braking: bool,
    headlights: bool,
};
const TbCase = *TbCaseS;

fn list_tail_loop(comptime T19: type, xs: *CxList(T19), i_: i64, len_: i64, acc_: *CxList(T19)) *CxList(T19) {
    var _tl_i = i_;
    var _tl_acc = acc_;
    while (true) {
        if ((_tl_i >= len_)) { return _tl_acc; } else { { const _tj1_1 = (_tl_i +% 1); const _tj1_3 = cx_ll_push(_tl_acc, cx_list_at(xs, _tl_i)); _tl_i = _tj1_1; _tl_acc = _tj1_3; continue; } }
    }
}

fn list_take(comptime T20: type, xs: *CxList(T20), n_: i64) *CxList(T20) {
    return list_take_loop(T20, xs, 0, (if ((n_ > cx_list_len(xs))) cx_list_len(xs) else n_), cx_ll_empty(T20));
}

fn list_take_loop(comptime T21: type, xs: *CxList(T21), i_: i64, n_: i64, acc_: *CxList(T21)) *CxList(T21) {
    var _tl_i = i_;
    var _tl_acc = acc_;
    while (true) {
        if ((_tl_i >= n_)) { return _tl_acc; } else { { const _tj1_1 = (_tl_i +% 1); const _tj1_3 = cx_ll_push(_tl_acc, cx_list_at(xs, _tl_i)); _tl_i = _tj1_1; _tl_acc = _tj1_3; continue; } }
    }
}

fn list_drop(comptime T22: type, xs: *CxList(T22), n_: i64) *CxList(T22) {
    return list_tail_loop(T22, xs, (if ((n_ > cx_list_len(xs))) cx_list_len(xs) else n_), cx_list_len(xs), cx_ll_empty(T22));
}

fn from_maybe(comptime T43: type, m_: Maybe(T43), default: T43) T43 {
    return switch (m_) { .Just => |x| x, .None => default,  };
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

fn two_pi() f64 {
    return dm_two_pi();
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

fn tree_improves(best: Maybe(f64), a_: f64) bool {
    return switch (best) { .Just => |b_| (a_ < b_), .None => true,  };
}

fn next_tree_loop(ts: *CxList(Tree), desired: f64, i_: i64, best: Maybe(f64)) Maybe(f64) {
    return (if ((i_ >= cx_list_len(ts))) best else next_tree_step(ts, desired, i_, best));
}

fn next_tree_step(ts: *CxList(Tree), desired: f64, i_: i64, best: Maybe(f64)) Maybe(f64) {
    return b0: { const t = cx_list_at(ts, i_); break :b0 b1: { const take: bool = (if ((t.across > @as(f64, @bitCast(@as(i64, 0))))) (if ((t.along >= desired)) tree_improves(best, t.along) else false) else false); break :b1 (if (take) next_tree_loop(ts, desired, (i_ +% 1), Maybe(f64){ .Just = t.along }) else next_tree_loop(ts, desired, (i_ +% 1), best)); }; };
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
    return b0: { const c_ = cx_list_at(route(), i_); break :b0 b1: { const angle: f64 = (real_abs(c_.turn_deg) * deg()); break :b1 b2: { const trees = fill_trees(c_.scheme, c_.length, tree_start_inset(), 0, 0); break :b2 b3: { const distract: bool = (if (c_.pigs) (pig_count_to((i_ +% 1), 0) <= pig_novelty_count()) else false); break :b3 cx_new(SegmentS{ .length = c_.length, .width = lane_width(), .trees = trees, .cows = fill_cows(c_.bull), .pigs = (if (c_.pigs) (if (distract) fill_pig_herd(c_.length) else fill_pig_row(c_.length)) else cx_ll_empty(Critter)), .pigs_distract = distract, .exit_angle = angle, .exit_right = (c_.turn_deg >= @as(f64, @bitCast(@as(i64, 0)))), .exit_to = (if (c_.terminates) i_ else (i_ +% 1)), .commit_along = (if (c_.terminates) c_.length else (c_.length - ((lane_width() / @as(f64, @bitCast(@as(i64, 4611686018427387904)))) / r_tan(angle)))), .north_heading = heading_at(i_), .has_mid_tower = (c_.length > mid_tower_min_length()), .has_cat = c_.cat, .cat = cat_make((lane_width() / @as(f64, @bitCast(@as(i64, 4611686018427387904)))), tree_road_offset(), from_maybe(f64, next_tree_loop(trees, cat_along(), 0, Maybe(f64){ .None = {} }), cat_along())), .terminates = c_.terminates, .exit_creature = (if (c_.terminates) Creature.NoCreature else c_.creature) }); }; }; }; };
}

fn segments_from(i_: i64) *CxList(Segment) {
    return (if ((i_ >= cx_list_len(route()))) cx_ll_empty(Segment) else cx_ll_concat(cx_ll_of(Segment, &[_]Segment{ segment_at(i_) }), segments_from((i_ +% 1))));
}

fn build_world() *CxList(Segment) {
    return segments_from(0);
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

fn project(p_: Vec3, cf: f64, view_w: f64) ScreenPt {
    return cx_new(ScreenPtS{ .x = ((view_w / @as(f64, @bitCast(@as(i64, 4611686018427387904)))) + ((p_.right / p_.forward) * cf)), .y = ((camera_h() / @as(f64, @bitCast(@as(i64, 4611686018427387904)))) - (((p_.height - eye_h()) / p_.forward) * cf)) });
}

fn flatten_screen(ps: *CxList(ScreenPt), i_: i64) *CxList(f64) {
    return (if ((i_ >= cx_list_len(ps))) cx_ll_empty(f64) else b1: { const p_ = cx_list_at(ps, i_); break :b1 cx_ll_concat(cx_ll_of(f64, &[_]f64{ p_.x, p_.y }), flatten_screen(ps, (i_ +% 1))); });
}

fn push_poly(color: i64, ps: *CxList(ScreenPt)) *CxList(DrawCmd) {
    return (if ((cx_list_len(ps) < 3)) cx_ll_empty(DrawCmd) else cx_ll_of(DrawCmd, &[_]DrawCmd{ cx_new(DrawCmdS{ .tag = 0, .color = color, .color2 = 0, .strength = @as(f64, @bitCast(@as(i64, 0))), .geom = cx_ll_empty(f64), .pts = flatten_screen(ps, 0) }) }));
}

fn push_grad_poly(rgba_center: i64, rgba_edge: i64, cx: f64, cy: f64, r_: f64, ps: *CxList(ScreenPt)) *CxList(DrawCmd) {
    return (if ((cx_list_len(ps) < 3)) cx_ll_empty(DrawCmd) else cx_ll_of(DrawCmd, &[_]DrawCmd{ cx_new(DrawCmdS{ .tag = 4, .color = rgba_center, .color2 = rgba_edge, .strength = @as(f64, @bitCast(@as(i64, 0))), .geom = cx_ll_of(f64, &[_]f64{ cx, cy, r_ }), .pts = flatten_screen(ps, 0) }) }));
}

fn project_all(ps: *CxList(Vec3), cf: f64, view_w: f64, i_: i64) *CxList(ScreenPt) {
    return (if ((i_ >= cx_list_len(ps))) cx_ll_empty(ScreenPt) else cx_ll_concat(cx_ll_of(ScreenPt, &[_]ScreenPt{ project(cx_list_at(ps, i_), cf, view_w) }), project_all(ps, cf, view_w, (i_ +% 1))));
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

fn sort_tie() f64 {
    return @as(f64, @bitCast(@as(i64, 4499125899939309867)));
}

fn deeper_than(x: f64, y: f64) bool {
    return ((x - y) > (sort_tie() * real_max(real_abs(y), @as(f64, @bitCast(@as(i64, 4607182418800017408))))));
}

fn truck_length() f64 {
    return @as(f64, @bitCast(@as(i64, 4620918397663497421)));
}

fn truck_width() f64 {
    return @as(f64, @bitCast(@as(i64, 4612586738352862003)));
}

fn truck_height() f64 {
    return @as(f64, @bitCast(@as(i64, 4615288898129284301)));
}

fn cab_length() f64 {
    return @as(f64, @bitCast(@as(i64, 4615063718147915776)));
}

fn cab_roof_frac() f64 {
    return @as(f64, @bitCast(@as(i64, 4599075939470750515)));
}

fn tire_radius() f64 {
    return @as(f64, @bitCast(@as(i64, 4602678819172646912)));
}

fn trailer_bottom() f64 {
    return ((@as(f64, @bitCast(@as(i64, 4611686018427387904))) * tire_radius()) + @as(f64, @bitCast(@as(i64, 4593311331947716280))));
}

fn cab_bottom() f64 {
    return tire_radius();
}

fn tire_pair_gap() f64 {
    return @as(f64, @bitCast(@as(i64, 4608083138725491507)));
}

fn trailer_axle_inset() f64 {
    return @as(f64, @bitCast(@as(i64, 4609884578576439706)));
}

fn cab_axle_frac() f64 {
    return @as(f64, @bitCast(@as(i64, 4603129179135383962)));
}

fn tire_sides() i64 {
    return 16;
}

fn body_color() i64 {
    return 1846886;
}

fn roof_color() i64 {
    return 3822248;
}

fn side_color() i64 {
    return 1384784;
}

fn brake_color() i64 {
    return 16722456;
}

fn tire_color() i64 {
    return 1381658;
}

fn headlight_h() f64 {
    return @as(f64, @bitCast(@as(i64, 4607182418800017408)));
}

fn headlight_inset() f64 {
    return @as(f64, @bitCast(@as(i64, 4599075939470750515)));
}

fn cone_near_half() f64 {
    return @as(f64, @bitCast(@as(i64, 4598175219545276416)));
}

fn cone_far_center() f64 {
    return @as(f64, @bitCast(@as(i64, 4604480259023595110)));
}

fn cone_far_half() f64 {
    return @as(f64, @bitCast(@as(i64, 4606281698874543309)));
}

fn cone_length() f64 {
    return @as(f64, @bitCast(@as(i64, 4626435307207026278)));
}

fn beam_core() i64 {
    return 3288332502;
}

fn beam_edge() i64 {
    return 1174403286;
}

fn glow_core() i64 {
    return 3875491900;
}

fn glow_edge() i64 {
    return 16722456;
}

fn glow_sides() i64 {
    return 16;
}

fn truck_p3(segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, d_: i64, along: f64, x: f64, h_: f64) Vec3 {
    return b0: { const r_ = at(segs, ch, pose, d_, along, x); break :b0 cx_new(Vec3S{ .right = r_.right, .forward = r_.forward, .height = (h_ - ground_drop(r_.right, r_.forward)) }); };
}

fn truck_box(center_along: f64, hw: f64) TruckBox {
    return b0: { const a0: f64 = (center_along - (truck_length() / @as(f64, @bitCast(@as(i64, 4611686018427387904))))); break :b0 b1: { const a1: f64 = (center_along + (truck_length() / @as(f64, @bitCast(@as(i64, 4611686018427387904))))); break :b1 cx_new(TruckBoxS{ .a0 = a0, .a1 = a1, .a2 = (a1 + cab_length()), .a_roof = (a1 + (cab_length() * cab_roof_frac())), .xl = (hw - (truck_width() / @as(f64, @bitCast(@as(i64, 4611686018427387904))))), .xr = (hw + (truck_width() / @as(f64, @bitCast(@as(i64, 4611686018427387904))))) }); }; };
}

fn sum_fwd(ps: *CxList(Vec3), i_: i64) f64 {
    return @as(f64, (if ((i_ >= cx_list_len(ps))) @as(f64, @bitCast(@as(i64, 0))) else (cx_list_at(ps, i_).forward + sum_fwd(ps, (i_ +% 1)))));
}

fn truck_face(color: i64, ps: *CxList(Vec3)) TruckFace {
    return cx_new(TruckFaceS{ .color = color, .fwd = (sum_fwd(ps, 0) / cx_real_from_int(cx_list_len(ps))), .v_ = ps });
}

fn truck_side(segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, d_: i64, bx: TruckBox, x: f64) TruckFace {
    return b0: { const p0 = truck_p3(segs, ch, pose, d_, bx.a0, x, trailer_bottom()); break :b0 b1: { const p1 = truck_p3(segs, ch, pose, d_, bx.a0, x, truck_height()); break :b1 b2: { const p2 = truck_p3(segs, ch, pose, d_, bx.a_roof, x, truck_height()); break :b2 b3: { const p3 = truck_p3(segs, ch, pose, d_, bx.a2, x, (truck_height() / @as(f64, @bitCast(@as(i64, 4611686018427387904))))); break :b3 b4: { const p4 = truck_p3(segs, ch, pose, d_, bx.a2, x, cab_bottom()); break :b4 b5: { const p5 = truck_p3(segs, ch, pose, d_, bx.a1, x, cab_bottom()); break :b5 b6: { const p6 = truck_p3(segs, ch, pose, d_, bx.a1, x, trailer_bottom()); break :b6 truck_face(side_color(), cx_ll_of(Vec3, &[_]Vec3{ p0, p1, p2, p3, p4, p5, p6 })); }; }; }; }; }; }; };
}

fn truck_rear(segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, d_: i64, bx: TruckBox) TruckFace {
    return b0: { const p0 = truck_p3(segs, ch, pose, d_, bx.a0, bx.xl, trailer_bottom()); break :b0 b1: { const p1 = truck_p3(segs, ch, pose, d_, bx.a0, bx.xr, trailer_bottom()); break :b1 b2: { const p2 = truck_p3(segs, ch, pose, d_, bx.a0, bx.xr, truck_height()); break :b2 b3: { const p3 = truck_p3(segs, ch, pose, d_, bx.a0, bx.xl, truck_height()); break :b3 truck_face(body_color(), cx_ll_of(Vec3, &[_]Vec3{ p0, p1, p2, p3 })); }; }; }; };
}

fn truck_roof(segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, d_: i64, bx: TruckBox) TruckFace {
    return b0: { const p0 = truck_p3(segs, ch, pose, d_, bx.a0, bx.xl, truck_height()); break :b0 b1: { const p1 = truck_p3(segs, ch, pose, d_, bx.a0, bx.xr, truck_height()); break :b1 b2: { const p2 = truck_p3(segs, ch, pose, d_, bx.a_roof, bx.xr, truck_height()); break :b2 b3: { const p3 = truck_p3(segs, ch, pose, d_, bx.a_roof, bx.xl, truck_height()); break :b3 truck_face(roof_color(), cx_ll_of(Vec3, &[_]Vec3{ p0, p1, p2, p3 })); }; }; }; };
}

fn truck_windshield(segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, d_: i64, bx: TruckBox) TruckFace {
    return b0: { const p0 = truck_p3(segs, ch, pose, d_, bx.a_roof, bx.xl, truck_height()); break :b0 b1: { const p1 = truck_p3(segs, ch, pose, d_, bx.a_roof, bx.xr, truck_height()); break :b1 b2: { const p2 = truck_p3(segs, ch, pose, d_, bx.a2, bx.xr, (truck_height() / @as(f64, @bitCast(@as(i64, 4611686018427387904))))); break :b2 b3: { const p3 = truck_p3(segs, ch, pose, d_, bx.a2, bx.xl, (truck_height() / @as(f64, @bitCast(@as(i64, 4611686018427387904))))); break :b3 truck_face(body_color(), cx_ll_of(Vec3, &[_]Vec3{ p0, p1, p2, p3 })); }; }; }; };
}

fn truck_nose(segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, d_: i64, bx: TruckBox) TruckFace {
    return b0: { const p0 = truck_p3(segs, ch, pose, d_, bx.a2, bx.xl, (truck_height() / @as(f64, @bitCast(@as(i64, 4611686018427387904))))); break :b0 b1: { const p1 = truck_p3(segs, ch, pose, d_, bx.a2, bx.xr, (truck_height() / @as(f64, @bitCast(@as(i64, 4611686018427387904))))); break :b1 b2: { const p2 = truck_p3(segs, ch, pose, d_, bx.a2, bx.xr, cab_bottom()); break :b2 b3: { const p3 = truck_p3(segs, ch, pose, d_, bx.a2, bx.xl, cab_bottom()); break :b3 truck_face(body_color(), cx_ll_of(Vec3, &[_]Vec3{ p0, p1, p2, p3 })); }; }; }; };
}

fn truck_axles(bx: TruckBox) *CxList(f64) {
    return b0: { const rear: f64 = (bx.a0 + trailer_axle_inset()); break :b0 b1: { const front: f64 = (bx.a1 - trailer_axle_inset()); break :b1 b2: { const cab: f64 = (bx.a1 + (cab_length() * cab_axle_frac())); break :b2 cx_ll_of(f64, &[_]f64{ (rear - (tire_pair_gap() / @as(f64, @bitCast(@as(i64, 4611686018427387904))))), (rear + (tire_pair_gap() / @as(f64, @bitCast(@as(i64, 4611686018427387904))))), (front - (tire_pair_gap() / @as(f64, @bitCast(@as(i64, 4611686018427387904))))), (front + (tire_pair_gap() / @as(f64, @bitCast(@as(i64, 4611686018427387904))))), cab }); }; }; };
}

fn tire_pt(segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, d_: i64, ac: f64, x: f64, i_: i64) Vec3 {
    return b0: { const th: f64 = ((cx_real_from_int(i_) / cx_real_from_int(tire_sides())) * two_pi()); break :b0 truck_p3(segs, ch, pose, d_, (ac + (tire_radius() * r_cos(th))), x, (tire_radius() + (tire_radius() * r_sin(th)))); };
}

fn tire_pts(segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, d_: i64, ac: f64, x: f64, i_: i64) *CxList(Vec3) {
    return (if ((i_ >= tire_sides())) cx_ll_empty(Vec3) else cx_ll_concat(cx_ll_of(Vec3, &[_]Vec3{ tire_pt(segs, ch, pose, d_, ac, x, i_) }), tire_pts(segs, ch, pose, d_, ac, x, (i_ +% 1))));
}

fn side_tires(segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, d_: i64, axles: *CxList(f64), x: f64, i_: i64) *CxList(TruckFace) {
    return (if ((i_ >= cx_list_len(axles))) cx_ll_empty(TruckFace) else cx_ll_concat(cx_ll_of(TruckFace, &[_]TruckFace{ truck_face(tire_color(), tire_pts(segs, ch, pose, d_, cx_list_at(axles, i_), x, 0)) }), side_tires(segs, ch, pose, d_, axles, x, (i_ +% 1))));
}

fn truck_faces(segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, d_: i64, bx: TruckBox) *CxList(TruckFace) {
    return b0: { const axles = truck_axles(bx); break :b0 cx_ll_concat(cx_ll_concat(cx_ll_concat(cx_ll_concat(cx_ll_of(TruckFace, &[_]TruckFace{ truck_side(segs, ch, pose, d_, bx, bx.xl), truck_side(segs, ch, pose, d_, bx, bx.xr) }), cx_ll_of(TruckFace, &[_]TruckFace{ truck_rear(segs, ch, pose, d_, bx), truck_roof(segs, ch, pose, d_, bx) })), cx_ll_of(TruckFace, &[_]TruckFace{ truck_windshield(segs, ch, pose, d_, bx), truck_nose(segs, ch, pose, d_, bx) })), side_tires(segs, ch, pose, d_, axles, bx.xl, 0)), side_tires(segs, ch, pose, d_, axles, bx.xr, 0)); };
}

fn face_rest(ys: *CxList(TruckFace), j: i64) *CxList(TruckFace) {
    return (if ((j >= cx_list_len(ys))) cx_ll_empty(TruckFace) else cx_ll_concat(cx_ll_of(TruckFace, &[_]TruckFace{ cx_list_at(ys, j) }), face_rest(ys, (j +% 1))));
}

fn merge_faces(a_: *CxList(TruckFace), b_: *CxList(TruckFace), i_: i64, j: i64) *CxList(TruckFace) {
    return (if ((i_ >= cx_list_len(a_))) face_rest(b_, j) else (if ((j >= cx_list_len(b_))) face_rest(a_, i_) else (if (deeper_than(cx_list_at(b_, j).fwd, cx_list_at(a_, i_).fwd)) cx_ll_concat(cx_ll_of(TruckFace, &[_]TruckFace{ cx_list_at(b_, j) }), merge_faces(a_, b_, i_, (j +% 1))) else cx_ll_concat(cx_ll_of(TruckFace, &[_]TruckFace{ cx_list_at(a_, i_) }), merge_faces(a_, b_, (i_ +% 1), j)))));
}

fn sort_faces(xs: *CxList(TruckFace)) *CxList(TruckFace) {
    return (if ((cx_list_len(xs) <= 1)) xs else merge_faces(sort_faces(list_take(TruckFace, xs, @divTrunc(cx_list_len(xs), 2))), sort_faces(list_drop(TruckFace, xs, @divTrunc(cx_list_len(xs), 2))), 0, 0));
}

fn truck_fill(color: i64, ps: *CxList(Vec3), cf: f64, view_w: f64) *CxList(DrawCmd) {
    return push_poly(color, project_all(clip_near(ps, near()), cf, view_w, 0));
}

fn draw_faces(fs: *CxList(TruckFace), cf: f64, view_w: f64, i_: i64) *CxList(DrawCmd) {
    return (if ((i_ >= cx_list_len(fs))) cx_ll_empty(DrawCmd) else cx_ll_concat(truck_fill(cx_list_at(fs, i_).color, cx_list_at(fs, i_).v_, cf, view_w), draw_faces(fs, cf, view_w, (i_ +% 1))));
}

fn any_behind(ps: *CxList(Vec3), i_: i64) bool {
    var _tl_i = i_;
    while (true) {
        if ((_tl_i >= cx_list_len(ps))) { return false; } else { if ((cx_list_at(ps, _tl_i).forward <= near())) { return true; } else { { const _tj2_1 = (_tl_i +% 1); _tl_i = _tj2_1; continue; } } }
    }
}

fn mid_vec(p_: Vec3, q: Vec3) Vec3 {
    return cx_new(Vec3S{ .right = ((p_.right + q.right) / @as(f64, @bitCast(@as(i64, 4611686018427387904)))), .forward = ((p_.forward + q.forward) / @as(f64, @bitCast(@as(i64, 4611686018427387904)))), .height = ((p_.height + q.height) / @as(f64, @bitCast(@as(i64, 4611686018427387904)))) });
}

fn pt_dist(p_: ScreenPt, c_: ScreenPt) f64 {
    return real_sqrt((((p_.x - c_.x) * (p_.x - c_.x)) + ((p_.y - c_.y) * (p_.y - c_.y))));
}

fn max_radius(sp: *CxList(ScreenPt), c_: ScreenPt, i_: i64) f64 {
    return @as(f64, (if ((i_ >= cx_list_len(sp))) @as(f64, @bitCast(@as(i64, 0))) else real_max(pt_dist(cx_list_at(sp, i_), c_), max_radius(sp, c_, (i_ +% 1)))));
}

fn truck_wedge(segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, d_: i64, bx: TruckBox, src_x: f64, cf: f64, view_w: f64) *CxList(DrawCmd) {
    return b0: { const p0 = truck_p3(segs, ch, pose, d_, bx.a2, src_x, (headlight_h() - cone_near_half())); break :b0 b1: { const p1 = truck_p3(segs, ch, pose, d_, bx.a2, src_x, (headlight_h() + cone_near_half())); break :b1 b2: { const p2 = truck_p3(segs, ch, pose, d_, (bx.a2 + cone_length()), src_x, (cone_far_center() + cone_far_half())); break :b2 b3: { const p3 = truck_p3(segs, ch, pose, d_, (bx.a2 + cone_length()), src_x, (cone_far_center() - cone_far_half())); break :b3 wedge_emit(cx_ll_of(Vec3, &[_]Vec3{ p0, p1, p2, p3 }), cf, view_w); }; }; }; };
}

fn wedge_emit(ps: *CxList(Vec3), cf: f64, view_w: f64) *CxList(DrawCmd) {
    return (if (any_behind(ps, 0)) cx_ll_empty(DrawCmd) else wedge_cmd(ps, cf, view_w));
}

fn wedge_cmd(ps: *CxList(Vec3), cf: f64, view_w: f64) *CxList(DrawCmd) {
    return b0: { const sp = project_all(ps, cf, view_w, 0); break :b0 b1: { const lamp = project(mid_vec(cx_list_at(ps, 0), cx_list_at(ps, 1)), cf, view_w); break :b1 push_grad_poly(beam_core(), beam_edge(), lamp.x, lamp.y, max_radius(sp, lamp, 0), sp); }; };
}

fn truck_wedges(segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, d_: i64, bx: TruckBox, cf: f64, view_w: f64) *CxList(DrawCmd) {
    return cx_ll_concat(truck_wedge(segs, ch, pose, d_, bx, (bx.xl + headlight_inset()), cf, view_w), truck_wedge(segs, ch, pose, d_, bx, (bx.xr - headlight_inset()), cf, view_w));
}

fn sum_x(ps: *CxList(ScreenPt), i_: i64) f64 {
    return @as(f64, (if ((i_ >= cx_list_len(ps))) @as(f64, @bitCast(@as(i64, 0))) else (cx_list_at(ps, i_).x + sum_x(ps, (i_ +% 1)))));
}

fn sum_y(ps: *CxList(ScreenPt), i_: i64) f64 {
    return @as(f64, (if ((i_ >= cx_list_len(ps))) @as(f64, @bitCast(@as(i64, 0))) else (cx_list_at(ps, i_).y + sum_y(ps, (i_ +% 1)))));
}

fn glow_pt(cx: f64, cy: f64, rad: f64, i_: i64) ScreenPt {
    return b0: { const th: f64 = ((cx_real_from_int(i_) / cx_real_from_int(glow_sides())) * two_pi()); break :b0 cx_new(ScreenPtS{ .x = (cx + (rad * r_cos(th))), .y = (cy + (rad * r_sin(th))) }); };
}

fn glow_circle(cx: f64, cy: f64, rad: f64, i_: i64) *CxList(ScreenPt) {
    return (if ((i_ >= glow_sides())) cx_ll_empty(ScreenPt) else cx_ll_concat(cx_ll_of(ScreenPt, &[_]ScreenPt{ glow_pt(cx, cy, rad, i_) }), glow_circle(cx, cy, rad, (i_ +% 1))));
}

fn glow_cmd(panel: *CxList(Vec3), cf: f64, view_w: f64) *CxList(DrawCmd) {
    return b0: { const sp = project_all(panel, cf, view_w, 0); break :b0 b1: { const cx: f64 = (sum_x(sp, 0) / @as(f64, @bitCast(@as(i64, 4616189618054758400)))); break :b1 b2: { const cy: f64 = (sum_y(sp, 0) / @as(f64, @bitCast(@as(i64, 4616189618054758400)))); break :b2 b3: { const rad: f64 = (max_radius(sp, cx_new(ScreenPtS{ .x = cx, .y = cy }), 0) * @as(f64, @bitCast(@as(i64, 4614388178203810202)))); break :b3 push_grad_poly(glow_core(), glow_edge(), cx, cy, rad, glow_circle(cx, cy, rad, 0)); }; }; }; };
}

fn brake_light(segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, d_: i64, a0: f64, x0: f64, x1: f64, cf: f64, view_w: f64) *CxList(DrawCmd) {
    return b0: { const bl: f64 = (trailer_bottom() + (@as(f64, @bitCast(@as(i64, 4596373779694328218))) * (truck_height() - trailer_bottom()))); break :b0 b1: { const bh: f64 = (trailer_bottom() + (@as(f64, @bitCast(@as(i64, 4602678819172646912))) * (truck_height() - trailer_bottom()))); break :b1 b2: { const q0 = truck_p3(segs, ch, pose, d_, a0, x0, bl); break :b2 b3: { const q1 = truck_p3(segs, ch, pose, d_, a0, x1, bl); break :b3 b4: { const q2 = truck_p3(segs, ch, pose, d_, a0, x1, bh); break :b4 b5: { const q3 = truck_p3(segs, ch, pose, d_, a0, x0, bh); break :b5 emit_brake(cx_ll_of(Vec3, &[_]Vec3{ q0, q1, q2, q3 }), cf, view_w); }; }; }; }; }; };
}

fn emit_brake(panel: *CxList(Vec3), cf: f64, view_w: f64) *CxList(DrawCmd) {
    return cx_ll_concat((if (any_behind(panel, 0)) cx_ll_empty(DrawCmd) else glow_cmd(panel, cf, view_w)), truck_fill(brake_color(), panel, cf, view_w));
}

fn brake_lights(segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, d_: i64, bx: TruckBox, cf: f64, view_w: f64) *CxList(DrawCmd) {
    return cx_ll_concat(brake_light(segs, ch, pose, d_, bx.a0, (bx.xl + (@as(f64, @bitCast(@as(i64, 4591870180066957722))) * truck_width())), (bx.xl + (@as(f64, @bitCast(@as(i64, 4600156803381319434))) * truck_width())), cf, view_w), brake_light(segs, ch, pose, d_, bx.a0, (bx.xr - (@as(f64, @bitCast(@as(i64, 4600156803381319434))) * truck_width())), (bx.xr - (@as(f64, @bitCast(@as(i64, 4591870180066957722))) * truck_width())), cf, view_w));
}

fn truck_draw_body(segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, d_: i64, center_along: f64, hw: f64, braking: bool, headlights: bool, cf: f64, view_w: f64) *CxList(DrawCmd) {
    return b0: { const bx = truck_box(center_along, hw); break :b0 b1: { const beams = (if (headlights) truck_wedges(segs, ch, pose, d_, bx, cf, view_w) else cx_ll_empty(DrawCmd)); break :b1 b2: { const body = draw_faces(sort_faces(truck_faces(segs, ch, pose, d_, bx)), cf, view_w, 0); break :b2 b3: { const lights = (if (braking) brake_lights(segs, ch, pose, d_, bx, cf, view_w) else cx_ll_empty(DrawCmd)); break :b3 cx_ll_concat(cx_ll_concat(beams, body), lights); }; }; }; };
}

fn g_abs(x: f64) f64 {
    return (if ((x < @as(f64, @bitCast(@as(i64, 0))))) (@as(f64, @bitCast(@as(i64, 0))) - x) else x);
}

fn g_finite(x: f64) bool {
    return ((cx_real_to_bits(x) & 9223372036854775807) < 9218868437227405312);
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

fn g_tb_tag() *CxList(i64) {
    @setEvalBranchQuota(1000000);
    return cx_ll_of(i64, &[_]i64{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 4, 0, 4, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 4, 0, 4, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 });
}

fn g_tb_col() *CxList(i64) {
    @setEvalBranchQuota(1000000);
    return cx_ll_of(i64, &[_]i64{ 1846886, 1846886, 1381658, 1381658, 1381658, 1381658, 1384784, 1384784, 1381658, 1381658, 3822248, 1381658, 1381658, 1381658, 1381658, 1846886, 3288332502, 3288332502, 1846886, 1846886, 1381658, 1381658, 1381658, 1381658, 1384784, 1384784, 1381658, 1381658, 3822248, 1381658, 1381658, 1381658, 1381658, 1846886, 3875491900, 16722456, 3875491900, 16722456, 3288332502, 3288332502, 1381658, 1846886, 1846886, 1381658, 1384784, 1381658, 1381658, 1381658, 1384784, 3822248, 1381658, 1381658, 1381658, 1381658, 1846886, 1381658, 3875491900, 16722456, 3875491900, 16722456, 1846886, 1381658, 1846886, 1381658, 1381658, 1384784, 1381658, 1381658, 1384784, 1381658, 3822248, 1381658, 1381658, 1381658, 1381658, 1846886, 3288332502, 3288332502, 1846886, 1846886, 1381658, 1381658, 1381658, 1381658, 1384784, 1384784, 1381658, 1381658, 3822248, 1381658, 1381658, 1381658, 1381658, 1846886, 3875491900, 16722456, 3875491900, 16722456, 3288332502, 3288332502, 1846886, 1846886, 1381658, 1381658, 1381658, 1381658, 1384784, 1384784, 1381658, 1381658, 3822248, 1381658, 1381658 });
}

fn g_tb_col2() *CxList(i64) {
    @setEvalBranchQuota(1000000);
    return cx_ll_of(i64, &[_]i64{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1174403286, 1174403286, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 16722456, 0, 16722456, 0, 1174403286, 1174403286, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 16722456, 0, 16722456, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1174403286, 1174403286, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 16722456, 0, 16722456, 0, 1174403286, 1174403286, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 });
}

fn g_tb_cnt() *CxList(i64) {
    @setEvalBranchQuota(1000000);
    return cx_ll_of(i64, &[_]i64{ 4, 4, 16, 16, 16, 16, 7, 7, 16, 16, 4, 16, 16, 16, 16, 4, 4, 4, 4, 4, 16, 16, 16, 16, 7, 7, 16, 16, 4, 16, 16, 16, 16, 4, 16, 4, 16, 4, 4, 4, 16, 4, 4, 16, 7, 16, 16, 16, 7, 4, 16, 16, 16, 16, 4, 16, 16, 4, 16, 4, 4, 16, 4, 16, 16, 7, 16, 16, 7, 16, 4, 16, 16, 16, 16, 4, 4, 4, 4, 4, 16, 16, 16, 16, 7, 7, 16, 16, 4, 16, 16, 16, 16, 4, 16, 4, 16, 4, 4, 4, 4, 4, 16, 16, 16, 16, 7, 7, 16, 16, 4, 5, 5 });
}

fn g_tb_geom() *CxList(f64) {
    @setEvalBranchQuota(1000000);
    return cx_ll_of(f64, &[_]f64{ @as(f64, @bitCast(@as(i64, 4647083040814922014))), @as(f64, @bitCast(@as(i64, 4644010075931727144))), @as(f64, @bitCast(@as(i64, 4616877507994942131))), @as(f64, @bitCast(@as(i64, 4647220690170939106))), @as(f64, @bitCast(@as(i64, 4644010075931727144))), @as(f64, @bitCast(@as(i64, 4616877507994942131))), @as(f64, @bitCast(@as(i64, 4647098267379709038))), @as(f64, @bitCast(@as(i64, 4643928885530226118))), @as(f64, @bitCast(@as(i64, 4619910637307979886))), @as(f64, @bitCast(@as(i64, 4647205463606152082))), @as(f64, @bitCast(@as(i64, 4643928885530226118))), @as(f64, @bitCast(@as(i64, 4619910637307979886))), @as(f64, @bitCast(@as(i64, 4652723733025662173))), @as(f64, @bitCast(@as(i64, 4644018729879886113))), @as(f64, @bitCast(@as(i64, 4626770361789978738))), @as(f64, @bitCast(@as(i64, 4652776510463404723))), @as(f64, @bitCast(@as(i64, 4644019024373080497))), @as(f64, @bitCast(@as(i64, 4626567928645903131))), @as(f64, @bitCast(@as(i64, 4652670070700961589))), @as(f64, @bitCast(@as(i64, 4643930131584763644))), @as(f64, @bitCast(@as(i64, 4621357177182742641))), @as(f64, @bitCast(@as(i64, 4652709609139096414))), @as(f64, @bitCast(@as(i64, 4643929665567755327))), @as(f64, @bitCast(@as(i64, 4621420238836524896))), @as(f64, @bitCast(@as(i64, 4646514351762647433))), @as(f64, @bitCast(@as(i64, 4644092896952952627))), @as(f64, @bitCast(@as(i64, 4627352958978249430))), @as(f64, @bitCast(@as(i64, 4647470622358072124))), @as(f64, @bitCast(@as(i64, 4644092893962280999))), @as(f64, @bitCast(@as(i64, 4625876893222854659))), @as(f64, @bitCast(@as(i64, 4646093297918954334))), @as(f64, @bitCast(@as(i64, 4643000828403170159))), @as(f64, @bitCast(@as(i64, 4636639914382755795))), @as(f64, @bitCast(@as(i64, 4647540453660966131))), @as(f64, @bitCast(@as(i64, 4643000819255233416))), @as(f64, @bitCast(@as(i64, 4636639896086882309))), @as(f64, @bitCast(@as(i64, 4646032929804777339))), @as(f64, @bitCast(@as(i64, 4644234514578375757))), @as(f64, @bitCast(@as(i64, 4632084723910591444))), @as(f64, @bitCast(@as(i64, 4647992808049835036))), @as(f64, @bitCast(@as(i64, 4644234514578375757))), @as(f64, @bitCast(@as(i64, 4632084723910591444))) });
}

fn g_tb_xy() *CxList(f64) {
    @setEvalBranchQuota(1000000);
    return cx_ll_of(f64, &[_]f64{ @as(f64, @bitCast(@as(i64, 4647060099372867073))), @as(f64, @bitCast(@as(i64, 4643948898401070245))), @as(f64, @bitCast(@as(i64, 4647243631612994047))), @as(f64, @bitCast(@as(i64, 4643948898401070245))), @as(f64, @bitCast(@as(i64, 4647243631612994047))), @as(f64, @bitCast(@as(i64, 4644048311844407240))), @as(f64, @bitCast(@as(i64, 4647060099372867073))), @as(f64, @bitCast(@as(i64, 4644048311844407240))), @as(f64, @bitCast(@as(i64, 4647058650656346315))), @as(f64, @bitCast(@as(i64, 4643808204541336308))), @as(f64, @bitCast(@as(i64, 4647245080329514805))), @as(f64, @bitCast(@as(i64, 4643808204541336308))), @as(f64, @bitCast(@as(i64, 4647243631612994047))), @as(f64, @bitCast(@as(i64, 4643948898401070245))), @as(f64, @bitCast(@as(i64, 4647060099372867073))), @as(f64, @bitCast(@as(i64, 4643948898401070245))), @as(f64, @bitCast(@as(i64, 4647059469572606683))), @as(f64, @bitCast(@as(i64, 4644048614781850925))), @as(f64, @bitCast(@as(i64, 4647059446702764825))), @as(f64, @bitCast(@as(i64, 4644033888890678726))), @as(f64, @bitCast(@as(i64, 4647059382491285763))), @as(f64, @bitCast(@as(i64, 4644021408114289515))), @as(f64, @bitCast(@as(i64, 4647059286965715542))), @as(f64, @bitCast(@as(i64, 4644013064140448648))), @as(f64, @bitCast(@as(i64, 4647059173144271834))), @as(f64, @bitCast(@as(i64, 4644010135569237834))), @as(f64, @bitCast(@as(i64, 4647059059674671848))), @as(f64, @bitCast(@as(i64, 4644013086130681204))), @as(f64, @bitCast(@as(i64, 4647058963269492324))), @as(f64, @bitCast(@as(i64, 4644021486575439273))), @as(f64, @bitCast(@as(i64, 4647058898178403960))), @as(f64, @bitCast(@as(i64, 4644034066043992193))), @as(f64, @bitCast(@as(i64, 4647058875660405823))), @as(f64, @bitCast(@as(i64, 4644048900830796007))), @as(f64, @bitCast(@as(i64, 4647058898178403960))), @as(f64, @bitCast(@as(i64, 4644063713099601685))), @as(f64, @bitCast(@as(i64, 4647058963269492324))), @as(f64, @bitCast(@as(i64, 4644076230291816008))), @as(f64, @bitCast(@as(i64, 4647059059674671848))), @as(f64, @bitCast(@as(i64, 4644084537322066181))), @as(f64, @bitCast(@as(i64, 4647059173144271834))), @as(f64, @bitCast(@as(i64, 4644087378811956075))), @as(f64, @bitCast(@as(i64, 4647059286965715542))), @as(f64, @bitCast(@as(i64, 4644084340641426204))), @as(f64, @bitCast(@as(i64, 4647059382491285763))), @as(f64, @bitCast(@as(i64, 4644075904484530465))), @as(f64, @bitCast(@as(i64, 4647059446702764825))), @as(f64, @bitCast(@as(i64, 4644063361431802657))), @as(f64, @bitCast(@as(i64, 4647244261413254437))), @as(f64, @bitCast(@as(i64, 4644048614781850925))), @as(f64, @bitCast(@as(i64, 4647244284283096295))), @as(f64, @bitCast(@as(i64, 4644033888890678726))), @as(f64, @bitCast(@as(i64, 4647244348494575357))), @as(f64, @bitCast(@as(i64, 4644021408114289515))), @as(f64, @bitCast(@as(i64, 4647244444020145578))), @as(f64, @bitCast(@as(i64, 4644013064140448648))), @as(f64, @bitCast(@as(i64, 4647244557841589286))), @as(f64, @bitCast(@as(i64, 4644010135569237834))), @as(f64, @bitCast(@as(i64, 4647244671311189272))), @as(f64, @bitCast(@as(i64, 4644013086130681204))), @as(f64, @bitCast(@as(i64, 4647244767716368796))), @as(f64, @bitCast(@as(i64, 4644021486575439273))), @as(f64, @bitCast(@as(i64, 4647244832807457160))), @as(f64, @bitCast(@as(i64, 4644034066043992193))), @as(f64, @bitCast(@as(i64, 4647244855325455297))), @as(f64, @bitCast(@as(i64, 4644048900830796007))), @as(f64, @bitCast(@as(i64, 4647244832807457160))), @as(f64, @bitCast(@as(i64, 4644063713099601685))), @as(f64, @bitCast(@as(i64, 4647244767716368796))), @as(f64, @bitCast(@as(i64, 4644076230291816008))), @as(f64, @bitCast(@as(i64, 4647244671311189272))), @as(f64, @bitCast(@as(i64, 4644084537322066181))), @as(f64, @bitCast(@as(i64, 4647244557841589286))), @as(f64, @bitCast(@as(i64, 4644087378811956075))), @as(f64, @bitCast(@as(i64, 4647244444020145578))), @as(f64, @bitCast(@as(i64, 4644084340641426204))), @as(f64, @bitCast(@as(i64, 4647244348494575357))), @as(f64, @bitCast(@as(i64, 4644075904484530465))), @as(f64, @bitCast(@as(i64, 4647244284283096295))), @as(f64, @bitCast(@as(i64, 4644063361431802657))), @as(f64, @bitCast(@as(i64, 4647057710705845962))), @as(f64, @bitCast(@as(i64, 4644049464132593150))), @as(f64, @bitCast(@as(i64, 4647057687484160383))), @as(f64, @bitCast(@as(i64, 4644034458525662844))), @as(f64, @bitCast(@as(i64, 4647057620985697135))), @as(f64, @bitCast(@as(i64, 4644021740606605754))), @as(f64, @bitCast(@as(i64, 4647057521238002264))), @as(f64, @bitCast(@as(i64, 4644013238303090488))), @as(f64, @bitCast(@as(i64, 4647057403546277627))), @as(f64, @bitCast(@as(i64, 4644010253612806192))), @as(f64, @bitCast(@as(i64, 4647057285502709268))), @as(f64, @bitCast(@as(i64, 4644013261700697927))), @as(f64, @bitCast(@as(i64, 4647057185051326955))), @as(f64, @bitCast(@as(i64, 4644021823817645744))), @as(f64, @bitCast(@as(i64, 4647057118025098126))), @as(f64, @bitCast(@as(i64, 4644034644475069334))), @as(f64, @bitCast(@as(i64, 4647057094275646966))), @as(f64, @bitCast(@as(i64, 4644049763199755905))), @as(f64, @bitCast(@as(i64, 4647057118025098126))), @as(f64, @bitCast(@as(i64, 4644064859406444339))), @as(f64, @bitCast(@as(i64, 4647057185051326955))), @as(f64, @bitCast(@as(i64, 4644077614796857703))), @as(f64, @bitCast(@as(i64, 4647057285502709268))), @as(f64, @bitCast(@as(i64, 4644086079101251113))), @as(f64, @bitCast(@as(i64, 4647057403546277627))), @as(f64, @bitCast(@as(i64, 4644088972312167978))), @as(f64, @bitCast(@as(i64, 4647057521238002264))), @as(f64, @bitCast(@as(i64, 4644085873624518115))), @as(f64, @bitCast(@as(i64, 4647057620985697135))), @as(f64, @bitCast(@as(i64, 4644077274563979604))), @as(f64, @bitCast(@as(i64, 4647057687484160383))), @as(f64, @bitCast(@as(i64, 4644064492081599731))), @as(f64, @bitCast(@as(i64, 4647246020280015158))), @as(f64, @bitCast(@as(i64, 4644049464132593150))), @as(f64, @bitCast(@as(i64, 4647246043501700737))), @as(f64, @bitCast(@as(i64, 4644034458525662844))), @as(f64, @bitCast(@as(i64, 4647246110000163985))), @as(f64, @bitCast(@as(i64, 4644021740606605754))), @as(f64, @bitCast(@as(i64, 4647246209747858856))), @as(f64, @bitCast(@as(i64, 4644013238303090488))), @as(f64, @bitCast(@as(i64, 4647246327439583493))), @as(f64, @bitCast(@as(i64, 4644010253612806192))), @as(f64, @bitCast(@as(i64, 4647246445483151852))), @as(f64, @bitCast(@as(i64, 4644013261700697927))), @as(f64, @bitCast(@as(i64, 4647246545934534165))), @as(f64, @bitCast(@as(i64, 4644021823817645744))), @as(f64, @bitCast(@as(i64, 4647246612960762994))), @as(f64, @bitCast(@as(i64, 4644034644475069334))), @as(f64, @bitCast(@as(i64, 4647246636710214154))), @as(f64, @bitCast(@as(i64, 4644049763199755905))), @as(f64, @bitCast(@as(i64, 4647246612960762994))), @as(f64, @bitCast(@as(i64, 4644064859406444339))), @as(f64, @bitCast(@as(i64, 4647246545934534165))), @as(f64, @bitCast(@as(i64, 4644077614796857703))), @as(f64, @bitCast(@as(i64, 4647246445483151852))), @as(f64, @bitCast(@as(i64, 4644086079101251113))), @as(f64, @bitCast(@as(i64, 4647246327439583493))), @as(f64, @bitCast(@as(i64, 4644088972312167978))), @as(f64, @bitCast(@as(i64, 4647246209747858856))), @as(f64, @bitCast(@as(i64, 4644085873624518115))), @as(f64, @bitCast(@as(i64, 4647246110000163985))), @as(f64, @bitCast(@as(i64, 4644077274563979604))), @as(f64, @bitCast(@as(i64, 4647246043501700737))), @as(f64, @bitCast(@as(i64, 4644064492081599731))), @as(f64, @bitCast(@as(i64, 4647052609323736802))), @as(f64, @bitCast(@as(i64, 4644000681352535705))), @as(f64, @bitCast(@as(i64, 4647052609323736802))), @as(f64, @bitCast(@as(i64, 4643795551537445722))), @as(f64, @bitCast(@as(i64, 4647058650656346315))), @as(f64, @bitCast(@as(i64, 4643808204541336308))), @as(f64, @bitCast(@as(i64, 4647060099372867073))), @as(f64, @bitCast(@as(i64, 4643948898401070245))), @as(f64, @bitCast(@as(i64, 4647060099372867073))), @as(f64, @bitCast(@as(i64, 4644048311844407240))), @as(f64, @bitCast(@as(i64, 4647058016106195693))), @as(f64, @bitCast(@as(i64, 4644049315830464795))), @as(f64, @bitCast(@as(i64, 4647058016106195693))), @as(f64, @bitCast(@as(i64, 4644000827367679874))), @as(f64, @bitCast(@as(i64, 4647251121662124318))), @as(f64, @bitCast(@as(i64, 4644000681352535705))), @as(f64, @bitCast(@as(i64, 4647251121662124318))), @as(f64, @bitCast(@as(i64, 4643795551537445722))), @as(f64, @bitCast(@as(i64, 4647245080329514805))), @as(f64, @bitCast(@as(i64, 4643808204541336308))), @as(f64, @bitCast(@as(i64, 4647243631612994047))), @as(f64, @bitCast(@as(i64, 4643948898401070245))), @as(f64, @bitCast(@as(i64, 4647243631612994047))), @as(f64, @bitCast(@as(i64, 4644048311844407240))), @as(f64, @bitCast(@as(i64, 4647245714879665427))), @as(f64, @bitCast(@as(i64, 4644049315830464795))), @as(f64, @bitCast(@as(i64, 4647245714879665427))), @as(f64, @bitCast(@as(i64, 4644000827367679874))), @as(f64, @bitCast(@as(i64, 4647056969722969771))), @as(f64, @bitCast(@as(i64, 4644049823716875897))), @as(f64, @bitCast(@as(i64, 4647056946149440472))), @as(f64, @bitCast(@as(i64, 4644034700066377234))), @as(f64, @bitCast(@as(i64, 4647056878595446061))), @as(f64, @bitCast(@as(i64, 4644021882223703412))), @as(f64, @bitCast(@as(i64, 4647056777616298166))), @as(f64, @bitCast(@as(i64, 4644013313245803037))), @as(f64, @bitCast(@as(i64, 4647056657813511204))), @as(f64, @bitCast(@as(i64, 4644010305685676884))), @as(f64, @bitCast(@as(i64, 4647056537658880520))), @as(f64, @bitCast(@as(i64, 4644013338050785360))), @as(f64, @bitCast(@as(i64, 4647056435624201463))), @as(f64, @bitCast(@as(i64, 4644021967545805727))), @as(f64, @bitCast(@as(i64, 4647056367366519610))), @as(f64, @bitCast(@as(i64, 4644034889534220932))), @as(f64, @bitCast(@as(i64, 4647056343792990311))), @as(f64, @bitCast(@as(i64, 4644050128765381908))), @as(f64, @bitCast(@as(i64, 4647056367366519610))), @as(f64, @bitCast(@as(i64, 4644065344598935444))), @as(f64, @bitCast(@as(i64, 4647056435624201463))), @as(f64, @bitCast(@as(i64, 4644078200088887401))), @as(f64, @bitCast(@as(i64, 4647056537658880520))), @as(f64, @bitCast(@as(i64, 4644086730363978478))), @as(f64, @bitCast(@as(i64, 4647056657813511204))), @as(f64, @bitCast(@as(i64, 4644089645565127898))), @as(f64, @bitCast(@as(i64, 4647056777616298166))), @as(f64, @bitCast(@as(i64, 4644086521544730131))), @as(f64, @bitCast(@as(i64, 4647056878595446061))), @as(f64, @bitCast(@as(i64, 4644077853698744186))), @as(f64, @bitCast(@as(i64, 4647056946149440472))), @as(f64, @bitCast(@as(i64, 4644064970413138279))), @as(f64, @bitCast(@as(i64, 4647246761262891349))), @as(f64, @bitCast(@as(i64, 4644049823716875897))), @as(f64, @bitCast(@as(i64, 4647246784836420648))), @as(f64, @bitCast(@as(i64, 4644034700066377234))), @as(f64, @bitCast(@as(i64, 4647246852390415059))), @as(f64, @bitCast(@as(i64, 4644021882223703412))), @as(f64, @bitCast(@as(i64, 4647246953369562954))), @as(f64, @bitCast(@as(i64, 4644013313245803037))), @as(f64, @bitCast(@as(i64, 4647247073172349916))), @as(f64, @bitCast(@as(i64, 4644010305685676884))), @as(f64, @bitCast(@as(i64, 4647247193326980600))), @as(f64, @bitCast(@as(i64, 4644013338050785360))), @as(f64, @bitCast(@as(i64, 4647247295361659657))), @as(f64, @bitCast(@as(i64, 4644021967545805727))), @as(f64, @bitCast(@as(i64, 4647247363619341510))), @as(f64, @bitCast(@as(i64, 4644034889534220932))), @as(f64, @bitCast(@as(i64, 4647247387192870809))), @as(f64, @bitCast(@as(i64, 4644050128765381908))), @as(f64, @bitCast(@as(i64, 4647247363619341510))), @as(f64, @bitCast(@as(i64, 4644065344598935444))), @as(f64, @bitCast(@as(i64, 4647247295361659657))), @as(f64, @bitCast(@as(i64, 4644078200088887401))), @as(f64, @bitCast(@as(i64, 4647247193326980600))), @as(f64, @bitCast(@as(i64, 4644086730363978478))), @as(f64, @bitCast(@as(i64, 4647247073172349916))), @as(f64, @bitCast(@as(i64, 4644089645565127898))), @as(f64, @bitCast(@as(i64, 4647246953369562954))), @as(f64, @bitCast(@as(i64, 4644086521544730131))), @as(f64, @bitCast(@as(i64, 4647246852390415059))), @as(f64, @bitCast(@as(i64, 4644077853698744186))), @as(f64, @bitCast(@as(i64, 4647246784836420648))), @as(f64, @bitCast(@as(i64, 4644064970413138279))), @as(f64, @bitCast(@as(i64, 4647052609323736802))), @as(f64, @bitCast(@as(i64, 4643795551537445722))), @as(f64, @bitCast(@as(i64, 4647251121662124318))), @as(f64, @bitCast(@as(i64, 4643795551537445722))), @as(f64, @bitCast(@as(i64, 4647245080329514805))), @as(f64, @bitCast(@as(i64, 4643808204541336308))), @as(f64, @bitCast(@as(i64, 4647058650656346315))), @as(f64, @bitCast(@as(i64, 4643808204541336308))), @as(f64, @bitCast(@as(i64, 4647054413578337518))), @as(f64, @bitCast(@as(i64, 4644051073817616214))), @as(f64, @bitCast(@as(i64, 4647054388949277055))), @as(f64, @bitCast(@as(i64, 4644035542908010622))), @as(f64, @bitCast(@as(i64, 4647054317700923576))), @as(f64, @bitCast(@as(i64, 4644022380610334050))), @as(f64, @bitCast(@as(i64, 4647054210740432425))), @as(f64, @bitCast(@as(i64, 4644013581350718354))), @as(f64, @bitCast(@as(i64, 4647054084604458487))), @as(f64, @bitCast(@as(i64, 4644010493922067559))), @as(f64, @bitCast(@as(i64, 4647053957940718967))), @as(f64, @bitCast(@as(i64, 4644013608618606723))), @as(f64, @bitCast(@as(i64, 4647053850628384096))), @as(f64, @bitCast(@as(i64, 4644022472793388923))), @as(f64, @bitCast(@as(i64, 4647053778500421314))), @as(f64, @bitCast(@as(i64, 4644035745745915714))), @as(f64, @bitCast(@as(i64, 4647053753343595271))), @as(f64, @bitCast(@as(i64, 4644051398921214314))), @as(f64, @bitCast(@as(i64, 4647053778500421314))), @as(f64, @bitCast(@as(i64, 4644067026411921290))), @as(f64, @bitCast(@as(i64, 4647053850628384096))), @as(f64, @bitCast(@as(i64, 4644080228819782043))), @as(f64, @bitCast(@as(i64, 4647053957940718967))), @as(f64, @bitCast(@as(i64, 4644088987441447976))), @as(f64, @bitCast(@as(i64, 4647054084604458487))), @as(f64, @bitCast(@as(i64, 4644091977761231806))), @as(f64, @bitCast(@as(i64, 4647054210740432425))), @as(f64, @bitCast(@as(i64, 4644088765603981956))), @as(f64, @bitCast(@as(i64, 4647054317700923576))), @as(f64, @bitCast(@as(i64, 4644079861143093715))), @as(f64, @bitCast(@as(i64, 4647054388949277055))), @as(f64, @bitCast(@as(i64, 4644066628828516686))), @as(f64, @bitCast(@as(i64, 4647249317407523602))), @as(f64, @bitCast(@as(i64, 4644051073817616214))), @as(f64, @bitCast(@as(i64, 4647249342036584065))), @as(f64, @bitCast(@as(i64, 4644035542908010622))), @as(f64, @bitCast(@as(i64, 4647249413284937544))), @as(f64, @bitCast(@as(i64, 4644022380610334050))), @as(f64, @bitCast(@as(i64, 4647249520245428695))), @as(f64, @bitCast(@as(i64, 4644013581350718354))), @as(f64, @bitCast(@as(i64, 4647249646381402633))), @as(f64, @bitCast(@as(i64, 4644010493922067559))), @as(f64, @bitCast(@as(i64, 4647249773045142153))), @as(f64, @bitCast(@as(i64, 4644013608618606723))), @as(f64, @bitCast(@as(i64, 4647249880357477024))), @as(f64, @bitCast(@as(i64, 4644022472793388923))), @as(f64, @bitCast(@as(i64, 4647249952485439806))), @as(f64, @bitCast(@as(i64, 4644035745745915714))), @as(f64, @bitCast(@as(i64, 4647249977642265849))), @as(f64, @bitCast(@as(i64, 4644051398921214314))), @as(f64, @bitCast(@as(i64, 4647249952485439806))), @as(f64, @bitCast(@as(i64, 4644067026411921290))), @as(f64, @bitCast(@as(i64, 4647249880357477024))), @as(f64, @bitCast(@as(i64, 4644080228819782043))), @as(f64, @bitCast(@as(i64, 4647249773045142153))), @as(f64, @bitCast(@as(i64, 4644088987441447976))), @as(f64, @bitCast(@as(i64, 4647249646381402633))), @as(f64, @bitCast(@as(i64, 4644091977761231806))), @as(f64, @bitCast(@as(i64, 4647249520245428695))), @as(f64, @bitCast(@as(i64, 4644088765603981956))), @as(f64, @bitCast(@as(i64, 4647249413284937544))), @as(f64, @bitCast(@as(i64, 4644079861143093715))), @as(f64, @bitCast(@as(i64, 4647249342036584065))), @as(f64, @bitCast(@as(i64, 4644066628828516686))), @as(f64, @bitCast(@as(i64, 4647053619642981333))), @as(f64, @bitCast(@as(i64, 4644051464364146400))), @as(f64, @bitCast(@as(i64, 4647053594486155290))), @as(f64, @bitCast(@as(i64, 4644035807670410590))), @as(f64, @bitCast(@as(i64, 4647053522006348787))), @as(f64, @bitCast(@as(i64, 4644022537884477287))), @as(f64, @bitCast(@as(i64, 4647053413638482753))), @as(f64, @bitCast(@as(i64, 4644013667024664391))), @as(f64, @bitCast(@as(i64, 4647053285215524629))), @as(f64, @bitCast(@as(i64, 4644010554263265692))), @as(f64, @bitCast(@as(i64, 4647053156968488365))), @as(f64, @bitCast(@as(i64, 4644013694996240201))), @as(f64, @bitCast(@as(i64, 4647053047369169308))), @as(f64, @bitCast(@as(i64, 4644022632530438206))), @as(f64, @bitCast(@as(i64, 4647052974537519084))), @as(f64, @bitCast(@as(i64, 4644036014906362194))), @as(f64, @bitCast(@as(i64, 4647052948677005599))), @as(f64, @bitCast(@as(i64, 4644051795625009616))), @as(f64, @bitCast(@as(i64, 4647052974537519084))), @as(f64, @bitCast(@as(i64, 4644067551186830995))), @as(f64, @bitCast(@as(i64, 4647053047369169308))), @as(f64, @bitCast(@as(i64, 4644080861258870340))), @as(f64, @bitCast(@as(i64, 4647053156968488365))), @as(f64, @bitCast(@as(i64, 4644089690777046032))), @as(f64, @bitCast(@as(i64, 4647053285215524629))), @as(f64, @bitCast(@as(i64, 4644092704670359161))), @as(f64, @bitCast(@as(i64, 4647053413638482753))), @as(f64, @bitCast(@as(i64, 4644089465245220943))), @as(f64, @bitCast(@as(i64, 4647053522006348787))), @as(f64, @bitCast(@as(i64, 4644080487073073175))), @as(f64, @bitCast(@as(i64, 4647053594486155290))), @as(f64, @bitCast(@as(i64, 4644067146390630113))), @as(f64, @bitCast(@as(i64, 4647250111342879787))), @as(f64, @bitCast(@as(i64, 4644051464364146400))), @as(f64, @bitCast(@as(i64, 4647250136499705830))), @as(f64, @bitCast(@as(i64, 4644035807670410590))), @as(f64, @bitCast(@as(i64, 4647250208979512333))), @as(f64, @bitCast(@as(i64, 4644022537884477287))), @as(f64, @bitCast(@as(i64, 4647250317347378367))), @as(f64, @bitCast(@as(i64, 4644013667024664391))), @as(f64, @bitCast(@as(i64, 4647250445770336491))), @as(f64, @bitCast(@as(i64, 4644010554263265692))), @as(f64, @bitCast(@as(i64, 4647250574017372755))), @as(f64, @bitCast(@as(i64, 4644013694996240201))), @as(f64, @bitCast(@as(i64, 4647250683616691812))), @as(f64, @bitCast(@as(i64, 4644022632530438206))), @as(f64, @bitCast(@as(i64, 4647250756448342036))), @as(f64, @bitCast(@as(i64, 4644036014906362194))), @as(f64, @bitCast(@as(i64, 4647250782308855521))), @as(f64, @bitCast(@as(i64, 4644051795625009616))), @as(f64, @bitCast(@as(i64, 4647250756448342036))), @as(f64, @bitCast(@as(i64, 4644067551186830995))), @as(f64, @bitCast(@as(i64, 4647250683616691812))), @as(f64, @bitCast(@as(i64, 4644080861258870340))), @as(f64, @bitCast(@as(i64, 4647250574017372755))), @as(f64, @bitCast(@as(i64, 4644089690777046032))), @as(f64, @bitCast(@as(i64, 4647250445770336491))), @as(f64, @bitCast(@as(i64, 4644092704670359161))), @as(f64, @bitCast(@as(i64, 4647250317347378367))), @as(f64, @bitCast(@as(i64, 4644089465245220943))), @as(f64, @bitCast(@as(i64, 4647250208979512333))), @as(f64, @bitCast(@as(i64, 4644080487073073175))), @as(f64, @bitCast(@as(i64, 4647250136499705830))), @as(f64, @bitCast(@as(i64, 4644067146390630113))), @as(f64, @bitCast(@as(i64, 4647052609323736802))), @as(f64, @bitCast(@as(i64, 4644000681352535705))), @as(f64, @bitCast(@as(i64, 4647251121662124318))), @as(f64, @bitCast(@as(i64, 4644000681352535705))), @as(f64, @bitCast(@as(i64, 4647251121662124318))), @as(f64, @bitCast(@as(i64, 4643795551537445722))), @as(f64, @bitCast(@as(i64, 4647052609323736802))), @as(f64, @bitCast(@as(i64, 4643795551537445722))), @as(f64, @bitCast(@as(i64, 4647083040814922014))), @as(f64, @bitCast(@as(i64, 4644029193888067192))), @as(f64, @bitCast(@as(i64, 4647083040814922014))), @as(f64, @bitCast(@as(i64, 4643990957799465235))), @as(f64, @bitCast(@as(i64, 4647090924401254099))), @as(f64, @bitCast(@as(i64, 4643968926401194371))), @as(f64, @bitCast(@as(i64, 4647090924401254099))), @as(f64, @bitCast(@as(i64, 4644090808936391015))), @as(f64, @bitCast(@as(i64, 4647220690170939106))), @as(f64, @bitCast(@as(i64, 4644029193888067192))), @as(f64, @bitCast(@as(i64, 4647220690170939106))), @as(f64, @bitCast(@as(i64, 4643990957799465235))), @as(f64, @bitCast(@as(i64, 4647212806584607021))), @as(f64, @bitCast(@as(i64, 4643968926401194371))), @as(f64, @bitCast(@as(i64, 4647212806584607021))), @as(f64, @bitCast(@as(i64, 4644090808936391015))), @as(f64, @bitCast(@as(i64, 4647060099372867073))), @as(f64, @bitCast(@as(i64, 4643948898401070245))), @as(f64, @bitCast(@as(i64, 4647243631612994047))), @as(f64, @bitCast(@as(i64, 4643948898401070245))), @as(f64, @bitCast(@as(i64, 4647243631612994047))), @as(f64, @bitCast(@as(i64, 4644048311844407240))), @as(f64, @bitCast(@as(i64, 4647060099372867073))), @as(f64, @bitCast(@as(i64, 4644048311844407240))), @as(f64, @bitCast(@as(i64, 4647058650656346315))), @as(f64, @bitCast(@as(i64, 4643808204541336308))), @as(f64, @bitCast(@as(i64, 4647245080329514805))), @as(f64, @bitCast(@as(i64, 4643808204541336308))), @as(f64, @bitCast(@as(i64, 4647243631612994047))), @as(f64, @bitCast(@as(i64, 4643948898401070245))), @as(f64, @bitCast(@as(i64, 4647060099372867073))), @as(f64, @bitCast(@as(i64, 4643948898401070245))), @as(f64, @bitCast(@as(i64, 4647059469572606683))), @as(f64, @bitCast(@as(i64, 4644048614781850925))), @as(f64, @bitCast(@as(i64, 4647059446702764825))), @as(f64, @bitCast(@as(i64, 4644033888890678726))), @as(f64, @bitCast(@as(i64, 4647059382491285763))), @as(f64, @bitCast(@as(i64, 4644021408114289515))), @as(f64, @bitCast(@as(i64, 4647059286965715542))), @as(f64, @bitCast(@as(i64, 4644013064140448648))), @as(f64, @bitCast(@as(i64, 4647059173144271834))), @as(f64, @bitCast(@as(i64, 4644010135569237834))), @as(f64, @bitCast(@as(i64, 4647059059674671848))), @as(f64, @bitCast(@as(i64, 4644013086130681204))), @as(f64, @bitCast(@as(i64, 4647058963269492324))), @as(f64, @bitCast(@as(i64, 4644021486575439273))), @as(f64, @bitCast(@as(i64, 4647058898178403960))), @as(f64, @bitCast(@as(i64, 4644034066043992193))), @as(f64, @bitCast(@as(i64, 4647058875660405823))), @as(f64, @bitCast(@as(i64, 4644048900830796007))), @as(f64, @bitCast(@as(i64, 4647058898178403960))), @as(f64, @bitCast(@as(i64, 4644063713099601685))), @as(f64, @bitCast(@as(i64, 4647058963269492324))), @as(f64, @bitCast(@as(i64, 4644076230291816008))), @as(f64, @bitCast(@as(i64, 4647059059674671848))), @as(f64, @bitCast(@as(i64, 4644084537322066181))), @as(f64, @bitCast(@as(i64, 4647059173144271834))), @as(f64, @bitCast(@as(i64, 4644087378811956075))), @as(f64, @bitCast(@as(i64, 4647059286965715542))), @as(f64, @bitCast(@as(i64, 4644084340641426204))), @as(f64, @bitCast(@as(i64, 4647059382491285763))), @as(f64, @bitCast(@as(i64, 4644075904484530465))), @as(f64, @bitCast(@as(i64, 4647059446702764825))), @as(f64, @bitCast(@as(i64, 4644063361431802657))), @as(f64, @bitCast(@as(i64, 4647244261413254437))), @as(f64, @bitCast(@as(i64, 4644048614781850925))), @as(f64, @bitCast(@as(i64, 4647244284283096295))), @as(f64, @bitCast(@as(i64, 4644033888890678726))), @as(f64, @bitCast(@as(i64, 4647244348494575357))), @as(f64, @bitCast(@as(i64, 4644021408114289515))), @as(f64, @bitCast(@as(i64, 4647244444020145578))), @as(f64, @bitCast(@as(i64, 4644013064140448648))), @as(f64, @bitCast(@as(i64, 4647244557841589286))), @as(f64, @bitCast(@as(i64, 4644010135569237834))), @as(f64, @bitCast(@as(i64, 4647244671311189272))), @as(f64, @bitCast(@as(i64, 4644013086130681204))), @as(f64, @bitCast(@as(i64, 4647244767716368796))), @as(f64, @bitCast(@as(i64, 4644021486575439273))), @as(f64, @bitCast(@as(i64, 4647244832807457160))), @as(f64, @bitCast(@as(i64, 4644034066043992193))), @as(f64, @bitCast(@as(i64, 4647244855325455297))), @as(f64, @bitCast(@as(i64, 4644048900830796007))), @as(f64, @bitCast(@as(i64, 4647244832807457160))), @as(f64, @bitCast(@as(i64, 4644063713099601685))), @as(f64, @bitCast(@as(i64, 4647244767716368796))), @as(f64, @bitCast(@as(i64, 4644076230291816008))), @as(f64, @bitCast(@as(i64, 4647244671311189272))), @as(f64, @bitCast(@as(i64, 4644084537322066181))), @as(f64, @bitCast(@as(i64, 4647244557841589286))), @as(f64, @bitCast(@as(i64, 4644087378811956075))), @as(f64, @bitCast(@as(i64, 4647244444020145578))), @as(f64, @bitCast(@as(i64, 4644084340641426204))), @as(f64, @bitCast(@as(i64, 4647244348494575357))), @as(f64, @bitCast(@as(i64, 4644075904484530465))), @as(f64, @bitCast(@as(i64, 4647244284283096295))), @as(f64, @bitCast(@as(i64, 4644063361431802657))), @as(f64, @bitCast(@as(i64, 4647057710705845962))), @as(f64, @bitCast(@as(i64, 4644049464132593150))), @as(f64, @bitCast(@as(i64, 4647057687484160383))), @as(f64, @bitCast(@as(i64, 4644034458525662844))), @as(f64, @bitCast(@as(i64, 4647057620985697135))), @as(f64, @bitCast(@as(i64, 4644021740606605754))), @as(f64, @bitCast(@as(i64, 4647057521238002264))), @as(f64, @bitCast(@as(i64, 4644013238303090488))), @as(f64, @bitCast(@as(i64, 4647057403546277627))), @as(f64, @bitCast(@as(i64, 4644010253612806192))), @as(f64, @bitCast(@as(i64, 4647057285502709268))), @as(f64, @bitCast(@as(i64, 4644013261700697927))), @as(f64, @bitCast(@as(i64, 4647057185051326955))), @as(f64, @bitCast(@as(i64, 4644021823817645744))), @as(f64, @bitCast(@as(i64, 4647057118025098126))), @as(f64, @bitCast(@as(i64, 4644034644475069334))), @as(f64, @bitCast(@as(i64, 4647057094275646966))), @as(f64, @bitCast(@as(i64, 4644049763199755905))), @as(f64, @bitCast(@as(i64, 4647057118025098126))), @as(f64, @bitCast(@as(i64, 4644064859406444339))), @as(f64, @bitCast(@as(i64, 4647057185051326955))), @as(f64, @bitCast(@as(i64, 4644077614796857703))), @as(f64, @bitCast(@as(i64, 4647057285502709268))), @as(f64, @bitCast(@as(i64, 4644086079101251113))), @as(f64, @bitCast(@as(i64, 4647057403546277627))), @as(f64, @bitCast(@as(i64, 4644088972312167978))), @as(f64, @bitCast(@as(i64, 4647057521238002264))), @as(f64, @bitCast(@as(i64, 4644085873624518115))), @as(f64, @bitCast(@as(i64, 4647057620985697135))), @as(f64, @bitCast(@as(i64, 4644077274563979604))), @as(f64, @bitCast(@as(i64, 4647057687484160383))), @as(f64, @bitCast(@as(i64, 4644064492081599731))), @as(f64, @bitCast(@as(i64, 4647246020280015158))), @as(f64, @bitCast(@as(i64, 4644049464132593150))), @as(f64, @bitCast(@as(i64, 4647246043501700737))), @as(f64, @bitCast(@as(i64, 4644034458525662844))), @as(f64, @bitCast(@as(i64, 4647246110000163985))), @as(f64, @bitCast(@as(i64, 4644021740606605754))), @as(f64, @bitCast(@as(i64, 4647246209747858856))), @as(f64, @bitCast(@as(i64, 4644013238303090488))), @as(f64, @bitCast(@as(i64, 4647246327439583493))), @as(f64, @bitCast(@as(i64, 4644010253612806192))), @as(f64, @bitCast(@as(i64, 4647246445483151852))), @as(f64, @bitCast(@as(i64, 4644013261700697927))), @as(f64, @bitCast(@as(i64, 4647246545934534165))), @as(f64, @bitCast(@as(i64, 4644021823817645744))), @as(f64, @bitCast(@as(i64, 4647246612960762994))), @as(f64, @bitCast(@as(i64, 4644034644475069334))), @as(f64, @bitCast(@as(i64, 4647246636710214154))), @as(f64, @bitCast(@as(i64, 4644049763199755905))), @as(f64, @bitCast(@as(i64, 4647246612960762994))), @as(f64, @bitCast(@as(i64, 4644064859406444339))), @as(f64, @bitCast(@as(i64, 4647246545934534165))), @as(f64, @bitCast(@as(i64, 4644077614796857703))), @as(f64, @bitCast(@as(i64, 4647246445483151852))), @as(f64, @bitCast(@as(i64, 4644086079101251113))), @as(f64, @bitCast(@as(i64, 4647246327439583493))), @as(f64, @bitCast(@as(i64, 4644088972312167978))), @as(f64, @bitCast(@as(i64, 4647246209747858856))), @as(f64, @bitCast(@as(i64, 4644085873624518115))), @as(f64, @bitCast(@as(i64, 4647246110000163985))), @as(f64, @bitCast(@as(i64, 4644077274563979604))), @as(f64, @bitCast(@as(i64, 4647246043501700737))), @as(f64, @bitCast(@as(i64, 4644064492081599731))), @as(f64, @bitCast(@as(i64, 4647052609323736802))), @as(f64, @bitCast(@as(i64, 4644000681352535705))), @as(f64, @bitCast(@as(i64, 4647052609323736802))), @as(f64, @bitCast(@as(i64, 4643795551537445722))), @as(f64, @bitCast(@as(i64, 4647058650656346315))), @as(f64, @bitCast(@as(i64, 4643808204541336308))), @as(f64, @bitCast(@as(i64, 4647060099372867073))), @as(f64, @bitCast(@as(i64, 4643948898401070245))), @as(f64, @bitCast(@as(i64, 4647060099372867073))), @as(f64, @bitCast(@as(i64, 4644048311844407240))), @as(f64, @bitCast(@as(i64, 4647058016106195693))), @as(f64, @bitCast(@as(i64, 4644049315830464795))), @as(f64, @bitCast(@as(i64, 4647058016106195693))), @as(f64, @bitCast(@as(i64, 4644000827367679874))), @as(f64, @bitCast(@as(i64, 4647251121662124318))), @as(f64, @bitCast(@as(i64, 4644000681352535705))), @as(f64, @bitCast(@as(i64, 4647251121662124318))), @as(f64, @bitCast(@as(i64, 4643795551537445722))), @as(f64, @bitCast(@as(i64, 4647245080329514805))), @as(f64, @bitCast(@as(i64, 4643808204541336308))), @as(f64, @bitCast(@as(i64, 4647243631612994047))), @as(f64, @bitCast(@as(i64, 4643948898401070245))), @as(f64, @bitCast(@as(i64, 4647243631612994047))), @as(f64, @bitCast(@as(i64, 4644048311844407240))), @as(f64, @bitCast(@as(i64, 4647245714879665427))), @as(f64, @bitCast(@as(i64, 4644049315830464795))), @as(f64, @bitCast(@as(i64, 4647245714879665427))), @as(f64, @bitCast(@as(i64, 4644000827367679874))), @as(f64, @bitCast(@as(i64, 4647056969722969771))), @as(f64, @bitCast(@as(i64, 4644049823716875897))), @as(f64, @bitCast(@as(i64, 4647056946149440472))), @as(f64, @bitCast(@as(i64, 4644034700066377234))), @as(f64, @bitCast(@as(i64, 4647056878595446061))), @as(f64, @bitCast(@as(i64, 4644021882223703412))), @as(f64, @bitCast(@as(i64, 4647056777616298166))), @as(f64, @bitCast(@as(i64, 4644013313245803037))), @as(f64, @bitCast(@as(i64, 4647056657813511204))), @as(f64, @bitCast(@as(i64, 4644010305685676884))), @as(f64, @bitCast(@as(i64, 4647056537658880520))), @as(f64, @bitCast(@as(i64, 4644013338050785360))), @as(f64, @bitCast(@as(i64, 4647056435624201463))), @as(f64, @bitCast(@as(i64, 4644021967545805727))), @as(f64, @bitCast(@as(i64, 4647056367366519610))), @as(f64, @bitCast(@as(i64, 4644034889534220932))), @as(f64, @bitCast(@as(i64, 4647056343792990311))), @as(f64, @bitCast(@as(i64, 4644050128765381908))), @as(f64, @bitCast(@as(i64, 4647056367366519610))), @as(f64, @bitCast(@as(i64, 4644065344598935444))), @as(f64, @bitCast(@as(i64, 4647056435624201463))), @as(f64, @bitCast(@as(i64, 4644078200088887401))), @as(f64, @bitCast(@as(i64, 4647056537658880520))), @as(f64, @bitCast(@as(i64, 4644086730363978478))), @as(f64, @bitCast(@as(i64, 4647056657813511204))), @as(f64, @bitCast(@as(i64, 4644089645565127898))), @as(f64, @bitCast(@as(i64, 4647056777616298166))), @as(f64, @bitCast(@as(i64, 4644086521544730131))), @as(f64, @bitCast(@as(i64, 4647056878595446061))), @as(f64, @bitCast(@as(i64, 4644077853698744186))), @as(f64, @bitCast(@as(i64, 4647056946149440472))), @as(f64, @bitCast(@as(i64, 4644064970413138279))), @as(f64, @bitCast(@as(i64, 4647246761262891349))), @as(f64, @bitCast(@as(i64, 4644049823716875897))), @as(f64, @bitCast(@as(i64, 4647246784836420648))), @as(f64, @bitCast(@as(i64, 4644034700066377234))), @as(f64, @bitCast(@as(i64, 4647246852390415059))), @as(f64, @bitCast(@as(i64, 4644021882223703412))), @as(f64, @bitCast(@as(i64, 4647246953369562954))), @as(f64, @bitCast(@as(i64, 4644013313245803037))), @as(f64, @bitCast(@as(i64, 4647247073172349916))), @as(f64, @bitCast(@as(i64, 4644010305685676884))), @as(f64, @bitCast(@as(i64, 4647247193326980600))), @as(f64, @bitCast(@as(i64, 4644013338050785360))), @as(f64, @bitCast(@as(i64, 4647247295361659657))), @as(f64, @bitCast(@as(i64, 4644021967545805727))), @as(f64, @bitCast(@as(i64, 4647247363619341510))), @as(f64, @bitCast(@as(i64, 4644034889534220932))), @as(f64, @bitCast(@as(i64, 4647247387192870809))), @as(f64, @bitCast(@as(i64, 4644050128765381908))), @as(f64, @bitCast(@as(i64, 4647247363619341510))), @as(f64, @bitCast(@as(i64, 4644065344598935444))), @as(f64, @bitCast(@as(i64, 4647247295361659657))), @as(f64, @bitCast(@as(i64, 4644078200088887401))), @as(f64, @bitCast(@as(i64, 4647247193326980600))), @as(f64, @bitCast(@as(i64, 4644086730363978478))), @as(f64, @bitCast(@as(i64, 4647247073172349916))), @as(f64, @bitCast(@as(i64, 4644089645565127898))), @as(f64, @bitCast(@as(i64, 4647246953369562954))), @as(f64, @bitCast(@as(i64, 4644086521544730131))), @as(f64, @bitCast(@as(i64, 4647246852390415059))), @as(f64, @bitCast(@as(i64, 4644077853698744186))), @as(f64, @bitCast(@as(i64, 4647246784836420648))), @as(f64, @bitCast(@as(i64, 4644064970413138279))), @as(f64, @bitCast(@as(i64, 4647052609323736802))), @as(f64, @bitCast(@as(i64, 4643795551537445722))), @as(f64, @bitCast(@as(i64, 4647251121662124318))), @as(f64, @bitCast(@as(i64, 4643795551537445722))), @as(f64, @bitCast(@as(i64, 4647245080329514805))), @as(f64, @bitCast(@as(i64, 4643808204541336308))), @as(f64, @bitCast(@as(i64, 4647058650656346315))), @as(f64, @bitCast(@as(i64, 4643808204541336308))), @as(f64, @bitCast(@as(i64, 4647054413578337518))), @as(f64, @bitCast(@as(i64, 4644051073817616214))), @as(f64, @bitCast(@as(i64, 4647054388949277055))), @as(f64, @bitCast(@as(i64, 4644035542908010622))), @as(f64, @bitCast(@as(i64, 4647054317700923576))), @as(f64, @bitCast(@as(i64, 4644022380610334050))), @as(f64, @bitCast(@as(i64, 4647054210740432425))), @as(f64, @bitCast(@as(i64, 4644013581350718354))), @as(f64, @bitCast(@as(i64, 4647054084604458487))), @as(f64, @bitCast(@as(i64, 4644010493922067559))), @as(f64, @bitCast(@as(i64, 4647053957940718967))), @as(f64, @bitCast(@as(i64, 4644013608618606723))), @as(f64, @bitCast(@as(i64, 4647053850628384096))), @as(f64, @bitCast(@as(i64, 4644022472793388923))), @as(f64, @bitCast(@as(i64, 4647053778500421314))), @as(f64, @bitCast(@as(i64, 4644035745745915714))), @as(f64, @bitCast(@as(i64, 4647053753343595271))), @as(f64, @bitCast(@as(i64, 4644051398921214314))), @as(f64, @bitCast(@as(i64, 4647053778500421314))), @as(f64, @bitCast(@as(i64, 4644067026411921290))), @as(f64, @bitCast(@as(i64, 4647053850628384096))), @as(f64, @bitCast(@as(i64, 4644080228819782043))), @as(f64, @bitCast(@as(i64, 4647053957940718967))), @as(f64, @bitCast(@as(i64, 4644088987441447976))), @as(f64, @bitCast(@as(i64, 4647054084604458487))), @as(f64, @bitCast(@as(i64, 4644091977761231806))), @as(f64, @bitCast(@as(i64, 4647054210740432425))), @as(f64, @bitCast(@as(i64, 4644088765603981956))), @as(f64, @bitCast(@as(i64, 4647054317700923576))), @as(f64, @bitCast(@as(i64, 4644079861143093715))), @as(f64, @bitCast(@as(i64, 4647054388949277055))), @as(f64, @bitCast(@as(i64, 4644066628828516686))), @as(f64, @bitCast(@as(i64, 4647249317407523602))), @as(f64, @bitCast(@as(i64, 4644051073817616214))), @as(f64, @bitCast(@as(i64, 4647249342036584065))), @as(f64, @bitCast(@as(i64, 4644035542908010622))), @as(f64, @bitCast(@as(i64, 4647249413284937544))), @as(f64, @bitCast(@as(i64, 4644022380610334050))), @as(f64, @bitCast(@as(i64, 4647249520245428695))), @as(f64, @bitCast(@as(i64, 4644013581350718354))), @as(f64, @bitCast(@as(i64, 4647249646381402633))), @as(f64, @bitCast(@as(i64, 4644010493922067559))), @as(f64, @bitCast(@as(i64, 4647249773045142153))), @as(f64, @bitCast(@as(i64, 4644013608618606723))), @as(f64, @bitCast(@as(i64, 4647249880357477024))), @as(f64, @bitCast(@as(i64, 4644022472793388923))), @as(f64, @bitCast(@as(i64, 4647249952485439806))), @as(f64, @bitCast(@as(i64, 4644035745745915714))), @as(f64, @bitCast(@as(i64, 4647249977642265849))), @as(f64, @bitCast(@as(i64, 4644051398921214314))), @as(f64, @bitCast(@as(i64, 4647249952485439806))), @as(f64, @bitCast(@as(i64, 4644067026411921290))), @as(f64, @bitCast(@as(i64, 4647249880357477024))), @as(f64, @bitCast(@as(i64, 4644080228819782043))), @as(f64, @bitCast(@as(i64, 4647249773045142153))), @as(f64, @bitCast(@as(i64, 4644088987441447976))), @as(f64, @bitCast(@as(i64, 4647249646381402633))), @as(f64, @bitCast(@as(i64, 4644091977761231806))), @as(f64, @bitCast(@as(i64, 4647249520245428695))), @as(f64, @bitCast(@as(i64, 4644088765603981956))), @as(f64, @bitCast(@as(i64, 4647249413284937544))), @as(f64, @bitCast(@as(i64, 4644079861143093715))), @as(f64, @bitCast(@as(i64, 4647249342036584065))), @as(f64, @bitCast(@as(i64, 4644066628828516686))), @as(f64, @bitCast(@as(i64, 4647053619642981333))), @as(f64, @bitCast(@as(i64, 4644051464364146400))), @as(f64, @bitCast(@as(i64, 4647053594486155290))), @as(f64, @bitCast(@as(i64, 4644035807670410590))), @as(f64, @bitCast(@as(i64, 4647053522006348787))), @as(f64, @bitCast(@as(i64, 4644022537884477287))), @as(f64, @bitCast(@as(i64, 4647053413638482753))), @as(f64, @bitCast(@as(i64, 4644013667024664391))), @as(f64, @bitCast(@as(i64, 4647053285215524629))), @as(f64, @bitCast(@as(i64, 4644010554263265692))), @as(f64, @bitCast(@as(i64, 4647053156968488365))), @as(f64, @bitCast(@as(i64, 4644013694996240201))), @as(f64, @bitCast(@as(i64, 4647053047369169308))), @as(f64, @bitCast(@as(i64, 4644022632530438206))), @as(f64, @bitCast(@as(i64, 4647052974537519084))), @as(f64, @bitCast(@as(i64, 4644036014906362194))), @as(f64, @bitCast(@as(i64, 4647052948677005599))), @as(f64, @bitCast(@as(i64, 4644051795625009616))), @as(f64, @bitCast(@as(i64, 4647052974537519084))), @as(f64, @bitCast(@as(i64, 4644067551186830995))), @as(f64, @bitCast(@as(i64, 4647053047369169308))), @as(f64, @bitCast(@as(i64, 4644080861258870340))), @as(f64, @bitCast(@as(i64, 4647053156968488365))), @as(f64, @bitCast(@as(i64, 4644089690777046032))), @as(f64, @bitCast(@as(i64, 4647053285215524629))), @as(f64, @bitCast(@as(i64, 4644092704670359161))), @as(f64, @bitCast(@as(i64, 4647053413638482753))), @as(f64, @bitCast(@as(i64, 4644089465245220943))), @as(f64, @bitCast(@as(i64, 4647053522006348787))), @as(f64, @bitCast(@as(i64, 4644080487073073175))), @as(f64, @bitCast(@as(i64, 4647053594486155290))), @as(f64, @bitCast(@as(i64, 4644067146390630113))), @as(f64, @bitCast(@as(i64, 4647250111342879787))), @as(f64, @bitCast(@as(i64, 4644051464364146400))), @as(f64, @bitCast(@as(i64, 4647250136499705830))), @as(f64, @bitCast(@as(i64, 4644035807670410590))), @as(f64, @bitCast(@as(i64, 4647250208979512333))), @as(f64, @bitCast(@as(i64, 4644022537884477287))), @as(f64, @bitCast(@as(i64, 4647250317347378367))), @as(f64, @bitCast(@as(i64, 4644013667024664391))), @as(f64, @bitCast(@as(i64, 4647250445770336491))), @as(f64, @bitCast(@as(i64, 4644010554263265692))), @as(f64, @bitCast(@as(i64, 4647250574017372755))), @as(f64, @bitCast(@as(i64, 4644013694996240201))), @as(f64, @bitCast(@as(i64, 4647250683616691812))), @as(f64, @bitCast(@as(i64, 4644022632530438206))), @as(f64, @bitCast(@as(i64, 4647250756448342036))), @as(f64, @bitCast(@as(i64, 4644036014906362194))), @as(f64, @bitCast(@as(i64, 4647250782308855521))), @as(f64, @bitCast(@as(i64, 4644051795625009616))), @as(f64, @bitCast(@as(i64, 4647250756448342036))), @as(f64, @bitCast(@as(i64, 4644067551186830995))), @as(f64, @bitCast(@as(i64, 4647250683616691812))), @as(f64, @bitCast(@as(i64, 4644080861258870340))), @as(f64, @bitCast(@as(i64, 4647250574017372755))), @as(f64, @bitCast(@as(i64, 4644089690777046032))), @as(f64, @bitCast(@as(i64, 4647250445770336491))), @as(f64, @bitCast(@as(i64, 4644092704670359161))), @as(f64, @bitCast(@as(i64, 4647250317347378367))), @as(f64, @bitCast(@as(i64, 4644089465245220943))), @as(f64, @bitCast(@as(i64, 4647250208979512333))), @as(f64, @bitCast(@as(i64, 4644080487073073175))), @as(f64, @bitCast(@as(i64, 4647250136499705830))), @as(f64, @bitCast(@as(i64, 4644067146390630113))), @as(f64, @bitCast(@as(i64, 4647052609323736802))), @as(f64, @bitCast(@as(i64, 4644000681352535705))), @as(f64, @bitCast(@as(i64, 4647251121662124318))), @as(f64, @bitCast(@as(i64, 4644000681352535705))), @as(f64, @bitCast(@as(i64, 4647251121662124318))), @as(f64, @bitCast(@as(i64, 4643795551537445722))), @as(f64, @bitCast(@as(i64, 4647052609323736802))), @as(f64, @bitCast(@as(i64, 4643795551537445722))), @as(f64, @bitCast(@as(i64, 4647226777243232334))), @as(f64, @bitCast(@as(i64, 4643928885530226118))), @as(f64, @bitCast(@as(i64, 4647216994932260476))), @as(f64, @bitCast(@as(i64, 4643978063958547701))), @as(f64, @bitCast(@as(i64, 4647189137705659143))), @as(f64, @bitCast(@as(i64, 4644019755680254363))), @as(f64, @bitCast(@as(i64, 4647147445983952482))), @as(f64, @bitCast(@as(i64, 4644047612906855696))), @as(f64, @bitCast(@as(i64, 4647098267379709038))), @as(f64, @bitCast(@as(i64, 4644057395217827554))), @as(f64, @bitCast(@as(i64, 4647049089127309315))), @as(f64, @bitCast(@as(i64, 4644047612906855696))), @as(f64, @bitCast(@as(i64, 4647007397229680793))), @as(f64, @bitCast(@as(i64, 4644019755680254363))), @as(f64, @bitCast(@as(i64, 4646979540179001320))), @as(f64, @bitCast(@as(i64, 4643978063958547701))), @as(f64, @bitCast(@as(i64, 4646969757868029462))), @as(f64, @bitCast(@as(i64, 4643928885530226118))), @as(f64, @bitCast(@as(i64, 4646979540179001320))), @as(f64, @bitCast(@as(i64, 4643879707101904534))), @as(f64, @bitCast(@as(i64, 4647007397229680793))), @as(f64, @bitCast(@as(i64, 4643838015380197873))), @as(f64, @bitCast(@as(i64, 4647049089127309315))), @as(f64, @bitCast(@as(i64, 4643810158153596540))), @as(f64, @bitCast(@as(i64, 4647098267379709038))), @as(f64, @bitCast(@as(i64, 4643800375842624682))), @as(f64, @bitCast(@as(i64, 4647147445983952482))), @as(f64, @bitCast(@as(i64, 4643810158153596540))), @as(f64, @bitCast(@as(i64, 4647189137705659143))), @as(f64, @bitCast(@as(i64, 4643838015380197873))), @as(f64, @bitCast(@as(i64, 4647216994932260476))), @as(f64, @bitCast(@as(i64, 4643879707101904534))), @as(f64, @bitCast(@as(i64, 4647072460698313042))), @as(f64, @bitCast(@as(i64, 4643959655143227104))), @as(f64, @bitCast(@as(i64, 4647124073885183173))), @as(f64, @bitCast(@as(i64, 4643959654615461522))), @as(f64, @bitCast(@as(i64, 4647124073885183173))), @as(f64, @bitCast(@as(i64, 4643898115917225132))), @as(f64, @bitCast(@as(i64, 4647072460698313042))), @as(f64, @bitCast(@as(i64, 4643898116444990713))), @as(f64, @bitCast(@as(i64, 4647333973117831658))), @as(f64, @bitCast(@as(i64, 4643928885530226118))), @as(f64, @bitCast(@as(i64, 4647324190806859800))), @as(f64, @bitCast(@as(i64, 4643978063958547701))), @as(f64, @bitCast(@as(i64, 4647296333756180327))), @as(f64, @bitCast(@as(i64, 4644019755680254363))), @as(f64, @bitCast(@as(i64, 4647254641858551805))), @as(f64, @bitCast(@as(i64, 4644047612906855696))), @as(f64, @bitCast(@as(i64, 4647205463606152082))), @as(f64, @bitCast(@as(i64, 4644057395217827554))), @as(f64, @bitCast(@as(i64, 4647156285001908638))), @as(f64, @bitCast(@as(i64, 4644047612906855696))), @as(f64, @bitCast(@as(i64, 4647114593280201977))), @as(f64, @bitCast(@as(i64, 4644019755680254363))), @as(f64, @bitCast(@as(i64, 4647086736053600644))), @as(f64, @bitCast(@as(i64, 4643978063958547701))), @as(f64, @bitCast(@as(i64, 4647076953742628786))), @as(f64, @bitCast(@as(i64, 4643928885530226118))), @as(f64, @bitCast(@as(i64, 4647086736053600644))), @as(f64, @bitCast(@as(i64, 4643879707101904534))), @as(f64, @bitCast(@as(i64, 4647114593280201977))), @as(f64, @bitCast(@as(i64, 4643838015380197873))), @as(f64, @bitCast(@as(i64, 4647156285001908638))), @as(f64, @bitCast(@as(i64, 4643810158153596540))), @as(f64, @bitCast(@as(i64, 4647205463606152082))), @as(f64, @bitCast(@as(i64, 4643800375842624682))), @as(f64, @bitCast(@as(i64, 4647254641858551805))), @as(f64, @bitCast(@as(i64, 4643810158153596540))), @as(f64, @bitCast(@as(i64, 4647296333756180327))), @as(f64, @bitCast(@as(i64, 4643838015380197873))), @as(f64, @bitCast(@as(i64, 4647324190806859800))), @as(f64, @bitCast(@as(i64, 4643879707101904534))), @as(f64, @bitCast(@as(i64, 4647179657100677947))), @as(f64, @bitCast(@as(i64, 4643959654615461522))), @as(f64, @bitCast(@as(i64, 4647231270287548078))), @as(f64, @bitCast(@as(i64, 4643959655143227104))), @as(f64, @bitCast(@as(i64, 4647231270287548078))), @as(f64, @bitCast(@as(i64, 4643898116444990713))), @as(f64, @bitCast(@as(i64, 4647179657100677947))), @as(f64, @bitCast(@as(i64, 4643898115917225132))), @as(f64, @bitCast(@as(i64, 4652723733025662173))), @as(f64, @bitCast(@as(i64, 4644039949046927306))), @as(f64, @bitCast(@as(i64, 4652723733025662173))), @as(f64, @bitCast(@as(i64, 4643997510536923059))), @as(f64, @bitCast(@as(i64, 4652815705414107031))), @as(f64, @bitCast(@as(i64, 4643972442375497208))), @as(f64, @bitCast(@as(i64, 4652815705414107031))), @as(f64, @bitCast(@as(i64, 4644113183734133466))), @as(f64, @bitCast(@as(i64, 4652776510463404723))), @as(f64, @bitCast(@as(i64, 4644040461859150501))), @as(f64, @bitCast(@as(i64, 4652776510463404723))), @as(f64, @bitCast(@as(i64, 4643997587238854213))), @as(f64, @bitCast(@as(i64, 4652865155729663931))), @as(f64, @bitCast(@as(i64, 4643972275425651647))), @as(f64, @bitCast(@as(i64, 4652865155729663931))), @as(f64, @bitCast(@as(i64, 4644114348688693327))), @as(f64, @bitCast(@as(i64, 4652709726127133609))), @as(f64, @bitCast(@as(i64, 4644061213425886634))), @as(f64, @bitCast(@as(i64, 4652709537011133632))), @as(f64, @bitCast(@as(i64, 4644044930098483922))), @as(f64, @bitCast(@as(i64, 4652708999130045324))), @as(f64, @bitCast(@as(i64, 4644031124278641846))), @as(f64, @bitCast(@as(i64, 4652708191648705885))), @as(f64, @bitCast(@as(i64, 4644021891371640155))), @as(f64, @bitCast(@as(i64, 4652707238152222278))), @as(f64, @bitCast(@as(i64, 4644018643326330774))), @as(f64, @bitCast(@as(i64, 4652706282456715415))), @as(f64, @bitCast(@as(i64, 4644021887677281086))), @as(f64, @bitCast(@as(i64, 4652705471456938767))), @as(f64, @bitCast(@as(i64, 4644031144861499518))), @as(f64, @bitCast(@as(i64, 4652704929617608599))), @as(f64, @bitCast(@as(i64, 4644045010670696006))), @as(f64, @bitCast(@as(i64, 4652704738302585366))), @as(f64, @bitCast(@as(i64, 4644061369116733127))), @as(f64, @bitCast(@as(i64, 4652704929617608599))), @as(f64, @bitCast(@as(i64, 4644077715776005598))), @as(f64, @bitCast(@as(i64, 4652705471456938767))), @as(f64, @bitCast(@as(i64, 4644091547808204881))), @as(f64, @bitCast(@as(i64, 4652706282456715415))), @as(f64, @bitCast(@as(i64, 4644100754151005644))), @as(f64, @bitCast(@as(i64, 4652707238152222278))), @as(f64, @bitCast(@as(i64, 4644103938688523405))), @as(f64, @bitCast(@as(i64, 4652708191648705885))), @as(f64, @bitCast(@as(i64, 4644100631005703333))), @as(f64, @bitCast(@as(i64, 4652708999130045324))), @as(f64, @bitCast(@as(i64, 4644091347960971416))), @as(f64, @bitCast(@as(i64, 4652709537011133632))), @as(f64, @bitCast(@as(i64, 4644077507836366553))), @as(f64, @bitCast(@as(i64, 4652715042045951581))), @as(f64, @bitCast(@as(i64, 4643950895114186287))), @as(f64, @bitCast(@as(i64, 4652785412109543198))), @as(f64, @bitCast(@as(i64, 4643950357145137048))), @as(f64, @bitCast(@as(i64, 4652785412109543198))), @as(f64, @bitCast(@as(i64, 4644062023194210258))), @as(f64, @bitCast(@as(i64, 4652715042045951581))), @as(f64, @bitCast(@as(i64, 4644061048059337816))), @as(f64, @bitCast(@as(i64, 4652702857258092567))), @as(f64, @bitCast(@as(i64, 4643796033563343339))), @as(f64, @bitCast(@as(i64, 4652773798188121326))), @as(f64, @bitCast(@as(i64, 4643793341255191101))), @as(f64, @bitCast(@as(i64, 4652785412109543198))), @as(f64, @bitCast(@as(i64, 4643950357145137048))), @as(f64, @bitCast(@as(i64, 4652715042045951581))), @as(f64, @bitCast(@as(i64, 4643950895114186287))), @as(f64, @bitCast(@as(i64, 4652695018179991175))), @as(f64, @bitCast(@as(i64, 4644061675748535881))), @as(f64, @bitCast(@as(i64, 4652694823786335384))), @as(f64, @bitCast(@as(i64, 4644045189935071798))), @as(f64, @bitCast(@as(i64, 4652694271831498241))), @as(f64, @bitCast(@as(i64, 4644031212239572068))), @as(f64, @bitCast(@as(i64, 4652693443679340200))), @as(f64, @bitCast(@as(i64, 4644021864631517368))), @as(f64, @bitCast(@as(i64, 4652692467313014735))), @as(f64, @bitCast(@as(i64, 4644018576300101945))), @as(f64, @bitCast(@as(i64, 4652691488747666014))), @as(f64, @bitCast(@as(i64, 4644021861992689461))), @as(f64, @bitCast(@as(i64, 4652690657077070764))), @as(f64, @bitCast(@as(i64, 4644031235109413926))), @as(f64, @bitCast(@as(i64, 4652690098964968505))), @as(f64, @bitCast(@as(i64, 4644045274905330393))), @as(f64, @bitCast(@as(i64, 4652689904571312715))), @as(f64, @bitCast(@as(i64, 4644061837772569350))), @as(f64, @bitCast(@as(i64, 4652690098964968505))), @as(f64, @bitCast(@as(i64, 4644078388501199937))), @as(f64, @bitCast(@as(i64, 4652690657077070764))), @as(f64, @bitCast(@as(i64, 4644092392584978733))), @as(f64, @bitCast(@as(i64, 4652691488747666014))), @as(f64, @bitCast(@as(i64, 4644101713452910646))), @as(f64, @bitCast(@as(i64, 4652692467313014735))), @as(f64, @bitCast(@as(i64, 4644104936165472123))), @as(f64, @bitCast(@as(i64, 4652693443679340200))), @as(f64, @bitCast(@as(i64, 4644101586261405545))), @as(f64, @bitCast(@as(i64, 4652694271831498241))), @as(f64, @bitCast(@as(i64, 4644092186052714572))), @as(f64, @bitCast(@as(i64, 4652694823786335384))), @as(f64, @bitCast(@as(i64, 4644078173172842753))), @as(f64, @bitCast(@as(i64, 4652653397706637994))), @as(f64, @bitCast(@as(i64, 4644007732476624167))), @as(f64, @bitCast(@as(i64, 4652653397706637994))), @as(f64, @bitCast(@as(i64, 4643786578818875628))), @as(f64, @bitCast(@as(i64, 4652702857258092567))), @as(f64, @bitCast(@as(i64, 4643796033563343339))), @as(f64, @bitCast(@as(i64, 4652715042045951581))), @as(f64, @bitCast(@as(i64, 4643950895114186287))), @as(f64, @bitCast(@as(i64, 4652715042045951581))), @as(f64, @bitCast(@as(i64, 4644061048059337816))), @as(f64, @bitCast(@as(i64, 4652697558491655989))), @as(f64, @bitCast(@as(i64, 4644061595176323797))), @as(f64, @bitCast(@as(i64, 4652697558491655989))), @as(f64, @bitCast(@as(i64, 4644008279593610149))), @as(f64, @bitCast(@as(i64, 4652780345120157755))), @as(f64, @bitCast(@as(i64, 4644062194893946052))), @as(f64, @bitCast(@as(i64, 4652780165679860102))), @as(f64, @bitCast(@as(i64, 4644045687090249413))), @as(f64, @bitCast(@as(i64, 4652779652427832256))), @as(f64, @bitCast(@as(i64, 4644031690747032476))), @as(f64, @bitCast(@as(i64, 4652778883209497464))), @as(f64, @bitCast(@as(i64, 4644022331176291265))), @as(f64, @bitCast(@as(i64, 4652777973693478968))), @as(f64, @bitCast(@as(i64, 4644019038446829332))), @as(f64, @bitCast(@as(i64, 4652777063737655820))), @as(f64, @bitCast(@as(i64, 4644022327833775917))), @as(f64, @bitCast(@as(i64, 4652776289681469866))), @as(f64, @bitCast(@as(i64, 4644031713616874334))), @as(f64, @bitCast(@as(i64, 4652775772911004811))), @as(f64, @bitCast(@as(i64, 4644045772060508008))), @as(f64, @bitCast(@as(i64, 4652775591711488554))), @as(f64, @bitCast(@as(i64, 4644062356917979521))), @as(f64, @bitCast(@as(i64, 4652775772911004811))), @as(f64, @bitCast(@as(i64, 4644078929636842663))), @as(f64, @bitCast(@as(i64, 4652776289681469866))), @as(f64, @bitCast(@as(i64, 4644092952720182388))), @as(f64, @bitCast(@as(i64, 4652777063737655820))), @as(f64, @bitCast(@as(i64, 4644102285726722671))), @as(f64, @bitCast(@as(i64, 4652777973693478968))), @as(f64, @bitCast(@as(i64, 4644105512837330659))), @as(f64, @bitCast(@as(i64, 4652778883209497464))), @as(f64, @bitCast(@as(i64, 4644102158007451989))), @as(f64, @bitCast(@as(i64, 4652779652427832256))), @as(f64, @bitCast(@as(i64, 4644092746187918226))), @as(f64, @bitCast(@as(i64, 4652780165679860102))), @as(f64, @bitCast(@as(i64, 4644078714308485479))), @as(f64, @bitCast(@as(i64, 4652688877187647721))), @as(f64, @bitCast(@as(i64, 4644061870669957253))), @as(f64, @bitCast(@as(i64, 4652688680594968674))), @as(f64, @bitCast(@as(i64, 4644045300589922018))), @as(f64, @bitCast(@as(i64, 4652688123362475717))), @as(f64, @bitCast(@as(i64, 4644031251294225087))), @as(f64, @bitCast(@as(i64, 4652687286854029305))), @as(f64, @bitCast(@as(i64, 4644021856011346206))), @as(f64, @bitCast(@as(i64, 4652686299052782911))), @as(f64, @bitCast(@as(i64, 4644018550439588460))), @as(f64, @bitCast(@as(i64, 4652685310371927215))), @as(f64, @bitCast(@as(i64, 4644021853196596439))), @as(f64, @bitCast(@as(i64, 4652684471224652897))), @as(f64, @bitCast(@as(i64, 4644031274867754386))), @as(f64, @bitCast(@as(i64, 4652683907834894824))), @as(f64, @bitCast(@as(i64, 4644045386967555496))), @as(f64, @bitCast(@as(i64, 4652683711242215778))), @as(f64, @bitCast(@as(i64, 4644062035508740489))), @as(f64, @bitCast(@as(i64, 4652683907834894824))), @as(f64, @bitCast(@as(i64, 4644078671383551531))), @as(f64, @bitCast(@as(i64, 4652684471224652897))), @as(f64, @bitCast(@as(i64, 4644092747595293110))), @as(f64, @bitCast(@as(i64, 4652685310371927215))), @as(f64, @bitCast(@as(i64, 4644102115434361761))), @as(f64, @bitCast(@as(i64, 4652686299052782911))), @as(f64, @bitCast(@as(i64, 4644105355035421841))), @as(f64, @bitCast(@as(i64, 4652687286854029305))), @as(f64, @bitCast(@as(i64, 4644101986659559916))), @as(f64, @bitCast(@as(i64, 4652688123362475717))), @as(f64, @bitCast(@as(i64, 4644092538248279181))), @as(f64, @bitCast(@as(i64, 4652688680594968674))), @as(f64, @bitCast(@as(i64, 4644078453416366440))), @as(f64, @bitCast(@as(i64, 4652766324147880355))), @as(f64, @bitCast(@as(i64, 4644062675864312506))), @as(f64, @bitCast(@as(i64, 4652766138110512936))), @as(f64, @bitCast(@as(i64, 4644045959769133102))), @as(f64, @bitCast(@as(i64, 4652765612104150208))), @as(f64, @bitCast(@as(i64, 4644031787504055720))), @as(f64, @bitCast(@as(i64, 4652764823094606116))), @as(f64, @bitCast(@as(i64, 4644022309713824291))), @as(f64, @bitCast(@as(i64, 4652763892028159715))), @as(f64, @bitCast(@as(i64, 4644018975642725154))), @as(f64, @bitCast(@as(i64, 4652762957883080756))), @as(f64, @bitCast(@as(i64, 4644022307426840105))), @as(f64, @bitCast(@as(i64, 4652762164915294804))), @as(f64, @bitCast(@as(i64, 4644031812133116183))), @as(f64, @bitCast(@as(i64, 4652761634071080914))), @as(f64, @bitCast(@as(i64, 4644046048961516347))), @as(f64, @bitCast(@as(i64, 4652761447593908843))), @as(f64, @bitCast(@as(i64, 4644062845101142253))), @as(f64, @bitCast(@as(i64, 4652761634071080914))), @as(f64, @bitCast(@as(i64, 4644079627694784905))), @as(f64, @bitCast(@as(i64, 4652762164915294804))), @as(f64, @bitCast(@as(i64, 4644093827227750656))), @as(f64, @bitCast(@as(i64, 4652762957883080756))), @as(f64, @bitCast(@as(i64, 4644103277222328135))), @as(f64, @bitCast(@as(i64, 4652763892028159715))), @as(f64, @bitCast(@as(i64, 4644106544619042164))), @as(f64, @bitCast(@as(i64, 4652764823094606116))), @as(f64, @bitCast(@as(i64, 4644103145808698383))), @as(f64, @bitCast(@as(i64, 4652765612104150208))), @as(f64, @bitCast(@as(i64, 4644093613482690216))), @as(f64, @bitCast(@as(i64, 4652766138110512936))), @as(f64, @bitCast(@as(i64, 4644079404274022141))), @as(f64, @bitCast(@as(i64, 4652726619023782760))), @as(f64, @bitCast(@as(i64, 4644007988794774834))), @as(f64, @bitCast(@as(i64, 4652726619023782760))), @as(f64, @bitCast(@as(i64, 4643783636701681560))), @as(f64, @bitCast(@as(i64, 4652773798188121326))), @as(f64, @bitCast(@as(i64, 4643793341255191101))), @as(f64, @bitCast(@as(i64, 4652785412109543198))), @as(f64, @bitCast(@as(i64, 4643950357145137048))), @as(f64, @bitCast(@as(i64, 4652785412109543198))), @as(f64, @bitCast(@as(i64, 4644062023194210258))), @as(f64, @bitCast(@as(i64, 4652768745272484718))), @as(f64, @bitCast(@as(i64, 4644062592125506935))), @as(f64, @bitCast(@as(i64, 4652768745272484718))), @as(f64, @bitCast(@as(i64, 4644008533624776630))), @as(f64, @bitCast(@as(i64, 4652653397706637994))), @as(f64, @bitCast(@as(i64, 4643786578818875628))), @as(f64, @bitCast(@as(i64, 4652726619023782760))), @as(f64, @bitCast(@as(i64, 4643783636701681560))), @as(f64, @bitCast(@as(i64, 4652773798188121326))), @as(f64, @bitCast(@as(i64, 4643793341255191101))), @as(f64, @bitCast(@as(i64, 4652702857258092567))), @as(f64, @bitCast(@as(i64, 4643796033563343339))), @as(f64, @bitCast(@as(i64, 4652760467709146169))), @as(f64, @bitCast(@as(i64, 4644062878878139459))), @as(f64, @bitCast(@as(i64, 4652760280792169447))), @as(f64, @bitCast(@as(i64, 4644046075877560995))), @as(f64, @bitCast(@as(i64, 4652759748628541604))), @as(f64, @bitCast(@as(i64, 4644031829725302227))), @as(f64, @bitCast(@as(i64, 4652758951262709141))), @as(f64, @bitCast(@as(i64, 4644022302676949873))), @as(f64, @bitCast(@as(i64, 4652758009640951113))), @as(f64, @bitCast(@as(i64, 4644018951541430273))), @as(f64, @bitCast(@as(i64, 4652757065820169830))), @as(f64, @bitCast(@as(i64, 4644022301093653129))), @as(f64, @bitCast(@as(i64, 4652756265815509461))), @as(f64, @bitCast(@as(i64, 4644031855761737573))), @as(f64, @bitCast(@as(i64, 4652755729253835106))), @as(f64, @bitCast(@as(i64, 4644046167356928426))), @as(f64, @bitCast(@as(i64, 4652755541017444431))), @as(f64, @bitCast(@as(i64, 4644063050577875252))), @as(f64, @bitCast(@as(i64, 4652755729253835106))), @as(f64, @bitCast(@as(i64, 4644079920780604405))), @as(f64, @bitCast(@as(i64, 4652756265815509461))), @as(f64, @bitCast(@as(i64, 4644094195080360844))), @as(f64, @bitCast(@as(i64, 4652757065820169830))), @as(f64, @bitCast(@as(i64, 4644103693805293666))), @as(f64, @bitCast(@as(i64, 4652758009640951113))), @as(f64, @bitCast(@as(i64, 4644106977386818857))), @as(f64, @bitCast(@as(i64, 4652758951262709141))), @as(f64, @bitCast(@as(i64, 4644103560104679729))), @as(f64, @bitCast(@as(i64, 4652759748628541604))), @as(f64, @bitCast(@as(i64, 4644093977640941335))), @as(f64, @bitCast(@as(i64, 4652760280792169447))), @as(f64, @bitCast(@as(i64, 4644079694545091874))), @as(f64, @bitCast(@as(i64, 4652667944685278121))), @as(f64, @bitCast(@as(i64, 4644062544978448336))), @as(f64, @bitCast(@as(i64, 4652667742375138610))), @as(f64, @bitCast(@as(i64, 4644045686034718251))), @as(f64, @bitCast(@as(i64, 4652667164032022400))), @as(f64, @bitCast(@as(i64, 4644031392383557163))), @as(f64, @bitCast(@as(i64, 4652666299815882968))), @as(f64, @bitCast(@as(i64, 4644021833845191790))), @as(f64, @bitCast(@as(i64, 4652665276830264485))), @as(f64, @bitCast(@as(i64, 4644018471978438702))), @as(f64, @bitCast(@as(i64, 4652664252525232049))), @as(f64, @bitCast(@as(i64, 4644021832965582488))), @as(f64, @bitCast(@as(i64, 4652663383031436804))), @as(f64, @bitCast(@as(i64, 4644031419827367392))), @as(f64, @bitCast(@as(i64, 4652662801169883385))), @as(f64, @bitCast(@as(i64, 4644045778921460565))), @as(f64, @bitCast(@as(i64, 4652662596220915968))), @as(f64, @bitCast(@as(i64, 4644062718789246454))), @as(f64, @bitCast(@as(i64, 4652662801169883385))), @as(f64, @bitCast(@as(i64, 4644079645814736531))), @as(f64, @bitCast(@as(i64, 4652663383031436804))), @as(f64, @bitCast(@as(i64, 4644093967085629709))), @as(f64, @bitCast(@as(i64, 4652664252525232049))), @as(f64, @bitCast(@as(i64, 4644103497476497411))), @as(f64, @bitCast(@as(i64, 4652665276830264485))), @as(f64, @bitCast(@as(i64, 4644106791085568646))), @as(f64, @bitCast(@as(i64, 4652666299815882968))), @as(f64, @bitCast(@as(i64, 4644103362192586729))), @as(f64, @bitCast(@as(i64, 4652667164032022400))), @as(f64, @bitCast(@as(i64, 4644093747183304153))), @as(f64, @bitCast(@as(i64, 4652667742375138610))), @as(f64, @bitCast(@as(i64, 4644079416588552372))), @as(f64, @bitCast(@as(i64, 4652661521338348654))), @as(f64, @bitCast(@as(i64, 4644062754325462264))), @as(f64, @bitCast(@as(i64, 4652661317268990539))), @as(f64, @bitCast(@as(i64, 4644045807420801957))), @as(f64, @bitCast(@as(i64, 4652660733208413864))), @as(f64, @bitCast(@as(i64, 4644031439178772041))), @as(f64, @bitCast(@as(i64, 4652659859316572108))), @as(f64, @bitCast(@as(i64, 4644021830326754581))), @as(f64, @bitCast(@as(i64, 4652658826655251300))), @as(f64, @bitCast(@as(i64, 4644018450867815449))), @as(f64, @bitCast(@as(i64, 4652657791355102586))), @as(f64, @bitCast(@as(i64, 4644021829095301558))), @as(f64, @bitCast(@as(i64, 4652656912625409668))), @as(f64, @bitCast(@as(i64, 4644031467326269712))), @as(f64, @bitCast(@as(i64, 4652656324606591133))), @as(f64, @bitCast(@as(i64, 4644045902418606597))), @as(f64, @bitCast(@as(i64, 4652656117458600460))), @as(f64, @bitCast(@as(i64, 4644062931478775731))), @as(f64, @bitCast(@as(i64, 4652656324606591133))), @as(f64, @bitCast(@as(i64, 4644079947520727193))), @as(f64, @bitCast(@as(i64, 4652656912625409668))), @as(f64, @bitCast(@as(i64, 4644094344262098501))), @as(f64, @bitCast(@as(i64, 4652657791355102586))), @as(f64, @bitCast(@as(i64, 4644103923735165267))), @as(f64, @bitCast(@as(i64, 4652658826655251300))), @as(f64, @bitCast(@as(i64, 4644107234584578826))), @as(f64, @bitCast(@as(i64, 4652659859316572108))), @as(f64, @bitCast(@as(i64, 4644103787395723423))), @as(f64, @bitCast(@as(i64, 4652660733208413864))), @as(f64, @bitCast(@as(i64, 4644094121545023179))), @as(f64, @bitCast(@as(i64, 4652661317268990539))), @as(f64, @bitCast(@as(i64, 4644079714600183965))), @as(f64, @bitCast(@as(i64, 4652740500577985757))), @as(f64, @bitCast(@as(i64, 4644063580454518910))), @as(f64, @bitCast(@as(i64, 4652740307503743920))), @as(f64, @bitCast(@as(i64, 4644046481201527458))), @as(f64, @bitCast(@as(i64, 4652739755548906776))), @as(f64, @bitCast(@as(i64, 4644031983481008255))), @as(f64, @bitCast(@as(i64, 4652738930915185944))), @as(f64, @bitCast(@as(i64, 4644022288779122898))), @as(f64, @bitCast(@as(i64, 4652737955428469781))), @as(f64, @bitCast(@as(i64, 4644018879061623770))), @as(f64, @bitCast(@as(i64, 4652736977742730363))), @as(f64, @bitCast(@as(i64, 4644022288251357317))), @as(f64, @bitCast(@as(i64, 4652736147831353718))), @as(f64, @bitCast(@as(i64, 4644032013035880810))), @as(f64, @bitCast(@as(i64, 4652735593237688667))), @as(f64, @bitCast(@as(i64, 4644046579014081865))), @as(f64, @bitCast(@as(i64, 4652735397084814272))), @as(f64, @bitCast(@as(i64, 4644063762005878888))), @as(f64, @bitCast(@as(i64, 4652735593237688667))), @as(f64, @bitCast(@as(i64, 4644080931275770796))), @as(f64, @bitCast(@as(i64, 4652736147831353718))), @as(f64, @bitCast(@as(i64, 4644095457143787671))), @as(f64, @bitCast(@as(i64, 4652736977742730363))), @as(f64, @bitCast(@as(i64, 4644105122994487915))), @as(f64, @bitCast(@as(i64, 4652737955428469781))), @as(f64, @bitCast(@as(i64, 4644108463046930307))), @as(f64, @bitCast(@as(i64, 4652738930915185944))), @as(f64, @bitCast(@as(i64, 4644104983312530722))), @as(f64, @bitCast(@as(i64, 4652739755548906776))), @as(f64, @bitCast(@as(i64, 4644095230204587698))), @as(f64, @bitCast(@as(i64, 4652740307503743920))), @as(f64, @bitCast(@as(i64, 4644080693253493615))), @as(f64, @bitCast(@as(i64, 4652653397706637994))), @as(f64, @bitCast(@as(i64, 4644007732476624167))), @as(f64, @bitCast(@as(i64, 4652726619023782760))), @as(f64, @bitCast(@as(i64, 4644007988794774834))), @as(f64, @bitCast(@as(i64, 4652726619023782760))), @as(f64, @bitCast(@as(i64, 4643783636701681560))), @as(f64, @bitCast(@as(i64, 4652653397706637994))), @as(f64, @bitCast(@as(i64, 4643786578818875628))), @as(f64, @bitCast(@as(i64, 4652734371900172534))), @as(f64, @bitCast(@as(i64, 4644063798245782140))), @as(f64, @bitCast(@as(i64, 4652734177506516743))), @as(f64, @bitCast(@as(i64, 4644046608393032559))), @as(f64, @bitCast(@as(i64, 4652733618954609833))), @as(f64, @bitCast(@as(i64, 4644032033442816621))), @as(f64, @bitCast(@as(i64, 4652732785524795979))), @as(f64, @bitCast(@as(i64, 4644022287723591736))), @as(f64, @bitCast(@as(i64, 4652731799482768189))), @as(f64, @bitCast(@as(i64, 4644018859710219121))), @as(f64, @bitCast(@as(i64, 4652730811681521795))), @as(f64, @bitCast(@as(i64, 4644022287019904294))), @as(f64, @bitCast(@as(i64, 4652729973853661430))), @as(f64, @bitCast(@as(i64, 4644032064053220339))), @as(f64, @bitCast(@as(i64, 4652729412223121962))), @as(f64, @bitCast(@as(i64, 4644046707788883710))), @as(f64, @bitCast(@as(i64, 4652729214311028962))), @as(f64, @bitCast(@as(i64, 4644063982963735606))), @as(f64, @bitCast(@as(i64, 4652729412223121962))), @as(f64, @bitCast(@as(i64, 4644081244064838666))), @as(f64, @bitCast(@as(i64, 4652729973853661430))), @as(f64, @bitCast(@as(i64, 4644095847690317857))), @as(f64, @bitCast(@as(i64, 4652730811681521795))), @as(f64, @bitCast(@as(i64, 4644105564382435769))), @as(f64, @bitCast(@as(i64, 4652731799482768189))), @as(f64, @bitCast(@as(i64, 4644108921499298625))), @as(f64, @bitCast(@as(i64, 4652732785524795979))), @as(f64, @bitCast(@as(i64, 4644105423117181832))), @as(f64, @bitCast(@as(i64, 4652733618954609833))), @as(f64, @bitCast(@as(i64, 4644095617232680675))), @as(f64, @bitCast(@as(i64, 4652734177506516743))), @as(f64, @bitCast(@as(i64, 4644081002524124276))), @as(f64, @bitCast(@as(i64, 4652710442129105617))), @as(f64, @bitCast(@as(i64, 4643930131584763644))), @as(f64, @bitCast(@as(i64, 4652707369214008309))), @as(f64, @bitCast(@as(i64, 4643991929767744189))), @as(f64, @bitCast(@as(i64, 4652698617541255863))), @as(f64, @bitCast(@as(i64, 4644044319825550041))), @as(f64, @bitCast(@as(i64, 4652685520158745795))), @as(f64, @bitCast(@as(i64, 4644079325109184941))), @as(f64, @bitCast(@as(i64, 4652670070700961589))), @as(f64, @bitCast(@as(i64, 4644091618001027198))), @as(f64, @bitCast(@as(i64, 4652654621243177383))), @as(f64, @bitCast(@as(i64, 4644079325109184941))), @as(f64, @bitCast(@as(i64, 4652641523420862664))), @as(f64, @bitCast(@as(i64, 4644044319825550041))), @as(f64, @bitCast(@as(i64, 4652632772187914869))), @as(f64, @bitCast(@as(i64, 4643991929767744189))), @as(f64, @bitCast(@as(i64, 4652629698833012910))), @as(f64, @bitCast(@as(i64, 4643930131584763644))), @as(f64, @bitCast(@as(i64, 4652632772187914869))), @as(f64, @bitCast(@as(i64, 4643868333225861238))), @as(f64, @bitCast(@as(i64, 4652641523420862664))), @as(f64, @bitCast(@as(i64, 4643815943695820967))), @as(f64, @bitCast(@as(i64, 4652654621243177383))), @as(f64, @bitCast(@as(i64, 4643780937884420486))), @as(f64, @bitCast(@as(i64, 4652670070700961589))), @as(f64, @bitCast(@as(i64, 4643768645344421950))), @as(f64, @bitCast(@as(i64, 4652685520158745795))), @as(f64, @bitCast(@as(i64, 4643780937884420486))), @as(f64, @bitCast(@as(i64, 4652698617541255863))), @as(f64, @bitCast(@as(i64, 4643815943695820967))), @as(f64, @bitCast(@as(i64, 4652707369214008309))), @as(f64, @bitCast(@as(i64, 4643868333225861238))), @as(f64, @bitCast(@as(i64, 4652660625896078993))), @as(f64, @bitCast(@as(i64, 4643963463851505720))), @as(f64, @bitCast(@as(i64, 4652679515945648836))), @as(f64, @bitCast(@as(i64, 4643963364455654569))), @as(f64, @bitCast(@as(i64, 4652679515945648836))), @as(f64, @bitCast(@as(i64, 4643896675996797397))), @as(f64, @bitCast(@as(i64, 4652660625896078993))), @as(f64, @bitCast(@as(i64, 4643897023266549913))), @as(f64, @bitCast(@as(i64, 4652750473588254337))), @as(f64, @bitCast(@as(i64, 4643929665567755327))), @as(f64, @bitCast(@as(i64, 4652747362849957033))), @as(f64, @bitCast(@as(i64, 4643992218103673457))), @as(f64, @bitCast(@as(i64, 4652738504304674367))), @as(f64, @bitCast(@as(i64, 4644045246933754582))), @as(f64, @bitCast(@as(i64, 4652725246833271295))), @as(f64, @bitCast(@as(i64, 4644080679707510361))), @as(f64, @bitCast(@as(i64, 4652709609139096414))), @as(f64, @bitCast(@as(i64, 4644093122308855856))), @as(f64, @bitCast(@as(i64, 4652693971005116881))), @as(f64, @bitCast(@as(i64, 4644080679707510361))), @as(f64, @bitCast(@as(i64, 4652680713533713809))), @as(f64, @bitCast(@as(i64, 4644045246933754582))), @as(f64, @bitCast(@as(i64, 4652671854988431144))), @as(f64, @bitCast(@as(i64, 4643992218103673457))), @as(f64, @bitCast(@as(i64, 4652668744689938491))), @as(f64, @bitCast(@as(i64, 4643929665567755327))), @as(f64, @bitCast(@as(i64, 4652671854988431144))), @as(f64, @bitCast(@as(i64, 4643867113207759058))), @as(f64, @bitCast(@as(i64, 4652680713533713809))), @as(f64, @bitCast(@as(i64, 4643814084201756072))), @as(f64, @bitCast(@as(i64, 4652693971005116881))), @as(f64, @bitCast(@as(i64, 4643778651252078433))), @as(f64, @bitCast(@as(i64, 4652709609139096414))), @as(f64, @bitCast(@as(i64, 4643766208826654799))), @as(f64, @bitCast(@as(i64, 4652725246833271295))), @as(f64, @bitCast(@as(i64, 4643778651252078433))), @as(f64, @bitCast(@as(i64, 4652738504304674367))), @as(f64, @bitCast(@as(i64, 4643814084201756072))), @as(f64, @bitCast(@as(i64, 4652747362849957033))), @as(f64, @bitCast(@as(i64, 4643867113207759058))), @as(f64, @bitCast(@as(i64, 4652700016120046394))), @as(f64, @bitCast(@as(i64, 4643963257143319698))), @as(f64, @bitCast(@as(i64, 4652719201718341783))), @as(f64, @bitCast(@as(i64, 4643963156867859245))), @as(f64, @bitCast(@as(i64, 4652719201718341783))), @as(f64, @bitCast(@as(i64, 4643895948559904460))), @as(f64, @bitCast(@as(i64, 4652700016120046394))), @as(f64, @bitCast(@as(i64, 4643896300227703488))), @as(f64, @bitCast(@as(i64, 4648469109977878763))), @as(f64, @bitCast(@as(i64, 4644027039021198612))), @as(f64, @bitCast(@as(i64, 4648485660178743768))), @as(f64, @bitCast(@as(i64, 4644026989587155827))), @as(f64, @bitCast(@as(i64, 4648485660178743768))), @as(f64, @bitCast(@as(i64, 4644046240188578650))), @as(f64, @bitCast(@as(i64, 4648469109977878763))), @as(f64, @bitCast(@as(i64, 4644046258308530276))), @as(f64, @bitCast(@as(i64, 4648465906792643795))), @as(f64, @bitCast(@as(i64, 4644046204652362840))), @as(f64, @bitCast(@as(i64, 4648465793674887530))), @as(f64, @bitCast(@as(i64, 4644043370551191085))), @as(f64, @bitCast(@as(i64, 4648465470506429894))), @as(f64, @bitCast(@as(i64, 4644040963588296488))), @as(f64, @bitCast(@as(i64, 4648464986281509021))), @as(f64, @bitCast(@as(i64, 4644039350384836215))), @as(f64, @bitCast(@as(i64, 4648464414975267229))), @as(f64, @bitCast(@as(i64, 4644038775999961865))), @as(f64, @bitCast(@as(i64, 4648463843756986367))), @as(f64, @bitCast(@as(i64, 4644039328394603659))), @as(f64, @bitCast(@as(i64, 4648463359004299913))), @as(f64, @bitCast(@as(i64, 4644040924885487190))), @as(f64, @bitCast(@as(i64, 4648463035220115765))), @as(f64, @bitCast(@as(i64, 4644043322172679463))), @as(f64, @bitCast(@as(i64, 4648462921398672058))), @as(f64, @bitCast(@as(i64, 4644046155394241916))), @as(f64, @bitCast(@as(i64, 4648463035220115765))), @as(f64, @bitCast(@as(i64, 4644048991606475997))), @as(f64, @bitCast(@as(i64, 4648463359004299913))), @as(f64, @bitCast(@as(i64, 4644051399976745477))), @as(f64, @bitCast(@as(i64, 4648463843756986367))), @as(f64, @bitCast(@as(i64, 4644053012476518308))), @as(f64, @bitCast(@as(i64, 4648464414975267229))), @as(f64, @bitCast(@as(i64, 4644053584222564752))), @as(f64, @bitCast(@as(i64, 4648464986281509021))), @as(f64, @bitCast(@as(i64, 4644053028309485748))), @as(f64, @bitCast(@as(i64, 4648465470506429894))), @as(f64, @bitCast(@as(i64, 4644051430938992915))), @as(f64, @bitCast(@as(i64, 4648465793674887530))), @as(f64, @bitCast(@as(i64, 4644049034883253666))), @as(f64, @bitCast(@as(i64, 4648461800424577308))), @as(f64, @bitCast(@as(i64, 4644000190178701345))), @as(f64, @bitCast(@as(i64, 4648478380092353937))), @as(f64, @bitCast(@as(i64, 4644000097643802751))), @as(f64, @bitCast(@as(i64, 4648485660178743768))), @as(f64, @bitCast(@as(i64, 4644026989587155827))), @as(f64, @bitCast(@as(i64, 4648469109977878763))), @as(f64, @bitCast(@as(i64, 4644027039021198612))), @as(f64, @bitCast(@as(i64, 4648482469835804613))), @as(f64, @bitCast(@as(i64, 4644046186708333075))), @as(f64, @bitCast(@as(i64, 4648482357245813929))), @as(f64, @bitCast(@as(i64, 4644043348033192948))), @as(f64, @bitCast(@as(i64, 4648482035308809316))), @as(f64, @bitCast(@as(i64, 4644040937200017421))), @as(f64, @bitCast(@as(i64, 4648481553019028908))), @as(f64, @bitCast(@as(i64, 4644039321005885521))), @as(f64, @bitCast(@as(i64, 4648480984439575953))), @as(f64, @bitCast(@as(i64, 4644038745917323729))), @as(f64, @bitCast(@as(i64, 4648480415068474625))), @as(f64, @bitCast(@as(i64, 4644039299367496686))), @as(f64, @bitCast(@as(i64, 4648479932690733287))), @as(f64, @bitCast(@as(i64, 4644040898497208123))), @as(f64, @bitCast(@as(i64, 4648479610225963093))), @as(f64, @bitCast(@as(i64, 4644043299830603186))), @as(f64, @bitCast(@as(i64, 4648479496756363107))), @as(f64, @bitCast(@as(i64, 4644046137098368430))), @as(f64, @bitCast(@as(i64, 4648479610225963093))), @as(f64, @bitCast(@as(i64, 4644048978236414603))), @as(f64, @bitCast(@as(i64, 4648479932690733287))), @as(f64, @bitCast(@as(i64, 4644051389773277571))), @as(f64, @bitCast(@as(i64, 4648480415068474625))), @as(f64, @bitCast(@as(i64, 4644053005439643890))), @as(f64, @bitCast(@as(i64, 4648480984439575953))), @as(f64, @bitCast(@as(i64, 4644053577537534055))), @as(f64, @bitCast(@as(i64, 4648481553019028908))), @as(f64, @bitCast(@as(i64, 4644053021272611330))), @as(f64, @bitCast(@as(i64, 4648482035308809316))), @as(f64, @bitCast(@as(i64, 4644051421439212451))), @as(f64, @bitCast(@as(i64, 4648482357245813929))), @as(f64, @bitCast(@as(i64, 4644049021161348551))), @as(f64, @bitCast(@as(i64, 4648457156439305303))), @as(f64, @bitCast(@as(i64, 4644046059692749834))), @as(f64, @bitCast(@as(i64, 4648457042969705316))), @as(f64, @bitCast(@as(i64, 4644043217147328777))), @as(f64, @bitCast(@as(i64, 4648456717514263495))), @as(f64, @bitCast(@as(i64, 4644040803499403484))), @as(f64, @bitCast(@as(i64, 4648456229858866343))), @as(f64, @bitCast(@as(i64, 4644039184666443676))), @as(f64, @bitCast(@as(i64, 4648455655386031063))), @as(f64, @bitCast(@as(i64, 4644038608522350722))), @as(f64, @bitCast(@as(i64, 4648455081001156713))), @as(f64, @bitCast(@as(i64, 4644039163028054842))), @as(f64, @bitCast(@as(i64, 4648454592993915841))), @as(f64, @bitCast(@as(i64, 4644040764092906744))), @as(f64, @bitCast(@as(i64, 4648454266922747508))), @as(f64, @bitCast(@as(i64, 4644043168768817155))), @as(f64, @bitCast(@as(i64, 4648454153453147521))), @as(f64, @bitCast(@as(i64, 4644046010434628910))), @as(f64, @bitCast(@as(i64, 4648454266922747508))), @as(f64, @bitCast(@as(i64, 4644048855442956013))), @as(f64, @bitCast(@as(i64, 4648454592993915841))), @as(f64, @bitCast(@as(i64, 4644051270850099911))), @as(f64, @bitCast(@as(i64, 4648455081001156713))), @as(f64, @bitCast(@as(i64, 4644052888275684835))), @as(f64, @bitCast(@as(i64, 4648455655386031063))), @as(f64, @bitCast(@as(i64, 4644053461605028022))), @as(f64, @bitCast(@as(i64, 4648456229858866343))), @as(f64, @bitCast(@as(i64, 4644052904284574135))), @as(f64, @bitCast(@as(i64, 4648456717514263495))), @as(f64, @bitCast(@as(i64, 4644051301812347349))), @as(f64, @bitCast(@as(i64, 4648457042969705316))), @as(f64, @bitCast(@as(i64, 4644048898719733682))), @as(f64, @bitCast(@as(i64, 4648433256574954661))), @as(f64, @bitCast(@as(i64, 4644036390675456102))), @as(f64, @bitCast(@as(i64, 4648433256574954661))), @as(f64, @bitCast(@as(i64, 4643999271866589826))), @as(f64, @bitCast(@as(i64, 4648461800424577308))), @as(f64, @bitCast(@as(i64, 4644000190178701345))), @as(f64, @bitCast(@as(i64, 4648469109977878763))), @as(f64, @bitCast(@as(i64, 4644027039021198612))), @as(f64, @bitCast(@as(i64, 4648469109977878763))), @as(f64, @bitCast(@as(i64, 4644046258308530276))), @as(f64, @bitCast(@as(i64, 4648458656173165589))), @as(f64, @bitCast(@as(i64, 4644046084673654017))), @as(f64, @bitCast(@as(i64, 4648458656173165589))), @as(f64, @bitCast(@as(i64, 4644036885191805811))), @as(f64, @bitCast(@as(i64, 4648453551448541081))), @as(f64, @bitCast(@as(i64, 4644046000231161004))), @as(f64, @bitCast(@as(i64, 4648453437099331792))), @as(f64, @bitCast(@as(i64, 4644043154167302738))), @as(f64, @bitCast(@as(i64, 4648453110676319738))), @as(f64, @bitCast(@as(i64, 4644040737176862096))), @as(f64, @bitCast(@as(i64, 4648452622669078866))), @as(f64, @bitCast(@as(i64, 4644039116936527405))), @as(f64, @bitCast(@as(i64, 4648452046788868702))), @as(f64, @bitCast(@as(i64, 4644038539736903288))), @as(f64, @bitCast(@as(i64, 4648451469765166445))), @as(f64, @bitCast(@as(i64, 4644039095298138571))), @as(f64, @bitCast(@as(i64, 4648450981582003713))), @as(f64, @bitCast(@as(i64, 4644040698474052798))), @as(f64, @bitCast(@as(i64, 4648450655246952589))), @as(f64, @bitCast(@as(i64, 4644043105964712977))), @as(f64, @bitCast(@as(i64, 4648450540018133998))), @as(f64, @bitCast(@as(i64, 4644045950973040080))), @as(f64, @bitCast(@as(i64, 4648450655246952589))), @as(f64, @bitCast(@as(i64, 4644048799147960671))), @as(f64, @bitCast(@as(i64, 4648450981582003713))), @as(f64, @bitCast(@as(i64, 4644051218073541778))), @as(f64, @bitCast(@as(i64, 4648451469765166445))), @as(f64, @bitCast(@as(i64, 4644052837258345306))), @as(f64, @bitCast(@as(i64, 4648452046788868702))), @as(f64, @bitCast(@as(i64, 4644053411115454075))), @as(f64, @bitCast(@as(i64, 4648452622669078866))), @as(f64, @bitCast(@as(i64, 4644052853267234606))), @as(f64, @bitCast(@as(i64, 4648453110676319738))), @as(f64, @bitCast(@as(i64, 4644051249211711076))), @as(f64, @bitCast(@as(i64, 4648453437099331792))), @as(f64, @bitCast(@as(i64, 4644048842424738340))), @as(f64, @bitCast(@as(i64, 4648473755546447512))), @as(f64, @bitCast(@as(i64, 4644046041572798208))), @as(f64, @bitCast(@as(i64, 4648473641637042874))), @as(f64, @bitCast(@as(i64, 4644043193925643199))), @as(f64, @bitCast(@as(i64, 4648473317940819657))), @as(f64, @bitCast(@as(i64, 4644040776407436975))), @as(f64, @bitCast(@as(i64, 4648472832836289482))), @as(f64, @bitCast(@as(i64, 4644039155111571122))), @as(f64, @bitCast(@as(i64, 4648472260210633736))), @as(f64, @bitCast(@as(i64, 4644038578087868865))), @as(f64, @bitCast(@as(i64, 4648471688024782642))), @as(f64, @bitCast(@as(i64, 4644039133649104148))), @as(f64, @bitCast(@as(i64, 4648471202920252467))), @as(f64, @bitCast(@as(i64, 4644040737176862096))), @as(f64, @bitCast(@as(i64, 4648470877904615296))), @as(f64, @bitCast(@as(i64, 4644043145547131577))), @as(f64, @bitCast(@as(i64, 4648470763995210659))), @as(f64, @bitCast(@as(i64, 4644045991435067982))), @as(f64, @bitCast(@as(i64, 4648470877904615296))), @as(f64, @bitCast(@as(i64, 4644048841369207177))), @as(f64, @bitCast(@as(i64, 4648471202920252467))), @as(f64, @bitCast(@as(i64, 4644051260294788284))), @as(f64, @bitCast(@as(i64, 4648471688024782642))), @as(f64, @bitCast(@as(i64, 4644052880535122975))), @as(f64, @bitCast(@as(i64, 4648472260210633736))), @as(f64, @bitCast(@as(i64, 4644053455095919186))), @as(f64, @bitCast(@as(i64, 4648472832836289482))), @as(f64, @bitCast(@as(i64, 4644052896719934136))), @as(f64, @bitCast(@as(i64, 4648473317940819657))), @as(f64, @bitCast(@as(i64, 4644051291960723164))), @as(f64, @bitCast(@as(i64, 4648473641637042874))), @as(f64, @bitCast(@as(i64, 4644048884821906707))), @as(f64, @bitCast(@as(i64, 4648449952790963835))), @as(f64, @bitCast(@as(i64, 4644036355842927734))), @as(f64, @bitCast(@as(i64, 4648449952790963835))), @as(f64, @bitCast(@as(i64, 4643999177572472628))), @as(f64, @bitCast(@as(i64, 4648478380092353937))), @as(f64, @bitCast(@as(i64, 4644000097643802751))), @as(f64, @bitCast(@as(i64, 4648485660178743768))), @as(f64, @bitCast(@as(i64, 4644026989587155827))), @as(f64, @bitCast(@as(i64, 4648485660178743768))), @as(f64, @bitCast(@as(i64, 4644046240188578650))), @as(f64, @bitCast(@as(i64, 4648475249123042682))), @as(f64, @bitCast(@as(i64, 4644046066201858671))), @as(f64, @bitCast(@as(i64, 4648475249123042682))), @as(f64, @bitCast(@as(i64, 4644036851942574187))), @as(f64, @bitCast(@as(i64, 4648470164981275846))), @as(f64, @bitCast(@as(i64, 4644045981935287518))), @as(f64, @bitCast(@as(i64, 4648470051071871209))), @as(f64, @bitCast(@as(i64, 4644043130945617160))), @as(f64, @bitCast(@as(i64, 4648469725704390317))), @as(f64, @bitCast(@as(i64, 4644040710260817448))), @as(f64, @bitCast(@as(i64, 4648469239632289910))), @as(f64, @bitCast(@as(i64, 4644039086853889269))), @as(f64, @bitCast(@as(i64, 4648468666478868583))), @as(f64, @bitCast(@as(i64, 4644038509126499571))), @as(f64, @bitCast(@as(i64, 4648468092006033302))), @as(f64, @bitCast(@as(i64, 4644039065391422295))), @as(f64, @bitCast(@as(i64, 4648467605670050105))), @as(f64, @bitCast(@as(i64, 4644040671206164430))), @as(f64, @bitCast(@as(i64, 4648467280302569213))), @as(f64, @bitCast(@as(i64, 4644043082743027398))), @as(f64, @bitCast(@as(i64, 4648467165953359924))), @as(f64, @bitCast(@as(i64, 4644045931973479152))), @as(f64, @bitCast(@as(i64, 4648467280302569213))), @as(f64, @bitCast(@as(i64, 4644048785426055556))), @as(f64, @bitCast(@as(i64, 4648467605670050105))), @as(f64, @bitCast(@as(i64, 4644051207870073872))), @as(f64, @bitCast(@as(i64, 4648468092006033302))), @as(f64, @bitCast(@as(i64, 4644052829517783446))), @as(f64, @bitCast(@as(i64, 4648468666478868583))), @as(f64, @bitCast(@as(i64, 4644053404782267099))), @as(f64, @bitCast(@as(i64, 4648469239632289910))), @as(f64, @bitCast(@as(i64, 4644052845878516468))), @as(f64, @bitCast(@as(i64, 4648469725704390317))), @as(f64, @bitCast(@as(i64, 4644051239184165031))), @as(f64, @bitCast(@as(i64, 4648470051071871209))), @as(f64, @bitCast(@as(i64, 4644048828350989504))), @as(f64, @bitCast(@as(i64, 4648433256574954661))), @as(f64, @bitCast(@as(i64, 4643999271866589826))), @as(f64, @bitCast(@as(i64, 4648449952790963835))), @as(f64, @bitCast(@as(i64, 4643999177572472628))), @as(f64, @bitCast(@as(i64, 4648478380092353937))), @as(f64, @bitCast(@as(i64, 4644000097643802751))), @as(f64, @bitCast(@as(i64, 4648461800424577308))), @as(f64, @bitCast(@as(i64, 4644000190178701345))), @as(f64, @bitCast(@as(i64, 4648441469135165776))), @as(f64, @bitCast(@as(i64, 4644045803198677307))), @as(f64, @bitCast(@as(i64, 4648441353730425325))), @as(f64, @bitCast(@as(i64, 4644042944820288810))), @as(f64, @bitCast(@as(i64, 4648441024404702573))), @as(f64, @bitCast(@as(i64, 4644040518154145843))), @as(f64, @bitCast(@as(i64, 4648440532703102632))), @as(f64, @bitCast(@as(i64, 4644038890876936735))), @as(f64, @bitCast(@as(i64, 4648439952160963166))), @as(f64, @bitCast(@as(i64, 4644038311566250292))), @as(f64, @bitCast(@as(i64, 4648439370739214398))), @as(f64, @bitCast(@as(i64, 4644038869414469760))), @as(f64, @bitCast(@as(i64, 4648438878158005155))), @as(f64, @bitCast(@as(i64, 4644040479451336545))), @as(f64, @bitCast(@as(i64, 4648438548568399612))), @as(f64, @bitCast(@as(i64, 4644042896969542769))), @as(f64, @bitCast(@as(i64, 4648438432635893580))), @as(f64, @bitCast(@as(i64, 4644045753940556382))), @as(f64, @bitCast(@as(i64, 4648438548568399612))), @as(f64, @bitCast(@as(i64, 4644048614430007204))), @as(f64, @bitCast(@as(i64, 4648438878158005155))), @as(f64, @bitCast(@as(i64, 4644051042503525055))), @as(f64, @bitCast(@as(i64, 4648439370739214398))), @as(f64, @bitCast(@as(i64, 4644052668021515559))), @as(f64, @bitCast(@as(i64, 4648439952160963166))), @as(f64, @bitCast(@as(i64, 4644053244693374095))), @as(f64, @bitCast(@as(i64, 4648440532703102632))), @as(f64, @bitCast(@as(i64, 4644052684206326719))), @as(f64, @bitCast(@as(i64, 4648441024404702573))), @as(f64, @bitCast(@as(i64, 4644051073113928772))), @as(f64, @bitCast(@as(i64, 4648441353730425325))), @as(f64, @bitCast(@as(i64, 4644048657179019292))), @as(f64, @bitCast(@as(i64, 4648437824913826675))), @as(f64, @bitCast(@as(i64, 4644045743385244756))), @as(f64, @bitCast(@as(i64, 4648437709157242503))), @as(f64, @bitCast(@as(i64, 4644042882543950213))), @as(f64, @bitCast(@as(i64, 4648437379303754170))), @as(f64, @bitCast(@as(i64, 4644040452183448177))), @as(f64, @bitCast(@as(i64, 4648436886458662136))), @as(f64, @bitCast(@as(i64, 4644038823322942324))), @as(f64, @bitCast(@as(i64, 4648436303541577554))), @as(f64, @bitCast(@as(i64, 4644038243484490300))), @as(f64, @bitCast(@as(i64, 4648435721240219484))), @as(f64, @bitCast(@as(i64, 4644038801860475350))), @as(f64, @bitCast(@as(i64, 4648435226899791636))), @as(f64, @bitCast(@as(i64, 4644040413480638879))), @as(f64, @bitCast(@as(i64, 4648434897046303303))), @as(f64, @bitCast(@as(i64, 4644042834165438590))), @as(f64, @bitCast(@as(i64, 4648434780937875410))), @as(f64, @bitCast(@as(i64, 4644045694654889413))), @as(f64, @bitCast(@as(i64, 4648434897046303303))), @as(f64, @bitCast(@as(i64, 4644048558838699304))), @as(f64, @bitCast(@as(i64, 4648435226899791636))), @as(f64, @bitCast(@as(i64, 4644050989902888782))), @as(f64, @bitCast(@as(i64, 4648435721240219484))), @as(f64, @bitCast(@as(i64, 4644052617707863472))), @as(f64, @bitCast(@as(i64, 4648436303541577554))), @as(f64, @bitCast(@as(i64, 4644053194731565728))), @as(f64, @bitCast(@as(i64, 4648436886458662136))), @as(f64, @bitCast(@as(i64, 4644052633716752772))), @as(f64, @bitCast(@as(i64, 4648437379303754170))), @as(f64, @bitCast(@as(i64, 4644051021041058080))), @as(f64, @bitCast(@as(i64, 4648437709157242503))), @as(f64, @bitCast(@as(i64, 4644048601235867671))), @as(f64, @bitCast(@as(i64, 4648458131926021466))), @as(f64, @bitCast(@as(i64, 4644045783847272658))), @as(f64, @bitCast(@as(i64, 4648458017137007526))), @as(f64, @bitCast(@as(i64, 4644042921246759510))), @as(f64, @bitCast(@as(i64, 4648457689482542449))), @as(f64, @bitCast(@as(i64, 4644040490358491893))), @as(f64, @bitCast(@as(i64, 4648457199540161112))), @as(f64, @bitCast(@as(i64, 4644038860794298599))), @as(f64, @bitCast(@as(i64, 4648456620757240250))), @as(f64, @bitCast(@as(i64, 4644038280428080993))), @as(f64, @bitCast(@as(i64, 4648456041974319389))), @as(f64, @bitCast(@as(i64, 4644038838804066043))), @as(f64, @bitCast(@as(i64, 4648455551152328750))), @as(f64, @bitCast(@as(i64, 4644040451655682595))), @as(f64, @bitCast(@as(i64, 4648455223058059022))), @as(f64, @bitCast(@as(i64, 4644042872868247888))), @as(f64, @bitCast(@as(i64, 4648455107829240431))), @as(f64, @bitCast(@as(i64, 4644045734589151733))), @as(f64, @bitCast(@as(i64, 4648455223058059022))), @as(f64, @bitCast(@as(i64, 4644048599652570927))), @as(f64, @bitCast(@as(i64, 4648455551152328750))), @as(f64, @bitCast(@as(i64, 4644051031596369707))), @as(f64, @bitCast(@as(i64, 4648456041974319389))), @as(f64, @bitCast(@as(i64, 4644052660632797420))), @as(f64, @bitCast(@as(i64, 4648456620757240250))), @as(f64, @bitCast(@as(i64, 4644053237656499677))), @as(f64, @bitCast(@as(i64, 4648457199540161112))), @as(f64, @bitCast(@as(i64, 4644052676465764860))), @as(f64, @bitCast(@as(i64, 4648457689482542449))), @as(f64, @bitCast(@as(i64, 4644051062910460866))), @as(f64, @bitCast(@as(i64, 4648458017137007526))), @as(f64, @bitCast(@as(i64, 4644048642577504875))), @as(f64, @bitCast(@as(i64, 4648454502658040503))), @as(f64, @bitCast(@as(i64, 4644045724737527548))), @as(f64, @bitCast(@as(i64, 4648454387429221912))), @as(f64, @bitCast(@as(i64, 4644042858970420913))), @as(f64, @bitCast(@as(i64, 4648454059334952183))), @as(f64, @bitCast(@as(i64, 4644040424739637947))), @as(f64, @bitCast(@as(i64, 4648453567633352242))), @as(f64, @bitCast(@as(i64, 4644038792712538607))), @as(f64, @bitCast(@as(i64, 4648452987970822078))), @as(f64, @bitCast(@as(i64, 4644038212170399141))), @as(f64, @bitCast(@as(i64, 4648452407428682613))), @as(f64, @bitCast(@as(i64, 4644038771250071633))), @as(f64, @bitCast(@as(i64, 4648451915727082671))), @as(f64, @bitCast(@as(i64, 4644040386036828650))), @as(f64, @bitCast(@as(i64, 4648451586489320850))), @as(f64, @bitCast(@as(i64, 4644042810767831151))), @as(f64, @bitCast(@as(i64, 4648451471084580399))), @as(f64, @bitCast(@as(i64, 4644045675303484764))), @as(f64, @bitCast(@as(i64, 4648451586489320850))), @as(f64, @bitCast(@as(i64, 4644048544413106747))), @as(f64, @bitCast(@as(i64, 4648451915727082671))), @as(f64, @bitCast(@as(i64, 4644050979171655295))), @as(f64, @bitCast(@as(i64, 4648452407428682613))), @as(f64, @bitCast(@as(i64, 4644052610143223472))), @as(f64, @bitCast(@as(i64, 4648452987970822078))), @as(f64, @bitCast(@as(i64, 4644053187870613171))), @as(f64, @bitCast(@as(i64, 4648453567633352242))), @as(f64, @bitCast(@as(i64, 4644052626152112773))), @as(f64, @bitCast(@as(i64, 4648454059334952183))), @as(f64, @bitCast(@as(i64, 4644051010485746454))), @as(f64, @bitCast(@as(i64, 4648454387429221912))), @as(f64, @bitCast(@as(i64, 4644048586810275115))), @as(f64, @bitCast(@as(i64, 4648433256574954661))), @as(f64, @bitCast(@as(i64, 4644036390675456102))), @as(f64, @bitCast(@as(i64, 4648449952790963835))), @as(f64, @bitCast(@as(i64, 4644036355842927734))), @as(f64, @bitCast(@as(i64, 4648449952790963835))), @as(f64, @bitCast(@as(i64, 4643999177572472628))), @as(f64, @bitCast(@as(i64, 4648433256574954661))), @as(f64, @bitCast(@as(i64, 4643999271866589826))), @as(f64, @bitCast(@as(i64, 4646514351762647433))), @as(f64, @bitCast(@as(i64, 4644225712328088433))), @as(f64, @bitCast(@as(i64, 4646514351762647433))), @as(f64, @bitCast(@as(i64, 4643960081401894960))), @as(f64, @bitCast(@as(i64, 4646816098391258930))), @as(f64, @bitCast(@as(i64, 4643875950642418470))), @as(f64, @bitCast(@as(i64, 4646816098391258930))), @as(f64, @bitCast(@as(i64, 4644379601558808706))), @as(f64, @bitCast(@as(i64, 4647470622358072124))), @as(f64, @bitCast(@as(i64, 4644225709689260527))), @as(f64, @bitCast(@as(i64, 4647470622358072124))), @as(f64, @bitCast(@as(i64, 4643960078763067053))), @as(f64, @bitCast(@as(i64, 4647319749483571026))), @as(f64, @bitCast(@as(i64, 4643875948883199866))), @as(f64, @bitCast(@as(i64, 4647319749483571026))), @as(f64, @bitCast(@as(i64, 4644379599975511962))), @as(f64, @bitCast(@as(i64, 4646354972890272000))), @as(f64, @bitCast(@as(i64, 4643667889969133487))), @as(f64, @bitCast(@as(i64, 4647630001054525696))), @as(f64, @bitCast(@as(i64, 4643667886098852558))), @as(f64, @bitCast(@as(i64, 4647630001054525696))), @as(f64, @bitCast(@as(i64, 4644358526119927496))), @as(f64, @bitCast(@as(i64, 4646354972890272000))), @as(f64, @bitCast(@as(i64, 4644358529814286565))), @as(f64, @bitCast(@as(i64, 4646258558914655578))), @as(f64, @bitCast(@as(i64, 4641903204065113004))), @as(f64, @bitCast(@as(i64, 4647687849439895549))), @as(f64, @bitCast(@as(i64, 4641903195269019982))), @as(f64, @bitCast(@as(i64, 4647630001054525696))), @as(f64, @bitCast(@as(i64, 4643667886098852558))), @as(f64, @bitCast(@as(i64, 4646354972890272000))), @as(f64, @bitCast(@as(i64, 4643667889969133487))), @as(f64, @bitCast(@as(i64, 4646315358805737184))), @as(f64, @bitCast(@as(i64, 4644376951999668557))), @as(f64, @bitCast(@as(i64, 4646313884052781080))), @as(f64, @bitCast(@as(i64, 4644270743926315627))), @as(f64, @bitCast(@as(i64, 4646309655770865305))), @as(f64, @bitCast(@as(i64, 4644181094146233283))), @as(f64, @bitCast(@as(i64, 4646303246585645603))), @as(f64, @bitCast(@as(i64, 4644121245529310180))), @as(f64, @bitCast(@as(i64, 4646295560207719077))), @as(f64, @bitCast(@as(i64, 4644100726003507973))), @as(f64, @bitCast(@as(i64, 4646287733092304195))), @as(f64, @bitCast(@as(i64, 4644123684334061518))), @as(f64, @bitCast(@as(i64, 4646280984553815697))), @as(f64, @bitCast(@as(i64, 4644187673623813895))), @as(f64, @bitCast(@as(i64, 4646276416742709264))), @as(f64, @bitCast(@as(i64, 4644283394467300167))), @as(f64, @bitCast(@as(i64, 4646274800900421085))), @as(f64, @bitCast(@as(i64, 4644395818739591891))), @as(f64, @bitCast(@as(i64, 4646276416742709264))), @as(f64, @bitCast(@as(i64, 4644506740639195422))), @as(f64, @bitCast(@as(i64, 4646280984553815697))), @as(f64, @bitCast(@as(i64, 4644598210506845921))), @as(f64, @bitCast(@as(i64, 4646287733092304195))), @as(f64, @bitCast(@as(i64, 4644655920969477186))), @as(f64, @bitCast(@as(i64, 4646295560207719077))), @as(f64, @bitCast(@as(i64, 4644671596486852063))), @as(f64, @bitCast(@as(i64, 4646303246585645603))), @as(f64, @bitCast(@as(i64, 4644643926968875824))), @as(f64, @bitCast(@as(i64, 4646309655770865305))), @as(f64, @bitCast(@as(i64, 4644578115480492966))), @as(f64, @bitCast(@as(i64, 4646313884052781080))), @as(f64, @bitCast(@as(i64, 4644484531911689230))), @as(f64, @bitCast(@as(i64, 4647653769505246586))), @as(f64, @bitCast(@as(i64, 4644376947953465767))), @as(f64, @bitCast(@as(i64, 4647654654216282759))), @as(f64, @bitCast(@as(i64, 4644270740407878418))), @as(f64, @bitCast(@as(i64, 4647657191537275946))), @as(f64, @bitCast(@as(i64, 4644181089748186772))), @as(f64, @bitCast(@as(i64, 4647661037013223395))), @as(f64, @bitCast(@as(i64, 4644121241483107390))), @as(f64, @bitCast(@as(i64, 4647665648804794938))), @as(f64, @bitCast(@as(i64, 4644100722485070764))), @as(f64, @bitCast(@as(i64, 4647670345390703216))), @as(f64, @bitCast(@as(i64, 4644123680287858727))), @as(f64, @bitCast(@as(i64, 4647674393880477617))), @as(f64, @bitCast(@as(i64, 4644187669049845523))), @as(f64, @bitCast(@as(i64, 4647677134743063337))), @as(f64, @bitCast(@as(i64, 4644283389893331795))), @as(f64, @bitCast(@as(i64, 4647678104072514385))), @as(f64, @bitCast(@as(i64, 4644395815045232822))), @as(f64, @bitCast(@as(i64, 4647677134743063337))), @as(f64, @bitCast(@as(i64, 4644506736065227050))), @as(f64, @bitCast(@as(i64, 4647674393880477617))), @as(f64, @bitCast(@as(i64, 4644598206636564991))), @as(f64, @bitCast(@as(i64, 4647670345390703216))), @as(f64, @bitCast(@as(i64, 4644655916571430675))), @as(f64, @bitCast(@as(i64, 4647665648804794938))), @as(f64, @bitCast(@as(i64, 4644671592792492993))), @as(f64, @bitCast(@as(i64, 4647661037013223395))), @as(f64, @bitCast(@as(i64, 4644643922394907452))), @as(f64, @bitCast(@as(i64, 4647657191537275946))), @as(f64, @bitCast(@as(i64, 4644578111786133897))), @as(f64, @bitCast(@as(i64, 4647654654216282759))), @as(f64, @bitCast(@as(i64, 4644484527689564579))), @as(f64, @bitCast(@as(i64, 4646184514810969514))), @as(f64, @bitCast(@as(i64, 4644437836972271537))), @as(f64, @bitCast(@as(i64, 4646182541847304633))), @as(f64, @bitCast(@as(i64, 4644315107901082436))), @as(f64, @bitCast(@as(i64, 4646176879450382517))), @as(f64, @bitCast(@as(i64, 4644211584923085465))), @as(f64, @bitCast(@as(i64, 4646168280389844006))), @as(f64, @bitCast(@as(i64, 4644142489853177417))), @as(f64, @bitCast(@as(i64, 4646157939175121517))), @as(f64, @bitCast(@as(i64, 4644118900490910459))), @as(f64, @bitCast(@as(i64, 4646147378937682775))), @as(f64, @bitCast(@as(i64, 4644145784517779815))), @as(f64, @bitCast(@as(i64, 4646138248944969444))), @as(f64, @bitCast(@as(i64, 4644220464930835105))), @as(f64, @bitCast(@as(i64, 4646132055615872508))), @as(f64, @bitCast(@as(i64, 4644332172673389240))), @as(f64, @bitCast(@as(i64, 4646129862398038350))), @as(f64, @bitCast(@as(i64, 4644463281958322459))), @as(f64, @bitCast(@as(i64, 4646132055615872508))), @as(f64, @bitCast(@as(i64, 4644592348966377782))), @as(f64, @bitCast(@as(i64, 4646138248944969444))), @as(f64, @bitCast(@as(i64, 4644698288582971674))), @as(f64, @bitCast(@as(i64, 4646147378937682775))), @as(f64, @bitCast(@as(i64, 4644764467572121000))), @as(f64, @bitCast(@as(i64, 4646157939175121517))), @as(f64, @bitCast(@as(i64, 4644781518094757108))), @as(f64, @bitCast(@as(i64, 4646168280389844006))), @as(f64, @bitCast(@as(i64, 4644748299649458740))), @as(f64, @bitCast(@as(i64, 4646176879450382517))), @as(f64, @bitCast(@as(i64, 4644671197671994436))), @as(f64, @bitCast(@as(i64, 4646182541847304633))), @as(f64, @bitCast(@as(i64, 4644562403371371117))), @as(f64, @bitCast(@as(i64, 4647723545568676413))), @as(f64, @bitCast(@as(i64, 4644437832750146886))), @as(f64, @bitCast(@as(i64, 4647724137545736808))), @as(f64, @bitCast(@as(i64, 4644315102975270343))), @as(f64, @bitCast(@as(i64, 4647725836071299396))), @as(f64, @bitCast(@as(i64, 4644211580349117094))), @as(f64, @bitCast(@as(i64, 4647728415965382810))), @as(f64, @bitCast(@as(i64, 4644142485455130906))), @as(f64, @bitCast(@as(i64, 4647731518347391743))), @as(f64, @bitCast(@as(i64, 4644118895213254646))), @as(f64, @bitCast(@as(i64, 4647734686700098342))), @as(f64, @bitCast(@as(i64, 4644145779591967723))), @as(f64, @bitCast(@as(i64, 4647737425803465458))), @as(f64, @bitCast(@as(i64, 4644220460180944873))), @as(f64, @bitCast(@as(i64, 4647739283538311748))), @as(f64, @bitCast(@as(i64, 4644332167923499008))), @as(f64, @bitCast(@as(i64, 4647739941486069809))), @as(f64, @bitCast(@as(i64, 4644463277208432227))), @as(f64, @bitCast(@as(i64, 4647739283538311748))), @as(f64, @bitCast(@as(i64, 4644592344216487550))), @as(f64, @bitCast(@as(i64, 4647737425803465458))), @as(f64, @bitCast(@as(i64, 4644698283833081442))), @as(f64, @bitCast(@as(i64, 4647734686700098342))), @as(f64, @bitCast(@as(i64, 4644764462822230768))), @as(f64, @bitCast(@as(i64, 4647731518347391743))), @as(f64, @bitCast(@as(i64, 4644781513344866876))), @as(f64, @bitCast(@as(i64, 4647728415965382810))), @as(f64, @bitCast(@as(i64, 4644748294899568508))), @as(f64, @bitCast(@as(i64, 4647725836071299396))), @as(f64, @bitCast(@as(i64, 4644671193098026064))), @as(f64, @bitCast(@as(i64, 4647724137545736808))), @as(f64, @bitCast(@as(i64, 4644562399149246466))), @as(f64, @bitCast(@as(i64, 4645476916274391480))), @as(f64, @bitCast(@as(i64, 4644075266591864494))), @as(f64, @bitCast(@as(i64, 4645476916274391480))), @as(f64, @bitCast(@as(i64, 4639400819746036211))), @as(f64, @bitCast(@as(i64, 4646258558914655578))), @as(f64, @bitCast(@as(i64, 4641903204065113004))), @as(f64, @bitCast(@as(i64, 4646354972890272000))), @as(f64, @bitCast(@as(i64, 4643667889969133487))), @as(f64, @bitCast(@as(i64, 4646354972890272000))), @as(f64, @bitCast(@as(i64, 4644358529814286565))), @as(f64, @bitCast(@as(i64, 4646209706469541397))), @as(f64, @bitCast(@as(i64, 4644426111076585492))), @as(f64, @bitCast(@as(i64, 4646209706469541397))), @as(f64, @bitCast(@as(i64, 4644036685520494207))), @as(f64, @bitCast(@as(i64, 4647935825200018568))), @as(f64, @bitCast(@as(i64, 4644075258499458914))), @as(f64, @bitCast(@as(i64, 4647935825200018568))), @as(f64, @bitCast(@as(i64, 4639400803561225050))), @as(f64, @bitCast(@as(i64, 4647687849439895549))), @as(f64, @bitCast(@as(i64, 4641903195269019982))), @as(f64, @bitCast(@as(i64, 4647630001054525696))), @as(f64, @bitCast(@as(i64, 4643667886098852558))), @as(f64, @bitCast(@as(i64, 4647630001054525696))), @as(f64, @bitCast(@as(i64, 4644358526119927496))), @as(f64, @bitCast(@as(i64, 4647715987965551732))), @as(f64, @bitCast(@as(i64, 4644426106326695260))), @as(f64, @bitCast(@as(i64, 4647715987965551732))), @as(f64, @bitCast(@as(i64, 4644036680594682114))), @as(f64, @bitCast(@as(i64, 4646118182066114160))), @as(f64, @bitCast(@as(i64, 4644468720582638090))), @as(f64, @bitCast(@as(i64, 4646115929034847452))), @as(f64, @bitCast(@as(i64, 4644337624140000684))), @as(f64, @bitCast(@as(i64, 4646109459156585897))), @as(f64, @bitCast(@as(i64, 4644227085046365479))), @as(f64, @bitCast(@as(i64, 4646099623717212185))), @as(f64, @bitCast(@as(i64, 4644153314677094267))), @as(f64, @bitCast(@as(i64, 4646087779777957782))), @as(f64, @bitCast(@as(i64, 4644128183359720516))), @as(f64, @bitCast(@as(i64, 4646075667030100620))), @as(f64, @bitCast(@as(i64, 4644157093830500328))), @as(f64, @bitCast(@as(i64, 4646065179624312102))), @as(f64, @bitCast(@as(i64, 4644237269514710313))), @as(f64, @bitCast(@as(i64, 4646058058131479462))), @as(f64, @bitCast(@as(i64, 4644357193687756492))), @as(f64, @bitCast(@as(i64, 4646055534884235111))), @as(f64, @bitCast(@as(i64, 4644497895991739731))), @as(f64, @bitCast(@as(i64, 4646058058131479462))), @as(f64, @bitCast(@as(i64, 4644636248331511157))), @as(f64, @bitCast(@as(i64, 4646065179624312102))), @as(f64, @bitCast(@as(i64, 4644749538139356266))), @as(f64, @bitCast(@as(i64, 4646075667030100620))), @as(f64, @bitCast(@as(i64, 4644819945586343228))), @as(f64, @bitCast(@as(i64, 4646087779777957782))), @as(f64, @bitCast(@as(i64, 4644837573308603454))), @as(f64, @bitCast(@as(i64, 4646099623717212185))), @as(f64, @bitCast(@as(i64, 4644801410810970552))), @as(f64, @bitCast(@as(i64, 4646109459156585897))), @as(f64, @bitCast(@as(i64, 4644718479838582292))), @as(f64, @bitCast(@as(i64, 4646115929034847452))), @as(f64, @bitCast(@as(i64, 4644601915069383154))), @as(f64, @bitCast(@as(i64, 4647743444969920555))), @as(f64, @bitCast(@as(i64, 4644468715832747858))), @as(f64, @bitCast(@as(i64, 4647744121389473962))), @as(f64, @bitCast(@as(i64, 4644337619390110452))), @as(f64, @bitCast(@as(i64, 4647746062423321173))), @as(f64, @bitCast(@as(i64, 4644227079768709666))), @as(f64, @bitCast(@as(i64, 4647749012896803612))), @as(f64, @bitCast(@as(i64, 4644153309399438454))), @as(f64, @bitCast(@as(i64, 4647752566078579933))), @as(f64, @bitCast(@as(i64, 4644128177906142843))), @as(f64, @bitCast(@as(i64, 4647756200184412058))), @as(f64, @bitCast(@as(i64, 4644157088376922655))), @as(f64, @bitCast(@as(i64, 4647759346195042381))), @as(f64, @bitCast(@as(i64, 4644237264237054499))), @as(f64, @bitCast(@as(i64, 4647761482238271894))), @as(f64, @bitCast(@as(i64, 4644357188410100679))), @as(f64, @bitCast(@as(i64, 4647762239581881106))), @as(f64, @bitCast(@as(i64, 4644497890714083918))), @as(f64, @bitCast(@as(i64, 4647761482238271894))), @as(f64, @bitCast(@as(i64, 4644636243053855344))), @as(f64, @bitCast(@as(i64, 4647759346195042381))), @as(f64, @bitCast(@as(i64, 4644749532861700453))), @as(f64, @bitCast(@as(i64, 4647756200184412058))), @as(f64, @bitCast(@as(i64, 4644819940308687415))), @as(f64, @bitCast(@as(i64, 4647752566078579933))), @as(f64, @bitCast(@as(i64, 4644837568558713222))), @as(f64, @bitCast(@as(i64, 4647749012896803612))), @as(f64, @bitCast(@as(i64, 4644801406061080320))), @as(f64, @bitCast(@as(i64, 4647746062423321173))), @as(f64, @bitCast(@as(i64, 4644718474912770199))), @as(f64, @bitCast(@as(i64, 4647744121389473962))), @as(f64, @bitCast(@as(i64, 4644601910143571062))), @as(f64, @bitCast(@as(i64, 4645476916274391480))), @as(f64, @bitCast(@as(i64, 4639400819746036211))), @as(f64, @bitCast(@as(i64, 4647935825200018568))), @as(f64, @bitCast(@as(i64, 4639400803561225050))), @as(f64, @bitCast(@as(i64, 4647687849439895549))), @as(f64, @bitCast(@as(i64, 4641903195269019982))), @as(f64, @bitCast(@as(i64, 4646258558914655578))), @as(f64, @bitCast(@as(i64, 4641903204065113004))), @as(f64, @bitCast(@as(i64, 4645811905977361807))), @as(f64, @bitCast(@as(i64, 4644611410627722488))), @as(f64, @bitCast(@as(i64, 4645808117324175282))), @as(f64, @bitCast(@as(i64, 4644441766362946417))), @as(f64, @bitCast(@as(i64, 4645797210872515186))), @as(f64, @bitCast(@as(i64, 4644298964607480638))), @as(f64, @bitCast(@as(i64, 4645780553359315310))), @as(f64, @bitCast(@as(i64, 4644203714530892914))), @as(f64, @bitCast(@as(i64, 4645760369316500970))), @as(f64, @bitCast(@as(i64, 4644171598939737670))), @as(f64, @bitCast(@as(i64, 4645739582037627167))), @as(f64, @bitCast(@as(i64, 4644210194084856794))), @as(f64, @bitCast(@as(i64, 4645721467363657232))), @as(f64, @bitCast(@as(i64, 4644316416056036698))), @as(f64, @bitCast(@as(i64, 4645709102167930333))), @as(f64, @bitCast(@as(i64, 4644475288273454052))), @as(f64, @bitCast(@as(i64, 4645704709399075042))), @as(f64, @bitCast(@as(i64, 4644661376130447699))), @as(f64, @bitCast(@as(i64, 4645709102167930333))), @as(f64, @bitCast(@as(i64, 4644843368878373926))), @as(f64, @bitCast(@as(i64, 4645721467363657232))), @as(f64, @bitCast(@as(i64, 4644990712584432653))), @as(f64, @bitCast(@as(i64, 4645739582037627167))), @as(f64, @bitCast(@as(i64, 4645080047288462942))), @as(f64, @bitCast(@as(i64, 4645760369316500970))), @as(f64, @bitCast(@as(i64, 4645099263761044839))), @as(f64, @bitCast(@as(i64, 4645780553359315310))), @as(f64, @bitCast(@as(i64, 4645048332271383929))), @as(f64, @bitCast(@as(i64, 4645797210872515186))), @as(f64, @bitCast(@as(i64, 4644937554275862242))), @as(f64, @bitCast(@as(i64, 4645808117324175282))), @as(f64, @bitCast(@as(i64, 4644784586347925115))), @as(f64, @bitCast(@as(i64, 4647835328429864958))), @as(f64, @bitCast(@as(i64, 4644611404294535512))), @as(f64, @bitCast(@as(i64, 4647836465061005288))), @as(f64, @bitCast(@as(i64, 4644441759853837581))), @as(f64, @bitCast(@as(i64, 4647839736679843968))), @as(f64, @bitCast(@as(i64, 4644298958274293662))), @as(f64, @bitCast(@as(i64, 4647844734619899186))), @as(f64, @bitCast(@as(i64, 4644203707669940357))), @as(f64, @bitCast(@as(i64, 4647850789322570093))), @as(f64, @bitCast(@as(i64, 4644171592606550694))), @as(f64, @bitCast(@as(i64, 4647857025400679118))), @as(f64, @bitCast(@as(i64, 4644210187047982376))), @as(f64, @bitCast(@as(i64, 4647862459626948238))), @as(f64, @bitCast(@as(i64, 4644316409722849722))), @as(f64, @bitCast(@as(i64, 4647866169818985005))), @as(f64, @bitCast(@as(i64, 4644475281236579634))), @as(f64, @bitCast(@as(i64, 4647867487473719732))), @as(f64, @bitCast(@as(i64, 4644661369093573281))), @as(f64, @bitCast(@as(i64, 4647866169818985005))), @as(f64, @bitCast(@as(i64, 4644843361841499509))), @as(f64, @bitCast(@as(i64, 4647862459626948238))), @as(f64, @bitCast(@as(i64, 4644990705547558236))), @as(f64, @bitCast(@as(i64, 4647857025400679118))), @as(f64, @bitCast(@as(i64, 4645080040427510385))), @as(f64, @bitCast(@as(i64, 4647850789322570093))), @as(f64, @bitCast(@as(i64, 4645099256724170421))), @as(f64, @bitCast(@as(i64, 4647844734619899186))), @as(f64, @bitCast(@as(i64, 4645048325586353232))), @as(f64, @bitCast(@as(i64, 4647839736679843968))), @as(f64, @bitCast(@as(i64, 4644937547590831545))), @as(f64, @bitCast(@as(i64, 4647836465061005288))), @as(f64, @bitCast(@as(i64, 4644784580014738139))), @as(f64, @bitCast(@as(i64, 4645681178442865752))), @as(f64, @bitCast(@as(i64, 4644672345386211974))), @as(f64, @bitCast(@as(i64, 4645676612918743505))), @as(f64, @bitCast(@as(i64, 4644486288667387625))), @as(f64, @bitCast(@as(i64, 4645663457482019491))), @as(f64, @bitCast(@as(i64, 4644329785061899292))), @as(f64, @bitCast(@as(i64, 4645643323752857238))), @as(f64, @bitCast(@as(i64, 4644225422408862421))), @as(f64, @bitCast(@as(i64, 4645618861290396896))), @as(f64, @bitCast(@as(i64, 4644190395134994966))), @as(f64, @bitCast(@as(i64, 4645593592753972000))), @as(f64, @bitCast(@as(i64, 4644233292449211251))), @as(f64, @bitCast(@as(i64, 4645571510866127188))), @as(f64, @bitCast(@as(i64, 4644350980127645604))), @as(f64, @bitCast(@as(i64, 4645556403224517825))), @as(f64, @bitCast(@as(i64, 4644526997865503706))), @as(f64, @bitCast(@as(i64, 4645551029339446837))), @as(f64, @bitCast(@as(i64, 4644733022067332187))), @as(f64, @bitCast(@as(i64, 4645556403224517825))), @as(f64, @bitCast(@as(i64, 4644934035662731498))), @as(f64, @bitCast(@as(i64, 4645571510866127188))), @as(f64, @bitCast(@as(i64, 4645095966633536394))), @as(f64, @bitCast(@as(i64, 4645593592753972000))), @as(f64, @bitCast(@as(i64, 4645193063010049479))), @as(f64, @bitCast(@as(i64, 4645618861290396896))), @as(f64, @bitCast(@as(i64, 4645212398405809036))), @as(f64, @bitCast(@as(i64, 4645643323752857238))), @as(f64, @bitCast(@as(i64, 4645154563038656856))), @as(f64, @bitCast(@as(i64, 4645663457482019491))), @as(f64, @bitCast(@as(i64, 4645031427763891989))), @as(f64, @bitCast(@as(i64, 4645676612918743505))), @as(f64, @bitCast(@as(i64, 4644862658182606047))), @as(f64, @bitCast(@as(i64, 4647874546338370054))), @as(f64, @bitCast(@as(i64, 4644672338349337556))), @as(f64, @bitCast(@as(i64, 4647875915890053612))), @as(f64, @bitCast(@as(i64, 4644486281630513208))), @as(f64, @bitCast(@as(i64, 4647879862960875467))), @as(f64, @bitCast(@as(i64, 4644329778376868595))), @as(f64, @bitCast(@as(i64, 4647885903325914747))), @as(f64, @bitCast(@as(i64, 4644225414844222422))), @as(f64, @bitCast(@as(i64, 4647893241554479455))), @as(f64, @bitCast(@as(i64, 4644190388449964269))), @as(f64, @bitCast(@as(i64, 4647900822467250645))), @as(f64, @bitCast(@as(i64, 4644233284884571252))), @as(f64, @bitCast(@as(i64, 4647907446892866600))), @as(f64, @bitCast(@as(i64, 4644350972387083745))), @as(f64, @bitCast(@as(i64, 4647911978991835362))), @as(f64, @bitCast(@as(i64, 4644526990300863707))), @as(f64, @bitCast(@as(i64, 4647913591315686333))), @as(f64, @bitCast(@as(i64, 4644733014502692188))), @as(f64, @bitCast(@as(i64, 4647911978991835362))), @as(f64, @bitCast(@as(i64, 4644934028098091499))), @as(f64, @bitCast(@as(i64, 4647907446892866600))), @as(f64, @bitCast(@as(i64, 4645095959068896395))), @as(f64, @bitCast(@as(i64, 4647900822467250645))), @as(f64, @bitCast(@as(i64, 4645193055445409480))), @as(f64, @bitCast(@as(i64, 4647893241554479455))), @as(f64, @bitCast(@as(i64, 4645212390841169037))), @as(f64, @bitCast(@as(i64, 4647885903325914747))), @as(f64, @bitCast(@as(i64, 4645154556001782438))), @as(f64, @bitCast(@as(i64, 4647879862960875467))), @as(f64, @bitCast(@as(i64, 4645031420199251990))), @as(f64, @bitCast(@as(i64, 4647875915890053612))), @as(f64, @bitCast(@as(i64, 4644862651145731629))), @as(f64, @bitCast(@as(i64, 4645476916274391480))), @as(f64, @bitCast(@as(i64, 4644075266591864494))), @as(f64, @bitCast(@as(i64, 4647935825200018568))), @as(f64, @bitCast(@as(i64, 4644075258499458914))), @as(f64, @bitCast(@as(i64, 4647935825200018568))), @as(f64, @bitCast(@as(i64, 4639400803561225050))), @as(f64, @bitCast(@as(i64, 4645476916274391480))), @as(f64, @bitCast(@as(i64, 4639400819746036211))), @as(f64, @bitCast(@as(i64, 4647771493951349771))), @as(f64, @bitCast(@as(i64, 4643000828403170159))), @as(f64, @bitCast(@as(i64, 4647696112489680612))), @as(f64, @bitCast(@as(i64, 4643769929925846914))), @as(f64, @bitCast(@as(i64, 4647320039226875178))), @as(f64, @bitCast(@as(i64, 4644332763770840332))), @as(f64, @bitCast(@as(i64, 4646757205205959899))), @as(f64, @bitCast(@as(i64, 4644708836857723906))), @as(f64, @bitCast(@as(i64, 4646093297918954334))), @as(f64, @bitCast(@as(i64, 4644840896648469105))), @as(f64, @bitCast(@as(i64, 4645429389928261327))), @as(f64, @bitCast(@as(i64, 4644708836857723906))), @as(f64, @bitCast(@as(i64, 4644866556083267908))), @as(f64, @bitCast(@as(i64, 4644332763770840332))), @as(f64, @bitCast(@as(i64, 4644490482644540614))), @as(f64, @bitCast(@as(i64, 4643769929574003193))), @as(f64, @bitCast(@as(i64, 4644358423381560997))), @as(f64, @bitCast(@as(i64, 4643000828051326438))), @as(f64, @bitCast(@as(i64, 4644490483172306196))), @as(f64, @bitCast(@as(i64, 4641673013125471588))), @as(f64, @bitCast(@as(i64, 4644866556083267908))), @as(f64, @bitCast(@as(i64, 4640547345083641029))), @as(f64, @bitCast(@as(i64, 4645429390807870629))), @as(f64, @bitCast(@as(i64, 4639795198558030162))), @as(f64, @bitCast(@as(i64, 4646093297918954334))), @as(f64, @bitCast(@as(i64, 4639531079680227205))), @as(f64, @bitCast(@as(i64, 4646757205909647340))), @as(f64, @bitCast(@as(i64, 4639795198909873882))), @as(f64, @bitCast(@as(i64, 4647320039754640759))), @as(f64, @bitCast(@as(i64, 4640547346491015912))), @as(f64, @bitCast(@as(i64, 4647696113193368053))), @as(f64, @bitCast(@as(i64, 4641673013125471588))), @as(f64, @bitCast(@as(i64, 4645744908247873974))), @as(f64, @bitCast(@as(i64, 4643521412854159308))), @as(f64, @bitCast(@as(i64, 4646441687238190972))), @as(f64, @bitCast(@as(i64, 4643521406520972332))), @as(f64, @bitCast(@as(i64, 4646441687238190972))), @as(f64, @bitCast(@as(i64, 4642170047620690519))), @as(f64, @bitCast(@as(i64, 4645744908247873974))), @as(f64, @bitCast(@as(i64, 4642170059935220750))), @as(f64, @bitCast(@as(i64, 4648495069359449624))), @as(f64, @bitCast(@as(i64, 4643000819255233416))), @as(f64, @bitCast(@as(i64, 4648429040079803536))), @as(f64, @bitCast(@as(i64, 4643769923416738077))), @as(f64, @bitCast(@as(i64, 4648241003888205470))), @as(f64, @bitCast(@as(i64, 4644332755854356612))), @as(f64, @bitCast(@as(i64, 4647959587845318063))), @as(f64, @bitCast(@as(i64, 4644708828061630883))), @as(f64, @bitCast(@as(i64, 4647540453660966131))), @as(f64, @bitCast(@as(i64, 4644840887324610501))), @as(f64, @bitCast(@as(i64, 4646876547781335450))), @as(f64, @bitCast(@as(i64, 4644708828061630883))), @as(f64, @bitCast(@as(i64, 4646313715695560635))), @as(f64, @bitCast(@as(i64, 4644332755854356612))), @as(f64, @bitCast(@as(i64, 4645937642784598922))), @as(f64, @bitCast(@as(i64, 4643769923416738077))), @as(f64, @bitCast(@as(i64, 4645805583873463026))), @as(f64, @bitCast(@as(i64, 4643000818903389695))), @as(f64, @bitCast(@as(i64, 4645937642784598922))), @as(f64, @bitCast(@as(i64, 4641673007847815774))), @as(f64, @bitCast(@as(i64, 4646313715695560635))), @as(f64, @bitCast(@as(i64, 4640547342972578704))), @as(f64, @bitCast(@as(i64, 4646876548485022891))), @as(f64, @bitCast(@as(i64, 4639795197502498999))), @as(f64, @bitCast(@as(i64, 4647540453660966131))), @as(f64, @bitCast(@as(i64, 4639531079680227205))), @as(f64, @bitCast(@as(i64, 4647959587845318063))), @as(f64, @bitCast(@as(i64, 4639795198558030162))), @as(f64, @bitCast(@as(i64, 4648241003888205470))), @as(f64, @bitCast(@as(i64, 4640547344028109866))), @as(f64, @bitCast(@as(i64, 4648429040079803536))), @as(f64, @bitCast(@as(i64, 4641673007847815774))), @as(f64, @bitCast(@as(i64, 4647192064165807632))), @as(f64, @bitCast(@as(i64, 4643521403706222565))), @as(f64, @bitCast(@as(i64, 4647801829301238251))), @as(f64, @bitCast(@as(i64, 4643521406520972332))), @as(f64, @bitCast(@as(i64, 4647801829301238251))), @as(f64, @bitCast(@as(i64, 4642170047620690519))), @as(f64, @bitCast(@as(i64, 4647192064165807632))), @as(f64, @bitCast(@as(i64, 4642170042694878427))), @as(f64, @bitCast(@as(i64, 4646032929804777339))), @as(f64, @bitCast(@as(i64, 4644545329802971290))), @as(f64, @bitCast(@as(i64, 4646032929804777339))), @as(f64, @bitCast(@as(i64, 4643923698826014643))), @as(f64, @bitCast(@as(i64, 4646791278455578165))), @as(f64, @bitCast(@as(i64, 4643826827453561066))), @as(f64, @bitCast(@as(i64, 4646791278455578165))), @as(f64, @bitCast(@as(i64, 4644548002056031437))), @as(f64, @bitCast(@as(i64, 4647992808049835036))), @as(f64, @bitCast(@as(i64, 4644545329802971290))), @as(f64, @bitCast(@as(i64, 4647992808049835036))), @as(f64, @bitCast(@as(i64, 4643923698826014643))), @as(f64, @bitCast(@as(i64, 4647512452530282955))), @as(f64, @bitCast(@as(i64, 4643826827453561066))), @as(f64, @bitCast(@as(i64, 4647512452530282955))), @as(f64, @bitCast(@as(i64, 4644548002056031437))), @as(f64, @bitCast(@as(i64, 4645659951359340839))), @as(f64, @bitCast(@as(i64, 4643239908674419818))), @as(f64, @bitCast(@as(i64, 4648179297536436077))), @as(f64, @bitCast(@as(i64, 4643239908674419818))), @as(f64, @bitCast(@as(i64, 4648179297536436077))), @as(f64, @bitCast(@as(i64, 4644856149073769613))), @as(f64, @bitCast(@as(i64, 4645659951359340839))), @as(f64, @bitCast(@as(i64, 4644856149073769613))), @as(f64, @bitCast(@as(i64, 4645155787982571129))), @as(f64, @bitCast(@as(i64, 4634844218028707377))), @as(f64, @bitCast(@as(i64, 4648431379224820932))), @as(f64, @bitCast(@as(i64, 4634844218028707377))), @as(f64, @bitCast(@as(i64, 4648179297536436077))), @as(f64, @bitCast(@as(i64, 4643239908674419818))), @as(f64, @bitCast(@as(i64, 4645659951359340839))), @as(f64, @bitCast(@as(i64, 4643239908674419818))), @as(f64, @bitCast(@as(i64, 4645474003184304385))), @as(f64, @bitCast(@as(i64, 4644964555114846932))), @as(f64, @bitCast(@as(i64, 4645466565383966666))), @as(f64, @bitCast(@as(i64, 4644700168308050520))), @as(f64, @bitCast(@as(i64, 4645445021817014814))), @as(f64, @bitCast(@as(i64, 4644478568336542034))), @as(f64, @bitCast(@as(i64, 4645411730540066222))), @as(f64, @bitCast(@as(i64, 4644330998043127054))), @as(f64, @bitCast(@as(i64, 4645370749894519475))), @as(f64, @bitCast(@as(i64, 4644282625688770026))), @as(f64, @bitCast(@as(i64, 4645327792942792500))), @as(f64, @bitCast(@as(i64, 4644347627584751120))), @as(f64, @bitCast(@as(i64, 4645289720285598895))), @as(f64, @bitCast(@as(i64, 4644523363143945070))), @as(f64, @bitCast(@as(i64, 4645263382320184358))), @as(f64, @bitCast(@as(i64, 4644786239309725848))), @as(f64, @bitCast(@as(i64, 4645253955371370598))), @as(f64, @bitCast(@as(i64, 4645092857038731183))), @as(f64, @bitCast(@as(i64, 4645263382320184358))), @as(f64, @bitCast(@as(i64, 4645388481762521084))), @as(f64, @bitCast(@as(i64, 4645289720285598895))), @as(f64, @bitCast(@as(i64, 4645620643026999475))), @as(f64, @bitCast(@as(i64, 4645327792942792500))), @as(f64, @bitCast(@as(i64, 4645751980482585690))), @as(f64, @bitCast(@as(i64, 4645370749894519475))), @as(f64, @bitCast(@as(i64, 4645766887749196007))), @as(f64, @bitCast(@as(i64, 4645411730540066222))), @as(f64, @bitCast(@as(i64, 4645670727276980485))), @as(f64, @bitCast(@as(i64, 4645445021817014814))), @as(f64, @bitCast(@as(i64, 4645484335251090131))), @as(f64, @bitCast(@as(i64, 4645466565383966666))), @as(f64, @bitCast(@as(i64, 4645237614693441381))), @as(f64, @bitCast(@as(i64, 4648272271360071513))), @as(f64, @bitCast(@as(i64, 4644964555114846932))), @as(f64, @bitCast(@as(i64, 4648275990348201302))), @as(f64, @bitCast(@as(i64, 4644700168308050520))), @as(f64, @bitCast(@as(i64, 4648286762043716298))), @as(f64, @bitCast(@as(i64, 4644478568336542034))), @as(f64, @bitCast(@as(i64, 4648303407770151525))), @as(f64, @bitCast(@as(i64, 4644330998043127054))), @as(f64, @bitCast(@as(i64, 4648323898268846758))), @as(f64, @bitCast(@as(i64, 4644282625688770026))), @as(f64, @bitCast(@as(i64, 4648345376568788386))), @as(f64, @bitCast(@as(i64, 4644347627584751120))), @as(f64, @bitCast(@as(i64, 4648364413073307048))), @as(f64, @bitCast(@as(i64, 4644523363143945070))), @as(f64, @bitCast(@as(i64, 4648377582056014317))), @as(f64, @bitCast(@as(i64, 4644786239309725848))), @as(f64, @bitCast(@as(i64, 4648382295266538407))), @as(f64, @bitCast(@as(i64, 4645092857038731183))), @as(f64, @bitCast(@as(i64, 4648377582056014317))), @as(f64, @bitCast(@as(i64, 4645388481762521084))), @as(f64, @bitCast(@as(i64, 4648364413073307048))), @as(f64, @bitCast(@as(i64, 4645620643026999475))), @as(f64, @bitCast(@as(i64, 4648345376568788386))), @as(f64, @bitCast(@as(i64, 4645751980482585690))), @as(f64, @bitCast(@as(i64, 4648323898268846758))), @as(f64, @bitCast(@as(i64, 4645766887749196007))), @as(f64, @bitCast(@as(i64, 4648303407770151525))), @as(f64, @bitCast(@as(i64, 4645670727276980485))), @as(f64, @bitCast(@as(i64, 4648286762043716298))), @as(f64, @bitCast(@as(i64, 4645484335251090131))), @as(f64, @bitCast(@as(i64, 4648275990348201302))), @as(f64, @bitCast(@as(i64, 4645237614693441381))), @as(f64, @bitCast(@as(i64, 4644612993220779044))), @as(f64, @bitCast(@as(i64, 4645466639622991774))), @as(f64, @bitCast(@as(i64, 4644595924930035030))), @as(f64, @bitCast(@as(i64, 4645069045311232625))), @as(f64, @bitCast(@as(i64, 4644546043342037252))), @as(f64, @bitCast(@as(i64, 4644737937851878579))), @as(f64, @bitCast(@as(i64, 4644467643061242870))), @as(f64, @bitCast(@as(i64, 4644518119089207090))), @as(f64, @bitCast(@as(i64, 4644368870501243473))), @as(f64, @bitCast(@as(i64, 4644449434444999458))), @as(f64, @bitCast(@as(i64, 4644262552476727766))), @as(f64, @bitCast(@as(i64, 4644558783779092478))), @as(f64, @bitCast(@as(i64, 4644165848054119751))), @as(f64, @bitCast(@as(i64, 4644847661723612485))), @as(f64, @bitCast(@as(i64, 4644097543049286957))), @as(f64, @bitCast(@as(i64, 4645280248652632582))), @as(f64, @bitCast(@as(i64, 4644072807732021066))), @as(f64, @bitCast(@as(i64, 4645781691045986802))), @as(f64, @bitCast(@as(i64, 4644097543049286957))), @as(f64, @bitCast(@as(i64, 4646254280495009576))), @as(f64, @bitCast(@as(i64, 4644165848054119751))), @as(f64, @bitCast(@as(i64, 4646607189598684746))), @as(f64, @bitCast(@as(i64, 4644262552476727766))), @as(f64, @bitCast(@as(i64, 4646783265214834934))), @as(f64, @bitCast(@as(i64, 4644368870501243473))), @as(f64, @bitCast(@as(i64, 4646768596498267379))), @as(f64, @bitCast(@as(i64, 4644467643061242870))), @as(f64, @bitCast(@as(i64, 4646584701155420448))), @as(f64, @bitCast(@as(i64, 4644546043342037252))), @as(f64, @bitCast(@as(i64, 4646273433107956131))), @as(f64, @bitCast(@as(i64, 4644595924930035030))), @as(f64, @bitCast(@as(i64, 4645884141956166226))), @as(f64, @bitCast(@as(i64, 4648702776781638835))), @as(f64, @bitCast(@as(i64, 4645466639622991774))), @as(f64, @bitCast(@as(i64, 4648711310751088981))), @as(f64, @bitCast(@as(i64, 4645069045311232625))), @as(f64, @bitCast(@as(i64, 4648736251545087870))), @as(f64, @bitCast(@as(i64, 4644737937851878579))), @as(f64, @bitCast(@as(i64, 4648775451861406922))), @as(f64, @bitCast(@as(i64, 4644518119089207090))), @as(f64, @bitCast(@as(i64, 4648824837965484759))), @as(f64, @bitCast(@as(i64, 4644449434444999458))), @as(f64, @bitCast(@as(i64, 4648877996713859822))), @as(f64, @bitCast(@as(i64, 4644558783779092478))), @as(f64, @bitCast(@as(i64, 4648926349716812202))), @as(f64, @bitCast(@as(i64, 4644847661723612485))), @as(f64, @bitCast(@as(i64, 4648960501955345808))), @as(f64, @bitCast(@as(i64, 4645280248652632582))), @as(f64, @bitCast(@as(i64, 4648972869613978753))), @as(f64, @bitCast(@as(i64, 4645781691045986802))), @as(f64, @bitCast(@as(i64, 4648960501955345808))), @as(f64, @bitCast(@as(i64, 4646254280495009576))), @as(f64, @bitCast(@as(i64, 4648926349716812202))), @as(f64, @bitCast(@as(i64, 4646607189598684746))), @as(f64, @bitCast(@as(i64, 4648877996713859822))), @as(f64, @bitCast(@as(i64, 4646783265214834934))), @as(f64, @bitCast(@as(i64, 4648824837965484759))), @as(f64, @bitCast(@as(i64, 4646768596498267379))), @as(f64, @bitCast(@as(i64, 4648775451861406922))), @as(f64, @bitCast(@as(i64, 4646584701155420448))), @as(f64, @bitCast(@as(i64, 4648736251545087870))), @as(f64, @bitCast(@as(i64, 4646273433107956131))), @as(f64, @bitCast(@as(i64, 4648711310751088981))), @as(f64, @bitCast(@as(i64, 4645884141956166226))), (-@as(f64, @bitCast(@as(i64, 4654648479587228241)))), (-@as(f64, @bitCast(@as(i64, 4660603068645793333)))), @as(f64, @bitCast(@as(i64, 4645155787982571129))), @as(f64, @bitCast(@as(i64, 4634844218028707377))), @as(f64, @bitCast(@as(i64, 4645659951359340839))), @as(f64, @bitCast(@as(i64, 4643239908674419818))), @as(f64, @bitCast(@as(i64, 4645659951359340839))), @as(f64, @bitCast(@as(i64, 4644856149073769613))), @as(f64, @bitCast(@as(i64, 4644817741285431863))), @as(f64, @bitCast(@as(i64, 4645347232660215300))), @as(f64, @bitCast(@as(i64, 4644817741285431863))), @as(f64, @bitCast(@as(i64, 4644141268427700353))), (-@as(f64, @bitCast(@as(i64, 4654648479587228241)))), @as(f64, @bitCast(@as(i64, 4646399712634132717))), @as(f64, @bitCast(@as(i64, 4657796309469490473))), (-@as(f64, @bitCast(@as(i64, 4660603068645793333)))), @as(f64, @bitCast(@as(i64, 4648431379224820932))), @as(f64, @bitCast(@as(i64, 4634844218028707377))), @as(f64, @bitCast(@as(i64, 4648179297536436077))), @as(f64, @bitCast(@as(i64, 4643239908674419818))), @as(f64, @bitCast(@as(i64, 4648179297536436077))), @as(f64, @bitCast(@as(i64, 4644856149073769613))), @as(f64, @bitCast(@as(i64, 4648600402309507774))), @as(f64, @bitCast(@as(i64, 4645347232660215300))), @as(f64, @bitCast(@as(i64, 4648600402309507774))), @as(f64, @bitCast(@as(i64, 4644141268427700353))), @as(f64, @bitCast(@as(i64, 4657796309469490473))), @as(f64, @bitCast(@as(i64, 4646399712634132717))), @as(f64, @bitCast(@as(i64, 4643935962514828066))), @as(f64, @bitCast(@as(i64, 4645861505914461015))), @as(f64, @bitCast(@as(i64, 4643908528380301101))), @as(f64, @bitCast(@as(i64, 4645360352032957923))), @as(f64, @bitCast(@as(i64, 4643827784996247464))), @as(f64, @bitCast(@as(i64, 4644945234848367373))), @as(f64, @bitCast(@as(i64, 4643699140376579067))), @as(f64, @bitCast(@as(i64, 4644670509289754518))), @as(f64, @bitCast(@as(i64, 4643533974378682463))), @as(f64, @bitCast(@as(i64, 4644588516860491727))), @as(f64, @bitCast(@as(i64, 4643352213143924580))), @as(f64, @bitCast(@as(i64, 4644739313033061671))), @as(f64, @bitCast(@as(i64, 4643155163243962937))), @as(f64, @bitCast(@as(i64, 4645131294381941488))), @as(f64, @bitCast(@as(i64, 4642912014955612366))), @as(f64, @bitCast(@as(i64, 4645719293321305863))), @as(f64, @bitCast(@as(i64, 4642823050567098313))), @as(f64, @bitCast(@as(i64, 4646397435149727406))), @as(f64, @bitCast(@as(i64, 4642912014955612366))), @as(f64, @bitCast(@as(i64, 4647023685306973736))), @as(f64, @bitCast(@as(i64, 4643155163243962937))), @as(f64, @bitCast(@as(i64, 4647469859560885238))), @as(f64, @bitCast(@as(i64, 4643352213143924580))), @as(f64, @bitCast(@as(i64, 4647664664170142032))), @as(f64, @bitCast(@as(i64, 4643533974378682463))), @as(f64, @bitCast(@as(i64, 4647603425242755839))), @as(f64, @bitCast(@as(i64, 4643699140376579067))), @as(f64, @bitCast(@as(i64, 4647328760729028558))), @as(f64, @bitCast(@as(i64, 4643827784996247464))), @as(f64, @bitCast(@as(i64, 4646903967490269858))), @as(f64, @bitCast(@as(i64, 4643908528380301101))), @as(f64, @bitCast(@as(i64, 4646394661741597504))), @as(f64, @bitCast(@as(i64, 4649041291782770603))), @as(f64, @bitCast(@as(i64, 4645861505914461015))), @as(f64, @bitCast(@as(i64, 4649055009025955946))), @as(f64, @bitCast(@as(i64, 4645360352032957923))), @as(f64, @bitCast(@as(i64, 4649095380717982764))), @as(f64, @bitCast(@as(i64, 4644945234848367373))), @as(f64, @bitCast(@as(i64, 4649159703027816962))), @as(f64, @bitCast(@as(i64, 4644670509289754518))), @as(f64, @bitCast(@as(i64, 4649242286026765264))), @as(f64, @bitCast(@as(i64, 4644588516860491727))), @as(f64, @bitCast(@as(i64, 4649333166380261415))), @as(f64, @bitCast(@as(i64, 4644739313033061671))), @as(f64, @bitCast(@as(i64, 4649417678714253208))), @as(f64, @bitCast(@as(i64, 4645131294381941488))), @as(f64, @bitCast(@as(i64, 4649478465522458060))), @as(f64, @bitCast(@as(i64, 4645719293321305863))), @as(f64, @bitCast(@as(i64, 4649500706883469364))), @as(f64, @bitCast(@as(i64, 4646397435149727406))), @as(f64, @bitCast(@as(i64, 4649478465522458060))), @as(f64, @bitCast(@as(i64, 4647023685306973736))), @as(f64, @bitCast(@as(i64, 4649417678714253208))), @as(f64, @bitCast(@as(i64, 4647469859560885238))), @as(f64, @bitCast(@as(i64, 4649333166380261415))), @as(f64, @bitCast(@as(i64, 4647664664170142032))), @as(f64, @bitCast(@as(i64, 4649242286026765264))), @as(f64, @bitCast(@as(i64, 4647603425242755839))), @as(f64, @bitCast(@as(i64, 4649159703027816962))), @as(f64, @bitCast(@as(i64, 4647328760729028558))), @as(f64, @bitCast(@as(i64, 4649095380717982764))), @as(f64, @bitCast(@as(i64, 4646903967490269858))), @as(f64, @bitCast(@as(i64, 4649055009025955946))), @as(f64, @bitCast(@as(i64, 4646394661741597504))), @as(f64, @bitCast(@as(i64, 4657796309469490473))), (-@as(f64, @bitCast(@as(i64, 4660603068645793333)))), @as(f64, @bitCast(@as(i64, 4648431379224820932))), @as(f64, @bitCast(@as(i64, 4634844218028707377))), @as(f64, @bitCast(@as(i64, 4645155787982571129))), @as(f64, @bitCast(@as(i64, 4634844218028707377))), (-@as(f64, @bitCast(@as(i64, 4654648479587228241)))), (-@as(f64, @bitCast(@as(i64, 4660603068645793333)))), (-@as(f64, @bitCast(@as(i64, 4652839534909713495)))), @as(f64, @bitCast(@as(i64, 4653255153383645381))), (-@as(f64, @bitCast(@as(i64, 4653435754325772704)))), @as(f64, @bitCast(@as(i64, 4652354126914329457))), (-@as(f64, @bitCast(@as(i64, 4654648479587228241)))), @as(f64, @bitCast(@as(i64, 4652120578418020534))), (-@as(f64, @bitCast(@as(i64, 4654648479587228241)))), @as(f64, @bitCast(@as(i64, 4656451264360799535))), (-@as(f64, @bitCast(@as(i64, 4653435754325772704)))), @as(f64, @bitCast(@as(i64, 4654851774449352861))), @as(f64, @bitCast(@as(i64, 4656891837130733099))), @as(f64, @bitCast(@as(i64, 4653255153383645381))), @as(f64, @bitCast(@as(i64, 4657189947058665030))), @as(f64, @bitCast(@as(i64, 4652354126914329457))), @as(f64, @bitCast(@as(i64, 4657796309469490473))), @as(f64, @bitCast(@as(i64, 4652120578418020534))), @as(f64, @bitCast(@as(i64, 4657796309469490473))), @as(f64, @bitCast(@as(i64, 4656451264360799535))), @as(f64, @bitCast(@as(i64, 4657189947058665030))), @as(f64, @bitCast(@as(i64, 4654851774449352861))) });
}

fn tb_cases() *CxList(TbCase) {
    return cx_ll_of(TbCase, &[_]TbCase{ cx_new(TbCaseS{ .start_ = 0, .along = @as(f64, @bitCast(@as(i64, 4636737291354636288))), .across = @as(f64, @bitCast(@as(i64, 0))), .yaw = @as(f64, @bitCast(@as(i64, 0))), .d_ = 0, .center = @as(f64, @bitCast(@as(i64, 4643000109586448384))), .braking = false, .headlights = false }), cx_new(TbCaseS{ .start_ = 0, .along = @as(f64, @bitCast(@as(i64, 4636737291354636288))), .across = @as(f64, @bitCast(@as(i64, 0))), .yaw = @as(f64, @bitCast(@as(i64, 0))), .d_ = 0, .center = @as(f64, @bitCast(@as(i64, 4643000109586448384))), .braking = true, .headlights = true }), cx_new(TbCaseS{ .start_ = 0, .along = @as(f64, @bitCast(@as(i64, 4646800021772042240))), .across = @as(f64, @bitCast(@as(i64, 4605380978949069210))), .yaw = (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4588807732320345784)))), .d_ = 1, .center = @as(f64, @bitCast(@as(i64, 4639833516098453504))), .braking = true, .headlights = true }), cx_new(TbCaseS{ .start_ = 2, .along = @as(f64, @bitCast(@as(i64, 4632233691727265792))), .across = (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4607632778762754458)))), .yaw = @as(f64, @bitCast(@as(i64, 4593311331947716280))), .d_ = 2, .center = @as(f64, @bitCast(@as(i64, 4641240890982006784))), .braking = false, .headlights = false }), cx_new(TbCaseS{ .start_ = 0, .along = @as(f64, @bitCast(@as(i64, 4636737291354636288))), .across = @as(f64, @bitCast(@as(i64, 4599075939470750515))), .yaw = @as(f64, @bitCast(@as(i64, 0))), .d_ = 0, .center = @as(f64, @bitCast(@as(i64, 4637792822517301248))), .braking = true, .headlights = true }), cx_new(TbCaseS{ .start_ = 0, .along = @as(f64, @bitCast(@as(i64, 4636737291354636288))), .across = @as(f64, @bitCast(@as(i64, 0))), .yaw = @as(f64, @bitCast(@as(i64, 0))), .d_ = 0, .center = @as(f64, @bitCast(@as(i64, 4636878028842991616))), .braking = true, .headlights = true }) });
}

fn tb_wire_of(w: *CxList(Segment), c_: TbCase) *CxList(DrawCmd) {
    return b0: { const ch = build_chain(w, c_.start_); break :b0 b1: { const hw: f64 = (cx_list_at(w, cx_list_at(ch, c_.d_)).width / @as(f64, @bitCast(@as(i64, 4611686018427387904)))); break :b1 truck_draw_body(w, ch, cx_new(PoseS{ .along = c_.along, .across = c_.across, .yaw = c_.yaw, .hw = (cx_list_at(w, cx_list_at(ch, 0)).width / @as(f64, @bitCast(@as(i64, 4611686018427387904)))) }), c_.d_, c_.center, hw, c_.braking, c_.headlights, focal(), camera_w()); }; };
}

fn tb_wire(w: *CxList(Segment), i_: i64) *CxList(DrawCmd) {
    return (if ((i_ >= cx_list_len(tb_cases()))) cx_ll_empty(DrawCmd) else cx_ll_concat(tb_wire_of(w, cx_list_at(tb_cases(), i_)), tb_wire(w, (i_ +% 1))));
}

fn all_cmds() *CxList(DrawCmd) {
    return tb_wire(build_world(), 0);
}

fn tb_tags(cs: *CxList(DrawCmd), i_: i64) *CxList(i64) {
    return (if ((i_ >= cx_list_len(cs))) cx_ll_empty(i64) else cx_ll_concat(cx_ll_of(i64, &[_]i64{ cx_list_at(cs, i_).tag }), tb_tags(cs, (i_ +% 1))));
}

fn tb_cols(cs: *CxList(DrawCmd), i_: i64) *CxList(i64) {
    return (if ((i_ >= cx_list_len(cs))) cx_ll_empty(i64) else cx_ll_concat(cx_ll_of(i64, &[_]i64{ cx_list_at(cs, i_).color }), tb_cols(cs, (i_ +% 1))));
}

fn tb_cols2(cs: *CxList(DrawCmd), i_: i64) *CxList(i64) {
    return (if ((i_ >= cx_list_len(cs))) cx_ll_empty(i64) else cx_ll_concat(cx_ll_of(i64, &[_]i64{ cx_list_at(cs, i_).color2 }), tb_cols2(cs, (i_ +% 1))));
}

fn tb_counts(cs: *CxList(DrawCmd), i_: i64) *CxList(i64) {
    return (if ((i_ >= cx_list_len(cs))) cx_ll_empty(i64) else cx_ll_concat(cx_ll_of(i64, &[_]i64{ @divTrunc(cx_list_len(cx_list_at(cs, i_).pts), 2) }), tb_counts(cs, (i_ +% 1))));
}

fn tb_geoms(cs: *CxList(DrawCmd), i_: i64) *CxList(f64) {
    return (if ((i_ >= cx_list_len(cs))) cx_ll_empty(f64) else cx_ll_concat(cx_list_at(cs, i_).geom, tb_geoms(cs, (i_ +% 1))));
}

fn tb_coords(cs: *CxList(DrawCmd), i_: i64) *CxList(f64) {
    return (if ((i_ >= cx_list_len(cs))) cx_ll_empty(f64) else cx_ll_concat(cx_list_at(cs, i_).pts, tb_coords(cs, (i_ +% 1))));
}

fn opening() void {
    return b0: { _ = cx_print_line(grade_ints("\x0e\x20\x49\x0e\x0f\x1d\x02\x02", tb_tags(all_cmds(), 0), g_tb_tag())); _ = cx_print_line(grade_ints("\x0e\x20\x49\x18\x10\x17\x02\x02", tb_cols(all_cmds(), 0), g_tb_col())); _ = cx_print_line(grade_ints("\x0e\x20\x49\x18\x10\x17\x05\x02", tb_cols2(all_cmds(), 0), g_tb_col2())); _ = cx_print_line(grade_ints("\x0e\x20\x49\x18\x12\x0e\x02\x02", tb_counts(all_cmds(), 0), g_tb_cnt())); _ = cx_print_line(grade_px("\x0e\x20\x49\x1d\x0d\x10\x1a\x02", tb_geoms(all_cmds(), 0), g_tb_geom(), @as(f64, @bitCast(@as(i64, 4562254508917369340))), @as(f64, @bitCast(@as(i64, 4517329193108106637))))); _ = cx_print_line(grade_px("\x0e\x20\x49\x24\x1e\x02\x02\x02", tb_coords(all_cmds(), 0), g_tb_xy(), @as(f64, @bitCast(@as(i64, 4562254508917369340))), @as(f64, @bitCast(@as(i64, 4534972062662729065))))); break :b0; };
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


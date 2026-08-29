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

const SpeciesS = struct {
    present: bool,
    cp_: i64,
    adult_h: f64,
};
const Species = *SpeciesS;

fn real_abs(x: f64) f64 {
    return (if ((x < @as(f64, @bitCast(@as(i64, 0))))) (@as(f64, @bitCast(@as(i64, 0))) - x) else x);
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

fn to_rider(a_: f64, x: f64, cam_along: f64, cam_across: f64, yaw: f64, hw: f64) RiderPt {
    return b0: { const d_a: f64 = (a_ - cam_along); break :b0 b1: { const d_x: f64 = (x - (cam_across + hw)); break :b1 b2: { const c_: f64 = r_cos(yaw); break :b2 b3: { const s_: f64 = r_sin(yaw); break :b3 cx_new(RiderPtS{ .forward = ((d_a * c_) + (d_x * s_)), .right = (((@as(f64, @bitCast(@as(i64, 0))) - d_a) * s_) + (d_x * c_)) }); }; }; }; };
}

fn next_to_cur(a_b: f64, x_b: f64, seg_len: f64, theta: f64, turns_right: bool, width: f64) AX {
    return b0: { const c_: f64 = r_cos(theta); break :b0 b1: { const s_: f64 = r_sin(theta); break :b1 (if (turns_right) cx_new(AXS{ .a_ = ((((a_b * c_) - (x_b * s_)) + (width * s_)) + seg_len), .x = (((x_b * c_) + (a_b * s_)) + (width * (@as(f64, @bitCast(@as(i64, 4607182418800017408))) - c_))) }) else cx_new(AXS{ .a_ = (((a_b * c_) + (x_b * s_)) + seg_len), .x = ((x_b * c_) - (a_b * s_)) })); }; };
}

fn cur_to_next(a_: f64, x: f64, seg_len: f64, theta: f64, turns_right: bool, width: f64) AX {
    return b0: { const c_: f64 = r_cos(theta); break :b0 b1: { const s_: f64 = r_sin(theta); break :b1 (if (turns_right) b3: { const a0: f64 = ((a_ - seg_len) - (width * s_)); break :b3 b4: { const x0: f64 = (x - (width * (@as(f64, @bitCast(@as(i64, 4607182418800017408))) - c_))); break :b4 cx_new(AXS{ .a_ = ((a0 * c_) + (x0 * s_)), .x = (((@as(f64, @bitCast(@as(i64, 0))) - a0) * s_) + (x0 * c_)) }); }; } else b3: { const a0: f64 = (a_ - seg_len); break :b3 cx_new(AXS{ .a_ = ((a0 * c_) - (x * s_)), .x = ((a0 * s_) + (x * c_)) }); }); }; };
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
    return b0: { const c_ = cx_list_at(route(), i_); break :b0 b1: { const angle: f64 = (real_abs(c_.turn_deg) * deg()); break :b1 b2: { const trees = fill_trees(c_.scheme, c_.length, tree_start_inset(), 0, 0); break :b2 b3: { const distract: bool = (if (c_.pigs) (pig_count_to((i_ +% 1), 0) <= pig_novelty_count()) else false); break :b3 cx_new(SegmentS{ .length = c_.length, .width = lane_width(), .trees = trees, .cows = fill_cows(c_.bull), .pigs = (if (c_.pigs) (if (distract) fill_pig_herd(c_.length) else fill_pig_row(c_.length)) else cx_ll_empty(Critter)), .pigs_distract = distract, .exit_angle = angle, .exit_right = (c_.turn_deg >= @as(f64, @bitCast(@as(i64, 0)))), .exit_to = (if (c_.terminates) i_ else (i_ +% 1)), .commit_along = (if (c_.terminates) c_.length else (c_.length - ((lane_width() / @as(f64, @bitCast(@as(i64, 4611686018427387904)))) / (r_sin(angle) / r_cos(angle))))), .north_heading = heading_at(i_), .has_mid_tower = (c_.length > mid_tower_min_length()), .has_cat = c_.cat, .cat = cat_make((lane_width() / @as(f64, @bitCast(@as(i64, 4611686018427387904)))), tree_road_offset(), next_tree_loop(trees, cat_along(), 0, false, @as(f64, @bitCast(@as(i64, 0))))), .terminates = c_.terminates, .exit_creature = (if (c_.terminates) Creature.NoCreature else c_.creature) }); }; }; }; };
}

fn segments_from(i_: i64) *CxList(Segment) {
    return (if ((i_ >= cx_list_len(route()))) cx_ll_empty(Segment) else cx_ll_concat(cx_ll_of(Segment, &[_]Segment{ segment_at(i_) }), segments_from((i_ +% 1))));
}

fn build_world() *CxList(Segment) {
    return segments_from(0);
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

fn map_pt(_arg_segs: *CxList(Segment), ch: *CxList(i64), pose: Pose, m_: Mapper, a_: f64, x: f64) RiderPt {
    return (if (m_.is_chain) at(_arg_segs, ch, pose, m_.d_, a_, x) else b1: { const p_ = cur_to_next(a_, x, m_.prev_len, m_.prev_angle, m_.prev_right, m_.prev_w); break :b1 to_rider(p_.a_, p_.x, pose.along, pose.across, pose.yaw, pose.hw); });
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

fn tower_beyond() f64 {
    return @as(f64, @bitCast(@as(i64, 4639833516098453504)));
}

fn tower_right() f64 {
    return @as(f64, @bitCast(@as(i64, 4626322717216342016)));
}

fn sample_as(s_: Segment) *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ @as(f64, @bitCast(@as(i64, 0))), (s_.length / @as(f64, @bitCast(@as(i64, 4611686018427387904)))), s_.length, (s_.length + tower_beyond()) });
}

fn sample_xs(s_: Segment) *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ @as(f64, @bitCast(@as(i64, 0))), (s_.width / @as(f64, @bitCast(@as(i64, 4611686018427387904)))), s_.width, ((s_.width / @as(f64, @bitCast(@as(i64, 4611686018427387904)))) + tower_right()) });
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
    return (if ((j >= cx_list_len(xs))) cx_ll_empty(f64) else b1: { const p_ = map_pt(segs(), cx_ll_empty(i64), pose, cx_new(MapperS{ .is_chain = false, .d_ = 0, .prev_len = pv.length, .prev_angle = pv.exit_angle, .prev_right = pv.exit_right, .prev_w = pv.width }), a_, cx_list_at(xs, j)); break :b1 cx_ll_concat(cx_ll_of(f64, &[_]f64{ p_.right, p_.forward }), prev_over_xs(pv, pose, xs, a_, (j +% 1))); });
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

fn opening() void {
    return b0: { _ = cx_print_line(grade_ints("\x15\x49\x18\x14\x0f\x11\x12\x17\x0d\x12", chain_lens(0), g_r_chainlen())); _ = cx_print_line(grade_ints("\x15\x49\x18\x14\x0f\x11\x12\x02\x02\x02", chain_flat(0), g_r_chain())); _ = cx_print_line(grade_px("\x15\x49\x0f\x0e\x02\x02\x02\x02\x02\x02", at_stream(0), g_r_at(), @as(f64, @bitCast(@as(i64, 4553247309662628348))), @as(f64, @bitCast(@as(i64, 4517329193108106637))))); _ = cx_print_line(grade_px("\x15\x49\x1f\x15\x0d\x21\x02\x02\x02\x02", prev_stream(0), g_r_prev(), @as(f64, @bitCast(@as(i64, 4543979261917470057))), @as(f64, @bitCast(@as(i64, 4517329193108106637))))); _ = cx_print_line(grade_ints("\x13\x18\x49\x12\x02\x02\x02\x02\x02\x02", sc_counts(0), g_sc_n())); _ = cx_print_line(grade_ints("\x13\x18\x49\x18\x1f\x02\x02\x02\x02\x02", cr_cps(sc_all(0), 0), g_sc_cp())); _ = cx_print_line(grade_bools("\x13\x18\x49\x1c\x0f\x18\x0d\x02\x02\x02", cr_faces(sc_all(0), 0), g_sc_face())); _ = cx_print_line(grade_rel("\x13\x18\x49\x1f\x17\x0f\x18\x0d\x02\x02", cr_place(sc_all(0), 0), g_sc_place(), @as(f64, @bitCast(@as(i64, 4517329193108106637))))); break :b0; };
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


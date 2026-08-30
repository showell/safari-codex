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

fn r_sin(x: f64) f64 {
    return real_sin(x);
}

fn r_cos(x: f64) f64 {
    return real_cos(x);
}

fn r_tan(x: f64) f64 {
    return (real_sin(x) / real_cos(x));
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

fn g_focal() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ @as(f64, @bitCast(@as(i64, 4649241033463118902))) });
}

fn g_cam_focal() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ @as(f64, @bitCast(@as(i64, 4649241033463118902))), @as(f64, @bitCast(@as(i64, 4648770708128440045))), @as(f64, @bitCast(@as(i64, 4648065219246812457))), @as(f64, @bitCast(@as(i64, 4646534320653026449))), @as(f64, @bitCast(@as(i64, 4646063994262816429))), @as(f64, @bitCast(@as(i64, 4644653016851404974))), @as(f64, @bitCast(@as(i64, 4648996072387957385))), @as(f64, @bitCast(@as(i64, 4648770708128440045))), @as(f64, @bitCast(@as(i64, 4648065219246812457))), @as(f64, @bitCast(@as(i64, 4646534320653026449))), @as(f64, @bitCast(@as(i64, 4646063994262816429))), @as(f64, @bitCast(@as(i64, 4644653016851404974))), @as(f64, @bitCast(@as(i64, 4648261187931019810))), @as(f64, @bitCast(@as(i64, 4648261187931019810))), @as(f64, @bitCast(@as(i64, 4648065219246812457))), @as(f64, @bitCast(@as(i64, 4646534320653026449))), @as(f64, @bitCast(@as(i64, 4646063994262816429))), @as(f64, @bitCast(@as(i64, 4644653016851404974))), @as(f64, @bitCast(@as(i64, 4646357947201166529))), @as(f64, @bitCast(@as(i64, 4646357947201166529))), @as(f64, @bitCast(@as(i64, 4646357947201166529))), @as(f64, @bitCast(@as(i64, 4646357947201166529))), @as(f64, @bitCast(@as(i64, 4646063994262816429))), @as(f64, @bitCast(@as(i64, 4644653016851404974))), @as(f64, @bitCast(@as(i64, 4642645761793798502))), @as(f64, @bitCast(@as(i64, 4642645761793798502))), @as(f64, @bitCast(@as(i64, 4642645761793798502))), @as(f64, @bitCast(@as(i64, 4642645761793798502))), @as(f64, @bitCast(@as(i64, 4642645761793798502))), @as(f64, @bitCast(@as(i64, 4642645761793798502))) });
}

fn g_project() *CxList(f64) {
    @setEvalBranchQuota(1000000);
    return cx_ll_of(f64, &[_]f64{ (-@as(f64, @bitCast(@as(i64, 4678881813939848479)))), @as(f64, @bitCast(@as(i64, 4657400485283491113))), (-@as(f64, @bitCast(@as(i64, 4678881813939848479)))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4678881813939848479)))), (-@as(f64, @bitCast(@as(i64, 4664965808739017818)))), (-@as(f64, @bitCast(@as(i64, 4663731521614736943)))), @as(f64, @bitCast(@as(i64, 4657400485283491113))), (-@as(f64, @bitCast(@as(i64, 4663731521614736943)))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4663731521614736943)))), (-@as(f64, @bitCast(@as(i64, 4664965808739017818)))), @as(f64, @bitCast(@as(i64, 4647151865492930560))), @as(f64, @bitCast(@as(i64, 4657400485283491113))), @as(f64, @bitCast(@as(i64, 4647151865492930560))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4647151865492930560))), (-@as(f64, @bitCast(@as(i64, 4664965808739017818)))), @as(f64, @bitCast(@as(i64, 4661960575619273484))), @as(f64, @bitCast(@as(i64, 4657400485283491113))), @as(f64, @bitCast(@as(i64, 4661960575619273484))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4661960575619273484))), (-@as(f64, @bitCast(@as(i64, 4664965808739017818)))), @as(f64, @bitCast(@as(i64, 4677600517030995296))), @as(f64, @bitCast(@as(i64, 4657400485283491113))), @as(f64, @bitCast(@as(i64, 4677600517030995296))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4677600517030995296))), (-@as(f64, @bitCast(@as(i64, 4664965808739017818)))), (-@as(f64, @bitCast(@as(i64, 4672569249403949285)))), @as(f64, @bitCast(@as(i64, 4652652120513931169))), (-@as(f64, @bitCast(@as(i64, 4672569249403949285)))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4672569249403949285)))), (-@as(f64, @bitCast(@as(i64, 4658417626557867622)))), (-@as(f64, @bitCast(@as(i64, 4657192701775097260)))), @as(f64, @bitCast(@as(i64, 4652652120513931169))), (-@as(f64, @bitCast(@as(i64, 4657192701775097260)))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4657192701775097260)))), (-@as(f64, @bitCast(@as(i64, 4658417626557867622)))), @as(f64, @bitCast(@as(i64, 4647151865492930560))), @as(f64, @bitCast(@as(i64, 4652652120513931169))), @as(f64, @bitCast(@as(i64, 4647151865492930560))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4647151865492930560))), (-@as(f64, @bitCast(@as(i64, 4658417626557867622)))), @as(f64, @bitCast(@as(i64, 4657042582373924445))), @as(f64, @bitCast(@as(i64, 4652652120513931169))), @as(f64, @bitCast(@as(i64, 4657042582373924445))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4657042582373924445))), (-@as(f64, @bitCast(@as(i64, 4658417626557867622)))), @as(f64, @bitCast(@as(i64, 4671702541221412995))), @as(f64, @bitCast(@as(i64, 4652652120513931169))), @as(f64, @bitCast(@as(i64, 4671702541221412995))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4671702541221412995))), (-@as(f64, @bitCast(@as(i64, 4658417626557867622)))), (-@as(f64, @bitCast(@as(i64, 4665490218610862326)))), @as(f64, @bitCast(@as(i64, 4648261970695337856))), (-@as(f64, @bitCast(@as(i64, 4665490218610862326)))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4665490218610862326)))), (-@as(f64, @bitCast(@as(i64, 4649717612380131898)))), (-@as(f64, @bitCast(@as(i64, 4646342881780803672)))), @as(f64, @bitCast(@as(i64, 4648261970695337856))), (-@as(f64, @bitCast(@as(i64, 4646342881780803672)))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4646342881780803672)))), (-@as(f64, @bitCast(@as(i64, 4649717612380131898)))), @as(f64, @bitCast(@as(i64, 4647151865492930560))), @as(f64, @bitCast(@as(i64, 4648261970695337856))), @as(f64, @bitCast(@as(i64, 4647151865492930560))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4647151865492930560))), (-@as(f64, @bitCast(@as(i64, 4649717612380131898)))), @as(f64, @bitCast(@as(i64, 4652338301423568552))), @as(f64, @bitCast(@as(i64, 4648261970695337856))), @as(f64, @bitCast(@as(i64, 4652338301423568552))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4652338301423568552))), (-@as(f64, @bitCast(@as(i64, 4649717612380131898)))), @as(f64, @bitCast(@as(i64, 4665038295142590579))), @as(f64, @bitCast(@as(i64, 4648261970695337856))), @as(f64, @bitCast(@as(i64, 4665038295142590579))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4665038295142590579))), (-@as(f64, @bitCast(@as(i64, 4649717612380131898)))), (-@as(f64, @bitCast(@as(i64, 4658599659503938961)))), @as(f64, @bitCast(@as(i64, 4645914813932534665))), (-@as(f64, @bitCast(@as(i64, 4658599659503938961)))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4658599659503938961)))), (-@as(f64, @bitCast(@as(i64, 4637854511276884597)))), @as(f64, @bitCast(@as(i64, 4637750190669172373))), @as(f64, @bitCast(@as(i64, 4645914813932534665))), @as(f64, @bitCast(@as(i64, 4637750190669172373))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4637750190669172373))), (-@as(f64, @bitCast(@as(i64, 4637854511276884597)))), @as(f64, @bitCast(@as(i64, 4647151865492930560))), @as(f64, @bitCast(@as(i64, 4645914813932534665))), @as(f64, @bitCast(@as(i64, 4647151865492930560))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4647151865492930560))), (-@as(f64, @bitCast(@as(i64, 4637854511276884597)))), @as(f64, @bitCast(@as(i64, 4649443279918916205))), @as(f64, @bitCast(@as(i64, 4645914813932534665))), @as(f64, @bitCast(@as(i64, 4649443279918916205))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4649443279918916205))), (-@as(f64, @bitCast(@as(i64, 4637854511276884597)))), @as(f64, @bitCast(@as(i64, 4659504757684714865))), @as(f64, @bitCast(@as(i64, 4645914813932534665))), @as(f64, @bitCast(@as(i64, 4659504757684714865))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4659504757684714865))), (-@as(f64, @bitCast(@as(i64, 4637854511276884597)))), (-@as(f64, @bitCast(@as(i64, 4650144254117839215)))), @as(f64, @bitCast(@as(i64, 4644708850051863439))), (-@as(f64, @bitCast(@as(i64, 4650144254117839215)))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4650144254117839215)))), @as(f64, @bitCast(@as(i64, 4639272193774085021))), @as(f64, @bitCast(@as(i64, 4644739938611197410))), @as(f64, @bitCast(@as(i64, 4644708850051863439))), @as(f64, @bitCast(@as(i64, 4644739938611197410))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4644739938611197410))), @as(f64, @bitCast(@as(i64, 4639272193774085021))), @as(f64, @bitCast(@as(i64, 4647151865492930560))), @as(f64, @bitCast(@as(i64, 4644708850051863439))), @as(f64, @bitCast(@as(i64, 4647151865492930560))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4647151865492930560))), @as(f64, @bitCast(@as(i64, 4639272193774085021))), @as(f64, @bitCast(@as(i64, 4648187067477246314))), @as(f64, @bitCast(@as(i64, 4644708850051863439))), @as(f64, @bitCast(@as(i64, 4648187067477246314))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4648187067477246314))), @as(f64, @bitCast(@as(i64, 4639272193774085021))), @as(f64, @bitCast(@as(i64, 4654498986467878607))), @as(f64, @bitCast(@as(i64, 4644708850051863439))), @as(f64, @bitCast(@as(i64, 4654498986467878607))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4654498986467878607))), @as(f64, @bitCast(@as(i64, 4639272193774085021))), @as(f64, @bitCast(@as(i64, 4635146839164887142))), @as(f64, @bitCast(@as(i64, 4644214979159460875))), @as(f64, @bitCast(@as(i64, 4635146839164887142))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4635146839164887142))), @as(f64, @bitCast(@as(i64, 4643017380891019350))), @as(f64, @bitCast(@as(i64, 4646386174391440376))), @as(f64, @bitCast(@as(i64, 4644214979159460875))), @as(f64, @bitCast(@as(i64, 4646386174391440376))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4646386174391440376))), @as(f64, @bitCast(@as(i64, 4643017380891019350))), @as(f64, @bitCast(@as(i64, 4647151865492930560))), @as(f64, @bitCast(@as(i64, 4644214979159460875))), @as(f64, @bitCast(@as(i64, 4647151865492930560))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4647151865492930560))), @as(f64, @bitCast(@as(i64, 4643017380891019350))), @as(f64, @bitCast(@as(i64, 4647630422563303320))), @as(f64, @bitCast(@as(i64, 4644214979159460875))), @as(f64, @bitCast(@as(i64, 4647630422563303320))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4647630422563303320))), @as(f64, @bitCast(@as(i64, 4643017380891019350))), @as(f64, @bitCast(@as(i64, 4650400394059661726))), @as(f64, @bitCast(@as(i64, 4644214979159460875))), @as(f64, @bitCast(@as(i64, 4650400394059661726))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4650400394059661726))), @as(f64, @bitCast(@as(i64, 4643017380891019350))), @as(f64, @bitCast(@as(i64, 4644920832903027024))), @as(f64, @bitCast(@as(i64, 4644057629897589386))), @as(f64, @bitCast(@as(i64, 4644920832903027024))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4644920832903027024))), @as(f64, @bitCast(@as(i64, 4643710915354464176))), @as(f64, @bitCast(@as(i64, 4646910673103824408))), @as(f64, @bitCast(@as(i64, 4644057629897589386))), @as(f64, @bitCast(@as(i64, 4646910673103824408))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4646910673103824408))), @as(f64, @bitCast(@as(i64, 4643710915354464176))), @as(f64, @bitCast(@as(i64, 4647151865492930560))), @as(f64, @bitCast(@as(i64, 4644057629897589386))), @as(f64, @bitCast(@as(i64, 4647151865492930560))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4647151865492930560))), @as(f64, @bitCast(@as(i64, 4643710915354464176))), @as(f64, @bitCast(@as(i64, 4647302610824082835))), @as(f64, @bitCast(@as(i64, 4644057629897589386))), @as(f64, @bitCast(@as(i64, 4647302610824082835))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4647302610824082835))), @as(f64, @bitCast(@as(i64, 4643710915354464176))), @as(f64, @bitCast(@as(i64, 4648367962296841509))), @as(f64, @bitCast(@as(i64, 4644057629897589386))), @as(f64, @bitCast(@as(i64, 4648367962296841509))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4648367962296841509))), @as(f64, @bitCast(@as(i64, 4643710915354464176))), @as(f64, @bitCast(@as(i64, 4646656080218842643))), @as(f64, @bitCast(@as(i64, 4644001351262980276))), @as(f64, @bitCast(@as(i64, 4646656080218842643))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4646656080218842643))), @as(f64, @bitCast(@as(i64, 4643924303821292710))), @as(f64, @bitCast(@as(i64, 4647098267027865317))), @as(f64, @bitCast(@as(i64, 4644001351262980276))), @as(f64, @bitCast(@as(i64, 4647098267027865317))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4647098267027865317))), @as(f64, @bitCast(@as(i64, 4643924303821292710))), @as(f64, @bitCast(@as(i64, 4647151865492930560))), @as(f64, @bitCast(@as(i64, 4644001351262980276))), @as(f64, @bitCast(@as(i64, 4647151865492930560))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4647151865492930560))), @as(f64, @bitCast(@as(i64, 4643924303821292710))), @as(f64, @bitCast(@as(i64, 4647185364533596337))), @as(f64, @bitCast(@as(i64, 4644001351262980276))), @as(f64, @bitCast(@as(i64, 4647185364533596337))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4647185364533596337))), @as(f64, @bitCast(@as(i64, 4643924303821292710))), @as(f64, @bitCast(@as(i64, 4647567252717576892))), @as(f64, @bitCast(@as(i64, 4644001351262980276))), @as(f64, @bitCast(@as(i64, 4647567252717576892))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4647567252717576892))), @as(f64, @bitCast(@as(i64, 4643924303821292710))) });
}

fn g_ground_drop() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4566861871480154452))), @as(f64, @bitCast(@as(i64, 4616752568008179712))), @as(f64, @bitCast(@as(i64, 4590598453604180841))), @as(f64, @bitCast(@as(i64, 4621819117588971520))) });
}

fn g_to_rider() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ (-@as(f64, @bitCast(@as(i64, 4609434218613702656)))), @as(f64, @bitCast(@as(i64, 4620693217682128896))), @as(f64, @bitCast(@as(i64, 4617034042984890368))), @as(f64, @bitCast(@as(i64, 4635259547726905344))), (-@as(f64, @bitCast(@as(i64, 4611226465717091466)))), @as(f64, @bitCast(@as(i64, 4620597553682514171))), @as(f64, @bitCast(@as(i64, 4605342334461386669))), @as(f64, @bitCast(@as(i64, 4635269305760660461))), @as(f64, @bitCast(@as(i64, 4608687176819753171))), @as(f64, @bitCast(@as(i64, 4620709727878362836))), @as(f64, @bitCast(@as(i64, 4629574019754153038))), @as(f64, @bitCast(@as(i64, 4634807898608774960))), (-@as(f64, @bitCast(@as(i64, 4619791406084105122)))), @as(f64, @bitCast(@as(i64, 4615734505668514568))), (-@as(f64, @bitCast(@as(i64, 4633490502831026775)))), @as(f64, @bitCast(@as(i64, 4632631695936959776))), @as(f64, @bitCast(@as(i64, 4620275111711793139))), @as(f64, @bitCast(@as(i64, 4613572828062512575))), @as(f64, @bitCast(@as(i64, 4635235472820303561))), @as(f64, @bitCast(@as(i64, 4621113470518407020))), (-@as(f64, @bitCast(@as(i64, 4617974416429543520)))), (-@as(f64, @bitCast(@as(i64, 4618352194241476044)))), (-@as(f64, @bitCast(@as(i64, 4634391661505620822)))), (-@as(f64, @bitCast(@as(i64, 4631199444857914762)))), @as(f64, @bitCast(@as(i64, 4613068508220840186))), (-@as(f64, @bitCast(@as(i64, 4620364747643306629)))), @as(f64, @bitCast(@as(i64, 4618943587241293968))), (-@as(f64, @bitCast(@as(i64, 4635251083774355655)))) });
}

fn g_fusion() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ @as(f64, @bitCast(@as(i64, 4636201664880891721))), @as(f64, @bitCast(@as(i64, 4610188306289269162))), @as(f64, @bitCast(@as(i64, 4624370795213344767))), @as(f64, @bitCast(@as(i64, 4616436318824716287))), @as(f64, @bitCast(@as(i64, 4636212180786021631))), @as(f64, @bitCast(@as(i64, 4617702588838774636))), @as(f64, @bitCast(@as(i64, 4624034290471312294))), (-@as(f64, @bitCast(@as(i64, 4595444187371787031)))), @as(f64, @bitCast(@as(i64, 4636203593336325910))), (-@as(f64, @bitCast(@as(i64, 4609205915385992550)))), @as(f64, @bitCast(@as(i64, 4623528841070558365))), @as(f64, @bitCast(@as(i64, 4620336754731692773))), @as(f64, @bitCast(@as(i64, 4636230996332683576))), @as(f64, @bitCast(@as(i64, 4620990593743223890))), @as(f64, @bitCast(@as(i64, 4622651948001862823))), (-@as(f64, @bitCast(@as(i64, 4614765672176376210)))), @as(f64, @bitCast(@as(i64, 4636087156638241176))), @as(f64, @bitCast(@as(i64, 4618846787659033201))), @as(f64, @bitCast(@as(i64, 4624649908615000820))), (-@as(f64, @bitCast(@as(i64, 4610664758306807345)))), @as(f64, @bitCast(@as(i64, 4636069747410931622))), @as(f64, @bitCast(@as(i64, 4604219469079972967))), @as(f64, @bitCast(@as(i64, 4625201914258377669))), @as(f64, @bitCast(@as(i64, 4618326108829484361))) });
}

fn g_line_meet() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ (-@as(f64, @bitCast(@as(i64, 4616189618054758400)))), @as(f64, @bitCast(@as(i64, 4620603145689581486))), @as(f64, @bitCast(@as(i64, 4592745645967449348))), @as(f64, @bitCast(@as(i64, 4598385668072119827))) });
}

fn g_clip_counts() *CxList(i64) {
    return cx_ll_of(i64, &[_]i64{ 3, 0, 4, 6 });
}

fn g_clip_pts() *CxList(f64) {
    @setEvalBranchQuota(1000000);
    return cx_ll_of(f64, &[_]f64{ (-@as(f64, @bitCast(@as(i64, 4616189618054758400)))), @as(f64, @bitCast(@as(i64, 4617315517961601024))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4616189618054758400))), @as(f64, @bitCast(@as(i64, 4617315517961601024))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4616189618054758400))), @as(f64, @bitCast(@as(i64, 4629137466983448576))), @as(f64, @bitCast(@as(i64, 0))), (-@as(f64, @bitCast(@as(i64, 4609884578126079743)))), @as(f64, @bitCast(@as(i64, 4600877379321698714))), @as(f64, @bitCast(@as(i64, 4608533498688228557))), @as(f64, @bitCast(@as(i64, 4616189618054758400))), @as(f64, @bitCast(@as(i64, 4618441417868443648))), @as(f64, @bitCast(@as(i64, 4611686018427387904))), @as(f64, @bitCast(@as(i64, 4620693217682128896))), @as(f64, @bitCast(@as(i64, 4626322717216342016))), @as(f64, @bitCast(@as(i64, 4613937818241073152))), (-@as(f64, @bitCast(@as(i64, 4613241808085581290)))), @as(f64, @bitCast(@as(i64, 4600877379321698714))), @as(f64, @bitCast(@as(i64, 4608165021822836469))), (-@as(f64, @bitCast(@as(i64, 4616189618054758400)))), @as(f64, @bitCast(@as(i64, 4622945017495814144))), @as(f64, @bitCast(@as(i64, 4607182418800017408))), @as(f64, @bitCast(@as(i64, 4612106355143209088))), @as(f64, @bitCast(@as(i64, 4600877379321698714))), @as(f64, @bitCast(@as(i64, 4610665202361730604))), @as(f64, @bitCast(@as(i64, 4616736483852470521))), @as(f64, @bitCast(@as(i64, 4600877379321698714))), @as(f64, @bitCast(@as(i64, 4610592287282323625))), @as(f64, @bitCast(@as(i64, 4620693217682128896))), @as(f64, @bitCast(@as(i64, 4627730092099895296))), @as(f64, @bitCast(@as(i64, 0))), (-@as(f64, @bitCast(@as(i64, 4621140864789040408)))), @as(f64, @bitCast(@as(i64, 4600877379321698714))), @as(f64, @bitCast(@as(i64, 4616081097741877411))), (-@as(f64, @bitCast(@as(i64, 4621185207793921452)))), @as(f64, @bitCast(@as(i64, 4600877379321698714))), @as(f64, @bitCast(@as(i64, 4616019313984489422))) });
}

fn leans() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4598175219545276416))), @as(f64, @bitCast(@as(i64, 4602678819172646912))), @as(f64, @bitCast(@as(i64, 4604930618986332160))), @as(f64, @bitCast(@as(i64, 4607182418800017408))) });
}

fn attns() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4596373779694328218))), @as(f64, @bitCast(@as(i64, 4602678819172646912))), @as(f64, @bitCast(@as(i64, 4606281698874543309))), @as(f64, @bitCast(@as(i64, 4607182418800017408))), @as(f64, @bitCast(@as(i64, 4608533498688228557))) });
}

fn fwds() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ @as(f64, @bitCast(@as(i64, 4600877379321698714))), @as(f64, @bitCast(@as(i64, 4607182418800017408))), @as(f64, @bitCast(@as(i64, 4613937818241073152))), @as(f64, @bitCast(@as(i64, 4620130267728707584))), @as(f64, @bitCast(@as(i64, 4626322717216342016))), @as(f64, @bitCast(@as(i64, 4634063279075885056))), @as(f64, @bitCast(@as(i64, 4641240890982006784))), @as(f64, @bitCast(@as(i64, 4651127699538968576))) });
}

fn rights() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4630404104378646528)))), (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4616189618054758400)))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4612811918334230528))), @as(f64, @bitCast(@as(i64, 4629418941960159232))) });
}

fn heights() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4608083138725491507))), @as(f64, @bitCast(@as(i64, 4618159942891732992))) });
}

fn yaws() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4587366580439587226))), (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4599976659396224614)))), @as(f64, @bitCast(@as(i64, 4606281698874543309))), (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4608983858650965606)))), @as(f64, @bitCast(@as(i64, 4612136378390124954))), (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4613937818241073152)))) });
}

fn thetas() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ @as(f64, @bitCast(@as(i64, 4594572339843380019))), @as(f64, @bitCast(@as(i64, 4600877379321698714))), (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4598175219545276416)))) });
}

fn cf_inner(l_: f64, j: i64) *CxList(f64) {
    return (if ((j >= cx_list_len(attns()))) cx_ll_empty(f64) else cx_ll_concat(cx_ll_of(f64, &[_]f64{ cam_focal(l_, cx_list_at(attns(), j)) }), cf_inner(l_, (j +% 1))));
}

fn cf_outer(i_: i64) *CxList(f64) {
    return (if ((i_ >= cx_list_len(leans()))) cx_ll_empty(f64) else cx_ll_concat(cf_inner(cx_list_at(leans(), i_), 0), cf_outer((i_ +% 1))));
}

fn pr_h(f: f64, r_: f64, k_: i64) *CxList(f64) {
    return (if ((k_ >= cx_list_len(heights()))) cx_ll_empty(f64) else b1: { const s_ = project(cx_new(Vec3S{ .right = r_, .forward = f, .height = cx_list_at(heights(), k_) }), focal(), camera_w()); break :b1 cx_ll_concat(cx_ll_of(f64, &[_]f64{ s_.x, s_.y }), pr_h(f, r_, (k_ +% 1))); });
}

fn pr_r(f: f64, j: i64) *CxList(f64) {
    return (if ((j >= cx_list_len(rights()))) cx_ll_empty(f64) else cx_ll_concat(pr_h(f, cx_list_at(rights(), j), 0), pr_r(f, (j +% 1))));
}

fn pr_f(i_: i64) *CxList(f64) {
    return (if ((i_ >= cx_list_len(fwds()))) cx_ll_empty(f64) else cx_ll_concat(pr_r(cx_list_at(fwds(), i_), 0), pr_f((i_ +% 1))));
}

fn gd() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ ground_drop(@as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0)))), ground_drop(@as(f64, @bitCast(@as(i64, 4613937818241073152))), @as(f64, @bitCast(@as(i64, 4626322717216342016)))), ground_drop(@as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4651127699538968576)))), ground_drop((@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4638144666238189568)))), @as(f64, @bitCast(@as(i64, 4631600373029666816)))), ground_drop(@as(f64, @bitCast(@as(i64, 4652007308841189376))), @as(f64, @bitCast(@as(i64, 4652007308841189376)))) });
}

fn tr(i_: i64) *CxList(f64) {
    return (if ((i_ >= cx_list_len(yaws()))) cx_ll_empty(f64) else b1: { const y: f64 = cx_list_at(yaws(), i_); break :b1 b2: { const a_ = to_rider(@as(f64, @bitCast(@as(i64, 4621819117588971520))), @as(f64, @bitCast(@as(i64, 4613937818241073152))), @as(f64, @bitCast(@as(i64, 4611686018427387904))), @as(f64, @bitCast(@as(i64, 4602678819172646912))), y, @as(f64, @bitCast(@as(i64, 4616189618054758400)))); break :b2 b3: { const b_ = to_rider(@as(f64, @bitCast(@as(i64, 4639129828656676864))), @as(f64, @bitCast(@as(i64, 4619848792751996928))), @as(f64, @bitCast(@as(i64, 4633781804099174400))), (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4609434218613702656)))), y, @as(f64, @bitCast(@as(i64, 4616189618054758400)))); break :b3 cx_ll_concat(cx_ll_of(f64, &[_]f64{ a_.right, a_.forward, b_.right, b_.forward }), tr((i_ +% 1))); }; }; });
}

fn fu_dir(th: f64, rt: bool) *CxList(f64) {
    return b0: { const f = next_to_cur(@as(f64, @bitCast(@as(i64, 4622945017495814144))), @as(f64, @bitCast(@as(i64, 4615063718147915776))), @as(f64, @bitCast(@as(i64, 4635329916471083008))), th, rt, @as(f64, @bitCast(@as(i64, 4620693217682128896)))); break :b0 b1: { const b_ = cur_to_next(@as(f64, @bitCast(@as(i64, 4636385447633747968))), @as(f64, @bitCast(@as(i64, 4611686018427387904))), @as(f64, @bitCast(@as(i64, 4635329916471083008))), th, rt, @as(f64, @bitCast(@as(i64, 4620693217682128896)))); break :b1 cx_ll_of(f64, &[_]f64{ f.a_, f.x, b_.a_, b_.x }); }; };
}

fn fu(i_: i64) *CxList(f64) {
    return (if ((i_ >= cx_list_len(thetas()))) cx_ll_empty(f64) else b1: { const th: f64 = cx_list_at(thetas(), i_); break :b1 cx_ll_concat(cx_ll_concat(fu_dir(th, false), fu_dir(th, true)), fu((i_ +% 1))); });
}

fn lm() *CxList(f64) {
    return b0: { const m_ = line_meet(cx_new(RiderPtS{ .right = (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4616189618054758400)))), .forward = @as(f64, @bitCast(@as(i64, 0))) }), cx_new(RiderPtS{ .right = (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4616189618054758400)))), .forward = @as(f64, @bitCast(@as(i64, 4621819117588971520))) }), cx_new(RiderPtS{ .right = (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4626322717216342016)))), .forward = @as(f64, @bitCast(@as(i64, 4618441417868443648))) }), cx_new(RiderPtS{ .right = @as(f64, @bitCast(@as(i64, 4617315517961601024))), .forward = @as(f64, @bitCast(@as(i64, 4621256167635550208))) })); break :b0 b1: { const m2 = line_meet(cx_new(RiderPtS{ .right = @as(f64, @bitCast(@as(i64, 0))), .forward = @as(f64, @bitCast(@as(i64, 0))) }), cx_new(RiderPtS{ .right = @as(f64, @bitCast(@as(i64, 4613937818241073152))), .forward = @as(f64, @bitCast(@as(i64, 4619567317775286272))) }), cx_new(RiderPtS{ .right = (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4620693217682128896)))), .forward = @as(f64, @bitCast(@as(i64, 4611686018427387904))) }), cx_new(RiderPtS{ .right = @as(f64, @bitCast(@as(i64, 4618441417868443648))), .forward = (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4607182418800017408)))) })); break :b1 cx_ll_of(f64, &[_]f64{ m_.right, m_.forward, m2.right, m2.forward }); }; };
}

fn poly_a() *CxList(Vec3) {
    return cx_ll_of(Vec3, &[_]Vec3{ cx_new(Vec3S{ .right = (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4616189618054758400)))), .forward = @as(f64, @bitCast(@as(i64, 4617315517961601024))), .height = @as(f64, @bitCast(@as(i64, 0))) }), cx_new(Vec3S{ .right = @as(f64, @bitCast(@as(i64, 4616189618054758400))), .forward = @as(f64, @bitCast(@as(i64, 4617315517961601024))), .height = @as(f64, @bitCast(@as(i64, 0))) }), cx_new(Vec3S{ .right = @as(f64, @bitCast(@as(i64, 4616189618054758400))), .forward = @as(f64, @bitCast(@as(i64, 4629137466983448576))), .height = @as(f64, @bitCast(@as(i64, 0))) }) });
}

fn poly_b() *CxList(Vec3) {
    return cx_ll_of(Vec3, &[_]Vec3{ cx_new(Vec3S{ .right = (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4616189618054758400)))), .forward = (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4617315517961601024)))), .height = @as(f64, @bitCast(@as(i64, 0))) }), cx_new(Vec3S{ .right = @as(f64, @bitCast(@as(i64, 4616189618054758400))), .forward = (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4617315517961601024)))), .height = @as(f64, @bitCast(@as(i64, 0))) }), cx_new(Vec3S{ .right = @as(f64, @bitCast(@as(i64, 4616189618054758400))), .forward = (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4607182418800017408)))), .height = @as(f64, @bitCast(@as(i64, 0))) }) });
}

fn poly_c() *CxList(Vec3) {
    return cx_ll_of(Vec3, &[_]Vec3{ cx_new(Vec3S{ .right = (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4616189618054758400)))), .forward = (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4611686018427387904)))), .height = @as(f64, @bitCast(@as(i64, 4607182418800017408))) }), cx_new(Vec3S{ .right = @as(f64, @bitCast(@as(i64, 4616189618054758400))), .forward = @as(f64, @bitCast(@as(i64, 4618441417868443648))), .height = @as(f64, @bitCast(@as(i64, 4611686018427387904))) }), cx_new(Vec3S{ .right = @as(f64, @bitCast(@as(i64, 4620693217682128896))), .forward = @as(f64, @bitCast(@as(i64, 4626322717216342016))), .height = @as(f64, @bitCast(@as(i64, 4613937818241073152))) }) });
}

fn poly_d() *CxList(Vec3) {
    return cx_ll_of(Vec3, &[_]Vec3{ cx_new(Vec3S{ .right = (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4616189618054758400)))), .forward = @as(f64, @bitCast(@as(i64, 4622945017495814144))), .height = @as(f64, @bitCast(@as(i64, 4607182418800017408))) }), cx_new(Vec3S{ .right = @as(f64, @bitCast(@as(i64, 4616189618054758400))), .forward = (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4613937818241073152)))), .height = @as(f64, @bitCast(@as(i64, 4611686018427387904))) }), cx_new(Vec3S{ .right = @as(f64, @bitCast(@as(i64, 4620693217682128896))), .forward = @as(f64, @bitCast(@as(i64, 4627730092099895296))), .height = @as(f64, @bitCast(@as(i64, 0))) }), cx_new(Vec3S{ .right = (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4621256167635550208)))), .forward = @as(f64, @bitCast(@as(i64, 4591870180066957722))), .height = @as(f64, @bitCast(@as(i64, 4616189618054758400))) }) });
}

fn clipped(poly: *CxList(Vec3), i_: i64) *CxList(f64) {
    return b0: { const cl = clip_near(poly, near()); break :b0 (if ((i_ >= cx_list_len(cl))) cx_ll_empty(f64) else b2: { const v_ = cx_list_at(cl, i_); break :b2 cx_ll_concat(cx_ll_of(f64, &[_]f64{ v_.right, v_.forward, v_.height }), clipped(poly, (i_ +% 1))); }); };
}

fn clip_count(poly: *CxList(Vec3)) i64 {
    return cx_list_len(clip_near(poly, near()));
}

fn opening() void {
    return b0: { _ = cx_print_line(grade_rel("\x1c\x10\x18\x0f\x17\x02\x02\x02\x02\x02\x02", cx_ll_of(f64, &[_]f64{ focal() }), g_focal(), @as(f64, @bitCast(@as(i64, 4517329193108106637))))); _ = cx_print_line(grade_rel("\x18\x0f\x1a\x49\x1c\x10\x18\x0f\x17\x02\x02", cf_outer(0), g_cam_focal(), @as(f64, @bitCast(@as(i64, 4517329193108106637))))); _ = cx_print_line(grade_px("\x1f\x15\x10\x23\x0d\x18\x0e\x02\x02\x02\x02", pr_f(0), g_project(), @as(f64, @bitCast(@as(i64, 4562254508917369340))), @as(f64, @bitCast(@as(i64, 4517329193108106637))))); _ = cx_print_line(grade_rel("\x1d\x15\x10\x19\x12\x16\x49\x16\x15\x10\x1f", gd(), g_ground_drop(), @as(f64, @bitCast(@as(i64, 4517329193108106637))))); _ = cx_print_line(grade_rel("\x0e\x10\x49\x15\x11\x16\x0d\x15\x02\x02\x02", tr(0), g_to_rider(), @as(f64, @bitCast(@as(i64, 4517329193108106637))))); _ = cx_print_line(grade_rel("\x1c\x19\x13\x11\x10\x12\x02\x02\x02\x02\x02", fu(0), g_fusion(), @as(f64, @bitCast(@as(i64, 4517329193108106637))))); _ = cx_print_line(grade_rel("\x17\x11\x12\x0d\x49\x1a\x0d\x0d\x0e\x02\x02", lm(), g_line_meet(), @as(f64, @bitCast(@as(i64, 4517329193108106637))))); _ = cx_print_line(grade_ints("\x18\x17\x11\x1f\x49\x18\x10\x19\x12\x0e\x02", cx_ll_of(i64, &[_]i64{ clip_count(poly_a()), clip_count(poly_b()), clip_count(poly_c()), clip_count(poly_d()) }), g_clip_counts())); _ = cx_print_line(grade_rel("\x18\x17\x11\x1f\x49\x1f\x0e\x13\x02\x02\x02", cx_ll_concat(cx_ll_concat(cx_ll_concat(clipped(poly_a(), 0), clipped(poly_b(), 0)), clipped(poly_c(), 0)), clipped(poly_d(), 0)), g_clip_pts(), @as(f64, @bitCast(@as(i64, 4517329193108106637))))); break :b0; };
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


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

fn camera_w() f64 {
    return @as(f64, @bitCast(@as(i64, 4651655465120301056)));
}

fn camera_h() f64 {
    return @as(f64, @bitCast(@as(i64, 4648488871632306176)));
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

fn flatten_screen(ps: *CxList(ScreenPt), i_: i64) *CxList(f64) {
    return (if ((i_ >= cx_list_len(ps))) cx_ll_empty(f64) else b1: { const p_ = cx_list_at(ps, i_); break :b1 cx_ll_concat(cx_ll_of(f64, &[_]f64{ p_.x, p_.y }), flatten_screen(ps, (i_ +% 1))); });
}

fn push_poly(color: i64, ps: *CxList(ScreenPt)) *CxList(DrawCmd) {
    return (if ((cx_list_len(ps) < 3)) cx_ll_empty(DrawCmd) else cx_ll_of(DrawCmd, &[_]DrawCmd{ cx_new(DrawCmdS{ .tag = 0, .color = color, .strength = @as(f64, @bitCast(@as(i64, 0))), .pts = flatten_screen(ps, 0) }) }));
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

fn sun_height_px(step: f64) f64 {
    return (sun_start_px() - (sun_drop_px_per_step() * step));
}

fn round_real(x: f64) f64 {
    return (if ((x < @as(f64, @bitCast(@as(i64, 0))))) (@as(f64, @bitCast(@as(i64, 0))) - cx_real_from_int(cx_real_to_int((@as(f64, @bitCast(@as(i64, 4602678819172646912))) - x)))) else cx_real_from_int(cx_real_to_int((x + @as(f64, @bitCast(@as(i64, 4602678819172646912)))))));
}

fn lerp3(a_: Rgb, b_: Rgb, t: f64) Rgb {
    return cx_new(RgbS{ .r_ = round_real((a_.r_ + ((b_.r_ - a_.r_) * t))), .g = round_real((a_.g + ((b_.g - a_.g) * t))), .b_ = round_real((a_.b_ + ((b_.b_ - a_.b_) * t))) });
}

fn pack(c_: Rgb) i64 {
    return ((cx_shl(cx_real_to_int(c_.r_), 16) | cx_shl(cx_real_to_int(c_.g), 8)) | cx_real_to_int(c_.b_));
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

fn horizon_crest_px(bearing: f64) f64 {
    return real_max(west_range(bearing), real_max(north_range(bearing), ground_base(bearing)));
}

fn sun_behind_mountains(step: f64) bool {
    return ((sun_height_px(step) + sun_radius_px()) < horizon_crest_px(sun_bearing()));
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

fn g_mt_crest() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ @as(f64, @bitCast(@as(i64, 4639093491996402123))), @as(f64, @bitCast(@as(i64, 4636368874387119245))), @as(f64, @bitCast(@as(i64, 4633847728634944779))), @as(f64, @bitCast(@as(i64, 4632638186749922724))), @as(f64, @bitCast(@as(i64, 4627061381864624629))), @as(f64, @bitCast(@as(i64, 4628696361354995819))), @as(f64, @bitCast(@as(i64, 4627005070543733849))), @as(f64, @bitCast(@as(i64, 4628665847215720571))), @as(f64, @bitCast(@as(i64, 4637523577980172391))), @as(f64, @bitCast(@as(i64, 4627953004800326416))), @as(f64, @bitCast(@as(i64, 4628258187006950527))), @as(f64, @bitCast(@as(i64, 4622598023870249525))), @as(f64, @bitCast(@as(i64, 4627966584560577822))), @as(f64, @bitCast(@as(i64, 4631196937056609758))), @as(f64, @bitCast(@as(i64, 4618526657948950852))), @as(f64, @bitCast(@as(i64, 4621476690894904032))), @as(f64, @bitCast(@as(i64, 4618442669869140057))), @as(f64, @bitCast(@as(i64, 4620923652238362655))), @as(f64, @bitCast(@as(i64, 4625394316478708237))), @as(f64, @bitCast(@as(i64, 4629254462901943290))) });
}

fn g_mt_rock() *CxList(i64) {
    return cx_ll_of(i64, &[_]i64{ 3752799, 3555418, 3291987, 2830919, 2370107, 2041140, 1909296 });
}

fn g_mt_sun_behind() *CxList(bool) {
    return cx_ll_of(bool, &[_]bool{ false, false, false, false, false, true, true, true });
}

fn g_mt_tags() *CxList(i64) {
    return cx_ll_of(i64, &[_]i64{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 });
}

fn g_mt_colors() *CxList(i64) {
    return cx_ll_of(i64, &[_]i64{ 3752799, 5991055, 15660024, 4886339, 3094350, 4937590, 4886339, 2633539, 4213348, 9016482, 4886339, 1909296, 3028296, 4609128, 4886339 });
}

fn g_mt_counts() *CxList(i64) {
    return cx_ll_of(i64, &[_]i64{ 683, 683, 88, 683, 683, 683, 683, 683, 683, 62, 683, 683, 683, 88, 683 });
}

fn g_mt_coords() *CxList(f64) {
    @setEvalBranchQuota(1000000);
    return cx_ll_of(f64, &[_]f64{ (-@as(f64, @bitCast(@as(i64, 4641240890982006784)))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4640677941028585472)))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4640114991075164160)))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4639552041121742848)))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4638989091168321536)))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4638144666238189568)))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4637018766331346944)))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4635892866424504320)))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4634766966517661696)))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4633078116657397760)))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4630826316843712512)))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4627448617123184640)))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4620693217682128896)))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4620693217682128896))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4627448617123184640))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4630826316843712512))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4633078116657397760))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4634766966517661696))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4635892866424504320))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4637018766331346944))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4638144666238189568))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4638989091168321536))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4639552041121742848))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4640114991075164160))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4640677941028585472))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4641240890982006784))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4641803840935428096))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4642366790888849408))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4642929740842270720))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4643351953307336704))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4643633428284047360))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4643914903260758016))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4644196378237468672))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4644477853214179328))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4644759328190889984))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4645040803167600640))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4645322278144311296))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4645603753121021952))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4645885228097732608))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4646166703074443264))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4646448178051153920))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4646729653027864576))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4647011128004575232))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4647292602981285888))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4647574077957996544))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4647785184190529536))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4647925921678884864))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4648066659167240192))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4648207396655595520))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4648348134143950848))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4648488871632306176))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4648629609120661504))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4648770346609016832))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4648911084097372160))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4649051821585727488))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4649192559074082816))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4649333296562438144))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4649474034050793472))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4649614771539148800))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4649755509027504128))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4649896246515859456))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4650036984004214784))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4650177721492570112))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4650318458980925440))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4650459196469280768))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4650599933957636096))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4650740671445991424))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4650881408934346752))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4651022146422702080))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4651162883911057408))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4651303621399412736))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4651444358887768064))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4651585096376123392))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4651725833864478720))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4651866571352834048))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4652007308841189376))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4652148046329544704))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4652253599445811200))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4652323968189988864))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4652394336934166528))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4652464705678344192))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4652535074422521856))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4652605443166699520))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4652675811910877184))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4652746180655054848))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4652816549399232512))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4641240890982006784)))), @as(f64, @bitCast(@as(i64, 4643486306943220234))), (-@as(f64, @bitCast(@as(i64, 4640677941028585472)))), @as(f64, @bitCast(@as(i64, 4643440775375065658))), (-@as(f64, @bitCast(@as(i64, 4640114991075164160)))), @as(f64, @bitCast(@as(i64, 4643387480199287821))), (-@as(f64, @bitCast(@as(i64, 4639552041121742848)))), @as(f64, @bitCast(@as(i64, 4643326403120013236))), (-@as(f64, @bitCast(@as(i64, 4638989091168321536)))), @as(f64, @bitCast(@as(i64, 4643258416885591567))), (-@as(f64, @bitCast(@as(i64, 4638144666238189568)))), @as(f64, @bitCast(@as(i64, 4643159705898243326))), (-@as(f64, @bitCast(@as(i64, 4637018766331346944)))), @as(f64, @bitCast(@as(i64, 4643010042838376503))), (-@as(f64, @bitCast(@as(i64, 4635892866424504320)))), @as(f64, @bitCast(@as(i64, 4642865072670058889))), (-@as(f64, @bitCast(@as(i64, 4634766966517661696)))), @as(f64, @bitCast(@as(i64, 4642735113210405532))), (-@as(f64, @bitCast(@as(i64, 4633078116657397760)))), @as(f64, @bitCast(@as(i64, 4642631629287061581))), (-@as(f64, @bitCast(@as(i64, 4630826316843712512)))), @as(f64, @bitCast(@as(i64, 4642566100505108456))), (-@as(f64, @bitCast(@as(i64, 4627448617123184640)))), @as(f64, @bitCast(@as(i64, 4642548568836184033))), (-@as(f64, @bitCast(@as(i64, 4620693217682128896)))), @as(f64, @bitCast(@as(i64, 4642585950120466092))), @as(f64, @bitCast(@as(i64, 4620693217682128896))), @as(f64, @bitCast(@as(i64, 4642680327272782291))), @as(f64, @bitCast(@as(i64, 4627448617123184640))), @as(f64, @bitCast(@as(i64, 4642827479927700576))), @as(f64, @bitCast(@as(i64, 4630826316843712512))), @as(f64, @bitCast(@as(i64, 4643015994978602771))), @as(f64, @bitCast(@as(i64, 4633078116657397760))), @as(f64, @bitCast(@as(i64, 4643219245772301350))), @as(f64, @bitCast(@as(i64, 4634766966517661696))), @as(f64, @bitCast(@as(i64, 4643323974694651665))), @as(f64, @bitCast(@as(i64, 4635892866424504320))), @as(f64, @bitCast(@as(i64, 4643413753601379575))), @as(f64, @bitCast(@as(i64, 4637018766331346944))), @as(f64, @bitCast(@as(i64, 4643474658453152785))), @as(f64, @bitCast(@as(i64, 4638144666238189568))), @as(f64, @bitCast(@as(i64, 4643495166895877784))), @as(f64, @bitCast(@as(i64, 4638989091168321536))), @as(f64, @bitCast(@as(i64, 4643468512095192587))), @as(f64, @bitCast(@as(i64, 4639552041121742848))), @as(f64, @bitCast(@as(i64, 4643394660801865570))), @as(f64, @bitCast(@as(i64, 4640114991075164160))), @as(f64, @bitCast(@as(i64, 4643281367123739531))), @as(f64, @bitCast(@as(i64, 4640677941028585472))), @as(f64, @bitCast(@as(i64, 4643076485358472774))), @as(f64, @bitCast(@as(i64, 4641240890982006784))), @as(f64, @bitCast(@as(i64, 4642794435820965908))), @as(f64, @bitCast(@as(i64, 4641803840935428096))), @as(f64, @bitCast(@as(i64, 4642550638732794019))), @as(f64, @bitCast(@as(i64, 4642366790888849408))), @as(f64, @bitCast(@as(i64, 4642384814787139354))), @as(f64, @bitCast(@as(i64, 4642929740842270720))), @as(f64, @bitCast(@as(i64, 4642321271811146923))), @as(f64, @bitCast(@as(i64, 4643351953307336704))), @as(f64, @bitCast(@as(i64, 4642360915450554294))), @as(f64, @bitCast(@as(i64, 4643633428284047360))), @as(f64, @bitCast(@as(i64, 4642477547421904121))), @as(f64, @bitCast(@as(i64, 4643914903260758016))), @as(f64, @bitCast(@as(i64, 4642620296400811768))), @as(f64, @bitCast(@as(i64, 4644196378237468672))), @as(f64, @bitCast(@as(i64, 4642722709311869336))), @as(f64, @bitCast(@as(i64, 4644477853214179328))), @as(f64, @bitCast(@as(i64, 4642717318714221606))), @as(f64, @bitCast(@as(i64, 4644759328190889984))), @as(f64, @bitCast(@as(i64, 4642552719184715632))), @as(f64, @bitCast(@as(i64, 4645040803167600640))), @as(f64, @bitCast(@as(i64, 4642208946758784490))), @as(f64, @bitCast(@as(i64, 4645322278144311296))), @as(f64, @bitCast(@as(i64, 4641706719753932689))), @as(f64, @bitCast(@as(i64, 4645603753121021952))), @as(f64, @bitCast(@as(i64, 4641107216404504568))), @as(f64, @bitCast(@as(i64, 4645885228097732608))), @as(f64, @bitCast(@as(i64, 4640501316888074419))), @as(f64, @bitCast(@as(i64, 4646166703074443264))), @as(f64, @bitCast(@as(i64, 4639990186477865539))), @as(f64, @bitCast(@as(i64, 4646448178051153920))), @as(f64, @bitCast(@as(i64, 4639661743882853501))), @as(f64, @bitCast(@as(i64, 4646729653027864576))), @as(f64, @bitCast(@as(i64, 4639569186114418015))), @as(f64, @bitCast(@as(i64, 4647011128004575232))), @as(f64, @bitCast(@as(i64, 4639717545593298947))), @as(f64, @bitCast(@as(i64, 4647292602981285888))), @as(f64, @bitCast(@as(i64, 4640062267293589045))), @as(f64, @bitCast(@as(i64, 4647574077957996544))), @as(f64, @bitCast(@as(i64, 4640520488500581903))), @as(f64, @bitCast(@as(i64, 4647785184190529536))), @as(f64, @bitCast(@as(i64, 4640992043880908985))), @as(f64, @bitCast(@as(i64, 4647925921678884864))), @as(f64, @bitCast(@as(i64, 4641384459404940379))), @as(f64, @bitCast(@as(i64, 4648066659167240192))), @as(f64, @bitCast(@as(i64, 4641635105482983080))), @as(f64, @bitCast(@as(i64, 4648207396655595520))), @as(f64, @bitCast(@as(i64, 4641724681375884037))), @as(f64, @bitCast(@as(i64, 4648348134143950848))), @as(f64, @bitCast(@as(i64, 4641678843527770428))), @as(f64, @bitCast(@as(i64, 4648488871632306176))), @as(f64, @bitCast(@as(i64, 4641558249796123398))), @as(f64, @bitCast(@as(i64, 4648629609120661504))), @as(f64, @bitCast(@as(i64, 4641440446888870454))), @as(f64, @bitCast(@as(i64, 4648770346609016832))), @as(f64, @bitCast(@as(i64, 4641398939181429817))), @as(f64, @bitCast(@as(i64, 4648911084097372160))), @as(f64, @bitCast(@as(i64, 4641485030765962818))), @as(f64, @bitCast(@as(i64, 4649051821585727488))), @as(f64, @bitCast(@as(i64, 4641716726189354752))), @as(f64, @bitCast(@as(i64, 4649192559074082816))), @as(f64, @bitCast(@as(i64, 4642076651760511877))), @as(f64, @bitCast(@as(i64, 4649333296562438144))), @as(f64, @bitCast(@as(i64, 4642518441513895529))), @as(f64, @bitCast(@as(i64, 4649474034050793472))), @as(f64, @bitCast(@as(i64, 4642979017610912292))), @as(f64, @bitCast(@as(i64, 4649614771539148800))), @as(f64, @bitCast(@as(i64, 4643302185013017051))), @as(f64, @bitCast(@as(i64, 4649755509027504128))), @as(f64, @bitCast(@as(i64, 4643458972556388142))), @as(f64, @bitCast(@as(i64, 4649896246515859456))), @as(f64, @bitCast(@as(i64, 4643548607559034208))), @as(f64, @bitCast(@as(i64, 4650036984004214784))), @as(f64, @bitCast(@as(i64, 4643566381648282324))), @as(f64, @bitCast(@as(i64, 4650177721492570112))), @as(f64, @bitCast(@as(i64, 4643519108981474932))), @as(f64, @bitCast(@as(i64, 4650318458980925440))), @as(f64, @bitCast(@as(i64, 4643422457863190631))), @as(f64, @bitCast(@as(i64, 4650459196469280768))), @as(f64, @bitCast(@as(i64, 4643297127259529282))), @as(f64, @bitCast(@as(i64, 4650599933957636096))), @as(f64, @bitCast(@as(i64, 4643118425833690104))), @as(f64, @bitCast(@as(i64, 4650740671445991424))), @as(f64, @bitCast(@as(i64, 4642878326974868472))), @as(f64, @bitCast(@as(i64, 4650881408934346752))), @as(f64, @bitCast(@as(i64, 4642691431812457248))), @as(f64, @bitCast(@as(i64, 4651022146422702080))), @as(f64, @bitCast(@as(i64, 4642574303389617247))), @as(f64, @bitCast(@as(i64, 4651162883911057408))), @as(f64, @bitCast(@as(i64, 4642531362270857711))), @as(f64, @bitCast(@as(i64, 4651303621399412736))), @as(f64, @bitCast(@as(i64, 4642556683056075160))), @as(f64, @bitCast(@as(i64, 4651444358887768064))), @as(f64, @bitCast(@as(i64, 4642636915387124207))), @as(f64, @bitCast(@as(i64, 4651585096376123392))), @as(f64, @bitCast(@as(i64, 4642754613444948326))), @as(f64, @bitCast(@as(i64, 4651725833864478720))), @as(f64, @bitCast(@as(i64, 4642891393395131102))), @as(f64, @bitCast(@as(i64, 4651866571352834048))), @as(f64, @bitCast(@as(i64, 4643030502550746159))), @as(f64, @bitCast(@as(i64, 4652007308841189376))), @as(f64, @bitCast(@as(i64, 4643158587387054622))), @as(f64, @bitCast(@as(i64, 4652148046329544704))), @as(f64, @bitCast(@as(i64, 4643238915595517611))), @as(f64, @bitCast(@as(i64, 4652253599445811200))), @as(f64, @bitCast(@as(i64, 4643280624029801015))), @as(f64, @bitCast(@as(i64, 4652323968189988864))), @as(f64, @bitCast(@as(i64, 4643309782550404053))), @as(f64, @bitCast(@as(i64, 4652394336934166528))), @as(f64, @bitCast(@as(i64, 4643327767218119120))), @as(f64, @bitCast(@as(i64, 4652464705678344192))), @as(f64, @bitCast(@as(i64, 4643337077706661267))), @as(f64, @bitCast(@as(i64, 4652535074422521856))), @as(f64, @bitCast(@as(i64, 4643340820972007798))), @as(f64, @bitCast(@as(i64, 4652605443166699520))), @as(f64, @bitCast(@as(i64, 4643342247698296000))), @as(f64, @bitCast(@as(i64, 4652675811910877184))), @as(f64, @bitCast(@as(i64, 4643344380750853885))), @as(f64, @bitCast(@as(i64, 4652746180655054848))), @as(f64, @bitCast(@as(i64, 4643349747247206734))), @as(f64, @bitCast(@as(i64, 4652816549399232512))), @as(f64, @bitCast(@as(i64, 4643360218995949673))), @as(f64, @bitCast(@as(i64, 4645955596841910272))), @as(f64, @bitCast(@as(i64, 4640360805987075343))), @as(f64, @bitCast(@as(i64, 4646237071818620928))), @as(f64, @bitCast(@as(i64, 4639888136317684207))), @as(f64, @bitCast(@as(i64, 4646518546795331584))), @as(f64, @bitCast(@as(i64, 4639615412749843206))), @as(f64, @bitCast(@as(i64, 4646800021772042240))), @as(f64, @bitCast(@as(i64, 4639584627479796641))), @as(f64, @bitCast(@as(i64, 4647081496748752896))), @as(f64, @bitCast(@as(i64, 4639788033964341713))), @as(f64, @bitCast(@as(i64, 4647362971725463552))), @as(f64, @bitCast(@as(i64, 4640169988119019934))), @as(f64, @bitCast(@as(i64, 4647327787353374720))), @as(f64, @bitCast(@as(i64, 4640515883218119195))), @as(f64, @bitCast(@as(i64, 4647046312376664064))), @as(f64, @bitCast(@as(i64, 4640670507626294264))), @as(f64, @bitCast(@as(i64, 4646764837399953408))), @as(f64, @bitCast(@as(i64, 4640745385951442554))), @as(f64, @bitCast(@as(i64, 4646483362423242752))), @as(f64, @bitCast(@as(i64, 4640719195408547069))), @as(f64, @bitCast(@as(i64, 4646201887446532096))), @as(f64, @bitCast(@as(i64, 4640591357566530670))), (-@as(f64, @bitCast(@as(i64, 4641240890982006784)))), @as(f64, @bitCast(@as(i64, 4643472101252989368))), (-@as(f64, @bitCast(@as(i64, 4640677941028585472)))), @as(f64, @bitCast(@as(i64, 4643471286382931791))), (-@as(f64, @bitCast(@as(i64, 4640114991075164160)))), @as(f64, @bitCast(@as(i64, 4643470475383155143))), (-@as(f64, @bitCast(@as(i64, 4639552041121742848)))), @as(f64, @bitCast(@as(i64, 4643469670364721751))), (-@as(f64, @bitCast(@as(i64, 4638989091168321536)))), @as(f64, @bitCast(@as(i64, 4643468872031319055))), (-@as(f64, @bitCast(@as(i64, 4638144666238189568)))), @as(f64, @bitCast(@as(i64, 4643468082845853103))), (-@as(f64, @bitCast(@as(i64, 4637018766331346944)))), @as(f64, @bitCast(@as(i64, 4643467303512011335))), (-@as(f64, @bitCast(@as(i64, 4635892866424504320)))), @as(f64, @bitCast(@as(i64, 4643466535437168636))), (-@as(f64, @bitCast(@as(i64, 4634766966517661696)))), @as(f64, @bitCast(@as(i64, 4643465782315684075))), (-@as(f64, @bitCast(@as(i64, 4633078116657397760)))), @as(f64, @bitCast(@as(i64, 4643465044675323232))), (-@as(f64, @bitCast(@as(i64, 4630826316843712512)))), @as(f64, @bitCast(@as(i64, 4643464325154914016))), (-@as(f64, @bitCast(@as(i64, 4627448617123184640)))), @as(f64, @bitCast(@as(i64, 4643463626217362471))), (-@as(f64, @bitCast(@as(i64, 4620693217682128896)))), @as(f64, @bitCast(@as(i64, 4643462949797809063))), @as(f64, @bitCast(@as(i64, 4620693217682128896))), @as(f64, @bitCast(@as(i64, 4643462299062847280))), @as(f64, @bitCast(@as(i64, 4627448617123184640))), @as(f64, @bitCast(@as(i64, 4643461676299461308))), @as(f64, @bitCast(@as(i64, 4630826316843712512))), @as(f64, @bitCast(@as(i64, 4643461084146479053))), @as(f64, @bitCast(@as(i64, 4633078116657397760))), @as(f64, @bitCast(@as(i64, 4643460525770494003))), @as(f64, @bitCast(@as(i64, 4634766966517661696))), @as(f64, @bitCast(@as(i64, 4643460003986255926))), @as(f64, @bitCast(@as(i64, 4635892866424504320))), @as(f64, @bitCast(@as(i64, 4643459522488123890))), @as(f64, @bitCast(@as(i64, 4637018766331346944))), @as(f64, @bitCast(@as(i64, 4643459083739003942))), @as(f64, @bitCast(@as(i64, 4638144666238189568))), @as(f64, @bitCast(@as(i64, 4643458691257333291))), @as(f64, @bitCast(@as(i64, 4638989091168321536))), @as(f64, @bitCast(@as(i64, 4643458349089314728))), @as(f64, @bitCast(@as(i64, 4639552041121742848))), @as(f64, @bitCast(@as(i64, 4643458060577463599))), @as(f64, @bitCast(@as(i64, 4640114991075164160))), @as(f64, @bitCast(@as(i64, 4643457828008764092))), @as(f64, @bitCast(@as(i64, 4640677941028585472))), @as(f64, @bitCast(@as(i64, 4643457655957184578))), @as(f64, @bitCast(@as(i64, 4641240890982006784))), @as(f64, @bitCast(@as(i64, 4643457547765240404))), @as(f64, @bitCast(@as(i64, 4641803840935428096))), @as(f64, @bitCast(@as(i64, 4643457506423603200))), @as(f64, @bitCast(@as(i64, 4642366790888849408))), @as(f64, @bitCast(@as(i64, 4643457535978475755))), @as(f64, @bitCast(@as(i64, 4642929740842270720))), @as(f64, @bitCast(@as(i64, 4643457639596451556))), @as(f64, @bitCast(@as(i64, 4643351953307336704))), @as(f64, @bitCast(@as(i64, 4643457819564514791))), @as(f64, @bitCast(@as(i64, 4643633428284047360))), @as(f64, @bitCast(@as(i64, 4643458079928868248))), @as(f64, @bitCast(@as(i64, 4643914903260758016))), @as(f64, @bitCast(@as(i64, 4643458422272808672))), @as(f64, @bitCast(@as(i64, 4644196378237468672))), @as(f64, @bitCast(@as(i64, 4643458850466616993))), @as(f64, @bitCast(@as(i64, 4644477853214179328))), @as(f64, @bitCast(@as(i64, 4643459365565824374))), @as(f64, @bitCast(@as(i64, 4644759328190889984))), @as(f64, @bitCast(@as(i64, 4643459970737024302))), @as(f64, @bitCast(@as(i64, 4645040803167600640))), @as(f64, @bitCast(@as(i64, 4643460666507982358))), @as(f64, @bitCast(@as(i64, 4645322278144311296))), @as(f64, @bitCast(@as(i64, 4643461454110151567))), @as(f64, @bitCast(@as(i64, 4645603753121021952))), @as(f64, @bitCast(@as(i64, 4643462335126828671))), @as(f64, @bitCast(@as(i64, 4645885228097732608))), @as(f64, @bitCast(@as(i64, 4643463310085779253))), @as(f64, @bitCast(@as(i64, 4646166703074443264))), @as(f64, @bitCast(@as(i64, 4643464377931472149))), @as(f64, @bitCast(@as(i64, 4646448178051153920))), @as(f64, @bitCast(@as(i64, 4643465539015751080))), @as(f64, @bitCast(@as(i64, 4646729653027864576))), @as(f64, @bitCast(@as(i64, 4643466792634928605))), @as(f64, @bitCast(@as(i64, 4647011128004575232))), @as(f64, @bitCast(@as(i64, 4643468137029786120))), @as(f64, @bitCast(@as(i64, 4647292602981285888))), @as(f64, @bitCast(@as(i64, 4643469570441105019))), @as(f64, @bitCast(@as(i64, 4647574077957996544))), @as(f64, @bitCast(@as(i64, 4643471091461510419))), @as(f64, @bitCast(@as(i64, 4647785184190529536))), @as(f64, @bitCast(@as(i64, 4643472696044799530))), @as(f64, @bitCast(@as(i64, 4647925921678884864))), @as(f64, @bitCast(@as(i64, 4643474382607675608))), @as(f64, @bitCast(@as(i64, 4648066659167240192))), @as(f64, @bitCast(@as(i64, 4643476146576170282))), @as(f64, @bitCast(@as(i64, 4648207396655595520))), @as(f64, @bitCast(@as(i64, 4643477984783690063))), @as(f64, @bitCast(@as(i64, 4648348134143950848))), @as(f64, @bitCast(@as(i64, 4643479893887719603))), @as(f64, @bitCast(@as(i64, 4648488871632306176))), @as(f64, @bitCast(@as(i64, 4643481869138368670))), @as(f64, @bitCast(@as(i64, 4648629609120661504))), @as(f64, @bitCast(@as(i64, 4643483905257981451))), @as(f64, @bitCast(@as(i64, 4648770346609016832))), @as(f64, @bitCast(@as(i64, 4643485999255886317))), @as(f64, @bitCast(@as(i64, 4648911084097372160))), @as(f64, @bitCast(@as(i64, 4643488144974818155))), @as(f64, @bitCast(@as(i64, 4649051821585727488))), @as(f64, @bitCast(@as(i64, 4643490338720417894))), @as(f64, @bitCast(@as(i64, 4649192559074082816))), @as(f64, @bitCast(@as(i64, 4643492574687264139))), @as(f64, @bitCast(@as(i64, 4649333296562438144))), @as(f64, @bitCast(@as(i64, 4643494848477310380))), @as(f64, @bitCast(@as(i64, 4649474034050793472))), @as(f64, @bitCast(@as(i64, 4643497154812900803))), @as(f64, @bitCast(@as(i64, 4649614771539148800))), @as(f64, @bitCast(@as(i64, 4643499489120067036))), @as(f64, @bitCast(@as(i64, 4649755509027504128))), @as(f64, @bitCast(@as(i64, 4643501847176684430))), @as(f64, @bitCast(@as(i64, 4649896246515859456))), @as(f64, @bitCast(@as(i64, 4643504223353253449))), @as(f64, @bitCast(@as(i64, 4650036984004214784))), @as(f64, @bitCast(@as(i64, 4643506614483180606))), @as(f64, @bitCast(@as(i64, 4650177721492570112))), @as(f64, @bitCast(@as(i64, 4643509015464731948))), @as(f64, @bitCast(@as(i64, 4650318458980925440))), @as(f64, @bitCast(@as(i64, 4643511422251704684))), @as(f64, @bitCast(@as(i64, 4650459196469280768))), @as(f64, @bitCast(@as(i64, 4643513831325661607))), @as(f64, @bitCast(@as(i64, 4650599933957636096))), @as(f64, @bitCast(@as(i64, 4643516238992243645))), @as(f64, @bitCast(@as(i64, 4650740671445991424))), @as(f64, @bitCast(@as(i64, 4643518641557091731))), @as(f64, @bitCast(@as(i64, 4650881408934346752))), @as(f64, @bitCast(@as(i64, 4643521036557299818))), @as(f64, @bitCast(@as(i64, 4651022146422702080))), @as(f64, @bitCast(@as(i64, 4643523419594821395))), @as(f64, @bitCast(@as(i64, 4651162883911057408))), @as(f64, @bitCast(@as(i64, 4643525789965969019))), @as(f64, @bitCast(@as(i64, 4651303621399412736))), @as(f64, @bitCast(@as(i64, 4643528143096774320))), @as(f64, @bitCast(@as(i64, 4651444358887768064))), @as(f64, @bitCast(@as(i64, 4643530477931706135))), @as(f64, @bitCast(@as(i64, 4651585096376123392))), @as(f64, @bitCast(@as(i64, 4643532791831936557))), @as(f64, @bitCast(@as(i64, 4651725833864478720))), @as(f64, @bitCast(@as(i64, 4643535083214168843))), @as(f64, @bitCast(@as(i64, 4651866571352834048))), @as(f64, @bitCast(@as(i64, 4643537350319184386))), @as(f64, @bitCast(@as(i64, 4652007308841189376))), @as(f64, @bitCast(@as(i64, 4643539591915530166))), @as(f64, @bitCast(@as(i64, 4652148046329544704))), @as(f64, @bitCast(@as(i64, 4643541805892143856))), @as(f64, @bitCast(@as(i64, 4652253599445811200))), @as(f64, @bitCast(@as(i64, 4643543992073103595))), @as(f64, @bitCast(@as(i64, 4652323968189988864))), @as(f64, @bitCast(@as(i64, 4643546148699190780))), @as(f64, @bitCast(@as(i64, 4652394336934166528))), @as(f64, @bitCast(@as(i64, 4643548275066717969))), @as(f64, @bitCast(@as(i64, 4652464705678344192))), @as(f64, @bitCast(@as(i64, 4643550371175685161))), @as(f64, @bitCast(@as(i64, 4652535074422521856))), @as(f64, @bitCast(@as(i64, 4643552435618717473))), @as(f64, @bitCast(@as(i64, 4652605443166699520))), @as(f64, @bitCast(@as(i64, 4643554467516205603))), @as(f64, @bitCast(@as(i64, 4652675811910877184))), @as(f64, @bitCast(@as(i64, 4643556467747758853))), @as(f64, @bitCast(@as(i64, 4652746180655054848))), @as(f64, @bitCast(@as(i64, 4643558435961533503))), @as(f64, @bitCast(@as(i64, 4652816549399232512))), @as(f64, @bitCast(@as(i64, 4643560371453842109))), (-@as(f64, @bitCast(@as(i64, 4641240890982006784)))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4640677941028585472)))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4640114991075164160)))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4639552041121742848)))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4638989091168321536)))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4638144666238189568)))), @as(f64, @bitCast(@as(i64, 4643981823936470974))), (-@as(f64, @bitCast(@as(i64, 4637018766331346944)))), @as(f64, @bitCast(@as(i64, 4643936637351084729))), (-@as(f64, @bitCast(@as(i64, 4635892866424504320)))), @as(f64, @bitCast(@as(i64, 4643892172397170026))), (-@as(f64, @bitCast(@as(i64, 4634766966517661696)))), @as(f64, @bitCast(@as(i64, 4643850443380028950))), (-@as(f64, @bitCast(@as(i64, 4633078116657397760)))), @as(f64, @bitCast(@as(i64, 4643811754996323792))), (-@as(f64, @bitCast(@as(i64, 4630826316843712512)))), @as(f64, @bitCast(@as(i64, 4643774236668912447))), (-@as(f64, @bitCast(@as(i64, 4627448617123184640)))), @as(f64, @bitCast(@as(i64, 4643733880545970278))), (-@as(f64, @bitCast(@as(i64, 4620693217682128896)))), @as(f64, @bitCast(@as(i64, 4643685248706869094))), @as(f64, @bitCast(@as(i64, 4620693217682128896))), @as(f64, @bitCast(@as(i64, 4643622868574374199))), @as(f64, @bitCast(@as(i64, 4627448617123184640))), @as(f64, @bitCast(@as(i64, 4643543148000017184))), @as(f64, @bitCast(@as(i64, 4630826316843712512))), @as(f64, @bitCast(@as(i64, 4643446399596944058))), @as(f64, @bitCast(@as(i64, 4633078116657397760))), @as(f64, @bitCast(@as(i64, 4643338387972677855))), @as(f64, @bitCast(@as(i64, 4634766966517661696))), @as(f64, @bitCast(@as(i64, 4643230707433353008))), @as(f64, @bitCast(@as(i64, 4635892866424504320))), @as(f64, @bitCast(@as(i64, 4643067719524010563))), @as(f64, @bitCast(@as(i64, 4637018766331346944))), @as(f64, @bitCast(@as(i64, 4642952956194662373))), @as(f64, @bitCast(@as(i64, 4638144666238189568))), @as(f64, @bitCast(@as(i64, 4642933970355639518))), @as(f64, @bitCast(@as(i64, 4638989091168321536))), @as(f64, @bitCast(@as(i64, 4643021869009523001))), @as(f64, @bitCast(@as(i64, 4639552041121742848))), @as(f64, @bitCast(@as(i64, 4643203020323190724))), @as(f64, @bitCast(@as(i64, 4640114991075164160))), @as(f64, @bitCast(@as(i64, 4643324197587648848))), @as(f64, @bitCast(@as(i64, 4640677941028585472))), @as(f64, @bitCast(@as(i64, 4643437570958377668))), @as(f64, @bitCast(@as(i64, 4641240890982006784))), @as(f64, @bitCast(@as(i64, 4643514378794491309))), @as(f64, @bitCast(@as(i64, 4641803840935428096))), @as(f64, @bitCast(@as(i64, 4643529170656361175))), @as(f64, @bitCast(@as(i64, 4642366790888849408))), @as(f64, @bitCast(@as(i64, 4643473471332438508))), @as(f64, @bitCast(@as(i64, 4642929740842270720))), @as(f64, @bitCast(@as(i64, 4643361044949084458))), @as(f64, @bitCast(@as(i64, 4643351953307336704))), @as(f64, @bitCast(@as(i64, 4643225740807388948))), @as(f64, @bitCast(@as(i64, 4643633428284047360))), @as(f64, @bitCast(@as(i64, 4643010961502331742))), @as(f64, @bitCast(@as(i64, 4643914903260758016))), @as(f64, @bitCast(@as(i64, 4642897088337597400))), @as(f64, @bitCast(@as(i64, 4644196378237468672))), @as(f64, @bitCast(@as(i64, 4642927170975733352))), @as(f64, @bitCast(@as(i64, 4644477853214179328))), @as(f64, @bitCast(@as(i64, 4643065036715638789))), @as(f64, @bitCast(@as(i64, 4644759328190889984))), @as(f64, @bitCast(@as(i64, 4643213168903476027))), @as(f64, @bitCast(@as(i64, 4645040803167600640))), @as(f64, @bitCast(@as(i64, 4643232768006104390))), @as(f64, @bitCast(@as(i64, 4645322278144311296))), @as(f64, @bitCast(@as(i64, 4643080866868328997))), @as(f64, @bitCast(@as(i64, 4645603753121021952))), @as(f64, @bitCast(@as(i64, 4642661425524408729))), @as(f64, @bitCast(@as(i64, 4645885228097732608))), @as(f64, @bitCast(@as(i64, 4642055394066583247))), @as(f64, @bitCast(@as(i64, 4646166703074443264))), @as(f64, @bitCast(@as(i64, 4641402952310910270))), @as(f64, @bitCast(@as(i64, 4646448178051153920))), @as(f64, @bitCast(@as(i64, 4640878163679300226))), @as(f64, @bitCast(@as(i64, 4646729653027864576))), @as(f64, @bitCast(@as(i64, 4640624469930947190))), @as(f64, @bitCast(@as(i64, 4647011128004575232))), @as(f64, @bitCast(@as(i64, 4640699211740731775))), @as(f64, @bitCast(@as(i64, 4647292602981285888))), @as(f64, @bitCast(@as(i64, 4641051412582996797))), @as(f64, @bitCast(@as(i64, 4647574077957996544))), @as(f64, @bitCast(@as(i64, 4641543163441059149))), @as(f64, @bitCast(@as(i64, 4647785184190529536))), @as(f64, @bitCast(@as(i64, 4642005875229461704))), @as(f64, @bitCast(@as(i64, 4647925921678884864))), @as(f64, @bitCast(@as(i64, 4642307129452785817))), @as(f64, @bitCast(@as(i64, 4648066659167240192))), @as(f64, @bitCast(@as(i64, 4642399654499755261))), @as(f64, @bitCast(@as(i64, 4648207396655595520))), @as(f64, @bitCast(@as(i64, 4642332575142524182))), @as(f64, @bitCast(@as(i64, 4648348134143950848))), @as(f64, @bitCast(@as(i64, 4642222356578518706))), @as(f64, @bitCast(@as(i64, 4648488871632306176))), @as(f64, @bitCast(@as(i64, 4642198304541758781))), @as(f64, @bitCast(@as(i64, 4648629609120661504))), @as(f64, @bitCast(@as(i64, 4642347124232226634))), @as(f64, @bitCast(@as(i64, 4648770346609016832))), @as(f64, @bitCast(@as(i64, 4642679246057028001))), @as(f64, @bitCast(@as(i64, 4648911084097372160))), @as(f64, @bitCast(@as(i64, 4643128364363274036))), @as(f64, @bitCast(@as(i64, 4649051821585727488))), @as(f64, @bitCast(@as(i64, 4643396025251815175))), @as(f64, @bitCast(@as(i64, 4649192559074082816))), @as(f64, @bitCast(@as(i64, 4643565684821793104))), @as(f64, @bitCast(@as(i64, 4649333296562438144))), @as(f64, @bitCast(@as(i64, 4643639562679321048))), @as(f64, @bitCast(@as(i64, 4649474034050793472))), @as(f64, @bitCast(@as(i64, 4643608914276481908))), @as(f64, @bitCast(@as(i64, 4649614771539148800))), @as(f64, @bitCast(@as(i64, 4643495106730601512))), @as(f64, @bitCast(@as(i64, 4649755509027504128))), @as(f64, @bitCast(@as(i64, 4643339464614463773))), @as(f64, @bitCast(@as(i64, 4649896246515859456))), @as(f64, @bitCast(@as(i64, 4643165564448039837))), @as(f64, @bitCast(@as(i64, 4650036984004214784))), @as(f64, @bitCast(@as(i64, 4642947741167031366))), @as(f64, @bitCast(@as(i64, 4650177721492570112))), @as(f64, @bitCast(@as(i64, 4642854445934156899))), @as(f64, @bitCast(@as(i64, 4650318458980925440))), @as(f64, @bitCast(@as(i64, 4642887148752482305))), @as(f64, @bitCast(@as(i64, 4650459196469280768))), @as(f64, @bitCast(@as(i64, 4643016648000548739))), @as(f64, @bitCast(@as(i64, 4650599933957636096))), @as(f64, @bitCast(@as(i64, 4643197878479053662))), @as(f64, @bitCast(@as(i64, 4650740671445991424))), @as(f64, @bitCast(@as(i64, 4643298415007547733))), @as(f64, @bitCast(@as(i64, 4650881408934346752))), @as(f64, @bitCast(@as(i64, 4643378810770005133))), @as(f64, @bitCast(@as(i64, 4651022146422702080))), @as(f64, @bitCast(@as(i64, 4643437794730984153))), @as(f64, @bitCast(@as(i64, 4651162883911057408))), @as(f64, @bitCast(@as(i64, 4643476025717852157))), @as(f64, @bitCast(@as(i64, 4651303621399412736))), @as(f64, @bitCast(@as(i64, 4643500347618746004))), @as(f64, @bitCast(@as(i64, 4651444358887768064))), @as(f64, @bitCast(@as(i64, 4643520350462044086))), @as(f64, @bitCast(@as(i64, 4651585096376123392))), @as(f64, @bitCast(@as(i64, 4643545071529639281))), @as(f64, @bitCast(@as(i64, 4651725833864478720))), @as(f64, @bitCast(@as(i64, 4643580639411383881))), @as(f64, @bitCast(@as(i64, 4651866571352834048))), @as(f64, @bitCast(@as(i64, 4643629198770678562))), @as(f64, @bitCast(@as(i64, 4652007308841189376))), @as(f64, @bitCast(@as(i64, 4643689061813194221))), @as(f64, @bitCast(@as(i64, 4652148046329544704))), @as(f64, @bitCast(@as(i64, 4643755740948192790))), @as(f64, @bitCast(@as(i64, 4652253599445811200))), @as(f64, @bitCast(@as(i64, 4643823408060359613))), @as(f64, @bitCast(@as(i64, 4652323968189988864))), @as(f64, @bitCast(@as(i64, 4643886369614603275))), @as(f64, @bitCast(@as(i64, 4652394336934166528))), @as(f64, @bitCast(@as(i64, 4643940214898038722))), @as(f64, @bitCast(@as(i64, 4652464705678344192))), @as(f64, @bitCast(@as(i64, 4643982500707868103))), @as(f64, @bitCast(@as(i64, 4652535074422521856))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4652605443166699520))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4652675811910877184))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4652746180655054848))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4652816549399232512))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4641240890982006784)))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4640677941028585472)))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4640114991075164160)))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4639552041121742848)))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4638989091168321536)))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4638144666238189568)))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4637018766331346944)))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4635892866424504320)))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4634766966517661696)))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4633078116657397760)))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4630826316843712512)))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4627448617123184640)))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4620693217682128896)))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4620693217682128896))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4627448617123184640))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4630826316843712512))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4633078116657397760))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4634766966517661696))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4635892866424504320))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4637018766331346944))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4638144666238189568))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4638989091168321536))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4639552041121742848))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4640114991075164160))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4640677941028585472))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4641240890982006784))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4641803840935428096))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4642366790888849408))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4642929740842270720))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4643351953307336704))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4643633428284047360))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4643914903260758016))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4644196378237468672))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4644477853214179328))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4644759328190889984))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4645040803167600640))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4645322278144311296))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4645603753121021952))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4645885228097732608))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4646166703074443264))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4646448178051153920))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4646729653027864576))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4647011128004575232))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4647292602981285888))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4647574077957996544))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4647785184190529536))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4647925921678884864))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4648066659167240192))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4648207396655595520))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4648348134143950848))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4648488871632306176))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4648629609120661504))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4648770346609016832))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4648911084097372160))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4649051821585727488))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4649192559074082816))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4649333296562438144))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4649474034050793472))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4649614771539148800))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4649755509027504128))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4649896246515859456))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4650036984004214784))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4650177721492570112))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4650318458980925440))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4650459196469280768))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4650599933957636096))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4650740671445991424))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4650881408934346752))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4651022146422702080))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4651162883911057408))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4651303621399412736))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4651444358887768064))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4651585096376123392))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4651725833864478720))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4651866571352834048))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4652007308841189376))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4652148046329544704))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4652253599445811200))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4652323968189988864))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4652394336934166528))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4652464705678344192))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4652535074422521856))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4652605443166699520))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4652675811910877184))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4652746180655054848))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4652816549399232512))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4641240890982006784)))), @as(f64, @bitCast(@as(i64, 4643794797184508137))), (-@as(f64, @bitCast(@as(i64, 4640677941028585472)))), @as(f64, @bitCast(@as(i64, 4643792976569174401))), (-@as(f64, @bitCast(@as(i64, 4640114991075164160)))), @as(f64, @bitCast(@as(i64, 4643791098603314159))), (-@as(f64, @bitCast(@as(i64, 4639552041121742848)))), @as(f64, @bitCast(@as(i64, 4643789161703630669))), (-@as(f64, @bitCast(@as(i64, 4638989091168321536)))), @as(f64, @bitCast(@as(i64, 4643787162879452303))), (-@as(f64, @bitCast(@as(i64, 4638144666238189568)))), @as(f64, @bitCast(@as(i64, 4643785100723404176))), (-@as(f64, @bitCast(@as(i64, 4637018766331346944)))), @as(f64, @bitCast(@as(i64, 4643782973652189546))), (-@as(f64, @bitCast(@as(i64, 4635892866424504320)))), @as(f64, @bitCast(@as(i64, 4643780780434355388))), (-@as(f64, @bitCast(@as(i64, 4634766966517661696)))), @as(f64, @bitCast(@as(i64, 4643778518079230077))), (-@as(f64, @bitCast(@as(i64, 4633078116657397760)))), @as(f64, @bitCast(@as(i64, 4643776186059048029))), (-@as(f64, @bitCast(@as(i64, 4630826316843712512)))), @as(f64, @bitCast(@as(i64, 4643773781910903199))), (-@as(f64, @bitCast(@as(i64, 4627448617123184640)))), @as(f64, @bitCast(@as(i64, 4643771304227420703))), (-@as(f64, @bitCast(@as(i64, 4620693217682128896)))), @as(f64, @bitCast(@as(i64, 4643768751425303798))), @as(f64, @bitCast(@as(i64, 4620693217682128896))), @as(f64, @bitCast(@as(i64, 4643766121921255739))), @as(f64, @bitCast(@as(i64, 4627448617123184640))), @as(f64, @bitCast(@as(i64, 4643763414307901643))), @as(f64, @bitCast(@as(i64, 4630826316843712512))), @as(f64, @bitCast(@as(i64, 4643760628057475929))), @as(f64, @bitCast(@as(i64, 4633078116657397760))), @as(f64, @bitCast(@as(i64, 4643757761058916270))), @as(f64, @bitCast(@as(i64, 4634766966517661696))), @as(f64, @bitCast(@as(i64, 4643754812608535226))), @as(f64, @bitCast(@as(i64, 4635892866424504320))), @as(f64, @bitCast(@as(i64, 4643751782530410936))), @as(f64, @bitCast(@as(i64, 4637018766331346944))), @as(f64, @bitCast(@as(i64, 4643748669769012237))), @as(f64, @bitCast(@as(i64, 4638144666238189568))), @as(f64, @bitCast(@as(i64, 4643745473796573548))), @as(f64, @bitCast(@as(i64, 4638989091168321536))), @as(f64, @bitCast(@as(i64, 4643742194613094869))), @as(f64, @bitCast(@as(i64, 4639552041121742848))), @as(f64, @bitCast(@as(i64, 4643738833274107362))), @as(f64, @bitCast(@as(i64, 4640114991075164160))), @as(f64, @bitCast(@as(i64, 4643735389075923586))), @as(f64, @bitCast(@as(i64, 4640677941028585472))), @as(f64, @bitCast(@as(i64, 4643731863601840285))), @as(f64, @bitCast(@as(i64, 4641240890982006784))), @as(f64, @bitCast(@as(i64, 4643728257203701180))), @as(f64, @bitCast(@as(i64, 4641803840935428096))), @as(f64, @bitCast(@as(i64, 4643724572872177898))), @as(f64, @bitCast(@as(i64, 4642366790888849408))), @as(f64, @bitCast(@as(i64, 4643720810959114160))), @as(f64, @bitCast(@as(i64, 4642929740842270720))), @as(f64, @bitCast(@as(i64, 4643716974455181594))), @as(f64, @bitCast(@as(i64, 4643351953307336704))), @as(f64, @bitCast(@as(i64, 4643713066351051827))), @as(f64, @bitCast(@as(i64, 4643633428284047360))), @as(f64, @bitCast(@as(i64, 4643709088405943463))), @as(f64, @bitCast(@as(i64, 4643914903260758016))), @as(f64, @bitCast(@as(i64, 4643705045193824875))), @as(f64, @bitCast(@as(i64, 4644196378237468672))), @as(f64, @bitCast(@as(i64, 4643700940936820713))), @as(f64, @bitCast(@as(i64, 4644477853214179328))), @as(f64, @bitCast(@as(i64, 4643696778977446325))), @as(f64, @bitCast(@as(i64, 4644759328190889984))), @as(f64, @bitCast(@as(i64, 4643692564417435664))), @as(f64, @bitCast(@as(i64, 4645040803167600640))), @as(f64, @bitCast(@as(i64, 4643688302886288265))), @as(f64, @bitCast(@as(i64, 4645322278144311296))), @as(f64, @bitCast(@as(i64, 4643683998782050638))), @as(f64, @bitCast(@as(i64, 4645603753121021952))), @as(f64, @bitCast(@as(i64, 4643679658261987899))), @as(f64, @bitCast(@as(i64, 4645885228097732608))), @as(f64, @bitCast(@as(i64, 4643675287131521443))), @as(f64, @bitCast(@as(i64, 4646166703074443264))), @as(f64, @bitCast(@as(i64, 4643670892251603827))), @as(f64, @bitCast(@as(i64, 4646448178051153920))), @as(f64, @bitCast(@as(i64, 4643666479603578307))), @as(f64, @bitCast(@as(i64, 4646729653027864576))), @as(f64, @bitCast(@as(i64, 4643662056048397438))), @as(f64, @bitCast(@as(i64, 4647011128004575232))), @as(f64, @bitCast(@as(i64, 4643657627743326338))), @as(f64, @bitCast(@as(i64, 4647292602981285888))), @as(f64, @bitCast(@as(i64, 4643653202253005004))), @as(f64, @bitCast(@as(i64, 4647574077957996544))), @as(f64, @bitCast(@as(i64, 4643648786262464135))), @as(f64, @bitCast(@as(i64, 4647785184190529536))), @as(f64, @bitCast(@as(i64, 4643644385753046985))), @as(f64, @bitCast(@as(i64, 4647925921678884864))), @as(f64, @bitCast(@as(i64, 4643640007761627972))), @as(f64, @bitCast(@as(i64, 4648066659167240192))), @as(f64, @bitCast(@as(i64, 4643635658445472211))), @as(f64, @bitCast(@as(i64, 4648207396655595520))), @as(f64, @bitCast(@as(i64, 4643631344665532259))), @as(f64, @bitCast(@as(i64, 4648348134143950848))), @as(f64, @bitCast(@as(i64, 4643627072227229512))), @as(f64, @bitCast(@as(i64, 4648488871632306176))), @as(f64, @bitCast(@as(i64, 4643622846584141644))), @as(f64, @bitCast(@as(i64, 4648629609120661504))), @as(f64, @bitCast(@as(i64, 4643618673717611908))), @as(f64, @bitCast(@as(i64, 4648770346609016832))), @as(f64, @bitCast(@as(i64, 4643614557146077515))), @as(f64, @bitCast(@as(i64, 4648911084097372160))), @as(f64, @bitCast(@as(i64, 4643610503378647300))), @as(f64, @bitCast(@as(i64, 4649051821585727488))), @as(f64, @bitCast(@as(i64, 4643606514878227310))), @as(f64, @bitCast(@as(i64, 4649192559074082816))), @as(f64, @bitCast(@as(i64, 4643602597450238940))), @as(f64, @bitCast(@as(i64, 4649333296562438144))), @as(f64, @bitCast(@as(i64, 4643598752853900793))), @as(f64, @bitCast(@as(i64, 4649474034050793472))), @as(f64, @bitCast(@as(i64, 4643594984607650079))), @as(f64, @bitCast(@as(i64, 4649614771539148800))), @as(f64, @bitCast(@as(i64, 4643591295702158425))), @as(f64, @bitCast(@as(i64, 4649755509027504128))), @as(f64, @bitCast(@as(i64, 4643587687368878855))), @as(f64, @bitCast(@as(i64, 4649896246515859456))), @as(f64, @bitCast(@as(i64, 4643584162246639275))), @as(f64, @bitCast(@as(i64, 4650036984004214784))), @as(f64, @bitCast(@as(i64, 4643580721566892708))), @as(f64, @bitCast(@as(i64, 4650177721492570112))), @as(f64, @bitCast(@as(i64, 4643577366033326596))), @as(f64, @bitCast(@as(i64, 4650318458980925440))), @as(f64, @bitCast(@as(i64, 4643574096525550242))), @as(f64, @bitCast(@as(i64, 4650459196469280768))), @as(f64, @bitCast(@as(i64, 4643570912691719923))), @as(f64, @bitCast(@as(i64, 4650599933957636096))), @as(f64, @bitCast(@as(i64, 4643567815763288664))), @as(f64, @bitCast(@as(i64, 4650740671445991424))), @as(f64, @bitCast(@as(i64, 4643564804684725302))), @as(f64, @bitCast(@as(i64, 4650881408934346752))), @as(f64, @bitCast(@as(i64, 4643561879104186116))), @as(f64, @bitCast(@as(i64, 4651022146422702080))), @as(f64, @bitCast(@as(i64, 4643559037966139943))), @as(f64, @bitCast(@as(i64, 4651162883911057408))), @as(f64, @bitCast(@as(i64, 4643556281270586783))), @as(f64, @bitCast(@as(i64, 4651303621399412736))), @as(f64, @bitCast(@as(i64, 4643553606378698729))), @as(f64, @bitCast(@as(i64, 4651444358887768064))), @as(f64, @bitCast(@as(i64, 4643551013290475782))), @as(f64, @bitCast(@as(i64, 4651585096376123392))), @as(f64, @bitCast(@as(i64, 4643548499543011896))), @as(f64, @bitCast(@as(i64, 4651725833864478720))), @as(f64, @bitCast(@as(i64, 4643546064432619627))), @as(f64, @bitCast(@as(i64, 4651866571352834048))), @as(f64, @bitCast(@as(i64, 4643543706376002234))), @as(f64, @bitCast(@as(i64, 4652007308841189376))), @as(f64, @bitCast(@as(i64, 4643541422558409948))), @as(f64, @bitCast(@as(i64, 4652148046329544704))), @as(f64, @bitCast(@as(i64, 4643539212276155327))), @as(f64, @bitCast(@as(i64, 4652253599445811200))), @as(f64, @bitCast(@as(i64, 4643537073418176047))), @as(f64, @bitCast(@as(i64, 4652323968189988864))), @as(f64, @bitCast(@as(i64, 4643535003521566061))), @as(f64, @bitCast(@as(i64, 4652394336934166528))), @as(f64, @bitCast(@as(i64, 4643533001178950486))), @as(f64, @bitCast(@as(i64, 4652464705678344192))), @as(f64, @bitCast(@as(i64, 4643531064103345135))), @as(f64, @bitCast(@as(i64, 4652535074422521856))), @as(f64, @bitCast(@as(i64, 4643529191063296986))), @as(f64, @bitCast(@as(i64, 4652605443166699520))), @as(f64, @bitCast(@as(i64, 4643527379068134411))), @as(f64, @bitCast(@as(i64, 4652675811910877184))), @as(f64, @bitCast(@as(i64, 4643525626886404388))), @as(f64, @bitCast(@as(i64, 4652746180655054848))), @as(f64, @bitCast(@as(i64, 4643523932407044589))), @as(f64, @bitCast(@as(i64, 4652816549399232512))), @as(f64, @bitCast(@as(i64, 4643522293870836413))), (-@as(f64, @bitCast(@as(i64, 4641240890982006784)))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4640677941028585472)))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4640114991075164160)))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4639552041121742848)))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4638989091168321536)))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4638144666238189568)))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4637018766331346944)))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4635892866424504320)))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4634766966517661696)))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4633078116657397760)))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4630826316843712512)))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4627448617123184640)))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4620693217682128896)))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4620693217682128896))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4627448617123184640))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4630826316843712512))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4633078116657397760))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4634766966517661696))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4635892866424504320))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4637018766331346944))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4638144666238189568))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4638989091168321536))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4639552041121742848))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4640114991075164160))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4640677941028585472))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4641240890982006784))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4641803840935428096))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4642366790888849408))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4642929740842270720))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4643351953307336704))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4643633428284047360))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4643914903260758016))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4644196378237468672))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4644477853214179328))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4644759328190889984))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4645040803167600640))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4645322278144311296))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4645603753121021952))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4645885228097732608))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4646166703074443264))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4646448178051153920))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4646729653027864576))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4647011128004575232))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4647292602981285888))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4647574077957996544))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4647785184190529536))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4647925921678884864))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4648066659167240192))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4648207396655595520))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4648348134143950848))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4648488871632306176))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4648629609120661504))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4648770346609016832))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4648911084097372160))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4649051821585727488))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4649192559074082816))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4649333296562438144))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4649474034050793472))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4649614771539148800))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4649755509027504128))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4649896246515859456))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4650036984004214784))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4650177721492570112))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4650318458980925440))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4650459196469280768))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4650599933957636096))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4650740671445991424))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4650881408934346752))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4651022146422702080))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4651162883911057408))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4651303621399412736))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4651444358887768064))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4651585096376123392))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4651725833864478720))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4651866571352834048))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4652007308841189376))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4652148046329544704))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4652253599445811200))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4652323968189988864))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4652394336934166528))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4652464705678344192))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4652535074422521856))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4652605443166699520))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4652675811910877184))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4652746180655054848))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4652816549399232512))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4641240890982006784)))), @as(f64, @bitCast(@as(i64, 4643666016929085338))), (-@as(f64, @bitCast(@as(i64, 4640677941028585472)))), @as(f64, @bitCast(@as(i64, 4643690225008535478))), (-@as(f64, @bitCast(@as(i64, 4640114991075164160)))), @as(f64, @bitCast(@as(i64, 4643713077434129035))), (-@as(f64, @bitCast(@as(i64, 4639552041121742848)))), @as(f64, @bitCast(@as(i64, 4643733354539607550))), (-@as(f64, @bitCast(@as(i64, 4638989091168321536)))), @as(f64, @bitCast(@as(i64, 4643749693282396301))), (-@as(f64, @bitCast(@as(i64, 4638144666238189568)))), @as(f64, @bitCast(@as(i64, 4643760640899771741))), (-@as(f64, @bitCast(@as(i64, 4637018766331346944)))), @as(f64, @bitCast(@as(i64, 4643764749554822414))), (-@as(f64, @bitCast(@as(i64, 4635892866424504320)))), @as(f64, @bitCast(@as(i64, 4643760700009516850))), (-@as(f64, @bitCast(@as(i64, 4634766966517661696)))), @as(f64, @bitCast(@as(i64, 4643747472620751914))), (-@as(f64, @bitCast(@as(i64, 4633078116657397760)))), @as(f64, @bitCast(@as(i64, 4643724552289320226))), (-@as(f64, @bitCast(@as(i64, 4630826316843712512)))), @as(f64, @bitCast(@as(i64, 4643692162963750131))), (-@as(f64, @bitCast(@as(i64, 4627448617123184640)))), @as(f64, @bitCast(@as(i64, 4643651498977552184))), (-@as(f64, @bitCast(@as(i64, 4620693217682128896)))), @as(f64, @bitCast(@as(i64, 4643604910822703780))), @as(f64, @bitCast(@as(i64, 4620693217682128896))), @as(f64, @bitCast(@as(i64, 4643555984666330074))), @as(f64, @bitCast(@as(i64, 4627448617123184640))), @as(f64, @bitCast(@as(i64, 4643509427121885387))), @as(f64, @bitCast(@as(i64, 4630826316843712512))), @as(f64, @bitCast(@as(i64, 4643470660101108610))), @as(f64, @bitCast(@as(i64, 4633078116657397760))), @as(f64, @bitCast(@as(i64, 4643445033915541430))), @as(f64, @bitCast(@as(i64, 4634766966517661696))), @as(f64, @bitCast(@as(i64, 4643436628544971268))), @as(f64, @bitCast(@as(i64, 4635892866424504320))), @as(f64, @bitCast(@as(i64, 4643446711506402625))), @as(f64, @bitCast(@as(i64, 4637018766331346944))), @as(f64, @bitCast(@as(i64, 4643472089993990300))), @as(f64, @bitCast(@as(i64, 4638144666238189568))), @as(f64, @bitCast(@as(i64, 4643503872389141863))), @as(f64, @bitCast(@as(i64, 4638989091168321536))), @as(f64, @bitCast(@as(i64, 4643527357957511158))), @as(f64, @bitCast(@as(i64, 4639552041121742848))), @as(f64, @bitCast(@as(i64, 4643523944721574821))), @as(f64, @bitCast(@as(i64, 4640114991075164160))), @as(f64, @bitCast(@as(i64, 4643475705540066148))), @as(f64, @bitCast(@as(i64, 4640677941028585472))), @as(f64, @bitCast(@as(i64, 4643372510128573325))), @as(f64, @bitCast(@as(i64, 4641240890982006784))), @as(f64, @bitCast(@as(i64, 4643220081225216599))), @as(f64, @bitCast(@as(i64, 4641803840935428096))), @as(f64, @bitCast(@as(i64, 4642879610148918552))), @as(f64, @bitCast(@as(i64, 4642366790888849408))), @as(f64, @bitCast(@as(i64, 4642578093450178656))), @as(f64, @bitCast(@as(i64, 4642929740842270720))), @as(f64, @bitCast(@as(i64, 4642427717203089592))), @as(f64, @bitCast(@as(i64, 4643351953307336704))), @as(f64, @bitCast(@as(i64, 4642494575954307674))), @as(f64, @bitCast(@as(i64, 4643633428284047360))), @as(f64, @bitCast(@as(i64, 4642758180436590692))), @as(f64, @bitCast(@as(i64, 4643914903260758016))), @as(f64, @bitCast(@as(i64, 4643097071030894508))), @as(f64, @bitCast(@as(i64, 4644196378237468672))), @as(f64, @bitCast(@as(i64, 4643276420376945702))), @as(f64, @bitCast(@as(i64, 4644477853214179328))), @as(f64, @bitCast(@as(i64, 4643298754536738390))), @as(f64, @bitCast(@as(i64, 4644759328190889984))), @as(f64, @bitCast(@as(i64, 4643250387987802756))), @as(f64, @bitCast(@as(i64, 4645040803167600640))), @as(f64, @bitCast(@as(i64, 4643234588445516266))), @as(f64, @bitCast(@as(i64, 4645322278144311296))), @as(f64, @bitCast(@as(i64, 4643344744733183144))), @as(f64, @bitCast(@as(i64, 4645603753121021952))), @as(f64, @bitCast(@as(i64, 4643564223438898395))), @as(f64, @bitCast(@as(i64, 4645885228097732608))), @as(f64, @bitCast(@as(i64, 4643756653103039193))), @as(f64, @bitCast(@as(i64, 4646166703074443264))), @as(f64, @bitCast(@as(i64, 4643785777670723165))), @as(f64, @bitCast(@as(i64, 4646448178051153920))), @as(f64, @bitCast(@as(i64, 4643656434289425085))), @as(f64, @bitCast(@as(i64, 4646729653027864576))), @as(f64, @bitCast(@as(i64, 4643514498069512690))), @as(f64, @bitCast(@as(i64, 4647011128004575232))), @as(f64, @bitCast(@as(i64, 4643492546539766468))), @as(f64, @bitCast(@as(i64, 4647292602981285888))), @as(f64, @bitCast(@as(i64, 4643579901771023039))), @as(f64, @bitCast(@as(i64, 4647574077957996544))), @as(f64, @bitCast(@as(i64, 4643667862173479537))), @as(f64, @bitCast(@as(i64, 4647785184190529536))), @as(f64, @bitCast(@as(i64, 4643695015360795372))), @as(f64, @bitCast(@as(i64, 4647925921678884864))), @as(f64, @bitCast(@as(i64, 4643703113571797198))), @as(f64, @bitCast(@as(i64, 4648066659167240192))), @as(f64, @bitCast(@as(i64, 4643756794720136850))), @as(f64, @bitCast(@as(i64, 4648207396655595520))), @as(f64, @bitCast(@as(i64, 4643856656588296117))), @as(f64, @bitCast(@as(i64, 4648348134143950848))), @as(f64, @bitCast(@as(i64, 4643950977269695114))), @as(f64, @bitCast(@as(i64, 4648488871632306176))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4648629609120661504))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4648770346609016832))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4648911084097372160))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4649051821585727488))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4649192559074082816))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4649333296562438144))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4649474034050793472))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4649614771539148800))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4649755509027504128))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4649896246515859456))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4650036984004214784))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4650177721492570112))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4650318458980925440))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4650459196469280768))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4650599933957636096))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4650740671445991424))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4650881408934346752))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4651022146422702080))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4651162883911057408))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4651303621399412736))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4651444358887768064))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4651585096376123392))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4651725833864478720))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4651866571352834048))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4652007308841189376))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4652148046329544704))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4652253599445811200))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4652323968189988864))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4652394336934166528))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4652464705678344192))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4652535074422521856))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4652605443166699520))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4652675811910877184))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4652746180655054848))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4652816549399232512))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4641944578423783424))), @as(f64, @bitCast(@as(i64, 4642795586349933212))), @as(f64, @bitCast(@as(i64, 4642507528377204736))), @as(f64, @bitCast(@as(i64, 4642522686508388047))), @as(f64, @bitCast(@as(i64, 4643070478330626048))), @as(f64, @bitCast(@as(i64, 4642423085180504097))), @as(f64, @bitCast(@as(i64, 4643422322051514368))), @as(f64, @bitCast(@as(i64, 4642545188321713738))), @as(f64, @bitCast(@as(i64, 4643598243911958528))), @as(f64, @bitCast(@as(i64, 4642829276089895711))), @as(f64, @bitCast(@as(i64, 4643316768935247872))), @as(f64, @bitCast(@as(i64, 4642932824048796864))), @as(f64, @bitCast(@as(i64, 4642859372098093056))), @as(f64, @bitCast(@as(i64, 4642949257261624674))), @as(f64, @bitCast(@as(i64, 4642296422144671744))), @as(f64, @bitCast(@as(i64, 4642875272971371162))), (-@as(f64, @bitCast(@as(i64, 4641240890982006784)))), @as(f64, @bitCast(@as(i64, 4643749009650046615))), (-@as(f64, @bitCast(@as(i64, 4640677941028585472)))), @as(f64, @bitCast(@as(i64, 4643748888791728490))), (-@as(f64, @bitCast(@as(i64, 4640114991075164160)))), @as(f64, @bitCast(@as(i64, 4643748769692628969))), (-@as(f64, @bitCast(@as(i64, 4639552041121742848)))), @as(f64, @bitCast(@as(i64, 4643748652528669913))), (-@as(f64, @bitCast(@as(i64, 4638989091168321536)))), @as(f64, @bitCast(@as(i64, 4643748538707226206))), (-@as(f64, @bitCast(@as(i64, 4638144666238189568)))), @as(f64, @bitCast(@as(i64, 4643748428404219707))), (-@as(f64, @bitCast(@as(i64, 4637018766331346944)))), @as(f64, @bitCast(@as(i64, 4643748322499259720))), (-@as(f64, @bitCast(@as(i64, 4635892866424504320)))), @as(f64, @bitCast(@as(i64, 4643748221520111825))), (-@as(f64, @bitCast(@as(i64, 4634766966517661696)))), @as(f64, @bitCast(@as(i64, 4643748127577838348))), (-@as(f64, @bitCast(@as(i64, 4633078116657397760)))), @as(f64, @bitCast(@as(i64, 4643748041024283009))), (-@as(f64, @bitCast(@as(i64, 4630826316843712512)))), @as(f64, @bitCast(@as(i64, 4643747963970508135))), (-@as(f64, @bitCast(@as(i64, 4627448617123184640)))), @as(f64, @bitCast(@as(i64, 4643747897120201166))), (-@as(f64, @bitCast(@as(i64, 4620693217682128896)))), @as(f64, @bitCast(@as(i64, 4643747842936268149))), @as(f64, @bitCast(@as(i64, 4620693217682128896))), @as(f64, @bitCast(@as(i64, 4643747803881615131))), @as(f64, @bitCast(@as(i64, 4627448617123184640))), @as(f64, @bitCast(@as(i64, 4643747781715460715))), @as(f64, @bitCast(@as(i64, 4630826316843712512))), @as(f64, @bitCast(@as(i64, 4643747779252554668))), @as(f64, @bitCast(@as(i64, 4633078116657397760))), @as(f64, @bitCast(@as(i64, 4643747799483568620))), @as(f64, @bitCast(@as(i64, 4634766966517661696))), @as(f64, @bitCast(@as(i64, 4643747846806549079))), @as(f64, @bitCast(@as(i64, 4635892866424504320))), @as(f64, @bitCast(@as(i64, 4643747924036245814))), @as(f64, @bitCast(@as(i64, 4637018766331346944))), @as(f64, @bitCast(@as(i64, 4643748036098470917))), @as(f64, @bitCast(@as(i64, 4638144666238189568))), @as(f64, @bitCast(@as(i64, 4643748189150489503))), @as(f64, @bitCast(@as(i64, 4638989091168321536))), @as(f64, @bitCast(@as(i64, 4643748387414426224))), @as(f64, @bitCast(@as(i64, 4639552041121742848))), @as(f64, @bitCast(@as(i64, 4643748638630842938))), @as(f64, @bitCast(@as(i64, 4640114991075164160))), @as(f64, @bitCast(@as(i64, 4643748949484770343))), @as(f64, @bitCast(@as(i64, 4640677941028585472))), @as(f64, @bitCast(@as(i64, 4643749327892692158))), @as(f64, @bitCast(@as(i64, 4641240890982006784))), @as(f64, @bitCast(@as(i64, 4643749783002545127))), @as(f64, @bitCast(@as(i64, 4641803840935428096))), @as(f64, @bitCast(@as(i64, 4643750325545562737))), @as(f64, @bitCast(@as(i64, 4642366790888849408))), @as(f64, @bitCast(@as(i64, 4643750964845603591))), @as(f64, @bitCast(@as(i64, 4642929740842270720))), @as(f64, @bitCast(@as(i64, 4643751713217197921))), @as(f64, @bitCast(@as(i64, 4643351953307336704))), @as(f64, @bitCast(@as(i64, 4643752582974875957))), @as(f64, @bitCast(@as(i64, 4643633428284047360))), @as(f64, @bitCast(@as(i64, 4643753586433167930))), @as(f64, @bitCast(@as(i64, 4643914903260758016))), @as(f64, @bitCast(@as(i64, 4643754737489900816))), @as(f64, @bitCast(@as(i64, 4644196378237468672))), @as(f64, @bitCast(@as(i64, 4643756048459604846))), @as(f64, @bitCast(@as(i64, 4644477853214179328))), @as(f64, @bitCast(@as(i64, 4643757532888263274))), @as(f64, @bitCast(@as(i64, 4644759328190889984))), @as(f64, @bitCast(@as(i64, 4643759201858953308))), @as(f64, @bitCast(@as(i64, 4645040803167600640))), @as(f64, @bitCast(@as(i64, 4643761066630674016))), @as(f64, @bitCast(@as(i64, 4645322278144311296))), @as(f64, @bitCast(@as(i64, 4643763134064377956))), @as(f64, @bitCast(@as(i64, 4645603753121021952))), @as(f64, @bitCast(@as(i64, 4643765409437720940))), @as(f64, @bitCast(@as(i64, 4645885228097732608))), @as(f64, @bitCast(@as(i64, 4643767892926624831))), @as(f64, @bitCast(@as(i64, 4646166703074443264))), @as(f64, @bitCast(@as(i64, 4643770583299636603))), @as(f64, @bitCast(@as(i64, 4646448178051153920))), @as(f64, @bitCast(@as(i64, 4643773470529210213))), @as(f64, @bitCast(@as(i64, 4646729653027864576))), @as(f64, @bitCast(@as(i64, 4643776543532268451))), @as(f64, @bitCast(@as(i64, 4647011128004575232))), @as(f64, @bitCast(@as(i64, 4643779784188859693))), @as(f64, @bitCast(@as(i64, 4647292602981285888))), @as(f64, @bitCast(@as(i64, 4643783170156907662))), @as(f64, @bitCast(@as(i64, 4647574077957996544))), @as(f64, @bitCast(@as(i64, 4643786676455508174))), @as(f64, @bitCast(@as(i64, 4647785184190529536))), @as(f64, @bitCast(@as(i64, 4643790274937163560))), @as(f64, @bitCast(@as(i64, 4647925921678884864))), @as(f64, @bitCast(@as(i64, 4643793935871079403))), @as(f64, @bitCast(@as(i64, 4648066659167240192))), @as(f64, @bitCast(@as(i64, 4643797629702383149))), @as(f64, @bitCast(@as(i64, 4648207396655595520))), @as(f64, @bitCast(@as(i64, 4643801326348436662))), @as(f64, @bitCast(@as(i64, 4648348134143950848))), @as(f64, @bitCast(@as(i64, 4643805000476492038))), @as(f64, @bitCast(@as(i64, 4648488871632306176))), @as(f64, @bitCast(@as(i64, 4643808626401957653))), @as(f64, @bitCast(@as(i64, 4648629609120661504))), @as(f64, @bitCast(@as(i64, 4643812182486444671))), @as(f64, @bitCast(@as(i64, 4648770346609016832))), @as(f64, @bitCast(@as(i64, 4643815651665532630))), @as(f64, @bitCast(@as(i64, 4648911084097372160))), @as(f64, @bitCast(@as(i64, 4643819017578488508))), @as(f64, @bitCast(@as(i64, 4649051821585727488))), @as(f64, @bitCast(@as(i64, 4643822271077375562))), @as(f64, @bitCast(@as(i64, 4649192559074082816))), @as(f64, @bitCast(@as(i64, 4643825403014257050))), @as(f64, @bitCast(@as(i64, 4649333296562438144))), @as(f64, @bitCast(@as(i64, 4643828408463320878))), @as(f64, @bitCast(@as(i64, 4649474034050793472))), @as(f64, @bitCast(@as(i64, 4643831285137582861))), @as(f64, @bitCast(@as(i64, 4649614771539148800))), @as(f64, @bitCast(@as(i64, 4643834031981511836))), @as(f64, @bitCast(@as(i64, 4649755509027504128))), @as(f64, @bitCast(@as(i64, 4643836650050638966))), @as(f64, @bitCast(@as(i64, 4649896246515859456))), @as(f64, @bitCast(@as(i64, 4643839141631948436))), @as(f64, @bitCast(@as(i64, 4650036984004214784))), @as(f64, @bitCast(@as(i64, 4643841510771643038))), @as(f64, @bitCast(@as(i64, 4650177721492570112))), @as(f64, @bitCast(@as(i64, 4643843760460394398))), @as(f64, @bitCast(@as(i64, 4650318458980925440))), @as(f64, @bitCast(@as(i64, 4643845896151780190))), @as(f64, @bitCast(@as(i64, 4650459196469280768))), @as(f64, @bitCast(@as(i64, 4643847922771612507))), @as(f64, @bitCast(@as(i64, 4650599933957636096))), @as(f64, @bitCast(@as(i64, 4643849845245703440))), @as(f64, @bitCast(@as(i64, 4650740671445991424))), @as(f64, @bitCast(@as(i64, 4643851669027630665))), @as(f64, @bitCast(@as(i64, 4650881408934346752))), @as(f64, @bitCast(@as(i64, 4643853399219128133))), @as(f64, @bitCast(@as(i64, 4651022146422702080))), @as(f64, @bitCast(@as(i64, 4643855041625617240))), @as(f64, @bitCast(@as(i64, 4651162883911057408))), @as(f64, @bitCast(@as(i64, 4643856600117378915))), @as(f64, @bitCast(@as(i64, 4651303621399412736))), @as(f64, @bitCast(@as(i64, 4643858080499834552))), @as(f64, @bitCast(@as(i64, 4651444358887768064))), @as(f64, @bitCast(@as(i64, 4643859486115499501))), @as(f64, @bitCast(@as(i64, 4651585096376123392))), @as(f64, @bitCast(@as(i64, 4643860822593873295))), @as(f64, @bitCast(@as(i64, 4651725833864478720))), @as(f64, @bitCast(@as(i64, 4643862093277471284))), @as(f64, @bitCast(@as(i64, 4651866571352834048))), @as(f64, @bitCast(@as(i64, 4643863302916183698))), @as(f64, @bitCast(@as(i64, 4652007308841189376))), @as(f64, @bitCast(@as(i64, 4643864454500682165))), @as(f64, @bitCast(@as(i64, 4652148046329544704))), @as(f64, @bitCast(@as(i64, 4643865551901247616))), @as(f64, @bitCast(@as(i64, 4652253599445811200))), @as(f64, @bitCast(@as(i64, 4643866598284473538))), @as(f64, @bitCast(@as(i64, 4652323968189988864))), @as(f64, @bitCast(@as(i64, 4643867596113265977))), @as(f64, @bitCast(@as(i64, 4652394336934166528))), @as(f64, @bitCast(@as(i64, 4643868549257905863))), @as(f64, @bitCast(@as(i64, 4652464705678344192))), @as(f64, @bitCast(@as(i64, 4643869459125768081))), @as(f64, @bitCast(@as(i64, 4652535074422521856))), @as(f64, @bitCast(@as(i64, 4643870329587133558))), @as(f64, @bitCast(@as(i64, 4652605443166699520))), @as(f64, @bitCast(@as(i64, 4643871161697533459))), @as(f64, @bitCast(@as(i64, 4652675811910877184))), @as(f64, @bitCast(@as(i64, 4643871958975404992))), @as(f64, @bitCast(@as(i64, 4652746180655054848))), @as(f64, @bitCast(@as(i64, 4643872721772591878))), @as(f64, @bitCast(@as(i64, 4652816549399232512))), @as(f64, @bitCast(@as(i64, 4643873453607531326))), (-@as(f64, @bitCast(@as(i64, 4641240890982006784)))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4640677941028585472)))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4640114991075164160)))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4639552041121742848)))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4638989091168321536)))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4638144666238189568)))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4637018766331346944)))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4635892866424504320)))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4634766966517661696)))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4633078116657397760)))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4630826316843712512)))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4627448617123184640)))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4620693217682128896)))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4620693217682128896))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4627448617123184640))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4630826316843712512))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4633078116657397760))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4634766966517661696))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4635892866424504320))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4637018766331346944))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4638144666238189568))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4638989091168321536))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4639552041121742848))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4640114991075164160))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4640677941028585472))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4641240890982006784))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4641803840935428096))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4642366790888849408))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4642929740842270720))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4643351953307336704))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4643633428284047360))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4643914903260758016))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4644196378237468672))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4644477853214179328))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4644759328190889984))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4645040803167600640))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4645322278144311296))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4645603753121021952))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4645885228097732608))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4646166703074443264))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4646448178051153920))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4646729653027864576))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4647011128004575232))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4647292602981285888))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4647574077957996544))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4647785184190529536))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4647925921678884864))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4648066659167240192))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4648207396655595520))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4648348134143950848))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4648488871632306176))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4648629609120661504))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4648770346609016832))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4648911084097372160))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4649051821585727488))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4649192559074082816))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4649333296562438144))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4649474034050793472))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4649614771539148800))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4649755509027504128))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4649896246515859456))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4650036984004214784))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4650177721492570112))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4650318458980925440))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4650459196469280768))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4650599933957636096))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4650740671445991424))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4650881408934346752))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4651022146422702080))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4651162883911057408))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4651303621399412736))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4651444358887768064))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4651585096376123392))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4651725833864478720))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4651866571352834048))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4652007308841189376))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4652148046329544704))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4652253599445811200))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4652323968189988864))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4652394336934166528))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4652464705678344192))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4652535074422521856))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4652605443166699520))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4652675811910877184))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4652746180655054848))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), @as(f64, @bitCast(@as(i64, 4652816549399232512))), @as(f64, @bitCast(@as(i64, 4643985272004935680))), (-@as(f64, @bitCast(@as(i64, 4641240890982006784)))), @as(f64, @bitCast(@as(i64, 4643486306943220234))), (-@as(f64, @bitCast(@as(i64, 4640677941028585472)))), @as(f64, @bitCast(@as(i64, 4643440775375065658))), (-@as(f64, @bitCast(@as(i64, 4640114991075164160)))), @as(f64, @bitCast(@as(i64, 4643387480199287821))), (-@as(f64, @bitCast(@as(i64, 4639552041121742848)))), @as(f64, @bitCast(@as(i64, 4643326403120013236))), (-@as(f64, @bitCast(@as(i64, 4638989091168321536)))), @as(f64, @bitCast(@as(i64, 4643258416885591567))), (-@as(f64, @bitCast(@as(i64, 4638144666238189568)))), @as(f64, @bitCast(@as(i64, 4643159705898243326))), (-@as(f64, @bitCast(@as(i64, 4637018766331346944)))), @as(f64, @bitCast(@as(i64, 4643010042838376503))), (-@as(f64, @bitCast(@as(i64, 4635892866424504320)))), @as(f64, @bitCast(@as(i64, 4642865072670058889))), (-@as(f64, @bitCast(@as(i64, 4634766966517661696)))), @as(f64, @bitCast(@as(i64, 4642735113210405532))), (-@as(f64, @bitCast(@as(i64, 4633078116657397760)))), @as(f64, @bitCast(@as(i64, 4642631629287061581))), (-@as(f64, @bitCast(@as(i64, 4630826316843712512)))), @as(f64, @bitCast(@as(i64, 4642566100505108456))), (-@as(f64, @bitCast(@as(i64, 4627448617123184640)))), @as(f64, @bitCast(@as(i64, 4642548568836184033))), (-@as(f64, @bitCast(@as(i64, 4620693217682128896)))), @as(f64, @bitCast(@as(i64, 4642585950120466092))), @as(f64, @bitCast(@as(i64, 4620693217682128896))), @as(f64, @bitCast(@as(i64, 4642680327272782291))), @as(f64, @bitCast(@as(i64, 4627448617123184640))), @as(f64, @bitCast(@as(i64, 4642827479927700576))), @as(f64, @bitCast(@as(i64, 4630826316843712512))), @as(f64, @bitCast(@as(i64, 4643015994978602771))), @as(f64, @bitCast(@as(i64, 4633078116657397760))), @as(f64, @bitCast(@as(i64, 4643219245772301350))), @as(f64, @bitCast(@as(i64, 4634766966517661696))), @as(f64, @bitCast(@as(i64, 4643323974694651665))), @as(f64, @bitCast(@as(i64, 4635892866424504320))), @as(f64, @bitCast(@as(i64, 4643413753601379575))), @as(f64, @bitCast(@as(i64, 4637018766331346944))), @as(f64, @bitCast(@as(i64, 4643474658453152785))), @as(f64, @bitCast(@as(i64, 4638144666238189568))), @as(f64, @bitCast(@as(i64, 4643495166895877784))), @as(f64, @bitCast(@as(i64, 4638989091168321536))), @as(f64, @bitCast(@as(i64, 4643468512095192587))), @as(f64, @bitCast(@as(i64, 4639552041121742848))), @as(f64, @bitCast(@as(i64, 4643394660801865570))), @as(f64, @bitCast(@as(i64, 4640114991075164160))), @as(f64, @bitCast(@as(i64, 4643281367123739531))), @as(f64, @bitCast(@as(i64, 4640677941028585472))), @as(f64, @bitCast(@as(i64, 4643076485358472774))), @as(f64, @bitCast(@as(i64, 4641240890982006784))), @as(f64, @bitCast(@as(i64, 4642794435820965908))), @as(f64, @bitCast(@as(i64, 4641803840935428096))), @as(f64, @bitCast(@as(i64, 4642550638732794019))), @as(f64, @bitCast(@as(i64, 4642366790888849408))), @as(f64, @bitCast(@as(i64, 4642384814787139354))), @as(f64, @bitCast(@as(i64, 4642929740842270720))), @as(f64, @bitCast(@as(i64, 4642321271811146923))), @as(f64, @bitCast(@as(i64, 4643351953307336704))), @as(f64, @bitCast(@as(i64, 4642360915450554294))), @as(f64, @bitCast(@as(i64, 4643633428284047360))), @as(f64, @bitCast(@as(i64, 4642477547421904121))), @as(f64, @bitCast(@as(i64, 4643914903260758016))), @as(f64, @bitCast(@as(i64, 4642620296400811768))), @as(f64, @bitCast(@as(i64, 4644196378237468672))), @as(f64, @bitCast(@as(i64, 4642722709311869336))), @as(f64, @bitCast(@as(i64, 4644477853214179328))), @as(f64, @bitCast(@as(i64, 4642717318714221606))), @as(f64, @bitCast(@as(i64, 4644759328190889984))), @as(f64, @bitCast(@as(i64, 4642552719184715632))), @as(f64, @bitCast(@as(i64, 4645040803167600640))), @as(f64, @bitCast(@as(i64, 4642208946758784490))), @as(f64, @bitCast(@as(i64, 4645322278144311296))), @as(f64, @bitCast(@as(i64, 4641706719753932689))), @as(f64, @bitCast(@as(i64, 4645603753121021952))), @as(f64, @bitCast(@as(i64, 4641107216404504568))), @as(f64, @bitCast(@as(i64, 4645885228097732608))), @as(f64, @bitCast(@as(i64, 4640501316888074419))), @as(f64, @bitCast(@as(i64, 4646166703074443264))), @as(f64, @bitCast(@as(i64, 4639990186477865539))), @as(f64, @bitCast(@as(i64, 4646448178051153920))), @as(f64, @bitCast(@as(i64, 4639661743882853501))), @as(f64, @bitCast(@as(i64, 4646729653027864576))), @as(f64, @bitCast(@as(i64, 4639569186114418015))), @as(f64, @bitCast(@as(i64, 4647011128004575232))), @as(f64, @bitCast(@as(i64, 4639717545593298947))), @as(f64, @bitCast(@as(i64, 4647292602981285888))), @as(f64, @bitCast(@as(i64, 4640062267293589045))), @as(f64, @bitCast(@as(i64, 4647574077957996544))), @as(f64, @bitCast(@as(i64, 4640520488500581903))), @as(f64, @bitCast(@as(i64, 4647785184190529536))), @as(f64, @bitCast(@as(i64, 4640992043880908985))), @as(f64, @bitCast(@as(i64, 4647925921678884864))), @as(f64, @bitCast(@as(i64, 4641384459404940379))), @as(f64, @bitCast(@as(i64, 4648066659167240192))), @as(f64, @bitCast(@as(i64, 4641635105482983080))), @as(f64, @bitCast(@as(i64, 4648207396655595520))), @as(f64, @bitCast(@as(i64, 4641724681375884037))), @as(f64, @bitCast(@as(i64, 4648348134143950848))), @as(f64, @bitCast(@as(i64, 4641678843527770428))), @as(f64, @bitCast(@as(i64, 4648488871632306176))), @as(f64, @bitCast(@as(i64, 4641558249796123398))), @as(f64, @bitCast(@as(i64, 4648629609120661504))), @as(f64, @bitCast(@as(i64, 4641440446888870454))), @as(f64, @bitCast(@as(i64, 4648770346609016832))), @as(f64, @bitCast(@as(i64, 4641398939181429817))), @as(f64, @bitCast(@as(i64, 4648911084097372160))), @as(f64, @bitCast(@as(i64, 4641485030765962818))), @as(f64, @bitCast(@as(i64, 4649051821585727488))), @as(f64, @bitCast(@as(i64, 4641716726189354752))), @as(f64, @bitCast(@as(i64, 4649192559074082816))), @as(f64, @bitCast(@as(i64, 4642076651760511877))), @as(f64, @bitCast(@as(i64, 4649333296562438144))), @as(f64, @bitCast(@as(i64, 4642518441513895529))), @as(f64, @bitCast(@as(i64, 4649474034050793472))), @as(f64, @bitCast(@as(i64, 4642979017610912292))), @as(f64, @bitCast(@as(i64, 4649614771539148800))), @as(f64, @bitCast(@as(i64, 4643302185013017051))), @as(f64, @bitCast(@as(i64, 4649755509027504128))), @as(f64, @bitCast(@as(i64, 4643458972556388142))), @as(f64, @bitCast(@as(i64, 4649896246515859456))), @as(f64, @bitCast(@as(i64, 4643548607559034208))), @as(f64, @bitCast(@as(i64, 4650036984004214784))), @as(f64, @bitCast(@as(i64, 4643566381648282324))), @as(f64, @bitCast(@as(i64, 4650177721492570112))), @as(f64, @bitCast(@as(i64, 4643519108981474932))), @as(f64, @bitCast(@as(i64, 4650318458980925440))), @as(f64, @bitCast(@as(i64, 4643422457863190631))), @as(f64, @bitCast(@as(i64, 4650459196469280768))), @as(f64, @bitCast(@as(i64, 4643297127259529282))), @as(f64, @bitCast(@as(i64, 4650599933957636096))), @as(f64, @bitCast(@as(i64, 4643118425833690104))), @as(f64, @bitCast(@as(i64, 4650740671445991424))), @as(f64, @bitCast(@as(i64, 4642878326974868472))), @as(f64, @bitCast(@as(i64, 4650881408934346752))), @as(f64, @bitCast(@as(i64, 4642691431812457248))), @as(f64, @bitCast(@as(i64, 4651022146422702080))), @as(f64, @bitCast(@as(i64, 4642574303389617247))), @as(f64, @bitCast(@as(i64, 4651162883911057408))), @as(f64, @bitCast(@as(i64, 4642531362270857711))), @as(f64, @bitCast(@as(i64, 4651303621399412736))), @as(f64, @bitCast(@as(i64, 4642556683056075160))), @as(f64, @bitCast(@as(i64, 4651444358887768064))), @as(f64, @bitCast(@as(i64, 4642636915387124207))), @as(f64, @bitCast(@as(i64, 4651585096376123392))), @as(f64, @bitCast(@as(i64, 4642754613444948326))), @as(f64, @bitCast(@as(i64, 4651725833864478720))), @as(f64, @bitCast(@as(i64, 4642891393395131102))), @as(f64, @bitCast(@as(i64, 4651866571352834048))), @as(f64, @bitCast(@as(i64, 4643030502550746159))), @as(f64, @bitCast(@as(i64, 4652007308841189376))), @as(f64, @bitCast(@as(i64, 4643158587387054622))), @as(f64, @bitCast(@as(i64, 4652148046329544704))), @as(f64, @bitCast(@as(i64, 4643238915595517611))), @as(f64, @bitCast(@as(i64, 4652253599445811200))), @as(f64, @bitCast(@as(i64, 4643280624029801015))), @as(f64, @bitCast(@as(i64, 4652323968189988864))), @as(f64, @bitCast(@as(i64, 4643309782550404053))), @as(f64, @bitCast(@as(i64, 4652394336934166528))), @as(f64, @bitCast(@as(i64, 4643327767218119120))), @as(f64, @bitCast(@as(i64, 4652464705678344192))), @as(f64, @bitCast(@as(i64, 4643337077706661267))), @as(f64, @bitCast(@as(i64, 4652535074422521856))), @as(f64, @bitCast(@as(i64, 4643340820972007798))), @as(f64, @bitCast(@as(i64, 4652605443166699520))), @as(f64, @bitCast(@as(i64, 4643342247698296000))), @as(f64, @bitCast(@as(i64, 4652675811910877184))), @as(f64, @bitCast(@as(i64, 4643344380750853885))), @as(f64, @bitCast(@as(i64, 4652746180655054848))), @as(f64, @bitCast(@as(i64, 4643349747247206734))), @as(f64, @bitCast(@as(i64, 4652816549399232512))), @as(f64, @bitCast(@as(i64, 4643360218995949673))), @as(f64, @bitCast(@as(i64, 4645955596841910272))), @as(f64, @bitCast(@as(i64, 4640360805987075343))), @as(f64, @bitCast(@as(i64, 4646237071818620928))), @as(f64, @bitCast(@as(i64, 4639888136317684207))), @as(f64, @bitCast(@as(i64, 4646518546795331584))), @as(f64, @bitCast(@as(i64, 4639615412749843206))), @as(f64, @bitCast(@as(i64, 4646800021772042240))), @as(f64, @bitCast(@as(i64, 4639584627479796641))), @as(f64, @bitCast(@as(i64, 4647081496748752896))), @as(f64, @bitCast(@as(i64, 4639788033964341713))), @as(f64, @bitCast(@as(i64, 4647362971725463552))), @as(f64, @bitCast(@as(i64, 4640169988119019934))), @as(f64, @bitCast(@as(i64, 4647327787353374720))), @as(f64, @bitCast(@as(i64, 4640515883218119195))), @as(f64, @bitCast(@as(i64, 4647046312376664064))), @as(f64, @bitCast(@as(i64, 4640670507626294264))), @as(f64, @bitCast(@as(i64, 4646764837399953408))), @as(f64, @bitCast(@as(i64, 4640745385951442554))), @as(f64, @bitCast(@as(i64, 4646483362423242752))), @as(f64, @bitCast(@as(i64, 4640719195408547069))), @as(f64, @bitCast(@as(i64, 4646201887446532096))), @as(f64, @bitCast(@as(i64, 4640591357566530670))), (-@as(f64, @bitCast(@as(i64, 4641240890982006784)))), @as(f64, @bitCast(@as(i64, 4643472101252989368))), (-@as(f64, @bitCast(@as(i64, 4640677941028585472)))), @as(f64, @bitCast(@as(i64, 4643471286382931791))), (-@as(f64, @bitCast(@as(i64, 4640114991075164160)))), @as(f64, @bitCast(@as(i64, 4643470475383155143))), (-@as(f64, @bitCast(@as(i64, 4639552041121742848)))), @as(f64, @bitCast(@as(i64, 4643469670364721751))), (-@as(f64, @bitCast(@as(i64, 4638989091168321536)))), @as(f64, @bitCast(@as(i64, 4643468872031319055))), (-@as(f64, @bitCast(@as(i64, 4638144666238189568)))), @as(f64, @bitCast(@as(i64, 4643468082845853103))), (-@as(f64, @bitCast(@as(i64, 4637018766331346944)))), @as(f64, @bitCast(@as(i64, 4643467303512011335))), (-@as(f64, @bitCast(@as(i64, 4635892866424504320)))), @as(f64, @bitCast(@as(i64, 4643466535437168636))), (-@as(f64, @bitCast(@as(i64, 4634766966517661696)))), @as(f64, @bitCast(@as(i64, 4643465782315684075))), (-@as(f64, @bitCast(@as(i64, 4633078116657397760)))), @as(f64, @bitCast(@as(i64, 4643465044675323232))), (-@as(f64, @bitCast(@as(i64, 4630826316843712512)))), @as(f64, @bitCast(@as(i64, 4643464325154914016))), (-@as(f64, @bitCast(@as(i64, 4627448617123184640)))), @as(f64, @bitCast(@as(i64, 4643463626217362471))), (-@as(f64, @bitCast(@as(i64, 4620693217682128896)))), @as(f64, @bitCast(@as(i64, 4643462949797809063))), @as(f64, @bitCast(@as(i64, 4620693217682128896))), @as(f64, @bitCast(@as(i64, 4643462299062847280))), @as(f64, @bitCast(@as(i64, 4627448617123184640))), @as(f64, @bitCast(@as(i64, 4643461676299461308))), @as(f64, @bitCast(@as(i64, 4630826316843712512))), @as(f64, @bitCast(@as(i64, 4643461084146479053))), @as(f64, @bitCast(@as(i64, 4633078116657397760))), @as(f64, @bitCast(@as(i64, 4643460525770494003))), @as(f64, @bitCast(@as(i64, 4634766966517661696))), @as(f64, @bitCast(@as(i64, 4643460003986255926))), @as(f64, @bitCast(@as(i64, 4635892866424504320))), @as(f64, @bitCast(@as(i64, 4643459522488123890))), @as(f64, @bitCast(@as(i64, 4637018766331346944))), @as(f64, @bitCast(@as(i64, 4643459083739003942))), @as(f64, @bitCast(@as(i64, 4638144666238189568))), @as(f64, @bitCast(@as(i64, 4643458691257333291))), @as(f64, @bitCast(@as(i64, 4638989091168321536))), @as(f64, @bitCast(@as(i64, 4643458349089314728))), @as(f64, @bitCast(@as(i64, 4639552041121742848))), @as(f64, @bitCast(@as(i64, 4643458060577463599))), @as(f64, @bitCast(@as(i64, 4640114991075164160))), @as(f64, @bitCast(@as(i64, 4643457828008764092))), @as(f64, @bitCast(@as(i64, 4640677941028585472))), @as(f64, @bitCast(@as(i64, 4643457655957184578))), @as(f64, @bitCast(@as(i64, 4641240890982006784))), @as(f64, @bitCast(@as(i64, 4643457547765240404))), @as(f64, @bitCast(@as(i64, 4641803840935428096))), @as(f64, @bitCast(@as(i64, 4643457506423603200))), @as(f64, @bitCast(@as(i64, 4642366790888849408))), @as(f64, @bitCast(@as(i64, 4643457535978475755))), @as(f64, @bitCast(@as(i64, 4642929740842270720))), @as(f64, @bitCast(@as(i64, 4643457639596451556))), @as(f64, @bitCast(@as(i64, 4643351953307336704))), @as(f64, @bitCast(@as(i64, 4643457819564514791))), @as(f64, @bitCast(@as(i64, 4643633428284047360))), @as(f64, @bitCast(@as(i64, 4643458079928868248))), @as(f64, @bitCast(@as(i64, 4643914903260758016))), @as(f64, @bitCast(@as(i64, 4643458422272808672))), @as(f64, @bitCast(@as(i64, 4644196378237468672))), @as(f64, @bitCast(@as(i64, 4643458850466616993))), @as(f64, @bitCast(@as(i64, 4644477853214179328))), @as(f64, @bitCast(@as(i64, 4643459365565824374))), @as(f64, @bitCast(@as(i64, 4644759328190889984))), @as(f64, @bitCast(@as(i64, 4643459970737024302))), @as(f64, @bitCast(@as(i64, 4645040803167600640))), @as(f64, @bitCast(@as(i64, 4643460666507982358))), @as(f64, @bitCast(@as(i64, 4645322278144311296))), @as(f64, @bitCast(@as(i64, 4643461454110151567))), @as(f64, @bitCast(@as(i64, 4645603753121021952))), @as(f64, @bitCast(@as(i64, 4643462335126828671))), @as(f64, @bitCast(@as(i64, 4645885228097732608))), @as(f64, @bitCast(@as(i64, 4643463310085779253))), @as(f64, @bitCast(@as(i64, 4646166703074443264))), @as(f64, @bitCast(@as(i64, 4643464377931472149))), @as(f64, @bitCast(@as(i64, 4646448178051153920))), @as(f64, @bitCast(@as(i64, 4643465539015751080))), @as(f64, @bitCast(@as(i64, 4646729653027864576))), @as(f64, @bitCast(@as(i64, 4643466792634928605))), @as(f64, @bitCast(@as(i64, 4647011128004575232))), @as(f64, @bitCast(@as(i64, 4643468137029786120))), @as(f64, @bitCast(@as(i64, 4647292602981285888))), @as(f64, @bitCast(@as(i64, 4643469570441105019))), @as(f64, @bitCast(@as(i64, 4647574077957996544))), @as(f64, @bitCast(@as(i64, 4643471091461510419))), @as(f64, @bitCast(@as(i64, 4647785184190529536))), @as(f64, @bitCast(@as(i64, 4643472696044799530))), @as(f64, @bitCast(@as(i64, 4647925921678884864))), @as(f64, @bitCast(@as(i64, 4643474382607675608))), @as(f64, @bitCast(@as(i64, 4648066659167240192))), @as(f64, @bitCast(@as(i64, 4643476146576170282))), @as(f64, @bitCast(@as(i64, 4648207396655595520))), @as(f64, @bitCast(@as(i64, 4643477984783690063))), @as(f64, @bitCast(@as(i64, 4648348134143950848))), @as(f64, @bitCast(@as(i64, 4643479893887719603))), @as(f64, @bitCast(@as(i64, 4648488871632306176))), @as(f64, @bitCast(@as(i64, 4643481869138368670))), @as(f64, @bitCast(@as(i64, 4648629609120661504))), @as(f64, @bitCast(@as(i64, 4643483905257981451))), @as(f64, @bitCast(@as(i64, 4648770346609016832))), @as(f64, @bitCast(@as(i64, 4643485999255886317))), @as(f64, @bitCast(@as(i64, 4648911084097372160))), @as(f64, @bitCast(@as(i64, 4643488144974818155))), @as(f64, @bitCast(@as(i64, 4649051821585727488))), @as(f64, @bitCast(@as(i64, 4643490338720417894))), @as(f64, @bitCast(@as(i64, 4649192559074082816))), @as(f64, @bitCast(@as(i64, 4643492574687264139))), @as(f64, @bitCast(@as(i64, 4649333296562438144))), @as(f64, @bitCast(@as(i64, 4643494848477310380))), @as(f64, @bitCast(@as(i64, 4649474034050793472))), @as(f64, @bitCast(@as(i64, 4643497154812900803))), @as(f64, @bitCast(@as(i64, 4649614771539148800))), @as(f64, @bitCast(@as(i64, 4643499489120067036))), @as(f64, @bitCast(@as(i64, 4649755509027504128))), @as(f64, @bitCast(@as(i64, 4643501847176684430))), @as(f64, @bitCast(@as(i64, 4649896246515859456))), @as(f64, @bitCast(@as(i64, 4643504223353253449))), @as(f64, @bitCast(@as(i64, 4650036984004214784))), @as(f64, @bitCast(@as(i64, 4643506614483180606))), @as(f64, @bitCast(@as(i64, 4650177721492570112))), @as(f64, @bitCast(@as(i64, 4643509015464731948))), @as(f64, @bitCast(@as(i64, 4650318458980925440))), @as(f64, @bitCast(@as(i64, 4643511422251704684))), @as(f64, @bitCast(@as(i64, 4650459196469280768))), @as(f64, @bitCast(@as(i64, 4643513831325661607))), @as(f64, @bitCast(@as(i64, 4650599933957636096))), @as(f64, @bitCast(@as(i64, 4643516238992243645))), @as(f64, @bitCast(@as(i64, 4650740671445991424))), @as(f64, @bitCast(@as(i64, 4643518641557091731))), @as(f64, @bitCast(@as(i64, 4650881408934346752))), @as(f64, @bitCast(@as(i64, 4643521036557299818))), @as(f64, @bitCast(@as(i64, 4651022146422702080))), @as(f64, @bitCast(@as(i64, 4643523419594821395))), @as(f64, @bitCast(@as(i64, 4651162883911057408))), @as(f64, @bitCast(@as(i64, 4643525789965969019))), @as(f64, @bitCast(@as(i64, 4651303621399412736))), @as(f64, @bitCast(@as(i64, 4643528143096774320))), @as(f64, @bitCast(@as(i64, 4651444358887768064))), @as(f64, @bitCast(@as(i64, 4643530477931706135))), @as(f64, @bitCast(@as(i64, 4651585096376123392))), @as(f64, @bitCast(@as(i64, 4643532791831936557))), @as(f64, @bitCast(@as(i64, 4651725833864478720))), @as(f64, @bitCast(@as(i64, 4643535083214168843))), @as(f64, @bitCast(@as(i64, 4651866571352834048))), @as(f64, @bitCast(@as(i64, 4643537350319184386))), @as(f64, @bitCast(@as(i64, 4652007308841189376))), @as(f64, @bitCast(@as(i64, 4643539591915530166))), @as(f64, @bitCast(@as(i64, 4652148046329544704))), @as(f64, @bitCast(@as(i64, 4643541805892143856))), @as(f64, @bitCast(@as(i64, 4652253599445811200))), @as(f64, @bitCast(@as(i64, 4643543992073103595))), @as(f64, @bitCast(@as(i64, 4652323968189988864))), @as(f64, @bitCast(@as(i64, 4643546148699190780))), @as(f64, @bitCast(@as(i64, 4652394336934166528))), @as(f64, @bitCast(@as(i64, 4643548275066717969))), @as(f64, @bitCast(@as(i64, 4652464705678344192))), @as(f64, @bitCast(@as(i64, 4643550371175685161))), @as(f64, @bitCast(@as(i64, 4652535074422521856))), @as(f64, @bitCast(@as(i64, 4643552435618717473))), @as(f64, @bitCast(@as(i64, 4652605443166699520))), @as(f64, @bitCast(@as(i64, 4643554467516205603))), @as(f64, @bitCast(@as(i64, 4652675811910877184))), @as(f64, @bitCast(@as(i64, 4643556467747758853))), @as(f64, @bitCast(@as(i64, 4652746180655054848))), @as(f64, @bitCast(@as(i64, 4643558435961533503))), @as(f64, @bitCast(@as(i64, 4652816549399232512))), @as(f64, @bitCast(@as(i64, 4643560371453842109))) });
}

fn bearings() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4596373779694328218))), (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4596373779694328218)))), @as(f64, @bitCast(@as(i64, 4602678819172646912))), @as(f64, @bitCast(@as(i64, 4606641986844732948))), (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4606641986844732948)))), @as(f64, @bitCast(@as(i64, 4606822130829827768))), (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4606822130829827768)))), (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4611779693299637210)))), (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4610334938539176755)))), (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4612586738352862003)))), (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4613397386285788692)))), (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4608623570680775967)))), (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4612176010066845814)))), @as(f64, @bitCast(@as(i64, 4613937818241073152))), (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4613937818241073152)))), @as(f64, @bitCast(@as(i64, 4614253070214989087))), (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4614253070214989087)))), @as(f64, @bitCast(@as(i64, 4609434218613702656))), (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4609434218613702656)))) });
}

fn crests(bs: *CxList(f64), i_: i64) *CxList(f64) {
    return (if ((i_ >= cx_list_len(bs))) cx_ll_empty(f64) else cx_ll_concat(cx_ll_of(f64, &[_]f64{ horizon_crest_px(cx_list_at(bs, i_)) }), crests(bs, (i_ +% 1))));
}

fn dusks() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4591870180066957722))), @as(f64, @bitCast(@as(i64, 4598175219545276416))), @as(f64, @bitCast(@as(i64, 4602678819172646912))), @as(f64, @bitCast(@as(i64, 4604930618986332160))), @as(f64, @bitCast(@as(i64, 4606281698874543309))), @as(f64, @bitCast(@as(i64, 4607182418800017408))) });
}

fn rocks(ds: *CxList(f64), i_: i64) *CxList(i64) {
    return (if ((i_ >= cx_list_len(ds))) cx_ll_empty(i64) else cx_ll_concat(cx_ll_of(i64, &[_]i64{ dimmed(rock_west(), cx_list_at(ds, i_)) }), rocks(ds, (i_ +% 1))));
}

fn steps() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4656510908468559872))), @as(f64, @bitCast(@as(i64, 4659914996468154368))), @as(f64, @bitCast(@as(i64, 4660794605770375168))), @as(f64, @bitCast(@as(i64, 4661014508095930368))), @as(f64, @bitCast(@as(i64, 4661449914700529664))), @as(f64, @bitCast(@as(i64, 4662219572839972864))), @as(f64, @bitCast(@as(i64, 4665518107723300864))) });
}

fn behinds(ss: *CxList(f64), i_: i64) *CxList(bool) {
    return (if ((i_ >= cx_list_len(ss))) cx_ll_empty(bool) else cx_ll_concat(cx_ll_of(bool, &[_]bool{ sun_behind_mountains(cx_list_at(ss, i_)) }), behinds(ss, (i_ +% 1))));
}

fn frame_1() *CxList(DrawCmd) {
    return draw(@as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), focal(), camera_w());
}

fn frame_2() *CxList(DrawCmd) {
    return draw((@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4611779693299637210)))), @as(f64, @bitCast(@as(i64, 4599976659396224614))), focal(), camera_w());
}

fn frame_3() *CxList(DrawCmd) {
    return draw(@as(f64, @bitCast(@as(i64, 4603579539098121011))), @as(f64, @bitCast(@as(i64, 4603579539098121011))), (focal() * @as(f64, @bitCast(@as(i64, 4601778099247172813)))), camera_w());
}

fn frame_4() *CxList(DrawCmd) {
    return draw(@as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4607182418800017408))), focal(), camera_w());
}

fn all_cmds() *CxList(DrawCmd) {
    return cx_ll_concat(cx_ll_concat(cx_ll_concat(frame_1(), frame_2()), frame_3()), frame_4());
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

fn stride_pts(ps: *CxList(f64), i_: i64) *CxList(f64) {
    return (if (((i_ *% 2) >= cx_list_len(ps))) cx_ll_empty(f64) else cx_ll_concat(cx_ll_of(f64, &[_]f64{ cx_list_at(ps, (i_ *% 2)), cx_list_at(ps, ((i_ *% 2) +% 1)) }), stride_pts(ps, (i_ +% 8))));
}

fn cmd_coords(cs: *CxList(DrawCmd), i_: i64) *CxList(f64) {
    return (if ((i_ >= cx_list_len(cs))) cx_ll_empty(f64) else cx_ll_concat(stride_pts(cx_list_at(cs, i_).pts, 0), cmd_coords(cs, (i_ +% 1))));
}

fn opening() void {
    return b0: { _ = cx_print_line(grade_rel("\x1a\x0e\x49\x18\x15\x0d\x13\x0e\x02\x02\x02\x02\x02\x02", crests(bearings(), 0), g_mt_crest(), @as(f64, @bitCast(@as(i64, 4517329193108106637))))); _ = cx_print_line(grade_ints("\x1a\x0e\x49\x15\x10\x18\x22\x02\x02\x02\x02\x02\x02\x02", rocks(dusks(), 0), g_mt_rock())); _ = cx_print_line(grade_bools("\x1a\x0e\x49\x13\x19\x12\x49\x20\x0d\x14\x11\x12\x16\x02", behinds(steps(), 0), g_mt_sun_behind())); _ = cx_print_line(grade_ints("\x1a\x0e\x49\x0e\x0f\x1d\x13\x02\x02\x02\x02\x02\x02\x02", cmd_tags(all_cmds(), 0), g_mt_tags())); _ = cx_print_line(grade_ints("\x1a\x0e\x49\x18\x10\x17\x10\x15\x13\x02\x02\x02\x02\x02", cmd_colors(all_cmds(), 0), g_mt_colors())); _ = cx_print_line(grade_ints("\x1a\x0e\x49\x18\x10\x19\x12\x0e\x13\x02\x02\x02\x02\x02", cmd_counts(all_cmds(), 0), g_mt_counts())); _ = cx_print_line(grade_px("\x1a\x0e\x49\x18\x10\x10\x15\x16\x13\x02\x02\x02\x02\x02", cmd_coords(all_cmds(), 0), g_mt_coords(), @as(f64, @bitCast(@as(i64, 4562254508917369340))), @as(f64, @bitCast(@as(i64, 4517329193108106637))))); break :b0; };
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


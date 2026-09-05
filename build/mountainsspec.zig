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

const DrawCmdS = struct {
    tag: i64,
    color: i64,
    color2: i64,
    strength: f64,
    geom: *CxList(f64),
    pts: *CxList(f64),
};
const DrawCmd = *DrawCmdS;

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

fn two_pi() f64 {
    return dm_two_pi();
}

fn half_pi() f64 {
    return dm_half_pi();
}

fn deg() f64 {
    return @as(f64, @bitCast(@as(i64, 4580687790476533049)));
}

fn wrap(x: f64, fuel: i64) f64 {
    var _tl_x = x;
    var _tl_fuel = fuel;
    while (true) {
        if ((_tl_fuel <= 0)) { return _tl_x; } else { if ((_tl_x > pi())) { { const _tj2_0 = (_tl_x - two_pi()); const _tj2_1 = (_tl_fuel -% 1); _tl_x = _tj2_0; _tl_fuel = _tj2_1; continue; } } else { if ((_tl_x < (@as(f64, @bitCast(@as(i64, 0))) - pi()))) { { const _tj3_0 = (_tl_x + two_pi()); const _tj3_1 = (_tl_fuel -% 1); _tl_x = _tj3_0; _tl_fuel = _tj3_1; continue; } } else { return _tl_x; } } }
    }
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

fn camera_w() f64 {
    return @as(f64, @bitCast(@as(i64, 4651655465120301056)));
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

fn round_real(x: f64) f64 {
    return b0: { const t: f64 = cx_real_from_int(cx_real_to_int(x)); break :b0 b1: { const f: f64 = (x - t); break :b1 (if ((f >= @as(f64, @bitCast(@as(i64, 4602678819172646912))))) (t + @as(f64, @bitCast(@as(i64, 4607182418800017408)))) else (if ((f <= (@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4602678819172646912)))))) (t - @as(f64, @bitCast(@as(i64, 4607182418800017408)))) else t)); }; };
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

fn snow_color(dusk: f64) i64 {
    return pack(lerp3(snow_day(), snow_night(), dusk));
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

fn palette_got() *CxList(i64) {
    return cx_ll_of(i64, &[_]i64{ rock(), rock_west(), land() });
}

fn palette_want() *CxList(i64) {
    return cx_ll_of(i64, &[_]i64{ 5991055, 3752799, 4886339 });
}

fn chan_got() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ chan(rock(), 16), chan(rock(), 8), chan(rock(), 0), chan(16777215, 16), chan(0, 0) });
}

fn chan_want() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ @as(f64, @bitCast(@as(i64, 4636103972657037312))), @as(f64, @bitCast(@as(i64, 4637159503819702272))), @as(f64, @bitCast(@as(i64, 4639235381772943360))), @as(f64, @bitCast(@as(i64, 4643176031446892544))), @as(f64, @bitCast(@as(i64, 0))) });
}

fn dim_got() *CxList(i64) {
    return cx_ll_of(i64, &[_]i64{ dimmed(rock(), @as(f64, @bitCast(@as(i64, 0)))), dimmed(rock_west(), @as(f64, @bitCast(@as(i64, 0)))), dimmed(land(), @as(f64, @bitCast(@as(i64, 0)))), dimmed(rock(), @as(f64, @bitCast(@as(i64, 4607182418800017408)))), dimmed(rock_west(), @as(f64, @bitCast(@as(i64, 4607182418800017408)))), dimmed(land(), @as(f64, @bitCast(@as(i64, 4607182418800017408)))), dimmed(rock(), @as(f64, @bitCast(@as(i64, 4602678819172646912)))) });
}

fn dim_want() *CxList(i64) {
    return cx_ll_of(i64, &[_]i64{ 5991055, 3752799, 4886339, 3028296, 1909296, 2443298, 4477035 });
}

fn snow_got() *CxList(i64) {
    return cx_ll_of(i64, &[_]i64{ snow_color(@as(f64, @bitCast(@as(i64, 0)))), snow_color(@as(f64, @bitCast(@as(i64, 4607182418800017408)))), snow_color(@as(f64, @bitCast(@as(i64, 4602678819172646912)))), pack(snow_day()), pack(snow_night()) });
}

fn snow_want() *CxList(i64) {
    return cx_ll_of(i64, &[_]i64{ 15660024, 4609128, 10134704, 15660024, 4609128 });
}

fn night_order_got() *CxList(bool) {
    return cx_ll_of(bool, &[_]bool{ (snow_color(@as(f64, @bitCast(@as(i64, 4607182418800017408)))) > dimmed(rock(), @as(f64, @bitCast(@as(i64, 4607182418800017408))))), (snow_color(@as(f64, @bitCast(@as(i64, 0)))) > dimmed(rock(), @as(f64, @bitCast(@as(i64, 0))))) });
}

fn night_order_want() *CxList(bool) {
    return cx_ll_of(bool, &[_]bool{ true, true });
}

fn north_edge_got() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ north_range(@as(f64, @bitCast(@as(i64, 4606732058837280358)))), north_range(@as(f64, @bitCast(@as(i64, 4607182418800017408)))), north_range(@as(f64, @bitCast(@as(i64, 4611686018427387904)))), north_range((@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4606732058837280358))))), north_range((@as(f64, @bitCast(@as(i64, 0))) - @as(f64, @bitCast(@as(i64, 4613937818241073152))))) });
}

fn north_edge_want() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))) });
}

fn west_edge_got() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ west_range((west_range_bearing() + @as(f64, @bitCast(@as(i64, 4605380978949069210))))), west_range((west_range_bearing() - @as(f64, @bitCast(@as(i64, 4605380978949069210))))), west_range(@as(f64, @bitCast(@as(i64, 0)))), west_range(@as(f64, @bitCast(@as(i64, 4609434218613702656)))) });
}

fn west_edge_want() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))) });
}

fn inside_got() *CxList(bool) {
    return cx_ll_of(bool, &[_]bool{ (north_range(@as(f64, @bitCast(@as(i64, 0)))) > @as(f64, @bitCast(@as(i64, 0)))), (north_range(@as(f64, @bitCast(@as(i64, 4606641986844732948)))) > @as(f64, @bitCast(@as(i64, 0)))), (north_range(@as(f64, @bitCast(@as(i64, 0)))) > snow_threshold()), (north_range(@as(f64, @bitCast(@as(i64, 4606281698874543309)))) > snow_threshold()), (west_range(west_range_bearing()) > @as(f64, @bitCast(@as(i64, 0)))) });
}

fn inside_want() *CxList(bool) {
    return cx_ll_of(bool, &[_]bool{ true, true, true, false, true });
}

fn shape_got() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ west_range_bearing(), snow_threshold(), snow_dip(), col_step(), roll_margin(), rock_night_dim() });
}

fn shape_want() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ (-@as(f64, @bitCast(@as(i64, 4611779693299637210)))), @as(f64, @bitCast(@as(i64, 4638426141214900224))), @as(f64, @bitCast(@as(i64, 4621819117588971520))), @as(f64, @bitCast(@as(i64, 4611686018427387904))), @as(f64, @bitCast(@as(i64, 4641240890982006784))), @as(f64, @bitCast(@as(i64, 4602678819172646912))) });
}

fn snowline_got() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ snowline_at(@as(f64, @bitCast(@as(i64, 4606281698874543309))), snow_peak_height()), snowline_at(@as(f64, @bitCast(@as(i64, 4611686018427387904))), snow_peak_height()) });
}

fn snowline_want() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ @as(f64, @bitCast(@as(i64, 4638426141214900224))), @as(f64, @bitCast(@as(i64, 4638426141214900224))) });
}

fn band_got() *CxList(bool) {
    return cx_ll_of(bool, &[_]bool{ (snowline_at(@as(f64, @bitCast(@as(i64, 0))), snow_peak_height()) < snow_threshold()), (snowline_at(@as(f64, @bitCast(@as(i64, 0))), snow_peak_height()) > (snow_threshold() - snow_dip())), (snowline_at(@as(f64, @bitCast(@as(i64, 4602678819172646912))), snow_peak_height()) <= snow_threshold()), (snowline_at(@as(f64, @bitCast(@as(i64, 4602678819172646912))), snow_peak_height()) >= (snow_threshold() - snow_dip())) });
}

fn band_want() *CxList(bool) {
    return cx_ll_of(bool, &[_]bool{ true, true, true, true });
}

fn peak_got() *CxList(bool) {
    return cx_ll_of(bool, &[_]bool{ (snow_peak_height() > snow_threshold()), (snow_peak_height() < @as(f64, @bitCast(@as(i64, 4639481672377565184)))) });
}

fn peak_want() *CxList(bool) {
    return cx_ll_of(bool, &[_]bool{ true, true });
}

fn bearing_got() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ bearing_at(@as(f64, @bitCast(@as(i64, 4647151865492930560))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4647503709213818880))), @as(f64, @bitCast(@as(i64, 4651655465120301056)))), bearing_at(@as(f64, @bitCast(@as(i64, 4647151865492930560))), @as(f64, @bitCast(@as(i64, 4608308318706860032))), @as(f64, @bitCast(@as(i64, 4647503709213818880))), @as(f64, @bitCast(@as(i64, 4651655465120301056)))), bearing_at(@as(f64, @bitCast(@as(i64, 4647151865492930560))), @as(f64, @bitCast(@as(i64, 4608308318706860032))), @as(f64, @bitCast(@as(i64, 4636737291354636288))), @as(f64, @bitCast(@as(i64, 4651655465120301056)))) });
}

fn bearing_want() *CxList(f64) {
    return cx_ll_of(f64, &[_]f64{ @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4608308318706860032))), @as(f64, @bitCast(@as(i64, 4608308318706860032))) });
}

fn spread_got() *CxList(bool) {
    return cx_ll_of(bool, &[_]bool{ (bearing_at(@as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4647503709213818880))), @as(f64, @bitCast(@as(i64, 4651655465120301056)))) < bearing_at(@as(f64, @bitCast(@as(i64, 4647151865492930560))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4647503709213818880))), @as(f64, @bitCast(@as(i64, 4651655465120301056))))), (bearing_at(@as(f64, @bitCast(@as(i64, 4647151865492930560))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4647503709213818880))), @as(f64, @bitCast(@as(i64, 4651655465120301056)))) < bearing_at(@as(f64, @bitCast(@as(i64, 4651655465120301056))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4647503709213818880))), @as(f64, @bitCast(@as(i64, 4651655465120301056))))), (bearing_at(@as(f64, @bitCast(@as(i64, 4651655465120301056))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4636737291354636288))), @as(f64, @bitCast(@as(i64, 4651655465120301056)))) > bearing_at(@as(f64, @bitCast(@as(i64, 4651655465120301056))), @as(f64, @bitCast(@as(i64, 0))), @as(f64, @bitCast(@as(i64, 4647503709213818880))), @as(f64, @bitCast(@as(i64, 4651655465120301056))))) });
}

fn spread_want() *CxList(bool) {
    return cx_ll_of(bool, &[_]bool{ true, true, true });
}

fn crest_got() *CxList(bool) {
    return cx_ll_of(bool, &[_]bool{ (horizon_crest_px(@as(f64, @bitCast(@as(i64, 0)))) >= ground_base(@as(f64, @bitCast(@as(i64, 0))))), (horizon_crest_px(@as(f64, @bitCast(@as(i64, 4611686018427387904)))) >= ground_base(@as(f64, @bitCast(@as(i64, 4611686018427387904))))), (horizon_crest_px(@as(f64, @bitCast(@as(i64, 0)))) >= north_range(@as(f64, @bitCast(@as(i64, 0))))), sun_behind_mountains(@as(f64, @bitCast(@as(i64, 0)))), sun_behind_mountains(@as(f64, @bitCast(@as(i64, 4663319084467748864)))) });
}

fn crest_want() *CxList(bool) {
    return cx_ll_of(bool, &[_]bool{ true, true, true, false, true });
}

fn opening() void {
    return b0: { _ = cx_print_line(grade_ints("\x1a\x0e\x49\x1f\x0f\x17\x02\x02\x02", palette_got(), palette_want())); _ = cx_print_line(grade_reals("\x1a\x0e\x49\x18\x14\x0f\x12\x02\x02", chan_got(), chan_want(), @as(f64, @bitCast(@as(i64, 0))))); _ = cx_print_line(grade_ints("\x1a\x0e\x49\x16\x11\x1a\x02\x02\x02", dim_got(), dim_want())); _ = cx_print_line(grade_ints("\x1a\x0e\x49\x13\x12\x10\x1b\x02\x02", snow_got(), snow_want())); _ = cx_print_line(grade_bools("\x1a\x0e\x49\x10\x15\x16\x0d\x15\x02", night_order_got(), night_order_want())); _ = cx_print_line(grade_reals("\x1a\x0e\x49\x12\x10\x15\x0e\x14\x02", north_edge_got(), north_edge_want(), @as(f64, @bitCast(@as(i64, 0))))); _ = cx_print_line(grade_reals("\x1a\x0e\x49\x1b\x0d\x13\x0e\x02\x02", west_edge_got(), west_edge_want(), @as(f64, @bitCast(@as(i64, 0))))); _ = cx_print_line(grade_bools("\x1a\x0e\x49\x11\x12\x13\x11\x16\x0d", inside_got(), inside_want())); _ = cx_print_line(grade_reals("\x1a\x0e\x49\x13\x14\x0f\x1f\x0d\x02", shape_got(), shape_want(), @as(f64, @bitCast(@as(i64, 0))))); _ = cx_print_line(grade_reals("\x1a\x0e\x49\x13\x12\x10\x1b\x17\x12", snowline_got(), snowline_want(), @as(f64, @bitCast(@as(i64, 0))))); _ = cx_print_line(grade_bools("\x1a\x0e\x49\x20\x0f\x12\x16\x02\x02", band_got(), band_want())); _ = cx_print_line(grade_bools("\x1a\x0e\x49\x1f\x0d\x0f\x22\x02\x02", peak_got(), peak_want())); _ = cx_print_line(grade_reals("\x1a\x0e\x49\x20\x0d\x0f\x15\x02\x02", bearing_got(), bearing_want(), @as(f64, @bitCast(@as(i64, 0))))); _ = cx_print_line(grade_bools("\x1a\x0e\x49\x13\x1f\x15\x0d\x0f\x16", spread_got(), spread_want())); _ = cx_print_line(grade_bools("\x1a\x0e\x49\x18\x15\x0d\x13\x0e\x02", crest_got(), crest_want())); break :b0; };
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


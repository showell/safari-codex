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

fn first_int_diff(_arg_got: *CxList(i64), _arg_want: *CxList(i64), i_: i64) i64 {
    var _tl_i = i_;
    while (true) {
        if ((_tl_i >= cx_list_len(_arg_got))) { return (0 -% 1); } else { if ((cx_list_at(_arg_got, _tl_i) != cx_list_at(_arg_want, _tl_i))) { return _tl_i; } else { { const _tj2_2 = (_tl_i +% 1); _tl_i = _tj2_2; continue; } } }
    }
}

fn grade_ints(name: []const u8, _arg_got: *CxList(i64), _arg_want: *CxList(i64)) []const u8 {
    return (if ((cx_list_len(_arg_got) != cx_list_len(_arg_want))) cx_concat(cx_concat(cx_concat(cx_concat(name, "\x02\x3a\x29\x30\x02\x17\x0d\x12\x1d\x0e\x14\x02"), cx_show_int(cx_list_len(_arg_got))), "\x02\x1b\x0f\x12\x0e\x02"), cx_show_int(cx_list_len(_arg_want))) else b1: { const i_: i64 = first_int_diff(_arg_got, _arg_want, 0); break :b1 (if ((i_ < 0)) cx_concat(cx_concat(name, "\x02\x10\x22\x02"), cx_show_int(cx_list_len(_arg_got))) else cx_concat(cx_concat(cx_concat(cx_concat(cx_concat(cx_concat(name, "\x02\x3a\x29\x30\x02\x0f\x0e\x02"), cx_show_int(i_)), "\x02\x1d\x10\x0e\x02"), cx_show_int(cx_list_at(_arg_got, i_))), "\x02\x1b\x0f\x12\x0e\x02"), cx_show_int(cx_list_at(_arg_want, i_)))); });
}

fn lits() *CxList(f64) {
    @setEvalBranchQuota(1000000);
    return cx_ll_of(f64, &[_]f64{ (-@as(f64, @bitCast(@as(i64, 4644905949743581666)))), (-@as(f64, @bitCast(@as(i64, 4649353542108863072)))), @as(f64, @bitCast(@as(i64, 4644018150852076876))), (-@as(f64, @bitCast(@as(i64, 4650732996209767314)))), @as(f64, @bitCast(@as(i64, 4634750360100148384))), (-@as(f64, @bitCast(@as(i64, 4643433267314612502)))), (-@as(f64, @bitCast(@as(i64, 4650986980966176646)))), @as(f64, @bitCast(@as(i64, 4624561509360033280))), (-@as(f64, @bitCast(@as(i64, 4651347678242020102)))), (-@as(f64, @bitCast(@as(i64, 4638873286475685744)))), (-@as(f64, @bitCast(@as(i64, 4650778399233453196)))), (-@as(f64, @bitCast(@as(i64, 4650411468633794511)))), (-@as(f64, @bitCast(@as(i64, 4639515506433793464)))), @as(f64, @bitCast(@as(i64, 4648961259205224522))), (-@as(f64, @bitCast(@as(i64, 4649829361707981249)))), (-@as(f64, @bitCast(@as(i64, 4648080047443459978)))), @as(f64, @bitCast(@as(i64, 4643171332391434656))), @as(f64, @bitCast(@as(i64, 4651087394828433756))), @as(f64, @bitCast(@as(i64, 4639629654230848720))), (-@as(f64, @bitCast(@as(i64, 4641474481812097304)))), @as(f64, @bitCast(@as(i64, 4651589584241175012))), (-@as(f64, @bitCast(@as(i64, 4651187817657314196)))), @as(f64, @bitCast(@as(i64, 4649517459641620864))), (-@as(f64, @bitCast(@as(i64, 4646110081345352094)))), (-@as(f64, @bitCast(@as(i64, 4649469546576912596)))), (-@as(f64, @bitCast(@as(i64, 4649935085874326577)))), (-@as(f64, @bitCast(@as(i64, 4645446062954182798)))), @as(f64, @bitCast(@as(i64, 4648772569542164834))), (-@as(f64, @bitCast(@as(i64, 4648827936742433659)))), @as(f64, @bitCast(@as(i64, 4639946117605859984))), @as(f64, @bitCast(@as(i64, 4643595199370460140))), (-@as(f64, @bitCast(@as(i64, 4643183241236614703)))), @as(f64, @bitCast(@as(i64, 4636419853123700144))), (-@as(f64, @bitCast(@as(i64, 4650902713511920495)))), (-@as(f64, @bitCast(@as(i64, 4650958793970678552)))), (-@as(f64, @bitCast(@as(i64, 4648384044847803337)))), @as(f64, @bitCast(@as(i64, 4645054875972854148))), (-@as(f64, @bitCast(@as(i64, 4639299255083084664)))), (-@as(f64, @bitCast(@as(i64, 4645246731302836146)))), @as(f64, @bitCast(@as(i64, 4640224897448773616))), (-@as(f64, @bitCast(@as(i64, 4636289130222235312)))), (-@as(f64, @bitCast(@as(i64, 4645752688678423343)))), @as(f64, @bitCast(@as(i64, 4648389994425583762))), @as(f64, @bitCast(@as(i64, 4645709110391558536))), (-@as(f64, @bitCast(@as(i64, 4647711419777193083)))), @as(f64, @bitCast(@as(i64, 4639441119592185392))), @as(f64, @bitCast(@as(i64, 4632289002633017632))), @as(f64, @bitCast(@as(i64, 4649810704433345420))), @as(f64, @bitCast(@as(i64, 4646780504629270067))), (-@as(f64, @bitCast(@as(i64, 4646168892777703930)))), @as(f64, @bitCast(@as(i64, 4651658541069919960))), (-@as(f64, @bitCast(@as(i64, 4649930273704649318)))), (-@as(f64, @bitCast(@as(i64, 4639965610772024736)))), @as(f64, @bitCast(@as(i64, 4647734886891527314))), (-@as(f64, @bitCast(@as(i64, 4649333568631567784)))), (-@as(f64, @bitCast(@as(i64, 4626906439755189824)))), (-@as(f64, @bitCast(@as(i64, 4651317567480919612)))), @as(f64, @bitCast(@as(i64, 4644626185479158624))), @as(f64, @bitCast(@as(i64, 4647865595719329480))), @as(f64, @bitCast(@as(i64, 4639342760273952984))), @as(f64, @bitCast(@as(i64, 4649816691340260584))), (-@as(f64, @bitCast(@as(i64, 4645260793002033844)))), @as(f64, @bitCast(@as(i64, 4645578961025808040))), @as(f64, @bitCast(@as(i64, 4640844706304321016))), @as(f64, @bitCast(@as(i64, 4639826141755417280))), (-@as(f64, @bitCast(@as(i64, 4635863968612862720)))), @as(f64, @bitCast(@as(i64, 4649191992262865188))), @as(f64, @bitCast(@as(i64, 4651034128374554856))), (-@as(f64, @bitCast(@as(i64, 4632487487181072240)))), @as(f64, @bitCast(@as(i64, 4644483208468234232))), (-@as(f64, @bitCast(@as(i64, 4650940000983690860)))), @as(f64, @bitCast(@as(i64, 4645796986442116596))), @as(f64, @bitCast(@as(i64, 4643884252554316012))), @as(f64, @bitCast(@as(i64, 4651885851323824495))), @as(f64, @bitCast(@as(i64, 4648874576557328402))), (-@as(f64, @bitCast(@as(i64, 4646286487140007204)))), (-@as(f64, @bitCast(@as(i64, 4642240729333607804)))), @as(f64, @bitCast(@as(i64, 4644641556101072224))), (-@as(f64, @bitCast(@as(i64, 4651610377613128688)))), (-@as(f64, @bitCast(@as(i64, 4635091326135210760)))), (-@as(f64, @bitCast(@as(i64, 4649050970495002930)))), (-@as(f64, @bitCast(@as(i64, 4649947337839648048)))), (-@as(f64, @bitCast(@as(i64, 4650970171728172448)))), @as(f64, @bitCast(@as(i64, 4647930020455439654))), (-@as(f64, @bitCast(@as(i64, 4649731931592410612)))), (-@as(f64, @bitCast(@as(i64, 4647587629792520392)))), (-@as(f64, @bitCast(@as(i64, 4641877749006956640)))), @as(f64, @bitCast(@as(i64, 4649745340288795500))), (-@as(f64, @bitCast(@as(i64, 4650589707598775415)))), (-@as(f64, @bitCast(@as(i64, 4636851654504067375)))), @as(f64, @bitCast(@as(i64, 4636658465574317329))), @as(f64, @bitCast(@as(i64, 4649955775420160558))), @as(f64, @bitCast(@as(i64, 4648828046126418708))), @as(f64, @bitCast(@as(i64, 4649614498327195752))), (-@as(f64, @bitCast(@as(i64, 4646503731904801224)))), (-@as(f64, @bitCast(@as(i64, 4640164494275527532)))), (-@as(f64, @bitCast(@as(i64, 4643676664060255130)))), @as(f64, @bitCast(@as(i64, 4649970007511982578))), @as(f64, @bitCast(@as(i64, 4651263708317450436))), (-@as(f64, @bitCast(@as(i64, 4649352280188520407)))), (-@as(f64, @bitCast(@as(i64, 4648907253777262396)))), (-@as(f64, @bitCast(@as(i64, 4647926680485820278)))), (-@as(f64, @bitCast(@as(i64, 4647902417046200247)))), (-@as(f64, @bitCast(@as(i64, 4629158447936045888)))), @as(f64, @bitCast(@as(i64, 4640475525598592560))), (-@as(f64, @bitCast(@as(i64, 4647055227417544434)))), (-@as(f64, @bitCast(@as(i64, 4651935293408847279)))), (-@as(f64, @bitCast(@as(i64, 4639907649491256761)))), (-@as(f64, @bitCast(@as(i64, 4643307847132168212)))), @as(f64, @bitCast(@as(i64, 4638872365163668656))), @as(f64, @bitCast(@as(i64, 4651182198821157798))), @as(f64, @bitCast(@as(i64, 4645410015904845512))), @as(f64, @bitCast(@as(i64, 4629414119207752960))), @as(f64, @bitCast(@as(i64, 4642478870664559439))), @as(f64, @bitCast(@as(i64, 4644907105454597012))), (-@as(f64, @bitCast(@as(i64, 4651057455818520171)))), @as(f64, @bitCast(@as(i64, 4650239874862806400))), @as(f64, @bitCast(@as(i64, 4648136491186243004))), @as(f64, @bitCast(@as(i64, 4649799721430361714))), @as(f64, @bitCast(@as(i64, 4648451455184702242))) });
}

fn want() *CxList(i64) {
    @setEvalBranchQuota(1000000);
    return cx_ll_of(i64, &[_]i64{ -4578466087111194142, -4574018494745912736, 4644018150852076876, -4572639040645008494, 4634750360100148384, -4579938769540163306, -4572385055888599162, 4624561509360033280, -4572024358612755707, -4584498750379090064, -4572593637621322612, -4572960568220981297, -4583856530420982344, 4648961259205224522, -4573542675146794559, -4575291989411315830, 4643171332391434656, 4651087394828433756, 4639629654230848720, -4581897555042678504, 4651589584241175012, -4572184219197461612, 4649517459641620864, -4577261955509423714, -4573902490277863212, -4573436950980449231, -4577925973900593010, 4648772569542164834, -4574544100112342149, 4639946117605859984, 4643595199370460140, -4580188795618161104, 4636419853123700144, -4572469323342855313, -4572413242884097256, -4574987992006972471, 4645054875972854148, -4584072781771691144, -4578125305551939662, 4640224897448773616, -4587082906632540496, -4577619348176352464, 4648389994425583762, 4645709110391558536, -4575660617077582725, 4639441119592185392, 4632289002633017632, 4649810704433345420, 4646780504629270068, -4577203144077071878, 4651658541069919960, -4573441763150126490, -4583406426082751072, 4647734886891527314, -4574038468223208024, -4596465597099585984, -4572054469373856196, 4644626185479158624, 4647865595719329480, 4639342760273952984, 4649816691340260584, -4578111243852741964, 4645578961025808040, 4640844706304321016, 4639826141755417280, -4587508068241913088, 4649191992262865188, 4651034128374554856, -4590884549673703568, 4644483208468234232, -4572432035871084948, 4645796986442116596, 4643884252554316012, 4651885851323824494, 4648874576557328402, -4577085549714768604, -4581131307521168004, 4644641556101072224, -4571761659241647120, -4588280710719565048, -4574321066359772878, -4573424699015127760, -4572401865126603360, 4647930020455439654, -4573640105262365196, -4575784407062255416, -4581494287847819168, 4649745340288795500, -4572782329256000393, -4586520382350708432, 4636658465574317328, 4649955775420160558, 4648828046126418708, 4649614498327195752, -4576868304949974584, -4583207542579248276, -4579695372794520678, 4649970007511982578, 4651263708317450436, -4574019756666255401, -4574464783077513412, -4575445356368955530, -4575469619808575561, -4594213588918729920, 4640475525598592560, -4576316809437231374, -4571436743445928528, -4583464387363519048, -4580064189722607596, 4638872365163668656, 4651182198821157798, 4645410015904845512, 4629414119207752960, 4642478870664559440, 4644907105454597012, -4572314581036255637, 4650239874862806400, 4648136491186243004, 4649799721430361714, 4648451455184702242 });
}

fn got(i_: i64) *CxList(i64) {
    return (if ((i_ >= cx_list_len(lits()))) cx_ll_empty(i64) else cx_ll_concat(cx_ll_of(i64, &[_]i64{ cx_real_to_bits(cx_list_at(lits(), i_)) }), got((i_ +% 1))));
}

fn bad_from(g: *CxList(i64), i_: i64, n_: i64) i64 {
    var _tl_i = i_;
    var _tl_n = n_;
    while (true) {
        if ((_tl_i >= cx_list_len(g))) { return _tl_n; } else { if ((cx_list_at(g, _tl_i) != cx_list_at(want(), _tl_i))) { { const _tj2_1 = (_tl_i +% 1); const _tj2_2 = (_tl_n +% 1); _tl_i = _tj2_1; _tl_n = _tj2_2; continue; } } else { { const _tj2_1 = (_tl_i +% 1); const _tj2_2 = _tl_n; _tl_i = _tj2_1; _tl_n = _tj2_2; continue; } } }
    }
}

fn off_by_from(g: *CxList(i64), i_: i64, worst: i64) i64 {
    var _tl_i = i_;
    var _tl_worst = worst;
    while (true) {
        if ((_tl_i >= cx_list_len(g))) { return _tl_worst; } else { const d_: i64 = (cx_list_at(g, _tl_i) -% cx_list_at(want(), _tl_i)); const a_: i64 = (if ((d_ < 0)) (0 -% d_) else d_); { const _tj3_1 = (_tl_i +% 1); const _tj3_2 = (if ((a_ > _tl_worst)) a_ else _tl_worst); _tl_i = _tj3_1; _tl_worst = _tj3_2; continue; } }
    }
}

fn opening() void {
    return b0: { _ = cx_print_line(grade_ints("\x14\x10\x1b\x02\x1a\x0f\x12\x1e\x02\x10\x1c\x02\x04\x05\x03\x02\x16\x11\x1c\x1c\x0d\x15", cx_ll_of(i64, &[_]i64{ bad_from(got(0), 0, 0) }), cx_ll_of(i64, &[_]i64{ 0 }))); _ = cx_print_line(grade_ints("\x1b\x10\x15\x13\x0e\x02\x19\x17\x1f\x02\x1d\x0f\x1f\x02\x02\x02\x02\x02\x02\x02\x02", cx_ll_of(i64, &[_]i64{ off_by_from(got(0), 0, 0) }), cx_ll_of(i64, &[_]i64{ 0 }))); break :b0; };
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


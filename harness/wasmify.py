#!/usr/bin/env python3
"""Turn a transpiled Codex program into a wasm32-freestanding module.

NOTES.txt records that the emitted zig is a hosted program and that
wasm32-freestanding "is not close". Measured, it is three prelude functions:

  * the entry spawns a thread purely to get a 512 MB stack, and freestanding is
    single-threaded;
  * the heap reserves 4 GiB through std.heap.page_allocator, which is the whole
    of a wasm32 address space;
  * printing reaches std.Io, which drags in posix.

Nothing in the TRANSPILED PROGRAM needs changing -- only the fixed prelude, which
is emitted identically into every file this plug produces. That is why this is a
text pass over three known shapes rather than a fork of the emitter: when the
plug grows a wasm story of its own, this file is what it replaces.

Each substitution must match exactly once. A prelude that has drifted underneath
this script is a prelude this script no longer understands, and silently
emitting a module with a 4 GiB reservation in it would waste the afternoon.
"""

import pathlib
import re
import sys

HERE = pathlib.Path(__file__).resolve().parent
ROOT = HERE.parent

HOSTED_ENTRY = """pub fn main() void {
    const stack_bytes: usize = 512 * 1024 * 1024;
    const t = std.Thread.spawn(.{ .stack_size = stack_bytes }, cx_entry, .{}) catch @panic("spawn");
    t.join();
}"""

FREESTANDING_ENTRY = """// The hosted entry spawned a thread for its 512 MB stack; freestanding is
// single-threaded and the browser calls renderFrame directly, so cx_entry is
// simply unused here.
comptime {
    _ = cx_entry;
}"""

HOSTED_PRINT = '''fn cx_print_line(s: []const u8) void {
    std.debug.print("{s}\\n", .{cx_cce_to_utf8(s)});
}
fn cx_print(s: []const u8) void {
    std.debug.print("{s}", .{cx_cce_to_utf8(s)});
}'''

FREESTANDING_PRINT = """// There is no stdout in a freestanding module. The Codex program's own
// print-line calls become no-ops; the frame leaves through linear memory.
fn cx_print_line(s: []const u8) void {
    _ = s;
}
fn cx_print(s: []const u8) void {
    _ = s;
}"""


def sub_once(text, old, new, what):
    if text.count(old) != 1:
        raise SystemExit(f'wasmify: expected exactly one {what} in the prelude, '
                         f'found {text.count(old)}; the plug has drifted')
    return text.replace(old, new)


def wasmify(text, heap_mb, shim='shim.zig'):
    text = sub_once(text, HOSTED_ENTRY, FREESTANDING_ENTRY, 'hosted entry')
    text = sub_once(text, HOSTED_PRINT, FREESTANDING_PRINT, 'hosted print pair')

    old_reserve = 'const cx_heap_reserve: usize = 4096 * 1024 * 1024;'
    text = sub_once(text, old_reserve,
                    f'const cx_heap_reserve: usize = {heap_mb} * 1024 * 1024;',
                    'heap reservation')

    # The bump heap becomes a static region: wasm32 has no page_allocator to
    # reserve from, and .bss costs nothing until the pages are touched.
    base, n = re.subn(r'fn cx_heap_base\(\) \[\*\]u8 \{.*?\n\}',
                      'var cx_heap_static: [cx_heap_reserve]u8 align(4096) = undefined;\n'
                      'fn cx_heap_base() [*]u8 {\n    return &cx_heap_static;\n}',
                      text, flags=re.S)
    if n != 1:
        raise SystemExit(f'wasmify: expected one cx_heap_base, found {n}')
    return base + (ROOT / 'poc' / shim).read_text()


def main():
    # The SHIM IS PER SCENE now. It was hardcoded to poc/shim.zig while there was
    # one scene; Drive needs a different one because it carries state -- the world,
    # the rider, a history ring -- while Scene is a pure function of a scrub.
    if len(sys.argv) not in (3, 4, 5):
        raise SystemExit('usage: wasmify.py <in.zig> <out.zig> [heap-mb] [shim]')
    heap_mb = int(sys.argv[3]) if len(sys.argv) >= 4 else 32
    shim = sys.argv[4] if len(sys.argv) == 5 else 'shim.zig'
    out = pathlib.Path(sys.argv[2])
    out.write_text(wasmify(pathlib.Path(sys.argv[1]).read_text(), heap_mb, shim))
    print(f'{out}  (heap {heap_mb} MB)')
    return 0


if __name__ == '__main__':
    sys.exit(main())

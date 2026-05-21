//! By convention, root.zig is the root source file when making a package.
const std = @import("std");
const Io = std.Io;

/// Parses an environment variable as a non-negative `f64`.
/// Returns `null` if the variable is unset, empty, unparseable, or negative.
pub fn parseEnvNonNegF64(key: [:0]const u8) ?f64 {
    const raw = std.mem.span(std.c.getenv(key) orelse return null);
    if (raw.len == 0) return null;

    const value = std.fmt.parseFloat(
        f64,
        std.mem.trim(u8, raw, &std.ascii.whitespace),
    ) catch return null;

    return if (value >= 0) value else null;
}

pub fn printAnotherMessage(writer: *Io.Writer) Io.Writer.Error!void {
    try writer.print("Run `zig build test` to run the tests.\n", .{});
}

pub fn add(a: i32, b: i32) i32 {
    return a + b;
}

test "basic add functionality" {
    try std.testing.expect(add(3, 7) == 10);
}

test "parseEnvNonNegF64 returns null for unset var" {
    try std.testing.expectEqual(null, parseEnvNonNegF64("__ZIG_LEARNING_UNSET__"));
}

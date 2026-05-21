const std = @import("std");

fn parseEnvF64Nonneg(key: []const u8) f64 {
    const v = std.posix.getenv(key) orelse return 0;
    if (v.len == 0) return 0;

    const x = std.fmt.parseFloat(f64, std.mem.trim(u8, v, &std.ascii.whitespace)) catch return 0;

    return @max(0, x);
}

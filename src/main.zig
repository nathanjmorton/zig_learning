const std = @import("std");
const Io = std.Io;
const zio = @import("zio");

const zig_learning = @import("zig_learning");

const num_tasks = 100;
fn task(io: std.Io) std.Io.Cancelable!void {
    try io.sleep(.fromMilliseconds(100), .awake);
}

pub fn main(init: std.process.Init) !void {
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_file_writer: Io.File.Writer = .init(.stdout(), init.io, &stdout_buffer);
    const stdout = &stdout_file_writer.interface;

    const keys = [_][:0]const u8{ "RATE", "TIMEOUT", "THRESHOLD" };

    for (&keys) |key| {
        if (zig_learning.parseEnvNonNegF64(key)) |value| {
            try stdout.print("{s} = {d:.2}\n", .{ key, value });
        } else {
            try stdout.print("{s} = <not set>\n", .{key});
        }
    }

    try stdout.flush();

    const batch_size = 20;
    var completed: usize = 0;
    // use zio runtime io instead of init io
    const rt = try zio.Runtime.init(init.gpa, .{});
    defer rt.deinit();
    const io = rt.io();

    while (completed < num_tasks) {
        var group: std.Io.Group = .init;
        const end = @min(completed + batch_size, num_tasks);
        for (completed..end) |j| {
            group.concurrent(io, task, .{io}) catch {
                break;
            };
            try stdout.print("queued task {d}\n", .{j});
        }
        try stdout.flush();
        try group.await(io);
        completed = end;
        // Give OS time to reclaim thread resources
        try init.io.sleep(.fromMilliseconds(100), .awake);
    }
}

test "simple test" {
    const gpa = std.testing.allocator;
    var list: std.ArrayList(i32) = .empty;
    defer list.deinit(gpa); // Try commenting this out and see if zig detects the memory leak!
    try list.append(gpa, 42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}

test "fuzz example" {
    try std.testing.fuzz({}, testOne, .{});
}

fn testOne(context: void, smith: *std.testing.Smith) !void {
    _ = context;
    // Try passing `--fuzz` to `zig build test` and see if it manages to fail this test case!

    const gpa = std.testing.allocator;
    var list: std.ArrayList(u8) = .empty;
    defer list.deinit(gpa);
    while (!smith.eos()) switch (smith.value(enum { add_data, dup_data })) {
        .add_data => {
            const slice = try list.addManyAsSlice(gpa, smith.value(u4));
            smith.bytes(slice);
        },
        .dup_data => {
            if (list.items.len == 0) continue;
            if (list.items.len > std.math.maxInt(u32)) return error.SkipZigTest;
            const len = smith.valueRangeAtMost(u32, 1, @min(32, list.items.len));
            const off = smith.valueRangeAtMost(u32, 0, @intCast(list.items.len - len));
            try list.appendSlice(gpa, list.items[off..][0..len]);
            try std.testing.expectEqualSlices(
                u8,
                list.items[off..][0..len],
                list.items[list.items.len - len ..],
            );
        },
    };
}

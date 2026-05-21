const std = @import("std");
const zio = @import("zio");

const num_tasks = 10_000;

fn task(io: std.Io) std.Io.Cancelable!void {
    try io.sleep(.fromSeconds(10), .awake);
}

pub fn main(init: std.process.Init) !void {
    const rt = try zio.Runtime.init(init.gpa, .{});
    defer rt.deinit();

    const io = rt.io();

    var group: std.Io.Group = .init;
    for (0..num_tasks) |_| {
        try group.concurrent(io, task, .{io});
    }
    try group.await(io);
}

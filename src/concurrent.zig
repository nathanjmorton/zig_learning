const std = @import("std");

const num_tasks = 10_000;

fn task(io: std.Io) std.Io.Cancelable!void {
    try io.sleep(.fromSeconds(10), .awake);
}

pub fn main(init: std.process.Init) !void {
    var group: std.Io.Group = .init;
    for (0..num_tasks) |_| {
        try group.concurrent(init.io, task, .{init.io});
    }
    try group.await(init.io);
}

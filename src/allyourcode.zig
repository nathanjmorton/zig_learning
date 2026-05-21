const std = @import("std");
const Io = std.Io;

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_file_writer: Io.File.Writer = .init(.stdout(), io, &stdout_buffer);
    const stdout_writer = &stdout_file_writer.interface;

    // const stdout_file = std.fs.File.stdout();
    // const stdout = &stdout_writer.interface;
    try stdout_writer.writeAll(" All your codebase still belong to us! ");
    try stdout_writer.flush();
    debugprint();
}

pub fn debugprint() void {
    const x: i32 = 42;
    std.debug.print("{}\n ", .{x});
}

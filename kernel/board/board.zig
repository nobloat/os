const std = @import("std");

const import = switch (std.Target.current.cpu.arch) {
    .x86_64 => {
        return @import("uefipc.zig");
    },
    else => {
        @compileError("Unsupported board");
    },
};

pub const Board = .{
    .init = import.init,
    .getFrameBuffer = import.getFrameBuffer,
};

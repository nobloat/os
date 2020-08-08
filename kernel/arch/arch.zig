const std = @import("std");

const import = switch (std.Target.current.cpu.arch) {
    .x86_64 => {
        return @import("x86_64.zig");
    },
    .aarch64 => {
        return @import("aarch64.zig");
    },
    else => {
        @compileError("Unsupported architecture");
    },
};

pub const ArchFunctions = .{
    .halt = import.halt,
    .suspendMultiCores = import.suspendMultiCores,
};

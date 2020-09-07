const std = @import("std");

const import = switch (std.Target.current.cpu.arch) {
    .x86_64 => {
        return @import("x86_64.zig");
    },
    else => {
        @compileError("Unsupported CPU architecture");
    },
};

pub const ArchFunctions = .{
    .halt = import.halt,
    .init = import.init,
    .exit = import.exit,
    .uartWrite = import.uartWrite,
    .suspendMultiCores = import.suspendMultiCores,
};

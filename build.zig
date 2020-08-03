const Builder = @import("std").build.Builder;
const Step = @import("std").build.Step;
const LibExeObjStep = @import("std").build.LibExeObjStep;
const std = @import("std");
const builtin = @import("builtin");
const CrossTarget = @import("std").zig.CrossTarget;
const Target = @import("std").zig.Target;

pub fn build(b: *Builder) void {
    const mode = b.standardReleaseOptions();

    const kernel_x86_64 = b.addExecutable("kernel-x86_64.elf", "kernel/main.zig");
    const kernel_aarch_64 = b.addExecutable("kernel-aarch64.elf", "kernel/main.zig");
    const kernels = [_]*LibExeObjStep{ kernel_aarch_64, kernel_x86_64 };

    for (kernels) |k| {
        k.setBuildMode(builtin.Mode.ReleaseSmall);
        k.setLinkerScriptPath("kernel/link.ld");
        k.setTarget(CrossTarget{
            .cpu_arch = std.Target.Cpu.Arch.aarch64,
            .os_tag = std.Target.Os.Tag.freestanding,
            .abi = std.Target.Abi.none,
        });
        k.install();
    }

    kernel_x86_64.target.cpu_arch = std.Target.Cpu.Arch.x86_64;
    kernel_aarch_64.target.cpu_arch = std.Target.Cpu.Arch.aarch64;

    b.default_step.dependOn(&kernel_x86_64.step);
    b.default_step.dependOn(&kernel_aarch_64.step);
}

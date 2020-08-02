const Builder = @import("std").build.Builder;
const std = @import("std");
const builtin = @import("builtin");
const CrossTarget = @import("std").zig.CrossTarget;
const Target = @import("std").zig.Target;

pub fn build(b: *Builder) void {
    const mode = b.standardReleaseOptions();
    //const lib = b.addStaticLibrary("os", "src/main.zig");
    buildX8664(b);
    buildAarch64(b);

    //const test_step = b.step("test", "Run library tests");
    //test_step.dependOn(&main_tests.step);
}

pub fn buildX8664(b: *Builder) void {
    const kernel = b.addExecutable("kernel-x86_64.elf", "kernel/main.zig");

    kernel.setBuildMode(builtin.Mode.ReleaseSmall);
    kernel.strip = true;

    kernel.setTarget(CrossTarget {
     .cpu_arch = std.Target.Cpu.Arch.x86_64,
     .os_tag = std.Target.Os.Tag.freestanding,
     .abi = std.Target.Abi.none,
    });  

    kernel.setLinkerScriptPath("kernel/link.ld");    
    kernel.install();
}


pub fn buildAarch64(b: *Builder) void {
    const kernel = b.addExecutable("kernel-aarch64.elf", "kernel/main.zig");

    kernel.setBuildMode(builtin.Mode.ReleaseSmall);
    kernel.strip = true;

    kernel.setTarget(CrossTarget {
     .cpu_arch = std.Target.Cpu.Arch.aarch64,
     .os_tag = std.Target.Os.Tag.freestanding,
     .abi = std.Target.Abi.none,
    });  

    kernel.setLinkerScriptPath("kernel/link.ld");    
    kernel.install();
}

const std = @import("std");
const CrossTarget = @import("std").zig.CrossTarget;


pub fn build(b: *std.build.Builder) void {
    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    const lib = b.addExecutable("kernel8.elf", "src/main.zig");
    lib.setBuildMode(mode);
    lib.setTarget(CrossTarget{
            .cpu_arch = std.Target.Cpu.Arch.aarch64,
            .os_tag = std.Target.Os.Tag.freestanding,
            .abi = std.Target.Abi.none,
        });
    lib.install();
    lib.addIncludeDir("src/");
    lib.addCSourceFile("src/uart.c", &[_][]const u8{"-Wall", "-O2" , "-ffreestanding" ,"-nostdinc" ,"-nostdlib", "-mcpu=cortex-a53+nosimd"});
    lib.setLinkerScriptPath("src/raspi3.ld");
    lib.addAssemblyFile("src/raspi3.S");

    var main_tests = b.addTest("src/main.zig");
    main_tests.setBuildMode(mode);

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&main_tests.step);
}

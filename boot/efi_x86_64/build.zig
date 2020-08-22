const Builder = @import("std").build.Builder;
const Target = @import("std").Target;
const CrossTarget = @import("std").zig.CrossTarget;
const builtin = @import("builtin");

pub fn build(b: *Builder) void {
    const exe = b.addExecutable("bootx64", "main.zig");
    exe.setBuildMode(b.standardReleaseOptions());
    exe.setTarget(CrossTarget{
        .cpu_arch = Target.Cpu.Arch.x86_64,
        .os_tag = Target.Os.Tag.uefi,
        .abi = Target.Abi.msvc,
    });
    exe.setOutputDir("efi/boot");
    exe.install();
    b.default_step.dependOn(&exe.step);

    const step = b.step("qemu", "run qemu");
    const qemuStep = b.addSystemCommand(&[_][]const u8{"qemu-system-x86_64", "-bios", "ovmf-x86_64.bin", "-hdd", "fat:rw:."});

    step.dependOn(&qemuStep.step);
    step.dependOn(&exe.step);
}
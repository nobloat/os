const Builder = @import("std").build.Builder;
const Step = @import("std").build.Step;
const LibExeObjStep = @import("std").build.LibExeObjStep;
const std = @import("std");
const builtin = @import("builtin");
const CrossTarget = @import("std").zig.CrossTarget;
const Target = @import("std").Target;

pub fn build(b: *Builder) void {
    const buildMode = b.standardReleaseOptions();

    const efiKernel = setupEfiKernel(b);
}

pub fn setupEfiKernel(b : *Builder) *LibExeObjStep {
    const k = b.addExecutable("bootx64", "kernel/main.zig");
    k.setBuildMode(b.standardReleaseOptions());
    k.setTarget(CrossTarget{
        .cpu_arch = Target.Cpu.Arch.x86_64,
        .os_tag = Target.Os.Tag.uefi,
        .abi = Target.Abi.msvc,
    });
    k.setOutputDir("boot/efi/boot");
    k.install();
    b.default_step.dependOn(&k.step);

    const step = b.step("qemu-efi", "run qemu with efi kernel");
    const qemuStep = b.addSystemCommand(&[_][]const u8{"qemu-system-x86_64", "-bios", "boot/ovmf-x86_64.bin", "-hdd", "fat:rw:boot/."});

    //you can use exe.addBuildOption([]const u8, "option_name", value);
    //And then use @import("build_options").option_name
    //(and b.option([]const u8, "option_name", "Option description") orelse default_value if you want to expose zig build -Doption_name=...)

    step.dependOn(&qemuStep.step);

    return k;
}

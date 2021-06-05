const ExportOptions = @import("std").builtin.ExportOptions;

const ProtocolLevel = enum(u2) { MINIAMAL = 0, STATIC = 1, DYNAMIC = 2 };

const Endianess = enum(u1) { BIG_ENDIAN = 1, LITTL_ENDIAN = 0 };

const LoaderType = enum(u5) { BIOS = (0 << 2), UEFI = (1 << 2), RASPBERRY_PI = (2 << 2) };

const ProtocolInfo = extern struct {
    protocolLevel: ProtocolLevel,
    loaderType: LoaderType,
    endianness: Endianess,
};

const PlatformX8664 = extern struct { acpi: u64, smbi: u64, efi: u64, mp: u64, unused: [4]u64 };

const PlatformAarch64 = extern struct { acpi: u64, mmio: u64, efi: u64, unused: [5]u64 };

const ArchSpecific = extern union { x8664: PlatformX8664, aarch64: PlatformAarch64 };

const Mmap = extern struct { ptr: u64, size: u64 };

pub const FrameBuffer = extern struct { address: *u32, size: u32, width: u32, height: u32, scanLine: u32 };

pub const Bootboot = extern struct { magic: [4]u8, size: u32, protocol: u8, fbType: u8, numcores: u16, bspId: u16, timezone: i16, datetime: [8]u8, initrdAddress: u64, initrdSize: u64, frameBuffer: FrameBuffer, specific: ArchSpecific, mmap: Mmap };

pub extern var bootboot: Bootboot;

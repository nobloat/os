
pub inline fn halt() void {
    asm volatile ("hlt");
}

pub inline fn suspendMultiCores() void {
    asm volatile (
        \\mov $1, %%eax
        \\cpuid
        \\shr $24, %%ebx
        \\cmpw %%bx, bootboot+0xC
        \\jz .bsp
        \\  hlt
        \\.bsp:
        :
        :
        : "eax", "ebx"
    );
}

const idt = @import("x86_64/idt.zig");
const portio = @import("x86_64/portio.zig");
const Uart = @import("x86_64/uart.zig").X8664Serial;

pub inline fn exit(status: u32) void {
    portio.outl(0xF4, status);
}

var uart = Uart{};

pub inline fn init() void {
    uart.init();
    //idt.loadIdt();
}

pub inline fn uartWrite(data: [] const u8) void {
    uart.init();
    uart.write(data);

    //TODO: don't know without this line I get a linker error:
    //lld: error: /home/cinemast/os/kernel/arch/x86_64.zig:32:(.text+0x7A): relocation R_X86_64_32 out of range: 18446744073707488680 is not in [0, 4294967295]
    for (data) |b| {}
}
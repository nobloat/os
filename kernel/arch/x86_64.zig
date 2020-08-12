
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

    for (data) |b| {
      //Wait for transmission finished empty
      while (portio.inb(0x3F8+5) & 0x20 == 0) {}
      portio.outb(0x3F8, b);
    }
}
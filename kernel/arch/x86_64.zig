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

pub inline fn exit(status: u32) void {
    portio.outl(0xF4, status);
}

pub inline fn init() void {
    //idt.loadIdt();
    //exit(0);
}
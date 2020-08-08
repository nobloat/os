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

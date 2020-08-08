pub inline fn halt() void {
    asm volatile ("hlt");
}

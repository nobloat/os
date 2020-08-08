pub inline fn halt() void {
    asm volatile ("hlt");
}

pub inline fn suspendMultiCores() void {}

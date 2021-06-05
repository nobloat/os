pub inline fn halt() void {
    asm volatile ("wfi");
}

pub inline fn suspendMultiCores() void {
    asm volatile (
        \\mrs x0, mpidr_el1
        \\and x0, x0, #3
        \\cbz x0, .bsp
        \\ wfi
        \\.bsp:
        ::: "x0");
}

pub fn exit(status: u32) void {
    //TODO:
}

pub inline fn init() void {
    //TODO: setup interrupts
}

pub fn uartWrite(data: []const u8) void {
    //TODO: uart.write(data);
}

pub inline fn halt() void {
    asm volatile ("wfi");
}

pub inline fn suspendMultiCores() void {
    asm volatile (
        \\mrs x0, mpidr_el1
        \\and x0, x0, #3
        \\cbnz x0, .ap
        \\.ap:
 //\\  wfi
        );
}

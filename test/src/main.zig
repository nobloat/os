
const StackTrace = @import("std").builtin.StackTrace;

const c = @cImport({
    @cInclude("uart.h");
});

pub fn panic(msg: []const u8, error_return_trace: ?*StackTrace) noreturn {
     while (true) {}
}

export fn kmain() void {
     // set up serial console
    c.uart_init();
    
    // say hello
    c.uart_puts("Hello Worl2222d!\n");
    
    // echo everything back
    while(true) {
        c.uart_send(c.uart_getc());
    }
}


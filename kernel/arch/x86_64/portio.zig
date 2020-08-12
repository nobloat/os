pub fn outb(port: u16, value: u8) void {
    asm volatile ("outb %[value], %[port]"
        :
        : [value] "{al}" (value),
          [port] "N{dx}" (port)
        : "al", "dx"
    );
}

pub fn inb(port: u16) u8 {
  return asm volatile ("inb %[port], %[result]" : [result] "={al}"(-> u8) : [port] "N{dx}"(port) : "al");
}

pub fn outl(port: u16, value: u32) void {
    asm volatile ("outl %[value], %[port]"
        :
        : [value] "{eax}" (value),
          [port] "N{dx}" (port)
        : "eax", "dx"
    );
}

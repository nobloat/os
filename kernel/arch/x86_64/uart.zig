//Info: https://wiki.osdev.org/Serial_ports

const portio = @import("portio.zig");
const BaudRate = @import("../../uart.zig").BaudRate;

pub const SerialDevice = enum(u16) {
  COM1 = 0x3F8, COM2 = 0x2F8, COM3 = 0x3E8, COM4 = 0x2E8
};

pub const Register = enum(u16) {
  Data = 0, InterruptEnable = 1, InterruptIdentification = 2,
   LineControl = 3, ModemControl = 4, LineStatus = 5, ModemStatus = 6, Scratch = 7
};

pub const X8664Serial = struct {
  device: SerialDevice = SerialDevice.COM1,
  baudrate: BaudRate = BaudRate.B115K2,

  pub fn init(self: X8664Serial) void {
    //Disable interrupts
    portio.outb(register(self.device,Register.InterruptEnable), 0x00);
    //8 data bits 1 stop bit, no parity
    portio.outb(register(self.device, Register.LineControl), 0x003);
  }

  pub fn register(device: SerialDevice, reg: Register) u16 {
    return @enumToInt(device)+@enumToInt(reg);
  }


};
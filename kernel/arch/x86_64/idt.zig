
pub const GateType = packed enum(u4) {
  Interrupt = 0b110, Trap = 0b111, Task = 0b101
};

pub const PriviledgeLevel = packed enum(u2) {
  Ring0 = 0, Ring1 = 1, Ring2 = 2, Ring3 = 3
};

pub const InterruptDescriptor = packed struct {
  offsetLow: u16,
  selector: u16,
  zero: u8 = 0,
  gateType: GateType,
  segment: u1,
  level: PriviledgeLevel,
  present: u1,
  offsetHigh: u48,
  reserved: u32 = 0
};

pub const IDT = .{
  .limit = @sizeOf(@TypeOf(descriptorTable)) - 1,
  .base = &descriptorTable,
};

pub var descriptorTable = [_]InterruptDescriptor{
  InterruptDescriptor{
    .offsetLow = 0,
    .selector = 0,
    .gateType = GateType.Interrupt,
    .segment = 0,
    .level = PriviledgeLevel.Ring0,
    .present = 1,
    .offsetHigh = 0
  },
  InterruptDescriptor{
    .offsetLow = 0,
    .selector = 0,
    .gateType = GateType.Interrupt,
    .segment = 0,
    .level = PriviledgeLevel.Ring0,
    .present = 1,
    .offsetHigh = 0
  }
};

pub fn loadIdt() void {
  asm volatile ("lidt (%%eax)"
        :
        : [IDT] "{eax}" (&IDT) : "eax"
  );
}

test "idt descriptor" {
  var x = InterruptDescriptor{
    .offsetLow = 0,
    .selector = 0,
    .gateType = GateType.Interrupt,
    .segment = 0,
    .level = PriviledgeLevel.Ring0,
    .present = 1,
    .offsetHigh = 0
  };

  //loadIdt();
}

const boot = @import("bootboot.zig");


pub export fn _start() void {

  const width = boot.bootboot.frameBufferWidth;
  const height = boot.bootboot.frameBufferHeight;
  const scaneLine = boot.bootboot.frameBufferScanLine;
  const frameBuffer = boot.bootboot.frameBufferAddress;

  var x: u32 =0; 
  var y: u32 =0;

  while (y < height) {
    var offset: u32 = (height-y) * scaneLine +4*x;
    var target = @intToPtr(*u32, frameBuffer.* + offset);
    target.* = 0x00FFFFFF;
    y+= 1;
  }

  const mmio_ptr = @intToPtr(*volatile u8, 0x12345678);
   while(true) {
    mmio_ptr.*;
  }

}
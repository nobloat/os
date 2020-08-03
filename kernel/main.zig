
const boot = @import("bootboot.zig");

export fn _start() callconv(.Naked) noreturn {

  const width = boot.bootboot.frameBufferWidth;
  const height = boot.bootboot.frameBufferHeight;
  const scanLine = boot.bootboot.frameBufferScanLine;
  const frameBuffer = boot.bootboot.frameBufferAddress;

  var x: u32 = width / 2; 
  var y: u32 =0;

while (y < height) {
    var offset: u32 = (height-y) * scanLine +4*x;
    var target = @intToPtr(*u32, @ptrToInt(frameBuffer) + offset);
    target.* = 0x00FFFF00;
    y+= 1;
  }

  // var x: u32 =0; 
  // var y: u32 =0;

  // while (y < height) {
  //   var offset: u32 = (height-y) * scaneLine +4*x;
  //   var target = @intToPtr(*u32, frameBuffer.* + offset);
  //   target.* = 0x00FFFFFF;
  //   y+= 1;
  // }


  while(true) {
  
  }
  
}
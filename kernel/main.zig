const boot = @import("bootboot.zig");
const FrameBuffer = @import("framebuffer.zig").FrameBuffer;
const FrameBufferType = @import("framebuffer.zig").FrameBufferType;

export fn _start() noreturn {
  
    const frameBuffer = FrameBuffer {
      .address =  boot.bootboot.frameBuffer.address,
      .size = boot.bootboot.frameBuffer.size,
      .width = boot.bootboot.frameBuffer.width,
      .height = boot.bootboot.frameBuffer.height,
      .scanLine = boot.bootboot.frameBuffer.scanLine,
      .colorEncoding = @intToEnum(FrameBufferType, boot.bootboot.fbType)
    };

    var x: u32 = frameBuffer.width / 2;
    var y: u32 = 0;

    while (y < frameBuffer.height) : (y +=1 ) {
        frameBuffer.setPixel(x,y,frameBuffer.getColor(0, 0,0xff,0));
    }

    while (true) {}
}

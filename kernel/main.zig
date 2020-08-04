const boot = @import("bootboot.zig");
const FrameBuffer = @import("framebuffer.zig").FrameBuffer;
const FrameBufferType = @import("framebuffer.zig").FrameBufferType;
const PSFont = @import("psfont.zig").PSFont;
const DefaultFont = @import("psfont.zig").DefaultFont;

export fn _start() noreturn {
    const frameBuffer = FrameBuffer{
        .address = boot.bootboot.frameBuffer.address,
        .size = boot.bootboot.frameBuffer.size,
        .width = boot.bootboot.frameBuffer.width,
        .height = boot.bootboot.frameBuffer.height,
        .scanLine = boot.bootboot.frameBuffer.scanLine,
        .colorEncoding = @intToEnum(FrameBufferType, boot.bootboot.fbType),
    };

    var x: u32 = frameBuffer.width / 2;
    var y: u32 = 0;

    while (y < frameBuffer.height) : (y += 1) {
        frameBuffer.setPixel(x, y, frameBuffer.getColor(0, 0, 0, 0xff));
    }

    x = 0;
    y = frameBuffer.height / 2;
    while (x < frameBuffer.width) : (x += 1) {
        frameBuffer.setPixel(x, y, frameBuffer.getColor(0, 0, 0xff, 0));
    }

    const font = PSFont.Init(DefaultFont);

    const area = font.Render('A', frameBuffer.getColor(0, 0xFF, 0xff, 0xFF));
    //frameBuffer.setPixel(x, y, frameBuffer.getColor(0, 0xFF, 0xFF, 0xFF));
    frameBuffer.drawArea(100, 100, area);

    while (true) {}
}

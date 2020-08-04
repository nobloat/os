const boot = @import("bootboot.zig");
const FrameBuffer = @import("framebuffer.zig").FrameBuffer;
const Color = @import("framebuffer.zig").Color;
const FrameBufferType = @import("framebuffer.zig").FrameBufferType;
const PSFont = @import("psfont.zig").PSFont;
const DefaultFont = @import("psfont.zig").DefaultFont;
const Renderer = @import("renderer.zig").Renderer;

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

    const blue = frameBuffer.getColor(0, 0, 0, 0xff);
    const green = frameBuffer.getColor(0, 0, 0xff, 0);
    const red = frameBuffer.getColor(0, 0xff, 0, 0);

    while (y < frameBuffer.height) : (y += 1) {
        frameBuffer.setPixel(x, y, blue);
    }

    x = 0;
    y = frameBuffer.height / 2;
    while (x < frameBuffer.width) : (x += 1) {
        frameBuffer.setPixel(x, y, green);
    }

    const font = PSFont.Init(DefaultFont);

    puts(frameBuffer, font, "P P P P P P P", green);

    const render = Renderer{ .framebuffer = frameBuffer };
    render.fillRectangle(200, 200, 50, 50, blue);
    render.drawRectangle(400, 400, 50, 50, red);
    render.drawRectangle(500, 400, 50, 50, green);
    render.drawRectangle(600, 400, 50, 50, blue);

    while (true) {}
}

fn puts(frameBuffer: FrameBuffer, font: PSFont, string: []const u8, color: Color) void {
    var x: u32 = 100;
    var y: u32 = 100;

    for (string) |c| {
        frameBuffer.drawArea(x, y, font.Render(c, color));
        x += 10;
    }
}

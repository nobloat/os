const boot = @import("bootboot.zig");
const FrameBuffer = @import("framebuffer.zig").FrameBuffer;
const Position = @import("framebuffer.zig").Position;
const Color = @import("framebuffer.zig").Color;
const FrameBufferType = @import("framebuffer.zig").FrameBufferType;
const PSFont = @import("psfont.zig").PSFont;
const DefaultFont = @import("psfont.zig").DefaultFont;
const Renderer = @import("renderer.zig").Renderer;
const Direction = @import("renderer.zig").Direction;

export fn _start() noreturn {
    kmain();
    while (true) {}
}

fn kmain() void {
    var frameBuffer = FrameBuffer{
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

    const font = PSFont.Init(DefaultFont);

    //puts(frameBuffer, font, "P P P P P P P", green);

    const render = Renderer{ .framebuffer = frameBuffer };

    //render.fillRectangle(200, 200, 50, 50, blue);
    const topLeft: Position = .{ .x = 100, .y = 50 };
    const width = 100;
    const height = 100;
    render.drawRectangle(topLeft, width, height, red);
    render.drawRectangle(topLeft.offsetX(2 * width), width, height, green);
    render.drawRectangle(topLeft.offsetX(4 * width), width, height, blue);

    render.fillRectangle(topLeft.offsetY(500), width, height, red);
    render.fillRectangle(topLeft.offsetY(500).offsetX(2 * width), width, height, green);
    render.fillRectangle(topLeft.offsetY(500).offsetX(4 * width), width, height, blue);
}

fn puts(frameBuffer: FrameBuffer, font: PSFont, string: []const u8, color: Color) void {
    var x: u32 = 100;
    var y: u32 = 100;

    for (string) |c| {
        frameBuffer.drawArea(x, y, font.Render(c, color));
        x += 10;
    }
}

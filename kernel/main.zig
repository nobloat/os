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
    var frameBuffer = FrameBuffer{
        .address = boot.bootboot.frameBuffer.address,
        .size = boot.bootboot.frameBuffer.size,
        .width = boot.bootboot.frameBuffer.width,
        .height = boot.bootboot.frameBuffer.height,
        .scanLine = boot.bootboot.frameBuffer.scanLine,
        .colorEncoding = @intToEnum(FrameBufferType, boot.bootboot.fbType),
    };
    kmain(frameBuffer);
    while (true) {}
}

fn kmain(frameBuffer: FrameBuffer) void {
    var render = Renderer{ .framebuffer = frameBuffer };

    const blue = frameBuffer.getColor(0, 0, 0, 0xff);
    const green = frameBuffer.getColor(0, 0, 0xff, 0);
    const red = frameBuffer.getColor(0, 0xff, 0, 0);

    const topLeft: Position = .{ .x = 100, .y = 50 };
    const width = 100;
    const height = 100;

    //bootScreen(render);

    render.drawRectangle(topLeft, width, height, red);
    render.drawRectangle(topLeft.offsetX(2 * width), width, height, green);
    render.drawRectangle(topLeft.offsetX(4 * width), width, height, blue);

    render.fillRectangle(topLeft.offsetY(500), width, height, red);
    render.fillRectangle(topLeft.offsetY(500).offsetX(2 * width), width, height, green);
    render.fillRectangle(topLeft.offsetY(500).offsetX(4 * width), width, height, blue);

    puts(&render, DefaultFont, "Hallo Peter", green);
}

fn bootScreen(render: Renderer) void {
    const background = render.framebuffer.getColor(0, 0xf7, 0xf8, 0xf9);
    render.fillRectangle(.{ .x = 0, .y = 0 }, render.framebuffer.width, render.framebuffer.height, background);
}

fn puts(render: *Renderer, font: PSFont, string: []const u8, color: Color) void {
    var x: u32 = 100;
    var y: u32 = 100;

    var target = render.getTarget(.{ .x = 10, .y = 10 }, font.header.width, font.header.height);

    for (string) |c| {
        font.Render(target, c, color);
        target.topLeft.x += 10;
    }
}

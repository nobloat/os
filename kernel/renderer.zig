const FrameBuffer = @import("framebuffer.zig").FrameBuffer;
const PixelArea = @import("framebuffer.zig").PixelArea;
const Color = @import("framebuffer.zig").Color;

const assert = @import("std").debug.assert;

pub const Renderer = struct {
    framebuffer: FrameBuffer,

    pub fn drawRectangle(self: Renderer, x: u32, y: u32, width: u32, height: u32, color: Color) void {
        assert(x + width < self.framebuffer.width);
        assert(y + height < self.framebuffer.height);

        var offsetX: u32 = 0;
        var offsetY: u32 = 0;

        while (offsetX < width) : (offsetX += 1) {
            self.framebuffer.setPixel(x + offsetX, y, color);
            self.framebuffer.setPixel(x + offsetX, y + height, color);
        }

        offsetX = 0;
        offsetY = 0;
        while (offsetY < height) : (offsetY += 1) {
            self.framebuffer.setPixel(x, y, color);
            self.framebuffer.setPixel(x + width, y, color);
        }
    }

    pub fn fillRectangle(self: Renderer, x: u32, y: u32, width: u32, height: u32, color: Color) void {
        assert(x + width < self.framebuffer.width);
        assert(y + height < self.framebuffer.height);

        var offsetX: u32 = 0;
        var offsetY: u32 = 0;

        while (offsetX < width) : (offsetX += 1) {
            while (offsetY < height) : (offsetY += 1) {
                self.framebuffer.setPixel(x, y, color);
            }
            offsetY = 0;
        }
    }
};

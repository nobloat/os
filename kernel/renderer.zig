const FrameBuffer = @import("framebuffer.zig").FrameBuffer;
const Position = @import("framebuffer.zig").Position;
const Color = @import("framebuffer.zig").Color;

const assert = @import("std").debug.assert;

pub const Direction = enum {
    Horizontal, Vertical
};

pub const RenderTarget = struct {
    frameBuffer: *FrameBuffer,
    topLeft: Position,
    width: u32,
    height: u32,

    pub inline fn setPixel(self: RenderTarget, x: u32, y: u32, color: Color) void {
        self.frameBuffer.setPixel(topLeft.x + x, topLeft.y + y, color);
    }

    pub inline fn setPixelAtOffset(self: RenderTarget, offset: u32, color: Color) void {
        var y = offset / self.width;
        var x = offset % self.width;
        self.frameBuffer.setPixel(self.topLeft.x + x, self.topLeft.y, color);
    }
};

pub const Renderer = struct {
    framebuffer: FrameBuffer,

    pub fn drawRectangle(self: Renderer, topLeft: Position, width: u32, height: u32, color: Color) void {
        self.drawLine(topLeft, width, Direction.Horizontal, color);
        self.drawLine(topLeft, height, Direction.Vertical, color);
        self.drawLine(topLeft.offsetY(height), width, Direction.Horizontal, color);
        self.drawLine(topLeft.offsetX(width), height, Direction.Vertical, color);
    }

    pub inline fn drawLine(self: Renderer, start: Position, length: u32, direction: Direction, color: Color) void {
        switch (direction) {
            .Horizontal => {
                var x = start.x;
                while (x < start.x + length) : (x += 1) {
                    self.framebuffer.setPixel(x, start.y, color);
                }
            },
            .Vertical => {
                var y = start.y;
                while (y < start.y + length) : (y += 1) {
                    self.framebuffer.setPixel(start.x, y, color);
                }
            },
        }
    }

    pub fn fillRectangle(self: Renderer, topLeft: Position, width: u32, height: u32, color: Color) void {
        var y: u32 = 0;
        while (y < height) : (y += 1) {
            self.drawLine(topLeft.offsetY(y), width, Direction.Horizontal, color);
        }
    }

    pub fn getTarget(self: *Renderer, topLeft: Position, width: u32, height: u32) RenderTarget {
        return RenderTarget{ .frameBuffer = &self.framebuffer, .topLeft = topLeft, .width = width, .height = height };
    }
};

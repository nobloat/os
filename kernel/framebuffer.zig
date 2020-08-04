pub const FrameBufferType = enum(u8) {
    ARGB = 0, RGBA = 1, ABGR = 2, BGRA = 3
};

pub const Color = u32;

pub const PixelArea = struct {
    width: u32, height: u32, rgba: [128]u32
};

pub const FrameBuffer = struct {
    address: *u32,
    size: u32,
    width: u32,
    height: u32,
    scanLine: u32,
    colorEncoding: FrameBufferType,

    pub fn setPixel(self: FrameBuffer, x: u32, y: u32, color: Color) void {
        var offset: u32 = (self.height - y) * self.scanLine + 4 * x;
        @intToPtr(*u32, @ptrToInt(self.address) + offset).* = color;
    }

    pub fn getColor(self: FrameBuffer, alpha: u8, red: u8, green: u8, blue: u8) Color {
        switch (self.colorEncoding) {
            .ABGR => {
                return @intCast(u32, alpha) << 24 | @intCast(u32, blue) << 16 | @intCast(u32, green) << 8 | @intCast(u32, red);
            },
            .ARGB => {
                return @intCast(u32, alpha) << 24 | @intCast(u32, red) << 16 | @intCast(u32, green) << 8 | @intCast(u32, blue);
            },
            .RGBA => {
                return @intCast(u32, red) << 24 | @intCast(u32, green) << 16 | @intCast(u32, blue) << 8 | @intCast(u32, alpha);
            },
            .BGRA => {
                return @intCast(u32, blue) << 24 | @intCast(u32, green) << 16 | @intCast(u32, red) << 8 | @intCast(u32, alpha);
            },
        }
    }

    pub fn drawArea(self: FrameBuffer, x: u32, y: u32, area: PixelArea) void {
        var relativeX: u32 = 0;
        var relativeY: u32 = 0;
        while (relativeY < area.height) : (relativeY += 1) {
            while (relativeX < area.width) : (relativeX += 1) {
                self.setPixel(x + relativeX, y + relativeY, area.rgba[y * area.width + x]);
            }
            relativeX = 0;
        }
    }
};

const expect = @import("std").testing.expect;

test "pixel conversion" {
    const width = 320;
    const height = 240;
    const scanLine = width * 4;
    var frameBuffer: [width * height]u32 = undefined;

    var fb = FrameBuffer{
        .address = @ptrCast(*u32, &frameBuffer),
        .width = width,
        .height = height,
        .scanLine = scanLine,
        .size = width * height * 4,
        .colorEncoding = FrameBufferType.RGBA,
    };

    expect(fb.getColor(0, 0xff, 0, 0) == 0xff000000);
    expect(fb.getColor(0, 0, 0xff, 0) == 0x00ff0000);
    expect(fb.getColor(0, 0, 0, 0xff) == 0x0000ff00);
    expect(fb.getColor(0xff, 0, 0, 0xff) == 0x0000ffff);

    fb.colorEncoding = FrameBufferType.ABGR;
    expect(fb.getColor(0, 0xff, 0, 0) == 0x000000ff);
    expect(fb.getColor(0, 0, 0xff, 0) == 0x0000ff00);
    expect(fb.getColor(0, 0, 0, 0xff) == 0x00ff0000);
    expect(fb.getColor(0xff, 0, 0, 0xff) == 0xffff0000);
}

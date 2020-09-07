pub const FrameBufferType = enum(u8) {
    ARGB = 0, RGBA = 1, ABGR = 2, BGRA = 3
};

pub const Color = u32;

pub const Position = struct {
    x: u32,
    y: u32,

    pub inline fn offsetX(self: Position, x: u32) Position {
        return .{ .x = self.x + x, .y = self.y };
    }

    pub inline fn offsetY(self: Position, y: u32) Position {
        return .{ .x = self.x, .y = self.y + y };
    }

    pub inline fn offsetXY(self: Position, x: u32, y: u32) Position {
        return .{ .x = self.x + x, .y = self.y + y };
    }
};

pub const FrameBuffer = struct {
    address: *volatile u32,
    size: u32,
    width: u32,
    height: u32,
    scanLine: u32,
    colorEncoding: FrameBufferType,

    pub inline fn setPixel(self: FrameBuffer, x: u32, y: u32, color: Color) void {
        @intToPtr(*volatile u32, @ptrToInt(self.address) + y * self.scanLine + 4 * x).* = color;
    }

    pub inline fn getPixel(self: FrameBuffer, x: u32, y: u32) Color {
        return @intToPtr(*volatile u32, @ptrToInt(self.address) + y * self.scanLine + 4 * x).*;
    }

    pub fn reset(self: FrameBuffer) void {
        var x: u32 = 0;
        var y: u32 = 0;
        while (x < self.width) : (x += 1) {
            while (y < self.height) : (y += 1) {
                @intToPtr(*volatile u32, @ptrToInt(self.address) + y * self.scanLine + 4 * x).* = 0x00000000;
            }
            y = 0;
        }
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
};

const expect = @import("std").testing.expect;

const TestWidth: u32 = 800;
const TestHeight: u32 = 600;
var TestMemory = [_]u8{0} ** (TestWidth * TestHeight * 4);
pub var TestFrameBuffer = FrameBuffer{
    .address = @ptrCast(*u32, &TestMemory),
    .width = TestWidth,
    .height = TestHeight,
    .size = TestWidth * TestHeight * 4,
    .scanLine = TestWidth * 4,
    .colorEncoding = FrameBufferType.RGBA,
};

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

test "set pixel" {
    TestFrameBuffer.setPixel(0, 0, 0xABABABAB);
    expect(TestMemory[0] == 0xAB);
    expect(TestMemory[1] == 0xAB);
    expect(TestMemory[2] == 0xAB);
    expect(TestMemory[3] == 0xAB);

    expect(TestFrameBuffer.getPixel(0, 0) == 0xABABABAB);

    var x: u32 = 1;
    var y: u32 = 0;

    while (x < TestWidth) : (x += 1) {
        while (y < TestHeight) : (y += 1) {
            expect(TestFrameBuffer.getPixel(x, y) == 0x0);
        }
    }
}

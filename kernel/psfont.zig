const assert = @import("std").debug.assert;
const RenderTarget = @import("renderer.zig").RenderTarget;

pub const PSFontHeader = packed struct {
    magic: u32,
    version: u32,
    headerSize: u32,
    flag: u32,
    glyphCount: u32,
    bytesPerGlyph: u32,
    height: u32,
    width: u32,
};

pub const Color = u32;

pub const PSFont = struct {
    header: PSFontHeader,
    glyphs: []const u8,

    pub fn Init(binary: []const u8) PSFont {
        var fontHeader = @ptrCast(*const PSFontHeader, binary);
        var x = binary[fontHeader.headerSize .. fontHeader.headerSize + fontHeader.glyphCount * fontHeader.bytesPerGlyph];
        return PSFont{ .header = fontHeader.*, .glyphs = x };
    }

    pub fn GetGlyph(self: PSFont, character: u8) []const u8 {
        //TODO: Where comes the offset from?
        const offset = (character + 2) * self.header.bytesPerGlyph;
        return self.glyphs[offset .. offset + self.header.bytesPerGlyph];
    }

    pub fn Render(self: *const PSFont, target: *RenderTarget, character: u8, color: Color) void {
        const glyph = self.GetGlyph(character);
        var pixelOffset: u32 = 0;
        var mask = @intCast(u8, 1) << @intCast(u3, self.header.width - 1);
        while (pixelOffset < self.header.bytesPerGlyph * 8) : (pixelOffset += 1) {
            var glyphByte = glyph[pixelOffset / 8];
            if (pixelOffset % 8 == 0) {
                mask = @intCast(u8, 1) << @intCast(u3, self.header.width - 1);
            } else {
                mask >>= 1;
            }

            var maskResult = glyphByte & mask;
            //_ = stdout.print("PixelOffset: {}, GlyphByte: {}, MaskResult: {}, Mask: {}\n", .{pixelOffset, glyphByte, maskResult, mask}) catch unreachable;
            if (glyphByte & mask > @intCast(u8, 0)) {
                target.setPixelAtOffset(pixelOffset, color);
            }
        }
    }
};

pub const DefaultFont = PSFont.Init(DefaultFontFile);
pub const DefaultFontFile = @embedFile("../res/font.psf");

const expect = @import("std").testing.expect;
const stdout = @import("std").io.getStdOut().writer();

test "font loading" {
    expect(DefaultFont.header.magic == 0x864ab572);
}

const Renderer = @import("renderer.zig").Renderer;
const Framebuffer = @import("framebuffer.zig");
const Position = @import("framebuffer.zig").Position;

test "font rendering" {
    Framebuffer.TestFrameBuffer.reset();
    var r = Renderer{ .framebuffer = Framebuffer.TestFrameBuffer };
    var target = r.getTarget(Position{ .x = 0, .y = 0 }, 8, 16);
    DefaultFont.Render(&target, 'A', 0xFFFFFFFF);

    var x: u32 = 0;
    var y: u32 = 0;
    while (x < 8) : (x += 1) {
        while (y < 3) : (y += 1) {
            expect(Framebuffer.TestFrameBuffer.getPixel(0, 0) == 0x00000000);
        }
    }

    x = 0;
    y = 13;
    while (x < 8) : (x += 1) {
        while (y < 16) : (y += 1) {
            expect(Framebuffer.TestFrameBuffer.getPixel(0, 0) == 0x00000000);
        }
    }

    expect(Framebuffer.TestFrameBuffer.getPixel(0, 3) == 0x00000000);
    expect(Framebuffer.TestFrameBuffer.getPixel(1, 3) == 0x00000000);
    expect(Framebuffer.TestFrameBuffer.getPixel(2, 3) == 0x00000000);
    expect(Framebuffer.TestFrameBuffer.getPixel(3, 3) == 0xFFFFFFFF);
    expect(Framebuffer.TestFrameBuffer.getPixel(4, 3) == 0x00000000);
    expect(Framebuffer.TestFrameBuffer.getPixel(5, 3) == 0x00000000);
    expect(Framebuffer.TestFrameBuffer.getPixel(6, 3) == 0x00000000);
    expect(Framebuffer.TestFrameBuffer.getPixel(7, 3) == 0x00000000);
}

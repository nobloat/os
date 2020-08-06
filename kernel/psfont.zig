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
        const offset = character * self.header.bytesPerGlyph;
        return self.glyphs[offset .. offset + self.header.bytesPerGlyph];
    }

    pub fn Render(self: PSFont, target: RenderTarget, character: u8, color: Color) void {
        const glyph = self.GetGlyph(character);

        var pixelOffset: u32 = 0;

        while (pixelOffset < self.header.bytesPerGlyph * 8) : (pixelOffset += 1) {
            const bitmask = @intCast(u8, 1) << @intCast(u3, pixelOffset % 8);
            if (glyph[pixelOffset / 8] & bitmask > 0) {
                target.setPixelAtOffset(pixelOffset, color);
            }
        }
    }
};

pub const DefaultFont = PSFont.Init(DefaultFontFile);

pub const DefaultFontFile = @embedFile("../res/font.psf");

const expect = @import("std").testing.expect;
const std = @import("std");
const stdout = std.io.getStdOut().writer();

test "font loading" {
    const font = PSFont.Init(DefaultFont);
    expect(font.header.magic == 0x864ab572);

    const area = font.Render('A', 0xFFFFFFFF);
}

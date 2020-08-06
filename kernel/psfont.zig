const assert = @import("std").debug.assert;
const PixelArea = @import("framebuffer.zig").PixelArea;

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

pub const Fontsize = 8 * 16;

pub const PSFont = struct {
    header: PSFontHeader,
    glyphs: []u8,

    pub fn Init(binary: []const u8) PSFont {
        var fontHeader = @ptrCast(*const PSFontHeader, binary);
        var x: [*]u8 = @intToPtr([*]u8, @ptrToInt(&binary) + fontHeader.headerSize);
        return PSFont{ .header = fontHeader.*, .glyphs = x[0 .. fontHeader.glyphCount - 1] };
    }

    pub fn GetGlyph(self: PSFont, character: u8) []u8 {
        const offset = character * self.header.bytesPerGlyph;
        return self.glyphs[offset .. offset + self.header.bytesPerGlyph];
    }

    pub fn Render(self: PSFont, character: u8, color: Color) PixelArea {
        const glyph = self.GetGlyph(character);

        var renderArea: [Fontsize]u32 = undefined;
        var pixelOffset: u32 = 0;

        while (pixelOffset < self.header.bytesPerGlyph * 8) : (pixelOffset += 1) {
            const bitmask = @intCast(u8, 1) << @intCast(u3, pixelOffset % 8);

            if (glyph[pixelOffset / 8] & bitmask > 0) {
                renderArea[pixelOffset] = color;
            } else {
                renderArea[pixelOffset] = 0;
            }
        }

        return PixelArea{
            .width = self.header.width,
            .height = self.header.height,
            .rgba = renderArea,
        };
    }
};

pub const DefaultFont = @embedFile("../res/font.psf");

const expect = @import("std").testing.expect;
const std = @import("std");
const stdout = std.io.getStdOut().writer();

test "font loading" {
    const font = PSFont.Init(DefaultFont);
    expect(font.header.magic == 0x864ab572);

    const area = font.Render('A', 0xFFFFFFFF);
}

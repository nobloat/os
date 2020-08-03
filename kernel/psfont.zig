const assert = @import("std").debug.assert;

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

pub const PSFont = struct {
    header: PSFontHeader,
    glyphs: *const u8,

    pub fn Init(binary: []const u8) PSFont {
        var fontHeader = @ptrCast(*const PSFontHeader, binary);
        var x = @intToPtr(*const u8, @ptrToInt(&binary) + fontHeader.headerSize);

        return PSFont{ .header = fontHeader.*, .glyphs = x };
    }

    pub fn GetGlyph(self: PSFont, character: u8, ) *u8 {
        return @intToPtr(*u8, @ptrToInt(self.glyphs) + character*self.header.bytesPerGlyph);
    }

    pub fn Render(self: PSFont, character: u8, target: *u8) void {
        assert(target.len == self.header.width * self.header.height);
        @memcpy(target, self.GetGlyph(character), self.header.bytesPerGlyph);
    }
};

const DefaultFont = @embedFile("../res/font.psf");

const expect = @import("std").testing.expect;
const std = @import("std");
const stdout = std.io.getStdOut().writer();

test "font loading" {
    const font = PSFont.Init(DefaultFont);
    expect(font.header.magic == 0x864ab572);

    //TODO: bits vs. bytes etc.
    //var target = [_]u8{0} ** (8*16);
    //font.Render('A', target[0..]);
}

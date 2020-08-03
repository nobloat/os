
pub const FrameBufferType = enum(u8) {
    ARGB = 0, RGBA = 1, ABGR = 2, BGRA = 3
};

pub const Color = u32;

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

    pub fn getColor(self : FrameBuffer, alpha: u8, red: u8, green: u8, blue: u8) Color {
      switch(self.colorEncoding) {
            .ABGR => {
              return @intCast(u32,alpha) << 24 | @intCast(u32,blue) << 16 | @intCast(u32,green) << 8 | @intCast(u32,red);
            },
            .ARGB => {
              return @intCast(u32,alpha) << 24 | @intCast(u32,red) << 16 | @intCast(u32,green) << 8 | @intCast(u32,blue);
            },
            .RGBA => {
              return @intCast(u32,red) << 24 | @intCast(u32,green) << 16 | @intCast(u32,blue) << 8 | @intCast(u32,alpha);
            },
            .BGRA => {
              return @intCast(u32,blue) << 24 | @intCast(u32,green) << 16 | @intCast(u32,red) << 8 | @intCast(u32,alpha);
            }
          }
    }
};



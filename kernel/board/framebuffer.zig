
pub const Color = struct {
    red: u8,
    green: u8,
    blue: u8
};

pub const FrameBuffer = struct {
    width: u32,
    height: u32,
    fill: fn (x: u32, y: u32, width: u32, height: u32, c: Color) void
};
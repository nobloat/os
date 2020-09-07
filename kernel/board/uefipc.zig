const FrameBuffer = @import("framebuffer.zig").FrameBuffer;
const Color = @import("framebuffer.zig").Color;
const uefi = @import("std").os.uefi;
const fmt = @import("std").fmt;
const GraphicsOutputProtocol = uefi.protocols.GraphicsOutputProtocol;
const GraphicsOutputBltPixel = uefi.protocols.GraphicsOutputBltPixel;
const GraphicsOutputBltOperation = uefi.protocols.GraphicsOutputBltOperation;

const EfiBoard = struct {
    gop: *uefi.protocols.GraphicsOutputProtocol,
    fb: FrameBuffer,
};

var board = EfiBoard{.gop = undefined, .fb = FrameBuffer{.width = 0, .height = 0, .fill = fill}};

pub fn fill(x: u32, y: u32, width: u32, height: u32, color: Color) void {
    var c = [1]GraphicsOutputBltPixel{GraphicsOutputBltPixel{ .blue = color.blue, .green = color.green, .red = c.red, .reserved = 0 }};
    var j : u32 = 0;
    var i : u32 = 0;
    _ = board.gop.blt(&c,  GraphicsOutputBltOperation.BltVideoFill, 0,0, x, y, width, height, 0);
}

pub fn getFrameBuffer() *FrameBuffer {
    return &board.fb;
}

pub fn init() void {
    const boot_services = uefi.system_table.boot_services.?;

    if (boot_services.locateProtocol(&uefi.protocols.GraphicsOutputProtocol.guid, null, @ptrCast(*?*c_void, &board.gop)) != uefi.Status.Success) {
        //TODO: panic
    }

    //TODO: select largest resolution
    _ = board.gop.setMode(23);
    const mode = board.gop.mode;
    board.fb.width = mode.info.horizontal_resolution;
    board.fb.height = mode.info.vertical_resolution;
}

// _ = graphics_output_protocol.?.blt(&c, GraphicsOutputBltOperation.BltVideoFill, 0, 0, j * mode.info.horizontal_resolution / 16, j * mode.info.horizontal_resolution / 16, mode.info.horizontal_resolution / 16, mode.info.vertical_resolution / 16, 0);

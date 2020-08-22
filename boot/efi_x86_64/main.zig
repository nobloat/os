const uefi = @import("std").os.uefi;
const fmt = @import("std").fmt;
const GraphicsOutputProtocol = uefi.protocols.GraphicsOutputProtocol;
const GraphicsOutputBltPixel = uefi.protocols.GraphicsOutputBltPixel;
const GraphicsOutputBltOperation = uefi.protocols.GraphicsOutputBltOperation;

// Assigned in main().
var con_out: *uefi.protocols.SimpleTextOutputProtocol = undefined;

// We need to print each character in an [_]u8 individually because EFI
// encodes strings as UCS-2.
fn puts(msg: []const u8) void {
    for (msg) |c| {
        const c_ = [2]u16{ c, 0 }; // work around https://github.com/ziglang/zig/issues/4372
        _ = con_out.outputString(@ptrCast(*const [1:0]u16, &c_));
    }
}

fn printf(buf: []u8, comptime format: []const u8, args: anytype) void {
    puts(fmt.bufPrint(buf, format, args) catch unreachable);
}

pub fn main() void {
    con_out = uefi.system_table.con_out.?;
    const boot_services = uefi.system_table.boot_services.?;

    _ = con_out.reset(false);

    // We're going to use this buffer to format strings.
    var buf: [100]u8 = undefined;

    // Graphics output?
    var graphics_output_protocol: ?*uefi.protocols.GraphicsOutputProtocol = undefined;
    if (boot_services.locateProtocol(&uefi.protocols.GraphicsOutputProtocol.guid, null, @ptrCast(*?*c_void, &graphics_output_protocol)) == uefi.Status.Success) {
        puts("*** graphics output protocol is supported!\r\n");

        // Check supported resolutions:
        _ = graphics_output_protocol.?.setMode(23);
        

        const mode = graphics_output_protocol.?.mode;
        printf(buf[0..], "    current mode = {}\r\n", .{graphics_output_protocol.?.mode.mode});
    
        var j : u32 = 0;
        var c = [1]GraphicsOutputBltPixel{GraphicsOutputBltPixel{ .blue = 0x00, .green = 0xaa, .red = 0x00, .reserved = 0 }};
        while (j < 16) : (j += 1) {
            _ = graphics_output_protocol.?.blt(&c, GraphicsOutputBltOperation.BltVideoFill, 0, 0, j * mode.info.horizontal_resolution / 16, j * mode.info.horizontal_resolution / 16, mode.info.horizontal_resolution / 16, mode.info.vertical_resolution / 16, 0);
        }

        
    } else {
        puts("*** graphics output protocol is NOT supported :(\r\n");
    }
    _ = boot_services.stall(20 * 1000 * 1000);
}

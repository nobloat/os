const boot = @import("bootboot.zig");
const FrameBuffer = @import("framebuffer.zig").FrameBuffer;
const Position = @import("framebuffer.zig").Position;
const Color = @import("framebuffer.zig").Color;
const FrameBufferType = @import("framebuffer.zig").FrameBufferType;
const PSFont = @import("psfont.zig").PSFont;
const DefaultFont = @import("psfont.zig").DefaultFont;
const Renderer = @import("renderer.zig").Renderer;
const Direction = @import("renderer.zig").Direction;
const fmt = @import("std").fmt;
const portio = @import("arch/x86_64/portio.zig");
const ArchFunctions = @import("arch/arch.zig").ArchFunctions;

//Integration test within qemu
export fn _start() void {
    var bootId = boot.bootboot.bspId;
    ArchFunctions.suspendMultiCores();
    ArchFunctions.init();
    ArchFunctions.exit(1);
    ArchFunctions.halt();
}

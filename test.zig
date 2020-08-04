test "main" {
  _ = @import("kernel/bootboot.zig");
  _ = @import("kernel/framebuffer.zig");
  _ = @import("kernel/renderer.zig");
  _ = @import("kernel/psfont.zig");
}
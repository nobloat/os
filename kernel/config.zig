pub extern var environment: [*]const u8 = undefined;

pub const Config = extern struct {
    environment: [*]const u8,

    pub fn keys(c: Config) void {
        var i: u32 = 0;
        while (environment[i] != 0) : (i += 1) {
            var start: u32 = i;
            while (environment[i] != '=' and environment[i] != 0) : (i += 1) {}
            var key = environment[start..i];
            _ = stdout.print("Key: {}", .{key}) catch unreachable;
        }
    }
};

const stdout = @import("std").io.getStdOut().writer();
const expect = @import("std").testing.expect;

test "config keys and values" {
    const memory = "key1=value1\nkey2=value2";
    //const c = Config{ .environment = @ptrCast([*]const u8, memory) };

    //c.keys();
    //expect(c.keys() == .{"key1", "key2"});
}

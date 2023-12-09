const one = @import("1.zig");
const two = @import("2.zig");

pub fn main() !void {
    _ = try one.main();
    _ = try two.main();
}

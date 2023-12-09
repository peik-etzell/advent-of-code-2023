const std = @import("std");
const allocator = std.heap.page_allocator;
const stdout = std.io.getStdOut().writer();

const map = std.ComptimeStringMap(usize, .{
    .{ "one", 1 },
    .{ "two", 2 },
    .{ "three", 3 },
    .{ "four", 4 },
    .{ "five", 5 },
    .{ "six", 6 },
    .{ "seven", 7 },
    .{ "eight", 8 },
    .{ "nine", 9 },
    .{ "0", 0 },
    .{ "1", 1 },
    .{ "2", 2 },
    .{ "3", 3 },
    .{ "4", 4 },
    .{ "5", 5 },
    .{ "6", 6 },
    .{ "7", 7 },
    .{ "8", 8 },
    .{ "9", 9 },
});

fn calibration_2(str: []const u8) usize {
    var first: usize = 0;
    var last: usize = 0;
    for (0..str.len) |idx| {
        for (map.kvs) |kv| {
            if (std.mem.eql(u8, str[idx..@min(idx + kv.key.len, str.len)], kv.key)) {
                if (first == 0) {
                    first = kv.value;
                }
                last = kv.value;
            }
        }
    }
    return 10 * first + last;
}

fn calibration_1(str: []const u8) u8 {
    var first: u8 = 255;
    var last: u8 = 0;
    for (str) |c| {
        switch (c) {
            '0'...'9' => {
                const n = c - '0';
                if (first == 255) {
                    first = n;
                }
                last = n;
            },
            else => continue,
        }
    }
    return 10 * first + last;
}

pub fn main() !void {
    const file = try std.fs.cwd().openFile("data/1", .{});
    defer file.close();
    var buffered_reader = std.io.bufferedReader(file.reader());
    var in_stream = buffered_reader.reader();
    var buf: [1024]u8 = undefined;
    var sum_1: u64 = 0;
    var sum_2: u64 = 0;

    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        sum_1 += calibration_1(line);
        sum_2 += calibration_2(line);
    }

    std.debug.print("SUM 1.1: {}\n", .{sum_1});
    std.debug.print("SUM 1.2: {}\n", .{sum_2});
}

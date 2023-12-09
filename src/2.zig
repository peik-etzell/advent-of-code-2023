const std = @import("std");
const stdout = std.io.getStdOut().writer();

// const Cube = enum { Red, Green, Blue };

const Hand = struct {
    red: u32,
    green: u32,
    blue: u32,
    fn power(self: Hand) u32 {
        return self.red * self.green * self.blue;
    }
};

fn zeroHand() Hand {
    return Hand{ .red = 0, .green = 0, .blue = 0 };
}

fn elemWiseMax(a: Hand, b: Hand) Hand {
    return Hand{
        .red = @max(a.red, b.red),
        .green = @max(a.green, b.green),
        .blue = @max(a.blue, b.blue),
    };
}

const part_one_limit = Hand{ .red = 12, .green = 13, .blue = 14 };

fn parse_hand(line: []const u8) Hand {
    var chunks = std.mem.tokenizeAny(u8, line, ", ");
    var x: u32 = 0;
    var res = zeroHand();
    while (chunks.next()) |chunk| {
        x = std.fmt.parseInt(u32, chunk, 10) catch x;

        if (std.mem.eql(u8, "red", chunk)) {
            res.red = x;
            x = 0;
        }
        if (std.mem.eql(u8, "green", chunk)) {
            res.green = x;
            x = 0;
        }
        if (std.mem.eql(u8, "blue", chunk)) {
            res.blue = x;
            x = 0;
        }
    }
    return res;
}

fn hand_ok(hand: Hand) bool {
    return hand.red <= part_one_limit.red and hand.green <= part_one_limit.green and hand.blue <= part_one_limit.blue;
}

pub fn main() !void {
    const file = try std.fs.cwd().openFile("data/2", .{});
    defer file.close();
    var buffered_reader = std.io.bufferedReader(file.reader());
    var in_stream = buffered_reader.reader();
    var buf: [1024]u8 = undefined;

    var part1: u32 = 0;
    var part2: u32 = 0;

    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var chunks = std.mem.tokenizeAny(u8, line, ":;");
        const gameId = blk: {
            if (chunks.next()) |game| {
                break :blk std.fmt.parseInt(u32, game["Game ".len..], 10) catch 0;
            } else {
                continue;
            }
        };
        var ok = true;
        var minimum = zeroHand();
        while (chunks.next()) |chunk| {
            const hand = parse_hand(chunk);
            ok = ok and hand_ok(hand);

            minimum = elemWiseMax(minimum, hand);
        }
        if (ok) {
            part1 += gameId;
        }
        part2 += minimum.power();
    }
    std.debug.print("SUM 2.1: {d}\n", .{part1});
    std.debug.print("SUM 2.2: {d}\n", .{part2});
}

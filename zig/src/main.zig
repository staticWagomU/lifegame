const std = @import("std");
const print = std.debug.print;
const time = std.time;

const N = 32;
const nextState = [2][9]u1{
    [_]u1{ 0, 0, 0, 1, 0, 0, 0, 0, 0 },
    [_]u1{ 0, 0, 1, 1, 0, 0, 0, 0, 0 },
};

pub fn main() anyerror!void {
    var cells: [N][N]u1 = initField();
    var nextGen: [N][N]u1 = undefined;

    var i: u8 = 0;
    while (i < 10) : (i += 1) {
        cells[16][i + 10] = 1;
    }

    while (true) {
        print("\x1B[2J\x1B[H", .{});

        for (cells) |_, y| {
            for (cells[y]) |_, x| {
                const c: *const [1:0]u8 = if (cells[y][x] == 1) "o" else "-";
                print("{s} ", .{c});
            }
            print("\n", .{});
        }

        for (cells) |_, _y| {
            for (cells[_y]) |_, _x| {
                var count: u8 = 0;
                const x = @intCast(i8, _x);
                const y = @intCast(i8, _y);
                const current: u8 = cells[_y][_x];

                count += cells[@intCast(usize,(y - 1) & 0x1f)][@intCast(usize, (x + 0) & 0x1f)];
                count += cells[@intCast(usize,(y - 1) & 0x1f)][@intCast(usize, (x + 1) & 0x1f)];
                count += cells[@intCast(usize,(y + 0) & 0x1f)][@intCast(usize, (x + 1) & 0x1f)];
                count += cells[@intCast(usize,(y + 1) & 0x1f)][@intCast(usize, (x + 1) & 0x1f)];
                count += cells[@intCast(usize,(y + 1) & 0x1f)][@intCast(usize, (x + 0) & 0x1f)];
                count += cells[@intCast(usize,(y + 1) & 0x1f)][@intCast(usize, (x - 1) & 0x1f)];
                count += cells[@intCast(usize,(y + 0) & 0x1f)][@intCast(usize, (x - 1) & 0x1f)];
                count += cells[@intCast(usize,(y - 1) & 0x1f)][@intCast(usize, (x - 1) & 0x1f)];

                nextGen[_y][_x] = nextState[current][count];
            }
        }

        time.sleep(100000000);

        for (cells) |_, y| {
            for (cells[y]) |_, x| {
                cells[y][x] = nextGen[y][x];
            }
        }
    }
}

fn initField() [N][N]u1 {
    var cells: [N][N]u1 = undefined;
    for (cells) |*y| {
        for (y) |*x| {
            x.* = 0;
        }
    }
    return cells;
}


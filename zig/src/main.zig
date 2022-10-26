const std = @import("std");
const print = std.io.getStdOut().writer().print;
const time = std.time;

const N = 32;
const nextState = [2][9]u1{
    [_]u1{ 0, 0, 0, 1, 0, 0, 0, 0, 0 },
    [_]u1{ 0, 0, 1, 1, 0, 0, 0, 0, 0 },
};

pub fn main() anyerror!void {
    var cells = initField();
    var nextGen: [N][N]u1 = undefined;

    var i: u8 = 0;
    while (i < 10) : (i += 1) {
        cells[16][i + 10] = 1;
    }

    while (true) {
        try print("\x1B[2J\x1B[H", .{});

        for (cells) |_, y| {
            for (cells[y]) |_, x| {
                const c: *const [1:0]u8 = if (cells[y][x] == 1) "#" else " ";
                try print("{s} ", .{c});
            }
            try print("\n", .{});
        }

        for (cells) |_, _y| {
            for (cells[_y]) |_, _x| {
                const x = @intCast(u5, _x);
                const y = @intCast(u5, _y);
                var count: u5 = 0;
                const current = cells[y][x];

                count += cells[y -% 1][x +% 0];
                count += cells[y -% 1][x +% 1];
                count += cells[y +% 0][x +% 1];
                count += cells[y +% 1][x +% 1];
                count += cells[y +% 1][x +% 0];
                count += cells[y +% 1][x -% 1];
                count += cells[y +% 0][x -% 1];
                count += cells[y -% 1][x -% 1];

                nextGen[y][x] = nextState[current][count];
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

const std = @import("std");

const Context = struct {
    name: []const u8,
    complexity: u8,
};

pub fn main(init: std.process.Init) !void {
    var context_list: std.ArrayList(Context) = .empty;
    defer context_list.deinit(init.gpa);

    var arg_iterator = init.minimal.args.iterate();
    defer arg_iterator.deinit();
    _ = arg_iterator.next(); // skip the app bin path
    const command: ?[:0]const u8 = arg_iterator.next();

    if (command != null and std.mem.eql(u8, command.?, "add")) {
        const name = arg_iterator.next();
        if (name == null) {
            std.log.info("ERROR: missing required paramters: `sentinel add <name> <complexity>`", .{});
            return;
        }
        const complexity_str = arg_iterator.next();
        if (complexity_str == null) {
            std.log.info("ERROR: missing required paramters: `sentinel add <name> <complexity>`", .{});
            return;
        }

        try context_list.append(init.gpa, .{
            .name = name.?,
            .complexity = try std.fmt.parseInt(u8, complexity_str.?, 10),
        });
    }

    for (context_list.items) |it| {
        std.log.debug("Name: {s}", .{it.name});
        std.log.debug("Complexity: {d}", .{it.complexity});
    }
}

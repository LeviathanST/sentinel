const std = @import("std");

const MAX_BIOLOGICAL_RAM = 10;

const Context = struct {
    name: []const u8,
    complexity: u8,
};

const ContextList = struct {
    list: std.ArrayList(Context) = .empty,
    total_complexity: u8 = 0,

    pub fn deinit(self: *ContextList, alloc: std.mem.Allocator) void {
        self.list.deinit(alloc);
    }

    pub fn add(
        self: *ContextList,
        alloc: std.mem.Allocator,
        ctx: Context,
    ) !void {
        try self.list.append(alloc, ctx);
        self.total_complexity += ctx.complexity;
    }
};

pub fn main(init: std.process.Init) !void {
    var context_list: ContextList = .{};
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
        const complexity = try std.fmt.parseInt(u8, complexity_str.?, 10);

        if (context_list.total_complexity + complexity > MAX_BIOLOGICAL_RAM) {
            std.log.info("You're overloaded!", .{});
            return;
        }

        try context_list.add(init.gpa, .{
            .name = name.?,
            .complexity = complexity,
        });
    }

    for (context_list.list.items) |it| {
        std.log.debug("Name: {s}", .{it.name});
        std.log.debug("Complexity: {d}", .{it.complexity});
    }
}

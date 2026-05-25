const std = @import("std");

const MAX_BIOLOGICAL_RAM = 10;

pub const Idea = struct {
    name: []const u8,
    /// How much the comlexity of the idea?
    complexity: u4, // 0 - 10
    /// How much technical truth is here? (.e.g., raw code, first principles)
    signal: u4, // 0 - 10
    /// How much long-term impact does this have?
    vision: u4, // 0 - 10
    /// How much is this just "hype" or "busy work"?
    noise: u4, // 0 - 10
};

pub const IdeaList = struct {
    list: std.ArrayList(Idea) = .empty,
    total_complexity: u8 = 0,

    pub fn deinit(self: *IdeaList, alloc: std.mem.Allocator) void {
        self.list.deinit(alloc);
    }

    pub fn add(
        self: *IdeaList,
        alloc: std.mem.Allocator,
        ctx: Idea,
    ) !void {
        try self.list.append(alloc, ctx);
        self.total_complexity += ctx.complexity;
    }
};

fn add(
    gpa: std.mem.Allocator,
    arg_iterator: *std.process.Args.Iterator,
    idea_list: *IdeaList,
) !void {
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

    const signal_str = arg_iterator.next();
    if (signal_str == null) {
        std.log.info("ERROR: missing required paramters: `sentinel add <name> <complexity>`", .{});
        return;
    }

    const vision_str = arg_iterator.next();
    if (vision_str == null) {
        std.log.info("ERROR: missing required paramters: `sentinel add <name> <complexity>`", .{});
        return;
    }

    const noise_str = arg_iterator.next();
    if (noise_str == null) {
        std.log.info("ERROR: missing required paramters: `sentinel add <name> <complexity>`", .{});
        return;
    }

    const complexity = try std.fmt.parseInt(u4, complexity_str.?, 10);
    const signal = try std.fmt.parseInt(u4, signal_str.?, 10);
    const vision = try std.fmt.parseInt(u4, vision_str.?, 10);
    const noise = try std.fmt.parseInt(u4, noise_str.?, 10);

    if (idea_list.total_complexity + complexity > MAX_BIOLOGICAL_RAM) {
        std.log.info("You're overloaded!", .{});
        return;
    }

    try idea_list.add(gpa, .{
        .name = name.?,
        .complexity = complexity,
        .signal = signal,
        .vision = vision,
        .noise = noise,
    });
}

fn score(idea_list: IdeaList) void {
    for (idea_list.list.items) |it| {
        std.log.info("Name: {s}", .{it.name});
        // Why these weights?
        // Because Noise is a "Negative Gradient." It kills your productivity faster than Signal can
        // build it.
        const result =
            @as(f32, @floatFromInt(it.signal)) * 0.5 +
            @as(f32, @floatFromInt(it.vision)) * 0.4 -
            @as(f32, @floatFromInt(it.noise)) * 0.8;
        std.log.info("Score: {f}", .{result});
    }
}

pub fn main(init: std.process.Init) !void {
    var idea_list: IdeaList = .{};
    defer idea_list.deinit(init.gpa);

    var arg_iterator = init.minimal.args.iterate();
    defer arg_iterator.deinit();
    _ = arg_iterator.next(); // skip the app bin path
    const command: ?[:0]const u8 = arg_iterator.next();

    // TODO: return error
    if (command == null) return;

    if (std.mem.eql(u8, command.?, "add")) {
        try add(init.gpa, &arg_iterator, &idea_list);
    } else if (std.mem.eql(u8, command.?, "score")) {
        score(idea_list);
    }
}

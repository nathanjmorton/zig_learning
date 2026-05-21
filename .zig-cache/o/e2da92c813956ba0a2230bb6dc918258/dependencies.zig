pub const packages = struct {
    pub const @"zio-0.11.0-xHbVVEqQGwDz0MYoQ0j7Ke0Y9E_iZVe5eLAWK4gd9U0i" = struct {
        pub const build_root = "/Users/nathanjmorton/codes/study/zig_learning/zig-pkg/zio-0.11.0-xHbVVEqQGwDz0MYoQ0j7Ke0Y9E_iZVe5eLAWK4gd9U0i";
        pub const build_zig = @import("zio-0.11.0-xHbVVEqQGwDz0MYoQ0j7Ke0Y9E_iZVe5eLAWK4gd9U0i");
        pub const deps: []const struct { []const u8, []const u8 } = &.{
        };
    };
};

pub const root_deps: []const struct { []const u8, []const u8 } = &.{
    .{ "zio", "zio-0.11.0-xHbVVEqQGwDz0MYoQ0j7Ke0Y9E_iZVe5eLAWK4gd9U0i" },
};

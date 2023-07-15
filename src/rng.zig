const std = @import("std");
const floor = std.math.floor;
const ceil = std.math.ceil;

const lua = @import("./lua.zig");
const LuaState = lua.LuaState;
const luaL_Reg = lua.luaL_Reg;

pub export fn rng_call(L: *LuaState) callconv(.C) c_int {
    var x = L.at(1).field("x").getNumber(u32);
    var y = L.at(1).field("y").getNumber(u32);
    var z = L.at(1).field("z").getNumber(u32);
    x = (((x << 13) ^ x) >> 19) ^ ((x & 0x000ffffe) << 12);
    y = (((y << 2) ^ y) >> 25) ^ ((y & 0x0ffffff8) << 4);
    z = (((z << 3) ^ z) >> 11) ^ ((z & 0x00007ff0) << 17);
    var t = @as(f64, @floatFromInt(x ^ y ^ z)) * 0x1p-32;
    L.at(1).field("x").setNumber(u32, x);
    L.at(1).field("y").setNumber(u32, y);
    L.at(1).field("z").setNumber(u32, z);

    var r: f64 = switch (L.getTop()) {
        1 => t,
        2 => blk: {
            const hi = floor(L.at(2).getNumber(f64));
            break :blk floor(1 + hi * t);
        },
        3 => blk: {
            const lo = ceil(L.at(2).getNumber(f64));
            const hi = floor(L.at(3).getNumber(f64));
            break :blk floor(lo + (hi - lo + 1) * t);
        },
        else => unreachable,
    };

    L.pushNumber(f64, r);
    return 1;
}

pub const rng: [1:luaL_Reg.SENTINEL]luaL_Reg = [_:luaL_Reg.SENTINEL]luaL_Reg{
    luaL_Reg{
        .name = "call",
        .func = &rng_call,
    },
};

pub export fn luaopen_rng(L: *LuaState) c_int {
    L.checkStack(1);

    L._createtable(0, rng.len);
    L._L_setfuncs(&rng, 0);
    return 1;
}

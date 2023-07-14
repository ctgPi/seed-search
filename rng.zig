pub const LuaNumber = f64;

pub const lua_CFunction = ?*const fn (*LuaState) callconv(.C) c_int;
pub extern fn lua_gettop(L: *LuaState) c_int;
pub extern fn lua_settop(L: *LuaState, idx: c_int) void;
pub extern fn lua_gettable(L: *LuaState, idx: c_int) void;
pub extern fn lua_settable(L: *LuaState, idx: c_int) void;
pub extern fn lua_checkstack(L: *LuaState, sz: c_int) c_int;
pub extern fn lua_tonumberx(L: *LuaState, idx: c_int, isnum: [*c]c_int) LuaNumber;
pub extern fn lua_error(L: *LuaState) noreturn;
pub extern fn lua_pushnumber(L: *LuaState, n: LuaNumber) void;
pub extern fn lua_pushlstring(L: *LuaState, s: [*c]const u8, len: usize) [*]const u8;
pub extern fn lua_createtable(L: *LuaState, narr: c_int, nrec: c_int) void;

pub const luaL_Reg = extern struct {
    name: [*c]const u8,
    func: lua_CFunction,

    pub const SENTINEL = luaL_Reg { .name = null, .func = null };
};
pub extern fn luaL_setfuncs(L: *LuaState, l: [*c]const luaL_Reg, nup: c_int) void;

pub const LuaState = opaque {
    pub inline fn _checkstack(self: *LuaState, extra: c_int) c_int {
        return lua_checkstack(self, extra);
    }

    pub inline fn _pushnumber(self: *LuaState, n: LuaNumber) void {
        lua_pushnumber(self, n);
    }

    pub inline fn _gettop(self: *LuaState) c_int {
        return lua_gettop(self);
    }

    pub inline fn _settop(self: *LuaState, index: c_int) void {
        lua_settop(self, index);
    }

    pub inline fn _gettable(self: *LuaState, index: c_int) void {
        lua_gettable(self, index);
    }

    pub inline fn _settable(self: *LuaState, index: c_int) void {
        lua_settable(self, index);
    }

    pub inline fn _createtable(self: *LuaState, narr: c_int, nrec: c_int) void {
        lua_createtable(self, narr, nrec);
    }

    pub inline fn _tonumberx(L: *LuaState, idx: c_int, isnum: [*c]c_int) LuaNumber {
        return lua_tonumberx(L, idx, isnum);
    }

    pub inline fn _L_setfuncs(self: *LuaState, l: [*c]const luaL_Reg, nup: c_int) void {
        luaL_setfuncs(self, l, nup);
    }


    pub inline fn checkStack(self: *LuaState, size: usize) void {
        assert(self._checkstack(@intCast(c_int, size)) != 0);
    }

    pub inline fn getTop(self: *LuaState) usize {
        return @intCast(usize, self._gettop());
    }

    pub inline fn checkIndex(self: *LuaState, index: anytype) void {
        const top = self.getTop();
        switch (@typeInfo(@TypeOf(index))) {
            .Int => |index_type| {
                if (index_type.signedness == .unsigned) {
                    assert(index > 0 and index < top);
                } else {
                    assert((index > 0 and index <= top) or (index < 0 and -index <= top));
                }
            },
            .ComptimeInt => {
                assert((index > 0 and index <= top) or (index < 0 and -index <= top));
            },
            else => @compileError("index type must be an integer type (not " ++ @typeName(@TypeOf(index)) ++ ")"),
        }
    }

    pub inline fn setTop(self: *LuaState, index: anytype) void {
        if (index < 0) self.checkIndex(index);
        
        self._settop(@intCast(c_int, index));
    }

    pub inline fn fromLuaNumber(_: *const LuaState, comptime T: type, value: LuaNumber) T {
        return switch(@typeInfo(LuaNumber)) {
            .Int => @compileError("integer types for LuaNumber are not implemented"),  // TODO
            .Float => switch (@typeInfo(T)) {
                .Int => @floatToInt(T, value),
                .Float => @floatCast(T, value),
                else => @compileError("destination type must be a number type (not " ++ @typeName(T) ++ ")"),
            },
            else => @compileError("LuaNumber must be a number type (not " ++ @typeName(LuaNumber) ++ ")"),
        };
    }

    pub inline fn toLuaNumber(_: *const LuaState, comptime T: type, value: T) LuaNumber {
        return switch(@typeInfo(LuaNumber)) {
            .Int => @compileError("integer types for LuaNumber are not implemented"),  // TODO
            .Float => switch (@typeInfo(T)) {
                .Int => @intToFloat(LuaNumber, value),
                .Float => @floatCast(LuaNumber, value),
                else => @compileError("source type must be a number type (not " ++ @typeName(T) ++ ")"),
            },
            else => @compileError("LuaNumber must be a number type (not " ++ @typeName(LuaNumber) ++ ")"),
        };
    }

    pub inline fn getNumber(self: *LuaState, comptime T: type, index: anytype) T {
        self.checkIndex(index);

        var is_num: c_int = undefined;
        const value = self._tonumberx(@intCast(c_int, index), &is_num);
        assert(is_num != 0);

        return self.fromLuaNumber(T, value);
    }

    pub inline fn pushNumber(self: *LuaState, comptime T: type, value: T) void {
        self.checkStack(1);

        self._pushnumber(self.toLuaNumber(T, value));
    }

    pub inline fn popNumber(self: *LuaState, comptime T: type) T {
        assert(self.getTop() >= 1);

        const value = self.getNumber(T, -1);
        self._settop(-2);
        return value;
    }

    pub inline fn pushString(self: *LuaState, s: []const u8) void {
        self.checkStack(1);

        _ = lua_pushlstring(self, s.ptr, s.len);
    }

    pub const LuaStackRef = struct {
        L: *LuaState,
        index: isize,

        pub inline fn getNumber(self: *const LuaStackRef, comptime T: type) T {
            self.L.checkIndex(self.index);

            return self.L.getNumber(T, self.index);
        }

        pub inline fn field(self: *const LuaStackRef, key: []const u8) LuaFieldRef {
            return LuaFieldRef{ .L = self.L, .index = self.index, .key = key };
        }
    };

    pub const LuaFieldRef = struct {
        L: *LuaState,
        index: isize,
        key: []const u8,

        pub inline fn getNumber(self: *const LuaFieldRef, comptime T: type) T {
            self.L.checkStack(1);
            self.L.checkIndex(self.index);

            self.L.pushString(self.key);
            self.L._gettable(@intCast(c_int, self.index));
            return self.L.popNumber(T);
        }

        pub inline fn setNumber(self: *const LuaFieldRef, comptime T: type, value: T) void {
            self.L.checkStack(2);
            self.L.checkIndex(self.index);

            self.L.pushString(self.key);
            self.L.pushNumber(T, value);
            self.L._settable(@intCast(c_int, self.index));
        }
    };

    pub inline fn at(L: *LuaState, index: c_int) LuaStackRef {
        return LuaStackRef{ .L = L, .index = index };
    }
};

const std = @import("std");
const assert = std.debug.assert;
const floor = std.math.floor;
const ceil = std.math.ceil;

pub export fn rng_call(L: *LuaState) callconv(.C) c_int {
    var x = L.at(1).field("x").getNumber(u32);
    var y = L.at(1).field("y").getNumber(u32);
    var z = L.at(1).field("z").getNumber(u32);
    x = (((x << 13) ^ x) >> 19) ^ ((x & 0x000ffffe) << 12);
    y = (((y <<  2) ^ y) >> 25) ^ ((y & 0x0ffffff8) <<  4);
    z = (((z <<  3) ^ z) >> 11) ^ ((z & 0x00007ff0) << 17);
    var t = @intToFloat(f64, x ^ y ^ z) * 0x1p-32;
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
        .name = "rng_call",
        .func = &rng_call,
    },
};

pub export fn luaopen_rng(L: *LuaState) c_int {
    L.checkStack(1);

    L._createtable(0, rng.len);
    L._L_setfuncs(&rng, 0);
    return 1;
}

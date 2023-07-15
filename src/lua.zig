const std = @import("std");
const assert = std.debug.assert;

pub const LuaNumber = f64;

pub const lua_CFunction = ?*const fn (*LuaState) callconv(.C) c_int;
pub extern fn lua_gettop(L: *LuaState) c_int;
pub extern fn lua_settop(L: *LuaState, idx: c_int) void;
pub extern fn lua_gettable(L: *LuaState, idx: c_int) void;
pub extern fn lua_settable(L: *LuaState, idx: c_int) void;
pub extern fn lua_checkstack(L: *LuaState, sz: c_int) c_int;
pub extern fn lua_tonumberx(L: *LuaState, idx: c_int, isnum: *c_int) LuaNumber;
pub extern fn lua_tolstring(L: *LuaState, idx: c_int, len: *usize) [*]const u8;
pub extern fn lua_error(L: *LuaState) noreturn;
pub extern fn lua_concat(L: *LuaState, n: c_int) void;
pub extern fn lua_pushnumber(L: *LuaState, n: LuaNumber) void;
pub extern fn lua_pushlstring(L: *LuaState, s: [*]const u8, len: usize) [*]const u8;
pub extern fn lua_createtable(L: *LuaState, narr: c_int, nrec: c_int) void;

pub const luaL_Reg = extern struct {
    name: [*c]const u8,
    func: lua_CFunction,

    pub const SENTINEL = luaL_Reg{ .name = null, .func = null };
};
pub extern fn luaL_setfuncs(L: *LuaState, l: [*:luaL_Reg.SENTINEL]const luaL_Reg, nup: c_int) void;

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

    pub inline fn _tonumberx(L: *LuaState, idx: c_int, isnum: *c_int) LuaNumber {
        return lua_tonumberx(L, idx, isnum);
    }

    pub inline fn _tolstring(L: *LuaState, idx: c_int, len: *usize) ?[*]const u8 {
        return lua_tolstring(L, idx, len);
    }

    pub inline fn _concat(L: *LuaState, n: c_int) void {
        lua_concat(L, n);
    }

    pub inline fn _error(L: *LuaState) noreturn {
        lua_error(L);
    }

    pub inline fn _L_setfuncs(self: *LuaState, l: [*:luaL_Reg.SENTINEL]const luaL_Reg, nup: c_int) void {
        luaL_setfuncs(self, l, nup);
    }

    pub inline fn checkStack(self: *LuaState, size: usize) void {
        assert(self._checkstack(@intCast(size)) != 0);
    }

    pub inline fn getTop(self: *LuaState) usize {
        return @intCast(self._gettop());
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

        self._settop(@intCast(index));
    }

    pub inline fn fromLuaNumber(_: *const LuaState, comptime T: type, value: LuaNumber) T {
        return switch (@typeInfo(LuaNumber)) {
            .Int => @compileError("integer types for LuaNumber are not implemented"), // TODO
            .Float => switch (@typeInfo(T)) {
                .Int => @intFromFloat(value),
                .Float => @floatCast(value),
                else => @compileError("destination type must be a number type (not " ++ @typeName(T) ++ ")"),
            },
            else => @compileError("LuaNumber must be a number type (not " ++ @typeName(LuaNumber) ++ ")"),
        };
    }

    pub inline fn toLuaNumber(_: *const LuaState, comptime T: type, value: T) LuaNumber {
        return switch (@typeInfo(LuaNumber)) {
            .Int => @compileError("integer types for LuaNumber are not implemented"), // TODO
            .Float => switch (@typeInfo(T)) {
                .Int => @floatFromInt(value),
                .Float => @floatCast(value),
                else => @compileError("source type must be a number type (not " ++ @typeName(T) ++ ")"),
            },
            else => @compileError("LuaNumber must be a number type (not " ++ @typeName(LuaNumber) ++ ")"),
        };
    }

    pub inline fn getNumber(self: *LuaState, comptime T: type, index: anytype) T {
        self.checkIndex(index);

        var is_num: c_int = undefined;
        const value = self._tonumberx(@intCast(index), &is_num);
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

    pub inline fn getString(self: *LuaState, index: anytype) []const u8 {
        self.checkIndex(index);

        var len: usize = undefined;
        const ptr = self._tolstring(@intCast(index), &len);
        assert(ptr != null);

        return ptr.?[0..len];
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
            self.L._gettable(@intCast(self.index));
            return self.L.popNumber(T);
        }

        pub inline fn setNumber(self: *const LuaFieldRef, comptime T: type, value: T) void {
            self.L.checkStack(2);
            self.L.checkIndex(self.index);

            self.L.pushString(self.key);
            self.L.pushNumber(T, value);
            self.L._settable(@intCast(self.index));
        }
    };

    pub inline fn at(L: *LuaState, index: isize) LuaStackRef {
        return LuaStackRef{ .L = L, .index = index };
    }
};

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
pub extern fn lua_touserdata(L: *LuaState, idx: c_int) ?*anyopaque;
pub extern fn lua_error(L: *LuaState) noreturn;
pub extern fn lua_concat(L: *LuaState, n: c_int) void;
pub extern fn lua_pushnumber(L: *LuaState, n: LuaNumber) void;
pub extern fn lua_pushboolean(L: *LuaState, b: c_int) void;
pub extern fn lua_pushlightuserdata(L: *LuaState, p: ?*anyopaque) void;
pub extern fn lua_pushnil(L: *LuaState) void;
pub extern fn lua_pushvalue(L: *LuaState, idx: c_int) void;
pub extern fn lua_pushlstring(L: *LuaState, s: [*]const u8, len: usize) [*]const u8;
pub extern fn lua_createtable(L: *LuaState, narr: c_int, nrec: c_int) void;
pub extern fn luaL_len(L: *LuaState, idx: c_int) c_int;

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

    pub inline fn _pushboolean(self: *LuaState, b: c_int) void {
        lua_pushboolean(self, b);
    }

    pub inline fn _pushvalue(self: *LuaState, idx: c_int) void {
        lua_pushvalue(self, idx);
    }

    pub inline fn _pushnil(self: *LuaState) void {
        lua_pushnil(self);
    }

    pub inline fn _pushlightuserdata(self: *LuaState, p: ?*anyopaque) void {
        lua_pushlightuserdata(self, p);
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

    pub inline fn _touserdata(L: *LuaState, idx: c_int) ?*anyopaque {
        return lua_touserdata(L, idx);
    }

    pub inline fn _concat(L: *LuaState, n: c_int) void {
        lua_concat(L, n);
    }

    pub inline fn _error(L: *LuaState) noreturn {
        lua_error(L);
    }

    pub inline fn _L_len(L: *LuaState, idx: c_int) c_int {
        return luaL_len(L, idx);
    }

    pub inline fn _L_setfuncs(self: *LuaState, l: [*:luaL_Reg.SENTINEL]const luaL_Reg, nup: c_int) void {
        luaL_setfuncs(self, l, nup);
    }

    //// //// //// //// ////

    pub inline fn checkStack(self: *LuaState, size: usize) void {
        assert(self._checkstack(@intCast(size)) != 0);
    }

    pub inline fn getStackTop(self: *LuaState) usize {
        return @intCast(self._gettop());
    }

    pub inline fn validatePosition(self: *LuaState, position: anytype) void {
        const top = self.getStackTop();
        switch (@typeInfo(@TypeOf(position))) {
            .Int => |index_type| {
                if (index_type.signedness == .unsigned) {
                    assert(position > 0 and position < top);
                } else {
                    assert((position > 0 and position <= top) or (position < 0 and -position <= top));
                }
            },
            .ComptimeInt => {
                assert((position > 0 and position <= top) or (position < 0 and -position <= top));
            },
            else => @compileError("position type must be an integer type (not " ++ @typeName(@TypeOf(position)) ++ ")"),
        }
    }

    pub inline fn setStackTop(self: *LuaState, position: anytype) void {
        if (position < 0) self.validatePosition(position);

        self._settop(@intCast(position));
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

    pub inline fn getNumber(self: *LuaState, comptime T: type, position: anytype) T {
        self.validatePosition(position);

        var is_num: c_int = undefined;
        const value = self._tonumberx(@intCast(position), &is_num);
        assert(is_num != 0);

        return self.fromLuaNumber(T, value);
    }

    pub inline fn pushNumber(self: *LuaState, comptime T: type, value: T) void {
        self.checkStack(1);

        self._pushnumber(self.toLuaNumber(T, value));
    }

    pub inline fn popNumber(self: *LuaState, comptime T: type) T {
        assert(self.getStackTop() >= 1);

        const value = self.getNumber(T, -1);
        self._settop(-2);
        return value;
    }

    pub inline fn getString(self: *LuaState, position: anytype) []const u8 {
        self.validatePosition(position);

        var len: usize = undefined;
        const ptr = self._tolstring(@intCast(position), &len);
        assert(ptr != null);

        return ptr.?[0..len];
    }

    pub inline fn pushString(self: *LuaState, s: []const u8) void {
        self.checkStack(1);

        _ = lua_pushlstring(self, s.ptr, s.len);
    }

    pub inline fn pushBoolean(self: *LuaState, value: bool) void {
        self.checkStack(1);

        self._pushboolean(@intFromBool(value));
    }

    pub inline fn getLightUserData(self: *LuaState, position: anytype) *anyopaque {
        self.validatePosition(position);

        const ptr = self._touserdata(@intCast(position));
        assert(ptr != null);

        return ptr.?;
    }

    pub inline fn pushLightUserData(self: *LuaState, p: *anyopaque) void {
        self.checkStack(1);

        self._pushlightuserdata(p);
    }

    pub inline fn popLightUserData(self: *LuaState) *anyopaque {
        assert(self.getStackTop() >= 1);

        const value = self.getLightUserData(-1);
        self._settop(-2);
        return value;
    }

    pub inline fn pushNil(self: *LuaState) void {
        self.checkStack(1);

        self._pushnil();
    }

    pub inline fn getLength(self: *LuaState, position: anytype) usize {
        self.validatePosition(position);

        return @intCast(self._L_len(position));
    }

    pub inline fn copy(self: *LuaState, position: anytype) void {
        self.checkStack(1);
        self.validatePosition(position);

        self._pushvalue(@intCast(position));
    }

    pub inline fn at(L: *LuaState, position: isize) LuaStackRef {
        return LuaStackRef{ .L = L, .position = position };
    }

    pub const LuaStackRef = struct {
        L: *LuaState,
        position: isize,

        pub inline fn getNumber(self: *const LuaStackRef, comptime T: type) T {
            self.L.validatePosition(self.position);

            return self.L.getNumber(T, self.position);
        }

        // TODO: create unified .get() method
        pub inline fn field(self: *const LuaStackRef, key: []const u8) LuaFieldRef {
            return LuaFieldRef{ .L = self.L, .position = self.position, .key = key };
        }

        pub inline fn index(self: *const LuaStackRef, key: LuaNumber) LuaIndexRef {
            return LuaIndexRef{ .L = self.L, .position = self.position, .key = key };
        }
    };

    pub const LuaFieldRef = struct {
        L: *LuaState,
        position: isize,
        key: []const u8,

        pub inline fn getNumber(self: *const LuaFieldRef, comptime T: type) T {
            self.L.checkStack(1);
            self.L.validatePosition(self.position);

            self.L.pushString(self.key);
            self.L._gettable(@intCast(self.position));
            return self.L.popNumber(T);
        }

        pub inline fn setNumber(self: *const LuaFieldRef, comptime T: type, value: T) void {
            self.L.checkStack(2);
            self.L.validatePosition(self.position);

            self.L.pushString(self.key);
            self.L.pushNumber(T, value);
            self.L._settable(@intCast(self.position));
        }
    };

    pub const LuaIndexRef = struct {
        L: *LuaState,
        position: isize,
        key: LuaNumber,

        pub inline fn getLightUserData(self: *const LuaIndexRef) *anyopaque {
            self.L.checkStack(1);
            self.L.validatePosition(self.position);

            self.L.pushNumber(LuaNumber, self.key);
            self.L._gettable(@intCast(self.position));
            return self.L.popLightUserData();
        }
    };
};

const c = @cImport({
    @cInclude("sys/stat.h");
    @cInclude("sys/types.h");
    @cInclude("unistd.h");
});

const std = @import("std");

const lua = @import("./lua.zig");
const LuaState = lua.LuaState;
const luaL_Reg = lua.luaL_Reg;

pub export fn env_operating_system(L: *LuaState) callconv(.C) c_int {
    L.checkStack(1);
    L.pushString("linux");

    return 1;
}

pub export fn env_create_directory(L: *LuaState) callconv(.C) c_int {
    const path = L.getString(1);

    _ = c.mkdir(path.ptr, 0o755);  // TODO

    return 0;
}

pub export fn env_file_exists(L: *LuaState) callconv(.C) c_int {
    L.checkStack(1);

    const path = L.getString(1);

    const result = c.access(path.ptr, c.F_OK); // TODO
    if (result != 0) {
        L.pushBoolean(false);
    } else {
        L.pushBoolean(true);
    }

    return 1;
}

pub export fn env_join_path(L: *LuaState) callconv(.C) c_int {
    const count = L.getStackTop();
    if (count == 0) {
        L.pushString("");
        return 1;
    }

    L.checkStack(2 * count - 1);
    for (0..count) |i| {
        if (i != 0) {
            L.pushString("/");
        }
        L.copy(1 + i);
    }

    L._concat(@intCast(2 * count - 1));

    return 1;
}

pub const env = [_:luaL_Reg.SENTINEL]luaL_Reg{
    luaL_Reg{
        .name = "operating_system",
        .func = &env_operating_system,
    },
    luaL_Reg{
        .name = "create_directory",
        .func = &env_create_directory,
    },
    luaL_Reg{
        .name = "file_exists",
        .func = &env_file_exists,
    },
    luaL_Reg{
        .name = "join_path",
        .func = &env_join_path,
    },
};

pub export fn luaopen_env(L: *LuaState) c_int {
    L.checkStack(1);

    L._createtable(0, env.len);
    L._L_setfuncs(&env, 0);
    return 1;
}

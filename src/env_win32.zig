const c = @cImport({
    @cInclude("windows.h");
    @cInclude("winbase.h");
});

const std = @import("std");

const lua = @import("./lua.zig");
const LuaState = lua.LuaState;
const luaL_Reg = lua.luaL_Reg;

pub export fn env_create_directory(L: *LuaState) callconv(.C) c_int {
    const path = L.getString(1);

    _ = c.CreateDirectoryA(path.ptr, null); // TODO

    return 0;
}

pub export fn env_file_exists(L: *LuaState) callconv(.C) c_int {
    L.checkStack(1);

    const path = L.getString(1);

    const result = c.GetFileAttributesA(path.ptr); // TODO
    if (result == c.INVALID_FILE_ATTRIBUTES) {
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
            L.pushString("\\");
        }
        L.copy(1 + i);
    }

    L._concat(@intCast(2 * count - 1));

    return 1;
}

pub export fn env_processor_count(L: *LuaState) callconv(.C) c_int {
    L.pushNumber(c.DWORD, c.GetActiveProcessorCount(c.ALL_PROCESSOR_GROUPS));

    return 1;
}

pub export fn env_spawn_background_process(L: *LuaState) callconv(.C) c_int {
    var command_line = L.getString(1);
    var buffer = [_]u8{0} ** 4096;
    @memcpy(buffer[0..command_line.len], command_line);
    var startupInfo = std.mem.zeroes(c.STARTUPINFOA);
    var processInformation: c.PROCESS_INFORMATION = undefined;
    {
        const result = c.CreateProcessA(null, &buffer, null, null, 0, c.IDLE_PRIORITY_CLASS, null, null, &startupInfo, &processInformation);
        if (result == 0) {
            unreachable; // TODO
        }
    }
    {
        const result = c.CloseHandle(processInformation.hThread);
        if (result == 0) {
            unreachable; // TODO
        }
    }

    L.checkStack(1);
    L.pushLightUserData(processInformation.hProcess.?);

    return 1;
}

pub export fn env_wait_for_process(L: *LuaState) callconv(.C) c_int {
    const WAIT_OBJECT_0 = 0;
    const MAXIMUM_WAIT_OBJECTS = 0x80;
    const WAIT_TIMEOUT = 0x102;

    var buffer: [MAXIMUM_WAIT_OBJECTS]c.HANDLE = undefined;
    const process_count = L.getLength(1);
    for (0..process_count) |i| {
        buffer[i] = L.at(1).index(@floatFromInt(1 + i)).getLightUserData();
    }
    const handles = buffer[0..process_count];
    const result = c.WaitForMultipleObjects(
        @intCast(handles.len),
        handles.ptr,
        0,
        10000,
    );
    if (result == WAIT_TIMEOUT) {
        L.checkStack(1);
        L.pushNil();
        return 1;
    } else if (WAIT_OBJECT_0 <= result and result < (WAIT_OBJECT_0 + handles.len)) {
        const i = result - WAIT_OBJECT_0;
        L.checkStack(1);
        L.pushLightUserData(handles[i].?);
        return 1;
    } else {
        unreachable; // TODO
    }
}

pub export fn env_close_process_handle(L: *LuaState) callconv(.C) c_int {
    const handle = L.getLightUserData(1);

    const result = c.CloseHandle(handle);
    if (result == 0) {
        unreachable; // TODO
    }

    return 0;
}

pub export fn env_get_process_exit_code(L: *LuaState) callconv(.C) c_int {
    const handle = L.getLightUserData(1);

    var exit_code: c.DWORD = undefined;
    const result = c.GetExitCodeProcess(handle, &exit_code);
    if (result == 0) {
        unreachable; // TODO
    }

    L.checkStack(1);
    L.pushNumber(c.DWORD, exit_code);
    return 1;
}

pub const env = [_:luaL_Reg.SENTINEL]luaL_Reg{
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
    luaL_Reg{
        .name = "processor_count",
        .func = &env_processor_count,
    },
    luaL_Reg{
        .name = "spawn_background_process",
        .func = &env_spawn_background_process,
    },
    luaL_Reg{
        .name = "wait_for_process",
        .func = &env_wait_for_process,
    },
    luaL_Reg{
        .name = "get_process_exit_code",
        .func = &env_get_process_exit_code,
    },
    luaL_Reg{
        .name = "close_process_handle",
        .func = &env_close_process_handle,
    },
};

pub export fn luaopen_env(L: *LuaState) c_int {
    L.checkStack(1);

    L._createtable(0, env.len);
    L._L_setfuncs(&env, 0);
    return 1;
}

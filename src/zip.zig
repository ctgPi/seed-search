const c = @cImport({
    @cInclude("miniz.h");
});
pub const mz_file_index = extern struct {
    index: u32,
};
pub extern fn mz_zip_reader_init_file(pZip: *c.mz_zip_archive, pFilename: [*]const u8, flags: u32) c_int;
pub extern fn mz_zip_reader_end(pZip: *c.mz_zip_archive) c_int;
pub extern fn mz_zip_reader_locate_file_v2(pZip: *c.mz_zip_archive, pName: [*]const u8, pComment: ?[*]const u8, flags: u32, file_index: *mz_file_index) c_int;
pub extern fn mz_zip_reader_file_stat(pZip: *c.mz_zip_archive, file_index: mz_file_index, pStat: *c.mz_zip_archive_file_stat) c_int;
pub extern fn mz_zip_reader_extract_to_mem(pZip: *c.mz_zip_archive, file_index: mz_file_index, pBuf: ?*anyopaque, buf_size: usize, flags: u32) c_int;

const std = @import("std");
const Allocator = std.mem.Allocator;

const lua = @import("./lua.zig");
const LuaState = lua.LuaState;
const luaL_Reg = lua.luaL_Reg;

const ZipReader = struct {
    archive: c.mz_zip_archive,

    const Error = error{
        ZipReader_ArchiveNotFound,
        ZipReader_FileNotFound,
    };

    pub fn open_archive(self: *ZipReader, filename: []const u8) !void {
        self.archive = std.mem.zeroes(c.mz_zip_archive);
        const result = mz_zip_reader_init_file(&self.archive, filename.ptr, 0);
        if (result == 0) {
            return error.ZipReader_ArchiveNotFound;
        }
    }

    pub fn deinit(self: *ZipReader) !void {
        const result = mz_zip_reader_end(&self.archive);
        if (result == 0) {
            unreachable; // TODO
        }
    }

    fn locate_file(self: *ZipReader, filename: []const u8) !mz_file_index {
        var index: mz_file_index = undefined;
        const result = mz_zip_reader_locate_file_v2(&self.archive, filename.ptr, null, 0, &index);
        if (result == 0) {
            return error.ZipReader_FileNotFound;
        }
        return index;
    }

    fn stat_file(self: *ZipReader, index: mz_file_index) !c.mz_zip_archive_file_stat {
        var file_stat: c.mz_zip_archive_file_stat = undefined;
        const result = mz_zip_reader_file_stat(&self.archive, index, &file_stat);
        if (result == 0) {
            unreachable; // TODO
        }
        return file_stat;
    }

    fn extract_file_to_buffer(self: *ZipReader, index: mz_file_index, buffer: []u8) !void {
        const result = mz_zip_reader_extract_to_mem(&self.archive, index, buffer.ptr, buffer.len, 0);
        if (result == 0) {
            unreachable; // TODO
        }
    }

    pub fn extract_file(self: *ZipReader, filename: []const u8, allocator: Allocator) ![]const u8 {
        const index = try self.locate_file(filename);
        const file_stat = try self.stat_file(index);

        var buffer = try allocator.alloc(u8, file_stat.m_uncomp_size);
        errdefer allocator.free(buffer);

        try self.extract_file_to_buffer(index, buffer);
        return buffer;
    }
};

pub export fn zip_extract(L: *LuaState) callconv(.C) c_int {
    var general_purpose_allocator = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = general_purpose_allocator.allocator();

    var reader: ZipReader = undefined;

    const archive = L.getString(1);
    reader.open_archive(archive) catch |e| {
        switch (e) {
            error.ZipReader_ArchiveNotFound => {
                L.pushString("archive not found: ");
                L.pushString(archive);
                L._concat(2);
                L._error();
            },
            else => unreachable, // TODO
        }
    };
    defer reader.deinit() catch unreachable; // TODO

    const path = L.getString(2);
    const buffer = reader.extract_file(path, allocator) catch |e| {
        switch (e) {
            error.ZipReader_FileNotFound => {
                L.pushString("file not found: ");
                L.pushString(path);
                L._concat(2);
                L._error();
            },
            else => unreachable, // TODO
        }
    };
    defer allocator.free(buffer);

    L.pushString(buffer);
    return 1;
}

pub const zip: [1:luaL_Reg.SENTINEL]luaL_Reg = [_:luaL_Reg.SENTINEL]luaL_Reg{
    luaL_Reg{
        .name = "extract",
        .func = &zip_extract,
    },
};

pub export fn luaopen_zip(L: *LuaState) c_int {
    L.checkStack(1);

    L._createtable(0, zip.len);
    L._L_setfuncs(&zip, 0);
    return 1;
}

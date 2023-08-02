#!/usr/bin/env lua5.4

if arg[1] ~= nil and arg[2] ~= nil then
    local struct = require('struct')
    local se_env = require('se_env')
    local bin_unpack = require('bin_unpack')
    local json = require('json')
    local unpack_filename = arg[2]
    unpack_file = io.open(unpack_filename, 'w+b')
    assert(unpack_file)
    for summary in bin_unpack.unpack_seeds(arg[1]) do
        unpack_file:write(json.encode(summary) .. "\n")
    end
    unpack_file:close()
else
    print("usage: lua unpack.lua filename unpack_filename")
end


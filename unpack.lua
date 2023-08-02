#!/usr/bin/env lua5.2

local struct = require('struct')

local se_env = require('se_env')
local bin_unpack = require('bin_unpack')
local json = require('json')

local input_file = io.open(arg[1], "r+b")
assert(input_file)
for summary in bin_unpack.unpack_seeds(input_file) do
    print(json.encode(summary))
end
input_file:close()

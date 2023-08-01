#!/usr/bin/env lua5.2

local struct = require('struct')

local se_env = require('se_env')
local bin_unpack = require('bin_unpack')
local json = require('json')

for summary in bin_unpack.unpack_seeds(io.stdin) do
    print(json.encode(summary))
end

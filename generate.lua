#!/usr/bin/env lua5.2

local env = require('env')
local struct = require('struct')

local se_data = require('se_data')
local summarize = require('summarize')
local bin_pack = require('bin_pack')
local bin_unpack = require('bin_unpack')

local chunk = tonumber(arg[1])
local chunk_size = math.pow(2, 16)

local start_seed = math.max(340, chunk * chunk_size)
local end_seed = (chunk + 1) * chunk_size - 2

report_file_name = env.join_path('output', string.format('universe-%04x.bin', chunk))

if env.file_exists(report_file_name) then
    return
end

report_file = io.open(report_file_name .. '.tmp', 'w+b')
assert(report_file)

for seed = start_seed, end_seed, 2 do
    local summary = summarize.summarize_seed(seed)
    report_file:write(bin_pack.pack_seed_summary(summary))
end
report_file:close()
os.rename(report_file_name .. '.tmp', report_file_name)

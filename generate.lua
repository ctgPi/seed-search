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

env.create_directory('output')
local report_file_name = env.join_path('output', string.format('universe-%04x.bin', chunk))
local temp_file_name = report_file_name .. '.tmp'

if env.file_exists(report_file_name) then
    return
end

-- TODO: needs more thought; maybe a per-seed checksum?
---- Try to recover a partial seed file.
--local next_seed
--local next_offset
--do
--    temp_file = io.open(temp_file_name, 'rb')
--    if temp_file == nil then
--        next_offset = 0
--        next_seed = start_seed
--    else
--        local seed_locations = {{seed = start_seed, offset = 0}, {seed = start_seed, offset = 0}}
--        local seed_offset_start = 0
--        pcall(function()
--            for summary in bin_unpack.unpack_seeds(temp_file) do
--                local seed_offset_end = temp_file:seek('cur', 0)
--                table.insert(seed_locations, {seed = summary.seed, offset = seed_offset_start})
--                print(summary.seed, seed_offset_start, seed_offset_end, seed_offset_end - seed_offset_start)
--                table.remove(seed_locations, 1)  -- only keep last two seeds
--                seed_offset_start = seed_offset_end
--            end
--        end)
--        local last_location = seed_locations[1]  -- last few seeds might be corrupted
--        next_seed = last_location.seed
--        next_offset = last_location.offset
--        temp_file:close()
--    end
--end
--
--local report_file
--if next_offset > 0 then
--    report_file = io.open(temp_file_name, 'r+b')
--    report_file:seek('cur', next_offset)
--    report_file:truncate(next_offset)
--else
--    report_file = io.open(temp_file_name, 'w+b')
--end

report_file = io.open(temp_file_name, 'w+b')
assert(report_file)

for seed = start_seed, end_seed, 2 do
    local summary = summarize.summarize_seed(seed)
    report_file:write(bin_pack.pack_seed_summary(summary))
end
report_file:close()
os.rename(report_file_name .. '.tmp', report_file_name)

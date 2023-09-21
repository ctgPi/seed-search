local env = require('env')

env.create_directory('output')

local WORKER_COUNT
if os.getenv('WORKER_COUNT') ~= nil then
    WORKER_COUNT = math.floor(tonumber(os.getenv('WORKER_COUNT')))
else
    WORKER_COUNT = math.max(1, math.min(128, env.processor_count()))
end
io.stderr:write('\x1B[93m\x1B[2K')
io.stderr:write("Spawning " .. tonumber(WORKER_COUNT) .. " workers")
io.stderr:write('\x1B[0m')
io.stderr:write('\n')

local INTERPRETER
if env.operating_system() == 'win32' then
    INTERPRETER = env.join_path('bin', 'lua.exe')
else
    INTERPRETER = env.join_path('bin', 'lua')
end

local queue = {}
for chunk = 0, 65535 do
    -- TODO: renice as part of the BG spawn
    table.insert(queue, 'nice -n20 ' .. INTERPRETER .. ' generate.lua ' .. string.format('%5d', chunk))
end

local timing = {}
local active = {}
local handle = {}
while #queue > 0 or #active > 0 do
    while #queue > 0 and #active < WORKER_COUNT do
        local job = table.remove(queue, 1)
        io.stderr:write('\x1B[90m\x1B[2K')
        io.stderr:write("    " .. job .. ": starting")
        io.stderr:write('\x1B[0m')
        io.stderr:write('\n')
        table.insert(active, job)
        table.insert(handle, env.spawn_background_process(job))
        table.insert(timing, env.monotonic_clock())
    end
    local signaled_handle, success = env.wait_for_background_process(handle)
    if signaled_handle ~= nil then
        local index
        for i, _ in ipairs(handle) do
            if handle[i] == signaled_handle then
                index = i
                break
            end
        end
        job = active[index]
        elapsed = env.monotonic_clock() - timing[index]
        table.remove(active, index)
        table.remove(handle, index)
        table.remove(timing, index)

        if success then
            io.stderr:write("    " .. job .. ": done (" .. string.format("%.3f s", elapsed) .. ")")
        else
            io.stderr:write('\x1B[97;41m\x1B[2K')
            io.stderr:write("!!! " .. job .. ": failed")
            io.stderr:write('\x1B[0m')
        end
        io.stderr:write('\n')
    end
end

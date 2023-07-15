local env = require('env');

env.create_directory('output');
local worker_count = math.max(1, math.min(128, env.processor_count() - 1))

local queue = {}
for chunk = 0, 65535 do
    table.insert(queue, "bin\\lua.exe worker.lua " .. tostring(chunk))
end

local active = {}
local handle = {}
while #queue > 0 or #active > 0 do
    while #queue > 0 and #active < worker_count do
        local job = table.remove(queue, 1)
        print(job .. ': starting')
        table.insert(active, job)
        table.insert(handle, env.spawn_background_process(job))
    end
    local signaled_handle = env.wait_for_process(handle);
    if signaled_handle ~= nil then
        local index
        for i, _ in ipairs(processes) do
            if processes[i] == signaled_handle then
                index = i
                break
            end
        end
        print(active[index] .. ': done (' .. tostring(env.get_process_exit_code(signaled_handle)) .. ')')
        table.remove(active, index)
        table.remove(handle, index)
        env.close_process_handle(signaled_handle)
    end
end

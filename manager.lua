local env = require('env')
local curl = require('curl')
local json = require('json')

env.create_directory('output')

local function load_config()
    local config_file = io.open('_config.json', 'r')
    if config_file == nil then
        return {}
    end
    config_data = config_file:read('*a')
    config_file:close()

    return json.decode(config_data)
end

local config = load_config()
if config.host == nil or config.secret == nil then
    print("Missing credentials!")  -- TODO
    os.exit(1)
end

if config.version == nil then
    print("Missing version!")  -- TODO
    os.exit(1)
end

local WORKER_COUNT
if os.getenv('WORKER_COUNT') ~= nil then
    WORKER_COUNT = math.floor(tonumber(os.getenv('WORKER_COUNT')))
elseif config.worker_count ~= nil then
    WORKER_COUNT = config.worker_count
else
    WORKER_COUNT = math.max(1, math.min(128, env.processor_count()))
end

local function log(color, message)
    io.stderr:write('\x1B[' .. color .. 'm\x1B[2K')
    io.stderr:write(os.date('%Y-%m-%dT%H:%M:%S%z') .. ' ')
    io.stderr:write(message)
    io.stderr:write('\x1B[0m')
    io.stderr:write('\n')
end

log('93', "Spawning " .. tonumber(WORKER_COUNT) .. " workers")

local INTERPRETER
if env.operating_system() == 'win32' then
    INTERPRETER = env.join_path('bin', 'lua.exe')
else
    INTERPRETER = env.join_path('bin', 'lua')
end

local function load_queue()
    local queue_file = io.open('_queue.json', 'r')
    if queue_file == nil then
        return {}
    end
    queue_data = queue_file:read('*a')
    queue_file:close()

    return json.decode(queue_data)
end

local function save_queue(queue)
    local queue_file = io.open('_queue.json.tmp', 'w')
    if queue_file == nil then
        return false
    end
    if queue_file:write(json.encode(queue)) == nil then
        return false
    end
    queue_file:close()
    os.rename('_queue.json.tmp', '_queue.json')

    return true
end

local API_ROOT = 'https://factorio.561.jp/'

local queue = load_queue()
local timing = {}
local handle = {}

local function assign_tasks()
    while #queue < 3 * WORKER_COUNT do
        -- TODO: URL-encoding
        local post_data = ('host_name' .. '=' .. config.host) .. '&' ..
                          ('host_secret' .. '=' .. config.secret) .. '&' ..
                          ('version_name' .. '=' .. config.version)
        local response_raw = curl.post(API_ROOT .. 'task/', post_data)
        if response_raw == nil then
            break
        end
        local response_success, response = pcall(json.decode, response_raw)
        if not response_success then
            break
        end
        table.insert(queue, response)
        if not save_queue(queue) then
            break
        end
        log('94', "Got chunk " .. string.format('%04x', response.task_chunk) .. " from the server")
    end
end

local function return_tasks()
    local done = false
    while not done do
        done = true
        for i, task in ipairs(queue) do
            local task_chunk = task.task_chunk
            report_file_name = 'output/universe-' .. string.format('%04x', task_chunk) .. '.bin'
            if handle[task_chunk] == nil and env.file_exists(report_file_name) then
                local post_data
                do
                    local report_file = io.open(report_file_name, 'rb')
                    assert(report_file)
                    post_data = report_file:read('*a')
                    report_file:close()
                end
                local response_raw = curl.post(API_ROOT .. 'task/' .. task.task_token .. '/', post_data)
                if response_raw == nil then
                    break
                end
                local response_success, response = pcall(json.decode, response_raw)
                if not response_success or response.task_state ~= 'closed' then
                    break
                end
                log('94', "Sent chunk " .. string.format('%04x', task_chunk) .. " to server")
                table.remove(queue, i)
                os.remove(report_file_name)
                done = false
                break
            end
        end
    end
end

local function spawn_workers()
    local done = false
    while not done do
        done = true
        local active_workers = 0
        for k, _ in pairs(handle) do
            active_workers = active_workers + 1
        end
        if active_workers >= WORKER_COUNT then
            break
        end
        for _, task in ipairs(queue) do
            local task_chunk = task.task_chunk
            if handle[task_chunk] == nil and not env.file_exists('output/universe-' .. string.format('%04x', task_chunk) .. '.bin') then
                timing[task_chunk] = env.monotonic_clock()
                -- TODO: renice as part of the BG spawn
                local task_command = 'nice -n20 ' .. INTERPRETER .. ' generate.lua ' .. tostring(task_chunk)
                handle[task_chunk] = env.spawn_background_process(task_command)
                log('37', "Starting chunk " .. string.format('%04x', task_chunk))
                done = false
                break
            end
        end
    end
end

while true do
    return_tasks()
    assign_tasks()
    spawn_workers()

    local signaled_handle, success = env.wait_for_background_process()
    if signaled_handle ~= nil then
        local task_chunk
        for k, _ in pairs(handle) do
            if handle[k] == signaled_handle then
                task_chunk = k
                break
            end
        end
        if task_chunk ~= nil then
            local elapsed_seconds = env.monotonic_clock() - timing[task_chunk]
            handle[task_chunk] = nil
            timing[task_chunk] = nil

            if success then
                local elapsed_minutes = math.floor(elapsed_seconds / 60)
                elapsed_seconds = elapsed_seconds - 60 * elapsed_minutes
                local elapsed_hours = math.floor(elapsed_minutes / 60)
                elapsed_minutes = elapsed_minutes - 60 * elapsed_hours
                log('92', "Chunk " .. string.format('%04x', task_chunk) .. " done (" .. string.format("%dh%02dm", elapsed_hours, elapsed_minutes) .. ")")
            else
                log('97', "Chunk " .. string.format('%04x', task_chunk) .. " failed")
            end
        else
            log('97', "Got phantom signal?? " .. tostring(signaled_handle))
        end
    end
end

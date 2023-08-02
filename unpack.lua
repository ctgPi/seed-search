#!/usr/bin/env lua5.4

function scandir(directory)
    local i, t, popen = 0, {}, io.popen
    local pfile = popen('ls -a "' .. directory .. '"')
    for filename in pfile:lines() do
        i = i + 1
        t[i] = filename
    end
    pfile:close()
    return t
end

local struct = require('struct')
local se_env = require('se_env')
local bin_unpack = require('bin_unpack')
local json = require('json')

for k, v in pairs(scandir(arg[1])) do
    if string.find(v, ".bin") then
        print("scanning: " .. arg[1] .. "/" .. v)
        for summary in bin_unpack.unpack_seeds(arg[1] .. "/" .. v) do
            local countProd = 0
            for k, v in pairs(summary.loot) do
                if v == "P" then
                    countProd = countProd + 1
                end
            end
            if countProd >= 4 then
                print(json.encode(summary))
            end
        end
    end
end

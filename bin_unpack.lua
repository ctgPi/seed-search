local bin_unpack = {}

local bit32 = require("bit32")
local bit32_extra = require('bit32_extra')
local struct = require('struct')
local se_data = require('se_data')

local json = require('json')

local function unpack_secondary_score(v)
    local x = (v + 0.5) / 256
    return math.pow(x, 3) / 7
end

local function unpack_trits(r)
    assert(1 <= r and r <= 243)

    local t1 = 1 + math.floor((r - 1)) % 3
    local t2 = 1 + math.floor((r - 1) / 3) % 3
    local t3 = 1 + math.floor((r - 1) / 9) % 3
    local t4 = 1 + math.floor((r - 1) / 27) % 3
    local t5 = 1 + math.floor((r - 1) / 81) % 3

    assert(1 <= t1 and t1 <= 3)
    assert(1 <= t2 and t2 <= 3)
    assert(1 <= t3 and t3 <= 3)
    assert(1 <= t4 and t4 <= 3)
    assert(1 <= t5 and t5 <= 3)
    return t1, t2, t3, t4, t5
end

local function unpack_quints(r)
    assert(1 <= r and r <= 125)

    local q1 = 1 + math.floor((r - 1)) % 5
    local q2 = 1 + math.floor((r - 1) / 5) % 5
    local q3 = 1 + math.floor((r - 1) / 25) % 5

    assert(1 <= q1 and q1 <= 5)
    assert(1 <= q2 and q2 <= 5)
    assert(1 <= q3 and q3 <= 5)
    return q1, q2, q3
end

local function unpack_zone_summary(reader)
    local zone_summary = {}
    local w0 = struct.unpack("<I", reader:read(4))

    local t_zone_type = bit32.band(bit32.rshift(w0, 0), 0x00000003)
    zone_summary.zone_type = se_data.T_ZONE_TYPE[t_zone_type]
    local t_name = bit32.band(bit32.rshift(w0, 2), 0x000003ff)
    zone_summary.name = se_data.NAME[t_name]
    local primary_resource_index = bit32.band(bit32.rshift(w0, 12), 0x0000000f)
    local resource_mask
    if t_zone_type == 3 then
        local t_cannonable = bit32.band(bit32.rshift(w0, 16), 0x00000001)
        if t_cannonable == 1 then
            zone_summary.cannonable = true
        else
            zone_summary.cannonable = false
        end
        local packed_delta_v = bit32.band(bit32.rshift(w0, 17), 0x00007fff)
        zone_summary.delta_v = packed_delta_v * 8

        resource_mask = 0x702e
    elseif t_zone_type == 1 or t_zone_type == 2 then
        resource_mask = 0x003f
        local t_resource_mask = bit32.band(bit32.rshift(w0, 16), 0x00000003)
        resource_mask = bit32.bor(resource_mask, bit32_extra.pdep(t_resource_mask, 0x00c0))

        local t_q1 = bit32.band(bit32.rshift(w0, 18), 0x0000007f)
        local t_t2_resource, t_water, t_moisture = unpack_quints(t_q1)

        local t_q2 = bit32.band(bit32.rshift(w0, 25), 0x0000007f)
        local t_trees, t_aux, t_cliff = unpack_quints(t_q2)

        resource_mask = bit32.bor(resource_mask, se_data.T_T2_RESOURCE[t_t2_resource])

        local w1 = struct.unpack("<I", reader:read(4))
        local t_temperature = bit32.band(bit32.rshift(w1, 0), 0x0000000f)
        local t_enemy = bit32.band(bit32.rshift(w1, 4), 0x00000007)
        local packed_delta_v = bit32.band(bit32.rshift(w1, 7), 0x000007ff)
        zone_summary.delta_v = 8 * packed_delta_v
        zone_summary.radius = bit32.band(bit32.rshift(w1, 18), 0x00003fff)

        zone_summary.tags = {}
        zone_summary.tags.temperature = se_data.T_TEMPERATURE[t_temperature]
        zone_summary.tags.water = se_data.T_WATER[t_water]
        zone_summary.tags.moisture = se_data.T_MOISTURE[t_moisture]
        zone_summary.tags.trees = se_data.T_TREES[t_trees]
        zone_summary.tags.aux = se_data.T_AUX[t_aux]
        zone_summary.tags.cliff = se_data.T_CLIFF[t_cliff]
        zone_summary.tags.enemy = se_data.T_ENEMY[t_enemy]
    else
        assert(false)
    end
    zone_summary.resource = {}
    zone_summary.resource[se_data.RESOURCE[primary_resource_index]] = 1
    for i, name in ipairs(se_data.RESOURCE) do
        if i ~= primary_resource_index then
            if bit32.band(resource_mask, bit32.lshift(1, i - 1)) ~= 0 then
                local s = struct.unpack("<B", reader:read(1))
                zone_summary.resource[se_data.RESOURCE[i]] = unpack_secondary_score(s)
            end
        end
    end

    return zone_summary
end

function bin_unpack.unpack_seeds(filename)
    print("Unpacking " .. filename)
    local input_file = io.open(filename, "r")
    local reader = {
        file = input_file,
        buffer = {},
        read = function(self, n)
            local r = {}
            while #self.buffer > 0 and n > 0 do
                table.insert(r, table.remove(self.buffer))
                n = n - 1
            end
            if n > 0 then
                local s = self.file:read(n)
                if s ~= nil then
                    table.insert(r, s)
                else
                    if #r == 0 then
                        return nil
                    end
                end
            end
            return table.concat(r)
        end,
        unread = function(self, s)
            for i = 1, string.len(s) do
                table.insert(self.buffer, string.sub(s, i, i))
            end
        end
    }

    local function iterator(reader, previous_seed_summary)
        local seed_summary = nil
        while true do
            local header = reader:read(1)
            if header == nil then
                if seed_summary ~= nil then
                    while #seed_summary.loot > #seed_summary.planets do
                        table.remove(seed_summary.loot)
                    end
                    return seed_summary
                else
                    return nil
                end
            end
            local w0 = struct.unpack("<B", header)
            local zone_summary
            if bit32.band(bit32.rshift(w0, 0), 0x03) == 0 then
                if seed_summary ~= nil then
                    reader:unread(header)
                    while #seed_summary.loot > #seed_summary.planets do
                        table.remove(seed_summary.loot)
                    end
                    return seed_summary
                else
                    local seed
                    if bit32.band(bit32.rshift(w0, 2), 0x03) == 1 then
                        seed = struct.unpack("<I", reader:read(4))
                    else
                        seed = previous_seed_summary.seed + 2
                    end
                    seed_summary = {
                        seed = seed,
                        loot = {},
                        planets = {},
                        moons = {},
                        fields = {}
                    }
                    local c = bit32.band(bit32.rshift(w0, 4), 0x0f)
                    for j = 1, c do
                        local w1 = struct.unpack("<B", reader:read(1))
                        local l = table.pack(unpack_trits(w1))
                        for i = 1, 5 do
                            if l[i] == 1 then
                                table.insert(seed_summary.loot, "P")
                            elseif l[i] == 2 then
                                table.insert(seed_summary.loot, "S")
                            elseif l[i] == 3 then
                                table.insert(seed_summary.loot, "E")
                            else
                                assert(false)
                            end
                        end
                    end
                end
            elseif bit32.band(w0, 0x03) == 3 then
                -- asteroid field
                reader:unread(header)
                zone_summary = unpack_zone_summary(reader)
            else
                -- planet/moon
                reader:unread(header)
                zone_summary = unpack_zone_summary(reader)
            end
            if zone_summary ~= nil then
                if zone_summary.zone_type == "planet" then
                    table.insert(seed_summary.planets, zone_summary)
                elseif zone_summary.zone_type == "moon" then
                    table.insert(seed_summary.moons, zone_summary)
                elseif zone_summary.zone_type == "asteroid-field" then
                    table.insert(seed_summary.fields, zone_summary)
                else
                    assert(false)
                end
            end
        end
    end

    return iterator, reader, nil
end

return bin_unpack

local bin_pack = {}

local bit32_extra = require('bit32_extra')
local struct = require('struct')
local se_data = require('se_data')

local function pack_secondary_score(score)
    local x = math.pow(7 * score, 1/3)
    return math.min(255, math.max(0, math.floor(256 * x)))
end

local function pack_trits(t1, t2, t3, t4, t5)
    assert(1 <= t1 and t1 <= 5)
    assert(1 <= t2 and t2 <= 5)
    assert(1 <= t3 and t3 <= 5)
    assert(1 <= t4 and t4 <= 5)
    assert(1 <= t5 and t5 <= 5)

    local r = 1 + (t1-1) + 3 * (t2-1) + 9 * (t3-1) + 27 * (t4-1) + 81 * (t5-1)

    assert(1 <= r and r <= 243)
    return r
end

local function pack_quints(q1, q2, q3)
    assert(1 <= q1 and q1 <= 5)
    assert(1 <= q2 and q2 <= 5)
    assert(1 <= q3 and q3 <= 5)

    local r = 1 + (q1-1) + 5 * (q2-1) + 25 * (q3-1) 

    assert(1 <= r and r <= 125)
    return r
end

local function pack_zone_summary(summary)
    local t_zone_type = se_data.T_ZONE_TYPE_index[summary.zone_type]
    assert(t_zone_type ~= nil)

    local primary_resource_index = 0
    local resource_mask = 0
    local secondary_resource_packed_scores = {}
    for i, name in ipairs(se_data.RESOURCE) do
        local score = summary.resource[se_data.RESOURCE[i]]
        -- XXX: apparently it is possible, but rare, for asteroid fields to not spawn all resources? Add a dummy score just to keep binary compatibility.
        if summary.zone_type == "asteroid-field" and bit32.band(0x702e, bit32.lshift(1, i-1)) ~= 0 then
            score = 1e-10
        end
        -- XXX: apparently it is possible, but rare, for planets/moons to not spawn all resources? Add a dummy score just to keep binary compatibility.
        if summary.zone_type ~= "asteroid-field" and bit32.band(0x003f, bit32.lshift(1, i-1)) ~= 0 then
            score = 1e-10
        end
        if score ~= nil then
            if score == 1 then
                resource_mask = bit32.bor(resource_mask, bit32.lshift(1, i-1))
                primary_resource_index = i
            elseif score > 0 then
                resource_mask = bit32.bor(resource_mask, bit32.lshift(1, i-1))
                table.insert(secondary_resource_packed_scores, pack_secondary_score(score))
            end
        end
    end

    if summary.zone_type == "asteroid-field" then
        assert(bit32.band(resource_mask, 0x0bd1) == 0x0000)
        assert(bit32.band(resource_mask, 0x702e) == 0x702e)

        local t_cannonable
        if summary.cannonable then
            t_cannonable = 1
        else
            t_cannonable = 0
        end

        local packed_delta_v = math.floor(summary.delta_v / 8 + 0.5)

        local w0 = 0
        w0 = bit32.bor(w0, bit32.lshift(t_zone_type, 0))  -- 0~1
        w0 = bit32.bor(w0, bit32.lshift(se_data.NAME_index[summary.name], 2))  -- 2~11
        w0 = bit32.bor(w0, bit32.lshift(primary_resource_index, 12))  -- 12~15
        w0 = bit32.bor(w0, bit32.lshift(t_cannonable, 16))  -- 16~16
        w0 = bit32.bor(w0, bit32.lshift(packed_delta_v, 17))  -- 17~31

        local r = {}
        table.insert(r, struct.pack("<I", w0))
        for _, x in ipairs(secondary_resource_packed_scores) do
            table.insert(r, struct.pack("<B", x))
        end

        return table.concat(r)
    else
        assert(bit32.band(resource_mask, 0xf000) == 0x0000)
        assert(bit32.band(resource_mask, 0x003f) == 0x003f)

        local t_t2_resource = se_data.T_T2_RESOURCE_index[bit32.band(resource_mask, 0x0f00)]
        local t_water       = se_data.T_WATER_index      [summary.tags.water   ]
        local t_moisture    = se_data.T_MOISTURE_index   [summary.tags.moisture]

        local t_trees = se_data.T_TREES_index[summary.tags.trees]
        local t_aux   = se_data.T_AUX_index  [summary.tags.aux  ]
        local t_cliff = se_data.T_CLIFF_index[summary.tags.cliff]

        local t_temperature = se_data.T_TEMPERATURE_index[summary.tags.temperature]
        local t_enemy       = se_data.T_ENEMY_index[summary.tags.enemy]

        assert(t_t2_resource ~= nil)
        assert(t_water       ~= nil)
        assert(t_moisture    ~= nil)
        assert(t_trees       ~= nil)
        assert(t_aux         ~= nil)
        assert(t_cliff       ~= nil)

        local packed_delta_v = math.floor(summary.delta_v / 8 + 0.5)
     
        local w0 = 0
        w0 = bit32.bor(w0, bit32.lshift(t_zone_type, 0))  -- 0~1
        w0 = bit32.bor(w0, bit32.lshift(se_data.NAME_index[summary.name], 2))  -- 2~11
        w0 = bit32.bor(w0, bit32.lshift(primary_resource_index, 12))  -- 12~15
        w0 = bit32.bor(w0, bit32.lshift(bit32.pext(resource_mask, 0x00c0), 16))  -- 16~17
        w0 = bit32.bor(w0, bit32.lshift(pack_quints(t_t2_resource, t_water, t_moisture), 18))  -- 18~24
        w0 = bit32.bor(w0, bit32.lshift(pack_quints(t_trees, t_aux, t_cliff), 25))  -- 25~31

        local w1 = 0
        w1 = bit32.bor(w1, bit32.lshift(t_temperature, 0))  -- 0~3
        w1 = bit32.bor(w1, bit32.lshift(t_enemy, 4))  -- 4~6
        w1 = bit32.bor(w1, bit32.lshift(packed_delta_v, 7))  -- 7~17
        w1 = bit32.bor(w1, bit32.lshift(summary.radius, 18))  -- 18~31

        local r = {}
        table.insert(r, struct.pack("<II", w0, w1))
        for _, x in ipairs(secondary_resource_packed_scores) do
            table.insert(r, struct.pack("<B", x))
        end

        return table.concat(r)
    end
end

local last_seed = nil  -- TODO: probably not good to keep this in global state...
function bin_pack.pack_seed_summary(summary)
    local r = {}

    local c = math.ceil(math.min(60, #summary.planets) / 5)
    local t_seed
    if last_seed == nil or last_seed + 2 ~= summary.seed then
        t_seed = 1
    else
        t_seed = 2
    end
    last_seed = summary.seed

    local w0 = 0
    w0 = bit32.bor(w0, bit32.lshift(0, 0))  -- 0~1
    w0 = bit32.bor(w0, bit32.lshift(t_seed, 2))  -- 2~3
    w0 = bit32.bor(w0, bit32.lshift(c, 4))  -- 4~7
    table.insert(r, struct.pack("<B", w0))
    if t_seed == 1 then
        table.insert(r, struct.pack("<I", summary.seed))
    end
    for j = 1, c do
        local l = {}
        for i = 1, 5 do
            local p = i + (j-1) * 5
            local loot = summary.loot[p]
            local t_loot
            if loot == "P" then
                t_loot = 1
            elseif loot == "S" then
                t_loot = 2
            elseif loot == "E" then
                t_loot = 3
            elseif loot == nil then
                -- undefined value
                t_loot = math.floor(1 + 3 * math.random())
            else
                assert(false)
            end
            table.insert(l, t_loot)
        end
        table.insert(r, struct.pack("<B", pack_trits(l[1], l[2], l[3], l[4], l[5])))
    end

    for _, planet in ipairs(summary.planets) do
        table.insert(r, pack_zone_summary(planet))
    end
    for _, moon in ipairs(summary.moons) do
        table.insert(r, pack_zone_summary(moon))
    end
    for _, field in ipairs(summary.fields) do
        table.insert(r, pack_zone_summary(field))
    end
    return table.concat(r)
end

return bin_pack

local summarize = {}

local se_data = require('se_data')

local function summarize_zone(zone)
    local nauvis = global.zones_by_name['Nauvis']
    local stars = {}
    for _, zone in pairs(global.zones_by_name) do
        if zone.type == "star" then
            table.insert(stars, zone)
        end
    end

    local summary = {}
    summary.name = zone.name
    summary.zone_type = zone.type

    local v = math.ceil(Zone.get_travel_delta_v(nauvis, zone))
    summary.delta_v = v
    if zone.type ~= "asteroid-field" then
        local r = math.floor(zone.radius + 0.5)
        summary.radius = r
    end
    if zone.type == "asteroid-field" then
        if v <= 20000 then
            local closest_star = { delta_v = 1/0, name = nil }
            for _, star in pairs(stars) do
                local delta_v = Zone.get_travel_delta_v(star, zone)
                if delta_v < closest_star.delta_v then
                    closest_star.delta_v = delta_v
                    closest_star.name = star.name
                end
            end
            if closest_star.name == "Calidus" then
                summary.cannonable = true
            else
                summary.cannonable = false
            end
        else
            summary.cannonable = false
        end
    end

    local s = {}
    for i, name in ipairs(se_data.RESOURCE) do
        local control = zone.controls[name]
        if control ~= nil then
            local score = control.frequency * control.richness * control.size
            if zone.type == "asteroid-field" then
                score = score / 167.79554553234018499
            else
                score = score / 22.02730826300005162466
            end
            s[i] = score
        else
            s[i] = 0
        end
    end

    summary.resource = {}
    for i, name in ipairs(se_data.RESOURCE) do
        if s[i] ~= 0 then
            summary.resource[se_data.RESOURCE[i]] = s[i]
        end
    end

    if zone.type ~= "asteroid-field" then
        summary.tags = {}
        summary.tags.temperature = zone.tags.temperature
        summary.tags.water = zone.tags.water
        summary.tags.moisture = zone.tags.moisture
        summary.tags.trees = zone.tags.trees
        summary.tags.aux = zone.tags.aux
        summary.tags.cliff = zone.tags.cliff
        summary.tags.enemy = zone.tags.enemy
    end

    return summary
end

function summarize.summarize_seed(seed)
    FactorioRNG.global_seed = seed
    global = {}
    global.meteor_zones = {}
    global.forces = {}
    global.forces.player = {}
    Universe.build()

    local planets = {}
    local moons = {}
    for _, planet in pairs(global.zones_by_name['Calidus'].children) do
        if planet.type == "planet" then
            if not planet.is_homeworld then
                local summary = summarize_zone(planet)
                table.insert(planets, summary)
            end
            for _, moon in pairs(planet.children) do
                local summary = summarize_zone(moon)
                table.insert(moons, summary)
            end
        end
    end

    local fields = {}
    for _, zone in pairs(global.zones_by_name) do
        if zone.type == "asteroid-field" then
            local summary = summarize_zone(zone)
            table.insert(fields, summary)
        end
    end

    local loot = {}
    for i = 1, #planets do
        local module = Ancient.get_next_vault_loot({ name = "player" })
        if module == "productivity-module-9" then
            table.insert(loot, "P")
        elseif module == "speed-module-9" then
            table.insert(loot, "S")
        elseif module == "effectivity-module-9" then
            table.insert(loot, "E")
        else
            assert(false)
        end
    end

    table.sort(planets, function (this, that) return this.delta_v < that.delta_v end)
    table.sort(moons, function (this, that) return this.delta_v < that.delta_v end)
    table.sort(fields, function (this, that) return this.delta_v < that.delta_v end)

    return {
        seed = seed,
        loot = loot,
        planets = planets,
        moons = moons,
        fields = fields,
    }
end

return summarize

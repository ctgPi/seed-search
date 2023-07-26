#!/usr/bin/env lua5.2

local zip = require('zip')
local env = require('env')
local json = require('json')
local struct = require('struct')

serpent = {}
serpent.block = function () return "" end
serpent = dofile('./serpent.lua')

util = dofile('./factorio-util.lua')
core_util = dofile('./factorio-util.lua')

function table_size(t)
    local count = 0
    for k,v in pairs(t) do
        count = count + 1
    end
    return count
end

log = function () end
Log = { debug_log = function () end, trace = function () end }

FactorioRNG = { global_seed = nil }
function FactorioRNG:new(o)
    o = o or {}   -- create object if user does not provide one
    setmetatable(o, self)
    self.__index = self
    return o
end

local rng = require('rng')
FactorioRNG.__call = rng.call

mod_prefix = "se-"
game = {}
game.autoplace_control_prototypes = {
  coal = {
    category = "resource",
    name = "coal"
  },
  cold = {
    category = "terrain",
    name = "cold"
  },
  ["copper-ore"] = {
    category = "resource",
    name = "copper-ore"
  },
  ["crude-oil"] = {
    category = "resource",
    name = "crude-oil"
  },
  ["enemy-base"] = {
    category = "enemy",
    name = "enemy-base"
  },
  hot = {
    category = "terrain",
    name = "hot"
  },
  ["iron-ore"] = {
    category = "resource",
    name = "iron-ore"
  },
  ["planet-size"] = {
    category = "terrain",
    name = "planet-size"
  },
  ["se-beryllium-ore"] = {
    category = "resource",
    name = "se-beryllium-ore"
  },
  ["se-cryonite"] = {
    category = "resource",
    name = "se-cryonite"
  },
  ["se-holmium-ore"] = {
    category = "resource",
    name = "se-holmium-ore"
  },
  ["se-iridium-ore"] = {
    category = "resource",
    name = "se-iridium-ore"
  },
  ["se-methane-ice"] = {
    category = "resource",
    name = "se-methane-ice"
  },
  ["se-naquium-ore"] = {
    category = "resource",
    name = "se-naquium-ore"
  },
  ["se-vitamelange"] = {
    category = "resource",
    name = "se-vitamelange"
  },
  ["se-vulcanite"] = {
    category = "resource",
    name = "se-vulcanite"
  },
  ["se-water-ice"] = {
    category = "resource",
    name = "se-water-ice"
  },
  stone = {
    category = "resource",
    name = "stone"
  },
  trees = {
    category = "terrain",
    name = "trees"
  },
  ["uranium-ore"] = {
    category = "resource",
    name = "uranium-ore"
  }
}
game.create_random_generator = function (seed)
    if seed == nil then
        seed = FactorioRNG.global_seed
    end
    if seed < 341 then
        seed = 341
    end
    return FactorioRNG:new{ x = seed, y = seed, z = seed }
end
Event = {}
Event.addListener = function () end
Event.trigger = function () end
defines = {}
defines.events = {}
defines.direction = {}
game.get_surface = function (surface)
    if surface == 1 then
        return {
            map_gen_settings = {
                autoplace_controls = {
                    ["planet-size"] = {
                        frequency = 6,
                    }
                },
                width = 2000000,
                height = 2000000,
            },
            find_entities_filtered = function () return {} end,
            regenerate_entity = function () return {} end,
        }
    else
        error('!!!')  -- FIXME
    end
end
is_testing_game = function () return false end
Meteor = {}
Meteor.schedule_meteor_shower = function () end
game.tick = 0
game.item_prototypes = {
  ["se-core-fragment-coal"] = {
    localised_name = {
      "item-name.core-fragment",
      {
        "entity-name.coal"
      }
    }
  },
  ["se-core-fragment-copper-ore"] = {
    localised_name = {
      "item-name.core-fragment",
      {
        "entity-name.copper-ore"
      }
    }
  },
  ["se-core-fragment-crude-oil"] = {
    localised_name = {
      "item-name.core-fragment",
      {
        "entity-name.crude-oil"
      }
    }
  },
  ["se-core-fragment-iron-ore"] = {
    localised_name = {
      "item-name.core-fragment",
      {
        "entity-name.iron-ore"
      }
    }
  },
  ["se-core-fragment-se-beryllium-ore"] = {
    localised_name = {
      "item-name.core-fragment",
      {
        "entity-name.se-beryllium-ore"
      }
    }
  },
  ["se-core-fragment-se-cryonite"] = {
    localised_name = {
      "item-name.core-fragment",
      {
        "entity-name.se-cryonite"
      }
    }
  },
  ["se-core-fragment-se-holmium-ore"] = {
    localised_name = {
      "item-name.core-fragment",
      {
        "entity-name.se-holmium-ore"
      }
    }
  },
  ["se-core-fragment-se-iridium-ore"] = {
    localised_name = {
      "item-name.core-fragment",
      {
        "entity-name.se-iridium-ore"
      }
    }
  },
  ["se-core-fragment-se-vitamelange"] = {
    localised_name = {
      "item-name.core-fragment",
      {
        "entity-name.se-vitamelange"
      }
    }
  },
  ["se-core-fragment-se-vulcanite"] = {
    localised_name = {
      "item-name.core-fragment",
      {
        "entity-name.se-vulcanite"
      }
    }
  },
  ["se-core-fragment-stone"] = {
    localised_name = {
      "item-name.core-fragment",
      {
        "entity-name.stone"
      }
    }
  },
  ["se-core-fragment-uranium-ore"] = {
    localised_name = {
      "item-name.core-fragment",
      {
        "entity-name.uranium-ore"
      }
    }
  }
}
game.entity_prototypes = {
  coal = {
    autoplace_specification = true,
    name = "coal",
    type = "resource"
  },
  ["copper-ore"] = {
    autoplace_specification = true,
    name = "copper-ore",
    type = "resource"
  },
  ["crude-oil"] = {
    autoplace_specification = true,
    name = "crude-oil",
    type = "resource"
  },
  ["iron-ore"] = {
    autoplace_specification = true,
    name = "iron-ore",
    type = "resource"
  },
  ["se-beryllium-ore"] = {
    autoplace_specification = true,
    name = "se-beryllium-ore",
    type = "resource"
  },
  ["se-core-fragment-coal"] = {
    autoplace_specification = false,
    name = "se-core-fragment-coal",
    type = "resource"
  },
  ["se-core-fragment-coal-sealed"] = {
    autoplace_specification = false,
    name = "se-core-fragment-coal-sealed",
    type = "resource"
  },
  ["se-core-fragment-copper-ore"] = {
    autoplace_specification = false,
    name = "se-core-fragment-copper-ore",
    type = "resource"
  },
  ["se-core-fragment-copper-ore-sealed"] = {
    autoplace_specification = false,
    name = "se-core-fragment-copper-ore-sealed",
    type = "resource"
  },
  ["se-core-fragment-crude-oil"] = {
    autoplace_specification = false,
    name = "se-core-fragment-crude-oil",
    type = "resource"
  },
  ["se-core-fragment-crude-oil-sealed"] = {
    autoplace_specification = false,
    name = "se-core-fragment-crude-oil-sealed",
    type = "resource"
  },
  ["se-core-fragment-iron-ore"] = {
    autoplace_specification = false,
    name = "se-core-fragment-iron-ore",
    type = "resource"
  },
  ["se-core-fragment-iron-ore-sealed"] = {
    autoplace_specification = false,
    name = "se-core-fragment-iron-ore-sealed",
    type = "resource"
  },
  ["se-core-fragment-omni"] = {
    autoplace_specification = false,
    name = "se-core-fragment-omni",
    type = "resource"
  },
  ["se-core-fragment-omni-sealed"] = {
    autoplace_specification = false,
    name = "se-core-fragment-omni-sealed",
    type = "resource"
  },
  ["se-core-fragment-se-beryllium-ore"] = {
    autoplace_specification = false,
    name = "se-core-fragment-se-beryllium-ore",
    type = "resource"
  },
  ["se-core-fragment-se-beryllium-ore-sealed"] = {
    autoplace_specification = false,
    name = "se-core-fragment-se-beryllium-ore-sealed",
    type = "resource"
  },
  ["se-core-fragment-se-cryonite"] = {
    autoplace_specification = false,
    name = "se-core-fragment-se-cryonite",
    type = "resource"
  },
  ["se-core-fragment-se-cryonite-sealed"] = {
    autoplace_specification = false,
    name = "se-core-fragment-se-cryonite-sealed",
    type = "resource"
  },
  ["se-core-fragment-se-holmium-ore"] = {
    autoplace_specification = false,
    name = "se-core-fragment-se-holmium-ore",
    type = "resource"
  },
  ["se-core-fragment-se-holmium-ore-sealed"] = {
    autoplace_specification = false,
    name = "se-core-fragment-se-holmium-ore-sealed",
    type = "resource"
  },
  ["se-core-fragment-se-iridium-ore"] = {
    autoplace_specification = false,
    name = "se-core-fragment-se-iridium-ore",
    type = "resource"
  },
  ["se-core-fragment-se-iridium-ore-sealed"] = {
    autoplace_specification = false,
    name = "se-core-fragment-se-iridium-ore-sealed",
    type = "resource"
  },
  ["se-core-fragment-se-vitamelange"] = {
    autoplace_specification = false,
    name = "se-core-fragment-se-vitamelange",
    type = "resource"
  },
  ["se-core-fragment-se-vitamelange-sealed"] = {
    autoplace_specification = false,
    name = "se-core-fragment-se-vitamelange-sealed",
    type = "resource"
  },
  ["se-core-fragment-se-vulcanite"] = {
    autoplace_specification = false,
    name = "se-core-fragment-se-vulcanite",
    type = "resource"
  },
  ["se-core-fragment-se-vulcanite-sealed"] = {
    autoplace_specification = false,
    name = "se-core-fragment-se-vulcanite-sealed",
    type = "resource"
  },
  ["se-core-fragment-stone"] = {
    autoplace_specification = false,
    name = "se-core-fragment-stone",
    type = "resource"
  },
  ["se-core-fragment-stone-sealed"] = {
    autoplace_specification = false,
    name = "se-core-fragment-stone-sealed",
    type = "resource"
  },
  ["se-core-fragment-uranium-ore"] = {
    autoplace_specification = false,
    name = "se-core-fragment-uranium-ore",
    type = "resource"
  },
  ["se-core-fragment-uranium-ore-sealed"] = {
    autoplace_specification = false,
    name = "se-core-fragment-uranium-ore-sealed",
    type = "resource"
  },
  ["se-cryonite"] = {
    autoplace_specification = true,
    name = "se-cryonite",
    type = "resource"
  },
  ["se-holmium-ore"] = {
    autoplace_specification = true,
    name = "se-holmium-ore",
    type = "resource"
  },
  ["se-iridium-ore"] = {
    autoplace_specification = true,
    name = "se-iridium-ore",
    type = "resource"
  },
  ["se-methane-ice"] = {
    autoplace_specification = true,
    name = "se-methane-ice",
    type = "resource"
  },
  ["se-naquium-ore"] = {
    autoplace_specification = true,
    name = "se-naquium-ore",
    type = "resource"
  },
  ["se-vitamelange"] = {
    autoplace_specification = true,
    name = "se-vitamelange",
    type = "resource"
  },
  ["se-vulcanite"] = {
    autoplace_specification = true,
    name = "se-vulcanite",
    type = "resource"
  },
  ["se-water-ice"] = {
    autoplace_specification = true,
    name = "se-water-ice",
    type = "resource"
  },
  stone = {
    autoplace_specification = true,
    name = "stone",
    type = "resource"
  },
  ["uranium-ore"] = {
    autoplace_specification = true,
    name = "uranium-ore",
    type = "resource"
  }
}
CoreMiner = {}
CoreMiner.update_zone_fragment_resources = function () end
CoreMiner.generate_core_seam_positions = function () end
settings = {}
settings.global = {}
settings.global["robot-attrition-factor"] = { value = 1 }  -- FIXME
settings.startup = {}
settings.startup["se-spawn-small-resources"] = { value = false }  -- FIXME

local FACTORIO_HOME
if os.getenv('FACTORIO_HOME') ~= nil then
    FACTORIO_HOME = os.getenv('FACTORIO_HOME')
else
    if env.operating_system() == "win32" then
        FACTORIO_HOME = env.join_path(os.getenv('APPDATA'), "Factorio")
    elseif env.operating_system() == "linux" then
        FACTORIO_HOME = env.join_path(os.getenv('HOME'), ".factorio")
    elseif env.operating_system() == "macos" then
        FACTORIO_HOME = env.join_path(os.getenv('HOME'), "Library", "Application Support", "factorio")
    else
        error("unknown operating system: " .. env.operating_system())
    end
end
local MOD_NAME = 'space-exploration'
local MOD_VERSION = '0.6.111'
local MOD_TAG = MOD_NAME .. '_' .. MOD_VERSION

do
    local archive = env.join_path(FACTORIO_HOME, "mods", MOD_TAG .. ".zip")

    local function load_from_zip(path)
        local data = zip.extract(archive, MOD_TAG .. '/' .. path)
        return load(data, '__' .. MOD_NAME .. '__/' .. path)()
    end

    package.loaded['__space-exploration__/shared_util'] = load_from_zip('shared_util.lua')
    util = load_from_zip('scripts/util.lua')
    Util = util
    Shared = load_from_zip('shared.lua')
    UniverseRaw = load_from_zip('scripts/universe-raw.lua')
    Zone = load_from_zip('scripts/zone.lua')
    Universe = load_from_zip('scripts/universe.lua')
    Ancient = load_from_zip('scripts/ancient.lua')
end

local NAME = {}
local NAME_index = {}
name_file = io.open('NAMES.txt', 'r')
assert(name_file)
for name in name_file:lines("*l") do
    table.insert(NAME, name)
    NAME_index[name] = #NAME
end
name_file:close()

local RESOURCE = {
    "coal", "stone", "iron-ore", "copper-ore", "crude-oil", "uranium-ore",
    "se-vulcanite", "se-cryonite", "se-vitamelange", "se-holmium-ore", "se-beryllium-ore", "se-iridium-ore",
    "se-water-ice", "se-methane-ice", "se-naquium-ore"}

local function pack_secondary_score(score)
    local x = math.pow(7 * score, 1/3)
    return math.min(255, math.max(0, math.floor(256 * x)))
end

local function unpack_secondary_score(b)
    local x = (b + 0.5) / 256
    return math.pow(x, 3) / 7
end

function bit32.pext(x, m)
    local r = 0
    local c = 0
    for i = 0, 31 do
        if bit32.band(m, bit32.lshift(1, i)) ~= 0 then
            if bit32.band(x, bit32.lshift(1, i)) ~= 0 then
                r = bit32.bor(r, bit32.lshift(1, c))
            end
            c = c + 1
        end
    end
    return r
end

function bit32.pdep(x, m)
    local r = 0
    local c = 0
    for i = 0, 31 do
        if bit32.band(m, bit32.lshift(1, i)) ~= 0 then
            if bit32.band(x, bit32.lshift(1, c)) ~= 0 then
                r = bit32.bor(r, bit32.lshift(1, i))
            end
            c = c + 1
        end
    end
    return r
end

local function pack_planet_or_moon_summary(summary)
    local p = 0
    local m = 0
    local c = 0
    local w2 = 0
    local w3 = 0
    for i, name in ipairs(RESOURCE) do
        local s = summary.resource[RESOURCE[i]]
        if s ~= nil then
            if s == 1 then
                p = i
            elseif s > 0 then
                m = bit32.bor(m, bit32.lshift(1, i))
                local x = pack_secondary_score(s)
                if c < 4 then
                    w2 = bit32.bor(w2, bit32.lshift(x, 8*c))
                else
                    w3 = bit32.bor(w3, bit32.lshift(x, 8*(c-4)))
                end
                c = c + 1
            end
        end
    end
    assert(c <= 8)
    assert(bit32.band(m, 0xe001) == 0)

    local b
    if summary.biome == "other" then
        b = 0
    elseif summary.biome == "volcanic" then
        b = 1
    elseif summary.biome == "frozen" then
        b = 2
    elseif summary.biome == "mild" then
        b = 3
    end

    local h = summary.water * 4

    local w0 = 0
    w0 = bit32.bor(w0, bit32.lshift(NAME_index[summary.name], 0))  -- 0~9
    w0 = bit32.bor(w0, bit32.lshift(p, 10))  -- 10~13
    w0 = bit32.bor(w0, bit32.lshift(b, 14))  -- 14~15
    w0 = bit32.bor(w0, bit32.lshift(bit32.pext(m, 0x1ff7), 16))  -- 16~27
    w0 = bit32.bor(w0, bit32.lshift(h, 28))  -- 28~30
    -- bit 31 unused

    local w1 = 0
    w1 = bit32.bor(w1, bit32.lshift(summary.radius, 0))  -- 0~13
    w1 = bit32.bor(w1, bit32.lshift(summary.delta_v, 14))  -- 14~32

    return struct.pack("<IIII", w0, w1, w2, w3)
end

local function pack_field_summary(summary)
    local p = 0
    local m = 0
    local c = 0
    local w2 = 0
    local w3 = 0
    for i, name in ipairs(RESOURCE) do
        local s = summary.resource[RESOURCE[i]]
        if s ~= nil then
            if s == 1 then
                p = i
            elseif s > 0 then
                m = bit32.bor(m, bit32.lshift(1, i))
                local x = pack_secondary_score(s)
                if c < 4 then
                    w2 = bit32.bor(w2, bit32.lshift(x, 8*c))
                else
                    w3 = bit32.bor(w3, bit32.lshift(x, 8*(c-4)))
                end
                c = c + 1
            end
        end
    end
    assert(c <= 6)
    assert(bit32.band(m, 0x17a3) == 0)

    local k
    if summary.cannonable then
        k = 1
    else
        k = 0
    end

    local w0 = 0
    w0 = bit32.bor(w0, bit32.lshift(NAME_index[summary.name], 0))  -- 0~9
    w0 = bit32.bor(w0, bit32.lshift(p, 10))  -- 10~13
    w0 = bit32.bor(w0, bit32.lshift(k, 14))  -- 14~14
    w0 = bit32.bor(w0, bit32.lshift(summary.delta_v, 16))  -- 16~29
    -- bits 15~15, 30~31 unused

    local w1 = 0
    w1 = bit32.bor(w1, bit32.lshift(bit32.pext(m, 0xe85c), 0))  -- 0~7

    return struct.pack("<IBIH", w0, w1, w2, w3)
end

local function pack_seed_summary(summary)
    local r = {}
    table.insert(r, struct.pack("<IBBB", summary.seed, #(summary.planets), #(summary.moons), #(summary.fields)))
    for _, planet in ipairs(summary.planets) do
        table.insert(r, pack_planet_or_moon_summary(planet))
    end
    for _, moon in ipairs(summary.moons) do
        table.insert(r, pack_planet_or_moon_summary(moon))
    end
    for _, field in ipairs(summary.fields) do
        table.insert(r, pack_field_summary(field))
    end
    return table.concat(r)
end

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
    for i, name in ipairs(RESOURCE) do
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
    for i, name in ipairs(RESOURCE) do
        if s[i] ~= 0 then
            summary.resource[RESOURCE[i]] = s[i]
        end
    end

    if zone.type ~= "asteroid-field" then
        if zone.tags.temperature == "temperature_volcanic" then
            summary.biome = "volcanic"
        elseif zone.tags.temperature == "temperature_frozen" then
            summary.biome = "frozen"
        elseif zone.tags.temperature == "temperature_bland" then
            summary.biome = "mild"
        else
            summary.biome = "other"
        end
    end

    if zone.type ~= "asteroid-field" then
        if zone.tags.water == "water_none" then
            summary.water = 0.0
        elseif zone.tags.water == "water_low" then
            summary.water = 0.25
        elseif zone.tags.water == "water_med" then
            summary.water = 0.5
        elseif zone.tags.water == "water_high" then
            summary.water = 0.75
        elseif zone.tags.water == "water_max" then
            summary.water = 1.0
        end
    end

    return summary
end

local function summarize_seed(seed)
    FactorioRNG.global_seed = seed
    global = {}
    global.meteor_zones = {}
    global.forces = {}
    global.forces.player = {}
    Universe.build()

    local nauvis = global.zones_by_name['Nauvis']

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

--    for i = 1, 60 do
--        print(Ancient.get_next_vault_loot({ name = "player" }))
--    end

    return {
        seed = seed,
        planets = planets,
        moons = moons,
        fields = fields,
    }
end

local seed = tonumber(arg[1])
local summary = summarize_seed(seed)
--if #(summary.planets) >= 8 then
--    print(seed, #(summary.planets))
--end
--print(json.encode(summary))
io.stdout:write(pack_seed_summary(summary))
--pack_seed_summary(summary)

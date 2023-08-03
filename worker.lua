local zip = require('zip')
local env = require('env')

serpent = {}
serpent.block = function () return "" end
-- serpent = dofile('./serpent.lua')

util = dofile('./factorio-util.lua')

function table_size(t)
    local count = 0
    for k,v in pairs(t) do
        count = count + 1
    end
    return count
end

log = function () end
Log = { debug_log = function () end }

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
local MOD_VERSION = '0.6.108'
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
end

local function check_seed(seed)
    FactorioRNG.global_seed = seed
    global = {}
    global.meteor_zones = {}
    Universe.build()

    local nauvis = global.zones_by_name['Nauvis']

    local celestial_bodies = {}
    for _, planet in pairs(global.zones_by_name['Calidus'].children) do
        if planet.type == "planet" then
            if not planet.is_homeworld then
                table.insert(celestial_bodies, planet)
            end 
            for _, moon in pairs(planet.children) do
                if moon.type == "moon" then  -- Shouldn't be necessary, but...
                    table.insert(celestial_bodies, moon)
                end
            end
        end
    end

    local asteroid_fields = {}
    for _, zone in pairs(global.zones_by_name) do
        if zone.type == "asteroid-field" then
            table.insert(asteroid_fields, zone)
        end
    end

    local stars = {}
    for _, zone in pairs(global.zones_by_name) do
        if zone.type == "star" then
            table.insert(stars, zone)
        end
    end

    local resources = {"coal","copper-ore", "crude-oil", "iron-ore", "se-beryllium-ore", "se-cryonite", "se-holmium-ore", "se-iridium-ore", "se-methane-ice", "se-naquium-ore", "se-vitamelange", "se-vulcanite", "se-water-ice", "stone", "uranium-ore"}
    local best = { P = { score = 0 }, U = { score = 0 }, B = { score = 0 }, E = { score = 0 }, A = { score = 0 }, M = { score = 0 }, D = { score = 0 } }
    for _, body in pairs(celestial_bodies) do
        local score = {}
        for _, resource in pairs(resources) do
            local control = body.controls[resource]
            score[resource] = control.frequency * control.richness * control.size
        end
        local primary_score = score[body.primary_resource]
        for _, resource in pairs(resources) do
            score[resource] = score[resource] / primary_score
        end

        -- TODO: oil is weird; what is the correct scaling factor here?
        score["crude-oil"] = score["crude-oil"] * 1.0

        local delta_v = Zone.get_travel_delta_v(nauvis, body)
        local radius_score = 1.0 + 0.0 * math.pow(1 - math.abs((math.log(body.radius) - math.log(2000)) / math.log(5)), 0.5)
        local base_score = 7.0 * radius_score

        local water_level
        if body.tags.water == "water_none" then
            if body.primary_resource ~= "se-vulcanite" then
                base_score = base_score * 0.0
            else
                base_score = base_score * 1.0
            end
            water_level = ' '
        elseif body.tags.water == "water_low" then
            base_score = base_score * 1.0
            water_level = '▘'
        elseif body.tags.water == "water_med" then
            base_score = base_score * 1.0
            water_level = '▚'
        elseif body.tags.water == "water_high" then
            base_score = base_score * 0.0
            water_level = '▛'
        elseif body.tags.water == "water_max" then
            base_score = base_score * 0.0
            water_level = '█'
        end

        if body.primary_resource == "se-vulcanite" and body.tags.temperature == "temperature_volcanic" then
            local P_score = base_score * score["crude-oil"]
            if P_score > best.P.score then
                best.P.score = P_score
                best.P.name = body.name
                best.P.delta_v = delta_v
                best.P.water_level = water_level
            end
        end

        if body.primary_resource == "se-cryonite" and body.tags.temperature == "temperature_frozen" then
            local U_score = base_score * score["crude-oil"]
            if U_score > best.U.score then
                best.U.score = U_score
                best.U.name = body.name
                best.U.delta_v = delta_v
                best.U.water_level = water_level
            end
        end

        if body.primary_resource == "se-vitamelange" and body.tags.temperature == "temperature_bland" then
            local B_score = base_score * score["stone"]
            if B_score > best.B.score then
                best.B.score = B_score
                best.B.name = body.name
                best.B.delta_v = delta_v
                best.B.water_level = water_level
            end
        end

        if body.primary_resource == "se-holmium-ore" then
            local E_score = base_score * score["crude-oil"]
            if E_score > best.E.score then
                best.E.score = E_score
                best.E.name = body.name
                best.E.delta_v = delta_v
                best.E.water_level = water_level
            end
        end

        if body.primary_resource == "se-beryllium-ore" then
            local A_score = base_score * score["crude-oil"]
            if A_score > best.A.score then
                best.A.score = A_score
                best.A.name = body.name
                best.A.delta_v = delta_v
                best.A.water_level = water_level
            end
        end

        if body.primary_resource == "se-iridium-ore" then
            local M_score = base_score * score["crude-oil"]
            if M_score > best.M.score then
                best.M.score = M_score
                best.M.name = body.name
                best.M.delta_v = delta_v
                best.M.water_level = water_level
            end
        end
    end

    for _, field in pairs(asteroid_fields) do
        local score = {}
        for _, resource in pairs(resources) do
            local control = field.controls[resource]
            score[resource] = control.frequency * control.richness * control.size
        end
        local primary_score = score[field.primary_resource]
        for _, resource in pairs(resources) do
            score[resource] = score[resource] / primary_score
        end

        local closest_star = { delta_v = 1/0, name = nil }
        for _, star in ipairs(stars) do
            local delta_v = Zone.get_travel_delta_v(field, star)
            if delta_v < closest_star.delta_v then
                closest_star.delta_v = delta_v
                closest_star.name = star.name
            end
        end

        local base_score = 7.0 * (20000 / Zone.get_travel_delta_v(field, nauvis))
        if field.primary_resource == "se-naquium-ore" then
            local D_score = base_score * score["se-methane-ice"]
            if D_score > best.D.score then
                best.D.score = D_score
                best.D.name = field.name
                best.D.delta_v = delta_v
            end
        end
    end

    local P_weight = 1.0
    local U_weight = 1.0
    local B_weight = 1.0
    local E_weight = 1.0
    local A_weight = 1.0
    local M_weight = 1.0
    local D_weight = 1.0
    local total_weight = P_weight + U_weight + B_weight + E_weight + A_weight + M_weight + D_weight
    local score_exponent = -4.0
    local final_score = math.pow((
        P_weight * math.pow(best.P.score, score_exponent) +
        U_weight * math.pow(best.U.score, score_exponent) +
        B_weight * math.pow(best.B.score, score_exponent) +
        E_weight * math.pow(best.E.score, score_exponent) +
        A_weight * math.pow(best.A.score, score_exponent) +
        M_weight * math.pow(best.M.score, score_exponent) +
        D_weight * math.pow(best.D.score, score_exponent) +
        0) / total_weight, 1.0 / score_exponent)

    if final_score > 0.0 then
        report_file:write(string.format('%10d %7.4f ', seed, final_score))
        report_file:write(string.format('P[%11s] (%5.3f %1s) ', best.P.name, best.P.score, best.P.water_level))
        report_file:write(string.format('U[%11s] (%5.3f %1s) ', best.U.name, best.U.score, best.U.water_level))
        report_file:write(string.format('B[%11s] (%5.3f %1s) ', best.B.name, best.B.score, best.B.water_level))
        report_file:write(string.format('E[%11s] (%5.3f %1s) ', best.E.name, best.E.score, best.E.water_level))
        report_file:write(string.format('A[%11s] (%5.3f %1s) ', best.A.name, best.A.score, best.A.water_level))
        report_file:write(string.format('M[%11s] (%5.3f %1s) ', best.M.name, best.M.score, best.M.water_level))
        report_file:write(string.format('D[%16s] (%5.3f) ', best.D.name, best.D.score))
        report_file:write(string.format('{v10}\n'))
        report_file:flush()
    end
end

local chunk = tonumber(arg[1])
local chunk_size = math.pow(2, 16)

local start_seed = math.max(340, chunk * chunk_size)
local end_seed = start_seed + chunk_size - 2

hint_file_name = env.join_path('output', string.format('report-%04x.hint', chunk))
report_file_name = env.join_path('output', string.format('report-%04x.txt', chunk))

if env.file_exists(hint_file_name) then
    hint_file = io.open(hint_file_name, 'r')
    assert(hint_file)

    report_file = io.open(report_file_name .. '.tmp', 'w+')
    assert(report_file)

    for seed in hint_file:lines("*n") do
        check_seed(seed)
    end

    report_file:close()
    os.rename(report_file_name .. '.tmp', report_file_name)

    hint_file:close()
    os.remove(hint_file_name)
else
    if env.file_exists(report_file_name) then
        return
    end

    report_file = io.open(report_file_name .. '.tmp', 'w+')
    assert(report_file)

    for seed = start_seed, end_seed, 2 do
        check_seed(seed)
    end

    report_file:close()
    os.rename(report_file_name .. '.tmp', report_file_name)
end

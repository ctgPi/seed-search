#!/usr/bin/env lua5.2

local zip = require('zip')

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

local PATH_SEPARATOR = package.config:sub(1, 1)
-- local FACTORIO_HOME = '/home/fabio/factorio/1.1.80'
local FACTORIO_HOME
if os.getenv('FACTORIO_HOME') ~= nil then
    FACTORIO_HOME = os.getenv('FACTORIO_HOME')
else
    -- Windows
    FACTORIO_HOME = os.getenv('APPDATA') .. PATH_SEPARATOR .. "Factorio"
    -- Linux
    -- FACTORIO_HOME = os.getenv('HOME') .. PATH_SEPARATOR .. ".factorio"
    -- MacOS
    -- FACTORIO_HOME = os.getenv('HOME') .. PATH_SEPARATOR .. "Library" .. PATH_SEPARATOR .. "Application Support" .. PATH_SEPARATOR .. "factorio"
end
local MOD_NAME = 'space-exploration'
local MOD_VERSION = '0.6.108'
local MOD_TAG = MOD_NAME .. '_' .. MOD_VERSION

do
    local archive = FACTORIO_HOME .. PATH_SEPARATOR .. "mods" .. PATH_SEPARATOR .. MOD_TAG .. ".zip"

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

    local best = { B = { score = 0 }, E = { score = 0 }, A = { score = 0 }, M = { score = 0 } }
    for _, body in pairs(celestial_bodies) do
        -- We don't want waterless bodies.
        if body.tags.water ~= "water_none" then
            local score = {}
            for _, resource in pairs({"coal","copper-ore", "crude-oil", "iron-ore", "se-beryllium-ore", "se-cryonite", "se-holmium-ore", "se-iridium-ore", "se-methane-ice", "se-naquium-ore", "se-vitamelange", "se-vulcanite", "se-water-ice", "stone", "uranium-ore"}) do
                local control = body.controls[resource]
                -- We prioritize patch frequency, for easier logistics.
                score[resource] = math.pow(control.frequency, 2) * control.richness * control.size
            end

            -- TODO: oil is weird; what is the correct scaling factor here?
            --       eyeballing the FP plans seems like only half the oil is consumed
            --       on land, but maybe we can live with less because it's infinite?
            score["crude-oil"] = score["crude-oil"] * 2

            -- We calculate the cost of each T4 science pack, assuming:
            --   * no prod modules;
            --   * using ingots/pyroflux/good recipes for heatshielding/LDS/etc.
            -- 
            -- B: 1538  vita +  253  vulc +   19  cryo +  930   oil +   6  coal
            --  +  248 stone +    8  iron +    5  copp +    8  uran + 34k water
            --
            -- E:  857  holm +  126  vulc +  451  cryo + 1899   oil +  39  coal
            --  -  146 stone +   16  iron +   49  copp +    4  uran +  5k water
            --
            -- A:  998 beryl +  124  vulc +  208  cryo +  842   oil +   8  coal
            --  -   23 stone +   26  iron +    6  copp +    0  uran +  2k water
            --
            -- M:  733  irid +  437  vulc +   15  cryo + 1527   oil +  22  coal
            --  -   68 stone +   17  iron +    2  copp +    4  uran +  5k water
            --
            -- D:  443   naq +  443  vita +  219  holm +  216  irid + 156 beryl (+ ...)
            --
            -- (plus secondary amounts of the other resorces, but only one BEAM resource
            --  can spawn in the same surface)
            -- 
            --   * B requires vita core fragments directly, consumes the most ore per
            --     pack of the 4 sciences, and are also consumed by deep space packs.
            --     Additionally, they require grassy terrain, which conflicts with
            --     vulc/cryo: let's assign it as a primary resource. To maximize patch
            --     spawn rates, we also require it to have a mild climate.
            --
            --   * E needs blue beads, which stack poorly and are best manufactured
            --     locally; we choose a cryonite-primary planet that does double-duty
            --     providing cryonite rods and holmium ingots. We also make sure that
            --     the planet is frozen.
            --
            --   * A??
            --
            --   * M needs red beads; for similar reasons as E we want it in a vulc
            --     planet with a volcanic biome.

            local delta_v = Zone.get_travel_delta_v(nauvis, body)
            local scaled_radius = body.radius * 0.5E-3
            local base_score = math.min(1.0, scaled_radius) --* math.pow((2E3) / (1E3 + delta_v), 0.5)
            local secondary_exponent = 0.5

            if body.primary_resource == "se-vitamelange" and body.tags.temperature == "temperature_bland" then
                local B_score = score["se-vitamelange"]
                B_score = math.min(B_score, math.pow(1538 /  248, secondary_exponent) * score["stone"])
                B_score = math.min(B_score, math.pow(1538 /  930, secondary_exponent) * score["crude-oil"])
                B_score = base_score * B_score / 1.538
                if B_score > best.B.score then
                    best.B.score = B_score
                    best.B.name = body.name
                    best.B.delta_v = delta_v
                end
            end
            if body.primary_resource == "se-cryonite" and body.tags.temperature == "temperature_frozen" then
                local E_score = score["se-holmium-ore"]
                E_score = math.min(E_score, math.pow(857 / 1899, secondary_exponent) * score["crude-oil"])
                -- TODO: boost copper for blue chips etc.?
                E_score = math.min(E_score, math.pow(857 /   49, secondary_exponent) * score["copper-ore"])
                E_score = math.min(E_score, math.pow(857 /   39, secondary_exponent) * score["coal"])
                E_score = base_score * E_score / 0.857
                if E_score > best.E.score then
                    best.E.score = E_score
                    best.E.name = body.name
                    best.E.delta_v = delta_v
                end
            end
            if true then
                local A_score = score["se-beryllium-ore"]
                A_score = math.min(A_score, math.pow(998 / 842, secondary_exponent) * score["crude-oil"])
                A_score = base_score * A_score / 0.998
                -- TODO: associate with cryo/iron?
                if A_score > best.A.score then
                    best.A.score = A_score
                    best.A.name = body.name
                    best.A.delta_v = delta_v
                end
            end
            if body.primary_resource == "se-vulcanite" and body.tags.temperature == "temperature_volcanic" then
                local M_score = score["se-iridium-ore"]
                M_score = math.min(M_score, math.pow(733 / 1527, secondary_exponent) * score["crude-oil"])
                M_score = math.min(M_score, math.pow(733 /   22, secondary_exponent) * score["coal"])
                M_score = base_score * M_score / 0.733
                if M_score > best.M.score then
                    best.M.score = M_score
                    best.M.name = body.name
                    best.M.delta_v = delta_v
                end
            end
        end
    end

    local score_exponent = -4.0
    local final_score = math.pow(0.25 * (
        math.pow(best.B.score, score_exponent) + math.pow(best.E.score, score_exponent) +
        math.pow(best.A.score, score_exponent) + math.pow(best.M.score, score_exponent)), 1.0 / score_exponent)

    if final_score > 0.0 then
        report_file:write(string.format('%10d %7.4f ', seed, final_score))
        report_file:write(string.format('B[%11s] (%5.2f) ', best.B.name, best.B.score))
        report_file:write(string.format('E[%11s] (%5.2f) ', best.E.name, best.E.score))
        report_file:write(string.format('A[%11s] (%5.2f) ', best.A.name, best.A.score))
        report_file:write(string.format('M[%11s] (%5.2f)\n', best.M.name, best.M.score))
    end
end

local chunk = tonumber(arg[1])
local chunk_size = math.pow(2, 16)

local start_seed = math.max(340, chunk * chunk_size)
local end_seed = start_seed + chunk_size - 2

hint_file_name = string.format('output/report-%04x.hint', chunk)
report_file_name = string.format('output/report-%04x.txt', chunk)

if os.execute('test -e ' .. hint_file_name) then
    hint_file = io.open(hint_file_name, 'r')
    assert(hint_file)

    report_file = io.open(report_file_name .. '.tmp', 'w+')
    assert(report_file)
    report_file:setvbuf('line')

    for seed in hint_file:lines("*n") do
        check_seed(seed)
    end

    report_file:close()
    os.rename(report_file_name .. '.tmp', report_file_name)

    hint_file:close()
    os.remove(hint_file_name)
else
    if os.execute('test -e ' .. report_file_name) then
        return
    end

    report_file = io.open(report_file_name .. '.tmp', 'w+')
    assert(report_file)
    report_file:setvbuf('line')

    for seed = start_seed, end_seed, 2 do
        check_seed(seed)
    end

    report_file:close()
    os.rename(report_file_name .. '.tmp', report_file_name)
end

#!/usr/bin/env lua5.2

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

function FactorioRNG.__call(self, bound_1, bound_2)
    self.x = bit32.bxor(bit32.rshift(bit32.bxor(bit32.lshift(self.x, 13), self.x), 19),
        bit32.lshift(bit32.band(self.x, 0x000ffffe), 12));
    self.y = bit32.bxor(bit32.rshift(bit32.bxor(bit32.lshift(self.y,  2), self.y), 25),
        bit32.lshift(bit32.band(self.y, 0x0ffffff8),  4));
    self.z = bit32.bxor(bit32.rshift(bit32.bxor(bit32.lshift(self.z,  3), self.z), 11),
        bit32.lshift(bit32.band(self.z, 0x00007ff0), 17));
    r = bit32.bxor(self.x, self.y, self.z) * 2.3283064365386963e-10;
    if bound_1 == nil then
        return r
    end
    local l, h
    if bound_2 == nil then
        l = 1
        h = math.floor(bound_1)
    else
        l = math.ceil(bound_1)
        h = math.floor(bound_2)
    end

    return math.floor(l + (h - l + 1) * r);
end

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
                        frequency = 0.16666667163372,  -- TODO: do we want a small or a big Nauvis?
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

base_dir = './space-exploration_0.6.104/'

package.loaded['__space-exploration__/shared_util'] = dofile(base_dir .. 'shared_util.lua')
util = dofile(base_dir .. 'scripts/util.lua')
Util = dofile(base_dir .. 'scripts/util.lua')
Shared = dofile(base_dir .. 'shared.lua')
UniverseRaw = dofile(base_dir .. 'scripts/universe-raw.lua')
Zone = dofile(base_dir .. 'scripts/zone.lua')
Universe = dofile(base_dir .. 'scripts/universe.lua')

local chunk = tonumber(arg[1])
local chunk_size = math.pow(2, 12)

local start_seed = chunk * chunk_size
local end_seed = start_seed + chunk_size - 2

report_file_name = string.format('output/report-%05x.txt', chunk)

if os.execute('test -e ' .. report_file_name) then
    return
end

report_file = io.open(report_file_name .. '.tmp', 'w+')
assert(report_file)
report_file:setvbuf('line')

for seed = 100 * math.floor(start_seed / 100), 100 * math.ceil((end_seed + 2) / 100) - 2, 2 do
    if seed % 100 == 0 then
        io.stderr:write(string.format('%10d : ', seed))
    end
    if seed < 340 or seed < start_seed or end_seed < seed then
        io.stderr:write(' ')
    else
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
                    score[resource] = control.frequency * control.richness * control.size
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
                local base_score = math.pow(body.radius * 1E-3, 1.0) * math.pow((2E3) / (1E3 + delta_v), 1.0)

                if body.primary_resource == "se-vitamelange" and body.tags.temperature == "temperature_bland" then
                    local B_score = score["se-vitamelange"]
                    B_score = math.min(B_score, 1538 /  248 * score["stone"])
                    B_score = math.min(B_score, 1538 /  930 * score["crude-oil"])
                    B_score = base_score * B_score / 1.538
                    if B_score > best.B.score then
                        best.B.score = B_score
                        best.B.name = body.name
                        best.B.delta_v = delta_v
                    end
                end
                if body.primary_resource == "se-cryonite" and body.tags.temperature == "temperature_frozen" then
                    local E_score = score["se-holmium-ore"]
                    E_score = math.min(E_score, 857 / 1899 * score["crude-oil"])
                    -- TODO: boost copper for blue chips etc.?
                    E_score = math.min(E_score, 857 /   49 * score["copper-ore"])
                    E_score = math.min(E_score, 857 /   39 * score["coal"])
                    E_score = base_score * E_score / 0.857
                    if E_score > best.E.score then
                        best.E.score = E_score
                        best.E.name = body.name
                        best.E.delta_v = delta_v
                    end
                end
                if body.primary_resource == "crude-oil" then
                    local A_score = score["se-beryllium-ore"]
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
                    M_score = math.min(M_score, 733 / 1527 * score["crude-oil"])
                    M_score = math.min(M_score, 733 /   22 * score["coal"])
                    M_score = base_score * M_score / 0.733
                    if M_score > best.M.score then
                        best.M.score = M_score
                        best.M.name = body.name
                        best.M.delta_v = delta_v
                    end
                end
            end
        end

        local score_exponent = -2.0
        local final_score = math.pow(0.25 * (
            math.pow(best.B.score, -2.0) + math.pow(best.E.score, -2.0) +
            math.pow(best.A.score, -2.0) + math.pow(best.M.score, -2.0)), -0.5)

        if final_score > 0 then
            report_file:write(string.format('%d\t%.4f\t', seed, final_score))
            report_file:write(string.format('B[%s] (%.4f, Δv=%.0f)\t', best.B.name, best.B.score, best.B.delta_v))
            report_file:write(string.format('E[%s] (%.4f, Δv=%.0f)\t', best.E.name, best.E.score, best.E.delta_v))
            report_file:write(string.format('A[%s] (%.4f, Δv=%.0f)\t', best.A.name, best.A.score, best.A.delta_v))
            report_file:write(string.format('M[%s] (%.4f, Δv=%.0f)\n', best.M.name, best.M.score, best.M.delta_v))
            io.stderr:write('#')
        else
            io.stderr:write('.')
        end
    end
    if (seed + 2) % 100 == 0 then
        io.stderr:write('\n')
    elseif (seed + 2) % 20 == 0 then
        io.stderr:write(' ')
    end
end

report_file:close()
os.rename(report_file_name .. '.tmp', report_file_name)

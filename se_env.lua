local se_env = {}

local zip = require('zip')
local env = require('env')

serpent = {}
serpent.block = function () return "" end
serpent.line = function () return "" end
--serpent = dofile('./serpent.lua')

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

local MOD_NAME = 'space-exploration'
local MOD_VERSION = '0.6.114'
local MOD_TAG = MOD_NAME .. '_' .. MOD_VERSION

local FACTORIO_HOME
if os.getenv('FACTORIO_HOME') ~= nil then
    FACTORIO_HOME = os.getenv('FACTORIO_HOME')
elseif env.file_exists(env.join_path('.', 'mods', MOD_TAG .. ".zip")) then
    FACTORIO_HOME = '.'
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

do
    local archive = env.join_path(FACTORIO_HOME, "mods", MOD_TAG .. ".zip")
    if not env.file_exists(archive) then
        io.stderr:write("Could not find " .. archive .. "!\n")
        io.stderr:write("Set the FACTORIO_HOME environment variable or copy " .. MOD_TAG .. ".zip into the mods/ directory.\n")
        os.exit(1)
    end

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

return se_env

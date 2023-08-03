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
Log = { debug_log = function () end }

FactorioRNG = { global_seed = nil }
function FactorioRNG:new(o)
    o = o or {}   -- create object if user does not provide one
    setmetatable(o, self)
    self.__index = self
    return o
end

function FactorioRNG:next()
    self.x = bit32.bxor(
        bit32.rshift(bit32.bxor(bit32.lshift(self.x, 13), self.x), 19),
        bit32.lshift(bit32.band(self.x, 0x000ffffe), 12));

    self.y = bit32.bxor(
        bit32.rshift(bit32.bxor(bit32.lshift(self.y,  2), self.y), 25),
        bit32.lshift(bit32.band(self.y, 0x0ffffff8),  4));

    self.z = bit32.bxor(
        bit32.rshift(bit32.bxor(bit32.lshift(self.z,  3), self.z), 11),
        bit32.lshift(bit32.band(self.z, 0x00007ff0), 17));
end

function FactorioRNG:prev()
    local u = bit32.bxor(
        bit32.rshift(self.x, 1),
        bit32.rshift(self.x, 19))
    self.x = bit32.bxor(
        bit32.rshift(self.x, 12),
        bit32.lshift(u, 20))

    local v = bit32.bxor(
        bit32.rshift(self.y, 3),
        bit32.rshift(self.y, 30))
    v = bit32.bxor(v, bit32.lshift(v, 2))
    self.y = bit32.bxor(
        bit32.rshift(self.y, 4),
        bit32.lshift(v, 28))

    local w = bit32.bxor(
        bit32.rshift(self.z, 4),
        bit32.rshift(self.z, 29))
    w = bit32.bxor(w, bit32.lshift(w, 3))
    w = bit32.bxor(w, bit32.lshift(w, 6))
    w = bit32.bxor(w, bit32.lshift(w, 12))
    self.z = bit32.bxor(
        bit32.rshift(self.z, 17),
        bit32.lshift(w, 15))
end

function FactorioRNG.__call(self, bound_1, bound_2)
    self:next()

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
Event = {}
Event.addListener = function () end
Event.trigger = function () end
defines = {}
defines.events = {}
defines.direction = {  -- FIXME
    south = {},
    west = {},
    north = {},
    east = {},
}
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
global = {}

base_dir = './space-exploration_0.6.104/'

package.loaded['__space-exploration__/shared_util'] = dofile(base_dir .. 'shared_util.lua')
util = dofile(base_dir .. 'scripts/util.lua')
Util = dofile(base_dir .. 'scripts/util.lua')
Shared = dofile(base_dir .. 'shared.lua')
--UniverseRaw = dofile(base_dir .. 'scripts/universe-raw.lua')
--Zone = dofile(base_dir .. 'scripts/zone.lua')
--Universe = dofile(base_dir .. 'scripts/universe.lua')
sha2 = {}
sha2.hash256 = function (s) return s end
Ancient = dofile(base_dir .. 'scripts/ancient.lua')

local seed = 2784861330
local target = { 50, 7, 13, 3, 41, 1, 51, 56, 22, 54, 55, 10 }
local rng = FactorioRNG:new{ x = seed, y = seed, z = seed }
for h = 0, 20000 do
    math.random = FactorioRNG:new{ x = rng.x, y = rng.y, z = rng.z }

        Ancient.cryptf6()

    local cartouche = {}
    local surface = {
        request_to_generate_chunks = function () end,
        force_generate_chunk_requests = function () end,
        create_entity = function (prototype)
            if prototype.name ~= "se-cartouche-a" then
                local t = prototype.name:sub(12)
                local p = t:find('-')
                if p ~= nil then
                    t = t:sub(1, p-1)
                end
                local glyph = tonumber(t)
                table.insert(cartouche, glyph)
            end
            return {}
        end,
    }
    Ancient.place_cartouche_a(surface, target[1], { x = 0, y = 0 })
    local found = true
    for i = 1, 12 do
        if cartouche[i] ~= target[i] then
            found = false
        end
    end
    if found then
        local s = global.gds
        local parts = {}
        for i = 1, 8 do
            local p = s:find('|')
            local t
            if p ~= nil then
                t = s:sub(1, p-1)
                s = s:sub(p+1)
            else
                t = s
                s = nil
            end
            table.insert(parts, tonumber(t))
        end
        print(serpent.block(parts))
    end

    -- reset for next iteration
    global.ftg = nil
    global.gco = nil
    global.gds = nil
    global.gtf = nil
    global.gtt = nil
    global.hcoord = nil
    global.vgo = nil

    rng:next()
end

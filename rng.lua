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

function FactorioRNG:from_outputs(p, q, r)
    local x = bit32.lshift(bit32.bor(
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0x9c390c30), bit32.band(q, 0xc39d6461), bit32.band(r, 0xe8da73e9))), 0),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0x23751c21), bit32.band(q, 0x987154b9), bit32.band(r, 0x5a096b81))), 1),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0xc9b7cca2), bit32.band(q, 0xe25205b8), bit32.band(r, 0xfaecfe49))), 2),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0x401883b7), bit32.band(q, 0x402010a8), bit32.band(r, 0x4a82bf02))), 3),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0x28e82ae7), bit32.band(q, 0x328f5a69), bit32.band(r, 0x50df408a))), 4),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0xa1504ab5), bit32.band(q, 0xc30179b9), bit32.band(r, 0xc85d2ae1))), 5),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0x35a00934), bit32.band(q, 0x280a5e38), bit32.band(r, 0x48acd649))), 6),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0xbb9405b1), bit32.band(q, 0x7b8d7a91), bit32.band(r, 0xd4d21cc3))), 7),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0x685a83e0), bit32.band(q, 0x390d0071), bit32.band(r, 0x6253e4a1))), 8),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0xa41696b4), bit32.band(q, 0x730f7091), bit32.band(r, 0xe661b908))), 9),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0xf66bb1a1), bit32.band(q, 0x78304700), bit32.band(r, 0xf8b5d70a))), 10),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0x172f56f4), bit32.band(q, 0xb07d3ad1), bit32.band(r, 0x808559c1))), 11),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0x8c558f70), bit32.band(q, 0x98d42559), bit32.band(r, 0x70cd20e1))), 12),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0x42fd54c6), bit32.band(q, 0xb53e1bc9), bit32.band(r, 0x06b57861))), 13),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0x4a5a66f5), bit32.band(q, 0x1c4a6c48), bit32.band(r, 0x9ec03360))), 14),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0xa7a0dd17), bit32.band(q, 0xe44c3551), bit32.band(r, 0x0c1e4649))), 15),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0x6752ae92), bit32.band(q, 0x0b0b1b18), bit32.band(r, 0xa21f2048))), 16),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0x2d655a00), bit32.band(q, 0xe1571d10), bit32.band(r, 0x302bd048))), 17),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0x938cb497), bit32.band(q, 0xf2883148), bit32.band(r, 0x8c378601))), 18),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0x1fef38c5), bit32.band(q, 0x4b784030), bit32.band(r, 0x58bcc6e0))), 19),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0x61618c96), bit32.band(q, 0xc4306680), bit32.band(r, 0x628afd88))), 20),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0xd2bc37a0), bit32.band(q, 0x712928c1), bit32.band(r, 0x56a52b63))), 21),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0xf2b69067), bit32.band(q, 0x556e4199), bit32.band(r, 0x307478a2))), 22),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0x6b9af1f2), bit32.band(q, 0xd48f7d80), bit32.band(r, 0x820629c2))), 23),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0x92112140), bit32.band(q, 0xe39f5f28), bit32.band(r, 0x28d4b700))), 24),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0xa846d091), bit32.band(q, 0x2e217978), bit32.band(r, 0x8cc702c1))), 25),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0x71e9e787), bit32.band(q, 0xe9951dd9), bit32.band(r, 0xf0b659a0))), 26),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0xd81cf814), bit32.band(q, 0x46ed72f0), bit32.band(r, 0x322f3c28))), 27),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0x0935d6f1), bit32.band(q, 0x6abf2960), bit32.band(r, 0x9e246760))), 28),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0xe6045581), bit32.band(q, 0x368f4058), bit32.band(r, 0x7ca1820a))), 29),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0xdddda052), bit32.band(q, 0x38b43709), bit32.band(r, 0xc6e325aa))), 30)), 1)

    local y = bit32.lshift(bit32.bor(
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0x9b773f1a), bit32.band(q, 0xec1d4f59), bit32.band(r, 0x26eb6a4a))), 0),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0x8d711bc0), bit32.band(q, 0xa8136ba8), bit32.band(r, 0x882c7fe3))), 1),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0x4db6a37c), bit32.band(q, 0x73a87190), bit32.band(r, 0xe42667e9))), 2),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0x43f81d1d), bit32.band(q, 0x11643799), bit32.band(r, 0x065a6629))), 3),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0xe4fc5409), bit32.band(q, 0x376d26f9), bit32.band(r, 0x1a8e600a))), 4),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0x105dbdf0), bit32.band(q, 0xa0bf7de8), bit32.band(r, 0x3e5a2e69))), 5),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0x552ef4b1), bit32.band(q, 0xeb820768), bit32.band(r, 0x86f4c5ca))), 6),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0xa669299d), bit32.band(q, 0xdbf575a0), bit32.band(r, 0xc63ec34a))), 7),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0x8bafeb86), bit32.band(q, 0x1b7b7c71), bit32.band(r, 0xe0dc4403))), 8),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0x166f990b), bit32.band(q, 0x0ea71c41), bit32.band(r, 0x04e8cf80))), 9),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0x3d9602bf), bit32.band(q, 0x4fee5188), bit32.band(r, 0x42e7a621))), 10),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0x3bd13ee7), bit32.band(q, 0x3b5a5400), bit32.band(r, 0x589ba6ab))), 11),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0xedc33544), bit32.band(q, 0x27f804e8), bit32.band(r, 0xf4b50c48))), 12),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0x4fdc9a29), bit32.band(q, 0x820b3961), bit32.band(r, 0x2c29bd88))), 13),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0x3c1e6334), bit32.band(q, 0xc3631829), bit32.band(r, 0x9852b76a))), 14),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0x6541363e), bit32.band(q, 0xd8972228), bit32.band(r, 0xb0441f2b))), 15),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0x3a9818dc), bit32.band(q, 0x83833fe0), bit32.band(r, 0x602b23e8))), 16),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0xbc76312f), bit32.band(q, 0x372074a8), bit32.band(r, 0x2c366141))), 17),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0xc80d7d45), bit32.band(q, 0x6bd30d98), bit32.band(r, 0x984d9b01))), 18),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0xefc14133), bit32.band(q, 0x30b112f9), bit32.band(r, 0x0a501a68))), 19),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0xb0bc7c88), bit32.band(q, 0xeb8e7f21), bit32.band(r, 0xd49b7e82))), 20),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0x27655d45), bit32.band(q, 0xa6323188), bit32.band(r, 0x167e5c0a))), 21),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0xcd39e54e), bit32.band(q, 0x06970271), bit32.band(r, 0xc0956fca))), 22),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0xb7b9271d), bit32.band(q, 0x20ba2660), bit32.band(r, 0xca857d23))), 23),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0xa6321e8f), bit32.band(q, 0xe2ea2fc0), bit32.band(r, 0x64bc7203))), 24),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0x36667f9a), bit32.band(q, 0xccc40571), bit32.band(r, 0x023fc601))), 25),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0x5f428412), bit32.band(q, 0xd1e251f8), bit32.band(r, 0x5ca11ac0))), 26),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0xb955d9ef), bit32.band(q, 0x4e3d7f89), bit32.band(r, 0x1e0e39e1))), 27),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0x2f2d2833), bit32.band(q, 0xf5157210), bit32.band(r, 0x7c7f4600))), 28)), 3)

    local z = bit32.lshift(bit32.bor(
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0x5464e0d4), bit32.band(q, 0xfa6e1858), bit32.band(r, 0xfa0153cb))), 0),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0xdf55660f), bit32.band(q, 0x5dde4349), bit32.band(r, 0x58823c82))), 1),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0x55b7bcff), bit32.band(q, 0x965a6159), bit32.band(r, 0x3a1ae8e9))), 2),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0xb41ba15e), bit32.band(q, 0x711b5f89), bit32.band(r, 0xa214a221))), 3),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0x581a34b0), bit32.band(q, 0x05413931), bit32.band(r, 0xe6272141))), 4),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0x30f80077), bit32.band(q, 0xe8661089), bit32.band(r, 0xae617e02))), 5),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0xeca4dcf8), bit32.band(q, 0x01820299), bit32.band(r, 0x44fcd743))), 6),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0x8e8746d7), bit32.band(q, 0xb4381529), bit32.band(r, 0x14c780e2))), 7),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0x8a6b4bdc), bit32.band(q, 0x0d9c1969), bit32.band(r, 0x628a4f82))), 8),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0xc49ebb98), bit32.band(q, 0x37ab2a80), bit32.band(r, 0xf40937ca))), 9),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0xabfc6c9d), bit32.band(q, 0xe6240f78), bit32.band(r, 0xe62c6ea3))), 10),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0xbc7fc200), bit32.band(q, 0x751c4fe0), bit32.band(r, 0x2e06fae0))), 11),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0x51da8e99), bit32.band(q, 0x824262b1), bit32.band(r, 0x3ea8b048))), 12),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0x5eadb748), bit32.band(q, 0x91314969), bit32.band(r, 0x6ea3dca2))), 13),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0x9adfb7f9), bit32.band(q, 0x421d4521), bit32.band(r, 0x5663ae81))), 14),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0x6839f41f), bit32.band(q, 0xed550740), bit32.band(r, 0xeca468c0))), 15),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0x18999d57), bit32.band(q, 0xd5d73ff8), bit32.band(r, 0x84eea808))), 16),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0xee76b080), bit32.band(q, 0xb0637730), bit32.band(r, 0x6087f58a))), 17),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0x0d935305), bit32.band(q, 0xe7bc7af9), bit32.band(r, 0x2894aa88))), 18),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0x61b8df77), bit32.band(q, 0xc16271b0), bit32.band(r, 0xeef86f88))), 19),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0x3923ae84), bit32.band(q, 0x6e3a05c9), bit32.band(r, 0x000ed908))), 20),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0x114b333b), bit32.band(q, 0xc9d14259), bit32.band(r, 0x16271e48))), 21),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0x23a07853), bit32.band(q, 0x384b0879), bit32.band(r, 0xf4c8d5c2))), 22),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0xf691a1ba), bit32.band(q, 0x4d541099), bit32.band(r, 0xece0b581))), 23),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0x9df30ee1), bit32.band(q, 0xd9595001), bit32.band(r, 0xa69be4e8))), 24),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0xb9250c01), bit32.band(q, 0xc01025c0), bit32.band(r, 0x640e5988))), 25),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0x2efa9dca), bit32.band(q, 0x42a64a49), bit32.band(r, 0x50f96f80))), 26),
        bit32.lshift(bit32.parity(bit32.bxor(bit32.band(p, 0x69ab9179), bit32.band(q, 0x20df13f1), bit32.band(r, 0x5e6045a3))), 27)), 4)

    local o = FactorioRNG:new{x = x, y = y, z = z}
    o:next()
    o:next()
    o:next()
    return o
end

function bit32.bitrev(x)
    local r = x
    r = bit32.bxor(bit32.lshift(bit32.band(p, 0x0000ffff), 16), bit32.rshift(bit32.band(p, 0xffff0000), 16))
    r = bit32.bxor(bit32.lshift(bit32.band(p, 0x00ff00ff),  8), bit32.rshift(bit32.band(x, 0xff00ff00),  8))
    r = bit32.bxor(bit32.lshift(bit32.band(p, 0x0f0f0f0f),  4), bit32.rshift(bit32.band(x, 0xf0f0f0f0),  4))
    r = bit32.bxor(bit32.lshift(bit32.band(p, 0x33333333),  2), bit32.rshift(bit32.band(x, 0xcccccccc),  2))
    r = bit32.bxor(bit32.lshift(bit32.band(p, 0x55555555),  1), bit32.rshift(bit32.band(x, 0xaaaaaaaa),  1))
    return r
end

function bit32.parity(x)
    local r = x
    r = bit32.bxor(r, bit32.rshift(r, 16))
    r = bit32.bxor(r, bit32.rshift(r,  8))
    r = bit32.bxor(r, bit32.rshift(r,  4))
    r = bit32.bxor(r, bit32.rshift(r,  2))
    r = bit32.bxor(r, bit32.rshift(r,  1))
    return bit32.band(r, 0x1)
end

FactorioRNG.global_seed = 341

game = {}
game.create_random_generator = function (seed)
    if seed == nil then
        seed = FactorioRNG.global_seed
    end
    if seed < 341 then
        seed = 341
    end
    return FactorioRNG:new{ x = seed, y = seed, z = seed }
end

local p = 65416031
local q = 3190733324
local r = 795914073
local S = FactorioRNG:from_outputs(p, q, r)

local steps = 0
local seed = nil
while true do
    if bit32.rshift(bit32.bxor(S.x, S.y), 3) == 0 and bit32.rshift(bit32.bxor(S.x, S.z), 4) == 0 then
        seed = S.x
        break
    end
    S:prev()
    steps = steps + 1
end

print("seed = " .. tostring(seed))
print("steps = " .. tostring(steps))

local bit32_extra = {}

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

return bit32_extra

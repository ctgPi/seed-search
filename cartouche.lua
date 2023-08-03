local base64 = dofile('base64.lua')
local zip = require('zip')
local libav = require('libav')

local FACTORIO_HOME = '/home/fabio/factorio/1.1.80/'

print([[
<!DOCTYPE html>
<meta name="viewport" content="width=640, user-scalable=no" />
<script>
]])
do
    local cannot_build_file = io.open(FACTORIO_HOME .. 'data/core/sound/cannot-build.ogg', 'rb')
    assert(cannot_build_file)
    local cannot_build_data = cannot_build_file:read('*a')
    cannot_build_file:close()
    print([[const invalidCommandAudio = new Audio('data:audio/mpeg;base64,]] .. base64.encode(libav.ogg_to_mp3(cannot_build_data)) .. [[');]])
end
print([[
]])
do
    local delete_item_file = io.open(FACTORIO_HOME .. 'data/core/sound/delete-item.ogg', 'rb')
    assert(delete_item_file)
    local delete_item_data = delete_item_file:read('*a')
    delete_item_file:close()
    print([[const clearGlyphAudio = new Audio('data:audio/mpeg;base64,]] .. base64.encode(libav.ogg_to_mp3(delete_item_data)) .. [[');]])
end
print([[
]])
do
    local build_small_file = io.open(FACTORIO_HOME .. 'data/core/sound/build-small.ogg', 'rb')
    assert(build_small_file)
    local build_small_data = build_small_file:read('*a')
    build_small_file:close()
    print([[const assignGlyphAudio = new Audio('data:audio/mpeg;base64,]] .. base64.encode(libav.ogg_to_mp3(build_small_data)) .. [[');]])
end
print([[
]])
do
    local copy_entity_file = io.open(FACTORIO_HOME .. 'data/core/sound/copy-entity.ogg', 'rb')
    assert(copy_entity_file)
    local copy_entity_data = copy_entity_file:read('*a')
    copy_entity_file:close()
    print([[const selectGlyphAudio = new Audio('data:audio/mpeg;base64,]] .. base64.encode(libav.ogg_to_mp3(copy_entity_data)) .. [[');]])
end
print([[
]])
do
    local clear_cursor_file = io.open(FACTORIO_HOME .. 'data/core/sound/clear-cursor.ogg', 'rb')
    assert(clear_cursor_file)
    local clear_cursor_data = clear_cursor_file:read('*a')
    clear_cursor_file:close()
    print([[const unselectGlyphAudio = new Audio('data:audio/mpeg;base64,]] .. base64.encode(libav.ogg_to_mp3(clear_cursor_data)) .. [[');]])
end
print([[
</script>
<style>
]])
do
    local se_graphics = zip.open(FACTORIO_HOME .. 'mods/space-exploration-graphics_0.6.14.zip')
    assert(se_graphics)

    print([[
cartouche {
    ]])
    do
        local cartouche_file = se_graphics:open('space-exploration-graphics/graphics/entity/cartouche/cartouche-a.png')
        assert(cartouche_file)
        local cartouche_data = cartouche_file:read('*a')
        cartouche_file:close()
        print([[    background-image: url('data:image/png;base64,]] .. base64.encode(cartouche_data) .. [[');]])
    end
    print([[
}

cartouche glyph[data-value], palette glyph {
    ]])
    do
        local glyphs_file = se_graphics:open('space-exploration-graphics/graphics/entity/cartouche/glyphs-a-metal.png')
        assert(glyphs_file)
        local glyphs_data = glyphs_file:read('*a')
        glyphs_file:close()
        print([[    background-image: url('data:image/png;base64,]] .. base64.encode(glyphs_data) .. [[');]])
    end
    print([[
    }
    ]])

    se_graphics:close()
end
print([[

@font-face {
    font-family: 'Titillium Web';
    font-style: normal;
    font-weight: 400;
]])
do
    local font_file = io.open(FACTORIO_HOME .. 'data/core/fonts/TitilliumWeb-Regular.ttf', 'rb')
    assert(font_file)
    local font_data = font_file:read('*a')
    font_file:close()
    print([[    src: url('data:font/ttf;base64,]] .. base64.encode(font_data) .. [[') format('truetype');]])
end
print([[
}

* {
    box-sizing: border-box;
    user-select: none;
    -webkit-touch-callout: none;
}

body {
    margin: 0 auto;
    padding: 0;
    font-family: 'Titillium Web', sans-serif;
    font-size: 16px;
    line-height: 22px;
}

input, button {
    font-family: 'Titillium Web', sans-serif;
    font-size: 16px;
    line-height: 22px;
}

input {
    height: 22px;
    border: 1px #999 solid;
    border-radius: 2px;
    padding: 0 0.5ex;
    margin: 0 0.5ex;
}

input::-webkit-outer-spin-button,
input::-webkit-inner-spin-button {
    display: none;
}

button {
    padding: 0;
    border: 1px #999 solid;
    padding: 0 0.5ex;
    margin: 0 0.5ex;
}

label {
    display: inline-block;
    text-align: right;
    width: 10ex;
}

#seed {
    width: 10ch;
    box-sizing: content-box;
}

palette {
    display: flex;
    flex-wrap: wrap;
    justify-content: center;

    width: 640px;
    height: 660px;
    margin: 0 auto;
}

palette glyph {
    display: block;
    background-size: 768px;
    width: 96px;
    height: 66px;
    border-radius: 48px / 33px;
}

palette glyph.used {
    filter: saturate(0%) opacity(50%);
}

palette glyph.selected, palette glyph.dragged {
    box-shadow: inset 0 0 20px #00f;
}

palette glyph.valid-target, palette glyph.used.valid-target {
    box-shadow: inset 0 0 20px #f00;
    filter: none;
}
]])
for i = 1, 60 do
    print([[palette glyph[data-value="]] .. (i) .. [["] { background-position: ]] .. (-96 * ((i-1) % 8)) .. [[px ]] .. (-72 * math.floor((i-1) / 8)) .. [[px; }]])
end
print([[
cartouche {
    width: 576px;
    height: 410px;
    margin: 0 auto;
    display: block;
    position: relative;
    background-size: 100%;
}

cartouche glyph {
    position: absolute;
    display: block;
}

cartouche glyph[data-value] {
    background-size: 512px;
}

cartouche glyph {
    width: 64px;
    height: 45px;
    border-radius: 32px / 22.5px;
}

cartouche glyph.selected, cartouche glyph.dragged {
    box-shadow: inset 0 0 20px #00f;
}

cartouche glyph.valid-target {
    box-shadow: inset 0 0 20px #f00;
}

cartouche glyph[data-position="0"] {
    top: 155px;
    left: 224px;
    width: 128px;
    height: 90px;
    border-radius: 64px / 45px;
    background-size: 1024px;
}
]])

for i = 1, 11 do
    local cx = 200
    local cy = 288
    local sx = 144
    local sy = 202
    local dx = -22
    local dy = -32
    local alpha = 2*math.pi/11
    local x = cx + sx * math.cos((i-1) * alpha) + dx
    local y = cy + sy * math.sin((i-1) * alpha) + dy
    x = x + 6755399441055744.0
    x = x - 6755399441055744.0
    y = y + 6755399441055744.0
    y = y - 6755399441055744.0
    print([[cartouche glyph[data-position="]] .. (i) .. [["] { top: ]] .. (x) .. [[px; left: ]] .. (y) .. [[px; }]])
end

for i = 1, 64 do
    print([[cartouche glyph[data-value="]] .. (i) .. [["] { background-position: ]] .. (-64 * ((i-1) % 8)) .. [[px ]] .. (-48 * math.floor((i-1) / 8)) .. [[px; }]])
end
for i = 1, 64 do
    print([[cartouche glyph[data-position="0"][data-value="]] .. i .. [["] { background-position: ]] .. (-128 * ((i-1) % 8)) .. [[px ]] .. (-96 * math.floor((i-1) / 8)) .. [[px; }]])
end

print([[</style>]])

print([[
<section style="display: flex; justify-content: center; margin-bottom: 12px; margin-top: 12px;">
<label style="flex: none; margin-right: 0.5ex;" for="seed">Seed:</label><input style="flex: none;" type="number" id="seed" value="8791912">
<button>Solve</button>
</section>
]])
print([[
<cartouche>
    <glyph data-position="0"></glyph>
    <glyph data-position="1"></glyph>
    <glyph data-position="2"></glyph>
    <glyph data-position="3"></glyph>
    <glyph data-position="4"></glyph>
    <glyph data-position="5"></glyph>
    <glyph data-position="6"></glyph>
    <glyph data-position="7"></glyph>
    <glyph data-position="8"></glyph>
    <glyph data-position="9"></glyph>
    <glyph data-position="10"></glyph>
    <glyph data-position="11"></glyph>
</cartouche>
]])

print([[<palette>]])
for i = 1, 60 do
    print([[    <glyph data-value=]] .. (i) .. [[></glyph>]])
end
print([[</palette>]])

print([[
<script>
]])
do
    local script_file = io.open('cartouche.js', 'rb')
    assert(script_file)
    local script_data = script_file:read('*a')
    script_file:close()
    print(script_data)
end
print([[
</script>
]])

local se_data = {}

local function invert_table(t)
    local r = {}
    for k, v in pairs(t) do
        assert(r[v] == nil)
        r[v] = k
    end
    return r
end

se_data.RESOURCE = {
    "coal", "stone", "iron-ore", "copper-ore", "crude-oil", "uranium-ore",
    "se-vulcanite", "se-cryonite", "se-vitamelange", "se-holmium-ore", "se-beryllium-ore", "se-iridium-ore",
    "se-water-ice", "se-methane-ice", "se-naquium-ore"}

se_data.T_ZONE_TYPE = { "planet", "moon", "asteroid-field" }
se_data.T_ZONE_TYPE_index = invert_table(se_data.T_ZONE_TYPE)

se_data.T_T2_RESOURCE = { 0x0000, 0x0100, 0x0200, 0x0400, 0x0800 }
se_data.T_T2_RESOURCE_index = invert_table(se_data.T_T2_RESOURCE)

se_data.T_TEMPERATURE = Universe.temperature_tags
se_data.T_TEMPERATURE_index = invert_table(se_data.T_TEMPERATURE)

se_data.T_WATER = Universe.water_tags
se_data.T_WATER_index = invert_table(se_data.T_WATER)

se_data.T_MOISTURE = Universe.moisture_tags
se_data.T_MOISTURE_index = invert_table(se_data.T_MOISTURE)

se_data.T_TREES = Universe.trees_tags
se_data.T_TREES_index = invert_table(se_data.T_TREES)

se_data.T_AUX = Universe.aux_tags
se_data.T_AUX_index = invert_table(se_data.T_AUX)

se_data.T_CLIFF = Universe.cliff_tags
se_data.T_CLIFF_index = invert_table(se_data.T_CLIFF)

se_data.T_ENEMY = Universe.enemy_tags
se_data.T_ENEMY_index = invert_table(se_data.T_ENEMY)

se_data.NAME = {}
do
    local name_file = io.open('NAMES.txt', 'r')
    assert(name_file)
    for name in name_file:lines("*l") do
        table.insert(se_data.NAME, name)
    end
    name_file:close()
end
se_data.NAME_index = invert_table(se_data.NAME)

return se_data

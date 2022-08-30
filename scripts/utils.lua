-- Copyright (c) 2022 Branko Majic
-- Provided under MIT license. See LICENSE for details.


local utils = {}


--- Parses list of space-separated surface names specified by a player.
--
-- @param names string Space-separated list of surface names. Specify name "all" to include all game surfaces.
-- @param aliases {string = string} Additional alias names to accept for surface names. Maps aliases to surface names.
-- @param player LuaPlayer? Player that should be shown encountered parsing errors.
--
-- @return {LuaSurface}|nil List of parsed surfaces, or nil if some of the passed-in names are invalid.
--
function utils.parse_list_of_surfaces(names, aliases, player)
    local surfaces = {}
    local errors = {}

    for token in string.gmatch(names, "[^%s]+") do
        local name = aliases[token] or token

        if string.lower(name) == "all" then
            for _, surface in pairs(game.surfaces) do
                table.insert(surfaces, surface)
            end
        elseif game.surfaces[name] then
            table.insert(surfaces, game.surfaces[name])
        elseif player then
            player.print({"error.br-invalid-parameter-surface", name})
            return nil
        end
    end

    -- Remove duplicate surfaces.
    local deduplicated_surfaces = {}
    local seen = {}
    for _, surface in pairs(surfaces) do
        if not seen[surface.name] then
            table.insert(deduplicated_surfaces, surface)
            seen[surface.name] = true
        end
    end

    return deduplicated_surfaces
end


return utils

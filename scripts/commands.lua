-- Copyright (c) 2022 Branko Majic
-- Provided under MIT license. See LICENSE for details.


local remover = require("scripts.remover")


local commands = {}


commands.remove_biters = {}
commands.remove_biters.name = "remove-biters"
commands.remove_biters.help = [[
Removes all hostile nests, worms, and biters from listed surfaces.
Usage:
    /remove-biters [SURFACE]...
Parameters:
    SURFACE
        List of (space-separated) surfaces from which to remove hostile nests, worms, and biters. For currently visible
        surface, specify "current" as surface name. To remove biters from every single surface in the game, pass-in
        "all" as surface name.

]]


--- Parses the passed-in player parameters and invokes removal of hostile biters.
--
-- @param command_data CustomCommandData Command data structure passed-in by the game engine.
--
commands.remove_biters.func = function(command_data)
    local player = game.players[command_data.player_index]

    -- Administrator privileges are required to run the command.
    if not player.admin then
        player.print({"error.br-administrator-privileges-required"})
        return
    end

    -- Show help if no parameters were specified.
    if not command_data.parameter then
        player.print(commands.remove_biters.help)
        return
    end

    -- Parse the passed-in list of surfaces.
    local surfaces = {}
    for token in string.gmatch(command_data.parameter, "[^%s]+") do
        if string.lower(token) == "current" then
            table.insert(surfaces, player.surface)
        elseif string.lower(token) == "all" then
            for _, surface in pairs(game.surfaces) do
                table.insert(surfaces, surface)
            end
        elseif game.surfaces[token] then
            table.insert(surfaces, game.surfaces[token])
        else
            player.print({"error.br-invalid-parameter-surface", token})
            return
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

    remover.remove_hostile_biters(player.force, deduplicated_surfaces)
end


return commands

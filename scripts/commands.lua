-- Copyright (c) 2022 Branko Majic
-- Provided under MIT license. See LICENSE for details.


local remover = require("scripts.remover")
local utils = require("scripts.utils")


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

    local surfaces = utils.parse_list_of_surfaces(command_data.parameter, {current=player.surface.name}, player)
    if surfaces then
        remover.remove_hostile_biters(player.force, surfaces)
    end
end


commands.disable_biter_base_generation = {}
commands.disable_biter_base_generation.name = "disable-biter-base-generation"
commands.disable_biter_base_generation.help = [[
Disables biter base generation on newly generated chunks.
Usage:
    /disable-biter-base-generation [SURFACE]
Parameters:
    SURFACE
        List of (space-separated) surfaces where biter base generation should be disabled. For currently visible
        surface, specify "current" as surface name. To disable biter base generation on every single surface in the
        game, pass-in "all" as surface name.
]]


--- Parses the passed-in player parameters and invokes disabling of biter base generation.
--
-- @param command_data CustomCommandData Command data structure passed-in by the game engine.
--
commands.disable_biter_base_generation.func = function(command_data)
    local player = game.players[command_data.player_index]

    -- Administrator privileges are required to run the command.
    if not player.admin then
        player.print({"error.br-administrator-privileges-required"})
        return
    end

    -- Show help if no parameters were specified.
    if not command_data.parameter then
        player.print(commands.disable_biter_base_generation.help)
        return
    end

    local surfaces = utils.parse_list_of_surfaces(command_data.parameter, {current=player.surface.name}, player)
    if surfaces then
        remover.disable_biter_base_generation(surfaces)
    end
end


return commands
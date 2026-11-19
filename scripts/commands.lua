-- Copyright (c) 2022 Branko Majic
-- Provided under MIT license. See LICENSE for details.


local remover = require("scripts.remover")
local utils = require("scripts.utils")


local commands = {}


commands.remove_critters = {}
commands.remove_critters.name = "remove-critters"
commands.remove_critters.help = [[
Removes all hostile critters (nests, worms, biters, pentapods, demolishers) from listed surfaces.
Usage:
    /remove-critters [SURFACE]...
Parameters:
    SURFACE
        List of (space-separated) surfaces from which to remove hostile critters. For currently visible surface, specify
        "current" as surface name. To remove critters from every single surface in the game, pass-in "all" as surface
        name.
]]


--- Parses the passed-in player parameters and invokes removal of hostile critters.
--
-- @param command_data CustomCommandData Command data structure passed-in by the game engine.
--
commands.remove_critters.func = function(command_data)
    local player = game.players[command_data.player_index]

    -- Administrator privileges are required to run the command.
    if not player.admin then
        player.print({"error.br-administrator-privileges-required"})
        return
    end

    -- Show help if no parameters were specified.
    if not command_data.parameter then
        player.print(commands.remove_critters.help)
        return
    end

    local surfaces = utils.parse_list_of_surfaces(command_data.parameter, {current=player.surface.name}, player)
    if surfaces then
        remover.remove_hostile_critters(player.force, surfaces)
    end
end


commands.disable_critter_base_generation = {}
commands.disable_critter_base_generation.name = "disable-critter-base-generation"
commands.disable_critter_base_generation.help = [[
Disables critter base (biters/pentapods) and territory (demolishers) generation on newly generated chunks.
Usage:
    /disable-critter-base-generation [SURFACE]
Parameters:
    SURFACE
        List of (space-separated) surfaces where critter base and territory generation should be disabled. For currently
        visible surface, specify "current" as surface name. To disable critter base and territory generation on every
        single surface in the game, pass-in "all" as surface name.
]]


--- Parses the passed-in player parameters and invokes disabling of critter base generation.
--
-- @param command_data CustomCommandData Command data structure passed-in by the game engine.
--
commands.disable_critter_base_generation.func = function(command_data)
    local player = game.players[command_data.player_index]

    -- Administrator privileges are required to run the command.
    if not player.admin then
        player.print({"error.br-administrator-privileges-required"})
        return
    end

    -- Show help if no parameters were specified.
    if not command_data.parameter then
        player.print(commands.disable_critter_base_generation.help)
        return
    end

    local surfaces = utils.parse_list_of_surfaces(command_data.parameter, {current=player.surface.name}, player)
    if surfaces then
        remover.disable_critter_base_generation(surfaces)
    end
end


commands.enable_critter_base_generation = {}
commands.enable_critter_base_generation.name = "enable-critter-base-generation"
commands.enable_critter_base_generation.help = [[
Enables critter base (biters/pentapods) and territory (demolishers) generation on newly generated chunks.
Usage:
    /enable-critter-base-generation [SURFACE]
Parameters:
    SURFACE
        List of (space-separated) surfaces where critter base and territory generation should be enabled. For currently
        visible surface, specify "current" as surface name. To enable critter base and territory generation on every
        single surface in the game, pass-in "all" as surface name.
]]


--- Parses the passed-in player parameters and invokes enabling of critter base and territory generation.
--
-- @param command_data CustomCommandData Command data structure passed-in by the game engine.
--
commands.enable_critter_base_generation.func = function(command_data)
    local player = game.players[command_data.player_index]

    -- Administrator privileges are required to run the command.
    if not player.admin then
        player.print({"error.br-administrator-privileges-required"})
        return
    end

    -- Show help if no parameters were specified.
    if not command_data.parameter then
        player.print(commands.enable_critter_base_generation.help)
        return
    end

    local surfaces = utils.parse_list_of_surfaces(command_data.parameter, {current=player.surface.name}, player)
    if surfaces then
        remover.enable_critter_base_generation(surfaces)
    end
end


commands.disable_pollution = {}
commands.disable_pollution.name = "disable-pollution"
commands.disable_pollution.help = [[
Disables all pollution.
Usage:
    /disable-pollution
]]


--- Parses the passed-in player parameters and disables pollution.
--
-- @param command_data CustomCommandData Command data structure passed-in by the game engine.
--
commands.disable_pollution.func = function(command_data)
    local player = game.players[command_data.player_index]

    -- Administrator privileges are required to run the command.
    if not player.admin then
        player.print({"error.br-administrator-privileges-required"})
        return
    end

    remover.disable_pollution()
end


commands.enable_pollution = {}
commands.enable_pollution.name = "enable-pollution"
commands.enable_pollution.help = [[
Enables pollution.
Usage:
    /enable-pollution
]]


--- Parses the passed-in player parameters and enables pollution.
--
-- @param command_data CustomCommandData Command data structure passed-in by the game engine.
--
commands.enable_pollution.func = function(command_data)
    local player = game.players[command_data.player_index]

    -- Administrator privileges are required to run the command.
    if not player.admin then
        player.print({"error.br-administrator-privileges-required"})
        return
    end

    remover.enable_pollution()
end


commands.clear_pollution = {}
commands.clear_pollution.name = "clear-pollution"
commands.clear_pollution.help = [[
Clears all pollution on listed surfaces. Does not disable pollution (this can only be done globally).
Usage:
    /clear-pollution [SURFACE]
Parameters:
    SURFACE
        List of (space-separated) surfaces on which to clear pollution. For currently visible surface, specify "current"
        as surface name. To clear pllution on every single surface in the game, pass-in "all" as surface name.
]]


--- Parses the passed-in player parameters and clears pollution on surfaces.
--
-- @param command_data CustomCommandData Command data structure passed-in by the game engine.
--
commands.clear_pollution.func = function(command_data)
    local player = game.players[command_data.player_index]

    -- Administrator privileges are required to run the command.
    if not player.admin then
        player.print({"error.br-administrator-privileges-required"})
        return
    end

    -- Show help if no parameters were specified.
    if not command_data.parameter then
        player.print(commands.clear_pollution.help)
        return
    end

    local surfaces = utils.parse_list_of_surfaces(command_data.parameter, {current=player.surface.name}, player)
    if surfaces then
        remover.clear_pollution(surfaces)
    end
end


return commands

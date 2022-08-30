-- Copyright (c) 2022 Branko Majic
-- Provided under MIT license. See LICENSE for details.

local remover = {}


--- Removes hostile biters, spawners, and worms from the passed-in surfaces.
--
-- @param force LuaForce Friendly force for which to find all hostile forces.
-- @param surfaces {LuaSurface} List of surfaces from which to remove the entities.
--
function remover.remove_hostile_biters(force, surfaces)
    local hostile_forces = {}

    -- Create a list of forces that are hostile to the passed-in force.
    for _, game_force in pairs(game.forces) do
        if force.is_enemy(game_force) then
            table.insert(hostile_forces, game_force)
        end
    end

    -- Iterate over surfaces, and for each hostile force remove the (most likely) biter/spitter units, spawners, and
    -- worm turrets.
    for _, surface in pairs(surfaces) do
        for _, hostile_force in pairs(hostile_forces) do
            for _, entity in pairs(surface.find_entities_filtered({force = hostile_force})) do
                if entity.prototype.type == "unit" and
                   (string.find(entity.name, "biter") or string.find(entity.name, "spitter")) then
                   entity.destroy()
                elseif entity.prototype.type == "unit-spawner" then
                    entity.destroy()
                elseif entity.prototype.type == "turret" and string.find(entity.name, "worm") then
                    entity.destroy()
                end
            end
        end
    end

    -- Output informative message to all players.
    local surface_names = {}
    for _, surface in pairs(surfaces) do
        table.insert(surface_names, surface.name)
    end
    table.sort(surface_names)
    game.print({"info.br-biters-removed", force.name, table.concat(surface_names, ", ")})
end


--- Disables biter base generation on passed-in surfaces.
--
-- @param surfaces {LuaSurface} List of surfaces where biter base generation should be disabled.
--
function remover.disable_biter_base_generation(surfaces)
    -- Initialise the structure for backing-up existing values.
    global.biter_base_generation_size = global.biter_base_generation_size or {}

    -- Drop biter base generation from map generation settings.
    for _, surface in pairs(surfaces) do
        local map_gen_settings = surface.map_gen_settings

        -- Store the original values for eventual re-enabling.
        if global.biter_base_generation_size[surface.name] ~= 0 then
            global.biter_base_generation_size[surface.name] = map_gen_settings.autoplace_controls["enemy-base"].size
        end

        map_gen_settings.autoplace_controls["enemy-base"].size = 0

        surface.map_gen_settings = map_gen_settings
    end

    -- Output informative message to all players.
    local surface_names = {}
    for _, surface in pairs(surfaces) do
        table.insert(surface_names, surface.name)
    end
    table.sort(surface_names)
    game.print({"info.br-biter-base-generation-disabled", table.concat(surface_names, ", ")})
end


--- Enables biter base generation on passed-in surfaces.
--
-- @param surfaces {LuaSurface} List of surfaces where biter base generation should be enabled.
--
function remover.enable_biter_base_generation(surfaces)

    for _, surface in pairs(surfaces) do
        local map_gen_settings = surface.map_gen_settings

        local biter_base_generation_size =
            global.biter_base_generation_size and global.biter_base_generation_size[surface.name] or
            game.default_map_gen_settings.autoplace_controls["enemy-base"].size

        map_gen_settings.autoplace_controls["enemy-base"].size = biter_base_generation_size

        surface.map_gen_settings = map_gen_settings
    end

    -- Output informative message to all players.
    local surface_names = {}
    for _, surface in pairs(surfaces) do
        table.insert(surface_names, surface.name)
    end
    table.sort(surface_names)
    game.print({"info.br-biter-base-generation-enabled", table.concat(surface_names, ", ")})
end


return remover

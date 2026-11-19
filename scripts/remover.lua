-- Copyright (c) 2022 Branko Majic
-- Provided under MIT license. See LICENSE for details.


local utils = require("scripts.utils")


local remover = {}


--- Removes hostile critters from the passed-in surfaces.
--
-- @param force LuaForce Friendly force for which to find all hostile forces.
-- @param surfaces {LuaSurface} List of surfaces from which to remove the entities.
--
function remover.remove_hostile_critters(force, surfaces)
    local hostile_forces = {}

    -- Create a list of forces that are hostile to the passed-in force.
    for _, game_force in pairs(game.forces) do
        if force.is_enemy(game_force) then
            table.insert(hostile_forces, game_force)
        end
    end

    -- Iterate over surfaces, and for each hostile force remove all critters (biters, worms, spawners, pentapods,
    -- demolishers etc).
    for _, surface in pairs(surfaces) do
        for _, hostile_force in pairs(hostile_forces) do
            for _, entity in pairs(surface.find_entities_filtered({force = hostile_force})) do
                if not entity.valid then --luacheck: ignore 542
                    -- Some entities may become invalidated in the middle of traversal (such as pentapods).
                elseif entity.prototype.type == "unit" and
                    (
                        string.find(entity.name, "biter") or
                        string.find(entity.name, "spitter") or
                        string.find(entity.name, "pentapod")
                    ) then
                    entity.destroy()
                elseif entity.prototype.type == "spider-unit" and string.find(entity.name, "pentapod") then
                    entity.destroy()
                elseif entity.prototype.type == "unit-spawner" then
                    entity.destroy()
                elseif entity.prototype.type == "turret" and string.find(entity.name, "worm") then
                    entity.destroy()
                end
            end
        end

        -- Demolishers are not guaranteed to exist as entities if containing chunks have not been generated, so we have
        -- to process them separately from "regular" entities.
        for _, unit in pairs(surface.get_segmented_units()) do
            if string.find(unit.prototype.name, "demolisher") then
                unit.destroy()
            end
        end
    end

    -- Output informative message to all players.
    local surface_names = {}
    for _, surface in pairs(surfaces) do
        table.insert(surface_names, surface.name)
    end
    table.sort(surface_names)
    game.print({"info.br-critters-removed", force.name, table.concat(surface_names, ", ")})
end


--- Disables critter base generation on passed-in surfaces.
--
-- @param surfaces {LuaSurface} List of surfaces where critter base generation should be disabled.
--
function remover.disable_critter_base_generation(surfaces)
    -- Initialise the structure for backing-up existing values.
    storage.biter_base_generation_size = storage.biter_base_generation_size or {}
    storage.pentapod_base_generation_size = storage.pentapod_base_generation_size or {}
    storage.territory_settings = storage.territory_settings or {}

    -- List of surfaces that have been processed, used for informing players.
    local processed_surfaces = {}

    -- Drop critter base generation from map generation settings.
    for _, surface in pairs(surfaces) do
        local map_gen_settings = surface.map_gen_settings

        -- Biter generation.
        if map_gen_settings.autoplace_controls and map_gen_settings.autoplace_controls["enemy-base"] then

            -- Keep track of original values.
            if storage.biter_base_generation_size[surface.name] ~= 0 then
                storage.biter_base_generation_size[surface.name] = map_gen_settings.autoplace_controls["enemy-base"].size -- luacheck: ignore 631
            end

            map_gen_settings.autoplace_controls["enemy-base"].size = 0

            surface.map_gen_settings = map_gen_settings

            processed_surfaces[surface.name] = true

        end

        -- Pentapod generation.
        if map_gen_settings.autoplace_controls and map_gen_settings.autoplace_controls["gleba_enemy_base"] then

            -- Keep track of original values.
            if storage.pentapod_base_generation_size[surface.name] ~= 0 then
                storage.pentapod_base_generation_size[surface.name] = map_gen_settings.autoplace_controls["gleba_enemy_base"].size  -- luacheck: ignore 631
            end

            map_gen_settings.autoplace_controls["gleba_enemy_base"].size = 0

            surface.map_gen_settings = map_gen_settings

            processed_surfaces[surface.name] = true
        end

        -- Demolisher generation.
        if map_gen_settings["territory_settings"] then

            -- Keep track of original values.
            if not storage.territory_settings[surface.name] then
                storage.territory_settings[surface.name] = map_gen_settings["territory_settings"]
            end

            map_gen_settings["territory_settings"] = nil

            surface.map_gen_settings = map_gen_settings

            processed_surfaces[surface.name] = true

        end

    end

    -- Output informative message to all players.
    local processed_surface_names = utils.get_table_keys(processed_surfaces)
    table.sort(processed_surface_names)
    game.print({"info.br-critter-base-generation-disabled", table.concat(processed_surface_names, ", ")})

end


--- Enables critter base generation on passed-in surfaces.
--
-- @param surfaces {LuaSurface} List of surfaces where critter base generation should be enabled.
--
function remover.enable_critter_base_generation(surfaces)

    -- List of surfaces that have been processed, used for informing players.
    local processed_surfaces = {}

    for _, surface in pairs(surfaces) do
        local map_gen_settings = surface.map_gen_settings

        -- Biter generation.
        if map_gen_settings.autoplace_controls and map_gen_settings.autoplace_controls["enemy-base"] then

            local biter_base_generation_size =
                storage.biter_base_generation_size and storage.biter_base_generation_size[surface.name] or
                game.default_map_gen_settings.autoplace_controls["enemy-base"].size

            map_gen_settings.autoplace_controls["enemy-base"].size = biter_base_generation_size

            surface.map_gen_settings = map_gen_settings

            processed_surfaces[surface.name] = true

        end

        -- Pentapod generation.
        if map_gen_settings.autoplace_controls and map_gen_settings.autoplace_controls["gleba_enemy_base"] then

            local pentapod_base_generation_size =
                storage.pentapod_base_generation_size and storage.pentapod_base_generation_size[surface.name] or
                game.default_map_gen_settings.autoplace_controls["gleba_enemy_base"].size

            map_gen_settings.autoplace_controls["gleba_enemy_base"].size = pentapod_base_generation_size

            surface.map_gen_settings = map_gen_settings

            processed_surfaces[surface.name] = true

        end

        -- @NOTE: Unable to fallback to default settings for demolisher territory
        --     Default is simply not exposed by the game, so all one can do is rely on stored settings. Perhaps one way
        --     to move forward would be to introduce another layer of fallback settings that have same values as default
        --     new game settings?
        -- Demolisher generation.
        if storage.territory_settings and storage.territory_settings[surface.name] then
            map_gen_settings.territory_settings = storage.territory_settings[surface.name]
            surface.map_gen_settings = map_gen_settings
            processed_surfaces[surface.name] = true
        end

    end

    -- Output informative message to all players.
    local processed_surface_names = utils.get_table_keys(processed_surfaces)
    table.sort(processed_surface_names)
    game.print({"info.br-critter-base-generation-enabled", table.concat(processed_surface_names, ", ")})
end


--- Globally disables pollution.
--
function remover.disable_pollution()
    game.map_settings.pollution.enabled = false
    game.print({"info.br-pollution-disabled"})
end


--- Globally enables pollution.
--
function remover.enable_pollution()
    game.map_settings.pollution.enabled = true
    game.print({"info.br-pollution-enabled"})
end


--- Clears pollution on all passed-in surfaces.
--
-- @param surface {LuaSurface} List of surfaces to clear the pollution on.
--
function remover.clear_pollution(surfaces)
    local surface_names = {}

    for _, surface in pairs(surfaces) do
        surface.clear_pollution()
        table.insert(surface_names, surface.name)
    end

    game.print({"info.br-pollution-cleared", table.concat(surface_names, ", ")})
end

return remover

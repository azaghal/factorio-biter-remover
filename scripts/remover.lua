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
end


return remover

-- Copyright (c) 2022 Branko Majic
-- Provided under MIT license. See LICENSE for details.


local mod_commands = require("scripts.commands")


-- Command registration
-- ====================
for _, mod_command in pairs(mod_commands) do
    commands.add_command(mod_command.name, mod_command.help, mod_command.func)
end

-- Add a command to reset the mod's state (clear storage, remove added sprites, etc.), used for debugging.
commands.add_command("fusc-reset", "Reset mod state of Find Unfiltered Storage Chests.", function(command)
    -- Reset storage
    storage.entities_with_warning = {}
    storage.entity_warning_sprites = {}

    -- Clear all render objects (warning sprites) created by this mod
    rendering.clear(script.mod_name)

    game.print("[FUSC] Mod state has been reset.")
end)

-- Dumps information about the mod's state, used for debugging.
-- TODO: Remove this command?
commands.add_command("fusc-debug", "Dump mod state of Find Unfiltered Storage Chests.", function(command)
    game.print("[FUSC] storage.entities_with_warning:")
    for key, value in pairs(storage.entities_with_warning) do
        game.print("[FUSC]   - " .. serpent.line(key) .. " -> " .. serpent.line(value))
    end

    game.print("[FUSC] storage.entity_warning_sprites:")
    for key, value in pairs(storage.entity_warning_sprites) do
        game.print("[FUSC]   - " .. serpent.line(key) .. " -> " .. serpent.line(value))
    end
end)

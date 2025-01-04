-- Add a debug command to reset the mod's state (clear storage, remove added sprites, etc).
commands.add_command(
    "fusc-reset",
    "Find Unfiltered Storage Chests: Reset mod state (for debugging.)",
    function(command)
        -- Reset storage
        storage.entities_with_warning = {}
        storage.entity_warning_sprites = {}

        -- Clear all render objects (warning sprites) created by this mod
        rendering.clear(script.mod_name)

        game.print("[FUSC] Mod state has been reset.")
    end
)

-- Add a debug command to update all storage containers on all surfaces
commands.add_command(
    "fusc-update",
    "Find Unfiltered Storage Chests: Update all storage containers (add/remove warnings).",
    function(command)
        update_all_logistic_containers()
        game.print("[FUSC] All logistic container were updated.")
    end
)

-- Add a debug command to dump information about the mod's state.
-- TODO: Remove this command?
commands.add_command(
    "fusc-debug",
    "Find Unfiltered Storage Chests: Dump mod state (for debugging).",
    function(command)
        game.print("[FUSC] DUMP: storage.entities_with_warning:")
        for key, value in pairs(storage.entities_with_warning) do
            game.print("[FUSC]   - " .. serpent.line(key) .. " -> " .. serpent.line(value))
        end

        game.print("[FUSC] DUMP: torage.entity_warning_sprites:")
        for key, value in pairs(storage.entity_warning_sprites) do
            game.print("[FUSC]   - " .. serpent.line(key) .. " -> " .. serpent.line(value))
        end
    end
)

-- Add a debug command to reset the mod's state (clear storage, remove added sprites, etc).
commands.add_command(
    "fusc-reset",
    "Find Unfiltered Storage Chests: Reset mod state (for debugging.)",
    function()
        -- Reset lists of entities
        storage.entities_with_warning = {}
        storage.acknowledged_entities = {}

        -- Clear all render objects (warning sprites) created by this mod
        clear_all_sprites()

        game.print("[Find Unfiltered Storage Chests] Mod state has been reset.")
    end
)

-- Add a debug command to update all storage containers on all surfaces
commands.add_command(
    "fusc-update",
    "Find Unfiltered Storage Chests: Update all storage containers (add/remove warnings).",
    function()
        -- Reset the state first (without removing acknowledgements), then find and update all logistic containers
        update_all_logistic_containers()

        game.print("[Find Unfiltered Storage Chests] All logistic containers were reset and updated.")
    end
)

-- Add a debug command to dump information about the mod's state.
-- (Debug tool, only uncomment when needed.)
--commands.add_command(
--    "fusc-debug",
--    "Find Unfiltered Storage Chests: Dump mod state (for debugging).",
--    function()
--        game.print("[FUSC] DUMP: storage.entities_with_warning:")
--        for key, value in pairs(storage.entities_with_warning) do
--            game.print("[FUSC]   - " .. serpent.line(key) .. " -> " .. serpent.line(value))
--        end
--
--        game.print("[FUSC] DUMP: storage.acknowledged_entities:")
--        for key, value in pairs(storage.acknowledged_entities) do
--            game.print("[FUSC]   - " .. serpent.line(key) .. " -> " .. serpent.line(value))
--        end
--
--        game.print("[FUSC] DUMP: storage.entity_icon_sprites:")
--        for key, value in pairs(storage.entity_icon_sprites) do
--            game.print("[FUSC]   - " .. serpent.line(key) .. " -> " .. serpent.line(value))
--        end
--
--    end
--)

-- Create a custom keybinding to get the selection tool to acknowledge unfiltered chests
data:extend({
    {
        type = "custom-input",
        name = "fusc-get-acknowledge-unfiltered-chest-tool",
        -- Don't set a default key binding for now, but allow players to set one.
        key_sequence = "",
        action = "spawn-item",
        item_to_spawn = "fusc-acknowledge-unfiltered-chest-tool",
    },
})

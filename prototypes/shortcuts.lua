-- Create a toolbar shortcut to get the selection tool to acknowledge unfiltered chests
data:extend({
    {
        -- TODO: Localisation
        type = "shortcut",
        name = "fusc-get-acknowledge-unfiltered-chest-tool",
        order = "d[tools]-u[acknowledge-unfiltered-chest]",
        -- TODO: Replace these placeholder icons with proper ones
        icon = "__base__/graphics/icons/storage-chest.png",
        small_icon = "__base__/graphics/icons/storage-chest.png",
        action = "spawn-item",
        item_to_spawn = "fusc-acknowledge-unfiltered-chest-tool",
        associated_control_input = "fusc-get-acknowledge-unfiltered-chest-tool",
    },
})

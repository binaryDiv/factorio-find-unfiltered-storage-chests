-- The selection tool uses an entity filter to only select logistic containers in "storage" mode, e.g. Storage Chests.
--
-- To provide compatibility with any mod that adds custom logistic containers (e.g. AAI Containers & Warehouses),
-- we need to populate the entity filter list with all prototypes of logistic storage containers **after** these mods
-- have created their prototypes.
--
-- We initialize an empty table here so that we can already create our prototypes. The table will then be populated
-- in data-final-fixes.lua.
FUSC_selection_tool_entity_filters = {}

-- Define custom item prototypes
data:extend({
    -- Selection tool to remove warnings from unfiltered storage chests
    {
        type = "selection-tool",
        name = "fusc-acknowledge-unfiltered-chest-tool",
        icon = "__find-unfiltered-storage-chests__/graphics/icons/acknowledged-icon-64.png",
        stack_size = 1,
        flags = { "only-in-cursor", "not-stackable", "spawnable" },
        hidden = true,

        -- Select mode (left-click): Mark unfiltered chests as ignored / intentionally unfiltered
        select = {
            border_color = { g = 1 },
            mode = { "buildable-type", "friend" },
            cursor_box_type = "entity",
            entity_filters = FUSC_selection_tool_entity_filters,
        },

        -- Alt-select mode (Shift + left-click): Remove chests from "ignored" list, making them show warnings again
        alt_select = {
            border_color = { r = 1 },
            mode = { "buildable-type", "friend" },
            cursor_box_type = "entity",
            entity_filters = FUSC_selection_tool_entity_filters,
        },
    }
})

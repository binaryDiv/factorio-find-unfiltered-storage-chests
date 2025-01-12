-- Add sprite prototypes for rendering icons on entities
data:extend({
    -- Warning icon for unfiltered storage containers
    {
        type = "sprite",
        name = "fusc-no-filter-warning-icon",
        filename = "__find-unfiltered-storage-chests__/graphics/icons/no-filter-warning-128.png",
        flags = { "icon" },
        size = 128,
        scale = 0.25,
    },

    -- Info icon for acknowledged unfiltered storage containers
    {
        type = "sprite",
        name = "fusc-acknowledged-icon",
        filename = "__find-unfiltered-storage-chests__/graphics/icons/acknowledged-icon-64.png",
        flags = { "icon" },
        size = 64,
        scale = 0.25,
    },
})

-- Add a virtual signal to use as the alert icon
data:extend({
    {
        -- TODO: Localisation
        type = "virtual-signal",
        name = "fusc-no-filter-warning-signal",
        order = "d[tools]-u[unfiltered-chest-warning]",
        icon = "__find-unfiltered-storage-chests__/graphics/icons/no-filter-warning-128.png",
        icon_size = 128,
    },
})

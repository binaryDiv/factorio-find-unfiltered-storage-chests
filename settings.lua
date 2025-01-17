-- Define mod settings
data:extend({
    -- Per player setting: Whether to generate alerts for unfiltered chests
    {
        type = "bool-setting",
        name = "fusc-generate-alerts-for-unfiltered-chests",
        setting_type = "runtime-per-user",
        default_value = true,
    }
})

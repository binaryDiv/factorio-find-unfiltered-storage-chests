-- Populate entity filters for selection tool with all prototypes of logistic storage containers, i.e. Storage Chests
-- and similar entities added by mods. (See explanation in prototypes/items.lua.)
for name, prototype in pairs(data.raw["logistic-container"]) do
    if prototype.logistic_mode == "storage" then
        table.insert(FUSC_selection_tool_entity_filters, name)
    end
end

-- Event handlers for selection tool to acknowledge/unacknowledge unfiltered storage containers
local function handle_player_selected_area(event)
    if event.item ~= "fusc-acknowledge-unfiltered-chest-tool" then
        return
    end

    for _, entity in pairs(event.entities) do
        if event.name == defines.events.on_player_alt_selected_area then
            unacknowledge_unfiltered_container(entity)
        else
            acknowledge_unfiltered_container(entity)
        end
    end
end

script.on_event(defines.events.on_player_selected_area, handle_player_selected_area)
script.on_event(defines.events.on_player_alt_selected_area, handle_player_selected_area)


-- Acknowledges an unfiltered storage container (checks if it actually is unfiltered first)
function acknowledge_unfiltered_container(entity)
    -- Ignore entities that are not logistic storage containers
    if entity.type ~= "logistic-container" or entity.prototype.logistic_mode ~= "storage" then
        return
    end

    -- Only acknowledge storage containers that are actually unfiltered
    if entity.storage_filter == nil then
        storage.acknowledged_entities[entity.unit_number] = entity
        update_logistic_container(entity)
    end
end

-- Removes acknowledgement of an unfiltered storage container
function unacknowledge_unfiltered_container(entity)
    -- Only unacknowledge if it is currently acknowledged
    if storage.acknowledged_entities[entity.unit_number] ~= nil then
        storage.acknowledged_entities[entity.unit_number] = nil
        update_logistic_container(entity)
    end
end

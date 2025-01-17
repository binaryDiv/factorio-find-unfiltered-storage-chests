-- Event handlers for selection tool to acknowledge/unacknowledge unfiltered storage containers
local function handle_player_selected_area(event)
    if event.item ~= "fusc-acknowledge-unfiltered-chest-tool" then
        return
    end

    for _, entity in pairs(event.entities) do
        if event.name == defines.events.on_player_selected_area then
            acknowledge_unfiltered_container(entity)
        else
            unacknowledge_unfiltered_container(entity)
        end
    end
end

script.on_event(defines.events.on_player_selected_area, handle_player_selected_area)
script.on_event(defines.events.on_player_alt_selected_area, handle_player_selected_area)
script.on_event(defines.events.on_player_reverse_selected_area, handle_player_selected_area)
script.on_event(defines.events.on_player_alt_reverse_selected_area, handle_player_selected_area)


-- Acknowledges an unfiltered storage container (checks if it actually is unfiltered first)
function acknowledge_unfiltered_container(entity)
    -- Ignore entities that are not logistic storage containers
    if not entity_is_storage_container(entity) then
        return
    end

    -- Only acknowledge storage containers that are actually unfiltered
    if entity.storage_filter == nil then
        entity_set_is_acknowledged(entity)
        update_logistic_container(entity)
    end
end

-- Removes acknowledgement of an unfiltered storage container
function unacknowledge_unfiltered_container(entity)
    -- Only unacknowledge if it is currently acknowledged
    if entity_is_acknowledged(entity) then
        entity_unset_is_acknowledged(entity)
        update_logistic_container(entity)
    end
end

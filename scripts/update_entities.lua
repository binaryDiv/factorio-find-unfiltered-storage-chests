-- Reset and update ALL logistic containers on all surfaces by checking if they have a filter and adding/removing
-- warnings. Acknowledgements of unfiltered containers will be kept intact (if the entities are still valid).
function update_all_logistic_containers()
    -- Remove all alerts for entities with warnings and all icon sprites
    clear_all_alerts()
    clear_all_sprites()

    -- Reset list of entities with warnings
    storage.entities_with_warning = {}

    -- Prune invalid acknowledged entities
    for unit_number, entity in pairs(storage.acknowledged_entities) do
        if not entity.valid then
            storage.acknowledged_entities[unit_number] = nil
        end
    end

    -- Iterate over all surfaces to find logistic storage chests and update them
    for _, surface in pairs(game.surfaces) do
        local logistic_containers = surface.find_entities_filtered { type = "logistic-container" }

        for _, entity in pairs(logistic_containers) do
            update_logistic_container(entity)
        end
    end
end

-- Update a single logistic container entity by checking if it has a filter and adding/removing warnings
function update_logistic_container(entity)
    -- Only look at logistic containers in "storage" mode, i.e. Storage Chests or other entities added by mods that
    -- behave like Storage Chests.
    if not entity_is_storage_container(entity) then
        return
    end

    if entity.storage_filter == nil and not entity_is_acknowledged(entity) then
        -- Container is unfiltered and not acknowledged: Render warning icon, generate alert
        -- (If the entity has an acknowledged icon, it will be automatically removed)
        add_warning_to_entity(entity)
    elseif entity.storage_filter == nil and entity_is_acknowledged(entity) then
        -- Container is unfiltered and acknowledged: Remove warning, render acknowledged icon
        clear_entity_warning(entity)
        add_acknowledgement_icon_to_entity(entity)
    else
        -- Container has a filter: Remove warning and acknowledgement
        clear_entity_warning(entity)
        clear_entity_acknowledgement(entity)
    end
end

-- Add warning to a single logistic container (automatically replaces "acknowledged" icon with warning sprite).
function add_warning_to_entity(entity)
    -- Check if entity already has warning
    if entity_has_warning(entity) then
        return
    end

    -- Add entity to list to generate and refresh alerts later
    entity_set_has_warning(entity)

    -- Remove existing icon sprite if the entity has one (e.g. if it has an "acknowledged" icon)
    clear_entity_icon_sprite(entity)

    -- Create warning icon sprite and save reference to remove it again later
    storage.entity_icon_sprites[entity.unit_number] = create_warning_icon(entity)

    -- Generate an alert for this entity
    generate_alerts_for_entity(entity)
end

-- Add an acknowledgement icon to a container that has been marked as "unfiltered".
function add_acknowledgement_icon_to_entity(entity)
    -- Remove existing icon sprite if the entity has one (e.g. if it has a warning icon)
    clear_entity_icon_sprite(entity)

    -- Create acknowledged icon sprite and save reference to remove it again later
    storage.entity_icon_sprites[entity.unit_number] = create_acknowledged_icon(entity)
end

-- Remove warning for a single logistic container. This will remove both the warning sprite and the alert.
function clear_entity_warning(entity)
    -- Remove entity from list
    entity_unset_has_warning(entity)

    -- Remove warning sprite and alerts
    clear_entity_icon_sprite(entity)
    remove_alerts_for_entity(entity)
end

-- Remove acknowledgement icon from a container and remove it from the list of acknowledged entities.
function clear_entity_acknowledgement(entity)
    -- Remove entity from list
    entity_unset_is_acknowledged(entity)

    -- Remove acknowledged icon sprite
    clear_entity_icon_sprite(entity)
end

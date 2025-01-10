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
    if entity.type ~= "logistic-container" or entity.prototype.logistic_mode ~= "storage" then
        return
    end

    if entity.storage_filter == nil and storage.acknowledged_entities[entity.unit_number] == nil then
        -- Container is unfiltered and not acknowledged: Render warning icon, generate alert
        -- (If the entity has an acknowledged icon, it will be automatically removed)
        add_warning_to_entity(entity)
    elseif entity.storage_filter == nil and storage.acknowledged_entities[entity.unit_number] ~= nil then
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
    local unit_number = entity.unit_number

    -- Check if entity already has warning
    if storage.entities_with_warning[unit_number] ~= nil then
        return
    end

    -- Add entity to list to generate and refresh alerts later
    storage.entities_with_warning[unit_number] = entity

    -- Remove existing icon sprite if the entity has one (e.g. if it has an "acknowledged" icon)
    clear_entity_icon_sprite(entity)

    -- Create warning icon sprite and save reference to remove it again later
    storage.entity_icon_sprites[unit_number] = create_warning_icon(entity)

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
    storage.entities_with_warning[entity.unit_number] = nil

    -- Remove warning sprite and alerts
    clear_entity_icon_sprite(entity)
    remove_alerts_for_entity(entity)
end

-- Remove acknowledgement icon from a container and remove it from the list of acknowledged entities.
function clear_entity_acknowledgement(entity)
    -- Remove entity from list
    storage.acknowledged_entities[entity.unit_number] = nil

    -- Remove acknowledged icon sprite
    clear_entity_icon_sprite(entity)
end

-- Generate a warning icon sprite for an entity and return it (caller needs to save it!)
function create_warning_icon(entity)
    -- TODO: Try to animate (blinking warning sprite)?
    -- TODO: Custom icon
    return rendering.draw_sprite {
        target = entity,
        surface = entity.surface,
        sprite = "utility.danger_icon",
        render_layer = "entity-info-icon-above",
        x_scale = 0.5,
        y_scale = 0.5,
    }
end

-- Generate an acknowledged icon sprite for an entity and return it (caller needs to save it!)
function create_acknowledged_icon(entity)
    -- TODO: Custom icon
    return rendering.draw_sprite {
        target = entity,
        surface = entity.surface,
        sprite = "utility.check_mark_green",
        render_layer = "entity-info-icon-above",
        x_scale = 1,
        y_scale = 1,
    }
end

-- Clear any icon sprite from an entity (if it has one)
function clear_entity_icon_sprite(entity)
    if storage.entity_icon_sprites[entity.unit_number] ~= nil then
        storage.entity_icon_sprites[entity.unit_number].destroy()
        storage.entity_icon_sprites[entity.unit_number] = nil
    end
end

-- Destroys all sprites generated by this mod and clears the list of sprites
function clear_all_sprites()
    -- Clear all render objects created by this mod
    rendering.clear(script.mod_name)

    -- Clear list of sprites
    storage.entity_icon_sprites = {}
end

-- Generate an alert for an unfiltered storage container
function generate_alerts_for_entity(entity)
    -- Add alert for every player of the force that owns the entity
    for _, player in pairs(entity.force.players) do
        player.add_custom_alert(
            entity,
            {
                type = "entity",
                name = entity.name,
            },
            -- TODO: Localized strings!
            string.format(
                "Unfiltered storage chest at (%d, %d).",
                entity.position.x,
                entity.position.y
            ),
            true
        )
    end
end

-- Remove alerts for an entity for all players
function remove_alerts_for_entity(entity)
    for _, player in pairs(entity.force.players) do
        player.remove_alert { entity = entity }
    end
end

-- Generate alerts for all currently known unfiltered storage containers.
-- This needs to be run frequently (on_nth_tick) because the alerts are short-lived and need to be refreshed.
function refresh_alerts()
    for _, entity in pairs(storage.entities_with_warning) do
        generate_alerts_for_entity(entity)
    end
end

-- Remove alerts for all entities with warnings
function clear_all_alerts()
    for _, entity in pairs(storage.entities_with_warning) do
        remove_alerts_for_entity(entity)
    end
end

-- Update ALL logistic containers on all surfaces by checking if they have a filter and adding/removing warnings
function update_all_logistic_containers()
    -- Iterate over our list of entities with warnings to check if they all still exist
    for unit_number, entity in pairs(storage.entities_with_warning) do
        if not entity.valid then
            storage.entities_with_warning[unit_number] = nil
            storage.entity_warning_sprites[unit_number].destroy()
            storage.entity_warning_sprites[unit_number] = nil
        end
    end

    -- Iterate over all surfaces to find logistic storage chests
    for _, surface in pairs(game.surfaces) do
        local logistic_containers = surface.find_entities_filtered { type = "logistic-container" }

        for _, logistic_container in pairs(logistic_containers) do
            update_logistic_container(logistic_container)
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

    if entity.storage_filter == nil then
        add_warning_to_entity(entity)
    else
        remove_warning_from_entity(entity)
    end
end

-- Add warning to a single logistic container.
function add_warning_to_entity(entity)
    -- Check if entity already has warning
    if storage.entities_with_warning[entity.unit_number] ~= nil then
        return
    end

    -- Add entity to list to generate and refresh alerts later
    storage.entities_with_warning[entity.unit_number] = entity

    -- Create warning sprite and save reference to remove it again later
    storage.entity_warning_sprites[entity.unit_number] = create_warning_sprite(entity)

    -- Generate an alert for this entity
    generate_alert_for_entity(entity)
end

-- Remove warning for a single logistic container. This will remove both the warning sprite and the alert.
function remove_warning_from_entity(entity)
    -- Check if entity has a warning
    if storage.entities_with_warning[entity.unit_number] == nil then
        return
    end

    -- Remove entity from list
    storage.entities_with_warning[entity.unit_number] = nil

    -- Remove warning sprite (but make sure it exists)
    if storage.entity_warning_sprites[entity.unit_number] ~= nil then
        storage.entity_warning_sprites[entity.unit_number].destroy()
        storage.entity_warning_sprites[entity.unit_number] = nil
    end

    -- Remove alerts for this entity
    for _, player in pairs(entity.force.players) do
        player.remove_alert { entity = entity }
    end
end

-- Generate a warning sprite for an entity and return it (caller needs to save it!)
function create_warning_sprite(entity)
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

-- Generate an alert for an unfiltered storage container
function generate_alert_for_entity(entity)
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

-- Generate alerts for all currently known unfiltered storage containers.
-- This needs to be run frequently (on_nth_tick) because the alerts are short-lived and need to be refreshed.
function refresh_alerts()
    for _, entity in pairs(storage.entities_with_warning) do
        generate_alert_for_entity(entity)
    end
end

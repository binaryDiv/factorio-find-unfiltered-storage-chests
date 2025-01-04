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

    -- TODO: Generate alerts
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
    -- TODO: Alerts not implemented yet
    for _, player in pairs(entity.force.players) do
        player.remove_alert{entity = entity}
    end
end

-- Generate a warning sprite for an entity and return it (caller needs to save it!)
function create_warning_sprite(entity)
    -- TODO: Try to animate (blinking warning sprite)?
    -- TODO: Custom icon
    return rendering.draw_sprite{
        target = entity,
        surface = entity.surface,
        sprite = "utility.danger_icon",
        render_layer = "entity-info-icon-above",
        x_scale = 0.5,
        y_scale = 0.5,
    }
end

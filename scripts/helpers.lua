-- Returns true if the entity is a logistic container in storage mode (e.g. a Storage Chest)
function entity_is_storage_container(entity)
    return entity.type == "logistic-container" and entity.prototype.logistic_mode == "storage"
end

-- Returns true if a prototype is a logistic container in storage mode (e.g. a Storage Chest)
function prototype_is_storage_container(prototype)
    return prototype.type == "logistic-container" and prototype.logistic_mode == "storage"
end

-- Returns true if an entity has a warning (checks storage variable)
function entity_has_warning(entity)
    return storage.entities_with_warning[entity.unit_number] ~= nil
end

-- Returns true if an entity is acknowledged (checks storage variable)
function entity_is_acknowledged(entity)
    return storage.acknowledged_entities[entity.unit_number] ~= nil
end

-- Sets the "has warning" flag for an entity (only modifies storage, does not update anything else!)
function entity_set_has_warning(entity)
    storage.entities_with_warning[entity.unit_number] = entity
end

-- Unsets the "has warning" flag for an entity (only modifies storage, does not update anything else!)
function entity_unset_has_warning(entity)
    storage.entities_with_warning[entity.unit_number] = nil
end

-- Sets the "is acknowledged" flag for an entity (only modifies storage, does not update anything else!)
function entity_set_is_acknowledged(entity)
    storage.acknowledged_entities[entity.unit_number] = entity
end

-- Unsets the "is acknowledged" flag for an entity (only modifies storage, does not update anything else!)
function entity_unset_is_acknowledged(entity)
    storage.acknowledged_entities[entity.unit_number] = nil
end

-- Checks the player settings: Returns true if alerts should be generated for the given player
function get_player_setting_generate_alerts(player)
    local player_settings = settings.get_player_settings(player)
    local setting = player_settings.valid and player_settings["fusc-generate-alerts-for-unfiltered-chests"]
    return setting and setting.value == true
end

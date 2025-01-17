-- Returns true if the entity is a logistic container in storage mode (e.g. a Storage Chest)
function entity_is_storage_container(entity)
    return entity.type == "logistic-container" and entity.prototype.logistic_mode == "storage"
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

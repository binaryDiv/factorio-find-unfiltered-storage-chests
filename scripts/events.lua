-- Mod initialization (run when starting a new game or adding the mod to an existing save)
script.on_init(function()
    -- This variable will hold references to all logistic container entities that currently have a warning about being
    -- unfiltered. The keys will be integer IDs (the entity's unit_number) and the values will be LuaEntity objects.
    storage.entities_with_warning = {}

    -- This variable will contain references to the LuaRenderObjects of the warning sprites for all logistic container
    -- entities that have a warning (so the same entites as in entities_with_warning). The keys will be integer IDs
    -- (the entity's unit_number, same as above) and the values will be LuaRenderObjects objects.
    storage.entity_warning_sprites = {}

    -- Update all existing logistic containers (important when adding the mod to an existing save file)
    update_all_logistic_containers()
end)

-- Mod initialization (run when starting a new game or adding the mod to an existing save)
script.on_configuration_changed(function()
    -- Update all existing logistic containers (important when adding the mod to an existing save file)
    update_all_logistic_containers()
end)


-- Define an event filter used for registering event handlers, so that we only get events for logistic containers
local entity_event_filter = {{filter = "type", type = "logistic-container"}}


-- Events for when a storage container is built
function handle_entity_built(event)
    -- We only care about storage containers
    if event.entity.prototype.logistic_mode ~= "storage" then
        return
    end

    update_logistic_container(event.entity)
end

script.on_event(defines.events.on_built_entity, handle_entity_built, entity_event_filter)
script.on_event(defines.events.on_robot_built_entity, handle_entity_built, entity_event_filter)
script.on_event(defines.events.on_space_platform_built_entity, handle_entity_built, entity_event_filter)
script.on_event(defines.events.script_raised_built, handle_entity_built, entity_event_filter)


-- Events for when the filter of a storage container is modified
function handle_entity_logistic_slot_changed(event)
    -- We can't use event filters here, so let's see if this event is relevant to us
    if event.entity.type ~= "logistic-container" or event.entity.prototype.logistic_mode ~= "storage" then
        return
    end

    update_logistic_container(event.entity)
end

script.on_event(defines.events.on_entity_logistic_slot_changed, handle_entity_logistic_slot_changed)


-- Events for when a storage container is removed
function handle_entity_removed(event)
    -- We only care about storage containers
    if event.entity.prototype.logistic_mode ~= "storage" then
        return
    end

    remove_warning_from_entity(event.entity)
end

script.on_event(defines.events.on_player_mined_entity, handle_entity_removed, entity_event_filter)
script.on_event(defines.events.on_robot_mined_entity, handle_entity_removed, entity_event_filter)
script.on_event(defines.events.on_space_platform_mined_entity, handle_entity_removed, entity_event_filter)
script.on_event(defines.events.on_entity_died, handle_entity_removed, entity_event_filter)
script.on_event(defines.events.script_raised_destroy, handle_entity_removed, entity_event_filter)

-- TODO: Do we want warnings on ghosts as well?

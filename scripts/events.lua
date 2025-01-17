-- Mod initialization (run when starting a new game or adding the mod to an existing save)
script.on_init(function()
    -- This variable will hold references to all logistic container entities that currently have a warning about being
    -- unfiltered. The keys will be integer IDs (the entity's unit_number) and the values will be LuaEntity objects.
    storage.entities_with_warning = {}

    -- This variable will contain all logistic container entities (with unit numbers as keys as above) that the players
    -- marked as "acknowledged" (as in: "this chest should really be unfiltered") using the selection tool. Instead of
    -- a warning, these entities will have a small icon in the corner to mark them as "acknowledged".
    storage.acknowledged_entities = {}

    -- This variable will contain references to the LuaRenderObjects rendered on top of logistic container entities,
    -- either a warning icon if they are in entities_with_warning, or a small "acknowledged" icon. The keys of this
    -- table are the entity's unit_number, like in the other tables.
    storage.entity_icon_sprites = {}

    -- Update all existing logistic containers (important when adding the mod to an existing save file)
    update_all_logistic_containers()
end)

-- Mod initialization (run when starting a new game or adding the mod to an existing save)
script.on_configuration_changed(function()
    -- Create storage variables that don't exist yet
    if storage.entities_with_warning == nil then
        storage.entities_with_warning = {}
    end
    if storage.acknowledged_entities == nil then
        storage.acknowledged_entities = {}
    end
    if storage.entity_icon_sprites == nil then
        storage.entity_icon_sprites = {}
    end

    -- Update all existing logistic containers (important when adding the mod to an existing save file)
    update_all_logistic_containers()
end)


-- Event that runs once per second to refresh the alerts
script.on_nth_tick(60, function()
    refresh_alerts()
end)


-- Define an event filter used for registering event handlers, so that we only get events for logistic containers
local entity_event_filter = {
    { filter = "type", type = "logistic-container" },
}


-- Events for when a storage container is built
function handle_entity_built(event)
    -- We only care about storage containers
    if not entity_is_storage_container(event.entity) then
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
    if not entity_is_storage_container(event.entity) then
        return
    end

    update_logistic_container(event.entity)
end

script.on_event(defines.events.on_entity_logistic_slot_changed, handle_entity_logistic_slot_changed)


-- Events for when a storage container is removed
function handle_entity_removed(event)
    -- We only care about storage containers
    if not entity_is_storage_container(event.entity) then
        return
    end

    -- Clear both warnings and acknowledgements for the removed item
    clear_entity_warning(event.entity)
    clear_entity_acknowledgement(event.entity)
end

script.on_event(defines.events.on_player_mined_entity, handle_entity_removed, entity_event_filter)
script.on_event(defines.events.on_robot_mined_entity, handle_entity_removed, entity_event_filter)
script.on_event(defines.events.on_space_platform_mined_entity, handle_entity_removed, entity_event_filter)
script.on_event(defines.events.on_entity_died, handle_entity_removed, entity_event_filter)
script.on_event(defines.events.script_raised_destroy, handle_entity_removed, entity_event_filter)


-- Events for when a storage container is cloned using the map editor
function handle_entity_cloned(event)
    -- We only care about storage containers
    if not entity_is_storage_container(event.source) or not entity_is_storage_container(event.destination) then
        return
    end

    -- If the source entity is acknowledged, copy the acknowledgement onto the cloned entity
    if entity_is_acknowledged(event.source) then
        entity_set_is_acknowledged(event.destination)
    end

    update_logistic_container(event.destination)
end

script.on_event(defines.events.on_entity_cloned, handle_entity_cloned, entity_event_filter)


-- Events when settings are copy and pasted from one storage container to another
function handle_entity_settings_pasted(event)
    -- We can't use event filters here, so let's see if this event is relevant to us
    if not entity_is_storage_container(event.source) or not entity_is_storage_container(event.destination) then
        return
    end

    -- If the destination entity is unfiltered (now) and the source entity is acknowledged, copy the acknowledgement.
    -- Otherwise, unset any existing acknowledgement.
    if event.destination.storage_filter == nil and entity_is_acknowledged(event.source) then
        entity_set_is_acknowledged(event.destination)
    else
        entity_unset_is_acknowledged(event.destination)
    end

    -- Update destination entity to apply warning or acknowledgement icons
    update_logistic_container(event.destination)
end

script.on_event(defines.events.on_entity_settings_pasted, handle_entity_settings_pasted)


-- Events for undo/redo actions: Update storage containers if undo/redo changed their filter
function handle_undo_or_redo_applied(event)
    -- Finding out whether the undo/redo action affected a storage container, and if yes, *which* storage container,
    -- is quite annoying and partially impossible with what the API offers. So this is going to be a bit ugly.
    for _, undo_redo_action in pairs(event.actions) do
        if undo_redo_action.type == 'copy-entity-settings' then
            -- Determine the type of the entity
            local target = undo_redo_action.target
            local target_prototype = prototypes.entity[target.name]

            if target_prototype.type == "logistic-container" and target_prototype.logistic_mode == "storage" then
                -- The UndoRedoAction only gives us the map position of the entity, but not the surface. So we have
                -- to check the map position on *every* surface for potential storage containers and update them. UGH.
                for _, surface in pairs(game.surfaces) do
                    local entity = surface.find_entity(target.name, target.position)
                    if entity ~= nil then
                        update_logistic_container(entity)
                    end
                end
            end
        end
    end
end

script.on_event(defines.events.on_undo_applied, handle_undo_or_redo_applied)
script.on_event(defines.events.on_redo_applied, handle_undo_or_redo_applied)

-- Generate an alert for an unfiltered storage container
function generate_alerts_for_entity(entity)
    if not entity.valid then
        return
    end

    -- Add alert for every player of the force that owns the entity
    for _, player in pairs(entity.force.players) do
        if get_player_setting_generate_alerts(player) then
            player.add_custom_alert(
                entity,
                {
                    type = "virtual",
                    name = "fusc-no-filter-warning-signal",
                },
                {
                    "fusc-messages.unfiltered-chest-alert",
                    entity.localised_name,
                },
                true
            )
        end
    end
end

-- Remove alerts for an entity for all players
function remove_alerts_for_entity(entity)
    if not entity.valid then
        return
    end

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

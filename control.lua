global.crash_site_created = false
local crash_site_objects = {
    "crash-site-spaceship", "crash-site-spaceship-wreck-big-1",
    "crash-site-spaceship-wreck-big-2", "crash-site-spaceship-wreck-medium-3",
    "crash-site-spaceship-wreck-small-5", "crash-site-spaceship-wreck-small-6"
}

local function initialize_crash_site(player_index)
    local player = game.get_player(player_index)
    local playerForce = player and player.force or "player"
    -- Find all objects to be tinted, and spawn the respective tint entity on top
    global.registered_objects = global.registered_objects or {}
    local registered_objects = global.registered_objects

    local surface = game.surfaces["nauvis"]
    if surface and surface.valid then
        for k, v in pairs(crash_site_objects) do
            local object = surface.find_entities_filtered{
                type = {"container", "simple-entity-with-owner"},
                name = v
            }[1]
            if object and object.valid then
                local tintEntityName = v .. "-tint"
                local tintEntity = surface.create_entity {
                    name = tintEntityName,
                    position = object.position,
                    force = playerForce,
                    raise_build = false,
                    create_build_effect_smoke = false
                }
                tintEntity.destructible = false

                -- register parent objects so we can destroy the tint entity when it is destroyed
                local objectID = script.register_on_entity_destroyed(object)
                registered_objects[objectID] = tintEntity

            end
        end
    end
    global.crash_site_created = true
end

script.on_event(defines.events.on_player_created, function(event)
    if not global.crash_site_created then
        initialize_crash_site(event.player_index)
    end
end)

script.on_event(defines.events.on_entity_destroyed, function(event)
    local ID = event.registration_number
    if global.registered_objects and global.registered_objects[ID] then
        global.registered_objects[ID].destroy()
    end
end)

local function manual_initialization(args)
    initialize_crash_site(args.player_index)
end

commands.add_command("recolor-crash-site", "", manual_initialization)

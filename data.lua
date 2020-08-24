local crash_site_objects = {
    "crash-site-spaceship", "crash-site-spaceship-wreck-big-1",
    "crash-site-spaceship-wreck-big-2", "crash-site-spaceship-wreck-medium-3",
    "crash-site-spaceship-wreck-small-5", "crash-site-spaceship-wreck-small-6"
}
for k, v in pairs(crash_site_objects) do
    local object = data.raw.container[v] or
                       data.raw["simple-entity-with-owner"][v]

    local objectPictures = object.picture.layers
    local baseLayer = objectPictures[1]
    local tintLayer = util.table.deepcopy(baseLayer)
    tintLayer.filename = "__tinted-spaceship__/graphics/" .. v .. "-mask.png"
    tintLayer.apply_runtime_tint = true
    tintLayer.hr_version.filename = "__tinted-spaceship__/graphics/hr-" .. v ..
                                        "-mask.png"
    tintLayer.hr_version.apply_runtime_tint = true
    table.insert(objectPictures, 2, tintLayer)

    data:extend{
        {
            type = "simple-entity-with-force",
            name = v .. "-tint",
            flags = {
                "hidden", "not-rotatable", "placeable-off-grid",
                "not-blueprintable", "not-deconstructable"
            },
            picture = tintLayer,
            render_layer = "higher-object-under",
            alert_when_damaged = false
        }
    }
end

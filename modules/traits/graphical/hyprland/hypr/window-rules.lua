local steam_props = {
    { class = '^(steam_app_\\d+)$' },
    { class = '^(gamescope)$' },
    { class = '^(steam_proton)$' },
    { xdg_tag = 'proton-game' }
}

for _, props in ipairs(steam_props) do
    hl.window_rule { match = props, tag = '+game' }
end

hl.window_rule {
    match = { tag = 'game' },
    workspace = '1',
    fullscreen = true,
    no_blur = true,
}

hl.window_rule {
    match = { class = 'satisfactory-modeler-SatisfactoryModeler' },
    no_blur = true,
    opaque = true,
}

--- Create a generic floating, centered window rule for a given set of criteria.
--@ param match The match props as defined on the hyprland wiki.
local function float_rule(match)
    if not match then return end
    hl.window_rule {
        match = match,
        float = true,
        center = true,
        size = { '(1.15*monitor_h)', '(0.65*monitor_h)' },
    }
end

hl.window_rule {
    match = {
        class = "qalculate-gtk",
        title = "Qalculate!",
    },
    float = true,
    center = true,
    size = { 800, 250 },
}

local to_float = {
    {
        class = "brave",
        title = "^(.* wants to (open|save))$",
    },
    {
        class = ".blueman-manager-wrapped",
        title = "Bluetooth Devices",
    },
    {
        class = "brave",
        title = "Save File",
    },
    {
        class = "xdg-desktop-portal-gtk",
        title = "xdg-desktop-portal-gtk",
    },
    { class = "org.gnome.Nautilus" },
    { class = "org.telegram.desktop" },
    { class = "org.pulseaudio.pavucontrol" },
}

for _, prop in ipairs(to_float) do
    float_rule(prop)
end

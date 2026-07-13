---@alias HL.WindowProps table<string, string|number|boolean>

---Create a generic floating, centred window rule for a given set of criteria.
---@param match HL.WindowProps The match props as defined on the hyprland wiki.
---@return nil
local function float_rule(match)
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

---@type HL.WindowProps[]
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
    { class = "steam", },
    { class = "org.gnome.Nautilus" },
    { class = "org.telegram.desktop" },
    { class = "org.pulseaudio.pavucontrol" },
}

for _, prop in ipairs(to_float) do
    float_rule(prop)
end

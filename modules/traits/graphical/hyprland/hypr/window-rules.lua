---@alias HLX.WindowMatch table<string, string|number|boolean>
---@alias HLX.WindowSize [integer|string, integer|string]

local STD_WIDTH = '(1.15*monitor_h)'
local STD_HEIGHT = '(0.65*monitor_h)'
local STD_SIZE = { STD_WIDTH, STD_HEIGHT }

---Creates a standard dimension vector with the width scaled according to a given factor. A value of 1 makes the window square.
---@param factor number
---@return HLX.WindowSize
local function std_size(factor)
    return { string.format("(%s*%f)", STD_HEIGHT, factor), STD_HEIGHT }
end

--> Default Window Rules
---@type HLX.WindowMatch[]
local float_generic = {
    -- Portals/dialogs
    { class = 'brave',                     title = '^(.* wants to (open|save))$', },
    { class = 'brave',                     title = 'Save File', },
    { class = 'xdg-desktop-portal-gtk',    title = 'xdg-desktop-portal-gtk', },
    -- Steam
    { class = 'steam',                     title = 'Steam', },
    -- Standalone apps
    { class = '.blueman-manager-wrapped',  title = 'Bluetooth Devices', },
    { class = 'org.gnome.Nautilus' },
    { class = 'org.telegram.desktop' },
    { class = 'org.pulseaudio.pavucontrol' },
}

---@class HLX.FloatingRule
---@field match HLX.WindowMatch
---@field size HLX.WindowSize

--> Other Specific Window Rules
---@type HLX.FloatingRule[]
local float_custom = {
    {
        match = { class = 'steam', title = 'Steam Settings' },
        size = std_size(1.2),
    },
    {
        match = { class = 'steam', title = 'Friends List' },
        size = std_size(0.6),
    },
    {
        match = { class = 'qalculate-gtk', title = 'Qalculate!' },
        size = { 800, 250 }
    }
}

--> Helpers

---Create a generic floating, centred window rule for a given set of criteria.
---@param match HLX.WindowMatch The match props as defined on the hyprland wiki.
---@param size? HLX.WindowSize
---@return nil
local function floating_window(match, size)
    hl.window_rule {
        match = match,
        float = true,
        center = true,
        size = size or STD_SIZE,
    }
end

for _, prop in ipairs(float_generic) do
    floating_window(prop)
end

for _, rule in ipairs(float_custom) do
    floating_window(rule.match, rule.size)
end

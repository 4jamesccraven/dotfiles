local helpers = require 'config.bind-helpers'
local term = require 'generated.terminal'

---@alias JCC.Bind [string, string|function|HL.Dispatcher, JCC.BindOpts?]
---@type JCC.Bind[]
local binds = {
    -- :> General
    { 'SUPER + E',             'nautilus',                                         { cmd = true, } },
    { 'ALT + Space',           'fuzzel',                                           { cmd = true, } },
    { 'SUPER + Return',        term.name,                                          { cmd = true, } },
    { 'CTRL + SHIFT + Escape', term.run_in_term .. ' btop',                        { cmd = true, } },
    { 'XF86Calculator',        'qalculate-gtk',                                    { cmd = true, } },
    -- Power/Session control
    { 'SUPER + L',             'hyprlock',                                         { cmd = true, } },
    { 'SUPER + V',             'hyprshutdown',                                     { cmd = true, } },
    { 'SUPER + SHIFT + V',     'shutdown now',                                     { cmd = true, } },
    { 'switch:on:Lid Switch',  'hyprlock',                                         { cmd = true, locked = true } },
    -- Screenshots
    { 'Print',                 'screenie',                                         { cmd = true, } },
    { 'SHIFT + Print',         'screenie output',                                  { cmd = true, } },

    -- :> Window Control
    -- Close window
    { 'SUPER + Q',             hl.dsp.window.close() },
    -- Fullscreen
    { 'SUPER + M',             hl.dsp.window.fullscreen { mode = 'maximized' } },
    { 'SUPER + SHIFT + M',     hl.dsp.window.fullscreen { mode = 'fullscreen' } },
    -- Floating
    { 'SUPER + F',             helpers.toggle_float }, -- Function floats and centres a window (or tiles if floating)
    -- Cycle visible
    { 'ALT + TAB',             helpers.cycle_visible },
    -- Mouse
    { 'SUPER + mouse:272',     hl.dsp.window.drag(),                               { passthru = { mouse = true, } } },
    { 'SUPER + mouse:273',     hl.dsp.window.resize(),                             { passthru = { mouse = true, } } },

    -- :> Media keys
    { 'XF86AudioRaiseVolume',  'wpctl set-volume -l 1.2 @DEFAULT_AUDIO_SINK@ 5%+', { cmd = true, media = true, } },
    { 'XF86AudioLowerVolume',  'wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-',        { cmd = true, media = true, } },
    { 'XF86AudioMute',         'wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle',       { cmd = true, media = true, } },
    { 'XF86AudioMicMute',      'wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle',     { cmd = true, media = true, } },
    { 'XF86MonBrightnessDown', 'brightnessctl set 10%-',                           { cmd = true, media = true, } },
    { 'XF86MonBrightnessUp',   'brightnessctl set 10%+',                           { cmd = true, media = true, } },
}
for _, b in ipairs(binds) do
    helpers.bind(b[1], b[2], b[3])
end


-- :> Directional window movement/focus change
local dir_binds = { left = 'h', down = 'j', up = 'k', right = 'l', }
for dir, bind in pairs(dir_binds) do
    hl.bind('ALT + ' .. bind, hl.dsp.focus { direction = dir })
    hl.bind('SUPER + SHIFT + ' .. bind, hl.dsp.window.move { direction = dir })
end


-- :> Change workspace
for i = 1, 5 do
    hl.bind('SUPER + ' .. i, hl.dsp.focus { workspace = i })
    hl.bind('SUPER + SHIFT + ' .. i, hl.dsp.focus { workspace = 5 + i })
end

-- :> Move window to workspace
hl.define_submap('movews', 'reset', function()
    for i = 1, 5 do
        hl.bind(tostring(i), hl.dsp.window.move { workspace = i })
        hl.bind('SHIFT + ' .. i, hl.dsp.window.move { workspace = 5 + i })
    end

    hl.bind('escape', hl.dsp.submap 'reset')
end)
hl.bind('SUPER + W', hl.dsp.submap 'movews')


-- :> Resize
hl.define_submap('resize', function()
    hl.bind('h', hl.dsp.window.resize { x = -10, y = 0, relative = true }, { repeating = true })
    hl.bind('j', hl.dsp.window.resize { x = 0, y = 10, relative = true }, { repeating = true })
    hl.bind('k', hl.dsp.window.resize { x = 0, y = -10, relative = true }, { repeating = true })
    hl.bind('l', hl.dsp.window.resize { x = 10, y = 0, relative = true }, { repeating = true })

    hl.bind('escape', hl.dsp.submap 'reset')
    hl.bind('SUPER + R', hl.dsp.submap 'reset')
end)
hl.bind('SUPER + R', hl.dsp.submap 'resize')


-- :> Touchpad gesture
hl.gesture {
    fingers = 3,
    direction = 'vertical',
    action = 'workspace'
}

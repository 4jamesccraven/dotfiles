local term = require 'generated/terminal'
local mod = 'SUPER'

-- :> General
hl.bind(mod .. ' + Q', hl.dsp.window.close())
hl.bind(mod .. ' + E', hl.dsp.exec_cmd 'nautilus')
hl.bind('ALT + Space', hl.dsp.exec_cmd 'fuzzel')
hl.bind(mod .. ' + Return', hl.dsp.exec_cmd(term.name))
hl.bind('CTRL + SHIFT + Escape', hl.dsp.exec_cmd(term.run_in_term .. ' btop'))
hl.bind('XF86Calculator', hl.dsp.exec_cmd 'qalculate-gtk')

-- :> Fullscreen control
hl.bind(mod .. ' + M', hl.dsp.window.fullscreen { mode = 'maximized' })
hl.bind(mod .. ' + SHIFT + M', hl.dsp.window.fullscreen { mode = 'fullscreen' })

-- :> Floating window toggle
hl.bind(mod .. ' + F', function()
    local win = hl.get_active_window()
    if not win then return end

    local was_floating = win.floating                      -- Get current floating state
    hl.dispatch(hl.dsp.window.float { action = 'toggle' }) -- toggle unconditionally

    -- Centre and resize if it wasn't floating before
    if not was_floating then
        local mon = hl.get_active_monitor()
        if not mon then return end

        local scale_factor = 0.65 -- Scale factor for floating size.
        hl.dispatch(hl.dsp.window.resize {
            x = mon.width * scale_factor,
            y = mon.height * scale_factor,
            relative = false,
        })

        hl.dispatch(hl.dsp.window.center())
    end
end)

-- :> System power/administration
hl.bind(mod .. ' + L', hl.dsp.exec_cmd 'hyprlock')
hl.bind(mod .. ' + V', hl.dsp.exec_cmd 'hyprshutdown')
hl.bind(mod .. ' + SHIFT + V', hl.dsp.exec_cmd 'shutdown now')

-- :> Window management
local dir_binds = { left = 'h', down = 'j', up = 'k', right = 'l', }
for dir, bind in pairs(dir_binds) do
    hl.bind('ALT + ' .. bind, hl.dsp.focus { direction = dir })
    hl.bind(mod .. ' + SHIFT + ' .. bind, hl.dsp.window.move { direction = dir })
end
hl.bind('ALT + TAB', function()
    local monitors = hl.get_monitors()
    local windows = hl.get_windows()
    local current = hl.get_active_window()
    if not windows or not current then return end

    -- Collect visible workspaces.
    local visible_wss = {}
    for _, m in ipairs(monitors) do
        visible_wss[m.active_workspace.id] = true
    end

    -- Collect windows that are on visible workspaces.
    local visible = {}
    for _, w in ipairs(windows) do
        if visible_wss[w.workspace.id] then
            table.insert(visible, w)
        end
    end
    if #visible == 0 then return end

    -- Find the next visible window.
    local next = nil
    for i, w in ipairs(visible) do
        if w.address == current.address then
            next = visible[(i % #visible) + 1]
            break
        end
    end

    -- Focus next.
    hl.dispatch(hl.dsp.focus({ window = next }))
end)

-- :> Resize
hl.define_submap('resize', function()
    hl.bind('h', hl.dsp.window.resize { x = -10, y = 0, relative = true }, { repeating = true })
    hl.bind('j', hl.dsp.window.resize { x = 0, y = 10, relative = true }, { repeating = true })
    hl.bind('k', hl.dsp.window.resize { x = 0, y = -10, relative = true }, { repeating = true })
    hl.bind('l', hl.dsp.window.resize { x = 10, y = 0, relative = true }, { repeating = true })

    hl.bind('escape', hl.dsp.submap 'reset')
    hl.bind(mod .. ' + R', hl.dsp.submap 'reset')
end)
hl.bind(mod .. ' + R', hl.dsp.submap 'resize')

-- :> Change workspace
for i = 1, 5 do
    hl.bind(mod .. ' + ' .. i, hl.dsp.focus { workspace = i })
    hl.bind(mod .. ' + SHIFT + ' .. i, hl.dsp.focus { workspace = 5 + i })
end

-- :> Move window to workspace
hl.define_submap('movews', 'reset', function()
    for i = 1, 5 do
        hl.bind(tostring(i), hl.dsp.window.move { workspace = i })
        hl.bind('SHIFT + ' .. i, hl.dsp.window.move { workspace = 5 + i })
    end

    hl.bind('escape', hl.dsp.submap 'reset')
end)
hl.bind(mod .. ' + W', hl.dsp.submap 'movews')

-- :> Screenshots
hl.bind('Print', hl.dsp.exec_cmd 'screenie')
hl.bind('SHIFT + Print', hl.dsp.exec_cmd 'screenie output')

-- :> Multimedia keys.
local el = { locked = true, repeating = true }
hl.bind('XF86AudioRaiseVolume', hl.dsp.exec_cmd 'wpctl set-volume -l 1.2 @DEFAULT_AUDIO_SINK@ 5%+', el)
hl.bind('XF86AudioLowerVolume', hl.dsp.exec_cmd 'wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-', el)
hl.bind('XF86AudioMute', hl.dsp.exec_cmd 'wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle', el)
hl.bind('XF86AudioMicMute', hl.dsp.exec_cmd 'wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle', el)
hl.bind('XF86MonBrightnessDown', hl.dsp.exec_cmd 'brightnessctl set 10%-', el)
hl.bind('XF86MonBrightnessUp', hl.dsp.exec_cmd 'brightnessctl set 10%+', el)

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mod .. ' + mouse:272', hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. ' + mouse:273', hl.dsp.window.resize(), { mouse = true })

hl.gesture {
    fingers = 3,
    direction = 'vertical',
    action = 'workspace'
}

local hostname = require 'config.local.hostname'

if hostname == 'RioTinto' then
    -- Outputs
    local primary    = 'desc:LG Electronics LG ULTRAWIDE 0x000769E5'
    local secondary  = 'desc:ONN 100002487'
    local television = 'desc:Samsung Electric Company SAMSUNG 0x01000E00'

    hl.on('hyprland.start', function()
        hl.exec_cmd 'openrgb -p main'
        hl.exec_cmd 'xrandr --output DP-2 --primary'
        hl.exec_cmd('brave', { workspace = '6', })
        hl.exec_cmd 'steam -silent'
    end)

    -- Primary Monitor (Ultrawide)
    hl.monitor {
        output = primary,
        mode = '2560x1080@75',
        position = '0x0',
        scale = '1.0',
    }

    -- Second Monitor
    hl.monitor {
        output = secondary,
        mode = '1920x1080',
        position = '320x-1080',
        scale = '1.0',
    }

    -- TV
    hl.monitor {
        output = television,
        mode = '1920x1080@60',
        position = '-1920x0',
        scale = '1.0',
    }

    -- Workspace Partitioning
    for i = 1, 5 do
        hl.workspace_rule { workspace = tostring(i), monitor = primary }
        hl.workspace_rule { workspace = tostring(i + 5), monitor = secondary }
    end

    hl.workspace_rule {
        workspace = '1',
        monitor = primary,
        default = true,
    }

    hl.workspace_rule {
        workspace = '6',
        monitor = secondary,
        default = true,
        persistent = true,
    }

    hl.workspace_rule {
        workspace = '7',
        on_created_empty = 'kitty btop',
    }

    -- Toggles the active window between the TV and the previous monitor.
    hl.bind('SUPER + G', function()
        local gws_id = 11
        local gws = hl.get_workspace(gws_id)

        if gws and gws.windows > 0 then
            hl.dispatch(hl.dsp.focus { workspace = gws_id })
            hl.dispatch(hl.dsp.window.move {
                workspace = 'previous',
            })
        else
            hl.dispatch(hl.dsp.window.move {
                workspace = gws_id,
            })
        end
    end)
end

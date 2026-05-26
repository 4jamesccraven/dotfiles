require 'generated.local'
require 'config.settings'
require 'config.binds'
require 'config.window-rules'
require 'config.anim'

hl.on('hyprland.start', function()
    hl.exec_cmd 'systemctl --user start hyprland-session.target'
    hl.exec_cmd 'hyprctl setcursor Dracula-cursors 22'
    hl.exec_cmd 'blueman-applet'
end)

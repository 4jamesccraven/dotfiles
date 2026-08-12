require 'generated.local'
require 'config.settings'
require 'config.binds'
require 'config.anim'
require 'config.float-rules'
require 'config.window-rules'

hl.on('hyprland.start', function()
    hl.exec_cmd 'hyprctl setcursor Dracula-cursors 22'
    hl.exec_cmd 'blueman-applet'
end)

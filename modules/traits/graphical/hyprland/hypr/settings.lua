local theme = require 'generated.theme'.gradient
hl.env('GDK_SCALE', '2')
hl.env('XCURSOR_SIZE', '22')

hl.config {
    ---[ General ]---
    general = {
        border_size = 3,
        gaps_in = 5,
        gaps_out = {
            top    = 10,
            bottom = 10,
            left   = 5,
            right  = 10,
        },
        col = {
            active_border = theme.accent,
            inactive_border = theme.base,
        }
    },

    ---[ Appearance ]---
    decoration = {
        active_opacity = 0.95,
        inactive_opacity = 0.90,
        rounding = 10,
    },
    dwindle = {
        preserve_split = true,
    },
    animations = {
        enabled = true,
    },

    ---[ Input ]---
    input = {
        -- :> Scrolling
        natural_scroll = false,
        numlock_by_default = true,
        touchpad = {
            natural_scroll = false,
        },

        -- :> XKB
        kb_layout = 'us,es',
        kb_options = 'grp:alt_shift_toggle',
    },

    ---[ Remove Annoyances ]---
    ecosystem = {
        no_update_news = true,
        no_donation_nag = true,
    },
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        middle_click_paste = false,
    },
}

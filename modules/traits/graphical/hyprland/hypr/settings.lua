local theme = require('generated.theme').gradient
hl.env('GDK_SCALE', '2')
hl.env('XCURSOR_SIZE', '22')

hl.config {
    ---[ General ]---
    general = {
        border_size = 3,
        gaps_in = 5,
        gaps_out = {
            top = 20,
            bottom = 20,
            left = 10,
            right = 20,
        },
        col = {
            active_border = theme.accent,
            inactive_border = theme.base,
        },
        resize_on_border = false,
    },

    ---[ Appearance ]---
    dwindle = {
        preserve_split = true,
    },
    decoration = {
        rounding         = 10,
        active_opacity   = 0.95,
        inactive_opacity = 0.90,
    },
    animations = {
        enabled = true,
    },

    ---[ Input ]---
    input = {
        kb_layout = 'us,es',
        kb_options = 'grp:alt_shift_toggle',
        natural_scroll = false,
        numlock_by_default = true,

        touchpad = {
            natural_scroll = false,
        },
    },

    ---[ Remove Annoyances ]---
    ecosystem = {
        no_update_news = true,
        no_donation_nag = true,
    },
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo = true,
        middle_click_paste = false,
    },
}

{
  pkgs,
  lib,
  config,
  ...
}:

/*
  ====[ Hyprland/binds ]====
  :: In trait `Graphical`
  Keybinds for managing windows etc. in Hyprland.
*/
{
  config = lib.mkIf config.hyprland.enable {
    environment.systemPackages = with pkgs; [
      brightnessctl
    ];

    home-manager.users.jamescraven = {
      wayland.windowManager.hyprland =
        let
          defaultTerm = config.ext.term;
          runTerm = defaultTerm.runCmds;
          terminal = defaultTerm.bin;
        in
        {
          settings = {
            "$mod" = "SUPER";

            bind = [
              # :> General
              "$mod, Q, killactive"
              "$mod, E, exec, nautilus"
              "Alt_L, Space, exec, fuzzel"
              "$mod, Return, exec, ${terminal}"
              "Control_L+Shift, Escape, exec, ${runTerm} btop"

              # :> Fullscreen control
              "$mod, M, fullscreen, 1"
              "$mod+Shift, M, fullscreen, 0"

              # :> Float
              "$mod, F, togglefloating"
              "$mod, F, resizeactive, exact 65% 65%"
              "$mod, F, centerwindow"

              # :> Minimize trick
              "$mod, Z, togglespecialworkspace, mincontainer"
              "$mod, Z, movetoworkspace, +0"
              "$mod, Z, togglespecialworkspace, mincontainer"
              "$mod, Z, movetoworkspace, special:mincontainer"
              "$mod, Z, togglespecialworkspace, mincontainer"

              # :> System Power
              "$mod, L, exec, hyprlock"
              "$mod, V, exec, hyprshutdown"
              "$mod+Shift, V, exec, shutdown now"

              # :> Window Focus
              "Alt_L, H, movefocus, l"
              "Alt_L, J, movefocus, d"
              "Alt_L, K, movefocus, u"
              "Alt_L, L, movefocus, r"
              "Alt_L, TAB, cyclenext, visible"

              # :> Move Window
              "$mod+Shift, H, movewindow, l"
              "$mod+Shift, J, movewindow, d"
              "$mod+Shift, K, movewindow, u"
              "$mod+Shift, L, movewindow, r"

              # :> Change Workspace
              "$mod, 1, workspace, 1"
              "$mod, 2, workspace, 2"
              "$mod, 3, workspace, 3"
              "$mod, 4, workspace, 4"
              "$mod, 5, workspace, 5"
              "$mod+shift, 1, workspace, 6"
              "$mod+shift, 2, workspace, 7"
              "$mod+shift, 3, workspace, 8"
              "$mod+shift, 4, workspace, 9"
              "$mod+shift, 5, workspace, 10"

              # :> Submaps
              "$mod, w, submap, movews"
              "$mod, r, submap, resize"

              # :> Change Keyboard Layouts
              "Alt_L, Shift_L, exec, hyprctl switchxkblayout current next"

              # Screenshots
              ", Print, exec, ${pkgs.screenie}/bin/screenie output"
              "Shift_L, Print, exec, ${pkgs.screenie}/bin/screenie"
            ];

            bindel = [
              # :> Sound
              ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
              ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
              # :> Screen Brightness
              ", XF86MonBrightnessDown, exec, brightnessctl set 10%-"
              ", XF86MonBrightnessUp, exec, brightnessctl set 10%+"
            ];

            bindl = [
              # :> Sound
              ", XF86AudioRaiseVolume, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ 0"
              ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
              # Lock on lid close
              ", switch:Lid Switch, exec, hyprlock"
            ];

            bindm = [
              # :> Window Manipulation
              "$mod, mouse:272, movewindow"
              "$mod, mouse:273, resizewindow"
            ];
          };

          # :> Submaps for moving windows and resizing
          extraConfig = /* hyprlang */ ''
            submap = movews
            bind = , 1, movetoworkspace, 1
            bind = , 1, submap, reset
            bind = , 2, movetoworkspace, 2
            bind = , 2, submap, reset
            bind = , 3, movetoworkspace, 3
            bind = , 3, submap, reset
            bind = , 4, movetoworkspace, 4
            bind = , 4, submap, reset
            bind = , 5, movetoworkspace, 5
            bind = , 5, submap, reset

            bind = Shift_L, 1, movetoworkspace, 6
            bind = Shift_L, 1, submap, reset
            bind = Shift_L, 2, movetoworkspace, 7
            bind = Shift_L, 2, submap, reset
            bind = Shift_L, 3, movetoworkspace, 8
            bind = Shift_L, 3, submap, reset
            bind = Shift_L, 4, movetoworkspace, 9
            bind = Shift_L, 4, submap, reset
            bind = Shift_L, 5, movetoworkspace, 10
            bind = Shift_L, 5, submap, reset

            bind = , escape, submap, reset
            submap = reset

            submap = resize
            binde = , l, resizeactive, 10 0
            binde = , h, resizeactive, -10 0
            binde = , k, resizeactive, 0 -10
            binde = , j, resizeactive, 0 10
            bind = , escape, submap, reset
            submap = reset
          '';
        };
    };
  };
}

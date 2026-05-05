{
  pkgs,
  config,
  lib,
  ...
}:

/*
  ====[ Hyprland/Default ]====
  :: In trait `Graphical`
  Defines a NixOS module that enables and configures Hyprland.
*/
{
  imports = [
    # keep-sorted start
    ./binds.nix
    ./fuzzel.nix
    ./hyprlock.nix
    ./hyprpaper.nix
    ./quickshell.nix
    ./window-rules.nix
    # keep-sorted end
  ];

  options = {
    hyprland.enable = lib.mkEnableOption "Enable Hyprland";
  };

  config = lib.mkIf config.hyprland.enable {
    # Enable in *NixOS*
    programs.hyprland.enable = true;

    environment.systemPackages = with pkgs; [
      hyprshutdown
      pavucontrol
    ];

    home-manager.users.jamescraven = {
      wayland.windowManager.hyprland = {
        enable = true; # Enable in *home-manager*

        settings = {
          # ---[ Startup ]----
          exec-once = [
            "hyprctl setcursor Dracula-cursors 22"
            "fcitx5 -d"
          ];

          # ---[ Compatibility ]---
          env = [
            "GDK_SCALE, 2"
            "XCURSOR_SIZE, 22"
          ];
          xwayland.force_zero_scaling = true;

          # ---[ Input ]---
          input = {
            kb_layout = "us,es,kr"; # English, Spanish, & Korean
            natural_scroll = false;
            numlock_by_default = true;

            touchpad = {
              natural_scroll = false;
            };
          };

          # ---[ Appearance ]---
          # :> Border Colours
          general =
            let
              inherit (config.ext) colours;
              active = "rgba(${colours.accent.hex}ff)";
              inactive = "rgba(${colours.base.hex}ff)";
            in
            {
              border_size = 3;
              gaps_in = "5";
              gaps_out = "20 20 20 10";
              "col.active_border" = active;
              "col.inactive_border" = inactive;
              resize_on_border = true;
            };

          # :> Window Decoration
          decoration = {
            rounding = "10";
            active_opacity = "0.95";
            inactive_opacity = "0.90";
          };

          animation = [ "workspaces, 1, 5, default, slidevert" ];

          # ---[ Disable Annoyances ]---
          # :> Disable default wallpapers
          misc = {
            disable_hyprland_logo = true;
            middle_click_paste = false;
          };
          # :> Disable popups
          ecosystem = {
            no_update_news = true;
            no_donation_nag = true;
          };

        }; # settings
      };
    }; # home-manager

  }; # config
}

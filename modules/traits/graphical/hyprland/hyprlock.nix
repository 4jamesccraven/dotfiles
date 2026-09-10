{ config, lib, ... }:

/*
  ====[ Hyprlock ]====
  :: In trait `Graphical`
  Config for hyprlock, a lock screen for hyprland.
*/
let
  inherit (config.ext) colours;
  inherit (lib.ext.colour) funcRGBFmt;

  colourVars = lib.genAttrs [
    "base"
    "accent"
    "text"
    "fail"
    "crust"
  ] (name: funcRGBFmt colours."${name}");

  font_family = "Overpass";
in
with colourVars;
{
  config = lib.mkIf config.ext.hyprland.enable {
    home-manager.users.jamescraven = {
      programs.hyprlock = {
        enable = true;

        settings = {
          # :> General
          background = {
            monitor = "";
            color = crust;

            blur_passes = 2;
          };

          # ---[ Contents ]---
          # :> Time & Date
          label = [
            {
              monitor = "";
              text = "$TIME";
              font_size = 95;
              inherit font_family;

              halign = "center";
              valign = "center";
              position = "0, 10%";

              color = accent;
            }

            {
              monitor = "";
              text = "cmd[update:1000] echo $(date '+%a, %d %B')";
              font_size = 25;
              inherit font_family;

              halign = "center";
              valign = "center";
              position = "0, 2%";

              color = text;
            }
          ];

          # :> Password Box
          input-field = {
            monitor = "";
            size = "10%, 4%";
            fade_on_empty = false;

            halign = "center";
            valign = "center";
            position = "0, -10%";

            outer_color = accent;
            inner_color = base;
            font_color = text;
            check_color = text;
            fail_color = fail;
          };
        };
      };
    };
  };
}

{ config, lib, ... }:

/*
  ====[ Hyprpaper ]====
  :: In trait `Graphical`
  Config for hyprpaper, a wallpaper daemon for hyprland.
*/
{
  config = lib.mkIf config.ext.hyprland.enable {
    home-manager.users.jamescraven = {
      services.hyprpaper = {
        enable = true;

        settings =
          let
            inherit (config.ext) flakeRoot;
            wp-path = "${flakeRoot + /assets/wp-wide.png}";
          in
          {
            splash = false;

            wallpaper = [
              {
                monitor = ""; # All monitors
                path = "${wp-path}";
              }
            ];
          };
      };
    };
  };
}

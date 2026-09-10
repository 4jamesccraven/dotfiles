{ config, lib, ... }:

/*
  ====[ quickshell ]====
  :: dotfile

  Enables and configures quickshell.
*/
{
  config = lib.mkIf config.ext.hyprland.enable {
    home-manager.users.jamescraven =
      { config, ... }:
      let
        inherit (config.home) homeDirectory;
      in
      {
        programs.quickshell = {
          enable = true;
          systemd.enable = true;
        };
        xdg.configFile."quickshell".source =
          config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/nixos/modules/traits/graphical/hyprland/qs";
      };
  };
}

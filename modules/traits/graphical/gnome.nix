{
  pkgs,
  lib,
  config,
  ...
}:

/*
  ====[ GNOME ]====
  :: In trait `Graphical`
  Defines a module that enables and configures GNOME
*/
{
  options.ext = {
    gnome.enable = lib.mkEnableOption "Enables gnome";
  };

  config = lib.mkIf config.ext.gnome.enable {
    # ---[ Enable and Configure GNOME Base ]---
    services.desktopManager.gnome.enable = true;
    # Exclude unnecessary packages (i.e., bloat)
    environment.gnome.excludePackages = with pkgs; [
      decibels
      epiphany
      geary
      gnome-calculator
      gnome-calendar
      gnome-clocks
      gnome-connections
      gnome-console
      gnome-contacts
      gnome-maps
      gnome-music
      gnome-system-monitor
      gnome-text-editor
      gnome-tour
      gnome-weather
      loupe
      papers
      showtime
      simple-scan
      snapshot
      totem
      yelp
    ];

    # ---[ Theming ]---
    # :> Extensions
    environment.systemPackages = with pkgs.gnomeExtensions; [
      user-themes
    ];

    # :> Set shell theme (GTK) and wallpaper using DCONF
    programs.dconf.enable = true;
    home-manager.users.jamescraven = {
      dconf.settings = {
        # Force enable user-themes extension
        "org/gnome/shell" = {
          disable-user-extensions = false;
          disabled-extensions = [ ];
          enabled-extensions = [
            "user-theme@gnome-shell-extensions.gcampax.github.com"
          ];
        };

        # Set shell theme
        "org/gnome/shell/extensions/user-theme" = {
          name = "catppuccin-mocha-mauve-standard";
        };

        # Set wallpaper
        "org/gnome/desktop/background" = {
          picture-uri = "file:///home/jamescraven/nixos/assets/wp-wide.png";
          picture-uri-dark = "file:///home/jamescraven/nixos/assets/wp-wide.png";
        };
      };
    };
  };

}

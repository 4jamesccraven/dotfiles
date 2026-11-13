{ pkgs, ... }:

/*
  ====[ GTK ]====
  :: dotfile

  Configures Colour Theme, Icon Theme, and Cursor Theme with GTK applications.
*/
{
  programs.dconf.enable = true;
  home-manager.users.jamescraven =
    let
      theme = {
        name = "catppuccin-mocha-mauve-standard";
        package = pkgs.catppuccin-gtk.override {
          accents = [ "mauve" ];
          variant = "mocha";
          size = "standard";
        };
      };
    in
    {
      gtk = {
        enable = true;

        inherit theme;
        gtk4 = {
          inherit theme;
        };

        iconTheme = {
          name = "Papirus-Dark";
          package = pkgs.catppuccin-papirus-folders.override {
            flavor = "mocha";
            accent = "mauve";
          };
        };

        cursorTheme = {
          name = "Dracula-cursors";
          package = pkgs.dracula-cursors;
        };
      };

      dconf = {
        settings."org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
        };
      };
    };
}

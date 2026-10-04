{ pkgs, lib, ... }:

/*
  ====[ qt ]====
  :: dotfile

  Configures system colour theme for qt applications.
*/
let
  variant = "mocha";
  accent = "mauve";
  catppuccinKvantum = pkgs.catppuccin-kvantum.override {
    inherit variant accent;
  };
  themeName = "catppuccin-${variant}-${accent}";
in
{
  home-manager.users.jamescraven = {
    qt =
      let
        # Settings for qt{5,6}ct
        Appearance = {
          custom_palette = false;
          style = "kvantum";
          standard_dialogs = "default";
        };
      in
      {
        enable = true;
        platformTheme.name = "qtct";
        style.name = "kvantum";
      }
      # Set the appearance settings for both qt5ct _and_ qt6ct
      // (lib.genAttrs
        [
          "qt5ctSettings"
          "qt6ctSettings"
        ]
        (_: {
          inherit Appearance;
        })
      );

    xdg.configFile = {
      # Set the kvantum theme
      "Kvantum/kvantum.kvconfig".text = /* ini */ ''
        [General]
        theme=${themeName}
      '';

      # Link the theme into .config
      "Kvantum/${themeName}".source = "${catppuccinKvantum}/share/Kvantum/${themeName}";
    };
  };
}

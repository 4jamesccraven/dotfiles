{ config, lib, ... }:

/*
  ====[ Fuzzel ]====
  :: In trait `Graphical`
  Config for Fuzzel, an application launcher.
*/
{
  config = lib.mkIf config.ext.hyprland.enable {
    home-manager.users.jamescraven =
      let
        inherit (config.ext) colours;
        base = "${colours.base.hex}ff";
        accent = "${colours.accent.hex}ff";
        text = "${colours.text.hex}ff";
        surface-0 = "${colours.surface-0.hex}ff";
        term = config.ext.term.runCmds;
      in
      {
        programs.fuzzel = {
          enable = true;

          settings = {
            # :> General
            main = {
              font = "FiraCode Nerd Font Mono:size=11";
              icon-theme = "Papirus-Dark";
              terminal = "${term}";
            };
            border.width = 3;

            # :> Colours
            colors = {
              inherit text;
              background = base;
              prompt = accent;

              match = text;
              border = surface-0;

              selection = accent;
              selection-match = base;
              selection-text = base;
            };
          };
        };
      };
  };
}

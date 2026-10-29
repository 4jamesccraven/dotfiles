{ ... }:

/*
  ====[ Kitty ]====
  :: dotfile

  Enables and configures kitty, a terminal emulator.
*/
{
  home-manager.users.jamescraven = {
    programs.kitty = {
      enable = true;

      # :> Font Settings
      font = {
        name = "FiraCode Nerd Font Mono";
        size = 11.75;
      };

      # :> Colour Theme
      themeFile = "Catppuccin-Mocha";

      # :> Miscellaneous Settings
      settings = {
        background_opacity = "1";
        font_features = "FiraCodeNFM-Reg +ss02";
      };
    };
  };
}

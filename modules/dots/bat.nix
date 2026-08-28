{ pkgs, lib, ... }:

/*
  ====[ Bat ]====
  :: dotfile

  Enables bat and installs a catppuccin theme for it.
*/
let
  variant = "mocha";
  themePkg = pkgs.catppuccin-bat.override {
    variants = [ variant ];
  };
  themeName = "Catppuccin ${lib.toSentenceCase variant}";
in
{
  home-manager.users.jamescraven = {
    programs.bat = {
      enable = true;

      themes.${themeName}.src = "${themePkg}/${themeName}.tmTheme";

      config.theme = "${themeName}";
    };

    home.shellAliases = {
      cat = "bat";
      lsblk = "lsblk | bat -l tcl -pp"; # Gives pseudo-syntax highlighting to lsblk
    };
  };
}

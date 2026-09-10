{ pkgs, lib, ... }:

/*
  ====[ Yazi ]====
  :: dotfile

  Enables and configures yazi, a terminal file manager.
*/
let
  # ---[ Theme ]---
  # :> Top-level variables
  variant = "mocha";
  accent = "mauve";

  # :> Packages
  # Get path to theme file
  themePkg = pkgs.catppuccin-yazi.override {
    variants = [ variant ];
    accents = [ accent ];
  };
  themeFile = "${themePkg}/catppuccin-${variant}-${accent}.toml";

  # Get path to syntax file
  syntaxPkg = pkgs.catppuccin-bat.override {
    variants = [ variant ];
  };
  syntaxFile = "${syntaxPkg}/Catppuccin ${lib.toSentenceCase variant}.tmTheme";

  # :> Final theme value
  # Convert the theme to nix values
  theme = fromTOML (builtins.readFile themeFile) // {
    # Patch in the bat theme file for the previewer pane
    mgr.syntect_theme = "${syntaxFile}";
  };
in
{
  # Hack to prevent the theme file from being garbage collected.
  system.activationScripts.cacheYaziSource.text = /* bash */ ''
    echo "${themeFile}" > /dev/null
  '';

  home-manager.users.jamescraven = {
    programs.yazi = {
      enable = true;

      inherit theme;

      # ---[ Disable Wrappers ]---
      # Suppresses a warning due to stateVersion <= 26.05
      shellWrapperName = "yy";
    }
    # I don't like the wrappers, nor do I want them.
    // (lib.pipe
      [ "Bash" "Fish" "Nushell" "Zsh" ]
      [
        (map (name: {
          name = "enable${name}Integration";
          value = lib.mkForce false;
        }))
        builtins.listToAttrs
      ]
    );
  };
}

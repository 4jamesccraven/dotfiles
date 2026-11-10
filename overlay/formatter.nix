{
  pkgs ? import <nixpkgs> { },
  lib ? pkgs.lib,
  ...
}:

/*
  ====[ Treefmt ]====
  :: dotfile

  A custom formatter for this flake, and everything else in the repo.

  This is damn-near ripped from isabelroses's dotfiles. Huge shoutout to her.
  <https://github.com/isabelroses/dotfiles>
*/
pkgs.treefmt.withConfig {
  runtimeInputs = with pkgs; [
    # keep-sorted start
    deadnix
    keep-sorted
    nixfmt
    typos
    # keep-sorted end

    (writeShellScriptBin "statix" /* bash */ ''
      for file in "$@"; do
        ${lib.getExe statix} fix "$file"
      done
    '')
  ];

  settings = {
    tree-root-file = "README.md";

    formatter = {
      # keep-sorted start block=yes newline_separated=yes
      deadnix = {
        command = "deadnix";
        options = [ "--edit" ];
        includes = [ "*.nix" ];
      };

      keep-sorted = {
        command = "keep-sorted";
        includes = [ "*" ];
      };

      nixfmt = {
        command = "nixfmt";
        includes = [ "*.nix" ];
      };

      statix = {
        command = "statix";
        includes = [ "*.nix" ];
      };

      typos = {
        command = "typos";
        options = [ "--write-changes" ];
        includes = [
          "*.nix"
          "*.md"
        ];
        excludes = [
          "modules/dots/starship.nix" # variable names
        ];
      };
      # keep-sorted end
    };
  };
}

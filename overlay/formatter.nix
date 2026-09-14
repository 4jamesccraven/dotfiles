{
  pkgs ? import <nixpkgs> { },
  lib ? pkgs.lib,
  ...
}:

pkgs.treefmt.withConfig {
  runtimeInputs = with pkgs; [
    # keep-sorted start
    deadnix
    keep-sorted
    nixfmt
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
      # keep-sorted end
    };
  };
}

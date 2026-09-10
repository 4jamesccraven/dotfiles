{
  pkgs ? import <nixpkgs> { },
  lib ? pkgs.lib,
  variants ? [ "latte" ],
  ...
}:

with pkgs;
let
  validVariants = [
    "frappe"
    "latte"
    "macchiato"
    "mocha"
  ];

  pname = "catppuccin-tty";
in
lib.checkListOfEnum "${pname}: variants" validVariants variants

  stdenvNoCC.mkDerivation
  {
    inherit pname;
    version = "2024-09-24";

    src = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "tty";
      rev = "6dd8b99181f7347e6e3b381872897184ff231bc7";
      hash = "sha256-bVrK6fdWFhYe4l9JZqR79GM2Lf2iaHeO+i3+QuUc0Pc=";
    };

    postInstall = /* bash */ ''
      mkdir $out
      ${lib.toShellVar "flavours" variants}
      for flavour in "''${flavours[@]}"; do
          cp "$src/themes/$flavour.txt" $out
      done
    '';
  }

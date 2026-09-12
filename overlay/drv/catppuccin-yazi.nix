{
  pkgs ? import <nixpkgs> { },
  lib ? pkgs.lib,
  variants ? [ "frappe" ],
  accents ? [ "blue" ],
  ...
}:

let
  validVariants = [
    "frappe"
    "latte"
    "macchiato"
    "mocha"
  ];

  validAccents = [
    "blue"
    "flamingo"
    "green"
    "lavender"
    "maroon"
    "mauve"
    "peach"
    "pink"
    "red"
    "rosewater"
    "sapphire"
    "sky"
    "teal"
    "yellow"
  ];

  pname = "catppuccin-yazi";
in
lib.checkListOfEnum "${pname}: variants" validVariants variants lib.checkListOfEnum
  "${pname}: accents"
  validAccents
  accents

  pkgs.stdenvNoCC.mkDerivation
  {
    inherit pname;
    version = "2025-12-29";

    src = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "yazi";
      rev = "d62802be39210ea10e54b3e3b09735c6cb9e57c1";
      hash = "sha256-bwzEO8exoBwa19q+jnYjHkaamGl2mhfukIEhDfUCRGI=";
    };

    postInstall = ''
      mkdir $out
      ${lib.toShellVar "flavours" variants}
      ${lib.toShellVar "accents" accents}

      for flavour in "''${flavours[@]}"; do
          for accent in "''${accents[@]}"; do
              cp "$src/themes/$flavour/catppuccin-$flavour-$accent.toml" $out
          done
      done
    '';
  }

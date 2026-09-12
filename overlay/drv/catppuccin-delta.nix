{
  pkgs ? import <nixpkgs> { },
  ...
}:

pkgs.stdenvNoCC.mkDerivation {
  pname = "catppuccin-delta";
  version = "2025-10-14";

  src = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "delta";
    rev = "011516f5d14f66b771b3e716f29c77231e008c74";
    hash = "sha256-lztkxX9O41YossvRzpR7tqxMhDNT1Efy2JvkCwtsiXQ=";
  };

  postInstall = ''
    mkdir $out
    cp $src/catppuccin.gitconfig $out
  '';
}

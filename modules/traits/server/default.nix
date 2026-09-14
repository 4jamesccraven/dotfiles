{ pkgs, ... }:

/*
  ====[ Server ]====
  :: trait

  A physical machine that is headless, intended to run services.

  Enables:
    :> User Level
    dots     => A few handpicked dotfiles useful for working on a headless machine

    :> System Level
    avahi    => Allows other machines to find the server via local MDNS

    :> Config Level
    jellyfin => A media server for movies, series, and music
    kavita   => A media server for books, comics, and manga
    immich   => A media server for images and videos
*/
{
  imports = [
    # :> Super traits
    ../machine.nix
    # :> Components
    # keep-sorted start
    ../../dots/bat.nix
    ../../dots/git.nix
    ../../dots/lsd.nix
    ../../dots/yazi.nix
    ../../dots/zsh.nix
    ./immich.nix
    ./jellyfin.nix
    ./kavita.nix
    # keep-sorted end
  ];

  # ---[ Software ]---
  environment.systemPackages = with pkgs; [
    # :> File management
    dust
    dysk

    # :> CLI Tools
    fd
    ripgrep
    tor-dl
    zip
    unzip

    # :> System management
    git
    just
  ];
  programs.nh.enable = true;
  programs.zsh.enable = true;

  # ---[ Services ]---
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    ipv6 = false;

    publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };

    extraConfig = /* ini */ ''
      [publish]
      publish-a-on-ipv6=yes
    '';
  };
}

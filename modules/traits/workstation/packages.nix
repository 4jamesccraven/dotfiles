{
  pkgs,
  ...
}:

/*
  ====[ Packages ]====
  :: in trait `Workstation`
  The master package list for all general purpose workstation.

  Enables:
  - Browsers, Office Suite, Media, etc.
  - Fonts
  - Man caching
*/
{
  environment.systemPackages = with pkgs; [
    # ---[ GUI ]---
    # :> Internet & Communication
    brave
    telegram-desktop
    tor-browser

    # :> Media
    foliate
    makemkv
    obs-studio
    vlc

    # :> Office
    hunspell
    hunspellDicts.en_GB-large
    hunspellDicts.en_US-large
    hunspellDicts.es_AR
    hunspellDicts.es_ES
    libreoffice-qt
    qalculate-gtk

    # :> Music
    ardour
    musescore

    # :> Games
    (prismlauncher.override {
      jdks = [
        temurin-bin-8
        temurin-bin-17
        temurin-bin-21
        openjdk25
      ];
    })

    # ---[ CLI ]---
    # :> Coreutils-esque
    dust
    dysk
    fd
    just
    ripgrep

    # :> Other Utilities
    caligula
    ffmpeg-full
    file
    fzf
    gallery-dl
    jq
    libqalculate
    tokei
    tor-dl
    unzip
    wl-clipboard
    yt-dlp
    zip

    # :> Fun
    figlet
    rff

    # :> Scripts
    ns
    st-remote

    # ---[ Development ]---
    # :> Compilers
    libgcc
    rustc

    # :> Interpreters
    python314

    # :> Writing & Presenting
    typst
    typstyle

    # :> Project Management
    cargo
    gh
    git

    # :> Extra Docs
    man-pages
    man-pages-posix
  ];

  # ---[ Progam/Service-based ]---
  programs = {
    nh.enable = true;
    zsh.enable = true;
    direnv = {
      enable = true;
      loadInNixShell = true;
      nix-direnv.enable = true;
    };
  };
  services.blueman.enable = true;

  # ---[ Fonts ]---
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      # keep-sorted start
      corefonts
      liberation_ttf
      nerd-fonts.fira-code
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      overpass
      # keep-sorted end
    ];
    fontconfig.defaultFonts = {
      sansSerif = [ "Noto Sans" ];
      serif = [ "Noto Serif" ];
    };
  };

  # ---[ man ]---
  documentation.man = {
    enable = true;
    cache.enable = true;
  };

}

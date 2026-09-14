{ pkgs, ... }:

/*
  ====[ Gaming ]====
  :: trait

  Additional software and settings to facilitate running games and using
  common gaming hardward (e.g., peripherals, lighting).

  Enables
      :> System Level
      steam/heroic   => software for installing and running games;
      piper/ratbag   => software for managing mouse sensitivity;
      xpadneo        => drivers for controllers;
      openrgb        => rgb lighting support (technically not gaming specific);
      gamemode/scope => software for improving game peformance;
*/
{
  # ---[ Software Support ]---
  # :> Game stores
  programs.steam.enable = true;
  environment.systemPackages = with pkgs; [
    heroic
    piper # belongs w/ hardware

    # Minecraft isn't on any major store front.
    (prismlauncher.override {
      jdks = [
        temurin-bin-8
        temurin-bin-17
        temurin-bin-21
        openjdk25
      ];
    })
  ];
  # :> Performance
  programs.gamemode.enable = true;
  programs.gamescope.enable = true;

  # ---[ Hardware Support ]---
  # :> Mouse sensitivity
  services.ratbagd.enable = true;
  systemd.services.ratbagd.wantedBy = [ "multi-user.target" ];
  # :> RGB Lighting
  services.hardware.openrgb = {
    enable = true;
    package = pkgs.openrgb-with-all-plugins;
  };
  # :> Controller/Gamepad
  hardware.xpadneo.enable = true;

  # ---[ Game-specific ]---
  # Fix for Assassin's Creed contacting defunct servers:
  networking.extraHosts = ''
    # Redirect legacy Ubisoft servers to localhost to prevent game freezes
    216.98.48.18 127.0.0.1
    216.98.48.53 127.0.0.1
    216.98.48.57 127.0.0.1
    216.98.48.133 127.0.0.1
    216.98.48.134 127.0.0.1
  '';
}

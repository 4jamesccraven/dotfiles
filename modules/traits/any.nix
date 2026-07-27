{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:

/*
  ====[ Any ]====
  :: trait

  Base type of all configurations.

  Enables:
    :> User level
    neovim       => I have to edit text on all systems
    jamescraven  => Essentially all config assumes the existence of my main account

    :> Config level
    constants    => Global constants to make config less verbose and error prone
    home-manager => All systems use home manager
    shell cache  => All systems should cache the dev-shells at build time
    nix-settings => All systems use flakes and nix command
*/
{
  imports = [
    inputs.home-manager.nixosModules.default
    ./neovim.nix
    ../constants
  ];

  # ---[ User account ]---
  users.users.jamescraven = {
    isNormalUser = true;
    description = "James Craven";
    shell = pkgs.zsh;
    extraGroups = [
      "jellyfin"
      "kavita"
      "networkmanager"
      "wheel"
    ];
  };

  # ---[ Caching and Performance ]---
  # :> Caching
  /*
    This caches the dependencies of config-level devShells by making the name
    of each dependencies' store path a dependency of the system activation
    scripts. This is accomplished by simply echoing said path into /dev/null
    at activation time.
  */
  system.activationScripts.cacheFlakeShells.text =
    let
      inherit (lib.ext) mapFiles;
      inherit (config.ext) flakeRoot;

      /*
        echoPkgs :: package -> string
        Creates a string which echos a package name into /dev/null.
      */
      echoPkg = pkg: "echo \"${pkg}\" > /dev/null";

      # Read in the build input of each devShell
      shellInputs = mapFiles (
        name:
        let
          params = import (flakeRoot + /shells/${name}) { inherit pkgs; };
        in
        params.buildInputs
      ) (flakeRoot + /shells);

      # Convert each set of inputs into a list of `echo` commands, then flatten
      cacheCommands = lib.concatMap (map echoPkg) shellInputs;
    in
    lib.concatLines cacheCommands;
  # Add the flake formatter to packages so it's cached.
  environment.systemPackages = [ pkgs.ext.formatter ];

  # :> Optimisation
  # Remove unnecessary docs
  documentation = {
    doc.enable = false;
    info.enable = false;
  };

  # Remove unnecessary services
  services = {
    orca.enable = false;
    speechd.enable = false;
  };

  # ---[ Nix settings ]---
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.stateVersion = "23.11";
  home-manager.users.jamescraven =
    { ... }:
    {
      home.stateVersion = "24.05";
    };
}

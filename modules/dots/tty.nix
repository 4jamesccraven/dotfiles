{ pkgs, lib, ... }:

/*
  ====[ TTY ]====
  :: dotfile

  Configures the TTY colours to be catppuccin.
*/
let
  catppuccin-tty = pkgs.catppuccin-tty.override { variants = [ "mocha" ]; };
in
{
  environment.systemPackages = [ catppuccin-tty ];
  boot.kernelParams = lib.splitString " " (
    lib.trim (builtins.readFile "${catppuccin-tty}/mocha.txt")
  );
}

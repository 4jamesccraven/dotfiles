{ pkgs, ... }:

/*
  ====[ Graphical ]====
  :: trait

  A machine that has a Desktop Environment or Window Manager.

  Enables:
      :> System Level
      display manager    => GDM is enabled as the display manager for all graphical machines
      pipewire           => Necessary for sound to work
      xdg desktop portal => Facilitates file dialogs etc.

      :> Config Level
      hyprland           => Enablable NixOS module for hyprland
      gnome              => Enablable NixOS module for GNOME
*/
{
  imports = [
    # :> super traits
    ../machine.nix
    # :> trait omponents
    # keep-sorted start
    ./display-manager.nix
    ./gnome.nix
    ./hyprland
    # keep-sorted end
  ];

  # :> Pipewire et al.
  services = {
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };
  };
  security.rtkit.enable = true;

  # ---[ XDG Desktop Portal ]---
  xdg.portal = {
    enable = true;
    # Ensure GTK is installed and used no matter what
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
    config.common.default = [
      "gtk"
    ];
  };
}

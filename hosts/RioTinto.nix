{
  config,
  lib,
  modulesPath,
  pkgs,
  ...
}:

/*
  ====[ RioTinto ]====
  :: host

  My primary PC.

  Derives:
  - Workstation
  - Nvidia
  - Gaming
*/
{
  # ---[ Host ]---
  imports = [
    # keep-sorted start
    ../modules/traits/gaming.nix
    ../modules/traits/nvidia.nix
    ../modules/traits/workstation
    # keep-sorted end
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  networking.hostName = "RioTinto";

  # :> Graphical Settings
  gnome.enable = true;
  hyprland.enable = true;
  home-manager.users.jamescraven = {
    wayland.windowManager.hyprland = {
      settings = {
        exec-once = [
          "openrgb -p main"
          "${pkgs.xrandr}/bin/xrandr --output DP-3 --primary"
          "steam -silent"
        ];

        monitor = [
          "DP-3, 2560x1080@75, 0x0, 1.0"
          "HDMI-A-1, 1920x1080, 320x-1080, 1.0"
        ];

        workspace = [
          "1, monitor:DP-3, default:true"
          "6, monitor:HDMI-A-1, persistent:true, default:true, on-created-empty:brave"
        ];
      };
    };
  };

  # ---[ Hardware ] ---
  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "usbhid"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [
    "kvm-amd"
    "sg"
  ];
  boot.supportedFilesystems = [ "ntfs" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/f0dd881a-edd3-4cd9-af89-4398a8fffaa9";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/EB06-9759";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/2904deaf-0bd4-41a0-a791-ccf8f98035ae";
    fsType = "ext4";
  };

  fileSystems."/home/jamescraven/steam-nvme" = {
    device = "/steam";
    options = [ "bind" ];
    inherit (config.fileSystems."/") fsType;
  };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp42s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}

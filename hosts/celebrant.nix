{
  lib,
  config,
  modulesPath,
  ...
}:

/*
  ====[ Celebrant ]====
  :: host

  My laptop.

  Derives:
  - Workstation
*/
{
  # ---[ Host ]---
  imports = [
    ../modules/traits/workstation
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  networking.hostName = "celebrant";

  # ---[ Graphical Settings ]---
  ext = {
    displayManager = "ly";
    hyprland.enable = true;
  };

  # :> Stay awake with lid closed if there's external power.
  services.logind.settings.Login.HandleLidSwitchExternalPower = "ignore";

  # :> Steam without the extra stuff in the gaming module.
  programs.steam.enable = true;

  # ---[ Hardware ]---
  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "usb_storage"
    "sd_mod"
    "sdhci_pci"
  ];

  boot.initrd.kernelModules = [
    "dm-snapshot"
    "cryptd"
  ];

  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];
  boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-label/nixos";

  fileSystems."/" = {
    device = "/dev/disk/by-label/root";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-label/home";
    fsType = "ext4";
  };

  swapDevices = [
    { device = "/dev/disk/by-label/swap"; }
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}

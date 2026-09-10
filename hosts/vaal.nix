{
  lib,
  config,
  pkgs,
  modulesPath,
  ...
}:

/*
  ====[ Vaal ]====
  :: host

  My laptop from college. No longer a valid build target.

  Derives:
  - Workstation
*/
{
  # ---[ Host ]---
  imports = [
    ../modules/traits/workstation
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  networking.hostName = "vaal";

  # :> Extra Packages
  environment.systemPackages = with pkgs; [
    openvpn
  ];

  # :> Graphical Settings
  ext.hyprland.enable = true;
  # home-manager.users.jamescraven = { wayland.windowManager.hyprland.settings = { monitor = [ "eDP-1, 1920x1080, 0x0, 1.2" ]; }; };

  # ---[ Hardware ]---
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "thunderbolt"
    "vmd"
    "nvme"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/cc7987a3-46d3-4024-b795-8205be29aea1";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."cryptroot".device =
    "/dev/disk/by-uuid/3664fc25-34ed-47e6-99bc-0cef747cfdb5";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/2EA4-0D0E";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/c14dabe7-4b6a-4858-a24e-d8486ea3c7ef"; }
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s13f0u1.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}

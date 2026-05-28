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

  services.logind.settings.Login.HandleLidSwitchExternalPower = "ignore";

  hyprland.enable = true;
  home-manager.users.jamescraven = {
    xdg.configFile."hypr/generated/local.lua".text = /* lua */ ''
      hl.monitor {
          output = 'eDP-1',
          mode = '1920x1200',
          position = '0x0',
          scale = '1.2',
      }

      -- Dad's monitors (for connecting to his docking station).
      hl.monitor {
          output = 'desc:LG Electronics LG ULTRAGEAR 407NTXR69146',
          mode = 'preferred',
          position = '-2560x0',
          scale = 1,
      }

      hl.monitor {
          output = 'desc:Lenovo Group Limited LEN LI2323swA 31611F19G3389',
          mode = 'preferred',
          position = '-4480x0',
          scale = 1,
      }
    '';
  };

  programs.steam.enable = true;

  services.displayManager = {
    gdm.enable = lib.mkForce false;
    cosmic-greeter.enable = true;
  };

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

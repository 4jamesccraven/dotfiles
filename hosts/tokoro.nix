{
  config,
  inputs,
  lib,
  pkgs,
  modulesPath,
  ...
}:

/*
  ====[ Tokoro ]====
  :: host

  My media/file-backup server.

  Derives:
  - Server
  - Syncthing
  - Jellyfin
  - Kavita
*/
{
  # ---[ Host ]---
  imports = [
    inputs.egress.nixosModules.default
    # keep-sorted start
    ../modules/traits/server
    ../modules/traits/syncthing.nix
    # keep-sorted end
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  networking.hostName = "tokoro";

  # :> Optional Server Modules.
  ext.server = {
    immich.enable = true;
    jellyfin.enable = true;
    kavita.enable = true;
  };

  # :> Egressd
  services.egressd.enable = true;
  users.users.jamescraven.extraGroups = [ "egress" ];
  networking.firewall.allowedTCPPorts = [ 50925 ];

  # :> File backups
  services.borgbackup.jobs.main = {
    doInit = true;
    paths = [
      "/home/jamescraven/Audio/"
      "/home/jamescraven/Code/"
      "/home/jamescraven/Documents/"
      "/home/jamescraven/Pictures/"
    ];
    encryption = {
      mode = "none";
    };
    repo = "/home/jamescraven/back-ups/";
    compression = "lz4";
    startAt = "daily";
  };

  # :> cryptsetup
  environment.systemPackages = [ pkgs.cryptsetup ];

  # Creates a systemd target that is activated once /dev/mapper/cryptmedia
  # becomes available. Mounts the logical volumes inside then starts services
  # that need media from that drive.
  systemd.targets.media-unlocked = {
    wants = [
      "srv-media.mount"
      "home-jamescraven-back\\x2dups.mount"
      "jellyfin.service"
      "immich-server.service"
      "kavita.service"
      "borgbackup-job-main.timer"
    ];

    after = [
      "dev-mapper-cryptmedia.device"
    ];

    wantedBy = [
      "dev-mapper-cryptmedia.device"
    ];
  };

  # Remove all wantedBy symlinks for these services and have them
  # require /srv/media/
  systemd = {
    services = {
      jellyfin = {
        wantedBy = lib.mkForce [ ];
        unitConfig.RequiresMountsFor = "/srv/media";
      };

      immich-server = {
        wantedBy = lib.mkForce [ ];
        unitConfig.RequiresMountsFor = "/srv/media";
      };

      kavita = {
        wantedBy = lib.mkForce [ ];
        unitConfig.RequiresMountsFor = "/srv/media";
      };
    };

    timers."borgbackup-job-main".wantedBy = lib.mkForce [ ];
  };

  # ---[ Hardware ]---
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ehci_pci"
    "ahci"
    "nvme"
    "usb_storage"
    "usbhid"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  environment.etc.crypttab.text = ''
    cryptmedia UUID=cfa91ab5-f93c-41e0-b737-5a0ae52bfab4 - luks,noauto
  '';

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/348657e2-5557-4ddc-a77f-3c22ac3e78f2";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/E951-BC80";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  fileSystems."/srv/media" = {
    device = "/dev/disk/by-label/media";
    fsType = "ext4";
    options = [ "noauto" ];
  };

  fileSystems."/home/jamescraven/back-ups" = {
    device = "/dev/disk/by-label/backups";
    fsType = "ext4";
    options = [ "noauto" ];
  };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp2s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}

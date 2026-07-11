{ config, ... }:

/*
  ====[ Nvidia ]====
  :: trait

  A machine that has Nvidia graphics.

  Enables:
    :> System Level
    nvidia drivers => what it says on the tin
*/
{
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware = {
    graphics.enable = true;

    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.latest;
      modesetting.enable = true;
      powerManagement = {
        enable = false;
        finegrained = false;
      };

      open = false;
      nvidiaSettings = true;
    };
  };

  nixpkgs.overlays = [
    (_final: prev: {
      btop = prev.btop.override { cudaSupport = true; };
    })
  ];

}

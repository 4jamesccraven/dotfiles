{
  pkgs,
  config,
  lib,
  ...
}:

/*
  ====[ Jellyfin ]====
  :: in trait `Server`

  Configuration for Jellyfin media server.

  Enables:
    :> User Level
    group    => Add user to jellyfin group
    ffmpeg   => For debugging media issues & reformatting

    :> System Level
    Jellyfin => Media server
    nginx    => Reverse Proxy
    firewall => Opens 8096 locally and 50924 externally
*/
{
  options.ext.server = {
    jellyfin.enable = lib.mkEnableOption "Whether to enable and configure Jellyfin.";
  };

  config =
    let
      cfg = config.ext.server;
    in
    lib.mkIf cfg.jellyfin.enable {
      # ---[ Jellyfin ]---
      services.jellyfin = {
        enable = true;
        dataDir = "/srv/media/_jellyfin-state";
      };
      # Open the port to others
      networking.firewall.allowedTCPPorts = [
        8096
        50924
      ];
      users.users.jamescraven.extraGroups = [ "jellyfin" ];

      # ---[ nginx ]---
      services.nginx = {
        enable = true;
        virtualHosts."_" = {
          listen = [
            {
              addr = "0.0.0.0";
              port = 50924;
            }
          ];

          locations."/" = {
            proxyPass = "http://127.0.0.1:8096";
          };
        };
      };

      # ---[ ffmpeg ]---
      environment.systemPackages = with pkgs; [
        ffmpeg-full
      ];
    };
}

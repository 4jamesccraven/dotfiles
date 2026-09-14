{ config, lib, ... }:

/*
  ====[ immich ]====
  :: in trait `Server`

  Configuration for immich image server.

  Enables:
    :> User Level
    group    => Add user to immich group

    :> System Level
    immich   => Media server
    firewall => Opens 2283 locally
*/
{
  options.ext.server = {
    immich.enable = lib.mkEnableOption "Whether to enable and configure Immich.";
  };

  config =
    let
      cfg = config.ext.server;
    in
    lib.mkIf cfg.immich.enable {
      services.immich = {
        enable = true;
        host = "0.0.0.0";
        port = 2283; # This is the default.
      };

      networking.firewall.allowedTCPPorts = [ 2283 ];
      users.users.jamescraven.extraGroups = [ "immich" ];
    };
}

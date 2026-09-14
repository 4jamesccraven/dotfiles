{ config, lib, ... }:

/*
  ====[ Kavita ]====
  :: in trait `Server`

  Configuration for the Kavita reading server.

  Enables:
    :> User Level
    group    => Add user to kavita group

    :> System Level
    Kavita   => The reading server itself
    firewall => opens 5000 locally
*/
{
  options.ext.server = {
    kavita.enable = lib.mkEnableOption "Whether to enable and configure Kavita.";
  };

  config =
    let
      cfg = config.ext.server;
    in
    lib.mkIf cfg.kavita.enable {

      services.kavita = {
        enable = true;
        tokenKeyFile = "/var/lib/secrets/kavita-token";
      };

      networking.firewall.allowedTCPPorts = [ 5000 ];
      users.users.jamescraven.extraGroups = [ "kavita" ];
    };
}

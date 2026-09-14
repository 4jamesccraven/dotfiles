{ ... }:

/*
  ====[ immich ]====
  :: trait

  Configuration for immich image server.

  Enables:
    :> System Level
    immich => Media server
    firewall => Opens 8096 locally and 50924 externally
*/
{
  services.immich = {
    enable = true;
    host = "0.0.0.0";
    port = 2283; # This is the default.
  };

  networking.firewall.allowedTCPPorts = [ 2283 ];
}

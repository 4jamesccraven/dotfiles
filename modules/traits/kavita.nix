{ ... }:

/*
  ====[ Kavita ]====
  :: trait

  Configuration for the Kavita reading server.

  Enables:
    :> System Level
    Kavita   => The reading server itself
    firewall => opens 5000 locally
*/
{
  services.kavita = {
    enable = true;
    tokenKeyFile = "/var/lib/secrets/kavita-token";
  };

  networking.firewall.allowedTCPPorts = [
    5000
  ];
}

{ lib, config, ... }:

/*
  ====[ Display Manager ]====
  :: In trait `Graphical`
  Enables a graphical login menu/session picker.
*/
{
  options.ext =
    let
      cfgExt = config.ext;
    in
    {
      displayManager = lib.mkOption {
        description = "Which display manager config to use.";
        type = lib.types.enum [
          "gdm"
          "cosmic"
        ];
        default = if cfgExt.gnome.enable then "gdm" else "cosmic";
        example = "gdm";
      };
    };

  config =
    let
      inherit (config.ext) displayManager;
    in
    {
      services.displayManager = {
        gdm = {
          enable = displayManager == "gdm";
          autoSuspend = false;
        };

        cosmic-greeter.enable = displayManager == "cosmic";
      };
    };
}

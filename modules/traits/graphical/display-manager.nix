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
          "ly"
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

        ly = {
          enable = displayManager == "ly";
          x11Support = false;

          settings = {
            # :> Clock
            clock = "%a, %d %B";
            bigclock = "en";
            bigclock_12hr = false;
            bigclock_seconds = true;

            # :> Interface
            text_in_center = true;
            hide_version_string = true;

            # :> Input
            default_input = "password";
            vi_mode = true;
            vi_default_mode = "insert";

            # :> Wayland
            xsessions = null;
            xinitrc = null;
          };
        };
      };
    };
}

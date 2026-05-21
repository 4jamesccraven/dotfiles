{
  pkgs,
  config,
  lib,
  ...
}:

/*
  ====[ Hyprland/Default ]====
  :: In trait `Graphical`
  Defines a NixOS module that enables and configures Hyprland.
*/
{
  imports = [
    # keep-sorted start
    ./fuzzel.nix
    ./hyprlock.nix
    ./hyprpaper.nix
    ./quickshell.nix
    # keep-sorted end
  ];

  options = {
    hyprland.enable = lib.mkEnableOption "Enable Hyprland";
  };

  config = lib.mkIf config.hyprland.enable {
    # Enable in *NixOS*
    programs.hyprland = {
      enable = true;
      withUWSM = true;
    };

    environment.systemPackages = with pkgs; [
      # keep-sorted start
      brightnessctl
      hyprshutdown
      pavucontrol
      screenie
      # keep-sorted end
    ];

    environment.pathsToLink = [ "/share/hypr" ];

    home-manager.users.jamescraven =
      let
        cfg = config;
      in
      { config, ... }:
      {
        # :> Hook in other systemd user units from hm
        systemd.user.targets.hyprland-session = {
          Unit = {
            Description = "Hyprland session";
            BindsTo = [ "graphical-session.target" ];
            Wants = [ "graphical-session-pre.target" ];
            After = [ "graphical-session-pre.target" ];
          };
        };

        # Stub to point hyprland to the config subdirectory.
        xdg.configFile."hypr/hyprland.lua".text = /* lua */ ''
          require('config')
        '';

        # Symlink the actual config directory.
        xdg.configFile."hypr/config".source =
          let
            inherit (config.home) homeDirectory;
          in
          config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/nixos/modules/traits/graphical/hyprland/hypr";

        # Expose catppuccin as a lua table in the format hyprland likes to use.
        xdg.configFile."hypr/generated/theme.lua".text =
          let
            inherit (cfg.ext) colours;
            toHyprFunc = col: "rgb(${col.hex})";
            toHyprGrad = col: "rgba(${col.hex}ff)";
            luaDecl = name: val: "        [\"${name}\"] = '${val}',";

            mkTable = vals: ''
              {
              ${lib.concatLines vals}
                  }'';

            mkColourTable =
              fmtFunc:
              lib.pipe colours [
                (builtins.mapAttrs (_: fmtFunc))
                (lib.mapAttrsToList luaDecl)
                mkTable
              ];

            cols = mkColourTable toHyprFunc;
            grads = mkColourTable toHyprGrad;
          in
          /* lua */ ''
            local theme = {
                colour = ${cols},
                gradient = ${grads}
            }
            return theme
          '';

        # Expose the terminal config.
        xdg.configFile."hypr/generated/terminal.lua".text =
          let
            inherit (cfg.ext) term;
            terminal = term.bin;
            runInTerm = term.runCmds;
          in
          /* lua */ ''
            local term = {
                name = '${terminal}',
                run_in_term = '${runInTerm}',
            }
            return term
          '';
      };

  };
}

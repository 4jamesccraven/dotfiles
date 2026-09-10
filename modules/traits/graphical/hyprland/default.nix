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
    # ./fuzzel.nix
    ./hyprlock.nix
    ./hyprpaper.nix
    ./quickshell.nix
    ./walker.nix
    # keep-sorted end
  ];

  options.ext.hyprland = {
    enable = lib.mkEnableOption "Enable Hyprland";
    localConfig = lib.mkOption {
      description = "Host specific config to be linked to the path `generated/local.lua`.";
      default = "";
      type = lib.types.str;
      example = /* lua */ ''
        hl.on('hyprland.start', function()
            hl.exec_cmd 'openrgb -p main'
        end
      '';
    };
  };

  config = lib.mkIf config.ext.hyprland.enable {
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
      { ... }@hmArgs:
      let
        hmCfg = hmArgs.config;
      in
      {
        # Stub to point hyprland to the config subdirectory.
        xdg.configFile."hypr/hyprland.lua".text = /* lua */ ''
          require 'config'
        '';

        # Symlink the actual config directory.
        xdg.configFile."hypr/config".source =
          let
            inherit (hmCfg.home) homeDirectory;
          in
          hmCfg.lib.file.mkOutOfStoreSymlink "${homeDirectory}/nixos/modules/traits/graphical/hyprland/hypr";

        xdg.configFile."hypr/generated/local.lua".text = config.ext.hyprland.localConfig;

        # Expose catppuccin as a lua table in the format hyprland likes to use.
        xdg.configFile."hypr/generated/theme.lua".text =
          let
            inherit (config.ext) colours;
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
            inherit (config.ext) term;
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

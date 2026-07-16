{
  pkgs,
  config,
  lib,
  ...
}:

/*
  ====[ Walker ]====
  :: In trait `Graphical`
  Config for Walker, an application launcher.
*/
{
  config = lib.mkIf config.hyprland.enable {
    home-manager.users.jamescraven = {
      services.elephant.enable = true;

      services.walker = {
        enable = true;
        systemd.enable = true;

        settings = {
          keybinds = {
            quick_activate = [
              "ctrl 1"
              "ctrl 2"
              "ctrl 3"
              "ctrl 4"
            ];
          };

          providers.prefixes = [
            # keep-sorted start block=yes
            {
              prefix = "!!";
              provider = "providerlist";
            }
            {
              prefix = "!c";
              provider = "clipboard";
            }
            {
              prefix = "!e";
              provider = "symbols";
            }
            {
              prefix = "!f";
              provider = "files";
            }
            {
              prefix = "!r";
              provider = "runner";
            }
            {
              prefix = "!u";
              provider = "unicode";
            }
            {
              prefix = "!win";
              provider = "windows";
            }
            {
              prefix = "@";
              provider = "websearch";
            }
            {
              prefix = "__";
              provider = "todo";
            }
            # keep-sorted end
          ];
        };

        theme = {
          /*
            Theme from https://github.com/krymancer/walker.
            See repo for license.
          */
          name = "catppuccin-mocha";
          style = /* css */ ''
            /* Catppuccin Mocha */
            @define-color rosewater #f5e0dc;
            @define-color flamingo #f2cdcd;
            @define-color pink #f5c2e7;
            @define-color mauve #cba6f7;
            @define-color red #f38ba8;
            @define-color maroon #eba0ac;
            @define-color peach #fab387;
            @define-color yellow #f9e2af;
            @define-color green #a6e3a1;
            @define-color teal #94e2d5;
            @define-color sky #89dceb;
            @define-color sapphire #74c7ec;
            @define-color blue #89b4fa;
            @define-color lavender #b4befe;
            @define-color text #cdd6f4;
            @define-color subtext1 #bac2de;
            @define-color subtext0 #a6adc8;
            @define-color overlay2 #9399b2;
            @define-color overlay1 #7f849c;
            @define-color overlay0 #6c7086;
            @define-color surface2 #585b70;
            @define-color surface1 #45475a;
            @define-color surface0 #313244;
            @define-color base #1e1e2e;
            @define-color mantle #181825;
            @define-color crust #11111b;

            * {
              all: unset;
            }

            .normal-icons {
              -gtk-icon-size: 16px;
            }

            .large-icons {
              -gtk-icon-size: 32px;
            }

            scrollbar {
              opacity: 0;
            }

            .box-wrapper {
              box-shadow:
                0 19px 38px rgba(0, 0, 0, 0.3),
                0 15px 12px rgba(0, 0, 0, 0.22);
              background: @base;
              padding: 20px;
              border-radius: 20px;
              border: 1px solid @crust;
            }

            .preview-box,
            .elephant-hint,
            .placeholder {
              color: @text;
            }

            .search-container {
              border-radius: 10px;
              background: @mantle;
              padding: 8px;
            }

            .input placeholder {
              opacity: 0.5;
            }

            .input selection {
              background: @surface1;
            }

            .input {
              caret-color: @text;
              background: none;
              padding: 10px;
              color: @text;
            }

            .list {
              color: @text;
            }

            .item-box {
              border-radius: 10px;
              padding: 10px;
            }

            .item-quick-activation {
              background: alpha(@mauve, 0.25);
              border-radius: 5px;
              padding: 10px;
            }

            child:selected .item-box,
            row:selected .item-box {
              background: alpha(@surface0, 0.6);
            }

            .item-subtext {
              font-size: 12px;
              opacity: 0.5;
            }

            .providerlist .item-subtext {
              font-size: unset;
              opacity: 0.75;
            }

            .item-image-text {
              font-size: 28px;
            }

            .preview {
              border: 1px solid alpha(@mauve, 0.25);
              border-radius: 10px;
              color: @text;
            }

            .calc .item-text {
              font-size: 24px;
            }

            .symbols .item-image {
              font-size: 24px;
            }

            .todo.done .item-text-box {
              opacity: 0.25;
            }

            .todo.urgent {
              font-size: 24px;
            }

            .todo.active {
              font-weight: bold;
            }

            .bluetooth.disconnected {
              opacity: 0.5;
            }

            .preview .large-icons {
              -gtk-icon-size: 64px;
            }

            .keybinds {
              padding-top: 10px;
              border-top: 1px solid @surface0;
              font-size: 12px;
              color: @text;
            }

            .keybind-button {
              opacity: 0.5;
            }

            .keybind-button:hover {
              opacity: 0.75;
            }

            .keybind-bind {
              text-transform: lowercase;
              opacity: 0.35;
            }

            .keybind-label {
              padding: 2px 4px;
              border-radius: 4px;
              border: 1px solid @text;
            }

            .error {
              padding: 10px;
              background: @red;
              color: @base;
            }

            :not(.calc).current {
              font-style: italic;
            }

            .preview-content.archlinuxpkgs,
            .preview-content.dnfpackages {
              font-family: monospace;
            }
          '';
        };
      };

      xdg.configFile."elephant/websearch.toml".source =
        let
          tomlFmt = pkgs.formats.toml { };
        in
        tomlFmt.generate "websearch.toml" {
          entries = [
            # keep-sorted start block=yes
            {
              default = true;
              name = "Google";
              url = "https://www.google.com/search?q=%TERM%";
            }
            {
              name = "Noogle";
              prefix = "!ng ";
              url = "https://noogle.dev/q/?term=%TERM%";
            }
            {
              name = "Satisfactory Wiki";
              prefix = "!sf ";
              url = "https://satisfactory.wiki.gg/wiki/Special:Search?search=%TERM%";
            }
            {
              name = "Terarria Wiki";
              prefix = "!tr ";
              url = "https://terraria.wiki.gg/wiki/Special:Search?search=%TERM%";
            }
            {
              name = "Warframe Wiki";
              prefix = "!wf ";
              url = "https://wiki.warframe.com/?search=%TERM%";
            }
            {
              name = "Wikipedia";
              prefix = "!w ";
              url = "https://en.wikipedia.org/w/index.php?search=%TERM%";
            }
            {
              name = "Wiktionary";
              prefix = "!wt ";
              url = "https://en.wiktionary.org/w/index.php?search=%TERM%";
            }
            {
              name = "YouTube";
              prefix = "!yt ";
              url = "https://www.youtube.com/results?search_query=%TERM%";
            }
            # keep-sorted end
          ];
        };
    };
  };
}

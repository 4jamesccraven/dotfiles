{ pkgs, ... }:

/*
  ====[ Machine ]====
  :: trait

  A machine is any system that exists on bare-metal, e.g., Workstations and Servers

  Enables:
      :> System Level
      boot loader    => A computer typically needs one of those
      time/locale    => All machines are in one place
      ssh            => Enabled for all machines
      networkManager => All machines use the internet
*/
{
  imports = [
    ./any.nix
  ];

  # ---[ Boot Loader ]---
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # ---[ Linux Kernel ]---
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # ---[ Time Zone & Locale ]---
  time.timeZone = "America/New_York";
  i18n =
    let
      locales = {
        english = {
          default = "en_US.UTF-8";
          messages = "en_GB.UTF-8";
        };

        spanish = "es_AR.UTF-8";
        korean = "ko_KR.UTF-8";
      };
    in
    with locales;
    {
      defaultLocale = english.default;
      extraLocaleSettings = {
        LC_MESSAGES = english.messages;
      };
      extraLocales = map (lang: "${lang}/UTF-8") [
        spanish
        korean
      ];

      inputMethod = {
        enable = true;
        type = "fcitx5";
        fcitx5 = {
          addons = with pkgs; [
            fcitx5-hangul
            catppuccin-fcitx5
          ];
          settings.inputMethod = {
            "Groups/0" = {
              Name = "Group 1";
              "Default Layout" = "us";
              DefaultIM = "keyboard-es";
            };

            "Groups/0/Items/0" = {
              Name = "keyboard-us";
              Layout = "";
            };

            "Groups/0/Items/1" = {
              Name = "keyboard-es";
              Layout = "";
            };

            "Groups/0/Items/2" = {
              Name = "hangul";
              Layout = "";
            };

            GroupOrder = {
              "0" = "Group 1";
            };
          };
        };
      };
    };

  # ---[ Services ]---
  # :> OpenSSH
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
  };

  # :> Networking
  networking.networkmanager.enable = true;

  # :> Security
  security = {
    sudo = {
      enable = true;
      extraConfig = ''
        Defaults pwfeedback
        Defaults passwd_timeout=0
      '';
    };
    pam.services.sudo.nodelay = true;
  };
  # Allow users to power-off the system etc.
  security.polkit.extraConfig = /* js */ ''
    polkit.addRule(function(action, subject) {
      if (
        subject.isInGroup("wheel")
          && (
            action.id == "org.freedesktop.login1.reboot" ||
            action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
            action.id == "org.freedesktop.login1.power-off" ||
            action.id == "org.freedesktop.login1.power-off-multiple-sessions"
          )
        )
      {
        return polkit.Result.YES;
      }
    });
  '';

  # :> Removable Media Management
  services.udisks2.enable = true;
  home-manager.sharedModules = [
    {
      services.udiskie.enable = true;
    }
  ];

  # ---[ Environment Variables ]---
  environment.variables = {
    MOZ_ENABLE_WAYLAND = 0;
    GOPATH = "$HOME/.local/share/go";
  };
}

{
  pkgs,
  lib,
  ...
}:

/*
  ====[ Zshell ]====
  :: dotfile

  Enables and configures Zshell.
*/
{
  imports = [ ./shell-aliases.nix ];
  home-manager.users.jamescraven = {
    programs.zsh = {
      enable = true;

      # ---[ Top-Level Settings ]---
      # :> Enable vi keybinds
      defaultKeymap = "viins";

      # :> Directory Aliases
      dirHashes = {
        cd = "$HOME/Code";
        cfg = "$HOME/.config";
        dw = "$HOME/Downloads";
        nix = "$HOME/nixos";
        nvim = "$HOME/neovim";
        sw = "$HOME/Documents/Schoolwork";
        txt = "$HOME/Documents/Texts";
        usb = "/run/media/jamescraven";
      };

      # :> Zsh Opts
      setOptions = [
        "auto_param_slash" # Dirs are autocompleted with a trailing /
        "cdable_vars" # cd into a hashed dir without typing ~
        "cd_silent" # Don't pwd after cd
        "correct" # Offer to correct mispelled commands
      ];

      # ---[ Plugins ]---
      # :> Syntax Highlighting
      syntaxHighlighting = {
        enable = true;
        highlighters = [
          "main"
          "brackets"
          "regexp"
        ];
      };

      autosuggestion.enable = true;

      # ---[ .zshrc ]---
      initContent = /* bash */ ''
        zstyle ':completion:*' insert-tab false # Disable inserting tab at the beginning of a line

        # fzf-zsh integration and theming
        source <(${lib.getExe pkgs.fzf} --zsh)
        bindkey "^f" fzf-history-widget

        # direnv integration
        eval "$(${lib.getExe pkgs.direnv} hook zsh)"

        bindkey "^a" autosuggest-accept

        export FZF_DEFAULT_OPTS=" \
        --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
        --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
        --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
        --color=selected-bg:#45475a \
        --color=border:#313244,label:#cdd6f4"

        if command -v nvim > /dev/null 2>&1; then
          export MANPAGER='nvim +Man!'
        fi

        # Fallback
        if ! command -v starship > /dev/null 2>&1; then
          PROMPT='/ˈiː.ən/%F{red}@%m [%f%~%F{red}]
        => %f'
        fi

        if command -v fastfetch > /dev/null 2>&1; then
          fastfetch
        fi
      '';

      # ---[ Shell Functions ]---
      siteFunctions = {
        tldr =
          let
            tealdeer = "${lib.getExe pkgs.tealdeer}";
            fzf = "${lib.getExe pkgs.fzf}";
          in
          /* bash */ ''
            if [[ "$#" -eq 0 ]]; then
                ${tealdeer} -l | ${fzf} --preview='tldr {} --color always' --scheme history | xargs tldr -q
            else
                ${tealdeer} "$@"
            fi
          '';

        eject-usb =
          let
            fzf = "${lib.getExe pkgs.fzf}";
          in
          /* bash */ ''
            eject-usb() {
              dev=$(\lsblk -dpno NAME,TRAN | grep usb \
                  | ${fzf} --height 10% --reverse --inline-info --prompt="USB> " \
                  | awk '{print $1}')
              [ -z "$dev" ] && return

              partitions=$(\lsblk -lnpo NAME "$dev" | tail -n +2)

              for part in $partitions; do
                  udisksctl unmount -b "$part"
              done

              udisksctl power-off -b "$dev"
            }
          '';

        sandwich = /* bash */ ''
          sandwich() {
              local go_bin=0 go_root=0
              local -a passthru

              for arg in $@; do
                  case "$arg" in
                      -g)  go_bin=1 ;;
                      -gg) go_root=1 ;;
                      *)   passthru+=("$arg") ;;
                  esac
              done

              local target
              target=$(which "''${passthru[@]}")

              # Do nothing special for non symlinks
              if [[ ! -L $target ]]; then
                  echo "$target"
                  return
              fi

              # Follow the symlink
              real_target=$(readlink -f "$target")
              # Go to "$real_target/../.."
              if (( "$go_root" == 1 )); then
                  cd $(dirname $(dirname "$real_target"))
              # Go to "$real_target/.."
              elif (( $go_bin == 1 )); then
                  cd $(dirname "$real_target")
              # Just echo like default which
              else
                  echo "$real_target"
              fi
          }
        '';

      };
    };
  };
}

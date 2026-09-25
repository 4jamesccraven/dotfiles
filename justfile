alias b := build
alias c := clean
alias d := develop
alias s := shell
alias r := run
alias gu := pull
alias vi := nvim
alias vim := nvim

[private]
default:
    #!/usr/bin/env bash
    info=$(\cat <<EOF
    NixOS configuration management.

    NOTE: nx is an alias for just --justfile /home/jamescraven/nixos/justfile.

    Commands:
    EOF
    )
    info+=$'\n'

    just --list --list-heading "$info" --list-prefix "  " --unsorted

    echo $'\n'"Copyright (C) 2026  James C. Craven <4jamesccraven@gmail.com>"

# ---[ Build Helpers ]---
# Rebuild the sytem and activate immediately.
[group('System State')]
build: validate
    @nh os switch .

# Rebuild the system and activate on next boot.
[group('System State')]
boot: validate
    @nh os boot .

# Pull upstream changes and rebuild.
[group('System State')]
sync: validate pull build (nvim "sync")

# Sync, rebuild, and clean
[group('System State')]
adopt: sync clean

# Clean unused store paths
[arg('gcroots', long='gc-roots', value='true', help='Clean out old direnv stuff.')]
[arg('help', long='help', short='h', value='true', help='Show this message and exit.')]
[arg('optimise', long='no-optimise', value='false', help='Optimise the Nix store after cleaning.')]
[group('System State')]
clean optimise='true' gcroots='false' help='false': validate && build
    #!/usr/bin/env bash
    if [[ "{{ help }}" == "true" ]]; then
        just --usage clean
        exit 1 # Necessary to avoid moving on to build
    fi

    nh clean all \
        {{ if optimise == "true" { "--optimise" } else { "" } }} \
        {{ if gcroots == "true" { "" } else { "--no-gcroots" } }}

# Update the system
[group('System State')]
update *inputs: validate pull && build (nvim "update")
    @nix flake update {{ inputs }}

# ---[ Nix Wrappers ]---

# A wrapper for `nix develop` with sensible defaults.
[arg('shell', help='The dev shell to use (optional).')]
[arg('cmd', long='cmd', short='c', help='The command the dev shell should run.')]
[arg('help', long='help', short='h', value='true', help='Show this message and exit.')]
[arg('global', long='global', short='g', value='true', help="Use the system flake's shells instead of the CWD.")]
[group('Tooling')]
[no-cd]
develop shell='' global='false' cmd='zsh' help='false':
    #!/usr/bin/env bash
    if [[ "{{ help }}" == "true" ]]; then
        just --justfile ~/nixos/justfile --usage develop
        exit 0
    fi

    if [[ "{{ global }}" == "true" ]]; then
        nix develop ~/nixos{{ if shell != "" { "#" + shell } else { "" } }} -c {{ cmd }}
    else
        nix develop .{{ if shell != "" { "#" + shell } else { "" } }} -c {{ cmd }}
    fi

# Alias for `ns shell` or `nix shell nixpkgs#$package`.
[group('Tooling')]
[no-cd]
[no-exit-message]
shell package="":
    #!/usr/bin/env bash
    if [[ -n "{{ package }}" ]]; then
        NIXPKGS_ALLOW_UNFREE=1 nix shell nixpkgs#{{ package }} --impure
    else
        ns shell
    fi

# Alias for `ns run` or `nix run nixpkgs#$package`.
[group('Tooling')]
[no-cd]
[no-exit-message]
run package="":
    #!/usr/bin/env bash
    if [[ -n "{{ package }}" ]]; then
        NIXPKGS_ALLOW_UNFREE=1 nix run nixpkgs#{{ package }} --impure
    else
        ns run
    fi

# ---[ nh Wrappers ]---

# Alias for `nh os repl ~/nixos`. Use `repl -h` for more.
[arg('hostname', long='hostname', short='H', help="The host to pull into the repl.")]
[arg('help', long='help', short='h', value='true', help='Show this message and exit.')]
[group('Tooling')]
repl hostname="NX_UNSET" help="false":
    #!/usr/bin/env bash
    if [[ "{{ help }}" == "true" ]]; then
        just --justfile ~/nixos/justfile --usage repl
        exit 0
    fi

    if [[ "{{ hostname }}" != "NX_UNSET" ]]; then
        nh os repl ~/nixos --hostname "{{ hostname }}"
    else
        nh os repl ~/nixos
    fi

# Alias for `nh os info`
[group('Tooling')]
info:
    @nh os info

# ---[ Neovim]---
# Manage Neovim plugins.
[arg('action', pattern='update|sync')]
[group('Tooling')]
nvim $action:
    #!/usr/bin/env bash
    case "$action" in
        update) nvim -c "PackUpdate" ;;
        sync) nvim -c "PackSync" ;;
        *) echo "invalid nvim action. this shouldn't happen" 2>&1; exit 1 ;;
    esac

# ---[ Version Control ]---
# Revert the system to HEAD
[group('Version Control')]
revert: _show_last_commit _phony_confirm
    @git reset --hard HEAD

# Push changes to origin
[group('Version Control')]
push message="chore: system update":
    @git add . --all
    @git commit -m '{{ message }}'
    @git push origin HEAD

# Git pull
[group('Version Control')]
pull:
    @git pull

# ---[ Helpers ]---
[private]
_show_last_commit:
    @echo "You are trying to revert to"
    @git log -1 --oneline

[confirm("Are you sure you want to revert to this commit?")]
[private]
_phony_confirm:

[private]
validate:
    @sudo -v

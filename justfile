alias b := build
alias c := clean
alias d := develop
alias gu := pull

[private]
default:
    @just --list --list-heading $'Actions:\n' --no-aliases

# ---[ Build Helpers ]---
# Build the system
[group('System State')]
build: validate
    @nh os switch .

# Pull upstream changes and build
[group('System State')]
sync: validate pull build
    @nvim -c 'PackSync' -c 'q'

# Pull upstream changes, build, and clean
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
update *inputs: validate pull && build update-nvim
    @nix flake update {{ inputs }}

# Rebuild the system and activate on next boot.
[group('System State')]
boot: validate
    @nh os boot .

# Update nvim plugins
[group('System State')]
update-nvim:
    @nvim -c 'PackUpdate' -c 'wq'

# List available generation
[group('System State')]
info:
    @nh os info

# ---[ Nix Develop Wrapper ]---

# A wrapper for `nix develop` with sensible defaults.
[arg('cmd', long='cmd', short='c', help='The command the dev shell should run.')]
[arg('global', long='global', short='g', value='true', help="Use the system flake's shells instead of the CWD.")]
[arg('help', long='help', short='h', value='true', help='Show this message and exit.')]
[arg('shell', help='The dev shell to use (optional).')]
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

# ---[ Version Control ]---
# Revert the system to HEAD
[group('VCS')]
revert: _show_last_commit _phony_confirm
    @git reset --hard HEAD

# Push changes to Origin
[group('VCS')]
push message="chore: system update":
    @git add . --all
    @git commit -m '{{ message }}'
    @git push origin HEAD

# Git pull
[group('VCS')]
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

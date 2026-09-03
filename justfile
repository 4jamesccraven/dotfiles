alias b := build
alias c := clean
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
[group('System State')]
clean *extra-args='--no-gcroots --optimise': validate && build
    @nh clean all {{ extra-args }}

# Update the system
[group('System State')]
update *inputs: validate pull && build update-nvim
    @nix flake update {{ inputs }}

# Update nvim plugins
update-nvim:
    @nvim -c 'PackUpdate' -c 'wq'

# List available generation
[group('System State')]
info:
    @nh os info

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

{
  pkgs ? import <nixpkgs> { },
  lib ? pkgs.lib,
  ...
}:

let
  ssh = lib.getExe pkgs.openssh;
in
pkgs.writeShellScriptBin "st-remote" /* bash */ ''
  SCRIPT=''${ basename "$0"; }
  URL="http://localhost:9898"

  cleanup() {
      if kill -0 "$SSH_ID" 2> /dev/null; then
          kill "$SSH_ID"
          wait "$SSH_ID" 2> /dev/null
      fi
  }

  usage() {
      echo "usage: ''${SCRIPT} <HOST>"
  }

  # Opens a tunnel to the syncthing web UI on the target host.
  #
  # Waits until the port is established and traps the cleanup function.
  open-tunnel() {
      ${ssh} -N -L 9898:localhost:8384 \
          -i "$HOME/.ssh/id_$(hostname --fqdn)" \
          -o ExitOnForwardFailure=yes \
          "$1" &

      SSH_ID=$!

      until nc -z 127.0.0.1 9898; do
          sleep 0.5
      done

      echo "Tunnel established..."

      trap cleanup EXIT INT TERM
  }

  # Parse the CLI
  if (( "$#" != 1 )); then
      usage 1>&2
      exit 1
  fi

  case "$1" in
      -h|--help)
          usage
          echo "open the Syncthing web UI on HOST."
          exit 0
          ;;
      *)
          host="$1"
          ;;
  esac

  # Open the tunnel
  open-tunnel "$host"

  # Open the Web UI
  printf 'Opening Syncthing web UI at %s with PID %s...\n' "$URL" "$SSH_ID"
  xdg-open "$URL"

  # Wait for ssh to end or user to CTRL-C, etc.
  wait "$SSH_ID"
''

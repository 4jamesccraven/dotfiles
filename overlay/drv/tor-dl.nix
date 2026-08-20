{
  pkgs ? import <nixpkgs> { },
  lib ? pkgs.lib,
  ...
}:

let
  inherit (lib) getExe getExe';
  tor = getExe pkgs.tor;
  torify = getExe' pkgs.tor "torify";
  yt-dlp = getExe pkgs.yt-dlp;
in
pkgs.writeShellScriptBin "tor-dl" ''
  cleanup() {
      if kill -0 "$TOR_PID" 2>/dev/null; then
          kill "$TOR_PID"
          wait "$TOR_PID" 2>/dev/null
      fi
  }

  ${tor} --RunAsDaemon 1 > /dev/null 2>&1 &
  TOR_PID=$!

  until nc -z 127.0.0.1 9050; do
    sleep 0.5
  done

  trap cleanup EXIT INT TERM

  exec ${torify} ${yt-dlp} "$@"
''

{ lib, inputs, ... }:

/*
  ====[ Overlay ]====

  Adds extra packages to `pkgs`.
*/
let
  inherit (lib.ext) overlayFromDir;
in
{
  nixpkgs.overlays = [
    # :> Local Overlay
    (overlayFromDir ./drv)

    # :> mkdev
    inputs.mkdev.overlays.default
    inputs.ns.overlays.default
    inputs.egress.overlays.default

    # :> etc
    (_final: prev: {
      ext.formatter = prev.callPackage ./formatter.nix { };
    })
  ];
}

{
  description = "";
  inputs.nixpkgs.url = "https://nixos.org/channels/nixpkgs-unstable/nixexprs.tar.xz";

  outputs =
    { nixpkgs, ... }:
    let
      inherit (nixpkgs) lib;
      eachDefaultSystem =
        function:
        lib.genAttrs [
          "x86_64-linux"
          "aarch64-linux"
          "x86_64-darwin"
          "aarch64-darwin"
        ] (system: function nixpkgs.legacyPackages.${system});
    in
    {
      packages = eachDefaultSystem (pkgs: {
        default =
          with pkgs;
          let
            manifest = (lib.importTOML ./Cargo.toml).package;
          in
          rustPlatform.buildRustPackage {
            pname = manifest.name;
            inherit (manifest) version;

            src = ./.;

            cargoLock.lockFile = ./Cargo.lock;
          };
      });

      devShells = eachDefaultSystem (pkgs: {
        default = pkgs.mkShell {
          buildInputs = builtins.attrValues {
            inherit (pkgs)
              cargo
              libgcc
              rustc
              ;
          };
        };
      });
    };
}

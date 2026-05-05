{
  description = "ἐρωτηθεὶς τί ἐστι φίλος, ἔφη, μία ψυχὴ δύο σώμασιν ἐνοικοῦσα";

  inputs = {
    # :> nixpkgs
    nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.xz";

    # :> nix-community
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    home-manager = {
      url = "github:nix-community/home-manager?ref=master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # :> me
    mkdev = {
      url = "github:4jamesccraven/mkdev";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ns = {
      url = "github:4jamesccraven/ns";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    let
      libExtension = import ./lib { inherit (nixpkgs) lib; };
      lib = nixpkgs.lib // {
        ext = libExtension;
      };
      inherit (lib.ext)
        genFileAttrs
        shellsFromDir
        checksFromDir
        templatesFromDir
        overlayFromDir
        ;

      /*
        eachDefaultSystem :: (nixpkgs -> a) -> attrsOf a

        see https://ayats.org/blog/no-flake-utils.
      */
      eachDefaultSystem =
        function:
        lib.genAttrs [
          "aarch64-darwin"
          "aarch64-linux"
          "x86_64-darwin"
          "x86_64-linux"
        ] (system: function nixpkgs.legacyPackages.${system});

      /*
        mkHost :: string -> NixOS System (attrs)

        Generates a NixOS system from a name, which is inferred to be the name
        of the host file in ./hosts/
      */
      mkHost =
        name:
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs lib;
          };
          modules = [
            ./hosts/${name}.nix
            ./overlay
          ];
        };
    in
    {

      nixosConfigurations = genFileAttrs ./hosts mkHost;

      devShells = eachDefaultSystem (pkgs: shellsFromDir pkgs ./shells);

      checks = eachDefaultSystem (pkgs: checksFromDir { inherit pkgs self; } ./checks);

      templates = templatesFromDir ./templates;

      formatter = eachDefaultSystem (pkgs: pkgs.callPackage ./overlay/formatter.nix { });

      overlays = {
        default = overlayFromDir ./overlay/drv;
        unused = overlayFromDir ./overlay/unused;
      };

    };
}

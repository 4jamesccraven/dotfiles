{
  description = "ἐρωτηθεὶς τί ἐστι φίλος, ἔφη, μία ψυχὴ δύο σώμασιν ἐνοικοῦσα";

  inputs = {
    # :> nixpkgs
    nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.xz";

    # :> nix-community
    home-manager = {
      type = "github";
      owner = "nix-community";
      repo = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl = {
      type = "github";
      owner = "nix-community";
      repo = "NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # :> me
    mkdev = {
      type = "github";
      owner = "4jamesccraven";
      repo = "mkdev";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ns = {
      type = "github";
      owner = "4jamesccraven";
      repo = "ns";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    egress = {
      type = "github";
      owner = "4jamesccraven";
      repo = "egress";
      # inputs.nixpkgs.follows = "nixpkgs"; # -- Disabled intentionally
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

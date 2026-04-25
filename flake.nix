{
  description = "Synnøve laptop";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    lanzaboote.url = "github:nix-community/lanzaboote";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{
    self,
    nixpkgs,
    home-manager,
    nixos-hardware,
    ...
  }:
  let
    system = "x86_64-linux";

    permittedInsecure = [
      "dotnet-sdk-6.0.428"
    ];

    pkgs-stable = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
        permittedInsecurePackages = permittedInsecure;
      };
    };
  in {
    nixosConfigurations.laptop-sno = nixpkgs.lib.nixosSystem {
      inherit system;

      specialArgs = {
        inherit inputs system pkgs-stable;
      };

      modules = [
        ./configuration.nix

        nixos-hardware.nixosModules.common-pc
        inputs.lanzaboote.nixosModules.lanzaboote

        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "backup";

            extraSpecialArgs = {
              inherit inputs system pkgs-stable;
            };

            users.synnove = import ./home.nix;
          };
        }
      ];
    };
  };
}


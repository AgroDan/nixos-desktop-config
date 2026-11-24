{
  description = "A very basic flake";
  inputs = {
    clipway = {
      url = "github:krisztianfekete/clipway";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "sops-nix";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, home-manager, sops-nix, ... } @ inputs: {
    nixosConfigurations.nixos-btw = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./nixos/configuration.nix
        home-manager.nixosModules.default
        {
          home-manager = {
            useUserPackages = true;
            useGlobalPkgs = true;
            backupFileExtension = "bak";
            sharedModules = [
              sops-nix.homeManagerModules.sops
            ];

            users.dan = import ./home/dan.nix;
          };
        }
      ];
    };
  };
}

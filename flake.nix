# /etc/nixos/flake.nix

{
  description = "flake for octavian";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-flatpak.url = "github:gmodena/nix-flatpak";  
    };

  outputs = { self, nixpkgs,home-manager,nix-flatpak,... }: {
    nixosConfigurations = {
      octavian=nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
           {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            #home-manager.users.theNameOfTheUser = import ./home.nix;
           }
          nix-flatpak.nixosModules.nix-flatpak
        ];
      };
    };
  };
}

# /etc/nixos/flake.nix

{
  description = "flake for octavian";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    #home-manager={
    #   url = "github:nix-community/home-manager";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #  };
    nix-flatpak.url = "github:gmodena/nix-flatpak";  
    };

  outputs = { self, nixpkgs,home-manager,nix-flatpak,... }@inputs:
   let   
     system= "x86_64-linux";
     pkgs = import nixpkgs{
       inherit system;
       config = {
         allowUnfree = true;
       };
     };
    in
  {
   nixosConfigurations = {
      octavian=nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs system;};
        modules = [
          ./configuration.nix
          nix-flatpak.nixosModules.nix-flatpak
        ];
      };
    };
  };
}

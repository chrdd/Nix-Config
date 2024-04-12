# /etc/nixos/flake.nix

{
  description = "flake for octavian";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";

    hyprland-plugins = {
        url = "github:hyprwm/hyprland-plugins";
        inputs.hyprland.follows = "hyprland"; 
    };
    home-manager={
       url = "github:nix-community/home-manager";
       inputs.nixpkgs.follows = "nixpkgs";
      };
    nix-flatpak.url = "github:gmodena/nix-flatpak";  
    nix-colors.url = "github:misterio77/nix-colors";
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
          ./dotfiles/default.nix
          ./apps/default.nix
          nix-flatpak.nixosModules.nix-flatpak
        ];
      };
    };
  };
}

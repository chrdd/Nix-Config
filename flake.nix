{
  description = "flake for octavian";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    hyprland = {
      type = "git";
      url = "https://github.com/hyprwm/Hyprland";
      submodules = true;
    };

    stylix.url = "github:danth/stylix";

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak";

    nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = { self, nixpkgs, home-manager, nix-flatpak, stylix, ... }@inputs: {
    nixosConfigurations = {
      octavian = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs;};
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          ./dotfiles/default.nix
          ./apps/default.nix
          ./home.nix
          nix-flatpak.nixosModules.nix-flatpak
          #stylix.nixosModules.stylix
        ];
      };
    };
  };
}

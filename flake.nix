{
  description = "flake for Orion";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    hyprland = {
      type = "git";
      url = "https://github.com/hyprwm/Hyprland";
      submodules = true;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:danth/stylix";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    nix-colors.url = "github:misterio77/nix-colors";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    nix-proton-cachyos.url = "github:kimjongbing/nix-proton-cachyos";
  };
  outputs = { self, nixpkgs, home-manager, nix-flatpak, stylix, hyprland, ... } @ inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      secrets = builtins.fromJSON (builtins.readFile "${self}/secrets/secrets.json");
    in {
      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;
      nixosConfigurations = {
        Orion = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs system secrets;};
          modules = [
            ./hosts/desktop/configuration.nix
            ./apps/default.nix
            ./modules/nixos/default.nix
            {
              # Import home-manager as a NixOS module
             # home-manager.useGlobalPkgs = true;
             # home-manager.useUserPackages = true;
             # home-manager.backupFileExtension = "backup"; # Added backup option
             # home-manager.users.octavian = import ./home.nix;
             # home-manager.extraSpecialArgs = {
              #  inherit inputs;
              #  inherit (self) outputs;
              #};
            }
            nix-flatpak.nixosModules.nix-flatpak
            # Uncomment if you want to use stylix
            # stylix.nixosModules.stylix
          ];
        };
      };
      nixosConfigurations = {
        Acer = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs system secrets;};
          modules = [
            ./hosts/laptop/configuration.nix
            ./apps/default.nix
            ./modules/nixos/default.nix
            {
              # Import home-manager as a NixOS module
             # home-manager.useGlobalPkgs = true;
             # home-manager.useUserPackages = true;
             # home-manager.backupFileExtension = "backup"; # Added backup option
             # home-manager.users.octavian = import ./home.nix;
             # home-manager.extraSpecialArgs = {
              #  inherit inputs;
              #  inherit (self) outputs;
              #};
            }
            nix-flatpak.nixosModules.nix-flatpak
            # Uncomment if you want to use stylix
            # stylix.nixosModules.stylix
          ];
        };
      };
    };
}

{
  description = "flake for Orion";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-25.url = "github:NixOS/nixpkgs/nixos-25.05";
    # Fix typo: nixpkgs-old instead of nixpksg-old
    nixpkgs-old.url = "github:NixOS/nixpkgs/c5dd43934613ae0f8ff37c59f61c507c2e8f980d";

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

    winapps = {
      url = "github:winapps-org/winapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    deploy-rs.url = "github:serokell/deploy-rs";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    nix-colors.url = "github:misterio77/nix-colors";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    nix-proton-cachyos.url = "github:kimjongbing/nix-proton-cachyos";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-old,
    home-manager,
    nix-flatpak,
    stylix,
    hyprland,
    deploy-rs,
    winapps,
    ...
  } @ inputs: let
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
          ./modules/nixos/default_Orion.nix
          # home-manager module can be enabled here if needed
          nix-flatpak.nixosModules.nix-flatpak
          # stylix.nixosModules.stylix # Uncomment if using stylix
          (
            {
              pkgs,
              system ? pkgs.system,
              ...
            }: {
              environment.systemPackages = [
                winapps.packages."${system}".winapps
                winapps.packages."${system}".winapps-launcher # optional
              ];
            }
          )
        ];
      };

      Acer = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs system secrets;};
        modules = [
          ./hosts/laptop/configuration.nix
          ./apps/default.nix
          ./modules/nixos/default_Acer.nix
          # home-manager module can be enabled here if needed
          nix-flatpak.nixosModules.nix-flatpak
          # stylix.nixosModules.stylix # Uncomment if using stylix
        ];
      };
    };

    deploy.nodes.Orion = {
      hostname = "octavian";
      profiles.system = {
        sshUser = "octavian";
        user = "root";
        interactiveSudo = true;
        path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.Orion;
      };
    };

    deploy.nodes.Acer = {
      hostname = "octavian";
      profiles.system = {
        sshUser = "octavian";
        user = "root";
        interactiveSudo = true;
        path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.Acer;
      };
    };

    packages.x86_64-linux.shadps4-0_6_0 = let
      pkgs-old = import nixpkgs-old {
        system = "x86_64-linux";
      };
    in
      pkgs-old.shadps4;
  };
}

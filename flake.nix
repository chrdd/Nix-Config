# /etc/nixos/flake.nix
{
  description = "flake for octavian";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    # hyprland = {
    #   type = "git";
    #   url = "https://github.com/hyprwm/Hyprland";
    #   submodules = true;
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # hyprland.url = "github:hyprwm/Hyprland";

    stylix.url = "github:danth/stylix";

    ghostty = {
      url = "github:ghostty-org/ghostty";
    };

    # hyprland-plugins = {
    #     url = "github:hyprwm/hyprland-plugins";
    #     inputs.hyprland.follows = "hyprland";
    # };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak";

    nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = {
    self,
    nixpkgs,
    ghostty,
    home-manager,
    nix-flatpak,
    stylix,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    secrets = builtins.fromJSON (builtins.readFile "${self}/secrets/secrets.json");
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };
  in {
    nixosConfigurations = {
      octavian = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs system secrets;};
        modules = [
          ./hosts/desktop/configuration.nix
          # ./dotfiles/default.nix
          ./apps/default.nix
          ./modules/suspend.nix
          ./modules/default.nix
          # ./modules/sunshine.nix
          {
            environment.systemPackages = [
              ghostty.packages.x86_64-linux.default
            ];
          }
          # ./home.nix
          nix-flatpak.nixosModules.nix-flatpak
          # inputs.stylix.nixosModules.stylix
        ];
      };
    };
    #Home-manager
    home-manager = {
      extraSpecialArgs = {inherit inputs;};
      users = {
        octavian = import ./home.nix;
      };
    };
  };
}

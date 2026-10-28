{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  options = {
    zed.enable = lib.mkEnableOption "Enables Zed editor";
  };
  config = lib.mkIf config.zed.enable {
    environment.systemPackages = with pkgs; [
      zed-editor

      # Nix: language servers, formatter, linters
      nixd
      nil
      alejandra
      statix
      deadnix

      # Python
      pyright
      ruff

      # YAML
      yaml-language-server
    ];
    nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];
  };
}

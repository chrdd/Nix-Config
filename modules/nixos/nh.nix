{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    nh.enable = lib.mkEnableOption "Enables Nix Helper";
  };
  config = lib.mkIf config.nh.enable {
    environment.sessionVariables = {
      NH_FLAKE = "/etc/nixos";
    };
    programs.nh = {
      enable = true;
      clean = {
        enable = true;
        extraArgs = "--keep 10";
      };
    };
  };
}

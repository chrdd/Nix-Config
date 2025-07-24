{
  config,
  lib,
  pkgs,
  ...
}: {
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
}

{
  config,
  lib,
  pkgs,
  ...
}: {
  nixpkgs.config.vivaldi = {
    proprietaryCodecs = true;
    enableWideVine = true;
  };
}

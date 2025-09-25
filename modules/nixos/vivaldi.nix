{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    vivaldi.enable = lib.mkEnableOption "Enables Vivaldi";
  };
  config = lib.mkIf config.vivaldi.enable {
    nixpkgs.config.vivaldi = {
      proprietaryCodecs = true;
      enableWideVine = true;
    };
  };
}

{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    thunar.enable = lib.mkEnableOption "Enables Thunar";
  };
  config = lib.mkIf config.thunar.enable {
    programs.thunar.enable = true;
    programs.thunar.plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
  };
}

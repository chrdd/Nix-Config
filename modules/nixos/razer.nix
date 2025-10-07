{
  pkgs,
  config,
  lib,
  ...
}: {
  options = {
    razer.enable = lib.mkEnableOption "Enables OpenRazer";
  };
  config = lib.mkIf config.razer.enable {
    hardware.openrazer.enable = true;
    users.users.octavian.extraGroups = ["openrazer"];
  };
}

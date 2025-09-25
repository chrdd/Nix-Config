{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    adb.enable = lib.mkEnableOption "Enables ADB";
  };
  config = lib.mkIf config.adb.enable {
    programs.adb.enable = true;
    users.users.octavian.extraGroups = ["adbusers kvm"];
    services.udev.packages = [
      pkgs.android-udev-rules
    ];
  };
}

{pkgs, ...}: {
  programs.adb.enable = true;
  users.users.octavian.extraGroups = ["adbusers kvm"];
  services.udev.packages = [
    pkgs.android-udev-rules
  ];
}

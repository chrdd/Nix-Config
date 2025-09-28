{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  # QT themeing
  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "Colloid-dark";
    style.package = pkgs.colloid-kde;
  };
}

{ config, pkgs,lib,inputs, ... }:
{
    imports = [
    # ./bluetooth.nix
    ./suspend.nix
  ];
}
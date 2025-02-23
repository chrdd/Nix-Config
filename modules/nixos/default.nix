{ config, pkgs,lib,inputs, ... }:
{
    imports = [
    ./bluetooth.nix
    ./flatpak.nix
    ./ollama.nix
    ./rdp.nix
    ./steam.nix
    ./sunshine.nix
    ./suspend.nix
    ./thunar.nix
    ./virtualbox.nix
  ];
}
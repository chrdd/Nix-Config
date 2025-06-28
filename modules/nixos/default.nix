{ config, pkgs,lib,inputs, ... }:
{
    imports = [
    # ./appimage.nix
    ./bluetooth.nix
#     ./smartd.nix
    ./mumblemic.nix
    ./flatpak.nix
    # ./ollama.nix
    ./optimisation.nix
    # ./rdp.nix
    ./steam.nix
    ./sunshine.nix
    ./suspend.nix
    ./syncthing.nix
    ./thunar.nix
    # ./virtualbox.nix
    # ./manga.nix
  ];
}

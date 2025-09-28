{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./adb.nix
    ./autoupgrade.nix
    ./avahi.nix
    ./bluetooth.nix
    ./docker.nix
    ./flatpak.nix
    ./fonts.nix
    ./git.nix
    ./lact.nix
    ./mumblemic.nix
    ./network.nix
    ./nh.nix
    ./optimisation.nix
    ./prismlauncher.nix
    ./samba.nix
    ./smartd.nix
    ./steam.nix
    ./sunshine.nix
    ./suspend.nix
    ./syncthing.nix
    ./thunar.nix
    ./tmux.nix
    ./vivaldi.nix
    ./vscodium.nix
    ./zsh.nix
    # ./appimage.nix
    # ./manga.nix
    # ./ollama.nix
    # ./rdp.nix
    # ./virtualbox.nix
  ];
  vivaldi.enable = lib.mkDefault true;
  zsh.enable = lib.mkDefault true;
  docker.enable = lib.mkDefault true;
  adb.enable = lib.mkDefault true;
  autoupgrade.enable = lib.mkDefault true;
  git.enable = lib.mkDefault true;
  fonts.enable = lib.mkDefault true;
  nh.enable = lib.mkDefault true;
  tmux.enable = lib.mkDefault true;
  vscodium.enable = lib.mkDefault true;
  syncthing.enable = lib.mkDefault true;
}

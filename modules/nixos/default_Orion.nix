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
    # ./lact.nix
    ./mumblemic.nix
    ./network.nix
    ./nh.nix
    ./optimisation.nix
    ./prismlauncher.nix
    # ./samba.nix
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
    ./hip.nix
    ./nfs.nix
    ./hyprland.nix
    # ./appimage.nix
    # ./manga.nix
    # ./ollama.nix
    # ./rdp.nix
    # ./virtualbox.nix
  ];
  adb.enable = lib.mkDefault false;
  autoupgrade.enable = lib.mkDefault true;
  bluetooth.enable = lib.mkDefault true;
  docker.enable = lib.mkDefault true;
  fonts.enable = lib.mkDefault true;
  git.enable = lib.mkDefault true;
  nh.enable = lib.mkDefault true;
  steam.enable = lib.mkDefault true;
  sunshine.enable = lib.mkDefault true;
  # suspend.enable = lib.mkDefault true;
  syncthing.enable = lib.mkDefault true;
  thunar.enable = lib.mkDefault true;
  tmux.enable = lib.mkDefault true;
  vivaldi.enable = lib.mkDefault true;
  vscodium.enable = lib.mkDefault true;
  zsh.enable = lib.mkDefault true;
  hip.enable = lib.mkDefault true;
  nfs.enable = lib.mkDefault true;
  hyprland.enable = lib.mkDefault false;
}

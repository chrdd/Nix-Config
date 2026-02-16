{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./adb.nix
    ./autologin.nix
    ./autoupgrade.nix
    ./avahi.nix
    ./bluetooth.nix
    ./cast.nix
    ./docker.nix
    ./flatpak.nix
    ./fonts.nix
    ./git.nix
    ./hip.nix
    ./hyprland.nix
    ./lact.nix
    ./mumblemic.nix
    ./network.nix
    ./nfs.nix
    ./nh.nix
    ./optimisation.nix
    ./prismlauncher.nix
    ./rdp.nix
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
    # ./samba.nix
    # ./virtualbox.nix
  ];
  # suspend.enable = lib.mkDefault true;
  adb.enable = lib.mkDefault false;
  autoLogin.enable = lib.mkDefault true;
  autoupgrade.enable = lib.mkDefault true;
  bluetooth.enable = lib.mkDefault true;
  cast.enable = lib.mkDefault true;
  docker.enable = lib.mkDefault true;
  fonts.enable = lib.mkDefault true;
  git.enable = lib.mkDefault true;
  hip.enable = lib.mkDefault true;
  hyprland.enable = lib.mkDefault false;
  nfs.enable = lib.mkDefault true;
  nh.enable = lib.mkDefault true;
  rdp.enable = lib.mkDefault true;
  steam.enable = lib.mkDefault true;
  sunshine.enable = lib.mkDefault true;
  syncthing.enable = lib.mkDefault true;
  thunar.enable = lib.mkDefault true;
  tmux.enable = lib.mkDefault true;
  vivaldi.enable = lib.mkDefault true;
  vscodium.enable = lib.mkDefault true;
  zsh.enable = lib.mkDefault true;
}

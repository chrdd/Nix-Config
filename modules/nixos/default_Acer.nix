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
    ./guacamole.nix
    ./mumblemic.nix
    ./network.nix
    ./nh.nix
    ./optimisation.nix
    ./prismlauncher.nix
    ./razer.nix
    ./steam.nix
    ./sunshine.nix
    ./syncthing.nix
    ./thunar.nix
    ./tmux.nix
    ./vivaldi.nix
    ./vscodium.nix
    ./zsh.nix
    # ./appimage.nix
    # ./auto-cpufreq.nix
    # ./fingerprint.nix
    # ./manga.nix
    # ./ollama.nix
    # ./rdp.nix
    # ./smartd.nix
    # ./suspend.nix
    # ./virtualbox.nix
    # ./wireguard.nix
  ];

  adb.enable = lib.mkDefault true;
  autoupgrade.enable = lib.mkDefault true;
  bluetooth.enable = lib.mkDefault true;
  docker.enable = lib.mkDefault true;
  fonts.enable = lib.mkDefault true;
  git.enable = lib.mkDefault true;
  guacamole.enable = lib.mkDefault true;
  nh.enable = lib.mkDefault true;
  razer.enable = lib.mkDefault true;
  steam.enable = lib.mkDefault true;
  sunshine.enable = lib.mkDefault true;
  syncthing.enable = lib.mkDefault true;
  thunar.enable = lib.mkDefault true;
  tmux.enable = lib.mkDefault true;
  vivaldi.enable = lib.mkDefault true;
  vscodium.enable = lib.mkDefault true;
  zsh.enable = lib.mkDefault true;
}

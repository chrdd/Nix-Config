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
    ./mumblemic.nix
    ./network.nix
    ./nh.nix
    ./optimisation.nix
    ./prismlauncher.nix
    ./razer.nix
    ./rdp.nix
    ./sunshine.nix
    ./syncthing.nix
    ./thunar.nix
    ./tmux.nix
    ./virtualbox.nix
    ./vivaldi.nix
    ./vscodium.nix
    ./wazuh.nix
    ./wireguard-dev.nix
    ./zabbix-Acer.nix
    ./zsh.nix
    ./vagrant.nix
    # ./appimage.nix
    # ./auto-cpufreq.nix
    # ./fingerprint.nix
    # ./guacamole.nix
    # ./manga.nix
    # ./ollama.nix
    # ./smartd.nix
    # ./steam.nix
    # ./suspend.nix
  ];

  # guacamole.enable = lib.mkDefault true;
  # steam.enable = lib.mkDefault true;
  # wireguard.enable = lib.mkDefault true;
  adb.enable = lib.mkDefault true;
  autoupgrade.enable = lib.mkDefault true;
  bluetooth.enable = lib.mkDefault true;
  docker.enable = lib.mkDefault true;
  fonts.enable = lib.mkDefault true;
  git.enable = lib.mkDefault true;
  nh.enable = lib.mkDefault true;
  razer.enable = lib.mkDefault false;
  rdp.enable = lib.mkDefault true;
  sunshine.enable = lib.mkDefault true;
  syncthing.enable = lib.mkDefault true;
  thunar.enable = lib.mkDefault true;
  tmux.enable = lib.mkDefault true;
  vagrant.enable = lib.mkDefault false;
  vivaldi.enable = lib.mkDefault true;
  vscodium.enable = lib.mkDefault true;
  wazuh-agent.enable = lib.mkDefault true;
  zabbix-agent.enable = lib.mkDefault true;
  zsh.enable = lib.mkDefault true;
}

{...}: {
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
  vivaldi.enable = lib.mkDefault true;
  zsh.enable = lib.mkDefault true;
  docker.enable = lib.mkDefault true;
  adb.enable = lib.mkDefault true;
  autoupgrade.enable = lib.mkDefault true;
  git.enable = lib.mkDefault true;
  fonts.enable = lib.mkDefault true;
}

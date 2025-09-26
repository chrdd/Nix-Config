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
<<<<<<< HEAD
  vivaldi.enable = true;
  zsh.enable = true;
  docker.enable = true;
  adb.enable = true;
  autoupgrade.enable = true;
  git.enable = true;
  fonts.enable = true;
=======
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
>>>>>>> cd966dd (Auto-commit before pull: 2025-09-26T08:35:36+03:00)
}

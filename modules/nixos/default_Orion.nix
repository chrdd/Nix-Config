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

  vivaldi.enable = true;
  zsh.enable = true;
  docker.enable = true;
  adb.enable = true;
  autoupgrade.enable = true;
  git.enable = true;
  fonts.enable = true;
  nh.enable = true;
}

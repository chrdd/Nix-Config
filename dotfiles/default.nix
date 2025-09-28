{config, ...}: {
  imports = [
    # ./waybar.nix
    ./hyprland.nix
    ./gtk.nix
  ];
  #home.packages = with pkgs; [
  #  nerdfonts
  #];
}

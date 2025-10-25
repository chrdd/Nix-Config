{
  config,
  lib,
  pkgs,
  hyprland,
  inputs,
  ...
}: {
  options = {
    hyprland.enable = lib.mkEnableOption "Enables Hyprland";
  };
  config = lib.mkIf config.hyprland.enable {
    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages."${pkgs.system}".hyprland;
      xwayland.enable = true;
      withUWSM = true;
    };
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
    environment.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";

    programs.waybar.enable = true;
    services.hypridle.enable = true;
    environment.systemPackages = with pkgs; [
      hyprcursor
      hyprlock
      hyprpaper
      hyprpicker
      hypridle
      hyprpolkitagent
      rofi
      dunst
    ];
    nix.settings = {
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };
    xdg.portal = {
      enable = true;
      # extraPortals = with pkgs; [xdg-desktop-portal-hyprland];
    };
    # wayland.windowManager.hyprland = {
    #   enable = true;
    #   plugins = [
    #     # inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.PLUGIN_NAME
    #   ];
    # };
  };
}

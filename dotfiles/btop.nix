{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  programs.btop.settings = {
    color_theme = "gruvbox";
    theme_background = false;
  };
}

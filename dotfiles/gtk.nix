{ config, pkgs,lib,inputs, ... }:
{
    # GTK Themeing
  gtk = {
    enable = true;

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    theme = {
      name = "orchis-theme";
      package = pkgs.orchis-theme;
    };
    cursorTheme = {
      name = "Numix-cursor";
      package = pkgs.numix-cursor-theme;
    };
    gtk3.extraConfig = {
      Settings = '' gtk-application-prefer-dark-theme=1'';
    };
    gtk4.extraConfig = {
      Settings = '' gtk-application-prefer-dark-theme=1'';
    };
  };

  home.sessionVariables.GTK_THEME = "Gruvbox-Dark-B";
}
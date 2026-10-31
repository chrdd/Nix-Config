{
  config,
  lib,
  ...
}: {
  options = {
    plasma.enable = lib.mkEnableOption "Enables KDE Plasma configuration";
  };
  config = lib.mkIf config.plasma.enable {
    programs.plasma = {
      enable = true;

      workspace = {
        theme = "Orchis-dark"; # Plasma style
        colorScheme = "OrchisDark";
        widgetStyle = "Union";
        iconTheme = "Papirus-Dark";
        cursor = {
          theme = "FossaCursors";
          size = 24;
        };
        windowDecorations = {
          library = "org.kde.kwin.aurorae";
          theme = "__aurorae__svg__Orchis-dark";
        };
      };

      fonts.general = {
        family = "Noto Sans";
        pointSize = 10;
      };

      configFile.kdeglobals.General.TerminalApplication = "ghostty";
    };

    # Default apps. Replace the IDs with the ones in your ~/.config/mimeapps.list
    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "x-scheme-handler/http" = "helium.desktop";
        "x-scheme-handler/https" = "helium.desktop";
        "text/html" = "helium.desktop";

        "x-scheme-handler/mailto" = "userapp-Thunderbird-EYYFW3.desktop";
        "x-scheme-handler/mid" = "userapp-Thunderbird-EYYFW3.desktop";
        "message/rfc822" = "userapp-Thunderbird-EYYFW3.desktop";
        "x-scheme-handler/net.thunderbird" = "userapp-Thunderbird-2WDHW3.desktop";
      };
    };
  };
}

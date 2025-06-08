{ config, pkgs, ... }:
{
  # https://github.com/gmodena/nix-flatpak
  services.flatpak.enable = true;
  services.flatpak.packages = [
    # {
    #   appId = "tv.plex.PlexDesktop";
    #   origin = "flathub";
    # }
    {
      appId = "tv.plex.PlexHTPC";
      origin = "flathub";
    }
    {
      appId = "com.github.tchx84.Flatseal";
      origin = "flathub";
    }
    {
      appId = "dev.vencord.Vesktop";
      origin = "flathub";
    }
    {
      appId = "org.libreoffice.LibreOffice";
      origin = "flathub";

    }
    # {
    #   appId = "io.github.zen_browser.zen";
    #   origin = "flathub";
    # }
  ];
}
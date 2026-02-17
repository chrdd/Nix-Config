{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    guacamole.enable = lib.mkEnableOption "Enables Guacamole";
  };
  config = lib.mkIf config.guacamole.enable {
    services.xserver.enable = true;
    services.xserver.displayManager.sddm.enable = true;
    services.xserver.desktopManager.plasma6.enable = true;

    services.xrdp.enable = true;
    services.xrdp.defaultWindowManager = "startplasma-x11";
    services.xrdp.openFirewall = true;

    services.guacamole-server = {
      enable = true;
      host = "127.0.0.1";
      userMappingXml = /etc/nixos/guacamole/user-mapping.xml;
      # package = pkgs.unstable.guacamole-server; # Optional, use only when you want to use the unstable channel
    };

    services.guacamole-client = {
      enable = true;
      enableWebserver = true;
      settings = {
        guacd-port = 4822;
        guacd-hostname = "127.0.0.1";
      };
      # package = pkgs.unstable.guacamole-client; # Optional, use only when you want to use the unstable channel
    };
  };
}

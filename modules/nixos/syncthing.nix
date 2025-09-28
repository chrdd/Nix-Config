{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    syncthing.enable = lib.mkEnableOption "Enables syncthing";
  };
  config = lib.mkIf config.syncthing.enable {
    services = {
      syncthing = {
        enable = true;
        user = "octavian";
        dataDir = "/home/octavian/Documents"; # Default folder for new synced folders
        configDir = "/home/octavian/Documents/.config/syncthing"; # Folder for Syncthing's settings and keys
      };
    };
  };
}

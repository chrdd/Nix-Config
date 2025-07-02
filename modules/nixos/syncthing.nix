{...}: {
  services = {
    syncthing = {
      enable = true;
      user = "octavian";
      dataDir = "/home/octavian/Documents"; # Default folder for new synced folders
      configDir = "/home/octavian/Documents/.config/syncthing"; # Folder for Syncthing's settings and keys
    };
  };
}

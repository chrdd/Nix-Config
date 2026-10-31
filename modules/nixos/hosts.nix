{
  lib,
  hostName,
  ...
}: let
  commonImports = [
    # ./mumblemic.nix
    ./adb.nix
    ./autoupgrade.nix
    ./avahi.nix
    ./bluetooth.nix
    ./docker.nix
    ./flatpak.nix
    ./fonts.nix
    ./git.nix
    ./home-manager.nix
    ./network.nix
    ./nh.nix
    ./optimisation.nix
    ./prismlauncher.nix
    ./sunshine.nix
    ./syncthing.nix
    ./thunar.nix
    ./tmux.nix
    ./vivaldi.nix
    ./vscodium.nix
    ./wazuh.nix
    ./zsh.nix
  ];

  hostImports = {
    Acer = [
      ./guacamole.nix
      ./razer.nix
      ./steam.nix
      ./wireguard-dev.nix
      ./zabbix-Acer.nix
    ];

    Orion = [
      ./autologin.nix
      ./cast.nix
      ./guacamole.nix
      ./hip.nix
      ./hyprland.nix
      ./internet.nix
      ./lact.nix
      ./nfs.nix
      ./packet-tracer.nix
      ./rdp.nix
      ./smartd.nix
      ./steam.nix
      ./suspend.nix
      ./zabbix-Orion.nix
    ];

    Thinkpad = [
      ./razer.nix
      ./rdp.nix
      ./vagrant.nix
      ./virtualbox.nix
      ./wireguard-dev.nix
      ./zabbix-Acer.nix
    ];
  };

  hostConfig = {
    Acer = {
      adb.enable = lib.mkDefault true;
      autoupgrade.enable = lib.mkDefault true;
      bluetooth.enable = lib.mkDefault true;
      docker.enable = lib.mkDefault true;
      fonts.enable = lib.mkDefault true;
      git.enable = lib.mkDefault true;
      guacamole.enable = lib.mkDefault true;
      nh.enable = lib.mkDefault true;
      razer.enable = lib.mkDefault false;
      steam.enable = lib.mkDefault true;
      sunshine.enable = lib.mkDefault true;
      syncthing.enable = lib.mkDefault true;
      thunar.enable = lib.mkDefault true;
      tmux.enable = lib.mkDefault true;
      vivaldi.enable = lib.mkDefault true;
      vscodium.enable = lib.mkDefault true;
      wazuh-agent.enable = lib.mkDefault false;
      zabbix-agent.enable = lib.mkDefault false;
      zsh.enable = lib.mkDefault true;
    };

    Orion = {
      adb.enable = lib.mkDefault false;
      autoLogin.enable = lib.mkDefault true;
      autoupgrade.enable = lib.mkDefault true;
      bluetooth.enable = lib.mkDefault true;
      cast.enable = lib.mkDefault true;
      docker.enable = lib.mkDefault true;
      fonts.enable = lib.mkDefault true;
      git.enable = lib.mkDefault true;
      guacamole.enable = lib.mkDefault false;
      hip.enable = lib.mkDefault false;
      homeManager.enable = lib.mkDefault true;
      hyprland.enable = lib.mkDefault false;
      internet-sharing.enable = lib.mkDefault false;
      nfs.enable = lib.mkDefault true;
      nh.enable = lib.mkDefault true;
      packet-tracer.enable = lib.mkDefault false;
      rdp.enable = lib.mkDefault false;
      steam.enable = lib.mkDefault true;
      sunshine.enable = lib.mkDefault true;
      syncthing.enable = lib.mkDefault true;
      thunar.enable = lib.mkDefault true;
      tmux.enable = lib.mkDefault true;
      vivaldi.enable = lib.mkDefault true;
      vscodium.enable = lib.mkDefault true;
      wazuh-agent.enable = lib.mkDefault false;
      zabbix-agent.enable = lib.mkDefault false;
      zsh.enable = lib.mkDefault true;
    };

    Thinkpad = {
      adb.enable = lib.mkDefault true;
      autoupgrade.enable = lib.mkDefault true;
      bluetooth.enable = lib.mkDefault true;
      docker.enable = lib.mkDefault true;
      fonts.enable = lib.mkDefault true;
      git.enable = lib.mkDefault true;
      nh.enable = lib.mkDefault true;
      razer.enable = lib.mkDefault false;
      rdp.enable = lib.mkDefault true;
      sunshine.enable = lib.mkDefault true;
      syncthing.enable = lib.mkDefault true;
      thunar.enable = lib.mkDefault true;
      tmux.enable = lib.mkDefault true;
      vagrant.enable = lib.mkDefault false;
      vivaldi.enable = lib.mkDefault true;
      vscodium.enable = lib.mkDefault true;
      wazuh-agent.enable = lib.mkDefault false;
      zabbix-agent.enable = lib.mkDefault false;
      zsh.enable = lib.mkDefault true;
    };
  };
in
  {
    imports = commonImports ++ (hostImports.${hostName} or []);
  }
  // (hostConfig.${hostName} or {})

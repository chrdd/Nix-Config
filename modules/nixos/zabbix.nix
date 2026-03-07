{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    zabbix-agent.enable = lib.mkEnableOption "Enables Zabbix Agent";
  };

  config = lib.mkIf config.zabbix-agent.enable {
    system.activationScripts.zabbixPsk = {
      text = ''
        mkdir -p /etc/zabbix
        echo -n "ff8c7ccc55928df4cc43082faa46605f9fc1eefa92e6627d41f094a8e167afa8" > /etc/zabbix/psk.secret
        chown -R zabbix:zabbix /etc/zabbix
        chmod 750 /etc/zabbix
        chmod 640 /etc/zabbix/psk.secret
      '';
      deps = [];
    };

    services.zabbixAgent = {
      enable = true;
      server = "100.66.123.77";

      listen = {
        port = 10050;
      };

      settings = {
        Hostname = "PC";
        RefreshActiveChecks = 120;
        Timeout = 10;
        LogFileSize = 10;

        TLSConnect = "psk";
        TLSAccept = "psk";
        TLSPSKIdentity = "PC PSK";
        TLSPSKFile = "/etc/zabbix/psk.secret";
      };
    };

    networking.firewall.allowedTCPPorts = [10050];
  };
}

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
    services.zabbixAgent = {
      enable = true;
      server = "100.66.123.77";

      listen = {
        port = 10050;
      };

      settings = {
        Hostname = "PC";
        ServerActive = "100.66.123.77";
        RefreshActiveChecks = 120;
        Timeout = 10;
        LogFileSize = 10;
      };
    };

    networking.firewall.allowedTCPPorts = [10050];
  };
}

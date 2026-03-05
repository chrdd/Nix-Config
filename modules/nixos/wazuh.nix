{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.nix-ld.enable = true;

  systemd.services.wazuh-agent = {
    description = "Wazuh Agent";
    after = ["network.target"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      ExecStartPre = pkgs.writeShellScript "install-wazuh" ''
        if [ ! -f /opt/wazuh-agent/var/ossec/bin/wazuh-agentd ]; then
          ${pkgs.curl}/bin/curl -so /tmp/wazuh-agent.deb \
            https://packages.wazuh.com/4.x/apt/pool/main/w/wazuh-agent/wazuh-agent_4.9.0-1_amd64.deb
          ${pkgs.dpkg}/bin/dpkg -x /tmp/wazuh-agent.deb /opt/wazuh-agent
        fi
      '';
      ExecStart = "/opt/wazuh-agent/var/ossec/bin/wazuh-agentd -f";
      Environment = "WAZUH_MANAGER=100.66.123.77";
      Restart = "always";
    };
  };
}

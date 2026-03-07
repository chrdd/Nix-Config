{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    wazuh-agent.enable = lib.mkEnableOption "Enables Wazuh Agent";
  };

  config = lib.mkIf config.wazuh-agent.enable {
    programs.nix-ld.enable = true;
    programs.nix-ld.libraries = with pkgs; [
      openssl
      zlib
      gcc-unwrapped.lib
    ];

    users.groups.wazuh = {};
    users.users.wazuh = {
      isSystemUser = true;
      group = "wazuh";
      home = "/opt/wazuh-agent/var/ossec";
      shell = pkgs.shadow;
    };

    systemd.services.wazuh-agent = {
      description = "Wazuh Agent";
      after = ["network.target"];
      wantedBy = ["multi-user.target"];

      # Make awk, grep, ps and other common tools available to wazuh-control
      path = with pkgs; [gawk gnugrep procps coreutils];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;

        ExecStartPre = pkgs.writeShellScript "install-wazuh" ''
          set -e

          INSTALL_PATH="/opt/wazuh-agent"
          AGENT_BIN="$INSTALL_PATH/var/ossec/bin/wazuh-agentd"
          DEB_PATH="/tmp/wazuh-agent-4.14.0.deb"
          OSSEC_CONF="$INSTALL_PATH/var/ossec/etc/ossec.conf"
          CLIENT_KEYS="$INSTALL_PATH/var/ossec/etc/client.keys"

          if [ ! -f "$AGENT_BIN" ]; then
            echo "Downloading Wazuh agent 4.14.0..."
            ${pkgs.curl}/bin/curl -so "$DEB_PATH" \
              "https://packages.wazuh.com/4.x/apt/pool/main/w/wazuh-agent/wazuh-agent_4.14.0-1_amd64.deb"

            echo "Extracting Wazuh agent..."
            ${pkgs.dpkg}/bin/dpkg -x "$DEB_PATH" "$INSTALL_PATH"

            echo "Configuring manager IP..."
            ${pkgs.gnused}/bin/sed -i \
              's|<address>.*</address>|<address>100.66.123.77</address>|' \
              "$OSSEC_CONF"

            echo "Fixing ownership..."
            chown -R wazuh:wazuh "$INSTALL_PATH/var/ossec"

            rm -f "$DEB_PATH"
          fi

          # Register with manager if not already registered
          if [ ! -s "$CLIENT_KEYS" ]; then
            echo "Registering agent with manager..."
            $INSTALL_PATH/var/ossec/bin/agent-auth -m 100.66.123.77
            chown wazuh:wazuh "$CLIENT_KEYS"
          fi
        '';

        ExecStart = pkgs.writeShellScript "start-wazuh" ''
          /opt/wazuh-agent/var/ossec/bin/wazuh-control start
        '';

        ExecStop = pkgs.writeShellScript "stop-wazuh" ''
          /opt/wazuh-agent/var/ossec/bin/wazuh-control stop
        '';

        Restart = "on-failure";
        RestartSec = "10s";
      };
    };

    networking.firewall.allowedTCPPorts = [1514 1515];
  };
}

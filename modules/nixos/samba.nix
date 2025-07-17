{
  config,
  lib,
  pkgs,
  ...
}: let
  secretsFile = "/etc/nixos/secrets/smbsecrets.json";
  credentialsFile = "/etc/nixos/smb-secrets";
in {
  options.services.sambaClient.enable = lib.mkEnableOption "Enable Samba CIFS client";

  config = lib.mkIf config.services.sambaClient.enable {
    environment.systemPackages = [pkgs.cifs-utils pkgs.jq];

    systemd.tmpfiles.rules = [
      "d /mnt/share 0755 root root -"
    ];

    systemd.services.generate-smb-credentials = {
      description = "Generate CIFS credentials from secrets.json";
      wantedBy = ["remote-fs-pre.target"];
      before = ["remote-fs-pre.target"];
      after = ["network-online.target"];
      wants = ["network-online.target"];
      script = ''
        set -eu

        # Check if secrets file exists and is readable
        if [ ! -f "${secretsFile}" ]; then
          echo "Error: Secrets file ${secretsFile} not found"
          exit 1
        fi

        # Extract credentials from JSON
        USER=$(${pkgs.jq}/bin/jq -r '.username' "${secretsFile}")
        PASS=$(${pkgs.jq}/bin/jq -r '.password' "${secretsFile}")
        DOMAIN=$(${pkgs.jq}/bin/jq -r '.domain // "WORKGROUP"' "${secretsFile}")

        # Validate that we got actual values (not null)
        if [ "$USER" = "null" ] || [ "$PASS" = "null" ]; then
          echo "Error: Could not extract username or password from secrets file"
          exit 1
        fi

        # Generate credentials file
        echo "username=$USER" > "${credentialsFile}"
        echo "password=$PASS" >> "${credentialsFile}"
        echo "domain=$DOMAIN" >> "${credentialsFile}"
        chmod 0400 "${credentialsFile}"

        echo "SMB credentials generated successfully"
      '';
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
    };

    fileSystems."/mnt/share" = {
      device = "//192.168.3.8/Media";
      fsType = "cifs";
      options = let
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
        cifs_opts = "credentials=${credentialsFile},vers=3.0,uid=1000,gid=100,file_mode=0644,dir_mode=0755";
      in ["${automount_opts},${cifs_opts}"];
    };
  };
}

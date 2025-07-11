{
  config,
  lib,
  pkgs,
  ...
}: let
  secretsFile = "/run/secrets/secrets.json";
  credentialsFile = "/etc/nixos/smb-secrets"; # This is what mount.cifs expects
in {
  imports = [];

  options.services.sambaClient.enable = lib.mkEnableOption "Enable Samba client with CIFS mount";

  config = lib.mkIf config.services.sambaClient.enable {
    environment.systemPackages = [pkgs.cifs-utils pkgs.jq];

    # Ensure mount point exists
    systemd.tmpfiles.rules = [
      "d /mnt/share 0755 root root -"
    ];

    # Write the credentials file at boot
    systemd.services.generate-smb-credentials = {
      description = "Generate CIFS credentials from secrets.json";
      wantedBy = ["multi-user.target"];
      before = ["mnt-share.mount"];
      script = ''
        set -eu
        USER=$(jq -r '.truenas.username' ${secretsFile})
        PASS=$(jq -r '.truenas.password' ${secretsFile})

        echo "username=$USER" > ${credentialsFile}
        echo "password=$PASS" >> ${credentialsFile}
        chmod 0400 ${credentialsFile}
      '';
      serviceConfig = {
        Type = "oneshot";
      };
    };

    # Mount config
    fileSystems."/mnt/share" = {
      device = "//192.168.3.8/Media";
      fsType = "cifs";
      options = let
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
      in ["${automount_opts},credentials=${credentialsFile},vers=3.0"];
    };
  };
}

{
  config,
  lib,
  ...
}: let
  cfg = config.nas;

  # Path on the server for a given subfolder of the export
  remotePath = sub:
    if sub == ""
    then cfg.exportRoot
    else "${cfg.exportRoot}/${sub}";
in {
  options.nas = {
    enable = lib.mkEnableOption "TrueNAS NFS mounts";

    server = lib.mkOption {
      type = lib.types.str;
      default = "100.66.123.77";
      description = "TrueNAS address (Tailscale IP, LAN IP or resolvable hostname).";
    };

    exportRoot = lib.mkOption {
      type = lib.types.str;
      default = "/mnt/Media";
      description = "Path of the NFS share as configured on TrueNAS.";
    };

    mounts = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {
        "/mnt/nas/general" = "General";
        "/mnt/nas/music" = "Music";
      };
      example = {"/mnt/nas/all" = "";};
      description = ''
        Local mount point -> subfolder of the export.
        Use "" to mount the whole export.
      '';
    };

    extraOptions = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      example = ["ro"];
      description = "Extra mount options appended to the defaults.";
    };
  };

  config = lib.mkIf cfg.enable {
    boot.supportedFilesystems = ["nfs"];

    fileSystems =
      lib.mapAttrs (_: sub: {
        device = "${cfg.server}:${remotePath sub}";
        fsType = "nfs";
        options =
          [
            "nfsvers=4.2"
            "noauto" # don't mount at boot
            "x-systemd.automount" # mount on first access
            "x-systemd.idle-timeout=600" # unmount after 10 min idle
            "x-systemd.mount-timeout=10s" # don't hang when the NAS is unreachable
            "_netdev" # wait for the network
          ]
          ++ cfg.extraOptions;
      })
      cfg.mounts;
  };
}

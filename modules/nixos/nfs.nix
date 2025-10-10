{
  pkgs,
  config,
  lib,
  ...
}: {
  options = {
    nfs.enable = lib.mkEnableOption "Enables NFS Client";
  };
  config = lib.mkIf config.nfs.enable {
    boot.supportedFilesystems = ["nfs"];
  };
}

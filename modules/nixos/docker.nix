{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    docker.enable = lib.mkEnableOption "Enables Docker";
  };
  config = lib.mkIf config.docker.enable {
    virtualisation.docker.enable = true;
    users.users.octavian.extraGroups = ["docker"];
    environment.systemPackages = with pkgs; [docker-compose];
  };
}

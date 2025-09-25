{
  config,
  lib,
  pkgs,
  ...
}: {
  virtualisation.docker.enable = true;
  users.users.octavian.extraGroups = ["docker"];
  environment.systemPackages = with pkgs; [docker-compose];
}

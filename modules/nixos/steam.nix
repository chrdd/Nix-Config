{ config, pkgs, ... }:
{
  hardware.steam-hardware.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server  
    gamescopeSession.enable = true;
  };
  programs.steam.extraCompatPackages = [ pkgs.proton-ge-bin];
}
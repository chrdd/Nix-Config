{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    steam.enable = lib.mkEnableOption "Enables Steam";
  };
  config = lib.mkIf config.steam.enable {
    hardware.steam-hardware.enable = true;
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      gamescopeSession.enable = true;
      extraCompatPackages = [
        # inputs.nix-proton-cachyos.packages.${system}.proton-cachyos
        pkgs.proton-ge-bin
      ];
    };
    programs.gamemode.enable = true;
  };
}

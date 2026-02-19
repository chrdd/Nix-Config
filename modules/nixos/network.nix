{
  config,
  lib,
  pkgs,
  ...
}: {
  networking.firewall.allowPing = true;
  networking.networkmanager.enable = true;
  # Open ports in the firewall.
  # networking.firewall.enable = false;
  # networking.useDHCP = false;
  networking.firewall = {
    enable = true;
    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      } # KDE Connect
    ];
    allowedTCPPorts = [22 4747 32400 32500 47984 47989 47990 48010 5900 8082 8085 64738];
    allowedUDPPortRanges = [
      {
        from = 1714;
        to = 1764;
      } # KDE Connect
      {
        from = 47998;
        to = 48000;
      }
      {
        from = 8000;
        to = 8010;
      }
    ];
    allowedUDPPorts = [4747 8082 8085 32400 32500 64738];
  };

  # Tailscale
  services.tailscale.enable = true;
  services.openssh.enable = true;
}

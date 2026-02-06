{
  pkgs,
  config,
  lib,
  ...
}: {
  options = {
    rdp.enable = lib.mkEnableOption "Enables RDP";
  };
  config = lib.mkIf config.rdp.enable {
    #RDP
    #programs.ssh.askPassword = pkgs.lib.mkForce "${pkgs.ksshaskpass.out}/bin/ksshaskpass";

    # XDRP
    services.xrdp.enable = true;
    services.xrdp.defaultWindowManager = "plasma";
    services.xrdp.openFirewall = true;
    # services.xdrp={
    #   enable = true;
    #   defaultWindowManager = "plasma";
    #   openFirewall = true;
    # };
  };
}

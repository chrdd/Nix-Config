{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    sunshine.enable = lib.mkEnableOption "Enables Sunshine";
  };
  config = lib.mkIf config.sunshine.enable {
    services.sunshine = {
      enable = true;
      capSysAdmin = true;
      openFirewall = true;
      autoStart = true;
      settings = {
        capture = "kms";
      };
    };
  };
}

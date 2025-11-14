{
  pkgs,
  config,
  lib,
  ...
}: {
  options = {
    autoLogin.enable = lib.mkEnableOption "Enables Autologin";
  };
  config = lib.mkIf config.autoLogin.enable {
    services.displayManager = {
      autoLogin.enable = true;
      autoLogin.user = ''octavian'';
    };
  };
}

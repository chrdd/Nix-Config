{ config, pkgs, ... }:
{
  services.sunshine = {
      enable = true;
      capSysAdmin = true;
      openFirewall = true;
      autoStart = true;
      settings = {
        capture = "kms";
    };
  };
}
{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    vagrant.enable = lib.mkEnableOption "Enables vagrant";
  };

  config = lib.mkIf config.vagrant.enable {
    virtualbox.enable = true;

    environment.systemPackages = with pkgs; [
      vagrant
    ];
  };
}

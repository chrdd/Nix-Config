{
  config,
  lib,
  inputs,
  hostName,
  ...
}: {
  imports = [inputs.home-manager.nixosModules.home-manager];

  options = {
    homeManager.enable = lib.mkEnableOption "Enables Home Manager for the octavian user";
  };
  config = lib.mkIf config.homeManager.enable {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "hm-backup";
      extraSpecialArgs = {inherit inputs hostName;};
      users.octavian = {
        imports = [../home-manager/hosts.nix];
        home = {
          username = "octavian";
          homeDirectory = "/home/octavian";
          stateVersion = config.system.stateVersion;
        };
      };
    };
  };
}

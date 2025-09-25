{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    git.enable = lib.mkEnableOption "Enables Git";
  };
  config = lib.mkIf config.git.enable {
    programs.git = {
      enable = true;
      config = {
        user.name = "Octavian";
        user.email = "soctavianstefan@gmail.com";
        init.defaultBranch = "main";
        pull.rebase = true;
      };
    };
  };
}

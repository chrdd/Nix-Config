{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    zsh.enable = lib.mkEnableOption "Enables ZSH";
  };
  config = lib.mkIf config.zsh.enable {
    programs.zsh = {
      enable = true;
      autosuggestions.enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      ohMyZsh = {
        enable = true;
        plugins = ["git"];
        theme = "eastwood";
      };
    };
    users.defaultUserShell = pkgs.zsh;
  };
}

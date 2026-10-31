{
  config,
  lib,
  ...
}: {
  options = {
    zoxide.enable = lib.mkEnableOption "Enables zoxide";
  };
  config = lib.mkIf config.zoxide.enable {
    programs.zoxide = {
      enable = true;
      enableZshIntegration = true; # replaces: eval "$(zoxide init zsh)"
    };
  };
}

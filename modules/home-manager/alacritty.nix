{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    alacritty.enable = lib.mkEnableOption "Enables Alacritty";
  };
  config = lib.mkIf config.alacritty.enable {
    fonts.fontconfig.enable = true;
    home.packages = [pkgs.nerd-fonts.jetbrains-mono];

    programs.alacritty = {
      enable = true;
      settings.font = {
        normal = {
          family = "JetBrainsMono Nerd Font";
          style = "Regular";
        };
        size = 11.25; # Alacritty's default, so nothing changes size
      };
    };
  };
}

{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    fonts.enable = lib.mkEnableOption "Enables additional fonts";
  };
  config = lib.mkIf config.fonts.enable {
    #fonts.fontconfig.enableProfileFonts = true;
    fonts.packages = with pkgs; [
      dina-font
      fira-code
      fira-code-symbols
      jetbrains-mono
      liberation_ttf
      mplus-outline-fonts.githubRelease
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      proggyfonts
    ];
  };
}

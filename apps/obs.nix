{
  pkgs,
  inputs,
  lib,
  config,
  ...
}: {

options = {
    obs.enable= lib.mkEnableOption "enables OBS";

};
config = lib.mkIf config.obs.enable{
      programs.obs-studio = {
        #enable = true;
        plugins = with pkgs.obs-studio-plugins; [
          wlrobs
          obs-vaapi
          obs-vkcapture
          obs-pipewire-audio-capture
        ];
  };
};
}

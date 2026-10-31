{
  config,
  lib,
  ...
}: {
  options = {
    zsh.enable = lib.mkEnableOption "Enables ZSH user configuration";
  };
  config = lib.mkIf config.zsh.enable {
    programs.zsh = {
      enable = true;

      # compinit, autosuggestions, syntax highlighting and oh-my-zsh already
      # come from the system module (modules/nixos/zsh.nix). Leaving completion
      # on here would run compinit a second time and slow down shell startup.
      enableCompletion = false;

      # bindkey -e
      defaultKeymap = "emacs";

      # Same file as before, so your existing history carries over
      history = {
        path = "${config.home.homeDirectory}/.histfile";
        size = 10000;
        save = 10000;
      };
    };
  };
}

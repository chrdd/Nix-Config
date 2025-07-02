{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;
    config = { 
      user.name = "Octavian"; 
      user.email = "soctavianstefan@gmail.com";
      init.defaultBranch = "main";
      pull.rebase = true;
      };
  };
}
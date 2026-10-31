{
  lib,
  hostName,
  ...
}: let
  commonImports = [
    ./alacritty.nix
    ./helium.nix
    ./plasma.nix
    ./zed.nix
    ./zoxide.nix
    ./zsh.nix
  ];

  hostImports = {
    Acer = [];
    Orion = [];
    Thinkpad = [];
  };

  hostConfig = {
    Acer = {
      alacritty.enable = lib.mkDefault true;
      helium.enable = lib.mkDefault true;
      plasma.enable = lib.mkDefault false;
      zed.enable = lib.mkDefault true;
      zoxide.enable = lib.mkDefault true;
      zsh.enable = lib.mkDefault true;
    };

    Orion = {
      alacritty.enable = lib.mkDefault true;
      helium.enable = lib.mkDefault true;
      plasma.enable = lib.mkDefault true;
      zed.enable = lib.mkDefault true;
      zoxide.enable = lib.mkDefault true;
      zsh.enable = lib.mkDefault true;
    };

    Thinkpad = {
      alacritty.enable = lib.mkDefault true;
      helium.enable = lib.mkDefault true;
      plasma.enable = lib.mkDefault false;
      zed.enable = lib.mkDefault true;
      zoxide.enable = lib.mkDefault true;
      zsh.enable = lib.mkDefault true;
    };
  };
in
  {
    imports = commonImports ++ (hostImports.${hostName} or []);
  }
  // (hostConfig.${hostName} or {})

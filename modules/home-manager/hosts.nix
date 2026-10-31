{
  lib,
  hostName,
  ...
}: let
  commonImports = [
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
      zed.enable = lib.mkDefault true;
      zoxide.enable = lib.mkDefault true;
      zsh.enable = lib.mkDefault true;
    };

    Orion = {
      zed.enable = lib.mkDefault true;
      zoxide.enable = lib.mkDefault true;
      zsh.enable = lib.mkDefault true;
    };

    Thinkpad = {
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

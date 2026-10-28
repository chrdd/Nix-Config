{
  config,
  pkgs,
  lib,
  hostName,
  ...
}: {
  options = {
    zed.enable = lib.mkEnableOption "Enables Zed editor";
    zed.flakePath = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/Nix-Config";
      description = "Local path of this flake, used by nixd for option completion";
    };
    zed.hostName = lib.mkOption {
      type = lib.types.str;
      default = hostName;
      description = "nixosConfigurations attribute nixd reads options from";
    };
  };
  config = lib.mkIf config.zed.enable {
    # CLI linters, available in the shell as well
    home.packages = with pkgs; [
      statix
      deadnix
    ];

    programs.zed-editor = {
      enable = true;

      # Written to settings.json as auto_install_extensions
      extensions = ["nix" "ruff" "git-firefly"];

      # Language servers and formatter, on Zed's PATH only
      extraPackages = with pkgs; [
        nixd
        nil
        alejandra
        pyright
        ruff
        yaml-language-server
      ];

      userSettings = {
        languages = {
          Nix = {
            language_servers = ["nixd" "nil" "..."];
            formatter.external = {
              command = "alejandra";
              arguments = ["--quiet" "--"];
            };
            format_on_save = "on";
          };
          Python.language_servers = ["pyright" "ruff" "..."];
        };

        lsp = {
          nixd = {
            binary.path = "nixd";
            settings.nixd = {
              nixpkgs.expr = "import (builtins.getFlake \"${config.zed.flakePath}\").inputs.nixpkgs { }";
              formatting.command = ["alejandra"];
              options.nixos.expr = "(builtins.getFlake \"${config.zed.flakePath}\").nixosConfigurations.${config.zed.hostName}.options";
            };
          };
          nil = {
            binary.path = "nil";
            initialization_options.formatting.command = ["alejandra" "--quiet" "--"];
          };
          pyright.binary = {
            path = "pyright-langserver";
            arguments = ["--stdio"];
          };
          yaml-language-server.binary = {
            path = "yaml-language-server";
            arguments = ["--stdio"];
          };
        };
      };
    };
  };
}

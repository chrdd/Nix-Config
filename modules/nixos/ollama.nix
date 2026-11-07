{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.ollama;
in {
  options = {
    ollama.enable = lib.mkEnableOption "Enables Ollama";
    ollama.backend = lib.mkOption {
      type = lib.types.enum ["rocm" "vulkan" "cpu"];
      default = "rocm";
      description = "GPU backend. Switch to vulkan if rocm doesn't detect the RX 9070 XT";
    };
    ollama.models = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "gpt-oss:20b"
        "qwen3-coder:30b"
        "qwen2.5-coder:14b"
      ];
      description = "Models pulled automatically after the service starts";
    };
    ollama.contextLength = lib.mkOption {
      type = lib.types.int;
      default = 16384;
      description = "Default context window. Ollama's own default is small for coding";
    };
    ollama.tailnet.enable = lib.mkEnableOption "Lets other Tailscale devices use Ollama and Open WebUI";
    ollama.webui.enable = lib.mkEnableOption "Enables the Open WebUI chat frontend";
  };

  config = lib.mkIf cfg.enable {
    services.ollama = {
      enable = true;
      package =
        {
          rocm = pkgs.ollama-rocm;
          vulkan = pkgs.ollama-vulkan;
          cpu = pkgs.ollama-cpu;
        }
        .${
          cfg.backend
        };
      loadModels = cfg.models;
      host =
        if cfg.tailnet.enable
        then "0.0.0.0"
        else "127.0.0.1";
      environmentVariables =
        {
          OLLAMA_CONTEXT_LENGTH = toString cfg.contextLength;
          OLLAMA_FLASH_ATTENTION = "1";
        }
        // lib.optionalAttrs (cfg.backend == "vulkan") {OLLAMA_VULKAN = "1";};
    };

    services.open-webui = lib.mkIf cfg.webui.enable {
      enable = true;
      port = 8080;
      host =
        if cfg.tailnet.enable
        then "0.0.0.0"
        else "127.0.0.1";
      environment = {
        OLLAMA_API_BASE_URL = "http://127.0.0.1:${toString config.services.ollama.port}";
        ANONYMIZED_TELEMETRY = "False";
        DO_NOT_TRACK = "True";
        SCARF_NO_ANALYTICS = "True";
      };
    };

    # Reachable over Tailscale only, never on the LAN
    networking.firewall.interfaces."tailscale0".allowedTCPPorts = lib.mkIf cfg.tailnet.enable (
      [config.services.ollama.port] ++ lib.optional cfg.webui.enable 8080
    );
  };
}

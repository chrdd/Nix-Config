{
  config,
  lib,
  ...
}: {
  options = {
    searxng.enable = lib.mkEnableOption "Enables SearXNG";
    searxng.port = lib.mkOption {
      type = lib.types.port;
      default = 8888;
      description = "Port SearXNG listens on (reachable over Tailscale only)";
    };
    searxng.environmentFile = lib.mkOption {
      type = lib.types.str;
      default = "/etc/searxng.env";
      description = "File holding SEARXNG_SECRET, kept out of the repo and the Nix store";
    };
  };
  config = lib.mkIf config.searxng.enable {
    services.searx = {
      enable = true;
      environmentFile = config.searxng.environmentFile;
      settings = {
        server = {
          bind_address = "0.0.0.0";
          port = config.searxng.port;
          secret_key = "@SEARXNG_SECRET@";
          limiter = false; # private instance, and it avoids needing Redis on 2 GB
          public_instance = false;
          image_proxy = true;
          method = "GET"; # lets browsers use /search?q=%s
        };
        search = {
          autocomplete = "duckduckgo";
          formats = ["html" "json"];
        };
      };
    };

    # Open the port on the Tailscale interface only, not on the LAN
    # networking.firewall.interfaces."tailscale0".allowedTCPPorts = [config.searxng.port];
    networking.firewall.allowedTCPPorts = [config.searxng.port];
  };
}

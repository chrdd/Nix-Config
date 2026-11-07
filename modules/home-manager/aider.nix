{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  options = {
    aider.enable = lib.mkEnableOption "Enables aider with the local Ollama server";
  };
  config = lib.mkIf config.aider.enable {
    home.packages = [
      inputs.nixpkgs-stable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.aider-chat
    ];
    home.sessionVariables.OLLAMA_API_BASE = "http://127.0.0.1:11434";
  };
}

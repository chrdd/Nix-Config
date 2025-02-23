{ config, pkgs, ... }:
{
  services.ollama = {
  enable = true;
  loadModels = [ "codellama" "llama3.2" "deepseek-r1" ];
  acceleration = "rocm";
  rocmOverrideGfx = "10.3.0";
  }; 
}
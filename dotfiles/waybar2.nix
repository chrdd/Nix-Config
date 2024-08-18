{ config, pkgs,lib,inputs, ... }:
{
    programs.waybar.settings =  {
    layer = "top";
    position = "top";
    height = "24";
    width = "1366";
    modules-left =[
      "hyprland/workspaces" 
      "hyprland/mode" 
      "custom/spotify"
      ];
    modules-center = [
      "hyprland/window"
      ];
    modules-right = [
      "backlight" 
      "pulseaudio" 
      "network" 
      "cpu" 
      "memory" 
      "tray" 
      "clock"
      ];
    hyprland.workspaces = {
        disable-scroll = true;
        all-outputs = false;
        format = "{icon}";
        format-icons = {
            "1" = "";
            "2" = "";
            "3" = "";
            "4" = "";
            "5" = "";
            "urgent" = "";
            "focused" = "";
            "default" = "";
        };
    };
    hyprland.mode = {
        format = "<span style=\"italic\">{}</span>";
    };
    tray = {
      icon-size = 21;
      spacing = 10;
    };
    clock = {
      format-alt = "{:%Y-%m-%d}";
    };
    cpu = {
      format = "{usage}% ";
    };
    memory = {
      format = "{}% ";
    };
    pulseaudio = {
      scroll-step = 1;
      format = "{volume}% {icon}";
      format-muted = "";
      format-icons = {
        headphones = "";
        handsfree ="";
        headset = "";
        phone = "";
        portable ="";
        car = "";
        default = [
          ""
          ""
         ];
      };
      on-click = "";
    };
  };
  
  programs.waybar.style = {
  
    border = "none";
    border-radius = 0;
    font-family = "Ubuntu Nerd Font";
    font-size = "13px";
    min-height = 0;
  };
}
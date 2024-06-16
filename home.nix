{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    inputs.nix-colors.homeManagerModules.default
    ./features/alacritty.nix
  ];

  colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-medium;

  home.username = "octavian";
  home.homeDirectory = "/home/octavian";
  home.stateVersion = "23.11";

  # Enable GTK and QT
  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    theme = {
      name = "Gruvbox-Dark-B";
      package = pkgs.gruvbox-gtk-theme;
    };
    cursorTheme = {
      name = "Numix-Cursor";
      package = pkgs.numix-cursor-theme;
    };
    gtk3.extraConfig = {
      Settings = "gtk-application-prefer-dark-theme=1";
    };
    gtk4.extraConfig = {
      Settings = "gtk-application-prefer-dark-theme=1";
    };
  };

  home.sessionVariables.GTK_THEME = "Gruvbox-Dark-B";

  qt = {
    platformTheme = "gtk";
    style = {
      name = "colloid-kde";
      package = pkgs.colloid-kde;
    };
  };

  home.packages = [
    (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" "FiraCode" "DroidSansMono" ]; })
    pkgs.noto-fonts
    pkgs.noto-fonts-cjk
    pkgs.noto-fonts-emoji
    pkgs.liberation_ttf
    pkgs.fira-code
    pkgs.fira-code-symbols
    pkgs.mplus-outline-fonts.githubRelease
    pkgs.proggyfonts
    pkgs.jetbrains-mono
    pkgs.roboto-serif
    pkgs.aileron
  ];

  fonts.fontconfig.enable = true;

  home.file = {
    # Example: ".screenrc"."source" = dotfiles/screenrc;
  };

  home.sessionVariables = {
    # Example: EDITOR = "emacs";
  };

  programs.home-manager.enable = true;

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };

  programs.btop.settings = {
    color_theme = "gruvbox";
    theme_background = false;
  };

  programs.waybar.settings = {
    layer = "top";
    position = "top";
    height = "24";
    width = "1366";
    modules-left = [ "hyprland/workspaces" "hyprland/mode" "custom/spotify" ];
    modules-center = [ "hyprland/window" ];
    modules-right = [ "backlight" "pulseaudio" "network" "cpu" "memory" "tray" "clock" ];
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
        handsfree = "";
        headset = "";
        phone = "";
        portable = "";
        car = "";
        default = [ "" "" ];
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

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      exec-once = [
        "hyprpaper"
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "bitwarden"
        "whatsapp-for-linux"
        "discord"
        "kdeconnect-cli --refresh"
        "systemctl start --user polkit-gnome-authentication-agent-1"
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "~/.config/hypr/scripts/resetxdgportal.sh"
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "echo latam > /tmp/kb_layout"
        "systemctl --user restart pipewire"
        "waybar"
        "dunst"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
      ];

      monitor = [
        "DP-1,1920x1080@144,0x1080,auto"
        "HDMI-A-1 ,preferred,0x0,auto"
      ];

      input = {
        "kb_layout" = "us";
        "follow_mouse" = 1;
        sensitivity = -0.3;
      };

      general = {
        "gaps_in" = 5;
        "gaps_out" = 5;
        "border_size" = 0;
        "no_border_on_floating" = true;
        layout = "dwindle";
      };

      misc = {
        "disable_hyprland_logo" = true;
        "disable_splash_rendering" = true;
        "mouse_move_enables_dpms" = true;
        "enable_swallow" = true;
        "swallow_regex" = "^(kitty)$";
      };

      decoration = {
        rounding = 8;
        active_opacity = 1.0;
        inactive_opacity = 0.9;
        blur = {
          enabled = true;
          size = 3;
          passes = 3;
          new_optimizations = true;
          ignore_opacity = false;
        };
        "drop_shadow" = true;
        "shadow_ignore_window" = true;
        "shadow_offset" = "2 2";
        "shadow_range" = 4;
        "shadow_render_power" = 2;
        "col.shadow" = "0x66000000";
        blurls = [
          "gtk-layer-shell"
          "lockscreen"
        ];
      };

      animations = {
        enabled = true;
        bezier = [
          "overshot, 0.05, 0.9, 0.1, 1.05"
          "smoothOut, 0.36, 0, 0.66, -0.56"
          "smoothIn, 0.25, 1, 0.5, 1"
        ];
        animation = [
          "windows, 1, 5, overshot, slide"
          "windowsOut, 1, 4, smoothOut, slide"
          "windowsMove, 1, 4, default"
          "border, 1, 10, default"
          "fade, 1, 10, smoothIn"
          "fadeDim, 1, 10, smoothIn"
          "workspaces, 1, 6, default"
        ];
      };

      dwindle = {
        no_gaps_when_only = false;
        pseudotile = true;
        preserve_split = true;
      };

      windowrule = [
        "float, file_progress"
        "float, confirm"
        "float, dialog"
        "float, download"
        "float, notification"
        "float, error"
        "float, splash"
        "float, confirmreset"
        "float, title:Open File"
        "float, title:branchdialog"
        "float, Lxappearance"
        "float, Rofi"
        "animation none,Rofi"
        "float,viewnior"
        "float,feh"
        "float, pavucontrol-qt"
        "float, pavucontrol"
        "float, file-roller"
        "fullscreen, Lxappearance"
        "float, blurless"
        "float, ibus-extension-gtk"
      ];

      status_command = "echo status";

      submap = {
        mysubmap = [
          "1,exec,alacritty"
          "2,exec,firefox"
          "3,exec,sleep 1"
          "4,exec,notify-send test"
        ];
      };

      default_border = {
        size = 1;
        inactive = "0xff3a3a3a";
        active = "0xff00ff00";
        noresize = true;
      };
    };
  };
}

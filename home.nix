{ config, pkgs,lib,inputs, ... }:

{
  imports = [
      inputs.nix-colors.homeManagerModules.default
      ./features/alacritty.nix
      ./dotfiles/hyprland.nix
      ./modules/sunshine.nix
  ];
  colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-medium;  # Home Manager needs a bit of information about you and the paths it should manage
  
   home.username = "octavian";
   home.homeDirectory = "/home/octavian";
  

  #Stylix

  # home-manager.sharedModules = [{
  #    stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/material-darker.yaml";
  # }];

 

  # GTK Themeing
  gtk = {
    enable = true;

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    theme = {
      name = "orchis-theme";
      package = pkgs.orchis-theme;
    };
    cursorTheme = {
      name = "Numix-cursor";
      package = pkgs.numix-cursor-theme;
    };
    gtk3.extraConfig = {
      Settings = '' gtk-application-prefer-dark-theme=1'';
    };
    gtk4.extraConfig = {
      Settings = '' gtk-application-prefer-dark-theme=1'';
    };
  };

  home.sessionVariables.GTK_THEME = "Gruvbox-Dark-B";


  # QT themeing
  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "Colloid-dark";
    style.package = pkgs.colloid-kde;
  };
  # # QT themeing
  # qt.platformTheme = "gtk";
  # #qt.style.name = "colloid-kde";
  # qt.style.package = pkgs.colloid-kde;

  # gtk = {
  #   theme={
  #     name= "adw-gtk3";
  #     package = pkgs.adw-gtk3; 
  #   };
  #     iconTheme = {
  #      name = "Colloid";
  #      package = pkgs.colloid-icon-theme;
  #     };
  #     cursorTheme = {
  #      name = "Numix-Cursor-Light";
  #     package = pkgs.numix-cursor-theme;
  #     };
  # };

  # gtk.cursorTheme.package = pkgs.bibata-cursors;
  # gtk.cursorTheme.name = "Bibata-Modern-Classic";

  # home.pointerCursor = {
  #   package = pkgs.bibata-cursors;
  #   name = "Bibata-Modern-Classic";
  #   size = 18;
  # };
 
  #This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
 
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" "FiraCode" "DroidSansMono" ]; })
    pkgs.noto-fonts
    pkgs.noto-fonts-cjk
    pkgs.noto-fonts-emoji
    pkgs.liberation_ttf
    pkgs.fira-code
    pkgs.fira-code-symbols
    pkgs.mplus-outline-fonts.githubRelease
    # pkgs.dina-font
    pkgs.proggyfonts
    pkgs.jetbrains-mono
    pkgs.roboto-serif
    pkgs.aileron
    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')


  ];
  fonts.fontconfig.enable = true;
  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc"."source" = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually "source" 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/octavian/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;




  dconf = {
      enable = true;
      settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
        };
      };
  };



#Btop
programs.btop.settings={
  color_theme = "gruvbox";
  theme_background = false;
}; 

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

  # window#waybar {
  #     background: transparent;
  #     color: white;
  # };

  # window {
  #     font-weight: bold;
  #     font-family: "Ubuntu";
  # };

  # workspaces {
  #     padding: 0 5px;
  # };


  # workspaces button {
  #     padding: 0 5px;
  #     background: transparent;
  #     color: white;
  #     border-top: 2px solid transparent;
  # };

  # workspaces button.focused {
  #   color: #c9545d;
  #   border-top: 2px solid #c9545d;
  # };

  # mode {
  #     background: #64727D;
  #     border-bottom: 3px solid white;
  # };


  # clock {
  #   font-weight: bold;
  # };

# programs.kitty{
#   enable = true;
#   font.name = Jetbrains Mono;
#   font.package = jetbrains-mono;
#   font.size = 12;

# }



#Hyprland
# 
}

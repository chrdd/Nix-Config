{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    # Import your dotfiles and features when ready
    # ./dotfiles/gtk.nix
    # ./dotfiles/qt.nix
    # ./features/alacritty.nix
  ];

  # Basic user info
  home.username = "octavian";
  home.homeDirectory = "/home/octavian";

  # Don't change this even if you update Home Manager
  home.stateVersion = "23.11";

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # ============================================================================
  # PACKAGE MANAGEMENT
  # ============================================================================

  home.packages = with pkgs; [
    # Fonts
    (nerdfonts.override {
      fonts = [
        "FantasqueSansMono"
        "FiraCode"
        "DroidSansMono"
        "JetBrainsMono"
      ];
    })
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    proggyfonts
    jetbrains-mono
    roboto-serif
    aileron
  ];

  # Enable font configuration
  fonts.fontconfig.enable = true;

  # ============================================================================
  # GTK THEMING
  # ============================================================================

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

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  # GTK theme environment variable
  home.sessionVariables = {
    GTK_THEME = "Gruvbox-Dark-B";
  };

  # ============================================================================
  # QT THEMING (uncomment if you want Qt apps to match GTK)
  # ============================================================================

  qt = {
    enable = true;
    platformTheme.name = "gtk"; # Makes Qt apps use GTK theme
    style.name = "adwaita-dark";
  };

  # ============================================================================
  # DCONF SETTINGS (GNOME apps dark mode)
  # ============================================================================

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };

  # ============================================================================
  # PROGRAM CONFIGURATIONS
  # ============================================================================

  # Btop configuration
  programs.btop = {
    enable = true;
    settings = {
      color_theme = "gruvbox_dark";
      theme_background = false;
      vim_keys = true;
      rounded_corners = true;
    };
  };

  # Git configuration
  programs.git = {
    enable = true;
    userName = "octavian";
    userEmail = "your-email@example.com"; # Change this!

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
      core.editor = "nano"; # or vim, code, etc.
    };
  };

  # Zsh configuration (if you use it)
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "git"
        "sudo"
        "history"
      ];
    };

    initExtra = ''
      # Add your custom zsh configuration here
    '';
  };

  # Starship prompt (modern shell prompt)
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
    };
  };

  # Direnv (auto-load dev environments)
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Zoxide (better cd)
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  # ============================================================================
  # FILE MANAGEMENT
  # ============================================================================

  home.file = {
    # Example: Add custom scripts
    # ".local/bin/my-script".source = ./scripts/my-script.sh;

    # Example: Custom configuration files
    # ".config/something/config.conf".text = ''
    #   setting = value
    # '';
  };

  # ============================================================================
  # XDG USER DIRECTORIES
  # ============================================================================

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "${config.home.homeDirectory}/Desktop";
      documents = "${config.home.homeDirectory}/Documents";
      download = "${config.home.homeDirectory}/Downloads";
      music = "${config.home.homeDirectory}/Music";
      pictures = "${config.home.homeDirectory}/Pictures";
      videos = "${config.home.homeDirectory}/Videos";
    };
  };

  # ============================================================================
  # SERVICES
  # ============================================================================

  # Syncthing user service (if you use it)
  # services.syncthing = {
  #   enable = true;
  # };

  # ============================================================================
  # ADDITIONAL CONFIGURATIONS
  # ============================================================================

  # Cursor theme (optional)
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };

  # ============================================================================
  # PLASMA/KDE SPECIFIC (if using Plasma)
  # ============================================================================

  # KDE settings can be managed here
  # programs.plasma = {
  #   enable = true;
  #   # Add plasma-specific configurations
  # };
}

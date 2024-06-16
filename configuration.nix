# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, pkgs, ... }:

{
  # Import necessary modules and hardware configuration
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # ./apps
      inputs.home-manager.nixosModules.home-manager
    ];

  # Configure Nix with experimental features
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Home Manager configuration
  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      octavian = import ./home.nix;
    };
  };

  # Bootloader configuration
  boot = {
    tmp.cleanOnBoot = true;  # Clean /tmp on boot
    supportedFilesystems = ["ntfs"];  # Support for NTFS filesystem
    loader = {
      efi.canTouchEfiVariables = true;  # Allow EFI variable modification
      grub = {
        device = "nodev";  # No device for GRUB
        efiSupport = true;  # Enable EFI support for GRUB
        enable = true;  # Enable GRUB
        useOSProber = true;  # Use OS prober for detecting other OS
        timeoutStyle = "menu";  # Show GRUB menu
      };
      timeout = 300;  # Set bootloader timeout
    };
  };

  # Set the hostname
  networking.hostName = "nixos"; # Define your hostname.

  # Set your time zone
  time.timeZone = "Europe/Bucharest";

  # Internationalization settings
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ro_RO.UTF-8";
    LC_IDENTIFICATION = "ro_RO.UTF-8";
    LC_MEASUREMENT = "ro_RO.UTF-8";
    LC_MONETARY = "ro_RO.UTF-8";
    LC_NAME = "ro_RO.UTF-8";
    LC_NUMERIC = "ro_RO.UTF-8";
    LC_PAPER = "ro_RO.UTF-8";
    LC_TELEPHONE = "ro_RO.UTF-8";
    LC_TIME = "ro_RO.UTF-8";
  };

  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    xwayland.enable = true;  # Enable XWayland
  };

  # Thunar file manager configuration
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
  };

  # Enable GVFS for mounting and other functionalities
  services.gvfs.enable = true;

  # Enable Tumbler for thumbnail support
  services.tumbler.enable = true;

  # Enable File Roller
  programs.file-roller.enable = true;

  # Enable Bluetooth
  hardware.bluetooth = {
    enable = true;  # Enables support for Bluetooth
    powerOnBoot = true;  # Power on Bluetooth on boot
  };
  services.blueman.enable = true;  # Enable Blueman for Bluetooth management

  # Flatpak configuration
  services.flatpak = {
    enable = true;
    packages = [
      { appId = "tv.plex.PlexDesktop"; origin = "flathub"; }
      { appId = "tv.plex.PlexHTPC"; origin = "flathub"; }
      { appId = "com.github.tchx84.Flatseal"; origin = "flathub"; }
    ];
  };

  # Enable Tailscale VPN
  services.tailscale.enable = true;

  # Media keys configuration using actkbd
  services.actkbd = {
    enable = true;
    bindings = [
      { keys = [ 123 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/runuser -l octavian -c 'amixer set Master 5%+'"; }
      { keys = [ 122 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/runuser -l octavian -c 'amixer set Master 5%-'"; }
      { keys = [ 121 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/runuser -l octavian -c 'amixer -D pulse set Master 1+ toggle'"; }
    ];
  };

  # Steam configuration
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;  # Open firewall for Steam Remote Play
  };

  # Zsh configuration
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "eastwood";
    }; 
  };

  # Environment session variables
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
    LIBGL_DEBUG = "verbose";
    EGL_PLATFORM = "wayland";
  };

  # Enable Nvidia drivers
  services.xserver.videoDrivers = ["nvidia"];

  # Nvidia settings
  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;
    powerManagement.enable = true;
    open = false;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # OBS configuration
  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];

  boot.kernelModules = [
    "v4l2loopback"  # Virtual Camera
    "snd-aloop"     # Virtual Microphone, built-in
  ];

  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=1 card_label="Virtual Cam" exclusive_caps=1
  '';

  # Enable Polkit for managing administrative privileges
  security.polkit.enable = true;

  # Autostart polkit_gnome
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  # Enable X11 and display manager configuration
  services.xserver.enable = true;
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  services.xserver.displayManager.gdm.enable = true;
  services.displayManager.defaultSession = "hyprland";

  # Configure X11 keymap
  services.xserver.xkb = {
    variant = "";
    layout = "us";
  };

  # Syncthing configuration
  services.syncthing = {
    enable = true;
    user = "octavian";
    dataDir = "/home/octavian/Documents";    # Default folder for new synced folders
    configDir = "/home/octavian/Documents/.config/syncthing";   # Folder for Syncthing's settings and keys
  };

  # Enable printing services
  services.printing.enable = true;

  # Sound configuration with PipeWire
  sound = {
    enable = true;
  };

  hardware.pulseaudio.enable = false;

  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse = {
      enable = true;
    };
    jack = {
      enable = true;
    };
  };

  security.rtkit.enable = true;

  # User account configuration
  users.users.octavian = {
    isNormalUser = true;
    description = "octavian";
    extraGroups = [ "networkmanager" "wheel" "audio" ];
    packages = with pkgs; [
      firefox
      kate
    ];
  };

  # Nixpkgs configuration
  nixpkgs.config = {
    allowUnfree = pkgs.lib.mkForce true;  # Allow unfree packages
    allowInsecure = true;  # Allow insecure packages
    vivaldi = {
      proprietaryCodecs = true;
      enableWideVine = true;
    };
  };

  # Security wrapper for Sunshine
  security.wrappers.sunshine = {
    owner = "root";
    group = "root";
    capabilities = "cap_sys_admin+p";
    source = "${pkgs.sunshine}/bin/sunshine";
  };

  # Avahi configuration
  services.avahi = {
    enable = true;
    publish = {
      enable = true;
      userServices = true;
    };
  };

  # Font configuration
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      liberation_ttf
      fira-code
      fira-code-symbols
      mplus-outline-fonts.githubRelease
      dina-font
      proggyfonts
      jetbrains-mono
    ];
  };

  # List packages installed in the system profile
  environment.systemPackages = with pkgs; [
    hyprland
    wget
    pkgs.waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    })
    discord
    bitwarden
    obsidian
    heroic
    tmux
    tor
    tor-browser
    ollama
    zabbix.web
    zabbix.agent
    zabbixctl
    vivaldi
    docker-compose
    youtube-music
    net-snmp
    gparted
    f3
    rpi-imager
    droidcam
    postgresql
    postman
    jetbrains.idea-ultimate
    github-desktop
    pkgs.dunst
    syncthing
    libnotify
    hyprpaper
    kitty
    git
    alacritty
    rofi-wayland
    floorp
    libva
    libvdpau
    libva-utils
    vdpauinfo
    vulkan-tools
    mesa
    mesa-demos
    vscode
    swaylock
    wlogout
    tailscale
    btop
    bottom
    zathura
    steam
    mpv
    vlc
    obs-studio
    whatsapp-for-linux
    wayvnc
    tigervnc
    sunshine
    z-lua
    fish
    sshfs
    ncdu
    ffmpeg_5
    grim
    slurp
    wireplumber
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
    zsh
    lsd
    pavucontrol
    viewnior
    starship
    wl-clipboard
    wf-recorder
    ffmpegthumbnailer
    grimblast
    playerctl
    xfce.tumbler
    nwg-look
    nordic
    papirus-icon-theme
    hackgen-nf-font
    udev-gothic-nf
    noto-fonts
    hyprpicker
    gnome.gnome-keyring
    imagemagick
    pamixer
    libsForQt5.kdeconnect-kde
    xdotool
    xbindkeys
    neofetch
    electron
    vscodium
    ntfs3g
    pkgs.oh-my-zsh
    pkgs.zsh-completions
    pkgs.zsh-powerlevel10k
    pkgs.zsh-syntax-highlighting
    sublime
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    font-awesome
    source-han-sans
    source-han-sans-japanese
    source-han-serif-japanese
    hyprlock
    nwg-look
    xbindkeys
    kdenlive
    parsec-bin
    plexamp
    flatpak
    pkgs.home-manager
    todoist-electron
    masterpdfeditor
    tailscale
    actkbd
    bottles
    arduino-ide
    pkgs.polkit_gnome
    vencord
    jetbrains-mono
    libreoffice
    fastfetch
    dos2unix
    colloid-kde
    colloid-gtk-theme
    colloid-icon-theme
    papirus-icon-theme
    maven
    jdk17
    speedtest-cli
    nodejs
    kwalletmanager
    nerdfonts
    python311
    stdenv.cc.cc.lib
    libstdcxx5
    gnumake
    cmake
    ninja
    gcc
  ];

  # PostgreSQL configuration
  services.postgresql.enable = true;

  # Default user shell
  users.defaultUserShell = pkgs.zsh;
  programs.fish.enable = true;

  # Insecure packages configuration
  nixpkgs.config.permittedInsecurePackages = [ "electron-25.9.0" ];

  # XDG desktop portals
  xdg.portal = {
    enable = true;
    extraPortals = [ 
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  systemd.user.services.xdg-desktop-portal-gtk = {
    wantedBy = [ "xdg-desktop-portal.service" ];
    before = [ "xdg-desktop-portal.service" ];
  };

  # KDE Connect configuration
  programs.kdeconnect.enable = true;

  # OpenGL configuration
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      vulkan-loader
      vulkan-validation-layers
    ];
  };

  # GnuPG agent configuration
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Enable OpenSSH daemon
  services.openssh.enable = true;

  # Enable NetworkManager
  networking.networkmanager.enable = true;

  # Firewall configuration
  networking.firewall = { 
  enable = true;
  allowedTCPPortRanges = [ 
    { from = 1714; to = 1764; } # KDE Connect
  ];
  allowedTCPPorts = [22 4747 47984 47989 47990 48010 5900 8085 ];  
  allowedUDPPortRanges = [ 
    { from = 1714; to = 1764; } # KDE Connect
    { from = 47998; to = 48000; }
  ];  
  allowedUDPPorts = [ 4747 8085 ];
};

  # Enable ADB
  programs.adb.enable = true;

  # System state version
  system.stateVersion = "23.11"; # Did you read the comment?
}

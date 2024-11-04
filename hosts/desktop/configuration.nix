# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).


{ inputs, config, pkgs,lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      #./apps
      inputs.home-manager.nixosModules.home-manager
    ];

  # nix = {
  # package = pkgs.nixFlakes;
  # extraOptions = ''experimental-features = nix-command flakes'';
  # };

  nix.settings.experimental-features = ["nix-command" "flakes"];
  
#   #Home-manager
#   home-manager = {
#     extraSpecialArgs = { inherit inputs; };
#     users = {
#       octavian = import ./home.nix;
#     };
#   };

  # Stylix
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";
  stylix.polarity = "dark";

  # Bootloader.
  #boot.loader.grub.efiSupport = true;
  #boot.loader.grub.useOSProber = true;
 
    boot = {
    tmp.cleanOnBoot = true;
    supportedFilesystems = ["ntfs"];
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        device = "nodev";
        efiSupport = true;
        enable = true;
        useOSProber = true;
        timeoutStyle = "menu";
      };
      timeout = 300;
    };
  };

  networking.hostName = "octavian"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  #networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Bucharest";

  # Select internationalisation properties.
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
    package = inputs.hyprland.packages."${pkgs.system}".hyprland;
    xwayland.enable = true;
  };

#VirtualBox

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "octavian"];
  virtualisation.virtualbox.host.enableExtensionPack = true;
  virtualisation.virtualbox.guest.enable = true; 
  virtualisation.virtualbox.guest.dragAndDrop = true;



  programs.thunar.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];

  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images
  programs.file-roller.enable = true;

  #Bluetooth
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; 
  services.blueman.enable = true;

  #Kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;


  # Flatpak
  # https://github.com/gmodena/nix-flatpak
  services.flatpak.enable = true;
  services.flatpak.packages = [
    { appId = "tv.plex.PlexDesktop"; origin = "flathub"; }
    { appId = "tv.plex.PlexHTPC"; origin = "flathub"; }
    { appId = "com.plexamp.Plexamp"; origin = "flathub"; }
    { appId = "com.github.tchx84.Flatseal"; origin = "flathub"; }
    { appId = "dev.vencord.Vesktop"; origin = "flathub"; }
  ];


  # Tailscale
  services.tailscale.enable = true;

  # Media keys
  # sound.mediaKeys.enable = true;
  services.actkbd = {
      enable = true;
      bindings = [
      #{ keys = [ 115 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/runuser -l octavian -c 'amixer set Master 5%+'"; }
      { keys = [ 115 ]; events = [ "key" ]; command = "${pkgs.alsa-utils}/bin/amixer -q set Master 5%+"; }
      { keys = [ 114 ]; events = [ "key" ]; command = "${pkgs.alsa-utils}/bin/amixer -q set Master 5%-"; }
      { keys = [ 113 ]; events = [ "key" ]; command = "${pkgs.alsa-utils}/bin/amixer -q set Master toggle"; }
    ];
  };


  # Steam
  programs.steam={
    enable = true;
    remotePlay.openFirewall = true;  
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    ohMyZsh = {
          enable = true;
          plugins = [ "git" ];
          theme="eastwood";
      }; 
    };

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
    LIBGL_DEBUG = "verbose";
    EGL_PLATFORM = "wayland";
  };



  #Samba
  fileSystems."/mnt/share/media" = {
    device = "192.168.3.8:/mnt/Media/Media";
    fsType = "nfs";
    options = [ "rw" "nconnect=16" "x-systemd.automount" "noauto"];
  };

# networking.firewall.enable = true;
networking.firewall.allowPing = true;


  ## AMD 

  boot.initrd.kernelModules = ["amdgpu"];
  # services.xserver.videoDrivers = ["amdgpu"];
  services.xserver.videoDrivers = [ "modesetting" ];

  # systemd.tmpfiles.rules = [
  #  "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.hip}"
  # ];
 

  #systemd.tmpfiles.rules = [
  #  "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  #];
 
  #hardware.opengl.driSupport = true; # This is already enabled by default
  #hardware.opengl.driSupport32Bit = true; # For 32 bit applications
  #hardware.graphics.extraPackages = with pkgs; [
  #amdvlk
  #];
  # For 32 bit applications 
  #hardware.graphics.extraPackages32 = with pkgs; [
  #  driversi686Linux.amdvlk
  #];


  # Nvidia settings
  # hardware.nvidia = {
  #   modesetting.enable = true;
  #   nvidiaSettings = true;
  #   powerManagement.enable = true;
  #   open = false;
  #   package = config.boot.kernelPackages.nvidiaPackages.stable;
  # };

  # services.xserver.videoDrivers = [ "nvidia" ];


 
    #OBS
    # https://nixos.wiki/wiki/OBS_Studio
   #boot.extraModulePackages = with config.boot.kernelPackages; [
   #  v4l2loopback
   #];
   #boot.kernelModules = [“v4l2loopback”];
  boot.extraModulePackages = with config.boot.kernelPackages;
  [ v4l2loopback.out ];

    # Activate kernel modules (choose from built-ins and extra ones)
  boot.kernelModules = [
    # Virtual Camera
    "v4l2loopback"
    # Virtual Microphone, built-in
    "snd-aloop"
  ];


   boot.extraModprobeConfig = ''
     options v4l2loopback devices=1 video_nr=1 card_label="Virtual Cam" exclusive_caps=1
   '';
   security.polkit.enable = true; 
   
   # Autostart polkit_gnome
   systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
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
   };

   #Load Nvidia drivers 
   #services.xserver.videoDrivers = ["nvidia"]; # or "nvidiaLegacy470 etc.
   #services.xserver.displayManager.gdm = {
     #enable = true;
     #nvidiaWayland = true;
   #};  
   # Enable the X11 windowing system.
   services.xserver.enable = true;
   #RDP
   #services.xserver.displayManager.sddm.enable = true;
   services.desktopManager.plasma6.enable = true;
  #  services.xserver.desktopManager.gnome.enable = true;
    programs.ssh.askPassword = pkgs.lib.mkForce "${pkgs.ksshaskpass.out}/bin/ksshaskpass";

   #services.xrdp.enable = true;
   #services.xrdp.defaultWindowManager = "hyprland";
   #services.xrdp.openFirewall = true;
   # Enable the KDE Plasma Desktop Environment.
   #services.xserver.displayManager.sddm.wayland.enable = true;
   services.displayManager.sddm.wayland.enable = true;
   services.xserver.displayManager.sddm.enable = true; 
   #Default session
   services.displayManager.defaultSession = "plasma";
   

  #  Nix Helper
  environment.sessionVariables = {
    FLAKE = "/etc/nixos/flake.nix";
    };

   # Sway
   #programs.sway = {
   #  enable = true;
   #  wrapperFeatures.gtk = true;
   #};
   # Swaylock
   #programs.swaylock = {
   #  enable= true;
   #};
   # Swaylock fix
   security.pam.services.swaylock = {};
   #services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  
  services.xserver.xkb.variant = "";
  services.xserver.xkb.layout = "us";

  services = {
    syncthing = {
        enable = true;
        user = "octavian";
        dataDir = "/home/octavian/Documents";    # Default folder for new synced folders
        configDir = "/home/octavian/Documents/.config/syncthing";   # Folder for Syncthing's settings and keys
      };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  # sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.octavian = {
    isNormalUser = true;
    description = "octavian";
    extraGroups = [ "networkmanager" "wheel" "audio" "vboxusers" "dialout"];
    packages = with pkgs; [
      firefox
      kate
    #  thunderbird
    ];
  };


  # Tmux
  programs.tmux = {
  enable = true;
  extraConfig = 
    '' set-option -sa terminal-overrides ",xterm*:Tc"
        set -g mouse on

        unbind C-b
        set -g prefix C-Space
        bind C-Space send-prefix

        # Vim style pane selection
        bind h select-pane -L
        bind j select-pane -D 
        bind k select-pane -U
        bind l select-pane -R

        # Start windows and panes at 1, not 0
        set -g base-index 1
        set -g pane-base-index 1
        set-window-option -g pane-base-index 1
        set-option -g renumber-windows on

        # Use Alt-arrow keys without prefix key to switch panes
        bind -n M-Left select-pane -L
        bind -n M-Right select-pane -R
        bind -n M-Up select-pane -U
        bind -n M-Down select-pane -D

        # Shift arrow to switch windows
        bind -n S-Left  previous-window
        bind -n S-Right next-window

        # Shift Alt vim keys to switch windows
        bind -n M-H previous-window
        bind -n M-L next-window

        set -g @plugin '${pkgs.tmuxPlugins.sensible}'
        set -g @plugin '${pkgs.tmuxPlugins.sensible}'


        # keybindings
        bind-key -T copy-mode-vi v send-keys -X begin-selection
        bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
        bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

        bind '"' split-window -v -c "#{pane_current_path}"
        bind % split-window -h -c "#{pane_current_path}"
    '';
  };

  #XRDP
  services.xrdp.enable = true;
  services.xrdp.openFirewall = true;
  #docker
  #virtualisation.docker.enable = true;
  #users.users.octavian.extraGroups = [ "docker" ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = pkgs.lib.mkForce true;  
  nixpkgs.config.allowInsecure = true;
  
  # Vivaldi
  nixpkgs.config.vivaldi = {
      proprietaryCodecs = true;
      enableWideVine = true;
    };
  #Sunshine
  services.sunshine = {
    enable = true;
    capSysAdmin = true;
    openFirewall = true;
    applications = {
      env = {
        PATH = "$(PATH):$(HOME)/.local/bin";
      };
      apps = [
        {
          name = "1440p Desktop";
          prep-cmd = [
            {
              do = "${pkgs.kdePackages.libkscreen}/bin/kscreen-doctor output.DP-4.mode.2560x1440@144";
              undo = "${pkgs.kdePackages.libkscreen}/bin/kscreen-doctor output.DP-4.mode.3440x1440@144";
            }
          ];
          exclude-global-prep-cmd = "false";
          auto-detach = "true";
        }
        {
          name = "1080p Desktop";
          prep-cmd = [
            {
              do = "${pkgs.kdePackages.libkscreen}/bin/kscreen-doctor output.DP-4.mode.1920x1080@120";
              undo = "${pkgs.kdePackages.libkscreen}/bin/kscreen-doctor output.DP-4.mode.3440x1440@144";
            }
          ];
          exclude-global-prep-cmd = "false";
          auto-detach = "true";
        }
        {
          name = "800p Desktop";
          prep-cmd = [
            {
              do = "${pkgs.kdePackages.libkscreen}/bin/kscreen-doctor output.DP-4.mode.1280x800@144";
              undo = "${pkgs.kdePackages.libkscreen}/bin/kscreen-doctor output.DP-4.mode.3440x1440@144";
            }
          ];
          exclude-global-prep-cmd = "false";
          auto-detach = "true";
        }
      ];
    };
  };
  
  services.avahi.enable = true; 
  services.avahi.publish.enable = true;
  services.avahi.publish.userServices = true;

  #Fonts
  #fonts.fontconfig.enableProfileFonts = true;
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
    jetbrains-mono
  ];
  
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
    hyprland
    # cudaPackages.nvidia_driver
    thunderbird
    mathpix-snipping-tool
    rquickshare
    wget
    lact
    pkgs.waybar
    (pkgs.waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    }))
    hyprcursor
    #wl-paste
    discord
    vencord
    bitwarden
    obsidian
    easyeffects
    nh
    jamesdsp
    nix-output-monitor
    nvd
    pkgs.cifs-utils
    aquamarine
    # virtualbox
    signal-desktop
    moonlight-qt
    libsForQt5.qt5.qtwayland
    kdePackages.qtwayland
    rocmPackages.rocm-smi
    heroic
    tailscale
    tmux
    zoxide
    arduino-ide
    tor
    tor-browser
    #ollama
    # wayvnc
    # guacamole-server
    #zabbix.web
    #zabbix.agent
    #zabbixctl
    vivaldi
    docker-compose
    # modelsim
    youtube-music
    net-snmp
    protonup-qt
    davinci-resolve
    yt-dlp
    flameshot
    gparted
    ranger
    pkgs.nemo-with-extensions
    prismlauncher
    # pkgs.nautilus
    f3
    clinfo
    rpi-imager
    droidcam
    xwaylandvideobridge
    xwayland
    qbittorrent
    #v4l2loopback
    postgresql
    postman
    jetbrains.idea-ultimate
    github-desktop
    pkgs.dunst
    syncthing
    libnotify
    # hyprpaper
    kitty
    git
    # pkgs.wayvnc
    alacritty
    rofi-wayland
    alsa-utils
    floorp
    libva
    libvdpau
    libva-utils
    vdpauinfo
    #vulkan
    vulkan-tools
    libglvnd
    #glu
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
    # wayvnc
    # tigervnc
    sunshine
    z-lua
    # fish
    # neatvnc
    sshfs
    ncdu
    ffmpeg
    grim
    slurp
    wireplumber
    xdg-desktop-portal-gtk
    # xdg-dekstop-portal-kde
    #xdg-desktop-portal-hyprland
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
    pkgs.gnome-keyring
    imagemagick
    pamixer
    libsForQt5.kdeconnect-kde
    plasma5Packages.kdeconnect-kde
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
    #pkgs.zsh-history-substring-search
    sublime
    noto-fonts
    noto-fonts-cjk-sans
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
    # plexamp
    # plex-desktop
    # plex-media-player
    # tautulli
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
    blender
    
    #themes
    colloid-kde
    colloid-gtk-theme
    colloid-icon-theme
    papirus-icon-theme

    #Java
    maven
    jdk17
    speedtest-cli
    nodejs
    kwalletmanager
    nerdfonts
      
    #Sunshine
    libsForQt5.libkscreen

    #v4l2loopback
    #privateGPT dependencies
    # python311
    #stdenv.cc.cc.lib
    #libstdcxx5
    #poetry
    #gnumake
    #cmake
    #ninja
    gcc
  ];
  
  #postgresql
  services.postgresql = {
    enable = true;
  #package = pkgs.postgresql_15;
  # ...
  };

  # ZSH
  users.defaultUserShell = pkgs.zsh;
  # programs.fish.enable = true;
  # Insecure packages
  nixpkgs.config.permittedInsecurePackages = [ "electron-25.9.0" ];

  
    


  # XDG desktop portals
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ 
	# pkgs.xdg-desktop-portal-gtk
	# xdg-dekstop-portal-hyprland
	 ];

  systemd.user.services.xdg-desktop-portal-gtk = {
      wantedBy = [ "xdg-desktop-portal.service" ];
      before = [ "xdg-desktop-portal.service" ];
   };

    #AMD
    systemd.packages = with pkgs; [ lact ];
    systemd.services.lactd.wantedBy = ["multi-user.target"];
    #KDEConnect
   programs.kdeconnect.enable = true;

   #GSConnect
  



    # OpenGL
    hardware.graphics = {
      enable = true;
      # driSupport = true;
      # driSupport32Bit = true;
      extraPackages = with pkgs; [
        #pkgs.vulkan-loader
        #pkgs.vulkan-validation-layers
        #pkgs.nvidia-x11.vulkan-driver
        amdvlk
        mesa
        vaapiVdpau
        libvdpau-va-gl
        rocmPackages_5.clr.icd
        rocmPackages_5.rocm-runtime
        rocmPackages_5.rocminfo
        pkgs.mesa.opencl
        # rocm-opencl-icd
        # rocm-opencl-runtime
        # rocmPackages.rocm-runtime
        ];
        extraPackages32 = with pkgs; [
          # driversi686Linux.amdvlk 
        ];
  };
  # hardware.opengl.enable = true;
  systemd.tmpfiles.rules = [
     "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages_5.clr}"
        ];  
  
    #Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # programs.mtr.enable = true;
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    # List services that you want to enable:

    # Enable the OpenSSH daemon.
    services.openssh.enable = true;

    # networking
    networking.networkmanager.enable = true;
    # Open ports in the firewall.
    # networking.firewall.enable = false;
    # networking.useDHCP = false;
    networking.firewall = { 
      enable = true;
      allowedTCPPortRanges = [ 
        { from = 1714; to = 1764; } # KDE Connect
      ];
      allowedTCPPorts = [22 4747 32400 47984 47989 47990 48010 5900 8085 ];  
      allowedUDPPortRanges = [ 
        { from = 1714; to = 1764; } # KDE Connect
        { from = 47998; to = 48000; }
        { from = 8000; to = 8010; }
      ];  
      allowedUDPPorts = [ 4747 8085 32400 ];
    }; 


  programs.adb.enable = true;
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}

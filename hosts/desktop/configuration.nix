# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  inputs,
  config,
  pkgs,
  lib,
  winapps,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  # Flakes
  # nix = {
  # package = pkgs.nixFlakes;
  # extraOptions = ''experimental-features = nix-command flakes'';
  # };

  nix.settings.experimental-features = ["nix-command" "flakes"];

  #   #Home-ma/home/octavian/Downloads/Untitled Sketch_bb.pngnager
  #   home-manager = {
  #     extraSpecialArgs = { inherit inputs; };
  #     users = {
  #       octavian = import ./home.nix;
  #     };
  #   };

  # Stylix
  # stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";
  # stylix.polarity = "dark";

  # Bootloader
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
    kernelPackages = pkgs.linuxPackages_latest;
    # kernelPackages = pkgs.linuxPackages_6_12;
    extraModulePackages = with config.boot.kernelPackages; [
      v4l2loopback.out
    ];
    # kernelParams = [ "amdgpu.dc=0" ];
    kernelModules = [
      # Virtual Camera
      "v4l2loopback"
      # Virtual Microphone, built-in
      "snd-aloop"
    ];
    initrd.kernelModules = ["amdgpu"];
    extraModprobeConfig = ''options v4l2loopback devices=1 video_nr=1 card_label="Virtual Cam" exclusive_caps=1 '';
  };

  hardware.amdgpu.amdvlk.enable = true;
  hardware.amdgpu.opencl.enable = true;

  #  #Kernel
  #   boot.kernelPackages = pkgs.linuxPackages_latest;

  #   # Boot packages
  #   boot.extraModulePackages = with config.boot.kernelPackages;
  #   [ v4l2loopback.out xpadneo];

  #     # Activate kernel modules (choose from built-ins and extra ones)
  #   boot.kernelModules = [
  #     # Virtual Camera
  #     "v4l2loopback"
  #     # Virtual Microphone, built-in
  #     "snd-aloop"
  #   ];
  #     # AMD
  #   boot.initrd.kernelModules = ["amdgpu"];
  # boot.extraModprobeConfig = ''
  #   options v4l2loopback devices=1 video_nr=1 card_label="Virtual Cam" exclusive_caps=1
  #  '';

  security.polkit.enable = true;

  #Networking
  networking.hostName = "Orion"; # Define your hostname.
  networking.firewall.allowPing = true;
  networking.networkmanager.enable = true;
  # Open ports in the firewall.
  # networking.firewall.enable = false;
  # networking.useDHCP = false;
  networking.firewall = {
    enable = true;
    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      } # KDE Connect
    ];
    allowedTCPPorts = [22 4747 32400 32500 47984 47989 47990 48010 5900 8085 64738];
    allowedUDPPortRanges = [
      {
        from = 1714;
        to = 1764;
      } # KDE Connect
      {
        from = 47998;
        to = 48000;
      }
      {
        from = 8000;
        to = 8010;
      }
    ];
    allowedUDPPorts = [4747 8085 32400 32500 64738];
  };

  # Tailscale
  services.tailscale.enable = true;

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

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

  # Waydroid
  virtualisation.waydroid.enable = true;

  programs.file-roller.enable = true;
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images

  services.xserver.videoDrivers = ["modesetting"];

  # Media keys
  services.actkbd = {
    enable = true;
    bindings = [
      #{ keys = [ 115 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/runuser -l octavian -c 'amixer set Master 5%+'"; }
      {
        keys = [115];
        events = ["key"];
        command = "${pkgs.alsa-utils}/bin/amixer -q set Master 5%+";
      }
      {
        keys = [114];
        events = ["key"];
        command = "${pkgs.alsa-utils}/bin/amixer -q set Master 5%-";
      }
      {
        keys = [113];
        events = ["key"];
        command = "${pkgs.alsa-utils}/bin/amixer -q set Master toggle";
      }
    ];
  };

  # ZSH
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    ohMyZsh = {
      enable = true;
      plugins = ["git"];
      theme = "eastwood";
    };
  };

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
    LIBGL_DEBUG = "verbose";
    EGL_PLATFORM = "wayland";
  };

  #Nfs
  # fileSystems."/mnt/share/media" = {
  #   device = "192.168.3.8:/mnt/Media/Media";
  #   fsType = "nfs";
  #   options = ["rw" "nconnect=16" "x-systemd.automount" "noauto"];
  # };

  # Autostart polkit_gnome
  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
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
  # X11
  services.xserver = {
    enable = true;
    # desktopManager.gnome.enable = true;
    # Configure keymap in X11
    xkb = {
      variant = "";
      layout = "us";
    };
  };
  # services.desktopManager.plasma6.enable = true;
  services.desktopManager.plasma6.enable = true;
  # services.xserver.enable = true;
  #services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;

  # #RDP
  # programs.ssh.askPassword = pkgs.lib.mkForce "${pkgs.ksshaskpass.out}/bin/ksshaskpass";

  # # XDRP
  # services.xrdp.enable = true;
  # services.xrdp.defaultWindowManager = "plasma";
  # services.xrdp.openFirewall = true;
  # # services.xdrp={
  # #   enable = true;
  # #   defaultWindowManager = "plasma";
  # #   openFirewall = true;
  # # };

  # Enable the KDE Plasma Desktop Environment.
  #services.xserver.displayManager.sddm.wayland.enable = true;

  #  Display Manager
  services.displayManager = {
    defaultSession = "plasma";
    sddm.enable = true;
    sddm.theme = "sddm-astronaut-theme";
    sddm.wayland.enable = true;
  };
  #  services.displayManager.sddm.wayland.enable = true;
  #  services.displayManager.sddm.enable = true;
  #  #Default session
  #  services.displayManager.defaultSession = "plasma";

  #  Nix Helper (nh)

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

  # services.xserver.xkb.variant = "";
  # services.xserver.xkb.layout = "us";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  # sound.enable = true;
  services.pulseaudio.enable = false;
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
    extraGroups = ["networkmanager" "wheel" "audio" "vboxusers" "dialout" "scanner" "lp" "docker"];
    packages = with pkgs; [
      # firefox
      # kdePackages.kate
      #  thunderbird
    ];
    # openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2etc/etc/etcjwrsh8e596z6J0l7 example@host" "ssh-ed25519 AAAAC3NzaCetcetera/etceteraJZMfk3QPfQ foo@bar" ];
  };

  programs.ssh.askPassword = lib.mkForce "/nix/store/03h3nhgks61l3szfpii9la6y1kqqdq6k-ksshaskpass-6.3.5/bin/ksshaskpass";

  # hardware.xpadneo.enable = true;
  # hardware.steam-hardware.enable = true;
  # Tmux
  programs.tmux = {
    enable = true;
    extraConfig = ''      set-option -sa terminal-overrides ",xterm*:Tc"
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

  # Docker
  virtualisation.docker.enable = true;

  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = pkgs.lib.mkForce true;
    # allowInsecure = true;
    # packageOverrides = pkgs: {
    # unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
    # };
  };

  # Vivaldi
  nixpkgs.config.vivaldi = {
    proprietaryCodecs = true;
    enableWideVine = true;
  };

  services.avahi = {
    enable = true;
    publish.enable = true;
    publish.userServices = true;
  };
  # services.avahi.enable = true;
  # services.avahi.publish.enable = true;
  # services.avahi.publish.userServices = true;

  # SANE scanner
  # hardware.sane = {
  #   enable = true;
  #   extraBackends = [pkgs.sane-airscan];
  # };

  # hardware.sane.drivers.scanSnap.enable = true;
  # environment.etc."sane/gt68xx/PS1fw.usb".source = /home/octavian/Documents/sane/gt68xx/PS1fw.usb;

  #Git
  programs.git = {
    enable = true;
    config = {
      user.name = "Octavian";
      user.email = "soctavianstefan@gmail.com";
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };

  # Samba
  services.sambaClient.enable = true;

  services.gnome.gnome-remote-desktop.enable = true;
  #Fonts
  #fonts.fontconfig.enableProfileFonts = true;
  fonts.packages = with pkgs; [
    dina-font
    fira-code
    fira-code-symbols
    jetbrains-mono
    liberation_ttf
    mplus-outline-fonts.githubRelease
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    proggyfonts
  ];

  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    actkbd
    alacritty
    alejandra
    alsa-utils
    anki
    bitwarden
    bottles
    bottom
    btop-rocm
    caligula
    cargo
    clinfo
    cmake
    # colloid-gtk-theme
    # colloid-icon-theme
    # colloid-kde
    discord
    docker-compose
    dos2unix
    dysk
    easyeffects
    electron
    expat
    f3
    fastfetch
    ffmpeg
    ffmpegthumbnailer
    filezilla
    flameshot
    floorp
    fluent-reader
    font-awesome
    fontconfig
    freetype
    fzf
    gcc
    gh
    ghostty
    git-crypt
    glew
    glfw
    glfw-wayland
    glfw-wayland-minecraft
    gnome-keyring
    gnumake
    gogdl
    gparted
    grim
    grimblast
    hackgen-nf-font
    heroic
    hyprcursor
    hyprlock
    hyprpaper
    hyprpicker
    imagemagick
    inputs.self.packages.${pkgs.system}.shadps4-0_6_0
    inputs.zen-browser.packages."${system}".default
    itch
    jamesdsp
    jdk17
    jetbrains-mono
    jq
    kdePackages.kasts
    kdePackages.krdp
    kdePackages.krfb
    kdePackages.kwalletmanager
    kdePackages.plasma-browser-integration
    kdePackages.qtmultimedia
    kdePackages.qtwayland
    kdePackages.xwaylandvideobridge
    kitty
    libGL
    libGL
    libglibutil
    libGLU
    libglvnd
    libnotify
    # libsForQt5.libkscreen
    libsForQt5.qt5.qtwayland
    libva
    libva-utils
    libvdpau
    linuxKernel.packages.linux_zen.xpadneo
    localsend
    lsd
    lutris
    mesa
    mesa-demos
    meson
    moonlight-qt
    mpv
    mumble
    ncdu
    nix-diff
    nix-output-monitor
    nix-tree
    nodejs
    noto-fonts
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    ntfs3g
    nvd
    nvtopPackages.amd
    nwg-look
    nwg-look
    obs-studio
    obsidian
    ocamlPackages.ssl
    openssl
    openssl
    openssl_3
    openssl_legacy
    pamixer
    papirus-icon-theme
    papirus-icon-theme
    pavucontrol
    pkg-config
    pkgs.cifs-utils
    pkgs.deluged
    pkgs.home-manager
    pkgs.oh-my-zsh
    pkgs.polkit_gnome
    pkgs.sane-backends
    pkgs.sx
    pkgs.wayvnc
    pkgs.xorg.xinit
    pkgs.zsh-completions
    pkgs.zsh-powerlevel10k
    pkgs.zsh-syntax-highlighting
    playerctl
    plex-desktop
    plexamp
    postgresql
    postman
    protonup-qt
    python3
    qbittorrent-enhanced
    qemu
    quickemu
    ranger
    rocmPackages.rocm-smi
    rofi-wayland
    rpi-imager
    rustdesk
    samba
    scrcpy
    sddm-astronaut
    signal-desktop
    slurp
    smartmontools
    source-han-sans
    source-han-sans-japanese
    source-han-serif-japanese
    speedtest-cli
    sshfs
    starship
    syncthing
    tautulli
    tesseract4
    thunderbird
    tigervnc
    tldr
    todoist-electron
    tor
    tor-browser
    udev-gothic-nf
    unrar
    vdpauinfo
    viewnior
    virtio-win
    vivaldi
    vlc
    vulkan-tools
    pkgs.waybar
    (pkgs.waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
    }))
    wayvnc
    wf-recorder
    wget
    winetricks
    wineWowPackages.waylandFull
    wireplumber
    wl-clipboard
    wlogout
    wlr-randr
    wlroots
    xbindkeys
    xbindkeys
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
    xdotool
    xfce.tumbler
    xorg.libXrandr
    xwayland
    yad
    yt-dlp
    zapzap
    zotero
    zoxide

    freerdp

    # winapps.packages."${system}".winapps
    # winapps.packages."${system}".winapps-launcher # optional
    #  wget
    # aquamarine
    # arduino-ide
    # arduino-ide
    # audacity
    # blender
    # cudaPackages.nvidia_driver
    # davinci-resolve
    # droidcam
    # fish
    # flatpak
    # git
    # github-desktop
    # gnome-remote-desktop
    # guacamole-server
    # hyprland
    # jdk8
    # jetbrains.idea-ultimate
    # kdePackages.kdenlive
    # kodi-wayland
    # lact
    # lact
    # libGLU
    # libglvnd
    # libreoffice
    # libsForQt5.kdeconnect-kde
    # masterpdfeditor
    # mathpix-snipping-tool
    # maven
    # mesa
    # modelsim
    # neatvnc
    # nerdfonts
    # net-snmp
    # nexusmods-app
    # nixd
    # nordic
    # ollama-rocm
    # parsec-bin
    # pkgs.dunst
    # pkgs.nautilus
    # pkgs.nemo-with-extensions
    # plasma5Packages.kdeconnect-kde
    # prismlauncher
    # python311
    # rquickshare
    # rustc
    # rustup
    # steam
    # sublime
    # swaylock
    # tailscale
    # tailscale
    # tailscale
    # tmux
    # v4l2loopback
    # vencord
    # vencord
    # virtualbox
    # vscode
    # vscodium
    # wayvnc
    # whatsie
    # wl-paste
    # xdg-dekstop-portal-kde
    # youtube-music
    # z-lua
    # zathura
    # zoxide
    #btop
    #cmake
    #glu
    #gnumake
    #Java
    #libstdcxx5
    #ninja
    #pkgs.zsh-history-substring-search
    #poetry
    #privateGPT dependencies
    #stdenv.cc.cc.lib
    #Sunshine
    #themes
    #v4l2loopback
    #vulkan
    #zabbix.agent
    #zabbix.web
    #zabbixctl
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
  # nixpkgs.config.permittedInsecurePackages = ["electron-25.9.0" "electron-33.4.11"];

  # XDG desktop portals
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [
  ];
  xdg.portal.xdgOpenUsePortal = true;

  systemd.user.services.xdg-desktop-portal-gtk = {
    wantedBy = ["xdg-desktop-portal.service"];
    before = ["xdg-desktop-portal.service"];
  };

  #VNC
  # systemd.services.krfb-virtualmonitor = {
  # description = "Virtual Monitor for Wireless Display";
  # wantedBy = [ "multi-user.target" ]; # Ensure it runs at boot
  # after = [ "network.target" "display-manager.service" ]; # Start after network and display manager

  # serviceConfig = {
  #   ExecStart = "/run/current-system/sw/bin/krfb-virtualmonitor --name WirelessDisplay --resolution 2048x1536 --password deadbeef --port 5900";
  #   Restart = "always"; # Restart if it crashes
  #   User = "octavian"; # Replace with your actual username
  #   Environment = "DISPLAY=:0"; # Ensures it runs in the graphical session
  # };
  # };

  #AMD
  # systemd.packages = with pkgs; [lact];
  # systemd.services.lactd.wantedBy = ["multi-user.target"];
  #KDEConnect
  programs.kdeconnect.enable = true;

  #UEFI Firmware support for virtual machines
  systemd.tmpfiles.rules = ["L+ /var/lib/qemu/firmware - - - - ${pkgs.qemu}/share/qemu/firmware"];

  # OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    # driSupport = true;
    # driSupport32Bit = true;
    extraPackages = with pkgs; [
      vaapiVdpau
      mesa
      libvdpau-va-gl
      amdvlk
      #pkgs.vulkan-validation-layers
      #pkgs.vulkan-loader
      #pkgs.nvidia-x11.vulkan-driver
      #pkgs.mesa.drivers
      # rocmPackages.rocm-runtime
      # rocmPackages_5.rocminfo
      # rocmPackages_5.rocm-runtime
      # rocmPackages_5.clr.icd
      # rocm-opencl-runtime
      # rocm-opencl-icd
      # pkgs.mesa.opencl
    ];
    extraPackages32 = with pkgs; [
      # driversi686Linux.amdvlk
    ];
  };

  hardware.amdgpu.amdvlk = {
    # enable = true;
    support32Bit.enable = true;
  };
  # systemd.tmpfiles.rules = [
  #   "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages_5.clr}"
  # ];

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

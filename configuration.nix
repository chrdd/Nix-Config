{ inputs, config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      octavian = import ./home.nix;
    };
  };

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

  networking.hostName = "nixos";

  time.timeZone = "Europe/Bucharest";

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

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    xwayland.enable = true;
  };

  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
  };

  services.gvfs.enable = true;
  services.tumbler.enable = true;
  programs.file-roller.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.blueman.enable = true;

  services.flatpak.enable = true;
  services.flatpak.packages = [
    { appId = "tv.plex.PlexDesktop"; origin = "flathub"; }
    { appId = "tv.plex.PlexHTPC"; origin = "flathub"; }
    { appId = "com.github.tchx84.Flatseal"; origin = "flathub"; }
  ];

  services.tailscale.enable = true;

  services.actkbd = {
    enable = true;
    bindings = [
      { keys = [123]; events = ["key"]; command = "/run/current-system/sw/bin/runuser -l octavian -c 'amixer set Master 5%+'"; }
      { keys = [122]; events = ["key"]; command = "/run/current-system/sw/bin/runuser -l octavian -c 'amixer set Master 5%-'"; }
      { keys = [121]; events = ["key"]; command = "/run/current-system/sw/bin/runuser -l octavian -c 'amixer -D pulse set Master 1+ toggle'"; }
    ];
  };

  programs.steam = {
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

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;
    powerManagement.enable = true;
    open = false;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];

  boot.kernelModules = [
    "v4l2loopback"
    "snd-aloop"
  ];

  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=1 card_label="Virtual Cam" exclusive_caps=1
  '';

  security.polkit.enable = true;

  systemd.user.services.polkit-gnome-authentication-agent-1 = {
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

  services.xserver.enable = true;
  services.xserver.displayManager.sddm.wayland.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.displayManager.defaultSession = "hyprland";

  security.pam.services.swaylock = {};

  services.xserver.xkb = {
    variant = "";
    layout = "us";
  };

  services.syncthing = {
    enable = true;
    user = "octavian";
    dataDir = "/home/octavian/Documents";
    configDir = "/home/octavian/Documents/.config/syncthing";
  };

  services.printing.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  users.users.octavian = {
    isNormalUser = true;
    description = "octavian";
    extraGroups = ["networkmanager" "wheel" "audio"];
    packages = with pkgs; [
      firefox
      kate
    ];
  };

  nixpkgs.config.allowUnfree = pkgs.lib.mkForce true;
  nixpkgs.config.allowInsecure = true;

  nixpkgs.config.vivaldi = {
    proprietaryCodecs = true;
    enableWideVine = true;
  };

  security.wrappers.sunshine = {
    owner = "root";
    group = "root";
    capabilities = "cap_sys_admin+p";
    source = "${pkgs.sunshine}/bin/sunshine";
  };

  services.avahi = {
    enable = true;
    publish.enable = true;
    publish.userServices = true;
  };

  fonts.packages = with pkgs; [
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
    gnome.gnome-system-monitor
  ];
}

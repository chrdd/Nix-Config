{
  config,
  inputs,
  lib,
  pkgs,
  winapps,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # networking.wireless.enable = true; # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

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

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  # services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Intel CPU microcode
  hardware.cpu.intel.updateMicrocode = true;

  # Intel GPU / media acceleration
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver # VAAPI for 12th gen+ (Arc/Xe graphics)
      intel-compute-runtime # OpenCL
      vpl-gpu-rt # Intel VPL for hardware video decode
    ];
  };

  # Intel P-State for hybrid core scheduling (essential for 240H)
  boot.kernelParams = [
    "intel_pstate=active"
    "elevator=none"
  ];

  # Better power management for hybrid Intel CPU
  services.power-profiles-daemon.enable = false;

  services.auto-cpufreq = {
    enable = true;
    settings = {
      battery = {
        governor = "powersave";
        turbo = "auto";
      };
      charger = {
        governor = "performance";
        turbo = "auto";
      };
    };
  };

  # Firmware updates (ThinkPad E16 is well-supported on LVFS)
  services.fwupd.enable = true;

  # SSD health
  services.fstrim.enable = true;

  # Bluetooth (likely needed for a ThinkPad)
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;

  # Backlight control
  hardware.acpilight.enable = true;

  # Wayland display manager
  services.displayManager.sddm.wayland.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  boot.loader.systemd-boot.configurationLimit = 3;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
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
    extraGroups = ["networkmanager" "wheel" "audio" "vboxusers" "dialout" "scanner" "lp" "samba"];
    packages = with pkgs; [
      kdePackages.kate
      #  thunderbird
    ];
  };

  # Install firefox.
  # programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;
  nixpkgs.config.permittedInsecurePackages = ["electron-39.8.10"];
  # VMware
  # virtualisation.vmware.host.enable = true;

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      freetype
      gfortran.libc # libgfortran
      glib
      libGL
      libxcb
      libxkbcommon
      openssl
      stdenv.cc.cc.lib
      libICE
      libSM
      libX11
      libXau
      libXext
      zlib
    ];
  };
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    # authentik
    # bottles
    # floorp-bin
    # lutris
    # mailspring
    # nh
    # prismlauncher
    # rustdesk
    # tigervnc
    # virtualbox
    brightnessctl
    alacritty
    anki
    ansible
    anydesk
    bitwarden-desktop
    btop
    dig
    discord
    fastfetch
    ffmpeg
    freecad
    gh
    ghostty
    git
    git-crypt
    gparted
    heroic
    howdy
    inputs.zen-browser.packages."${system}".default
    kdePackages.plasma-browser-integration
    localsend
    lsd
    moonlight-qt
    mumble
    nix-output-monitor
    nixd
    obs-studio
    obsidian
    openssl
    plex-desktop
    plexamp
    powershell
    python315
    qbittorrent-enhanced
    scrcpy
    smartmontools
    splix
    steam-run
    syncthing
    tailscale
    teams-for-linux
    thunderbird
    ticktick
    tmux
    todoist-electron
    unrar
    vivaldi
    vlc
    vscodium
    wget
    winboat
    wireguard-tools
    wireguard-ui
    zapzap
    zoxide
    zip
  ];

  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.samba = {
    # The full package is needed to register mDNS records (for discoverability), see discussion in
    # https://gist.github.com/vy-let/a030c1079f09ecae4135aebf1e121ea6
    package = pkgs.samba4Full;
    usershares.enable = true;
    enable = true;
    openFirewall = true;
  };

  # To be discoverable with windows
  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  # Make sure your user is in the samba group
  # users.users.octavian = {
  #   # isNormalUser = true;
  #   extraGroups = ["samba"];
  # };

  networking.hostName = "Thinkpad";

  programs.kdeconnect.enable = true;

  # nix.settings.require-sigs = false;

  # Overheating prevention
  # services.thermald.enable = true;

  networking.firewall.allowedTCPPorts = [8000];
  networking.firewall.allowedUDPPorts = [8000];

  # Powertop
  # powerManagement.powertop.enable = true;

  system.stateVersion = "25.05";
}

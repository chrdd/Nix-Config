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

  networking.wireless.enable = true; # Enables wireless support via wpa_supplicant.

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
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

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
    extraGroups = ["networkmanager" "wheel" "audio" "vboxusers" "dialout" "scanner" "lp"];
    packages = with pkgs; [
      kdePackages.kate
      #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    # floorp-bin
    # nh
    # prismlauncher
    # rustdesk
    # tigervnc
    alacritty
    anki
    anydesk
    bitwarden-desktop
    bottles
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
    inputs.zen-browser.packages."${system}".default
    kdePackages.plasma-browser-integration
    localsend
    lsd
    lutris
    mailspring
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
    thunderbird
    ticktick
    tmux
    todoist-electron
    unrar
    vivaldi
    vlc
    vscodium
    wget
    wireguard-tools
    wireguard-ui
    zapzap
    zoxide
  ];

  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  networking.hostName = "Acer";

  programs.kdeconnect.enable = true;

  nix.settings.require-sigs = false;

  # Overheating prevention
  services.thermald.enable = true;

  # Powertop
  powerManagement.powertop.enable = true;

  system.stateVersion = "25.05";
}

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  inputs,
  config,
  pkgs,
  lib,
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

  #   networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  #   networking.networkmanager.enable = true;

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
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.octavian = {
    isNormalUser = true;
    description = "octavian";
    extraGroups = ["networkmanager" "wheel" "audio" "vboxusers" "dialout" "scanner" "lp"];
    packages = with pkgs; [
      kdePackages.kate
      #  thunderbird
    ];
  };

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

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  services.avahi = {
    enable = true;
    publish.enable = true;
    publish.userServices = true;
  };

  # Fonts
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
    wget
    thunderbird
    nixd
    localsend
    unrar
    gh
    smartmontools
    discord
    obsidian
    bitwarden
    anki
    nix-output-monitor
    qbittorrent-enhanced
    moonlight-qt
    tailscale
    tmux
    mumble
    gparted
    # prismlauncher
    syncthing
    obs-studio
    lsd
    plexamp
    plex-desktop
    bottles
    git
    inputs.zen-browser.packages."${system}".default
    lutris
    alacritty
    floorp
    vscodium
    btop
    tigervnc
    todoist-electron
    nh
    fastfetch
    git-crypt
    ffmpeg
    vivaldi
    kdePackages.plasma-browser-integration
    rustdesk
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  networking.hostName = "Acer"; # Define your hostname.
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

  programs.kdeconnect.enable = true;
  # Enable Hyprland
  #   programs.hyprland = {
  #     enable = true;
  #     package = inputs.hyprland.packages."${pkgs.system}".hyprland;
  #     xwayland.enable = true;
  #   };

  # ZSH
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
  users.defaultUserShell = pkgs.zsh;

  environment.sessionVariables = {
    NH_FLAKE = "/etc/nixos";
  };

  nix.settings.require-sigs = false;

  # Vivaldi
  nixpkgs.config.vivaldi = {
    proprietaryCodecs = true;
    enableWideVine = true;
  };

  # Overheating prevention
  services.thermald.enable = true;

  # Powertop
  powerManagement.powertop.enable = true;

  #Fingerprint sensor
  # # Start the driver at boot
  # systemd.services.fprintd = {
  #   wantedBy = ["multi-user.target"];
  #   serviceConfig.Type = "simple";
  # };

  # # Install the driver
  # services.fprintd.enable = true;
  # # If simply enabling fprintd is not enough, try enabling fprintd.tod...
  # services.fprintd.tod.enable = true;
  # # ...and use one of the next four drivers
  # # services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix; # Goodix driver module
  # services.fprintd.tod.driver = pkgs.libfprint-2-tod1-elan; # Elan(04f3:0c4b) driver
  # services.fprintd.tod.driver = pkgs.libfprint-2-tod1-vfs0090; # (Marked as broken as of 2025/04/23!) driver for 2016 ThinkPads
  # services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix-550a; # Goodix 550a driver (from Lenovo)

  # however for focaltech 2808:a658, use fprintd with overidden package (without tod)
  # services.fprintd.package = pkgs.fprintd.override {
  #   libfprint = pkgs.libfprint-focaltech-2808-a658;
  # };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}

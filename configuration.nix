# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).


{ inputs, config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.home-manager
    ];

  nix = {
  package = pkgs.nixFlakes;
  extraOptions = ''experimental-features = nix-command flakes'';
  };
  
  #Home-manager
  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      octavian = import ./home.nix;
    };
  };


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

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

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
# Enable Hyprland
programs.hyprland = {
  enable = true;
  xwayland.enable = true;
};

programs.thunar.enable = true;
programs.thunar.plugins = with pkgs.xfce; [
  thunar-archive-plugin
  thunar-volman
];

services.gvfs.enable = true; # Mount, trash, and other functionalities
services.tumbler.enable = true; # Thumbnail support for images

# Flatpak
# https://github.com/gmodena/nix-flatpak
services.flatpak.enable=true;
services.flatpak.packages = [
  { appId = "tv.plex.PlexDesktop"; origin = "flathub";  }
  { appId = "tv.plex.PlexHTPC"; origin = "flathub";  }
  { appId = "com.github.tchx84.Flatseal"; origin = "flathub";  }   
];

# Tailscale
services.tailscale.enable = true;


# Actkbd
#services.actkbd = {
#    enable = true;
#    bindings = [
#      { keys = [ 439u ]; events = [ "key" ]; command = "neofetch"; }
#      { keys = [ 438u ]; events = [ "key" ]; command = "btop"; }
#    ];
#  };

#  services.actkbd = {
#    enable = true;
#    bindings = [
#      { keys = [ 113 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/runuser -l octavian -c 'amixer -q set Master toggle'"; }
#      { keys = [ 114 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/runuser -l octavian -c 'amixer -q set Master 5%- unmute'"; }
#      { keys = [ 115 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/runuser -l octavian -c 'amixer -q set Master 5%+ unmute'"; }
#    ];
#  };



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
        plugins = [ "git" "zsh-history-substring-search" ];
        theme="eastwood";
    }; 
  };

environment.sessionVariables = {
  WLR_NO_HARDWARE_CURSORS = "1";
  NIXOS_OZONE_WL = "1";
};
 
  # Nvidia settings
  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings= true;
    powerManagement = {
      enable = true;
      };
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
      

   #Load Nvidia drivers 
   services.xserver.videoDrivers = ["nvidia"]; # or "nvidiaLegacy470 etc.
     
   # Enable the X11 windowing system.
   services.xserver.enable = true;

   # Enable the KDE Plasma Desktop Environment.
   services.xserver.displayManager.sddm.enable = true;
   services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };


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
  sound.enable = true;
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
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.octavian = {
    isNormalUser = true;
    description = "octavian";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
      kate
    #  thunderbird
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = pkgs.lib.mkForce true;  
  nixpkgs.config.allowInsecure = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  hyprland
  wget
  pkgs.waybar
  (pkgs.waybar.overrideAttrs (oldAttrs: {
    mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
  })
  )
  discord
  bitwarden
  obsidian
  pkgs.dunst
  syncthing
  libnotify
  hyprpaper
  kitty
  git
  alacritty
  rofi-wayland
  floorp
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
  z-lua
  fish
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
  pkgs.zsh-history-substring-search
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
  jetbrains-mono
  emacs
  tmux
  ];
  

  # ZSH
  users.defaultUserShell = pkgs.zsh;

  # Insecure packages
  nixpkgs.config.permittedInsecurePackages = [ "electron-25.9.0" ];

  # XDG desktop portals
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  systemd.user.services.xdg-desktop-portal-gtk = {
      wantedBy = [ "xdg-desktop-portal.service" ];
      before = [ "xdg-desktop-portal.service" ];
   };

  # OpenGL
   hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };   
  #Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
   networking.firewall = { 
    enable = true;
    allowedTCPPortRanges = [ 
      { from = 1714; to = 1764; } # KDE Connect
    ];  
    allowedUDPPortRanges = [ 
      { from = 1714; to = 1764; } # KDE Connect
    ];  
  }; 
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

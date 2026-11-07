{
  pkgs,
  hostName,
  ...
}: {
  nixpkgs.hostPlatform = "aarch64-linux";
  system.stateVersion = "26.05";

  networking.hostName = hostName;
  time.timeZone = "Europe/Bucharest";
  hardware.enableRedistributableFirmware = true;

  zramSwap.enable = true;

  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      trusted-users = ["root" "@wheel"];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  users.users.octavian = {
    isNormalUser = true;
    description = "octavian";
    extraGroups = ["wheel"];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIODosyp08InREVgPGzAGGv7VeHW5CRfzeSYWt01Ao56C soctavianstefan@gmail.com"
    ];
  };

  security.sudo.wheelNeedsPassword = false;

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  services.avahi = {
    enable = true;
    # nssmdns4 = true;
    # openFirewall = true;
    settings.publish = {
      disable-publishing = false;
      publish-addresses = true;
    };
  };

  services.tailscale = {
    enable = true;
    openFirewall = true;
  };

  users.users.octavian.shell = pkgs.zsh;

  environment.systemPackages = with pkgs; [
    git
    nano
    btop
    lsd
    tmux
  ];
}

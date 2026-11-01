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

  # 2 GB of RAM: compressed swap instead of building anything heavy on the Pi
  zramSwap.enable = true;

  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      trusted-users = ["root" "@wheel"]; # needed for remote deploys
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

  # Key-only login, so sudo can't ask for a password that doesn't exist
  security.sudo.wheelNeedsPassword = false;

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  # Lets you reach it as pi.local on first boot
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    settings.publish = {
      disable-publishing = false;
      publish-addresses = true;
    };
  };

  environment.systemPackages = with pkgs; [git vim htop];
}

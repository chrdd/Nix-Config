# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath,secrets, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/276e3cd8-8dcc-42d6-aedd-c803de95f04d";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/FC6A-214C";
      fsType = "vfat";
    };
  
  fileSystems."/mnt/Media" =
    { device = "//192.168.3.8/Media";
      fsType = "cifs";
      options = [ "username=chr" "password=${secrets.truenas.password}" "x-systemd.automount" "noauto" ];
    };

    fileSystems."/mnt/Configs" =
    { device = "//192.168.3.8/Configs";
      fsType = "cifs";
      options = [ "username=chr" "password=${secrets.truenas.password}" "x-systemd.automount" "noauto" ];
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/a1b61fd2-f34d-4e2a-9167-ddd1ad331826"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp5s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}

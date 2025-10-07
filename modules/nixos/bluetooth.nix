{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    bluetooth.enable = lib.mkEnableOption "Enables bluetooth";
  };

  config = lib.mkIf config.bluetooth.enable {
    # Enable firmware
    hardware.enableRedistributableFirmware = true;

    # Load Bluetooth modules early
    boot.kernelModules = ["bluetooth" "btusb" "rfkill"];

    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
          FastConnectable = true;
          JustWorksRepairing = "always";
          Privacy = "device";
          Class = "0x000100";
          Experimental = true; # ADD THIS
          KernelExperimental = true; # ADD THIS
        };
        Policy = {
          AutoEnable = true; # ADD THIS
        };
      };
    };

    # Blueman
    services.blueman.enable = true;
    hardware.xpadneo.enable = true;

    boot = {
      extraModulePackages = with config.boot.kernelPackages; [xpadneo];
      extraModprobeConfig = ''
        options bluetooth disable_ertm=Y
        options btusb enable_autosuspend=0     # ADD THIS - disable autosuspend
      '';

      # ADD THIS - disable USB autosuspend globally for Bluetooth
      kernelParams = ["usbcore.autosuspend=-1"];
    };

    # ADD THIS - udev rules to keep Bluetooth devices awake
    services.udev.extraRules = ''
      # Disable autosuspend for Bluetooth USB devices
      ACTION=="add", SUBSYSTEM=="usb", DRIVERS=="btusb", ATTR{power/control}="on"

      # Keep all USB Bluetooth adapters awake
      ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="8087", ATTR{power/control}="on"
      ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="0a12", ATTR{power/control}="on"
      ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="0cf3", ATTR{power/control}="on"
    '';
  };
}

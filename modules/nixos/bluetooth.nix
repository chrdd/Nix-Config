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
    hardware.enableRedistributableFirmware = true;

    boot.kernelModules = ["bluetooth" "btusb" "rfkill"];

    hardware.bluetooth = {
      enable = true;
      powerOnBoot = lib.mkDefault true; # ← only change needed
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
          FastConnectable = true;
          JustWorksRepairing = "always";
          Privacy = "device";
          Class = "0x000100";
          Experimental = true;
          KernelExperimental = true;
        };
        Policy = {
          AutoEnable = true;
        };
      };
    };

    services.blueman.enable = true;
    hardware.xpadneo.enable = true;

    boot = {
      extraModulePackages = with config.boot.kernelPackages; [xpadneo];
      extraModprobeConfig = ''
        options bluetooth disable_ertm=Y
        options btusb enable_autosuspend=0
      '';
      kernelParams = ["usbcore.autosuspend=-1"];
    };

    services.udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="usb", DRIVERS=="btusb", ATTR{power/control}="on"
      ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="8087", ATTR{power/control}="on"
      ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="0a12", ATTR{power/control}="on"
      ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="0cf3", ATTR{power/control}="on"
    '';
  };
}

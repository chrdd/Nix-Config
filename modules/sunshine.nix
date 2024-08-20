{ config, pkgs, ... }:

let
  user = "sunshine";
  resolutionScript = pkgs.writeTextFile {
    name = "sunshine-resolution-script";
    text = ''
      #!/usr/bin/env bash

      width=''${1:-1920}
      height=''${2:-1080}
      refresh_rate=''${3:-120}

      # Get the modeline info from the 2nd row in the cvt output
      modeline=$(cvt ''${width} ''${height} ''${refresh_rate} | gawk 'FNR == 2')
      xrandr_mode_str=''${modeline//Modeline \"*\" /}
      mode_alias="''${width}x''${height}"

      echo "xrandr setting new mode ''${mode_alias} ''${xrandr_mode_str}"
      xrandr --rmmode ''${mode_alias}
      xrandr --newmode ''${mode_alias} ''${xrandr_mode_str}
      xrandr --addmode DP-0 ''${mode_alias}

      # Apply new xrandr mode
      xrandr --output DP-0 --primary --mode ''${mode_alias} --pos 0x0 --rotate normal

      # /run/current-system/sw/bin/nvidia-settings -a 'SyncToVBlank=0'
    '';
    executable = true;
    destination = "/bin/resolution.sh";
  };
  sunshineApps = pkgs.writeText "apps.json" (builtins.toJSON {
    env = { };
    apps = [
      {
        name = "Steam Big Picture";
        image-path = "steam.png";
        exclude-global-prep-cmd = false;
        auth-detach = true;
        prep-cmd = [
          {
            undo = "/run/current-system/sw/bin/pkill steam";
          }
        ];
        cmd = "${pkgs.steam}/bin/steam";
        working-dir = "/home/${user}";
      }
    ];
  });
  configFile = pkgs.writeText "sunshine.conf"
    ''
      file_apps = ${sunshineApps}
      output_name=1
      origin_web_ui_allowed=lan
      channels=2
      min_threads=12
      capture=kms
      # global_prep_cmd=[{"do":"${pkgs.bash}/bin/bash -c \"${resolutionScript}/bin/resolution.sh ''${SUNSHINE_CLIENT_WIDTH} ''${SUNSHINE_CLIENT_HEIGHT} ''${SUNSHINE_CLIENT_FPS}\""}]
    '';
  sunshineOverride = pkgs.sunshine.override { cudaSupport = true; stdenv = pkgs.cudaPackages.backendStdenv; };
in
{
  security = {
    polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
          if (action.id == "org.freedesktop.login1.suspend" ||
              action.id == "org.freedesktop.login1.suspend-multiple-sessions" ||
              action.id == "org.freedesktop.login1.hibernate" ||
              action.id == "org.freedesktop.login1.hibernate-multiple-sessions")
          {
              return polkit.Result.NO;
          }
      });
    '';
  };

  systemd.targets = {
    sleep.enable = false;
    suspend.enable = false;
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };

  environment.systemPackages = with pkgs; [
    sunshineOverride
    xorg.xrandr
    xorg.xorgserver
    xorg.libxcvt
  ];
  # sound.enable = true;

  services.xserver = {
    enable = true;
    videoDrivers = [ "amdgpu" ];

    displayManager = {
      # sddm = {
      #   enable = true;
      #   wayland.enable = false;
      #   autoLogin.relogin = true;
      # };
      # autoLogin = {
      #   inherit user;
      #   enable = true;
      # };
    };
    # desktopManager.xfce.enable = true;

    monitorSection = ''
      HorizSync       5.0 - 1000.0
      VertRefresh     5.0 - 1000.0
      Option         "DPMS"

      # 2240x1290 @ 30.00 Hz (GTF) hsync: 39.39 kHz; pclk: 113.44 MHz
      Modeline "2240x1290_30.00"  113.44  2240 2328 2560 2880  1290 1291 1294 1313  -HSync +Vsync
      # 2240x1290 @ 60.00 Hz (GTF) hsync: 80.10 kHz; pclk: 243.50 MHz
      Modeline "2240x1290_60.00"  243.50  2240 2400 2640 3040  1290 1291 1294 1335  -HSync +Vsync
      # 2240x1290 @ 120.00 Hz (GTF) hsync: 165.84 kHz; pclk: 517.42 MHz
      Modeline "2240x1290_120.00"  517.42  2240 2432 2680 3120  1290 1291 1294 1382  -HSync +Vsync
      # 2800x1290 @ 30.00 Hz (GTF) hsync: 39.39 kHz; pclk: 141.80 MHz
      Modeline "2800x1290_30.00"  141.80  2800 2912 3200 3600  1290 1291 1294 1313  -HSync +Vsync
      # 2800x1290 @ 60.00 Hz (GTF) hsync: 80.10 kHz; pclk: 303.74 MHz
      Modeline "2800x1290_60.00"  303.74  2800 2992 3296 3792  1290 1291 1294 1335  -HSync +Vsync
      # 2800x1290 @ 120.00 Hz (GTF) hsync: 165.84 kHz; pclk: 647.44 MHz
      Modeline "2800x1290_120.00"  647.44  2800 3040 3352 3904  1290 1291 1294 1382  -HSync +Vsync
    '';

    # deviceSection = ''
    #   VendorName  "NVIDIA Corporation"
    #   Option      "CustomEDID" "DFP-1:/etc/X11/120edid.bin"
    #   Option "ConnectedMonitor" "DFP-1"
    # '';

    screenSection = ''
      Monitor         "Configured Monitor"
      DefaultDepth    24

      Option "ModeValidation" "NoVertRefreshCheck, NoHorizSyncCheck, NoMaxSizeCheck, NoMaxPClkCheck, AllowNonEdidModes, NoEdidMaxPClkCheck"

      SubSection     "Display"
          Depth       24
      EndSubSection
    '';
  };

  security.wrappers.sunshine = {
    owner = "root";
    group = "root";
    capabilities = "cap_sys_admin+p";
    source = "${sunshineOverride}/bin/sunshine";
  };

  systemd.user.services.${user} = {
    description = "Sunshine server";
    wantedBy = [ "graphical-session.target" ];
    startLimitIntervalSec = 500;
    startLimitBurst = 5;
    partOf = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    path = [ resolutionScript pkgs.xorg.xrandr pkgs.bash pkgs.xorg.libxcvt pkgs.xorg.xorgserver pkgs.gawk pkgs.steam ];
    serviceConfig = {
      ExecStart = "${config.security.wrapperDir}/sunshine ${configFile}";
      Restart = "on-failure";
      RestartSec = "5s";
    };
  };

  services.avahi.publish.userServices = true;
  boot.kernelModules = [ "uinput" ];

  programs.steam.enable = true;

  hardware = {
    # pulseaudio.enable = true;
    opengl = {
      enable = true;
      # driSupport = true;
      driSupport32Bit = true;
    };

    # nvidia = {
    #   modesetting.enable = true;
    #   powerManagement.enable = false;
    #   powerManagement.finegrained = false;
    #   open = false;
    #   nvidiaSettings = true;
    # };
  };
}
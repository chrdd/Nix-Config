{ config, pkgs,lib,inputs, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      #MAIN
      #source = [
      #  "~/.config/hypr/startup.conf"
      #  "~/.config/hypr/env.conf"
      #  "~/.config/hypr/windowrule.conf"
      #  "~/.config/hypr/keybinds.conf" 
      #];
      #SOURCES
      #"source" = "~/.config/hypr/startup.conf";
      #"source" = "~/.config/hypr/env.conf";
      #"source" = "~/.config/hypr/windowrule.conf";
      #"source" = "~/.config/hypr/keybinds.conf";


      #execs
      # exec-once = hyprpaper;
      # exec-once=dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP;
      # #exec-once = steam
      # exec-once = bitwarden;
      # exec-once = whatsapp-for-linux;
      # exec-once = discord;
      # exec-once = wayvnc 0.0.0.0;
      # exec-once = kdeconnect-cli --refresh;
      # exec-once = systemctl start --user polkit-gnome-authentication-agent-1;
      # exec-once=dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP;
      exec-once = [
        "hyprpaper"
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "bitwarden"
        "whatsapp-for-linux"
        "hyprctl setcursor Numix-Cursor 24"
        "wayvnc 0.0.0.0"
        "kdeconnect-cli --refresh"
        "systemctl start --user polkit-gnome-authentication-agent-1"
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "~/.config/hypr/scripts/resetxdgportal.sh" # reset XDPH for screenshare
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP" # for XDPH
        "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP" # for XDPH
        #"/usr/lib/polkit-kde-authentication-agent-1" # authentication dialogue for GUI apps
        "echo latam > /tmp/kb_layout"
        #wlsunset -t 5200 -S 9:00 -s 19:30 # NightLight from 7.30pm to 9am
        "systemctl --user restart pipewire" # Restart pipewire to avoid bugs
        #swaybg -m fill -i ~/.wallpapers/pink.png # Set wallpaper
        "waybar" # launch the system panel
        "dunst" # start notification demon
        "wl-paste --type text --watch cliphist store" # clipboard store text data
        "wl-paste --type image --watch cliphist store" # clipboard store image data
      ];

      # MONITOR
      monitor = [
          "DP-3,1920x1080@144,0x1080,auto"
          "HDMI-A-1 ,preferred,0x0,auto"
      ]; 
      

      # INPUTS
      input  = {
        "kb_layout" = "us";
        "follow_mouse" = 1;
        sensitivity = -0.3; # -1.0 - 1.0, 0 means no modification.
      };
      #GENERAL
      general = {
        "gaps_in"=5;
        "gaps_out"=5;
        "border_size"=0;
        "no_border_on_floating" = true;
        layout = "dwindle";
      };

      # MISC
      misc = {
        "disable_hyprland_logo" = true;
        "disable_splash_rendering" = true;
        "mouse_move_enables_dpms" = true;
        "enable_swallow" = true;
        # "swallow_regex" = "^(kitty)$";
      };

      decoration = {
        #CORNERS
        rounding = 8;

        #OPACITY
        active_opacity = 1.0;
        inactive_opacity = 0.9;

        #BLUR
        blur = {
          enabled = true;
          size = 3;
          passes = 3;
          new_optimizations = true;
          ignore_opacity = false;
        };
        # SHADOW
        "drop_shadow" = true;
        "shadow_ignore_window" = true;
        "shadow_offset" = "2 2";
        "shadow_range" = 4;
        "shadow_render_power" = 2;
        "col.shadow" = "0x66000000";

        blurls = [
            "gtk-layer-shell"
            "lockscreen"
        ];
        
      };

      animations = {
        enabled = true;
        # BEZIER
        bezier = [
          "overshot, 0.05, 0.9, 0.1, 1.05"
          "smoothOut, 0.36, 0, 0.66, -0.56"
          "smoothIn, 0.25, 1, 0.5, 1"
        ]; 

        animation = [
          "windows, 1, 5, overshot, slide"
          "windowsOut, 1, 4, smoothOut, slide"
          "windowsMove, 1, 4, default"
          "border, 1, 10, default"
          "fade, 1, 10, smoothIn"
          "fadeDim, 1, 10, smoothIn"
          "workspaces, 1, 6, default"
        ];
      };
      #LAYOUTS
      dwindle = {
        no_gaps_when_only = false;
        pseudotile = true; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = true; # you probably want this
      };
      #WINDOW RULES
      windowrule = [
        "float, file_progress"
        "float, confirm"
        "float, dialog"
        "float, download"
        "float, notification"
        "float, error"
        "float, splash"
        "float, confirmreset"
        "float, title:Open File"
        "float, title:branchdialog"
        "float, Lxappearance"
        "float, Rofi"
        "animation none,Rofi"
        "float,viewnior"
        "float,feh"
        "float, pavucontrol-qt"
        "float, pavucontrol"
        "float, file-roller"
        "fullscreen, wlogout"
        "float, title:wlogout"
        "fullscreen, title:wlogout"
        "idleinhibit focus, mpv"
        "idleinhibit fullscreen, firefox"
        "float, title:^(Media viewer)$"
        "float, title:^(Volume Control)$"
        "float, title:^(Picture-in-Picture)$"
        "size 800 600, title:^(Volume Control)$"
        "move 75 44%, title:^(Volume Control)$"
      ];
      windowrulev2 = [
        #OPACITY
        "opacity 0.75 0.75,class:^(alacritty)$"
        "opacity 0.95 0.90,class:^(floorp)$"
        "opacity 0.95 0.90,class:^(Steam)$"
        "opacity 0.95 0.90,class:^(steam)$"
        "opacity 0.95 0.90,class:^(steamwebhelper)$"
        "opacity 0.80 0.80,class:^(plexamp)$"
        "opacity 0.95 0.90,class:^(Code)$"
        "opacity 0.80 0.80,class:^(thunar)$"
        "opacity 0.80 0.80,class:^(file-roller)$"
        "opacity 0.80 0.80,class:^(nwg-look)$"
        "opacity 0.80 0.80,class:^(qt5ct)$"
        "opacity 0.90 0.90,class:^(discord)$" #Discord-Electron
        "opacity 0.80 0.80,class:^(WebCord)$" #WebCord-Electron
        "opacity 0.80 0.70,class:^(pavucontrol)$"
        "opacity 0.80 0.70,class:^(org.kde.polkit-kde-authentication-agent-1)$"
        "opacity 0.80 0.80,class:^(org.telegram.desktop)$"

        #POSITION
        "float,class:^(org.kde.polkit-kde-authentication-agent-1)$"
        "float,class:^(pavucontrol)$"
        "float,title:^(Media viewer)$"
        "float,title:^(Volume Control)$"
        "float,title:^(Picture-in-Picture)$"
        "float,class:^(Viewnior)$"
        "float,title:^(DevTools)$"
        "float,class:^(file_progress)$"
        "float,class:^(confirm)$"
        "float,class:^(dialog)$"
        "float,class:^(download)$"
        "float,class:^(notification)$"
        "float,class:^(error)$"
        "float,class:^(confirmreset)$"
        "float,title:^(Open File)$"
        "float,title:^(branchdialog)$"
        "float,title:^(Confirm to replace files)"
        "float,title:^(File Operation Progress)"
        "move 75 44%,title:^(Volume Control)$"

        #WORKSPACE
        "workspace 1, class:^(floorp)$"
        "workspace 2, class:^(discord)$"
        "workspace 3, class:^(org.telegram.desktop)$"
        "workspace 4, class:^(Code)$"
        "workspace 4, class:^(code-url-handler)$"
        "workspace 5, class:^(plexamp)$"

        #SIZE
        "size 800 600,class:^(download)$"
        "size 800 600,title:^(Open File)$"
        "size 800 600,title:^(Save File)$"
        "size 800 600,title:^(Volume Control)$"
        "idleinhibit focus,class:^(mpv)$"
        "idleinhibit fullscreen,class:^(floorp)$"

        #XWAYLANDVIDEOBRIDGE
        "opacity 0.0 override 0.0 override,class:^(xwaylandvideobridge)$"
        "noanim,class:^(xwaylandvideobridge)$"
        "nofocus,class:^(xwaylandvideobridge)$"
        "noinitialfocus,class:^(xwaylandvideobridge)$"
      ];
      # BINDS
      bind = [
          #MISC
          ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
          ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ", XF86AudioPlay, exec, playerctl play-pause"
          ", XF86AudioPrev, exec, playerctl previous"
          ", XF86AudioNext, exec, playerctl next"
          # "XF86AudioRaiseVolume, exec, amixer set Master 5%+"
          # "XF86AudioLowerVolume, exec, amixer set Master 5%-"
          # "XF86AudioPlay, exec, playerctl play-pause"
          # "XF86AudioNext, exec, playerctl next"
          # "XF86AudioPrev, exec, playerctl previous"
          "SUPER, escape, exec, wlogout --protocol layer-shell -b 5 -T 400 -B 400"
          "SUPER , V, exec, $browser"
          "SUPER SHIFT, v, exec, killall -s SIGINT wf-recorder"
          "SUPERSHIFT, period, exec, $screenshot full"
          "SUPER SHIFT, S, exec, $screenshotarea"
          "SUPER SHIFT, X, exec, $colorpicker"
          "CTRL ALT, L, exec, swaylock"
          "SUPER, X, exec, $term"
          "SUPER, E, exec, $files"
          "SUPER, D, exec, killall rofi || rofi -show drun -theme ~/.config/rofi/config.rasi"
          # bind = SUPER, period, exec, killall rofi || rofi -show emoji -emoji-format "{emoji}" -modi emoji -theme ~/.config/rofi/global/emoji
          "SUPER SHIFT, B, exec, killall -SIGUSR2 waybar" # Reload waybar
          "SUPER, B, exec, killall -SIGUSR1 waybar"
          
          #WINDOW MANAGEMENET
          "SUPER, Q, killactive,"
          "SUPER SHIFT, Q, exit,"
          "SUPER, F, fullscreen,"
          "SUPER, Space, togglefloating,"
          "SUPER, P, pseudo," # dwindle
          "SUPER, S, togglesplit," # dwindle

          # WORKSPACE MODE
          "SUPER SHIFT, Space, workspaceopt, allfloat"
          "SUPER SHIFT, Space, exec, $notifycmd 'Toggled All Float Mode'"
          "SUPER SHIFT, P, workspaceopt, allpseudo"
          "SUPER SHIFT, P, exec, $notifycmd 'Toggled All Pseudo Mode'"

          "SUPER, Tab, cyclenext,"
          "SUPER, Tab, bringactivetotop,"

          #FOCUS
          "SUPER, h, movefocus, l"
          "SUPER, l, movefocus, r"
          "SUPER, k, movefocus, u"
          "SUPER, j, movefocus, d"

          #MOVE
          "SUPER SHIFT, left, movewindow, l"
          "SUPER SHIFT, right, movewindow, r"
          "SUPER SHIFT, up, movewindow, u"
          "SUPER SHIFT, down, movewindow, d"

          #RESIZE
          "SUPER CTRL, left, resizeactive, -20 0"
          "SUPER CTRL, right, resizeactive, 20 0"
          "SUPER CTRL, up, resizeactive, 0 -20"
          "SUPER CTRL, down, resizeactive, 0 20"

          #TABBED
          "SUPER, g, togglegroup"
          "SUPER, tab, changegroupactive"
          "SUPER, G, exec, $notifycmd 'Toggled Group Mode'"

          #SPECIAL
          "SUPER, a, togglespecialworkspace"
          "SUPERSHIFT, a, movetoworkspace, special"
          "SUPER, a, exec, $notifycmd 'Toggled Special Workspace'"
          "SUPER, c, exec, hyprctl dispatch centerwindow"

          #SWITCH
          "SUPER, 1, workspace, 1"
          "SUPER, 2, workspace, 2"
          "SUPER, 3, workspace, 3"
          "SUPER, 4, workspace, 4"
          "SUPER, 5, workspace, 5"
          "SUPER, 6, workspace, 6"
          "SUPER, 7, workspace, 7"
          "SUPER, 8, workspace, 8"
          "SUPER, 9, workspace, 9"
          "SUPER, 0, workspace, 10"
          "SUPER ALT, up, workspace, e+1"
          "SUPER ALT, down, workspace, e-1"

          #MOVE
          "SUPER SHIFT, 1, movetoworkspace, 1"
          "SUPER SHIFT, 2, movetoworkspace, 2"
          "SUPER SHIFT, 3, movetoworkspace, 3"
          "SUPER SHIFT, 4, movetoworkspace, 4"
          "SUPER SHIFT, 5, movetoworkspace, 5"
          "SUPER SHIFT, 6, movetoworkspace, 6"
          "SUPER SHIFT, 7, movetoworkspace, 7"
          "SUPER SHIFT, 8, movetoworkspace, 8"
          "SUPER SHIFT, 9, movetoworkspace, 9"
          "SUPER SHIFT, 0, movetoworkspace, 10"

      ];
      bindm=[
        #MOUSE RESIZING
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
        #"SUPER, mouse_down, workspace, e+1"
        #"SUPER, mouse_up, workspace, e-1"
      ];
      #ENVIROMENT
      env = [
        "XDG_CURRENT_DESKTOP,Hyprland" 
        "XDG_SESSION_TYPE,wayland" 
        "XDG_SESSION_DESKTOP,Hyprland" 

        "GDK_BACKEND,wayland"
        "QT_QPA_PLATFORM,wayland"
        "QT_QPA_PLATFORMTHEME,qt5ct #env = QT_STYLE_OVERRIDE,kvantum"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "QT_AUTO_SCREEN_SCALE_FACTOR,1"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"

        "SDL_VIDEODRIVER,wayland"
        "_JAVA_AWT_WM_NONREPARENTING,1"
        "WLR_NO_HARDWARE_CURSORS,1"

        "MOZ_DISABLE_RDD_SANDBOX,1"
        "MOZ_ENABLE_WAYLAND,1"

        "OZONE_PLATFORM,wayland"

        "HYPRCURSOR_THEME,Numix-Cursor"
        "HYPRCURSOR_SIZE,24"
      ];
      "$scriptsDir" = "$HOME/.config/hypr/scripts";
      "$notifycmd" = "notify-send -h string:x-canonical-private-synchronous:hypr-cfg -u low";
      #"$screenshotarea" = "hyprctl keyword animation "fadeOut,0,0,default"; grimblast --notify copysave area; hyprctl keyword animation "fadeOut,1,4,default""
      # "$screenshotarea" = "hyprctl keyword animation "fadeOut,0,0,default" ";
      # "grimblast --notify copysave area"; 
      # "hyprctl keyword animation "fadeOut,1,4,default"";
      "$term" = "kitty";
      "$volume" = "$scriptsDir/volume";
      "$screenshot" = "$scriptsDir/screensht";
      "$colorpicker" = "$scriptsDir/colorpicker";
      "$files" = "nemo";
      "$browser" = "vivaldi";
    };
  };
}

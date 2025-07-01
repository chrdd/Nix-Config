{ config, pkgs, ... }:
{
#   systemd.services.fetch-updates = {
#     description = "Fetches changes to system config";
#     restartIfChanged = false;
#     startAt = "*-*-* *:00:00";  # every hour
#     path = [ pkgs.git pkgs.openssh ];
#     script = ''
#       git fetch --all
#     '';
#     serviceConfig = {
#       WorkingDirectory = "/etc/nixos";
#       User = "octavian";
#       Type = "oneshot";
#     };
#   };

#   systemd.services.merge-updates = {
#     description = "Merges fetched changes if on 'main'";
#     restartIfChanged = false;
#     onSuccess = [ "rebuild.service" ];
#     startAt = "15:10";
#     path = [ pkgs.git pkgs.openssh ];
#     script = ''
#       current_branch="$(git branch --show-current)"
#       if [ "$current_branch" = "main" ]; then
#         git merge --ff-only origin/main
#       fi
#     '';
#     serviceConfig = {
#       WorkingDirectory = "/etc/nixos";
#       User = "octavian";
#       Type = "oneshot";
#     };
#   };

#   systemd.services.rebuild = {
#     description = "Rebuilds and activates system config";
#     restartIfChanged = false;
#     path = [ pkgs.nixos-rebuild pkgs.systemd ];
#     script = ''
#       nixos-rebuild boot
#       booted="$(readlink /run/booted-system/{initrd,kernel,kernel-modules})"
#       built="$(readlink /nix/var/nix/profiles/system/{initrd,kernel,kernel-modules})"

#       if [ "''${booted}" = "''${built}" ]; then
#         nixos-rebuild switch
#       else
#         reboot now
#       fi
#     '';
#     serviceConfig.Type = "oneshot";
#   };
# }
  systemd.services.pull-updates = {
    description = "Pulls changes to system config and pushes local changes if any";
    restartIfChanged = false;
    onSuccess = [ "rebuild.service" ];
    path = [ pkgs.git pkgs.openssh ];
    script = ''
      cd /etc/nixos
      test "$(git branch --show-current)" = "main" || exit 0

      # Commit local changes if any (unstaged or staged)
      if ! git diff --quiet || ! git diff --cached --quiet; then
        git add -A
        git commit -m "Auto-commit before pull: $(date -Iseconds)" || true
        git push
      fi

      # Now pull latest changes
      git pull --ff-only || {
        echo "Pull failed. Exiting."
        exit 1
      }

      # Commit and push again if pull introduced changes or if local changed since last push
      if ! git diff --quiet || ! git diff --cached --quiet; then
        git add -A
        git commit -m "Auto-commit after pull: $(date -Iseconds)" || true
        git push
      else
        echo "No changes to commit after pull."
      fi
    '';
    serviceConfig = {
      WorkingDirectory = "/etc/nixos";
      User = "octavian";
      Type = "oneshot";
    };
  };

  systemd.timers.pull-updates = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "hourly";
      Persistent = true;
    };
  };
}

# Test for script

# systemd.services.rebuild = {
#   description = "Rebuilds and activates system config";
#   restartIfChanged = false;
#   path = [pkgs.nixos-rebuild pkgs.systemd];
#   script = ''
#     nixos-rebuild boot
#     booted="$(readlink /run/booted-system/{initrd,kernel,kernel-modules})"
#     built="$(readlink /nix/var/nix/profiles/system/{initrd,kernel,kernel-modules})"

#     if [ "''${booted}" = "''${built}" ]; then
#       nixos-rebuild switch
#     else
#       reboot now
#     fi
#   '';
#   serviceConfig.Type = "oneshot";
# };

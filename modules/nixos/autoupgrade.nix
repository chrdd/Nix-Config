{ config, pkgs, ... }:
{
  systemd.services.pull-updates = {
    description = "Pulls changes to system config and pushes local changes if any";
    restartIfChanged = false;
    onSuccess = [ "rebuild.service" ];
    path = [ pkgs.git pkgs.openssh ];
    script = ''
      cd /etc/nixos
      test "$(git branch --show-current)" = "main" || exit 0

      echo "Pulling latest changes..."
      git pull --ff-only

      if ! git diff --quiet || ! git diff --cached --quiet; then
        echo "Changes detected, committing and pushing..."
        git add -A
        git commit -m "Auto-commit: $(date -Iseconds)"
        git push
      else
        echo "No changes to commit."
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

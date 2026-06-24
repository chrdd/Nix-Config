{
  pkgs,
  config,
  lib,
  ...
}: {
  options = {
    autoupgrade.enable = lib.mkEnableOption "Enables autoupgrade";
  };
  config = lib.mkIf config.autoupgrade.enable {
    # Ensure flake.lock conflicts always resolve to remote version
    environment.etc."gitconfig".text = ''
      [pull]
        rebase = false
      [merge "ours"]
        driver = true
    '';

    systemd.services.pull-updates = {
      description = "Pulls changes to system config and pushes local changes if any";
      restartIfChanged = false;
      onSuccess = ["rebuild.service"];
      path = [pkgs.git pkgs.openssh];
      script = ''
        cd /etc/nixos

        # Guard: only run on main branch (not detached HEAD)
        branch=$(git symbolic-ref --short HEAD 2>/dev/null)
        if [ "$branch" != "main" ]; then
          echo "Not on main branch (got: ''${branch:-detached HEAD}), skipping."
          exit 0
        fi

        # Guard: abort if a rebase or merge is already in progress
        if [ -d .git/rebase-merge ] || [ -d .git/rebase-apply ]; then
          echo "Rebase in progress, skipping auto-commit."
          exit 0
        fi
        if [ -f .git/MERGE_HEAD ]; then
          echo "Merge in progress, skipping auto-commit."
          exit 0
        fi

        # Commit local changes if any (unstaged or staged)
        if ! git diff --quiet || ! git diff --cached --quiet; then
          git add -A
          git commit -m "Auto-commit before pull: $(date -Iseconds)" || true
        fi

        # Pull using merge (not rebase) so flake.lock conflicts are resolved once
        # --strategy-option=theirs prefers the remote flake.lock on conflict
        git fetch origin
        if ! git merge --no-edit -X theirs origin/main; then
          echo "Merge failed, aborting."
          git merge --abort
          exit 1
        fi

        # Push merged result
        git push origin main || {
          echo "Push failed."
          exit 1
        }

        # Commit and push if any local changes remain after merge
        if ! git diff --quiet || ! git diff --cached --quiet; then
          git add -A
          git commit -m "Auto-commit after pull: $(date -Iseconds)" || true
          git push origin main || true
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
      wantedBy = ["timers.target"];
      timerConfig = {
        OnCalendar = "hourly";
        Persistent = true;
      };
    };

    systemd.services.rebuild = {
      description = "Rebuilds and activates system config";
      restartIfChanged = false;
      path = [pkgs.nh pkgs.nixos-rebuild pkgs.systemd];
      script = ''
        booted="$(readlink /run/booted-system/{initrd,kernel,kernel-modules})"
        built="$(readlink /nix/var/nix/profiles/system/{initrd,kernel,kernel-modules})"

        if [ "''${booted}" = "''${built}" ]; then
          nh os switch /etc/nixos
        else
          nixos-rebuild boot
          reboot
        fi
      '';
      serviceConfig.Type = "oneshot";
    };
  };
}

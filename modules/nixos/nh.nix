{
  config,
  lib,
  pkgs,
  ...
}: {
  options.nh.enable = lib.mkEnableOption "Nix Helper";

  config = lib.mkIf config.nh.enable {
    programs.nh = {
      enable = true;
      flake = "/etc/nixos"; # replaces the NH_FLAKE sessionVariable
      clean = {
        enable = true;
        dates = "weekly";
        extraArgs = "--keep-since 7d --keep 5";
      };
    };

    # Dedupe the store on a timer instead of on every build
    nix.optimise.automatic = true;

    # nh.clean replaces nix.gc, so don't run both
    assertions = [
      {
        assertion = !config.nix.gc.automatic;
        message = "nh.clean and nix.gc.automatic are both enabled; use only one.";
      }
    ];
  };
}

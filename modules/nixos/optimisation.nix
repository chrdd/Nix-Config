{...}: {
  # Optimization & Garbage Collection

  # Optimize Nix-Store During Rebuilds
  # NOTE: Optimizes during builds - results in slower builds
  nix.settings.auto-optimise-store = true;
  # Purge Unused Nix-Store Entries
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
}

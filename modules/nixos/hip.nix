{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    hip.enable = lib.mkEnableOption "Enables HIP";
  };

  config = lib.mkIf config.hip.enable {
    systemd.tmpfiles.rules = let
      rocmEnv = pkgs.symlinkJoin {
        name = "rocm-combined";
        paths = with pkgs.rocmPackages; [
          rocblas
          hipblas
          clr
        ];
      };
    in [
      "L+    /opt/rocm   -    -    -     -    ${rocmEnv}"
    ];
  };
}

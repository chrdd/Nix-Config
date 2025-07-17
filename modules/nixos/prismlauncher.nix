{
  config,
  pkgs,
  inputs,
  ...
}: let
  # Import the 23.11 nixpkgs
  pkgs-25 = import inputs.nixpkgs-25 {
    system = "x86_64-linux";
  };
in {
  environment.systemPackages = with pkgs; [
    (prismlauncher.override {
      # Add binary required by some mod
      additionalPrograms = [ffmpeg];

      # Change Java runtimes available to Prism Launcher
      jdks = [
        graalvm-ce
        zulu8
        zulu17
        zulu
        pkgs-25.jdk8 # Use jdk8 from nixpkgs-23.11
      ];
    })
  ];
}

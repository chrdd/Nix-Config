{
  config,
  pkgs,
  pkgs-stable,
  ...
}: {
  environment.systemPackages = with pkgs; [
    (prismlauncher.override {
      additionalPrograms = [ffmpeg];

      jdks = [
        graalvmPackages.graalvm-ce
        pkgs-stable.jdk8
        zulu
        zulu17
        zulu8
      ];
    })
  ];
}

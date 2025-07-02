{
  config,
  pkgs,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    nixd
    nil
    (vscode-with-extensions.override {
      vscode = vscodium;
      vscodeExtensions = with vscode-extensions;
        [
          kamadorueda.alejandra
          jnoortheen.nix-ide
          ms-python.python
          redhat.vscode-yaml
          ms-python.debugpy
          mhutchie.git-graph
        ]
        ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "vscode-theme-onedark";
            publisher = "akamud";
            version = "2.3.0";
            sha256 = "sha256-8GGv4L4poTYjdkDwZxgNYajuEmIB5XF1mhJMxO2Ho84=";
          }
          {
            name = "theme-monokai-pro-vscode";
            publisher = "monokai";
            version = "2.0.7";
            sha256 = "sha256-MRFOtadoHlUbyRqm5xYmhuw0LL0qc++gR8g0HWnJJRE=";
          }
        ];
    })
  ];
  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];
}

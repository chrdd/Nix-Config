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
      vscodeExtensions = with vscode-extensions; [
        kamadorueda.alejandra
        jnoortheen.nix-ide
        ms-python.python
        redhat.vscode-yaml
        ms-python.debugpy
        # ]
        # ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        #   {
        #     name = "vscode-theme-onedark";
        #     publisher = "akamud";
        #     version = "2.3.0";
        #     sha256 = "26e661d80c2b656297f570d5522214cd1deee6533b699c8c9dbbaaf5c366fd30";
        #   }
      ];
    })
  ];
  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];
}

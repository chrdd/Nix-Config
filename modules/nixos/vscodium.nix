{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    (vscode-with-extensions.override {
      vscode = vscodium;
      vscodeExtensions = with vscode-extensions; [
        kamadorueda.alejandra
        jnoortheen.nix-ide
        akamud.vscode-theme-onedark
        ms-python.python
        redhat.vscode-yaml
      ];
    })
  ];
}

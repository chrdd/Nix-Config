let
  entries = builtins.readDir ./.;

  isModule = name: type:
    type
    == "regular"
    && name != "default.nix"
    && builtins.match "default_.*\\.nix" name == null
    && builtins.match "hosts\\.nix" name == null
    && builtins.match ".*\\.nix" name != null;

  toAttr = name: {
    name = builtins.substring 0 (builtins.stringLength name - 4) name;
    value = ./. + "/${name}";
  };

  moduleNames = builtins.filter (name: isModule name entries.${name}) (builtins.attrNames entries);
in
  builtins.listToAttrs (map toAttr moduleNames)

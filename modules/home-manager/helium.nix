{
  config,
  lib,
  ...
}: {
  options = {
    helium.enable = lib.mkEnableOption "Enables Helium extensions";
    helium.extensions = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {
        bitwarden = "nngceckbapebfimnlniiiahkandclblb";
        hover-zoom-plus = "pccckmaobkjjboncdfnnofkonhgpceea";
        new-tab-redirect = "icpgjfneehieebagbmdbhnlpiopdcmna";
        sponsorblock = "mnjggcdmjocbbbhaepdhchncahnbgone";
      };
      description = "Chrome Web Store extensions to install, as name = id";
    };
  };
  config = lib.mkIf config.helium.enable {
    xdg.configFile = lib.mapAttrs' (_: id:
      lib.nameValuePair "net.imput.helium/External Extensions/${id}.json" {
        text = builtins.toJSON {
          external_update_url = "https://clients2.google.com/service/update2/crx";
        };
      })
    config.helium.extensions;
  };
}

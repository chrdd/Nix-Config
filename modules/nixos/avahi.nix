{
  config,
  lib,
  pkgs,
  ...
}: {
  services.avahi = {
    enable = true;
    settings.publish = {
      disable-publishing = false;
      disable-user-service-publishing = false;
      publish-addresses = true;
    };
  };
}

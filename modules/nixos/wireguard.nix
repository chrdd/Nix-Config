{
  config,
  host,
  lib,
  ...
}: {
  age.secrets.wg-key-vps = {
    file = "${inputs.self.outPath}/secrets/wg-key-vps.age";
    # for permission, see man systemd.netdev
    mode = "640";
    owner = "systemd-network";
    group = "systemd-network";
  };

  networking.firewall.allowedUDPPorts = [51820];

  networking.useNetworkd = true;

  systemd.network = {
    enable = true;

    networks."50-wg0" = {
      matchConfig.Name = "wg0";

      address = [
        # /32 and /128 specifies a single address
        # for use on this wg peer machine
        "fd31:bf08:57cb::7/128"
        "192.168.26.7/32"
      ];
    };

    netdevs."50-wg0" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg0";
      };

      wireguardConfig = {
        ListenPort = 51820;

        PrivateKeyFile = config.age.secrets.wg-key-vps.path;

        # To automatically create routes for everything in AllowedIPs,
        # add RouteTable=main
        RouteTable = "main";

        # FirewallMark marks all packets send and received by wg0
        # with the number 42, which can be used to define policy rules on these packets.
        FirewallMark = 42;
      };
      wireguardPeers = [
        {
          # laptop wg conf
          PublicKey = "ronr+8v670J0CPb0xT5QLGMWDfE7+1g7HmC6YMdCIDk=";
          AllowedIPs = [
            "fd31:bf08:57cb::9/128"
            "192.168.26.9/32"
          ];
          Endpoint = "192.168.1.26:51820";

          # RouteTable can also be set in wireguardPeers
          # RouteTable in wireguardConfig will then be ignored.
          # RouteTable = 1000;
        }
      ];
    };
  };
}

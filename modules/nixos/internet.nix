# ./internet-sharing.nix
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.internet-sharing;
in {
  options.internet-sharing = {
    enable = lib.mkEnableOption "USB tethering internet sharing via ethernet switch";

    phoneMac = lib.mkOption {
      type = lib.types.str;
      default = "3a:38:7e:30:26:b2";
      description = "MAC address of the phone's USB tethering interface, used to pin it to a stable name.";
    };

    phoneInterface = lib.mkOption {
      type = lib.types.str;
      default = "phone0";
      description = "Stable interface name assigned to the phone via udev.";
    };

    ethernetInterface = lib.mkOption {
      type = lib.types.str;
      default = "enp5s0";
      description = "Ethernet interface connected to the switch.";
    };

    lanAddress = lib.mkOption {
      type = lib.types.str;
      default = "192.168.10.1";
      description = "IP address assigned to the ethernet interface (gateway for LAN devices).";
    };

    dhcpRange = lib.mkOption {
      type = lib.types.str;
      default = "192.168.10.100,192.168.10.200,24h";
      description = "DHCP range handed out to LAN devices (dnsmasq format).";
    };

    dnsServers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = ["1.1.1.1" "8.8.8.8"];
      description = "DNS servers advertised to LAN devices via DHCP.";
    };
  };

  config = lib.mkIf cfg.enable {
    # Pin the phone's USB interface to a stable name using its MAC address
    systemd.network.links."10-phone" = {
      matchConfig.MACAddress = cfg.phoneMac;
      linkConfig.Name = cfg.phoneInterface;
    };

    networking = {
      nat = {
        enable = true;
        internalInterfaces = [cfg.ethernetInterface];
        externalInterface = cfg.phoneInterface;
      };

      interfaces.${cfg.ethernetInterface}.ipv4.addresses = [
        {
          address = cfg.lanAddress;
          prefixLength = 24;
        }
      ];

      firewall.trustedInterfaces = [cfg.ethernetInterface];
    };

    services.dnsmasq = {
      enable = true;
      settings = {
        interface = cfg.ethernetInterface;
        dhcp-range = [cfg.dhcpRange];
        dhcp-option = [
          "option:router,${cfg.lanAddress}"
          "option:dns-server,${lib.concatStringsSep "," cfg.dnsServers}"
        ];
      };
    };
  };
}

{
  config,
  host,
  lib,
  ...
}: {
  networking.firewall = {
    allowedUDPPorts = [51820];
  };
  # Enable WireGuard
  networking.wireguard.interfaces = {
    # "wg0" is the network interface name. You can name the interface arbitrarily.
    wg0 = {
      # Determines the IP address and subnet of the client's end of the tunnel interface.
      ips = ["10.4.7.104/24"];
      # listenPort = 51820; # to match firewall allowedUDPPorts (without this wg uses random port numbers)

      # Path to the private key file.
      #
      # Note: The private key can also be included inline via the privateKey option,
      # but this makes the private key world-readable; thus, using privateKeyFile is
      # recommended.
      privateKeyFile = "/home/octavian/wireguard-keys/privatekey";

      peers = [
        # For a client configuration, one peer entry for the server will suffice.

        {
          # Public key of the server (not a file path).
          publicKey = "vs9f/MndTXJHlElbDxIMMx6j8T3h1vKJFXvq8Esm7Sw=";

          # Forward all the traffic via VPN.
          allowedIPs = ["5.2.139.5/32" "5.2.145.42/32" "5.2.166.47/32" "5.2.178.142/32" "5.2.200.31/32" "5.2.203.71/32" "5.2.205.50/32" "5.2.208.69/32" "5.2.164.255/32" "46.97.11.42/32" "46.97.121.94/32" "78.31.59.10/32" "81.12.137.82/32" "81.196.20.78/32" "82.76.5.118/32" "82.76.14.195/32" "82.76.15.37/32" "82.76.64.245/32" "82.76.195.249/32" "82.76.208.130/32" "82.77.25.100/32" "82.77.136.5/32" "82.78.126.4/32" "82.78.172.245/32" "82.79.139.98/32" "82.79.139.168/32" "82.137.40.45/32" "82.208.177.236/32" "83.103.212.20/32" "84.247.72.82/32" "85.186.25.103/32" "86.34.180.234/32" "86.105.108.254/32" "86.124.19.0/32" "86.125.219.237/32" "86.127.110.226/32" "86.127.210.66/32" "89.121.242.254/32" "89.121.206.242/32" "89.121.253.228/32" "89.165.171.142/32" "92.55.145.98/32" "92.84.56.38/32" "92.86.31.182/32" "92.86.92.50/32" "92.87.22.228/32" "109.100.121.34/32" "109.103.139.130/32" "109.166.183.30/32" "109.166.232.53/32" "109.207.220.163/32" "136.255.155.98/32" "136.255.160.34/32" "194.102.125.54/32" "213.177.26.52/32" "213.177.31.164/32" "213.233.116.70/32" "217.73.170.74/32" "89.121.242.250/32" "5.2.240.223/32"];
          # Or forward only particular subnets
          #allowedIPs = [ "10.100.0.1" "91.108.12.0/22" ];

          # Set this to the server IP and port.
          endpoint = "148.251.253.27:51827"; # ToDo: route to endpoint not automatically configured https://wiki.archlinux.org/index.php/WireGuard#Loop_routing https://discourse.nixos.org/t/solved-minimal-firewall-setup-for-wireguard-client/7577

          # Send keepalives every 25 seconds. Important to keep NAT tables alive.
          persistentKeepalive = 25;
        }
      ];
    };
  };
}

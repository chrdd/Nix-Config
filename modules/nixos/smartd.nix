{ config, pkgs, ... }:
{
  services.smartd = {
    enable = true;
    devices = [
      {
        device = "/dev/disk/by-id/nvme-CT1000P3SSD8_24384B5D3AAA"; 
      }
    ];
  };
}
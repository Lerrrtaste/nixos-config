{ config, lib, pkgs, ... }:

{
  services.clamav = {
    scanner.enable = true;

    updater.enable = true;
    updater.interval = "hourly";
    updater.frequency = 3;

    fangfrisch.enable = true;

    daemon.enable = true;
    daemon.settings = {
      OnAccessMountPath = "/home/lerrrtaste/Downloads";
      OnAccessPrevention = false;
      OnAccessExtraScanning = true;
      OnAccessExcludeUname =  "clamav";
      VirusEvent = "/etc/clamav/virus-event.bash";
      User = "clamav";
    };
  };
}

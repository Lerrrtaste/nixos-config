{ config, lib, pkgs, ... }:
let
  notify-virus = pkgs.writeScript "notify-all-users-sus-file" ''
        #!/usr/bin/env sh
        ALERT="Signature detected by clamav: $CLAM_VIRUSEVENT_VIRUSNAME in $CLAM_VIRUSEVENT_FILENAME"
        # Send an alert to all graphical users.
        for ADDRESS in /run/user/*; do
            USERID=''${ADDRESS#/run/user/}
          /run/wrappers/bin/sudo -u "#$USERID" DBUS_SESSION_BUS_ADDRESS="unix:path=$ADDRESS/bus" ${pkgs.libnotify}/bin/notify-send -i dialog-warning --bell "Sus file" "$ALERT"
        done
      '';
in

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
      VirusEvent = "{$notify-virus}";
      User = "clamav";
    };
  };
}

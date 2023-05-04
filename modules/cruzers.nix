{ config, lib, pkgs, ... }:

{
  # cruzer usb sticks
  fileSystems."/mnt/cruzer1" = {
    label = "cruzer1";
    device = "/dev/mapper/cryptcruzer1";
    fsType = "ext4";
    options = [ "nofail" "user" "defaults" ];
  };

  fileSystems."/mnt/cruzer2" = {
    label = "cruzer2";
    device = "/dev/mapper/cryptcruzer2";
    fsType = "ext4";
    options = [ "nofail" "user" "defaults" ];
  };

  fileSystems."/mnt/cruzer3" = {
    label = "cruzer3";
    device = "/dev/mapper/cryptcruzer3";
    fsType = "ext4";
    options = [ "nofail" "user" "defaults" ];
  };
}

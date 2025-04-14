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


  fileSystems."/mnt/cruzer-key" = {
    label = "cruzer4";
    device = "/dev/mapper/cryptcruzer4";
    fsType = "ext4";
    options = [ "nofail" "user" "defaults" ];
  };

  # age.secrets.cruzer-key = {
  #   file = /etc/nixos/secrets/cruzer-key.age;
  #   name = "cruzer-key";
  #   mode = "770";
  #   owner = "lerrrtaste";
  #   group = "root";
  #   symlink = false;
  # };

}

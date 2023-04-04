{ config, lib, pkgs, ... }:

{
  # cruzer usb sticks
  # fileSystems."/mnt/cruzer1" = {
  #   device = "/dev/mapper/cryptcruzer1";
  #   fsType = "ext4";
  #   options = [ "noauto" "nofail" "user" "defaults" ];

  #   neededforBoot = false;
  #   enrypted.enable = true;
  #   encrypted.keyFile = "/root/keyfile_cruzers";
  #   encrypted.label = "cyptcruzer1";
  #   encrypted.blkDev = "/dev/disk/by-uuid/";
  # };

  # fileSystems."/mnt/cruzer2" = {
  #   device = "/dev/mapper/cryptcruzer2";
  #   fsType = "ext4";
  #   options = [ "noauto" "nofail" "user" "defaults" ];

  #   neededForBoot = false;
  #   encrypted.enable = true;
  #   encrypted.keyFile = "/root/keyfile_cruzers";
  #   encrypted.label = "cryptcruzer1";
  #   encrypted.blkDev = "/dev/disk/by-uuid/25d63b4d-4a03-4160-896d-b7be71e257e8";
  # };

  # fileSystems."/mnt/cruzer3" = {
  #   device = "/dev/mapper/cryptcruzer3";
  #   fsType = "ext4";
  #   options = [ "noauto" "nofail" "user" "defaults" ];

  #   neededforBoot = false;
  #   enrypted.enable = true;
  #   encrypted.keyFile = "/root/keyfile_cruzers";
  #   encrypted.label = "cyptcruzer1";
  #   encrypted.blkDev = "/dev/disk/by-uuid/";
  # };
}

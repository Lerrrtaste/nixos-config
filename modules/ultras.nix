{ config, lib, pkgs, ... }:

{
  services.udisks2.enable = true; #automount?

  # HDDs
  fileSystems."/media/hd1" = {
    label = "hd1";
    # device = "/dev/disks/by-label/hd1";
    device = "/dev/disks/by-uuid/6EF7-2F74";
    fsType = "exfat";
    options = [ "noauto" "nofail" "x-systemd.automount" "user" "defaults" "rw" "file_mode=0660" "dir_mode=0770" "gid=${toString config.users.groups.users.gid}"];
  };

  # ultra usb sticks
  fileSystems."/media/ultras/o1" = {
    label = "o1-ventoy";
    # device = "/dev/disks/by-label/o1-ventoy/";
    device = "/dev/disks/by-uuid/F0BA-E8B4";
    fsType = "exfat";
    options = [ "nofail" "user" "defaults" "rw" "uid=1000" ];
  };

  # fileSystems."/mnt/ultras/o2" = {
  #   label = "cruzer2";
  #   device = "/dev/mapper/cryptcruzer2";
  #   fsType = "ext4";
  #   options = [ "nofail" "user" "defaults" ];
  # };

  # fileSystems."/media/ultras/o3" = {
  #   label = "cruzer3";
  #   device = "/dev/mapper/cryptcruzer3";
  #   fsType = "ext4";
  #   options = [ "nofail" "user" "defaults" ];
  # };


   # fileSystems."/mnt/cruzer-key" = {
  #   label = "cruzer4";
  #   device = "/dev/mapper/cryptcruzer4";
  #   fsType = "ext4";
  #   options = [ "nofail" "user" "defaults" ];
  # };

  # age.secrets.cruzer-key = {
  #   file = /etc/nixos/secrets/cruzer-key.age;
  #   name = "cruzer-key";
  #   mode = "770";
  #   owner = "lerrrtaste";
  #   group = "root";
  #   symlink = false;
  # };

}

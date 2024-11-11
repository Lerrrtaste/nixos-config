{ config, lib, pkgs, ... }:

{
  # fileSystems."/media/cube/annex" = {
  #   label = "CubeAnnexShare";
  #   fsType = "nfs";
  #   device = "CubeServer.local:/mnt/annex";
  #   # options = [ "password=@sb-sub3-pw@"
  #   options = ["_netdev" # is network device
  #               "nofail" # do not fail boot
  #               "noauto" # do not mount at boot
  #               "x-systemd.automount" # automount on demand

  #               # "reconnect" # reconnect on failure
  #               # "ServerAliveInterval=15" # keep alive
  #             ];
  # };
  # system.activationScripts."cube-secrets" = ''
  #   sbpw=$(cat "${config.age.secrets.cb-pw.path}")
  #   cbuser=$(cat "${config.age.secrets.cb-user.path}")
  #   cbhost=$(cat "${config.age.secrets.cb-host.path}")
  #   ${pkgs.gnused}/bin/sed -i "s#@cb-pw@#$cbpw#" /etc/fstab
  #   ${pkgs.gnused}/bin/sed -i "s#@cb-user@#$cbuser#" /etc/fstab
  #   ${pkgs.gnused}/bin/sed -i "s#@cb-host@#$cbhost#" /etc/fstab
  # '';
  # age.secrets.cb-pw.file = /etc/nixos/secrets/cb-pw.age;
  # age.secrets.cb-user.file = /etc/nixos/secrets/cb-user.age;
  # age.secrets.cb-host.file = /etc/nixos/secrets/cb-host.age;

  fileSystems."/media/cube" = {
    device = "doc@CubeServer.local:/";
    fsType = "fuse.sshfs";
    options = [
      "_netdev" # is network device
      "noauto" # do not mount at boot
      "allow_other" # allow users
      "x-systemd.automount" # automount on demand
      "ssh_command=ssh -p 2022"
    ];
  };

}

{ config, lib, pkgs, ... }:

let
  options = [
      "_netdev" # is network device
      "noauto" # do not mount at boot
      "nofail"
      "x-systemd.automount" # automount on demand
      # "username=doc"
      # "password=@cb-pw@"
      "domain=CUBEGROUP"
      # "umask=ug=rwx,o="
      "credentials=${config.age.secrets.cb-creds-doc.path}"
      "file_mode=0660"           # Read/Write for owner and group
      "dir_mode=0770"            # Directory read/write for owner and group
      # "uid=${toString config.users.users.lerrrtaste.uid}"
      "gid=${toString config.users.groups.users.gid}"
    ];
in
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

  fileSystems."/media/cube/sftpgo" = {
    device = "${config.networking.hostName}@192.168.2.113:/";
    fsType = "fuse.sshfs";
    options = [
      "_netdev" # is network device
      # "identityfile=/home/lerrrtaste/.ssh/id_ed25519"
      "noauto" # do not mount at boot
      "allow_other" # allow users
      "x-systemd.automount" # automount on demand
    "ssh_command=ssh\\040-p\\0402022"
      # "ssh_command=ssh -p 2022"
      # "directport=2022"
    ];
  };

  fileSystems."/media/cube/smb/isos" = {
    device = "//cubeserver1.local/isos";
    fsType = "cifs";
    options = options;
  };
  fileSystems."/media/cube/smb/games" = {
    device = "//cubeserver1.local/games";
    fsType = "cifs";
    options = options;
  };
  fileSystems."/media/cube/smb/media" = {
    device = "//cubeserver1.local/media";
    fsType = "cifs";
    options = options;
  };
  fileSystems."/media/cube/smb/inbox" = {
    device = "//cubeserver1.local/inbox";
    fsType = "cifs";
    options = options;
  };
  fileSystems."/media/cube/smb/cubedrive" = {
    device = "//cubeserver1.local/cubedrive";
    fsType = "cifs";
    options = options;
  };
  # system.activationScripts."cube-secrets" = lib.stringAfter [ "etc" "agenix" ] ''
  #   cbpw=$(cat "${config.age.secrets.cb-pw.path}")
  #   ${pkgs.gnused}/bin/sed -i "s#@cb-pw@#$cbpw#" /etc/fstab
  # '';
  # age.secrets.cb-pw.file = /etc/nixos/secrets/cb-pw.age;
  age.secrets.cb-creds-doc.file = /etc/nixos/secrets/cb-creds-doc.age;

  # TODO migrate to credentials file
  #        credentials=filename
           # specifies a file that contains a username and/or password and optionally the name of
           # the workgroup. The format of the file is:

           #               username=value
           #               password=value
           #               domain=value

           # This is preferred over having passwords in plaintext in a shared file, such as
           # /etc/fstab. Be sure to protect any credentials file properly.
           # https://manpages.ubuntu.com/manpages/xenial/man8/mount.cifs.8.html#contenttoc3

}

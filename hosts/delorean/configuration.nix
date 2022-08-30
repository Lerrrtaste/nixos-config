#   ____            __
#  /\  _`\         /\ \
#  \ \ \/\ \     __\ \ \        ___   _ __    __     __      ___
#   \ \ \ \ \  /'__`\ \ \  __  / __`\/\`'__\/'__`\ /'__`\  /' _ `\
#    \ \ \_\ \/\  __/\ \ \L\ \/\ \L\ \ \ \//\  __//\ \L\.\_/\ \/\ \
#     \ \____/\ \____\\ \____/\ \____/\ \_\\ \____\ \__/.\_\ \_\ \_\
#      \/___/  \/____/ \/___/  \/___/  \/_/ \/____/\/__/\/_/\/_/\/_/
#
# DeLorean hardware specific configuration

{ config, lib, pkgs, options, ... }:

{                                                                   
  imports = [
    ./hardware-configuration.nix
    ../../modules/common.nix
  ];

  # EFI boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Network
  networking.hostName = "delorean";

  networking.networkmanager = {
    enable = true;
    dhcp = "dhcpcd";
    wifi.backend = "wpa_supplicant";
  };

  # LUKS
  boot.initrd.luks.fido2Support = true;
  boot.initrd.luks.devices = {
    cryptroot = {
      device = "/dev/disk/by-uuid/63d25036-4b8f-46c3-a6c4-a82dddd8f2b8";
      fido2.passwordLess = true;
      preLVM = true;
      allowDiscards = true;
    };
  };
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];  # better for ssds (?)

#─sda1          8:1    0   500M  0 part  /mnt/boot      A2A2-741D
#─sda2          8:2    0 232.4G  0 part                 63d25036-4b8f-46c3-a6c4-a82dddd8f2b8
# └─cryptroot 254:1    0 232.4G  0 crypt /mnt           f5ce4bf2-95f1-4d81-a086-dad583582cac

  # Displays
  services.xserver.resolutions = [  # TODO see if this even does anything, remove when autorandr service works
    {
      x = 1920;
      y = 1080;
    }
  ];
  services.autorandr.enable = true;

  # Packages
  environment.systemPackages = with pkgs; [
    autorandr
  ];

  # Services
  # FIXME needs ssl cert (generate it here!)
  # TODO (dwm) shortcuts (. -> mrfusion , comma -> delorean screen)
  #systemd.services.barriers = {
  #  enable = true;  # doesnt enable the service (wantedBy attr for autostart)
  #  description = "Custom Barrier Server Daemon";
  #  unitConfig = {
  #  };
  #  serviceConfig = {
  #    User = "lerrrtaste";
  #    ExecStart = "barriers --enable-crypto --debug INFO --enable-drag-drop --restart --adress ::24888";
  #  };
  #};

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # SSH
  services.openssh.enable = true;

  # Firewall
  networking.firewall.allowedTCPPorts = [ 24888 ];
  networking.firewall.allowedUDPPorts = [ 24888 ];

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}


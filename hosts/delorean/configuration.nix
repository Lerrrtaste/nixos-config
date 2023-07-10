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

let
  default_fingerprints =  {
    DisplayPort-1 = "00ffffffffffff004c2d80704e38383007210104b54628783b43a5ae5244b0260f5054bfef80714f810081c081809500a9c0b300010198e200a0a0a0295008403500ba892100001a000000fd003090d6d63b010a202020202020000000fc004c433332473578540a20202020000000ff00484b32573230303739360a202001f6020327f144903f1f042309070783010000e305c0006d1a000002013090000000000000e3060501565e00a0a0a0295030203500ba892100001a6fc200a0a0a0555030203500ba892100001a5a8780a070384d4030203500ba892100001a023a801871382d40582c4500ba892100001e00000000000000000000000000000000d7";
    DisplayPort-2 = "00ffffffffffff004dd9034b0101010101180103804728780a0dc9a05747982712484c2108008180a9c0714fb3000101010101010101023a801871382d40582c4500c48e2100001e011d007251d01e206e285500c48e2100001e000000fc00534f4e592054560a2020202020000000fd00303e0e460f000a202020202020017802032ff0531f101405130420223c3e121603071115020601260d0707150750830f000068030c004000b82d0fe200fb023a80d072382d40102c4580c48e2100001e011d00bc52d01e20b8285540c48e2100001e011d8018711c1620582c2500c48e2100009e011d80d0721c1620102c2580c48e2100009e00000000000000007a";
    HDMI-A-0 = "00ffffffffffff001e6df97674170300021c010380502278eaca95a6554ea1260f5054256b807140818081c0a9c0b300d1c08100d1cfcd4600a0a0381f4030203a001e4e3100001a003a801871382d40582c4500132a2100001e000000fd00284b5a5a18000a202020202020000000fc004c4720554c545241574944450a014c020323f12309070747100403011f13128301000065030c001000681a00000101284b008c0ad08a20e02d10103e96001e4e31000018295900a0a038274030203a001e4e3100001a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a3";
  };

  raidMonitorScript = pkgs.writeShellScript "raid-monitor.sh" ''
    #!/bin/bash

    # Set the RAID device name
    RAID_DEVICE="/dev/md127"

    # Get RAID status
    raid_status=$(mdadm --detail $RAID_DEVICE | awk '/State :/{print $NF}')

    # Extract the event information from the RAID status
    MDADM_EVENT="Status changed to: ''$raid_status"
    MDADM_LEVEL=$(mdadm --detail $RAID_DEVICE | awk '/Raid Level :/{print $NF}')
    MDADM_RAID_DEVICES=$(mdadm --detail $RAID_DEVICE | awk '/Active Devices :/{print $NF}')

    # Send notification
    DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus notify-send -i notification-message-im   -u critical "$(echo -e "RAID event detected on $RAID_DEVICE\n\nEvent: $MDADM_EVENT\nRAID level: $MDADM_LEVEL\nDevices: $MDADM_RAID_DEVICES\nStatus: $raid_status")"
  '';
in
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

  # GPU
  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;

  ### Mdadm Raid Status Update Notifications ###
  systemd.services.mdadm = {
    description = "MDADM RAID monitor";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.mdadm}/bin/mdadm --monitor --scan --daemonise --program=${raidMonitorScript}";
      Type = "forking";
      Restart = "always";
    };
  };

  # Displays
  services.xserver.enable = true;
  services.xserver = {
    monitorSection = ''
      Modeline "2560x1080_30"  106.56  2560 2640 2896 3232  1080 1081 1084 1099  -HSync +Vsync
    '';

    deviceSection = ''
    Option "ModeValidation" "AllowNonEdidModes"
    '';
    # xrandrHeads =
    # [ "DVI-0"
    #   {
    #     output = "DVI-0";
    #     mode = "2560x1080_30";
    #     primary = false;
    #     monitorConfig = ''
    #       Option "Rotate" "right"
    #       Option "RightOf" "HDMI-0"
    #     '';
    #   }
    # ];
  };

  services.autorandr = {
    enable = true;
    profiles = {
      "vdesk" = {
        fingerprint = default_fingerprints;
        config = {
          HDMI-A-0 = {
            enable = true;
            primary = false;
            mode = "2560x1080";
            position = "2560x0";
            rotate = "right";
            rate = "75";
          };
          DisplayPort-1 = {
            enable = true;
            primary = true;
            mode = "2560x1440";
            position = "0x500";
          };
          DisplayPort-2 = {
            enable = false;
          };
        };
      };

      "tv" = {
        fingerprint = default_fingerprints;
        config = {
          HDMI-A-0 = {
            enable = false;
          };
          DisplayPort-1 = {
            enable = false;
          };
          DisplayPort-2 = {
            enable = true;
            primary = true;
            mode = "1920x1080";
          };
        };
      };

      "deck" = {
        fingerprint = default_fingerprints;
        config = {
          HDMI-A-0 = {
            enable = false;
          };
          DisplayPort-1 = {
            enable = false;
          };
          DisplayPort-2 = {
            enable = true;
            primary = true;
            mode = "1280x800";
          };
        };
      };


    #   "hdesk" = {
    #     fingerprint = default_fingerprints;
    #     config = {
    #       HDMI-A-0 = {
    #         enable = true;
    #         primary = true;
    #         mode = "1920x1080";
    #         position = "0x0";
    #       };
    #       DisplayPort-1 = {
    #         enable = true;
    #         primary = false;
    #         mode = "2560x1080";
    #         position = "1920x0";
    #         rate = "75";
    #       };
    #       DisplayPort-2 = {
    #         enable = false;
    #       };
    #     };
    #   };

    #   "deskgaming" = {
    #     fingerprint = default_fingerprints;
    #     config = {
    #       HDMI-A-0 = {
    #         enable = false;
    #       };
    #       DisplayPort-1 = {
    #         enable = true;
    #         primary = true;
    #         mode = "2560x1080";
    #         position = "0x0";
    #         rate = "75";
    #       };
    #       DisplayPort-2 = {
    #         enable = false;
    #       };
    #     };
    #   };
    };
  };

  # Packages
  environment.systemPackages = with pkgs; [
    mdadm

    nvtop-amd
    corectrl

    # OpenCL for radv (not amdvlk)
    rocm-opencl-icd
    rocm-opencl-runtime

    # steam mode
    openbox
  ];

  # Bluetooth
  hardware.bluetooth = {
    package = pkgs.bluezFull;
    enable = true;
    settings =
    {
      General = {
        Enable="Source,Sink,Media,Socket";
      };
    };
  };

  services.blueman.enable = true;
  hardware.pulseaudio.extraConfig = ''
    load-module module-switch-on-connect
  '';
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
  networking.firewall.allowedTCPPorts = [ 24888 24070 ];
  networking.firewall.allowedUDPPorts = [ 24888 ];

  # Jello
  # users.users.jello = {
  #   isNormalUser = true;
  #   home = "/media/raid/jello";
  #   group = "jello";
  #   initialPassword = "changeme";
  #   cryptHomeLuks = "/dev/mapper/cryptraid";
  # };

  # Console Gaming User
  # users.users.steam = {
  #   isNormalUser = true;
  #   home = "/home/steam"; #shared between steamdeck and steambp
  #   group = "steam";
  #   extraGroups = [ "users" "wheel" "networkmanager" ]; # note dont add to docker!
  #   initialPassword = "changeme";
  #   packages = [
  #     pkgs.tinywm
  #     pkgs.xdotool
  #   ];
  # };

  users.motd = "Welcome to Delorean!";

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


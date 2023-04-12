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

  # GPU
  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;

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
        fingerprint = {
          DisplayPort-2 = "00ffffffffffff0009d1417f455400000c1a0103803c22782eeab5a55751a1260c5054a56b80d1c081c081008180a9c0b30001010101023a801871382d40582c450056502100001e000000ff005233473030383937534c300a20000000fd00324c1e5311000a202020202020000000fc0042656e5120524c323735350a200175020322f14f90050403020111121314060715161f2309070765030c00200083010000023a801871382d40582c450056502100001f011d8018711c1620582c250056502100009f011d007251d01e206e28550056502100001e8c0ad08a20e02d10103e960056502100001800000000000000000000000000000000000000000037";
          HDMI-A-0 = "00ffffffffffff001e6df97674170300021c010380502278eaca95a6554ea1260f5054256b807140818081c0a9c0b300d1c08100d1cfcd4600a0a0381f4030203a001e4e3100001a003a801871382d40582c4500132a2100001e000000fd00384b1e5a18000a202020202020000000fc004c4720554c545241574944450a017802031af12309070747100403011f13128301000065030c0010008c0ad08a20e02d10103e96001e4e31000018295900a0a038274030203a001e4e3100001a000000000000000000000000000000000000000000000000000000000000000000000000000000ff003830324e544a4a35593631320a0000000000000000000000a3";
        };
        config = {
          HDMI-A-0 = {
            enable = true;
            primary = false;
            mode = "2560x1080";
            position = "1920x0";
            rotate = "right";
            rate = "75.00";
          };
          DisplayPort-2 = {
            enable = true;
            primary = true;
            mode = "1920x1080";
            position = "0x1000";
            rate = "60";
          };
        };
      };

      "gamingdesk" = {
        fingerprint = {
          DisplayPort-2 = "00ffffffffffff0009d1417f455400000c1a0103803c22782eeab5a55751a1260c5054a56b80d1c081c081008180a9c0b30001010101023a801871382d40582c450056502100001e000000ff005233473030383937534c300a20000000fd00324c1e5311000a202020202020000000fc0042656e5120524c323735350a200175020322f14f90050403020111121314060715161f2309070765030c00100083010000023a801871382d40582c450056502100001f011d8018711c1620582c250056502100009f011d007251d01e206e28550056502100001e8c0ad08a20e02d10103e960056502100001800000000000000000000000000000000000000000047";
          HDMI-A-0 = "00ffffffffffff0009d1417f455400000c1a0103803c22782eeab5a55751a1260c5054a56b80d1c081c081008180a9c0b30001010101023a801871382d40582c450056502100001e000000ff005233473030383937534c300a20000000fd00324c1e5311000a202020202020000000fc0042656e5120524c323735350a200175020322f14f90050403020111121314060715161f2309070765030c00100083010000023a801871382d40582c450056502100001f011d8018711c1620582c250056502100009f011d007251d01e206e28550056502100001e8c0ad08a20e02d10103e960056502100001800000000000000000000000000000000000000000047";
        };
        config = {
          HDMI-A-0 = {
            enable = false;
            primary = true;
            mode = "2560x1080";
            rotate = "normal";
            position = "0x0";
            rate = "75.00";
          };
          DisplayPort-2 = {
            enable = false;
            primary = false;
            mode = "1920x1080";
            position = "0x1000";
            rate = "60";
          };
        };
      };
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
  ];

  # Bluetooth
  hardware.bluetooth = {
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


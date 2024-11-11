# Doc hardware specific configuration

{ config, lib, pkgs, options, ... }:

let
  b_fingerprints =  {
    DP = "";
    HDMI = "";
  };
in
{                                                                   
  imports = [
    ./hardware-configuration.nix
    ../../modules/common.nix
     ../../modules/cube.nix
  ];

  # EFI boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Network
  networking.hostName = "doc";

  networking.networkmanager = {
    enable = true;
    dhcp = "dhcpcd";
    wifi.backend = "wpa_supplicant";
  };

  # GPU
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
    # package = config.boot.kernelPackages.nvidiaPackages.vulkan_beta;
    # package = pkgs.linuxKernel.packages.linux_5_15.nvidia_x11;
  };

  # Mouse
  hardware.openrazer.enable = true;
  hardware.openrazer.users = ["lerrrtaste"];

  # Virtualisation
  virtualisation.docker.enable = false;
  virtualisation.docker.rootless = {
   enable = false;
   setSocketVariable = true;
  }
;
  virtualisation.libvirtd = {
    enable = true;
    onBoot = "ignore"; # or start
    onShutdown = "shutdown"; # or suspend
    qemu = {
      swtpm.enable = true;
      runAsRoot = true;
      ovmf.enable = true;
    };
  };
  programs.virt-manager.enable = true;
  # programs.dconf.settings = {
  #   "org/virt-manager/virt-manager/connections" = {
  #     autoconnect = ["qemu:///system"];
  #     uris = ["qemu:///system"];
  #   };
  # };

  # Displays
  services.xserver.enable = true;
  services.autorandr = {
    enable = true;
    #profiles = {
    #  "vdesk" = {
    #    fingerprint = b_fingerprints;
    #    config = {
    #      HDMI = {
    #        enable = true;
    #        primary = false;
    #        mode = "1920x1080";
    #        position = "0x0";
    #      };
    #      DP = {
    #        enable = true;
    #        primary = true;
    #        mode = "2560x1440";
    #        position = "1920x0";
    #      };
    #    };
    #  };
    #};
  };

  # Packages
  environment.systemPackages = with pkgs; [
    # gpu stuff
    # nvtopPackages.nvidia nvitop
    gpustat
    glmark2 # benchmark

    corectrl
    polychromatic

    barrier
  ];

  # Bluetooth
  hardware.bluetooth = {
    package = pkgs.bluez;
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

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };


  # SSH

  # Firewall
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 
    24800 # barrier
    22
  ];
  networking.firewall.allowedUDPPorts  = [
    24800 # barrier
    22
  ];
  users.motd = "Welcome to Doc!";

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


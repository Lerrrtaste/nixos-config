# Doc hardware specific configuration

{ config, lib, pkgs, options, ... }:

let
  b_fingerprints =  {
    DP-1 = "00ffffffffffff005a6335e701010101041f0103804627782e1105a5574fad2a0a5054bfef80b300a940a9c0950090408180814081c0023a801871382d40582c4500ba892100001e000000ff005b185612000a202020202020000000fc005658333237362d4648440a2020016d020320f14d010203040590121113141e1d1f23097f078301000065030c0010002a4480a07038274030203500ba8921000e023a80d072382d40102c4580ba892100001e011d007251d01e206e285500ba892100001e011d00bc52d01e20b8285540ba892100001e000000000025";
    DP-2 = "00ffffffffffff004c2d80704e38383007210104b54628783b43a5ae5244b0260f5054bfef80714f810081c081809500a9c0b300010198e200a0a0a0295008403500ba892100001a000000fd00333332473578540a20202020000000ff00484b32573230303739360a202001f6020327f144903f1f042309070783010000e305c0006d1a000002013090000000000000e3060501565e00a0a0a02950302500ba892100001a5a8780a070384d4030203500ba892100001a023a801871382d40582c4500ba892100001e00000000000000000000000000000000d7";
    HDMI-0 = "00ffffffffffff001e6df97674170300021c010380502278eaca95a6554ea1260f5054256b807140818081c0a9c0b300d1c08100d1cfcd4600a0a0381f4030203a001e4e3100001a003a8018784b5a5a18000a202020202020000000fc004c4720554c545241574944450a014c020323f12309070747100403011f13128301000065030c001000681a00000101284b008c0ad08a20e02d10103e96001e3100001a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a3";
  };

  # lanzaboote-src = pkgs.fetchFromGitHub {
  #   owner = "nix-community";
  #   repo = "lanzaboote";
  #   rev = "v0.4.1"; # Replace with the version you want
  #   sha256 = "0l82cq5xjbbh8grfvzz49qf3g2b1wrpnpfv1jdjyxwfj0n9a0n1j"; # Replace with the correct hash
  # };

  # lanzaboote = import lanzaboote-src;
in
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/common.nix
    ../../modules/cube.nix
    # ../../modules/secureboot.nix
    # ../../modules/webcam.nix
  ];

  # EFI boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # boot.lanzaboote = { # required for secure boot (ran sbctl create-keys before)
  #   enable = true;
  #   pkiBundle = "/etc/secureboot";
  # };

  # Network
  networking.hostName = "doc";
  services.tailscale.enable = false;
  services.tailscale.authKeyFile = config.age.secrets.ts-auth-doc.path;

  networking.networkmanager = {
    enable = true;
    dhcp = "dhcpcd";
    # wifi.backend = "wpa_supplicant";
  };

  # GPU
  services.xserver.videoDrivers = [ "nvidia" ];
  # hardware.opengl = {
  #   enable = true;
  #   driSupport = true;
  #   driSupport32Bit = true;
  # };

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
    profiles = {
     "bibs" = {
       fingerprint = b_fingerprints;
       config = {
         HDMI-0 = {
           enable = true;
           mode = "2560x1080";
           position = "4480x0";
         };
         DP-0 = {
           enable = false;
         };
         DP-1 = {
           enable = true;
           mode = "1920x1080";
           position = "2560x0";
         };
         DP-2 = {
           enable = true;
           primary = true;
           mode = "2560x1440";
           position = "0x0";
         };
       };
     };
    };
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
  # hardware.pulseaudio.extraConfig = ''
  #   load-module module-switch-on-connect
  # '';

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
    # 24800 # barrier
    # 22
    # 27040 # steam local dl
  ];
  networking.firewall.allowedUDPPorts  = [
    # 24800 # barrier
    # 22
    # 27031 # steam local dl client discovery
    # 27032
    # 27033
    # 27034
    # 27035
    # 27036 # client discovery end
  ];
  users.motd = "Welcome to Doc!";

  # Secrets

  age.secrets.ts-auth-doc = {
   file = /etc/nixos/secrets/ts-auth-doc.age;
   name = "ts-auth-doc";
   # path = "/etc/wireguard/wg0.conf";
   # mode = "600";
   # owner = "lerrrtaste";
   # group = "root";
    # symlink = false;
  };

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


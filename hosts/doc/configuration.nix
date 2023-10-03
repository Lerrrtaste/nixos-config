# Doc hardware specific configuration

{ config, lib, pkgs, options, ... }:

let
  b_fingerprints =  {
    DP-2 = "00ffffffffffff004c2d80704e38383007210104b54628783b43a5ae5244b0260f5054bfef80714f810081c081809500a9c0b300010198e200a0a0a0295008403500ba892100001a000000fd003090d6d63b010a202020202020000000fc004c433332473578540a20202020000000ff00484b32573230303739360a202001f6020327f144903f1f042309070783010000e305c0006d1a000002013090000000000000e3060501565e00a0a0a0295030203500ba892100001a6fc200a0a0a0555030203500ba892100001a5a8780a070384d4030203500ba892100001a023a801871382d40582c4500ba892100001e00000000000000000000000000000000d7";
    HDMI-0 = "00ffffffffffff001e6df97674170300021c010380502278eaca95a6554ea1260f5054256b807140818081c0a9c0b300d1c08100d1cfcd4600a0a0381f4030203a001e4e3100001a003a801871382d40582c4500132a2100001e000000fd00284b5a5a18000a202020202020000000fc004c4720554c545241574944450a014c020323f12309070747100403011f13128301000065030c001000681a00000101284b008c0ad08a20e02d10103e96001e4e31000018295900a0a038274030203a001e4e3100001a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a3";
  };
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
    package = config.boot.kernelPackages.nvidiaPackages.vulkan_beta;
    # package = pkgs.linuxKernel.packages.linux_5_15.nvidia_x11;
  };

  # Displays
  services.xserver.enable = true;
  services.autorandr = {
    enable = true;
    profiles = {
      "vdesk" = {
        fingerprint = b_fingerprints;
        config = {
          HDMI-0 = {
            enable = true;
            primary = false;
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
    nvtop
    corectrl
    polychromatic
    openrazer-daemon
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
  # networking.firewall.allowedTCPPorts = [ 24888 24070 ];
  # networking.firewall.allowedUDPPorts = [ 24888 ];

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


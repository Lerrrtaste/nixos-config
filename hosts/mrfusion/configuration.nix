#                  ____
#   /'\_/`\       /\  _`\                 __
#  /\      \  _ __\ \ \L\_\__  __    ____/\_\    ___     ___
#  \ \ \__\ \/\`'__\ \  _\/\ \/\ \  /',__\/\ \  / __`\ /' _ `\
#   \ \ \_/\ \ \ \/ \ \ \/\ \ \_\ \/\__, `\ \ \/\ \L\ \/\ \/\ \
#    \ \_\\ \_\ \_\  \ \_\ \ \____/\/\____/\ \_\ \____/\ \_\ \_\
#     \/_/ \/_/\/_/   \/_/  \/___/  \/___/  \/_/\/___/  \/_/\/_/
#
# MrFusion hardware specific configuration

{ config, lib, pkgs, options, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/common.nix
  ];

  # Temporary and Testing

  # Power Management
  powerManagement.cpuFreqGovernor = "performance";

  # EFI boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # LUKS
  boot.initrd.luks.fido2Support = true;
  boot.initrd.luks.devices = {
    cryptroot = {
      device = "/dev/disk/by-uuid/307aa1c2-972d-47a7-8813-dfcd0da73112";
      fido2.passwordLess = true;
      preLVM = true;
      allowDiscards = true;
    };
  };
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];  # better for ssds (?)

  # Displays
  services.xserver.resolutions = [  # TODO see if this even does anything, remove when autorandr service works
    {
      x = 1920;
      y = 1080;
    }
  ];
  services.autorandr.enable = true;

  # Laptop Hardware
  services.xserver.libinput.enable = true;  # touchpad
  services.xserver.libinput.touchpad = {
    disableWhileTyping = true;
    tapping = true;
  };
  environment.systemPackages = [
    pkgs.brightnessctl # brightnessctl s 50%
    pkgs.nvtop-amd
    pkgs.powertop
    pkgs.android-tools
    pkgs.chromium
  ];
  # hardware.enableAllFirmware = true;
  # nixpkgs.config.allowUnfree = true;
  services.tlp.enable = false;
  services.tlp.settings = {
    # CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
    # CPU_MIN_PERF_ON_BAT = 0;
    # CPU_MAX_PERF_ON_BAT = 25;
    # PCIE_ASPM_ON_BAT = "powersave";
    # SATA_LINKPWR_ON_BAT = "min_power";
    # BRIGHTNESS_ON_BAT = 30;
    # WIFI_PWR_ON_BAT = 5;
    # SOUND_POWER_SAVE_ON_BAT = 1;
    # USB_AUTOSUSPEND = 1;
    # DISK_IDLE_SECS_ON_BAT = 60;
  };

  services.xserver.xkbOptions = "ctrl:nocaps"; # map caps to escape.

  # Android
  services.udev.packages = [
    pkgs.android-udev-rules
  ];

  programs.adb.enable = true;

  # Graphics
  services.xserver.videoDrivers = [ "amdgpu" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  hardware.opengl.driSupport = true;  # OpenGL
  hardware.opengl.extraPackages = with pkgs; [
    amdvlk  # optional in addition to mesa radv drivers
  ];
  environment.variables.AMD_VULKAN_ICD = "RADV";  # use radv



  location = {
    # center of germany
    latitude = 51.1657;
    longitude = 10.4515;
  };

  services.redshift = { # FIXME service doesnt start
    enable = true;
    # brightness = {
    #   day = "1";
    #   night = "1";
    # };
    temperature = {
      day = 5500;
      night = 3700;
    };
  };

  # Bluetooth
  hardware.bluetooth = {
    enable = false;
    settings =
    {
      General = {
        Enable="Source,Sink,Media,Socket";
      };
    };
  };

  # services.blueman.enable = true;
  # hardware.pulseaudio.extraConfig = "
  #   load-module module-switch-on-connect
  # ";

 # Network
  networking.hostName = "mrfusion";

  networking.networkmanager = {
    enable = true;
    dhcp = "dhcpcd";
    wifi.backend = "wpa_supplicant";
  };
}

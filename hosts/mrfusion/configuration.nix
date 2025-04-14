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
let
  nix-mineral = pkgs.fetchgit {
    url = "https://github.com/cynicsketch/nix-mineral.git";

    # now add one of the following:
    # a specific tag 
    ref = "refs/tags/v0.1.6-alpha"; # Modify this tag as desired. Tags can be found here: https://github.com/cynicsketch/nix-mineral/tags. You will have to manually change this to the latest tagged release when/if you want to update.
    # or a specific commit hash
    # rev = "cfaf4cf15c7e6dc7f882c471056b57ea9ea0ee61";  
    # or the HEAD
    # ref = "HEAD"; # This will always fetch from the head of main, however this does not guarantee successful configuration evaluation in future - if we change something and you rebuild purely, your evaluation will fail because the sha256 hash will have changed (so may require manually changing every time you evaluate, to get a successful evaluation).

    # After changing any of the above, you to update the hash. 

    # Now the sha256 hash of the repository. This can be found with the nix-prefetch-url command, or (the simpler method) you can place an incorrect, but valid hash here, and nix will fail to evaluate and tell you the hash it expected (which you can then change this value to).
    # NOTE: this can be omitted if you are evaluating/building impurely.
    sha256 = "1mac9cnywpc4a0x1f5n45yn4yhady1affdmkimt2lg8rcw65ajh2";
  };
in
{
  imports = [
    "${nix-mineral}/nix-mineral.nix"
    ./hardware-configuration.nix
    ../../modules/common.nix
  ];

  # Power Management
  powerManagement.cpuFreqGovernor = "performance";

  # EFI boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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
  # pkgs.android-tools
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
  # services.udev.packages = [
  #   pkgs.android-udev-rules
  # ];

  # programs.adb.enable = true;

  # Graphics
  services.xserver.videoDrivers = [ "amdgpu" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  hardware.opengl.extraPackages = with pkgs; [
    amdvlk  # optional in addition to mesa radv drivers
  ];
  environment.variables.AMD_VULKAN_ICD = "RADV";  # use radv

  #location = {
  #  # center of germany
  #  latitude = 51.1657;
  #  longitude = 10.4515;
  #};

  #services.redshift = { # FIXME service doesnt start
  #  enable = true;
  #  temperature = {
  #    day = 5500;
  #    night = 3700;
  #  };
  #};

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

  services.blueman.enable = true;
  hardware.pulseaudio.extraConfig = "
    load-module module-switch-on-connect
  ";

 # Network
  networking.hostName = "mrfusion";

  networking.networkmanager = {
    enable = true;
    dhcp = "dhcpcd";
    wifi.backend = "wpa_supplicant";
  };
}

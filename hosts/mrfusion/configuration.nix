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
  programs.light.enable = true;  # background light (light -A/-U 20)
  services.xserver.libinput.enable = true;  # touchpad

  # Graphics
  services.xserver.videoDrivers = [ "amdgpu" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  hardware.opengl.driSupport = true;  # OpenGL
  hardware.opengl.extraPackages = with pkgs; [
    amdvlk  # optional in addition to mesa radv drivers
  ];
  environment.variables.AMD_VULKAN_ICD = "RADV";  # use radv

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

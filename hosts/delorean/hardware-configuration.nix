# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  # boot.initrd.kernelModules = [ "ati" ];
  boot.kernelModules = [ "ati" "kvm-amd" ];
  boot.extraModulePackages = [ ];
  boot.kernelParams = [ ];

  # # Enable Vulkan
  # hardware.opengl.driSupport = true;
  # hardware.opengl.driSupport32Bit = true; # For 32 bit applications


  fileSystems."/" =
    { device = "/dev/disk/by-uuid/f5ce4bf2-95f1-4d81-a086-dad583582cac";
      fsType = "ext4";
    };

  # cruzer usb sticks
  fileSystems."/mnt/cruzer1" = {
    device = "/dev/disk/by-label/cruzer1";
    fsType = "ext4";
    options = [ "noauto" "user" "defaults" ];
  };
  fileSystems."/mnt/cruzer2" = {
    device = "/dev/disk/by-label/cruzer2";
    fsType = "ext4";
    options = [ "noauto" "user" "defaults" ];
  };
  fileSystems."/mnt/cruzer3" = {
    device = "/dev/disk/by-label/cruzer3";
    fsType = "ext4";
    options = [ "noauto" "user" "defaults" ];
  };
  fileSystems."/mnt/cruzer4" = {
    device = "/dev/disk/by-label/cruzer4";
    fsType = "ext4";
    options = [ "noauto" "user" "defaults" ];
  };

  boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/63d25036-4b8f-46c3-a6c4-a82dddd8f2b8";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/A2A2-741D";
      fsType = "vfat";
    };
  fileSystems."/media/hdd" =
    { device = "/dev/disk/by-label/HDD";
      fsType = "ext4";
    };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp38s0u1.useDHCP = lib.mkDefault true;

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}

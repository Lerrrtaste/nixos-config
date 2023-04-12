# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/c9a7f542-7277-4709-a929-e1c7ffde565f";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/B4A2-1115";
      fsType = "vfat";
    };

  # environment.etc."crypttab".text = ''
  #   cryptcruzer1 /dev/796cbd8a-b6e5-4c20-b6a5-04a471d3a64d /root/keyfile_cruzers
  #   cryptcruzer2 /dev/25d63b4d-4a03-4160-896d-b7be71e257e8 /root/keyfile_cruzers
  #   cryptcruzer3 /dev/bf241007-9646-400a-867a-7b4fa1748e6f /root/keyfile_cruzers
  # '';

  swapDevices =
    [ { device = "/dev/disk/by-uuid/1575980a-76d1-4a85-a69e-75b8fe089988"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp4s0f3u1.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlo1.useDHCP = lib.mkDefault true;

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}

# I modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.
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

  # LUKS
  boot.initrd.luks = {
    fido2Support = true;
    reusePassphrases = true;
  };

  ### Root SSD ###
  boot.initrd.luks.devices."cryptroot" = {
    device = "/dev/disk/by-uuid/63d25036-4b8f-46c3-a6c4-a82dddd8f2b8";
      # fido2.passwordLess = true; # TODO
      preLVM = true;
      allowDiscards = true;
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/A2A2-741D";
    fsType = "vfat";
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/f5ce4bf2-95f1-4d81-a086-dad583582cac";
    fsType = "ext4";
    options = [
      "noatime"
      "nodiratime"
      "discard"
    ];
  };



  ### Data SSD and Raid ###

  fileSystems."/media/ssd" = {
    device = "/dev/mapper/cryptssd";
    label = "datassd";
    fsType = "ext4";
    options = [
      "defaults"
      "noatime"
      "nodiratime"
      "discard"
      "nofail"
    ];
  };

  fileSystems."/media/raid" = {
    label = "dataraid";
    device = "/dev/mapper/cryptraid";
    fsType = "ext4";
    options = [
      "defaults"
      "nofail"
    ];
  };

  environment.etc."crypttab".text = ''
    cryptssd /dev/disk/by-uuid/57229b63-8308-4525-8223-58205a52cc83 /root/keyfile_data_ssd discard
    cryptraid /dev/disk/by-uuid/d3e68092-af98-48a1-92b0-b1610acb22b2 /root/keyfile_data_raid
    cryptcruzer1 /dev/disk/by-uuid/796cbd8a-b6e5-4c20-b6a5-04a471d3a64d /root/keyfile_cruzers nofail
    cryptcruzer2 /dev/disk/by-uuid/25d63b4d-4a03-4160-896d-b7be71e257e8 /root/keyfile_cruzers nofail
    cryptcruzer3 /dev/disk/by-uuid/bf241007-9646-400a-867a-7b4fa1748e6f /root/keyfile_cruzers nofail
  '';


  ### SWAP ###
  swapDevices = [
    {
      device = "/swapfile";
      size = 2048;
      # size = 4096;
      # size = 8192;
    }
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp38s0u1.useDHCP = lib.mkDefault true;

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}

# For OBS https://wiki.nixos.org/wiki/OBS_Studiiioo
    boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];

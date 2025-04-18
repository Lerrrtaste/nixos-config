{ config, lib, pkgs, ... }:

{
  
  # Alloy
  services.alloy = {
    enable = true;
  };
  environment.etc."alloy/config.alloy" = {
    mode = "0440";
    source = "/etc/nixos/modules/rcmonitor/alloy.conf";
  };
}

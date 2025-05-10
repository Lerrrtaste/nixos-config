{ config, lib, pkgs, ... }:

builtins.trace("- Loading Module: bluetooth.nix")

{
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


  services.blueman.enable = false;
  hardware.pulseaudio.extraConfig = ''
    load-module module-switch-on-connect
  '';

}

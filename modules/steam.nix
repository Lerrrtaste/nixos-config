{ config, lib, pkgs, ... }:

builtins.trace("- Loading Module: steam.nix")

{
  programs.steam = {
    enable = true;
  };
}

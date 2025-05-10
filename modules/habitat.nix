{ config, lib, pkgs, ... }:

builtins.trace("- Loading Module: habitat.nix")

{
  # Users
  users.mutableUsers = true;

  users.users.lerrrtaste = {
    isNormalUser = true;
    home = "/home/lerrrtaste";
    uid = 1000;
    extraGroups = [
      "wheel"
      "networkmanager"
    ]; # note dont add to docker!
    initialPassword = "changeme";
  };

  users.users.root = {
    hashedPassword = "!"; # Disable password-based login for root.
  };
}

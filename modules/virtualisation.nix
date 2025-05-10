{ config, lib, pkgs, ... }:
builtins.trace("- Loading Module: virtualisation.nix")
{
  #### Docker
  virtualisation.docker.enable = false;

  virtualisation.docker.rootless = {
   enable = false;
   setSocketVariable = true;
  }

  #### VMs
  virtualisation.libvirtd = {
    enable = false;
    onBoot = "ignore"; # or start
    onShutdown = "shutdown"; # or suspend
    qemu = {
      swtpm.enable = true;
      runAsRoot = true;
      ovmf.enable = true;
    };
  };
  programs.virt-manager.enable = false;
}

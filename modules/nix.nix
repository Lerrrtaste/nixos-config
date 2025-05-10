{ config, lib, pkgs, ... }:

builtins.trace("- Loading Module: nix.nix")

{
  # Nix
  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 90d";
  };
  nix.extraOptions = ''
    min-free = ${builtins.toString (500 * 1024 * 1024)}
    max-free = ${builtins.toString (2000 * 1024 * 1024)}

  ''; # run gc when free space is less than 500MB and keep at least 2GB free
 nixpkgs.config.allowUnfreePredicate = pkg:
   builtins.elem (lib.getName pkg) [
     "canon-cups-ufr2"
     "steam"
     "steam-original"
     "steam-runtime"
     "steam-run"
     "nvidia-x11"
     "nvidia-settings"
     "nvidia-persistenced"
     "steam-unwrapped"

     # ollama
     # "cuda_cudart"
     # "libcublas"
     # "cuda_cccl"
     # "cuda_nvcc"

  ];


}

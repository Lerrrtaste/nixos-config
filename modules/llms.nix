# LLMs
# Ollama + OpenWebUI for now

{ config, lib, pkgs, options, ... }:

builtins.trace("- Loading Module: llms.nix")

{ 

  services.ollama = {
    enable = true;
    acceleration = "cuda";
    port = 11343; # default
    home = "/var/lib/ollama"; # default
    openFirewall = false; # default
  };

  services.open-webui = {
    enable = true;
    port = 10111;
  };
}

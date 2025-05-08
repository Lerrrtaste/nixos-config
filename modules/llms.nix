# LLMs
# Ollama + OpenWebUI for now

{ config, lib, pkgs, options, ... }:

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

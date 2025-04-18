{ pkgs, ... }:
{

  # For Future evaluation
  # services.taskserver.enable = true;
  # services.taskserver.config


  ## Scrap Archive
  # services.glances ={
  #   enable = true;
  #   extraArgs = ["-C" "/etc/glances.json" "-w" ];
  #   openFirewall = true;
  # };
  # environment.etc."glances.json".source = /etc/nixos/hosts/doc/glances.json;
  # environment.etc."glances.json".mode = "0644";
  # environment.etc.glances.enable = true;
  # services.duplicati = {
  #   enable = true;
  # };
  # Enable Prime for parallel integrated igpu and gpu usage
  # hardware.nvidia.prime = {
  #   nvidiaBusId = "PCI:1:0:0";
  #   amdgpuBusId = "PCI:15:0:0";
    #amdgpuBusId = "PCI:54:0:0"; # If you have an AMD iGPU
    #

    # sync.enable = true;
   #  Sync mode
   #  Note: Sync mode is available since NixOS 19.03 and NVIDIA driver version 390.67, and is incompatible with both offload and reverse sync modes. Sync mode also requires using a desktop manager that respects the services.xserver.displayManager.setupCommands option, including LightDM, GDM and SDDM.

    # offload.enable = true;
  # };
  # LLMs
  services.ollama = {
    enable = false;
    acceleration = "cuda";
    # home = "/media/games/ollama";
  # # Optional: load models on startup
  # # loadModels = [ ... ];
  };
  services.open-webui = {
    enable = false;
    port = 10238;
  };
  # networking.interfaces = {
  #   enp
  #   name = "USB Tethering";
  #   type = "ethernet";
  #   interface-name = "enp13s0u4"; # Replace with your USB interface name
  #   ipv4.route-metric = 100; # Lower metric for higher priority
  # }
  # {
  #   name = "LAN Connection";
  #   type = "ethernet";
  #   interface-name = "enp12s0"; # Replace with your LAN interface name
  #   ipv4.route-metric = 200; # Higher metric for lower priority
  #   # OPTIONAL - diable lan gateway
  #   # TODO fallback if lan is the only available connection to route all traffic????
  #   ipv4.gateway = "none"; # Prevents the LAN connection from becoming the default route
  #   ipv4.addresses = [
  #     {
  #       address = "192.168.2.128"; # Replace with your LAN IP
  #       prefixLength = 24; # Adjust based on your subnet
  #     }
  #   ];
  #   }
  # ];
  # networking.bonds = {
  #      "bond1" = {
  #        interfaces = [ "enp13s0u2u1" "enp13s0u4" ];
  #        driverOptions = {
  #          miimon = "250";
  #          mode = "balance-rr";
  #        };
  #      };
  #    };
  # systemd.network = {
  #    netdevs = {
  #      "10-bond0" = {
  #        netdevConfig = {
  #          Kind = "bond";
  #          Name = "bond0";
  #        };
  #        bondConfig = {
  #          Mode = "802.3ad";
  #          TransmitHashPolicy = "layer3+4";
  #        };
  #      };
  #    };
  #    networks = {
  #      "10-enp12s0" = {
  #        matchConfig.Name = "enp12s0";
  #        networkConfig.Bond = "bond0";
  #      };
  #      "20-enp13s0u2u1" = {
  #        matchConfig.Name = "enp13s0u2u1";
  #        networkConfig.Bond = "bond0";
  #      };
  #      "20-enp13s0u4" = {
  #        matchConfig.Name = "enp13s0u4";
  #        networkConfig.Bond = "bond0";
  #      };
  #      "31-bond0" = {
  #        matchConfig.Name = "bond0";
  #        linkConfig = {
  #          RequiredForOnline = "carrier";
  #        };
  #        networkConfig.LinkLocalAddressing = "no";
  #      };
  #    };
  #  };

}

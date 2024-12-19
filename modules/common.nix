# █▄░█ █ ▀▄▀ █▀█ █▀
# █░▀█ █ █░█ █▄█ ▄█
#
# Common configuration for all systems

{ config, lib, pkgs, options, ... }:

let
  dwm_src = if builtins.pathExists
  ("/home/lerrrtaste/repos/github.com/lerrrtaste/custom-dwm") then
    /home/lerrrtaste/repos/github.com/lerrrtaste/custom-dwm
  else
    builtins.fetchGit
    "https://github.com/lerrrtaste/custom-dwm.git"; # to force download --option tarball-ttl 0 (default 1 hr)

in {
  imports = [
    # TODO install home-manager as module (atm add channel and
    # nix-shell '<home-manager>' -A install=(import "${builtins.fetchTarball https://github.com/rycee/home-manager/archive/release-22.05.tar.gz}/nixos")
    #
     "${
       builtins.fetchTarball # TODO pin
       "https://github.com/ryantm/agenix/archive/main.tar.gz"
     }/modules/age.nix"
    #./cruzers.nix
    ./clamav.nix
    ./wireguard.nix
  ];

  # Nix
  nix.settings.auto-optimise-store = true;
  # nix.gc = {
  #   automatic = true;
  #   dates = "weekly";
  #   # options = "--delete-older-than 32d";
  # };
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

      # for nvtop:
      "cuda-merged"
      "cuda_cuobjdump"
      "cuda_gdb"
      "cuda_nvcc"
      "cuda_nvdisasm"
      "cuda_nvprune"
      "cuda_cccl"
      "cuda_cudart"
      "cuda_cupti"
      "cuda_cuxxfilt"
      "cuda_nvml_dev"
      "cuda_nvrtc"
      "cuda_nvtx"
      "cuda_profiler_api"
    ];


  # Time zone
  time.timeZone = "Europe/Berlin";

  # Locales
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    # font = "Lat2-Terminus16";
    # keyMap = "de";  # inherited from xkbOptions
    useXkbConfig = true; # use xkbOptions in tty.
  };

  # Disk Health
  services.smartd = {
    enable = true;

    autodetect = true;
    defaults.autodetected = "-a -s (S/../.././13|L/../../5/08)";
    notifications.test = true;
    notifications.x11.enable = true;
    notifications.wall.enable = true;
  };

  # X11
  services.xserver.enable = true;
  services.xserver.autorun = false;
  services.xserver.windowManager.dwm.enable = true;
  services.xserver.displayManager.startx.enable = true;
    # services.autorandr.hooks { TODO
  #   postswitch = {
  #     "notify-send" wj w
  #   }
  # }

  # Fonts
  fonts.packages = with pkgs; [ (nerdfonts.override { fonts = [ "FiraCode" ]; }) ];

  # Suckless
  nixpkgs.overlays = [
    (self: super: {
      dwm = super.dwm.overrideAttrs (oldAttrs: rec { src = dwm_src; });
    })
    (self: super: { # TODO move to own repo
      st = super.st.overrideAttrs (oldAttrs: rec {
        patches = [
          ./patches/st/st-scrollback-0.8.5.diff
          ./patches/st/st-blinking_cursor-20211116-2f6e597.diff
          ./patches/st/st-visualbell2-basic-2020-05-13-045a0fa.diff
          ./patches/st/st-alpha-20220206-0.8.5.diff
        ];
      });
    })
    (self: super: {
      dmenu = super.dmenu.overrideAttrs (oldAttrs: rec {
        patches = [
          ./patches/dmenu/dmenu-numbers-20220512-28fb3e2.diff
          ./patches/dmenu/dmenu-highlight-20201211-fcdc159.diff
        ];
      });
    })
  ];

  # Compositor
  services.picom = {
    enable = true;
    fade = true;
    shadow = true;
    settings = {
      blur = { # FIXME doesnt work
        method = "gaussian";
        size = 10;
        deviation = 10;
      };
    };
  };

  # Notifications

  # Keyboard
  services.xserver.xkb.layout = "de";
  # services.xserver.xkbOptions = "ctrl:nocaps"; # map caps to escape.

  # CUPS
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.canon-cups-ufr2 pkgs.gutenprintBin ];
  services.printing.browsing = true;
  hardware.sane.enable = true;
  hardware.sane.extraBackends = [ pkgs.sane-airscan ];
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;
  services.avahi.openFirewall = true; # for wifi printer
  nixpkgs.config.packageOverrides = pkgs: {
    xsaneGimp = pkgs.xsane.override { gimpSupport = true; };
  };

  # Moonlander
  hardware.keyboard.zsa.enable = true;

  # Sound
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;
  services.pipewire.enable = true;



  # Users
  users.mutableUsers = true;
  users.users.lerrrtaste = {
    isNormalUser = true;
    home = "/home/lerrrtaste";
    uid = 1000;
    extraGroups = [
      "docker"
      "davfs2"
      "wheel"
      "networkmanager"
      "scanner"
      "lp"
      "libvirtd"
      "adbusers"
      "cubeuser"
    ]; # note dont add to docker!
    initialPassword = "changeme";
  };

  users.users.root = {
    hashedPassword = "!"; # Disable password-based login for root.
  };

  # Gaming
  programs.steam = {
    enable = true;
  #   remotePlay.openFirewall = true;
  };
  hardware.steam-hardware.enable = true;

  # Packages installed in system profile
  environment.systemPackages = with pkgs; [
    # General
    st
    dmenu


    # Security
    onlykey-cli
    onlykey-agent # TODO find out how to use
    yubikey-manager-qt
    yubikey-manager
    yubico-pam
    gpa
    (pkgs.callPackage "${
        builtins.fetchTarball
        "https://github.com/ryantm/agenix/archive/main.tar.gz"
      }/pkgs/agenix.nix" { })

    # Tools
    htop
    iotop
    wget
    ncdu
    git
    nethogs
    wireguard-tools
    ncpamixer # terminal pavucontrol
    vim
    nmap
    s-tui
    stress
    # wally-cli
    #
    #

    # android / Gos
    # libarchive
    #   # android-tools
    #   android-udev-rules

    # Virtualization
    # docker-compose
    # virt-manager

    # Dekstop
    pinentry-curses
    feh
    libnotify
    dunst
    # tiramisu
    # herbe
    # gsettings-desktop-schemas
    # glib


    # files
    sshfs

    # QOL
    xcape

    # Deps
    xorg.xmessage # smartd notifications
  ];

  # For nix-direnv (prevents gc, but its optional)
  # nix.extraOptions = ''
  #   keep-outputs = true
  #   keep-derivations = true
  # '';

  # Virtualisation
  virtualisation.docker.enable = false;
  virtualisation.docker.rootless = {
   enable = false;
   setSocketVariable = true;
  };
  # virtualisation.libvirtd.enable = false;
  # programs.dconf.enable = false;
  # programs.virt-manager.enable = false;


  # Security
  programs.slock.enable = true; # prevent slock from out of memory kill
  hardware.onlykey.enable = true;
  services.udev.packages = [ pkgs.yubikey-personalization ];

  # OpenSSH
  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = false;
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
    openFirewall = false;
  };
  programs.ssh.startAgent = true;

  # GPG
  programs.gnupg = {
    agent.enable = true;
    agent.pinentryPackage = pkgs.pinentry-curses;
  };

  # Firewall
  networking.firewall.enable = true;
  # networking.firewall.allowedTCPPorts = [ ];
  # networking.firewall.allowedUDPPorts = [ ];

  # Random things

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

  # Configure swap file. Sizes are in megabytes. Default swap is
  # max(1GB, sqrt(RAM)) = 1024. If you want to use hibernation with
  # this device, then it's recommended that you use
  # RAM + max(1GB, sqrt(RAM)) = 3007.000.
  # swapDevices = [ { device = "/swapfile"; size = 1024; } ];
}


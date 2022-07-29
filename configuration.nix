################################################################################
# █▄░█ █ ▀▄▀ █▀█ █▀
# █░▀█ █ █░█ █▄█ ▄█
# MrFusion Config V1
################################################################################

{ config, lib, pkgs, options, ...}:
{
  imports = [
# TODO install home-manager as module (atm add channel and nix-shell '<home-manager>' -A install=
#      (import "${builtins.fetchTarball https://github.com/rycee/home-manager/archive/release-22.05.tar.gz}/nixos")

#      /home/lerrrtaste/.config/nixpkgs/home.nix 
      ./network.nix
      ./hardware-configuration.nix
    ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "canon-cups-ufr2"
    "steam"
    "steam-original"
    "steam-runtime"
  ];

  # Power Management
  powerManagement.cpuFreqGovernor = "performance";

  # EFI boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # GRUP
#   boot.loader.grub.enable = true;
#   boot.loader.grub.version = 2;
#   boot.loader.grub.device = "nodev"
#   boot.loader.grub.efiSupport = true;
#   boot.loader.grub.enableCryptodisk = true;  # enable once bootloader is on encrypted partition (check that hardware-config detected it too)
#   boot.loader.efi.efiSysMountPoint = "/boot/efi";
 
  # LUKS
  boot.initrd.luks.fido2Support = true;
  boot.initrd.luks.devices = {
    cryptroot = {
      device = "/dev/disk/by-uuid/307aa1c2-972d-47a7-8813-dfcd0da73112"; 
      fido2.passwordLess = true;
      preLVM = true;
      allowDiscards = true;
    };
  };
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];  # better for ssds (?)

  # Time zone
  time.timeZone = "Europe/Berlin";

  # Locales
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    # font = "Lat2-Terminus16";
    # keyMap = "de";  # inherited from xkbOptions
    useXkbConfig = true; # use xkbOptions in tty.
  };

  # X11
  services.xserver.enable = true;
  services.xserver.autorun = false;
  services.xserver.windowManager.dwm.enable = true;
  # services.xserver.desktopManager.xfce.enable = true;
  services.xserver.displayManager.lightdm.enable = lib.mkForce false;  # test if this fixes dbus error (should have been false by default)
  services.xserver.displayManager.startx.enable = true;
  services.xserver.resolutions = [
    {
      x = 1920;
      y = 1080;
    }
  ];
  services.autorandr.enable = true;
  programs.light.enable = true;  # background light (light -A/-U 20)

  nixpkgs.overlays = [
    (self: super: {
      dwm = super.dwm.overrideAttrs (oldAttrs: rec {
        src = /home/lerrrtaste/repos/github.com/lerrrtaste/dwm-6.3-mrfusion;
      });
    })
    (self: super: {
      st = super.st.overrideAttrs (oldAttrs: rec {
        patches = [
          ./patches/st/st-scrollback-0.8.5.diff
          ./patches/st/st-blinking_cursor-20211116-2f6e597.diff
          #./patches/st/st-copyurl-multiline-20220221-0.8.5.diff
          ./patches/st/st-visualbell2-basic-2020-05-13-045a0fa.diff
          ./patches/st/st-alpha-20220206-0.8.5.diff
          #./patches/st/st-focus-20200731-patch_alpha.diff
          #./patches/st/st-focus-20200731-43a395a.diff
        ];
      });
    })
  ];

  # Freedesktop
  services.systembus-notify.enable = true;

  # Graphics
  services.xserver.videoDrivers = [ "amdgpu" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  hardware.opengl.driSupport = true;  # OpenGL
  hardware.opengl.extraPackages = with pkgs; [
    amdvlk  # optional in addition to mesa radv drivers
  ];
  environment.variables.AMD_VULKAN_ICD = "RADV";  # use radv
  services.picom = {
    enable = true;
    fade = true;
    shadow = true;
     settings = {
       blur = {
         method = "gaussian";
         size = 10;
         deviation = 10;
       };
     };
  };

  # Keyboard
  services.xserver.layout = "de";
  services.xserver.xkbOptions = "ctrl:nocaps";  # map caps to escape.

  # CUPS
   services.printing.enable = true;

   services.printing.drivers = [ pkgs.canon-cups-ufr2 ];
   hardware.sane.enable = true;
   hardware.sane.extraBackends = [ pkgs.sane-airscan ];
   services.avahi.enable = true;
   services.avahi.nssmdns = true;
   nixpkgs.config.packageOverrides = pkgs: {
     xsaneGimp = pkgs.xsane.override { gimpSupport = true; };
   };

  # Sound
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    settings =
    {
      General = {
        Enable="Source,Sink,Media,Socket";
      };
    };
  };
 services.blueman.enable = true;
   hardware.pulseaudio.extraConfig = "
   load-module module-switch-on-connect
   ";

  # Touchpad
  services.xserver.libinput.enable = true;

  # Users
  users.mutableUsers = true;
  users.users.lerrrtaste = {
    isNormalUser = true;
    home = "/home/lerrrtaste";
    extraGroups = [ "wheel" "networkmanager" "scanner" "lp" ];
    initialPassword = "changeme";
  };

  users.users.root = {
    hashedPassword = "!";  # Disable password-based login for root.
  };

  # Gaming
  programs.steam.enable = true;

  # Packages installed in system profile
  environment.systemPackages = with pkgs; [
    # General
    st
    dmenu
    onlykey-cli
    onlykey
    # onlykey-agent


    # Tools
    htop
    wget
    ncdu
    chezmoi
    git
    nethogs
    wireguard-tools
    # ryzenadj  # FIXME
    ncpamixer  # terminal pavucontrol


    # Dekstop
    pinentry-curses
    herbe  # notification 
    feh

    # QOL
    xcape

    # Deps
    xmenu  # for dwm layout menu patch
  ];

  virtualisation.docker.enable = true;

  programs.slock.enable = true; # prevent slock from out of memory kill
  hardware.onlykey.enable = true;


  # OpenSSH
  services.openssh = {
    enable = true;
    openFirewall = true;
    passwordAuthentication = false;
    permitRootLogin = "no";
  };
  programs.ssh.startAgent = true;

  # GPG
  programs.gnupg = {
    agent.enable = true;
    agent.pinentryFlavor = "curses";
  };

  # Firewall
  networking.firewall.enable = true;  
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  

  # Random things i dont understand

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

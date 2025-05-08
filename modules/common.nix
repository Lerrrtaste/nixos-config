# █▄░█ █ ▀▄▀ █▀█ █▀
# █░▀█ █ █░█ █▄█ ▄█
#
# Common configuration for all systems

{ config, lib, pkgs, options, ... }:
{
  imports = [
    # TODO install home-manager as module (atm add channel and
    # nix-shell '<home-manager>' -A install=(import "${builtins.fetchTarball https://github.com/rycee/home-manager/archive/release-22.05.tar.gz}/nixos")
    # <home-manager/nixos>
     "${
       builtins.fetchTarball # TODO pin
       "https://github.com/ryantm/agenix/archive/main.tar.gz"
     }/modules/age.nix"
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

  # Keyboard
  services.xserver.xkb.layout = "de";
  # services.xserver.xkbOptions = "ctrl:nocaps"; # map caps to escape.

  # CUPS
  # services.printing.enable = true;
  # services.printing.drivers = [ pkgs.canon-cups-ufr2 pkgs.gutenprintBin ];
  # services.printing.browsing = true;
  # hardware.sane.enable = true;
  # hardware.sane.extraBackends = [ pkgs.sane-airscan ];
  # services.avahi.enable = true;
  # services.avahi.nssmdns4 = true;
  # # services.avahi.openFirewall = true; # for wifi printer
  # nixpkgs.config.packageOverrides = pkgs: {
  #   xsaneGimp = pkgs.xsane.override { gimpSupport = true; };
  # };

  # Moonlander
  hardware.keyboard.zsa.enable = true;

  # Sound
  # hardware.pulseaudio.enable = true;


  users.users.root = {
    hashedPassword = "!"; # Disable password-based login for root.
  };

  # Packages installed in system profile
  environment.systemPackages = with pkgs; [
    # General
    st
    dmenu

    gpa
    (pkgs.callPackage "${
        builtins.fetchTarball
        "https://github.com/ryantm/agenix/archive/main.tar.gz"
      }/pkgs/agenix.nix" { })

    # Tools
    htop
    iotop
    glances
    wget
    iftop
    ncdu
    git
    nethogs
    wireguard-tools
    ncpamixer # terminal pavucontrol
    vim
    nmap
    s-tui
    stress
    onlykey
    onlykey-cli
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

    # files
    sshfs

    # QOL
    xcape

    # Deps
    xorg.xmessage # smartd notifications

    # yk copypasta deps
    wget

    # yubioath-flutter
    # # yubikey-manager-qt # broken
    # # yubikey-touch-detector
    # yubikey-personalization-gui
    # yubikey-manager
    # # pam_u2f
    # yubikey-personalization
    # libu2f-host
    # # yubico-pam
    # # libu2f-udev
    #  gnupg                     # Encryption key management

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

# Udev packages so that the user can see YubiKey or CCID-based token
  # services.udev.packages = [
  #   pkgs.yubikey-personalization
  # ];
# own minimal udev rule for the YubiKey that sets appropriate permissions, e.g.:
  # services.udev.extraRules = ''
  #   # Example for a YubiKey (vendor 1050)
  #   SUBSYSTEM=="usb", ATTRS{idVendor}=="1050", MODE="0660", GROUP="plugdev"
  # '';

  # Enable the PC/SC daemon
  services.pcscd.enable = true;
  # (Often you can omit specifying reader plugins unless you must.
  #  If you do specify them, do it carefully.)
  services.pcscd.plugins = [ pkgs.ccid ];
  # services.pcscd.readerConfig = "readerport Yub
  # services.pcscd.plugins =[ pkgs.acsccid ]
  # services.pcscd.plugins =  with pkgs;
  #  [ pcsclite
  #    opensc                    # Encryption
  #    openssl
  #    pcsctools
  #    libusb1
  #    ccid
  #    pcsc-cyberjack
  #    encfs
  #    cryptsetup                # Encrypted USB sticks etc
  #    pinentry                  # GPG password entry from the terminal
  #    gnupg                     # Encryption key management
  #    gnupg1orig
  #    pcmciaUtils               # PCMCIA Tools
  #    acsccid                   # SmartCard Apps
  #    glibc                     # Para o WebSigner Certsign
  #    chrome-token-signing      # Chrome and Firefox extension for signing with your eID on the web
  #  ];

  # # OpenSSH
  # services.openssh = {
  #   enable = true;
  #   settings = {
  #     X11Forwarding = false;
  #     PermitRootLogin = "no";
  #     PasswordAuthentication = false;
  #   };
  #   openFirewall = false;
  # };
  # services.pcscd.enable = true;
  # security.pam.yubico = {
  #   # enable = true;
  #   # debug = true;

  #   control = "required" ;
  #   mode = "challenge-response";
  # };

  #age.identityPaths age.identitfyPaths = [ "/home/lerrrtaste/.ssh/id_ed25519" ];
  age.identityPaths = [ "/home/lerrrtaste/.ssh/id_ed25519" ];

  # GPG
  # programs.ssh.startAgent = true; # Use GnuPG as your SSH agent This is what many YubiKey owners prefer, because it allows you to keep SSH keys on the YubiKey via GPG.
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-curses;
  };

# # services.pcscd.enable = true;
# security.pam.yubico = {
# enable = true;
# debug = true;

# control = "required" ;
# mode = "challenge-response";
# # challenge response need to write configuration to yubikey with yubikey personalization tool, installed below
# # then a "challenge* file is written to ~/.yubico with the command “ykpamcfg -2 -v”
# # id generated by : nix-shell --command ‘ykinfo -s’ -p yubikey-personalization
# id = [ "12345678" ];
# };
  # Firewall
  networking.firewall.enable = true;
  # networking.firewall.allowedTCPPorts = [ ];
  # networking.firewall.allowedUDPPorts = [ ];

  # Random things

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   pinentryPackage = pkgs.pinentry-curses;
  #   # enableSSHSupport = true;
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


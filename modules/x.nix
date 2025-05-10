{ config, lib, pkgs, ... }:

let
  dwm_src = if builtins.pathExists
  ("/home/lerrrtaste/repos/github.com/lerrrtaste/custom-dwm") then
    /home/lerrrtaste/repos/github.com/lerrrtaste/custom-dwm
  else
    builtins.fetchGit
    "https://github.com/lerrrtaste/custom-dwm.git"; # to force download --option tarball-ttl 0 (default 1 hr)

in
builtins.trace("- Loading Module: x.nix")
{


  # X11
  services.xserver.enable = true;
  services.xserver.autorun = false;
  services.xserver.windowManager.dwm.enable = true;
  services.xserver.displayManager.startx.enable = true;

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
    # fade = true;
    # shadow = true;
    # settings = {
    #   backend= "glx";
    #   # blur = { # FIXME doesnt work
    #   #   method = "gaussian";
    #   #   size = 10;
    #   #   deviation = 10;
    #   # };
    # };
  };

  # Notifications

}

{ config, lib, pkgs, ... }:

{
         users.groups.cubeuser = {};

  services.syncthing = {
    enable = true;
    user = "lerrrtaste";
    group = "cubeuser";
    dataDir = "/home/lerrrtaste/st";
    # systemService = true;
    extraFlags = [
      "--no-browser"
      # "--gui-address=unix:///run/syncthing/syncthing.socket"
      # "--home=/var/lib/syncthing"
      # "--config=/home/lerrrtaste/.config/syncthing/config.xml"
      "--no-default-folder"
      "--no-upgrade"
      # "--skipp ak-port-probing"
    ];
    # key = "c1-sync-id"; # TODO add k1 to secrets recipient for restoring from backup
    # cert = "c1-sync; # useless until then; effectively local ssh
    # settings = {
    #     options = {
    #         urAccepted = -1;
    #         relaysEnabled = false;
    #         localAnnouncePort = 20227;
    #         localAnnounceEnabled = true;

        # devices = {
        #     cubeserver1 = {
        #         id = "RPYDWR4-IZGN5KX-7OLFOAZ-3JWRZ35-HPE32IE-Y3HWNQY-MLHWROI-QKYW3AM";
        #         name = "cubeserver1";
        #         # autoAcceptFolders = true;
        #     };
        #     blackpixel = {
        #         id = "CDJW3MY-E7QJMVZ-QMUZWQZ-LW6HOIN-5BLQYJG-24MNTCG-FVPYP5C-NJTZYQA";
        #         name = "blackpixel";
        #         # autoAcceptFolders = true;
        #     };
        #     deadpixel = {
        #         id = "ZV4K7DF-PQXB6N2-CQUOWSX-RLPT4OV-ZNWB5MW-QQLFNMY-OSFFZ2L-TCC6QQJ";
        #         name = "deadpixel";
        #         # autoAcceptFolders = true;
        #     };
        #     doc = {
        #         id = "5BE6NEP-WUKFTDY-6WHABRA-6BGV4ZZ-WFNSVFR-DDTTS42-G4XVP6P-UKOGNQF";
        #         name = "doc";
        #         # autoAcceptFolders = true;
    #         };
    #         # mrfusion = {
    #         #     id = "";
    #         #     name = "mrfusion";
    #         #     autoAcceptFolders = true;
    #         # };
    #     };
    # };
      # folders = {
      #   "chome"= {
      #     id = "cubedrive-home-nxnxk-zehpf";
      #     path = "/media/cube/syncthing/chome";
      #     enable = true;
      #     copyOwnershipFromParent = false;
      #     type = "sendrecieve";
      #     versioning = {
      #       type = "trashcan";
      #       params.cleanoutDays = "7";
      #     };
      #     # devices = [
      #     #     "cubeserver1"
      #     #     "blackpixel"
      #     #     "deadpixel"
      #     #     "doc"
      #     #     # "mrfuison"
      #     # ];
       # };
  };


  # age.secrets.c1-sync-id = {
  #   file = /etc/nixos/secrets/c1-sync-id.age;
  #   name = "c1-sync-id";
  #   # path = "/etc/wireguard/p2-de-pmp.conf";
  #   mode = "600";
  # };
}

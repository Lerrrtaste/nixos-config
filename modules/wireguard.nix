{ config, lib, pkgs, ... }:

{
  networking.wg-quick.interfaces = {
    #p0-se-de = { # fallback
    #  configFile = config.age.secrets.p0-se-de-default.path;
    #  autostart = false;
    #};
    p1-ch-de = { # host specific
      configFile = config.age.secrets.p1-ch-de.path;
      autostart = true;
    };
    #p2-de-pmp = { # alt / nat-pmp enabled
    #  configFile = config.age.secrets.p2-de-pmp.path;
    #  autostart = false;
    #};
  };

  #age.secrets.p0-se-de-default = {
  #  file = /etc/nixos/secrets/p0-se-de-default.age;
  #  name = "p0-se-de-default";
  #  path = "/etc/wireguard/p0-se-de-default.conf";
  #  mode = "600";
  #};
  age.secrets.p1-ch-de = {
    file = /etc/nixos/secrets/p1-ch-de.age;
    name = "p1-ch-de";
    path = "/etc/wireguard/p1-ch-de.conf";
    mode = "600";
  };
  #age.secrets.p2-de-pmp = {
  #  file = /etc/nixos/secrets/p2-de-pmp.age;
  #  name = "p2-de-pmp";
  #  path = "/etc/wireguard/p2-de-pmp.conf";
  #  mode = "600";
  #};
}

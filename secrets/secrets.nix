let
  delorean = {
    system = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK+ctWYFPtHTADyOh+SocAAZgazwx4clQtbc7ZgSM0Cq root@delorean";
    user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINYVwHJ/gmqUMM9Kr5wiLL0t9hRtDmBXNgDuRlfaPfvT";

  };
  mrfusion = {
    user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINpdds88pyZNlu5wo6LmO+HmCpgCYmKL2OPMcEz7eydF";
  };

  users = [ delorean.user mrfusion.user ];
  systems = [ delorean.system ]; # system keys are used for decryption when building (user keys just for convenient editing)
in
{
  "wg-quick-conf.age".publicKeys = systems ++ users;
}

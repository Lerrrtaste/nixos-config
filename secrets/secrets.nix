let
  mrfusion = {
    user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIBYLFR6Wy8//3A/qlM+aGpRx4/maUeJxpMeRreAyAHm";
    system = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINpdds88pyZNlu5wo6LmO+HmCpgCYmKL2OPMcEz7eydF";
  };
  doc = {
    system = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEATs+bgG/UqESkqRpgBS83V6/7Lsk73z9/GZkmsMzHA";
    user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB+SaeOJHqoqOVNAKcvPBP1s//OwdqKnhpwBBZprHqOA";
  };

  users = [ mrfusion.user doc.user ];
  systems = [ mrfusion.system doc.system ]; # system keys are used for decryption when building (user keys just for convenient editing)
in
{
  "wg-quick-conf.age".publicKeys = systems ++ users;

 # "spf-pass.age".publicKeys = systems ++ users;
 # "spf-id.age".publicKeys = systems ++ users;
 # "spf-secret.age".publicKeys = systems ++ users;

  "cruzer-key.age".publicKeys = systems ++ users;

  "ts-auth-doc.age".publicKeys = [doc.system doc.user];

  "cb-pw.age".publicKeys = [doc.system doc.user];
  "cb-creds-doc.age".publicKeys = [doc.system doc.user];
}

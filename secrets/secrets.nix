let
  mrfusion = {
    user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII0syzkMdqXWjj7ZzpkBndMuYfFLfLNjI5zOeyaM211y";
    system = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJkrL0s3nI2g9zbkdzUCTY61wJEq4PL4UCkgRgRmuEEW";
  };
  doc = {
    user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL6b8s0A59W5rTtYGGhJwm/mLRVsEvHJgX00qkBD3YVm";
    system = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMJMlBDrsb5dLBmaMiSxhFmHomOidjNbCavLhk90ytFg";
  };

  users = [ doc.user mrfusion.user ];
  systems = [ doc.system mrfusion.system ]; # system keys are used for decryption when building (user keys just for convenient editing)
in
{
  "p1-ch-de.age".publicKeys = systems ++ users;

  # "ivpn-ch-de-filtered.age".publicKeys = systems ++ users;
  # "p0-se-de-default.age".publicKeys = systems ++ users;
  # "p1-ch-de-mrfusion.age".publicKeys = systems ++ users;
  # "p2-de-pmp.age".publicKeys = systems ++ users;

  # "cruzer-key.age".publicKeys = systems ++ users;

  # "ts-auth-doc.age".publicKeys = [doc.system doc.user];

  # "cb-pw.age".publicKeys = [doc.system doc.user ];
  # "cb-creds-doc.age".publicKeys = [ doc.system doc.user ];

  # "c1-sync-id.age".publicKeys = systems ++ users;

  # "st-doc-key.age".publicKeys = doc;
}

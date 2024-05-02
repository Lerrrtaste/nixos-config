let
  mrfusion = {
    user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIBYLFR6Wy8//3A/qlM+aGpRx4/maUeJxpMeRreAyAHm";
    system = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHuTQ/H7vBFLvZhUC2jUog9dKSNbUgZOGqCstjbbLBAp";
  };
  doc = {
    system = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBTf5la/eGaMenXcEsCMjccJ75Nh1C+K73jMC3hmG+N9";
    user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEATs+bgG/UqESkqRpgBS83V6/7Lsk73z9/GZkmsMzHA";
  };

  users = [ mrfusion.user doc.user ];
  systems = [ mrfusion.system doc.system ]; # system keys are used for decryption when building (user keys just for convenient editing)
in
{
  "wg-quick-conf.age".publicKeys = systems ++ users;
}

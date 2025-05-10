{ pkgs, ... }:

builtins.trace("- Loading Module: hardening.nix")

let
  nix-mineral = pkgs.fetchgit {
    url = "https://github.com/cynicsketch/nix-mineral.git";

    # now add one of the following:
    # a specific tag 
    ref = "refs/tags/v0.1.6-alpha"; # Modify this tag as desired. Tags can be found here: https://github.com/cynicsketch/nix-mineral/tags. You will have to manually change this to the latest tagged release when/if you want to update.


    # or a specific commit hash
    # rev = "cfaf4cf15c7e6dc7f882c471056b57ea9ea0ee61";  
    # or the HEAD
    # ref = "HEAD"; # This will always fetch from the head of main, however this does not guarantee successful configuration evaluation in future - if we change something and you rebuild purely, your evaluation will fail because the sha256 hash will have changed (so may require manually changing every time you evaluate, to get a successful evaluation).

    # After changing any of the above, you to update the hash. 

    # Now the sha256 hash of the repository. This can be found with the nix-prefetch-url command, or (the simpler method) you can place an incorrect, but valid hash here, and nix will fail to evaluate and tell you the hash it expected (which you can then change this value to).
    # NOTE: this can be omitted if you are evaluating/building impurely.
    sha256 = "003h5dffbiymgvhazb46wv7i3zblw2gsg9gy80d63y968yqqp9zp";
  };
in
{
  imports = [
    #"${nix-mineral}/nix-mineral.nix"
  ];
}

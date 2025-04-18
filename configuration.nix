let
#  hardware_name = "${builtins.readFile /sys/class/dmi/id/product_name}";  # problem was that it appends \n at the end so the comparison didnt work. (for now still using 5 char substring, it works)
#  hosts = {
#    "HP EN" = "mrfusion";
#
#    "MS-7B" = "delorean";
#
#    "MS-7D" = "doc";
#  };
#  lookup = attrs: key:
#    if attrs ? ${builtins.substring 0 5 key} then attrs."${builtins.substring 0 5 key}" else builtins.abort ("Unknown hardware: " + hardware_name);
  host = "doc"; # lookup hosts hardware_name;
  config = ./hosts/${host}/configuration.nix;
in
builtins.trace ("Detected hardware: " + host)
import config

# Secure boot instructions
# https://github.com/nix-community/lanzaboote/blob/master/docs/QUICK_START.md

_:

{
  imports = [
    ../base.nix
    ../sites/orono.nix
    ../hardware/trkm-laptop.nix
    ../roles/de/cinnamon.nix
    ../users/tm.nix
    ../users/jm.nix
  ];

  networking.hostName = "trkm-laptop";
}

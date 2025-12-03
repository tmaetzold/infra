_:

{
  imports = [
    ../base.nix
    ../sites/orono.nix
    ../hardware/trkm-laptop.nix
    ../roles/de/cinnamon.nix
    ../roles/gaming.nix
    ../users/tm.nix
    ../users/jm.nix
  ];

  networking.hostName = "trkm-laptop";
  services.printing.enable = true;
}

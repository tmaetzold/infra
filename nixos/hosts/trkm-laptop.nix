_:

{
  imports = [
    ../hardware/trkm-laptop.nix
    ../hardware/optimus.nix
    ../base.nix
    ../sites/orono.nix
    ../roles/de/cinnamon.nix
    ../roles/tailscale.nix
    ../roles/printing.nix
    ../users/tm.nix
    ../users/jm.nix
  ];

  networking.hostName = "trkm-laptop";

  hardware.nvidia.prime = {
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:86:0:0";
  };
}

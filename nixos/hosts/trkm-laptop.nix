_:

{
  imports = [
    ../base.nix
    ../sites/orono.nix
    ../hardware/trkm-laptop.nix
    ../roles/nvidia.nix
    ../roles/tailscale.nix
    ../roles/de/cinnamon.nix
    ../users/tm.nix
    ../users/jm.nix
  ];

  networking.hostName = "trkm-laptop";

  services.xserver.videoDrivers = [ "modesetting" ];

  hardware.nvidia = {
    powerManagement.enable = true;
    prime = {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:56:0:0";
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
    };
  };
}

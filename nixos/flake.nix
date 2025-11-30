{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  };

  outputs =
    { self, nixpkgs }:
    {
      nixosConfigurations = {
        trkm-laptop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./base.nix
            ./sites/orono.nix
            ./hosts/trkm-laptop.nix
            ./hardware/trkm-laptop.nix
            ./environments/desktop/cinnamon.nix
            ./users/tm.nix
          ];
        };
      };
    };
}

{ pkgs, ... }:

{
  imports = [
    ../x.nix
  ];

  networking.networkmanager.enable = true;

  programs = {
    firefox.enable = true;
  };

  environment.systemPackages = with pkgs; [
    # themes
    nordic
    papirus-nord
  ];
}

{ pkgs, ... }:

{
  imports = [
    ../x.nix
    ../sound.nix
  ];

  environment.systemPackages = with pkgs; [
    blender
    citrix_workspace
    distrobox
    ghostty
    nordic
    orca-slicer
    papirus-nord
  ];

  networking.networkmanager.enable = true;
  programs.firefox.enable = true;
}

_:

{
  imports = [
    ../x.nix
  ];

  networking.networkmanager.enable = true;
  programs.firefox.enable = true;
}

_:

{
  imports = [
    ./modules/packages.nix
    ./modules/dotfiles.nix
  ];

  home = {
    username = "tm";
    homeDirectory = "/home/tm";
    stateVersion = "25.05";
  };

  nixpkgs.config.allowUnfree = true;
}

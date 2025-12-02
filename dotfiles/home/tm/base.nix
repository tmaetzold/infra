_:

{
  home = {
    username = "tm";
    homeDirectory = "/home/tm";
    stateVersion = "25.05";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  imports = [
    ./modules/packages.nix
    ./modules/dotfiles.nix
  ];
}

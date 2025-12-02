{ ... }:

{
  home = {
    username = "tm";
    homeDirectory = "/home/tm";
    stateVersion = "25.05";
  };

  imports = [
    ../modules/packages.nix
    ../modules/dotfiles.nix
  ];
}

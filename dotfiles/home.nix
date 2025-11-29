{ config, pkgs, ... }:

{
  home.username = "tm";
  home.homeDirectory = "/home/tm";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  xdg.configFile = {
    "nvim".source = ./dotfiles/.config/nvim;
  };

  home.file = {
    ".tmux.conf".source = ./dotfiles/.tmux.conf;
    ".zshrc".source = ./dotfiles/.zshrc;
  };
}

{ config, pkgs, ... }:

{
  home.username = "tm";
  home.homeDirectory = "/home/tm";
  home.stateVersion = "24.05";

  programs.home-manager.enable = true;

  # XDG config files
  xdg.configFile = {
    "nvim".source = ./neovim/.config/nvim;
  };

  # Home files
  home.file = {
    ".tmux.conf".source = ./tmux/.tmux.conf;
    ".zshrc".source = ./zsh/.zshrc;
  };
}

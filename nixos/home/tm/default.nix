{ config, pkgs, ... }:

{
  home.username = "tm";
  home.homeDirectory = "/home/tm";
  home.stateVersion = "25.05";

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Dotfiles management - symlink raw configs
  home.file = {
    # Neovim configuration
    ".config/nvim" = {
      source = ../../../dotfiles/neovim/.config/nvim;
      recursive = true;
    };

    # Tmux configuration  
    ".tmux.conf" = {
      source = ../../../dotfiles/tmux/.tmux.conf;
    };

    # Zsh configuration
    ".zshrc" = {
      source = ../../../dotfiles/zsh/.zshrc;
    };
  };

  # Programs configuration - enable programs, let Nix install them
  programs = {
    # Enable git with basic config
    git = {
      enable = true;
      userName = "Trent Maetzold";
      userEmail = "trent@maetzold.co";
    };

    # Enable zsh
    zsh = {
      enable = true;
    };

    # Enable tmux
    tmux = {
      enable = true;
    };

    # Enable neovim
    neovim = {
      enable = true;
    };
  };
}
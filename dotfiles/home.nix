{ pkgs, impermanence, ... }:

{
  home.username = "tm";
  home.homeDirectory = "/home/tm";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  xdg.configFile = {
    "nvim" = {
      source = ./dotfiles/.config/nvim;
      recursive = true;
    };
  };

  home.file = {
    ".tmux.conf".source = ./dotfiles/.tmux.conf;
    ".zshrc".source = ./dotfiles/.zshrc;
  };

  home.packages = with pkgs; [
    claude-code
    lazygit
    neovim
    nixfmt-rfc-style
    tmux
    tree-sitter
    zsh
  ];

  programs.git = {
    enable = true;
    userName = "Trent Maetzold";
    userEmail = "trent@maetzold.co";
  };
}

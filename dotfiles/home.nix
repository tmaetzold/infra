{ pkgs, ... }:

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
  };

  home.packages = with pkgs; [
    claude-code
    lazygit
    neovim
    nixfmt-rfc-style
    pure-prompt
    tmux
    tree-sitter
  ];

  programs.git = {
    enable = true;
    userName = "Trent Maetzold";
    userEmail = "trent@maetzold.co";
  };
  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "";
    };
    initContent = ''
      # Pure Prompt
      autoload -U promptinit; promptinit
      prompt pure
      
      # Import configs outside source control
      configs=(
          $HOME/.work-profile
      )
      for config in "''${configs[@]}"; do
          [[ -f "$config" ]] && source "$config"
      done
    '';
    shellAliases = {
      vim = "nvim";
    };
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };
}

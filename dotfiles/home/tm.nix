{ pkgs, ... }:

{
  home.username = "tm";
  home.homeDirectory = "/home/tm";
  home.stateVersion = "25.05";
  home.packages = with pkgs; [
    claude-code
    lazygit
    # languages
    nodejs
    python3
    R
    rustc
    # zsh extras
    pure-prompt
    # infra depends
    ansible
    just
    stow
  ];

  home.file = {
    ".tmux.conf".source = ../tmux/.tmux.conf;
  };

  programs.git = {
    enable = true;
    userName = "Trent Maetzold";
    userEmail = "trent@maetzold.co";
  };
  programs.home-manager.enable = true;
  programs.neovim = {
    enable = true;
    extraPackages = with pkgs; [
      # LazyVim
      tree-sitter
      # language servers
      # formatters
      nixfmt-rfc-style
      ruff
      # clipboard
      wl-clipboard
      xclip
    ];
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

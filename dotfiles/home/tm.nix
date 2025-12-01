{ config, pkgs, ... }:

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
    sqlite
    # python extras
    uv
    # zsh extras
    pure-prompt
    # infra depends
    ansible
    just
    stow
  ];
  home.file = {
    ".config/nvim".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/infra/dotfiles/nvim/.config/nvim";
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-theme = "Nordic-darker-standard-buttons";
      icon-theme = "Nordic-bluish";
    };
    "org/cinnamon/theme" = {
      name = "Nordic-darker-standard-buttons";
    };
    "org/cinnamon/desktop/peripherals/touchpad" = {
      send-events = "disabled-on-external-mouse";
    };
  };

  programs.git = {
    enable = true;
    userName = "Trent Maetzold";
    userEmail = "trent@maetzold.co";
  };
  programs.home-manager.enable = true;
  programs.neovim = {
    enable = true;
    extraPackages =
      with pkgs;
      [
        # LazyVim
        fd
        fzf
        ripgrep
        tree-sitter
        # conform.nvim
        fishMinimal
        github-markdown-toc-go
        # Snacks.image
        ghostscript
        imagemagick
        mermaid-cli
        tectonic
        # language servers
        yaml-language-server
        # formatters
        nixfmt-rfc-style
        ruff
        # clipboard
        wl-clipboard
        xclip
      ]
      ++ (with pkgs.lua51Packages; [
        lua
        luarocks
      ])
      ++ (with pkgs.nodePackages; [
        markdownlint-cli2
        prettier
      ])
      ++ (with pkgs.python3Packages; [
        pip
        pynvim
      ])
      ++ (with pkgs.tree-sitter-grammars; [
        tree-sitter-norg
        tree-sitter-norg-meta
      ]);
  };
  programs.tmux = {
    enable = true;
    clock24 = true;
    extraConfig = ''
      set-option -g focus-events on
      set-option -ga terminal-features '*:RGB'
    '';
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

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}

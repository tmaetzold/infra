{ config, pkgs, ... }:

{
  home = {
    username = "tm";
    homeDirectory = "/home/tm";

    file = {
      ".config/nvim".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/infra/dotfiles/nvim/.config/nvim";
    };
    packages = with pkgs; [
      lazygit
      # languages
      nodejs
      python3
      R
      rustc
      sqlite
      # formatters
      nixfmt-rfc-style
      ruff
      # python extras
      uv
      # zsh extras
      pure-prompt
      # infra depends
      ansible
      just
      stow
      # system utilities
      git
      curl
      wget
    ];

    stateVersion = "25.05";
  };

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (config.lib.getName pkg) [
      "claude-code"
    ];

  programs = {
    git = {
      enable = true;
      userName = "Trent Maetzold";
      userEmail = "trent@maetzold.co";
    };
    home-manager = {
      enable = true;
    };
    neovim = {
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
          # linters
          statix
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
        ]);
    };
    tmux = {
      enable = true;
      clock24 = true;
      extraConfig = ''
        set-option -g focus-events on
        set-option -ga terminal-features '*:RGB'
      '';
    };
    zsh = {
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

  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };
}

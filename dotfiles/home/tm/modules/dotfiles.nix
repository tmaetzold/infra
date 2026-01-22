_:

{
  imports = [ ./neovim.nix ];

  home = {
    shellAliases = {
      gg = "lazygit";
      hq = "harlequin";
      nb = "euporie-notebook";
      vim = "nvim";
    };
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };

  programs = {
    home-manager = {
      enable = true;
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
    };
  };

  xdg.configFile = {
    "ghostty/config".text = ''
      theme = catppuccin-mocha
      font-size = 10
      clipboard-read = allow
      clipboard-write = allow
      clipboard-paste-protection = false
    '';
  };
}

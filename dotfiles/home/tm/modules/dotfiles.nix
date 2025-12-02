_:

{
  imports = [ ./neovim.nix ];

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
      shellAliases = {
        vim = "nvim";
      };
      sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
      };
    };
  };
}

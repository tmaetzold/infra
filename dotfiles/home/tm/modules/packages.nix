{ pkgs, ... }:

{
  home = {
    packages =
      with pkgs;
      [
        claude-code
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

        # rust extras
        cargo

        # zsh extras
        pure-prompt

        # infra depends
        ansible
        just
        stow

        # system utilities
        curl
        git
        gnumake
        wget
      ]
      ++ (with pkgs.python3Packages; [ euporie ]);
  };
}

{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (config.lib.getName pkg) [
      "claude-code"
    ];

  home = {
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
    ];
  };
}

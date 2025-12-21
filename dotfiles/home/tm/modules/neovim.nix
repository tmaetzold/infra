{ config, pkgs, ... }:

{
  home.file = {
    ".config/nvim".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/infra/dotfiles/nvim/.config/nvim";
  };

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
        copilot-language-server
        rust-analyzer
        yaml-language-server

        # linters
        statix

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
        nodejs
        markdownlint-cli2
        prettier
      ])
      ++ (with pkgs.python3Packages; [
        pip
        pynvim
      ]);
  };
}

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

        # Mason.nvim
        unzip

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
        nil
        rust-analyzer
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

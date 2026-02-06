{ config, pkgs, ... }:

{
  home = {
    file = {
      ".claude".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/infra/dotfiles/claude/.claude";
    };
    packages = with pkgs; [ claude-code ];
  };
}

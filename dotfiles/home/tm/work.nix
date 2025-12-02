{ config, pkgs, ... }:

{
  home = {
    file = {
      ".config/jiratui".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/infra/dotfiles/jiratui/.config/jiratui";
    };
    packages = with pkgs; [ jiratui ];
  };

  programs.git = {
    enable = true;
    userName = "Trent Maetzold";
    userEmail = "trent.maetzold@gardacp.com";
  };

  imports = [ ./base.nix ];
}

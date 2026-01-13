{
  config,
  lib,
  pkgs,
  ...
}:

{
  users.users.tm = {
    isNormalUser = true;
    description = "Trent Maetzold";
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
    ]
    ++ lib.optionals config.virtualisation.docker.enable [ "docker" ];
  };

  programs.zsh.enable = true;
}

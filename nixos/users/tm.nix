{ pkgs, ... }:

{
  users.users.tm = {
    isNormalUser = true;
    description = "Trent Maetzold";
    extraGroups = [
      "networkmanager"
      "wheel"
      "podman"
    ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;
}

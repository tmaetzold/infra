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

  environment.systemPackages = with pkgs; [
    citrix_workspace
    distrobox
    ghostty
    steam
    steam-devices-udev-rules
    steam-tui
    steamcmd
  ];

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };
}

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
  ];

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };
}

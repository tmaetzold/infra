{ pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.tm = {
    isNormalUser = true;
    description = "Trent Maetzold";
    extraGroups = [
      "networkmanager"
      "wheel"
      "podman"
    ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      oh-my-zsh
      pure-prompt
      zsh
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    distrobox
  ];

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };
}

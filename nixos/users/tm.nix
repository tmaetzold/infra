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
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  environment.systemPackages =
    with pkgs;
    [
      distrobox
    ]
    ++ lib.optionals config.services.xserver.enable (
      with pkgs;
      [
        citrix_workspace
        ghostty

        # gaming
        steam
        steam-devices-udev-rules
        steam-tui
        steamcmd

        # 3D printing and design
        orca-slicer
        blender

        # themes
        nordic
        papirus-nord
      ]
    );
}

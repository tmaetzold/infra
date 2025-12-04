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
      "podman"
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

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-theme = "Nordic-darker-standard-buttons";
      icon-theme = "Nordic-bluish";
    };
    "org/cinnamon/theme" = {
      name = "Nordic-darker-standard-buttons";
    };
    "org/cinnamon/desktop/peripherals/touchpad" = {
      send-events = "disabled-on-external-mouse";
    };
  };
}

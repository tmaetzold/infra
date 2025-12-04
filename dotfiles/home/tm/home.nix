_:

{
  imports = [
    ./base.nix
  ];

  programs.git = {
    enable = true;
    userName = "Trent Maetzold";
    userEmail = "trent@maetzold.co";
  };

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

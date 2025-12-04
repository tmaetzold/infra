_:

{
  imports = [ ./base.nix ];

  programs.git = {
    enable = true;
    userName = "Trent Maetzold";
    userEmail = "trent.maetzold@gardacp.com";
  };
}

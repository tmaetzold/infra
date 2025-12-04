_:

{
  programs.git = {
    enable = true;
    userName = "Trent Maetzold";
    userEmail = "trent.maetzold@gardacp.com";
  };

  imports = [ ./base.nix ];
}

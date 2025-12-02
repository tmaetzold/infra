{ ... }:

{
  programs.git = {
    enable = true;
    userName = "Trent Maetzold";
    userEmail = "trent@maetzold.co";
  };

  imports = [
    ../base.nix
  ];
}

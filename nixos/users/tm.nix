
{
  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.tm = {
    isNormalUser = true;
    description = "Trent Maetzold";
    extraGroups = [ "networkmanager" "wheel" ];
  };


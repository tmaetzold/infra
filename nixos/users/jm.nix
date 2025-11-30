{ pkgs, ... }:

{
  users.users.jm = {
    isNormalUser = true;
    description = "Justine Maetzold";
    extraGroups = [ "networkmanager" ];
  };

  environment.systemPackages = with pkgs; [
    citrix_workspace
  ];
}

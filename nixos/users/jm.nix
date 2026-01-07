{
  config,
  lib,
  pkgs,
  ...
}:

{
  users.users.jm = {
    isNormalUser = true;
    description = "Justine Maetzold";
    extraGroups = [ "networkmanager" ];
  };

  environment.systemPackages =
    with pkgs;
    lib.optionals config.services.xserver.enable [ citrix-workspace ];
}

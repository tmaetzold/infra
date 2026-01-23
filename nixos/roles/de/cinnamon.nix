{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./common.nix
  ];

  services.xserver = {
    displayManager.lightdm.enable = true;
    desktopManager.cinnamon.enable = true;
  };

  environment.systemPackages =
    with pkgs;
    lib.optionals config.services.printing.enable [
      system-config-printer
    ];
}

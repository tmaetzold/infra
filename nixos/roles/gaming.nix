{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    steam
    steam-devices-udev-rules
    steam-tui
    steamcmd
  ];
}

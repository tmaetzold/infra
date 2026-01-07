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
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
    ]
    ++ lib.optionals config.virtualisation.docker.enable [ "docker" ];
  };

  programs.zsh.enable = true;

  environment.systemPackages =
    with pkgs;
    lib.optionals config.virtualisation.docker.enable [ distrobox ]
    ++ lib.optionals config.services.xserver.enable (
      with pkgs;
      [
        # GUI applications
        citrix_workspace
        ghostty

        # 3D printing and design
        orca-slicer
        blender
      ]
    );
}

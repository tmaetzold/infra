{
  config,
  lib,
  pkgs,
  ...
}:

{
  hardware.graphics.enable = true;

  services.xserver.videoDrivers = lib.mkDefault [ "nvidia" ];

  hardware = {
    nvidia = {
      modesetting.enable = lib.mkDefault true;
      powerManagement = {
        enable = lib.mkDefault false;
        finegrained = lib.mkDefault false;
      };
      open = lib.mkDefault true;
      nvidiaSettings = true;
      package = lib.mkDefault config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };

  environment.systemPackages = with pkgs; [
    nvidia-system-monitor-qt
    nvtopPackages.nvidia
  ];
}

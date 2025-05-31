{ config, pkgs, ... }:

{
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true; # 可选: 禁用电源管理，如果遇到问题再启用
    # finegrained = true; # 可选: 更精细的电源管理，实验性功能
    open = true; # 使用开源驱动
    nvidiaSettings = true; # 安装 nvidia-settings 工具
    package = config.boot.kernelPackages.nvidiaPackages.latest; # 或使用最新版本: config.boot.kernelPackages.nvidiaPackages.latest
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
      libvdpau
    ];
  };

  environment.systemPackages = with pkgs; [
    cudaPackages.cudatoolkit
    clinfo
  ];

  # 其他配置 ...
  boot.blacklistedKernelModules = [ "nouveau" ];
  boot.kernelParams = [ "nvidia-drm.modeset=1" ];
}

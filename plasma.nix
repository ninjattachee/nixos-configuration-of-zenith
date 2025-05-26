{ config, pkgs, ... }:
{
  # Enable KDE Plasma
  services.desktopManager.plasma6.enable = true;
  
  # Enable SDDM
  services.displayManager.sddm = {
    enable = true;
    wayland = {
      enable = true;
    };
    theme = "sddm-astronaut-theme"; # select theme
  };

  services.displayManager.defaultSession = "plasma";

  # NVIDIA driver
  services.xserver.videoDrivers = [ "nvidia" ];
  
  hardware.graphics.enable = true;
  hardware.nvidia.modesetting.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true;

  # Chinese fonts
  fonts.packages = with pkgs; [
    noto-fonts-cjk-sans
  ];

  environment.systemPackages = with pkgs; [
    # KDE Applications
    kdePackages.dolphin
    kdePackages.okular
    kdePackages.sddm-kcm # optional. used for graphical configuration for sddm

    # Bluetooth
    kdePackages.bluez-qt
    kdePackages.purpose
    
    sddm-astronaut	 # sddm-astronaut theme
    qt6.qtmultimedia
    qt6.qtsvg
    qt6.qtvirtualkeyboard

    # Others
    libreoffice
    vlc
    zellij
  ];
}

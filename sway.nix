{ config, pkgs, ... }:
{
  # Enable Wayland and Sway
  # programs.sway.enable = true;
  services.seatd.enable = true;

  # Ensure Wayland session available
  environment.sessionVariables = {
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    XDG_SESSION_TYPE = "wayland";
  };

  # Install Daily use tools
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      swaylock	# screen lock
      swayidle	# have a rest
      waybar	# status bar
      dmenu	# a simple application starter
      foot	# a light weight wayland terminal
      grim	# screenshot
      slurp	# screenshot area draw
      swappy
      wl-clipboard
      wf-recorder
      xdg-utils	# handle relationship of desktop files
      mako	# message system
    ];
  };

  # environment.systemPackages = with pkgs; [
  # ];

  # Enable XDG portal
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-wlr ];

  # Enable Polkit
  security.polkit.enable = true;

  # Enable light control
  programs.light.enable = true;

  # Users Setting
  users.users.atank = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "seat" ];
  };
}

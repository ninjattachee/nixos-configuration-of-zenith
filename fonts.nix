{ config, pkgs, ... }:
{
  # Chinese fonts
  fonts.packages = with pkgs; [
    roboto
    source-sans-pro
    source-serif-pro
  ];

}

{ config, pkgs, ... }:
{
  #environment.systemPackages = [
    #(pkgs.buildFHSEnv {
      #name = "cursor";
      #targetPkgs = pkgs: with pkgs; [
      #  glibc
      #  gtk3
      #  zlib
      #  fuse
      #];
      #runScript = "/home/atank/Applications/AppImages/Cursor.AppImage";
    #})
  #];
}

{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    docker
  ];

  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      data-root = "/home/atank/.docker";
    };
  };
}

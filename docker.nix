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

  systemd.tmpfiles.rules = [
    "d /home/atank/.docker 0755 root root -"
  ];
}

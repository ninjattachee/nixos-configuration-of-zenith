{ config, pkgs, ... }:

{
  systemd.services.sing-box = {
    description = "Sing Box";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "simple";
      ExecStart = "/home/atank/.local/bin/sing-box run -c /etc/sing-box/config.json";
      Restart = "always";
      RestartSec = 5;

      # Network management permission
      CapabilityBoundingSet = [ "CAP_NET_ADMIN" "CAP_NET_BIND_SERVICE" ];
      AmbientCapabilities = [ "CAP_NET_ADMIN" "CAP_NET_BIND_SERVICE" ];
      User = "sing-box";
      Group = "tun";
    };
  }

  # Create User
  users.users.sing-box = {
    isSystemUser = true;
    group = "tun";
  }
}

{ config, pkgs, ... }:
{
  # Neovim
  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;

  # OpenSSH
  # Create sftpuser
  users.users.sftpuser = {
    isNormalUser = true;
    home = "/home/sftpuser";
    createHome = true;
    description = "SFTP User";
    group = "sftpusers";
    shell = "/bin/false";
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC/8O2s8c4gYSImFuhRYEUdDqL+7JNepnY/K6qiiZ503sQpx6Hu+sMo3gQB2v43ZAj6+JYY1dV9OZxsxEQT5UcdouhDadFcyBvA2kBwgsWQ3OG0zC84lM6eW4Y9c5fMVZJZtWCrgDtGL2PcEtp+KITSqqj612f/L4+wpwe24ZTxobTmSvbC6jurC/XHFj2QDA0NMdHqxtK8pO68v/YL8MtP/rIvuTvssfcMhuIwn3T5J8OU5mDABALiCQO6r0G41OKOhzYscVpszpCrWo1JHrCoS14FkrLJdHggDYNr1jmS97x/GzCDUf3mBJ4m/KN9hSJDovgOIvq2j1p8Y4lPnxapiuXYRF1JwHsjmDqZoh5jlGwaI2vRludTi1vw53Aq601ONJXv1wtctwTjSU6ntCUnA/n3S6dHrJHdkl4hcMwvvF9IHpz3PC6Ri5A/sz76WNv9e/5kZC6etmvg4jcISQAthyTQcrVaO9uqbPS/1fl/FnWJlq7LbzP62Zzi6Nba/eqlGUDNLrofnePJwMxnCBrJjNMoa7069V2whKD0WXYIop4iVyqOd91fs4fXgZdMOpwA8H+OH31+3KfKAwOmTf0OvHQFCT9QjO7QanDIR7U303B6oy9xYHh7vJWK9IXQgGzPokCHdI9uLSoSRBX/3kUJ5lgmjqHPincKaK4JgzBndw== for connecting to sftp server"
    ];
  };

  # Create sftpusers group
  users.groups.sftpusers = {};
  
  # Config SFTP directory
  fileSystems."/home/sftpuser/files" = {
    device = "none";
    fsType = "tmpfs";
    options = [ "defaults" "noexec" "nosuid" "nodev" "mode=0755" "uid=sftpuser" "gid=sftpusers" ];
  };

  # Config SFTP limit
  services.openssh.extraConfig = ''
    Match User sftpuser
      ChrootDirectory /home/sftpuser
      ForceCommand internal-sftp
      AllowTcpForwarding no
      X11Forwarding no
  '';

  # Ensure /home/sftpuser is owned by root with 755 permissions
  system.activationScripts.setHomePermissions = {
    text = ''
      chown root:root /home/sftpuser
      chmod 755 /home/sftpuser
    '';
  };

  # Login interface
  # services.greetd = {
  #   enable = true;
  #   settings = {
  #     default_session = {
  #       command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd 'sway --unsupported-gpu'";
  #       user = "greeter";
  #     };
  #   };
  # };

  # environment.etc."greetd/environments".text = ''
  #   sway
  # '';

  # systemd.services.greetd.unitConfig = {
  #   After = [ "network-online.target" ];
  # };

  # Hysteria 2
  users.users.hysteria = {
    isSystemUser = true;
    group = "hysteria";
  };
  users.groups.hysteria = { };

  systemd.services.hysteria = {
    enable = true;
    description = "Hysteria Proxy Service";
    after = [ "network-online.target" ];
    requires = [ "network-online.target" ];
    serviceConfig = {
      ExecStart = "/usr/local/bin/hysteria -c /etc/hysteria/config.yaml";
      Restart = "always";
      User = "hysteria";
      Group = "hysteria";
      DynamicUser = false;
    };
    wantedBy = [ "multi-user.target" ];
  };


  # Ollama-cuda
  # add ollama group
  users.groups.ollama = {};

  # def ollama user and group
  users.users.ollama = {
    isSystemUser = true;
    group = "ollama";
    home = "/mnt/data/ollama";
    description = "Ollama service user";
    shell = "/bin/false";
  };

  # def systemd service
  systemd.services.ollama = {
    description = "Ollama CUDA Service";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    
    serviceConfig = {
      ExecStart = "${pkgs.ollama-cuda}/bin/ollama serve";
      Restart = "always";
      User = "ollama";
      Group = "ollama";
      WorkingDirectory = "/mnt/data/ollama/models";
      Environment = [
        "OLLAMA_MODELS=/mnt/data/ollama/models"
        "CUDA_VISIBLE_DEVICES=0" # set cuda devices as needed.
	"OLLAMA_HOST=0.0.0.0:11434"
      ];
    };

    # Create ollama user and group if it's not exist
    preStart = ''
      chown -R ollama:ollama /mnt/data/ollama
      chmod -R 750 /mnt/data/ollama
    '';
  };

  # Postgresql
  services.postgresql = {
    enable = true;
    enableTCPIP = true;
    authentication = pkgs.lib.mkOverride 10 ''
      local all all trust
      host all all 0.0.0.0/0 scram-sha-256
    '';
    initialScript = pkgs.writeText "init.sql" ''
      CREATE USER testuser WITH PASSWORD 'mypassword';
      CREATE DATABASE testdatabase OWNER testuser;
    '';
  };
}

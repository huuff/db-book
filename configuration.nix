{ pkgs, ... }:
let
  largeDataset = ./large-dataset.sql;
  smallDataset = ./small-dataset.sql; 
in {
  boot.isContainer = true;

  networking.useDHCP = false;
  networking.firewall.allowedTCPPorts = [ 5432 ];

  environment.systemPackages = [ pkgs.telnet ];

  services.postgresql = {
    enable = true;
    enableTCPIP = true;

    authentication = pkgs.lib.mkOverride 10 ''
      local all all trust
      host all all 0.0.0.0/0 trust
    '';

    ensureDatabases = [ "exercises" ];

    settings= {
      listen_addresses = "*";
    };
  };

  systemd = {
    extraConfig = ''
      DefaultTimeoutStopSec=1000s
    '';

    services.liquibase = {
      enable = true;
      description = "Load all data into DB";
      path = [ pkgs.liquibase ];

      serviceConfig = {
        Type = "simple";
        RemainAfterExit = true;
        WorkingDirectory = ./.;
      };

      unitConfig = {
        After = [ "postgresql.service" ];
        BindsTo = [ "postgresql.service" ];
      };

      wantedBy = [ "multi-user.target" ];

      script = ''
        liquibase --url=jdbc:postgresql://localhost/exercises update
      '';
    };
  };
}

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

    ensureDatabases = [ 
      "db_book" # TODO Should be university (obviously also correct the systemd unit)
      "insurance"
      "bank"
    ];

    settings= {
      listen_addresses = "*";
    };
  };

  systemd = {
    extraConfig = ''
      DefaultTimeoutStopSec=1000s
    '';

    services.load-db = {
      enable = true;
      description = "Load all data into DB";
      path = [ pkgs.postgresql_13 ];

      serviceConfig = {
        Type = "simple";
        RemainAfterExit = true;
      };

      unitConfig = {
        After = [ "postgresql.service" ];
        BindsTo = [ "postgresql.service" ];
      };

      wantedBy = [ "multi-user.target" ];

      script = ''
        psql -U postgres -d 'db_book' -f ${./DDL.sql}
        psql -U postgres -d 'db_book' -f ${largeDataset}
      '';
    };
  };
}

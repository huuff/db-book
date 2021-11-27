{ pkgs, ... }:
{
  boot.isContainer = true;

  networking.useDHCP = false;

  services.postgresql = {
    enable = true;

    authentication = pkgs.lib.mkOverride 10 ''
      local all all trust
      host all all ::1/128 trust
    '';

    initialScript = pkgs.writeText "initialScript" ''
      CREATE DATABASE db_book;
    '';
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
        Type = "oneshot";
        RemainAfterExit = true;
      };

      unitConfig = {
        After = [ "postgresql.service" ];
        BindsTo = [ "postgresql.service" ];
      };

      wantedBy = [ "multi-user.target" ];

      script = ''
        psql -U postgres -d 'db_book' -f ${./DDL.sql}
        psql -U postgres -d 'db_book' -f ${./data.sql}
      '';
    };
  };
}

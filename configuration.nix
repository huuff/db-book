{ pkgs, ... }:
{
  boot.isContainer = true;

  networking.useDHCP = false;

  services.postgresql = {
    enable = true;
  };
}

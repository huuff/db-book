{ config, pkgs, ... }:

{
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "yes";
}

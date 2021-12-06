{
  description = "Exercises of the book Database System Concepts (7th edition)";

  inputs = {
    emanote.url = "github:srid/emanote/master";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, emanote, ... }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
    emanotePkg = emanote.defaultPackage.${system};
  in
  {

    nixosConfigurations.container = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules =  [ ./configuration.nix ];
    };

    defaultApp.${system} = {
      type = "app";
      program = "${emanotePkg}/bin/emanote";
    };
  };
}

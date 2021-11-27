#!/usr/bin/env bash
sudo nixos-container destroy db-book
sudo nixos-container create db-book --flake .
sudo nixos-container start db-book
sudo nixos-container root-login db-book

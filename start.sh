#!/usr/bin/env bash
echo "Destroying previous container..."
sudo nixos-container destroy db-book

echo "Creating a new container..."
sudo nixos-container create db-book --flake .

echo "Starting the container..."
sudo nixos-container start db-book

echo "Logging into it as root..."
sudo nixos-container root-login db-book
